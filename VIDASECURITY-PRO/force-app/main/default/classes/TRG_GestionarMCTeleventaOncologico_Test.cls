/*******************************************************************************************
 *  NOMBRE                 : TRG_GestionarMCTeleventaOncologico_Test
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 17/07/2018 - J.ESPINOZA	        - Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class TRG_GestionarMCTeleventaOncologico_Test {

     static testMethod void GestionarMCTeleventaOncologico(){

         Profile perfil = [select id,name from profile where name = 'Administrador del sistema'];
         User usuario = [select id from user where ProfileId =: perfil.Id and IsActive = true limit 1];
         system.runAs(usuario) {

            try{
                Test.startTest();

                Account cta = new Account();
                String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
                //cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE RecordTypeId =: rtype LIMIT 1];
                cta.FirstName = 'Hèctor';
                cta.LastName = 'Norambuena';
                cta.PersonEmail = 'hector@prueba.cl';
                cta.PersonMobilePhone = '976523476';
                cta.PersonHomePhone = '2234534534';
                cta.RecordTypeId = rtype;
                cta.Rut__c = '10072931';
                cta.DV__c = '8';
                insert cta;

                Campaign cam = new Campaign();
                cam.Name = 'CAMPAÑA ONCO TEST';
                cam.Status = 'En curso';
                cam.IsActive = true;
                cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
                cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
                cam.StartDate = Date.today();
                cam.EndDate = Date.today() + 5;
                cam.Type = 'Televenta - Oncológico';
                cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
                cam.CAMPA_Script_Televenta__c = 'Hola!!';
                cam.CAMP_Producto__c = '19';

                Insert cam;

                CampaignMember mc = new CampaignMember();
                mc.CampaignId = cam.Id;
                mc.MCAMP_Carga_RUT__c = '10072931';
                mc.MCAMP_Carga_Dv__c = '8';
                mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
                mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
                mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
                mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
                mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
                mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
                mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
                mc.MCAMP_Tipo_Producto__c = '19';

                Insert mc;



                string RecordTypeIdTarea = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
                if(RecordTypeIdTarea==null)
                {
                   RecordTypeIdTarea ='';
                }

                Task tarea = new Task();
                tarea.Status='Abierta';
                tarea.TASK_Producto_Oferta__c = '19';
                tarea.RecordTypeId=RecordTypeIdTarea;
                tarea.TASK_Campana__c = cam.Id;
                tarea.TASK_ID_Campana__c = cam.Id;
                tarea.TASK_Campana_Activa__c = true;
                tarea.TASK_ID_Miembro_Campana__c = mc.Id;
                tarea.ActivityDate = cam.EndDate;

                mc = [SELECT Id, LeadId, ContactId FROM CampaignMember WHERE Id =: mc.Id];
                if(mc.LeadId != null) {
                    tarea.WhoId = mc.LeadId;
                }else{
                    tarea.WhoId = mc.ContactId;
                    tarea.WhatId = cta.Id;
                }
                insert tarea;

                system.debug('@@@@@ TRG_GestionarMCTeleventaOncologico - Update tarea => ' + tarea);
                tarea.Description = 'Hola!';
                tarea.TASK_No_quiere_ser_contactado_Televenta__c = true;
                update tarea;

                system.debug('@@@@@ TRG_GestionarMCTeleventaOncologico - Delete tarea => ' + tarea);
                delete tarea;

                Test.stopTest();
            }
            catch(Exception ex){
                system.debug('@@@@@ ERROR - TEST METHOD GestionarMCTeleventaOncologico => ' + ex);
                system.debug('@@@@@ ============================================================= ' + ex);
                system.debug('@@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                system.debug('@@@@@ ============================================================= ' + ex);
                Test.stopTest();
            }

         }

     }
}