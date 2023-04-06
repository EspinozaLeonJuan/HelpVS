/*******************************************************************************************
 *  NOMBRE                 : CLS_GestionarTareasMCOncologico_TEST
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 21/11/2018 - H.NORAMBUENA		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seealldata=true)
private class CLS_GestionarTareasMCOncologico_TEST {
	
    static testMethod void escenarioCambiaEstadosTarea(){
        
        try{
            
            test.startTest();

            Campaign cam = new Campaign();
            cam.Name = 'CAMPAÑA ONCO TEST';
            cam.Status = 'En curso';
            cam.IsActive = true;
            cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
            cam.RecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Televenta Oncológico').getRecordTypeId();
            cam.StartDate = Date.today();
            cam.EndDate = Date.today() + 5;
            cam.Type = 'Televenta - Oncológico';
            cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            cam.CAMPA_Script_Televenta__c = 'Hola!!';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_WS_Equifax_Consumido__c = true;
            mc.MCAMP_WS_Producto_Oncol_gico_Consumido__c = true;
            
            Insert mc;  
            
            Task tareaOnco = new Task();
            tareaOnco.RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
            tareaOnco.Subject = 'Realizar Llamada';
            tareaOnco.TASK_Campana__c = cam.Id;
            tareaOnco.TASK_Campana_Activa__c = true;
            tareaOnco.TASK_ID_Campana__c = cam.Id;
            tareaOnco.TASK_ID_Miembro_Campana__c = mc.Id;
            tareaOnco.Status = 'Abierta';
            tareaOnco.ActivityDate = cam.EndDate;
            tareaOnco.WhatId = cam.Id;
            tareaOnco.TASK_No_quiere_ser_contactado_Televenta__c = true;
            
            Insert tareaOnco;
            
            mc.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = tareaOnco.Id;
            
            Update mc;
            
            tareaOnco.status = 'En Curso';
            
            Update tareaOnco;
            
            tareaOnco.status = 'Completada';
            tareaOnco.TASK_Sub_Estado__c = 'Contratada';
            
            Update tareaOnco;
            
            tareaOnco.Status = 'Diferida';
            
            Update tareaOnco;
            
            test.stopTest();
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ EXCEPCION TEST TRIGGER GESTIONA TAREAS ONCO => Mensaje: ' + ex.getMessage() + ', Línea: ' + ex.getLineNumber());
        
        }
     
    } 
    
}