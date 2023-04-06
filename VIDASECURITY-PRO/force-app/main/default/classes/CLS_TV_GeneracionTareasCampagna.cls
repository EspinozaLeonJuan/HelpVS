/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-17-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_TV_GeneracionTareasCampagna {



    public List<OBJ_TV_TareasEjecutivo> ejecutivosCmp { get; set;}

    public String  recordTypeOnco {get; set;}

    public String  scriptCampagna {get; set;}

    public CLS_TV_GeneracionTareasCampagna() {

    }

    public CLS_TV_GeneracionTareasCampagna(String idCampagna) {

        this.recordTypeOnco =  Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();

        this.ejecutivosCmp = new List<OBJ_TV_TareasEjecutivo>();

        Campaign cmp = [SELECT Id, CAMPA_Ejecutivo_Televenta__c, CAMPA_Script_Televenta__c, IsActive FROM Campaign WHERE Id =: idCampagna];

        string Ejecutivos = cmp.CAMPA_Ejecutivo_Televenta__c;

        this.scriptCampagna = cmp.CAMPA_Script_Televenta__c;

        List<String> ejecs = Ejecutivos.split(';');

        System.debug('@@@@ ejecs '+ ejecs);
        for (String re : ejecs) {
            List<User> usuarios = [SELECT Id FROM User WHERE RUT_Usuario__c =: re];
            OBJ_TV_TareasEjecutivo eje = new OBJ_TV_TareasEjecutivo(re, usuarios[0].Id, 0);
            ejecutivosCmp.add(eje);
        }
    }

    public Task generaTarea(CampaignMember cm)
    {
        try{

            for (OBJ_TV_TareasEjecutivo eje : this.ejecutivosCmp) {
                List<Task> tareas = [SELECT Id FROM Task WHERE TASK_ID_Campana__c =: cm.CampaignId AND OwnerId =: eje.Id];
                eje.NumeroTareas = tareas.size();
            }

            this.ejecutivosCmp.sort();

            system.debug('@@@@ generarTareaCampanaTeleventaOncologico - CM (1)  => ' + cm);

            if(cm != null)
            {
                Task t = new Task();

                t.RecordTypeId = this.recordTypeOnco; // Asigna tipo registro Tarea Televenta Oncológico

				t.ActivityDate = cm.MCAMP_Fecha_Fin_Campana__c;
                t.Description = cm.MCAMP_Script_Televenta__c;
                t.TASK_ID_Miembro_Campana__c = cm.Id;
                t.TASK_ID_Campana__c = cm.CampaignId;
                t.TASK_Campana__c = cm.CampaignId;
                t.Status = 'Abierta';
                t.TASK_Producto_Oferta__c = cm.MCAMP_Tipo_Producto__c;
				t.Description = this.scriptCampagna;
                if (ejecutivosCmp.size()>0)
                {
                	t.TASK_RUT_Ejecutivo_Televenta__c = ejecutivosCmp[0].Rut;
                    t.OwnerId = ejecutivosCmp[0].Id;
                    t.Last_Assigned_Owner__c = t.OwnerId;
                }
                else
                {
                    t.TASK_RUT_Ejecutivo_Televenta__c ='';
                }

                t.TASK_Campana_Activa__c = cm.MCAMP_Campana_Activa__c;

                if(cm.ContactId == null){ // Asigna cuenta o contacto cliente
                    t.WhoId = cm.LeadId;
                }
                if(cm.LeadId == null){ // Asigna prospecto (Lead)
                    t.WhoId = cm.ContactId;
                    t.WhatId = [SELECT Id, AccountId FROM Contact WHERE Id =: cm.ContactId].AccountId;
                }
                //Creación Tarea de Llamada Televenta Oncológico...

                system.debug('@@@@ INSERTA TAREA =>' + t);

                insert t;

                system.debug('@@@@ TAREA INSERTADA =>' + t);

                return t;
            }
            else
            {
                return null;
            }
        }catch(Exception ex){
            system.debug('@@@@ ERROR - CLS_GeneracionTareasCampanaTeleventa - Método generarTareaCampanaTeleventaOncologico:');
            system.debug('@@@@ =============================================================================================');
            system.debug('@@@@ ' + ex.getMessage() + '; ' + ex.getLineNumber());
            system.debug('@@@@ =============================================================================================');
            return null;
        }
    }
}