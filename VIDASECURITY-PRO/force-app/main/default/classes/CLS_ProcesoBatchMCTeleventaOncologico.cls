/*******************************************************************************************
 *  NOMBRE                 : CLS_ProcesoBatchMCTeleventaOncologico
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - APEX JOB procesar MC TVenta Oncológico
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
global class CLS_ProcesoBatchMCTeleventaOncologico implements Database.Batchable<sObject> {

    public String IDCampana;
    global String qr_LMCampana;
    
    global CLS_ProcesoBatchMCTeleventaOncologico(String IDCampana){
        this.IDCampana = IDCampana;
        qr_LMCampana = 'Select Id, CampaignId, RecordTypeId, MCAPM_Carga_Primer_Nombre__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, ' +
                       'MCAMP_Tipo_Folio__c, MCAMP_Tasa_Riesgo__c, MCAMP_Tarifa_UF__c, MCAMP_Tarifa_CLP__c, MCAMP_Script_Televenta__c, ' +
                       'MCAMP_Revision__c, MCAMP_Ramo__c, MCAMP_Prima_Neta_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_IVA_UF__c, ' +
                       'MCAMP_Prima_IVA_CLP__c, MCAMP_Plan__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Fecha_Fin_Campana__c, ' +
                       'MCAMP_Es_cliente__c, MCAMP_Es_Asegurable__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Ejecutivo_Televenta__c, ' +
                       'MCAMP_Codigo_Producto__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Dv__c, ' +
                       'MCAMP_Carga_Poliza_Mandatoria__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Email_1__c, ' +
                       'MCAMP_Carga_Apellido_Paterno__c, MCAMP_Carga_Apellido_Materno__c, MCAMP_Campana_Activa__c, MCAMP_Abierto_Email_N1_Producto_Onco__c ' +
                       'from CampaignMember where CampaignId = \'' + String.escapeSingleQuotes(IDCampana) + '\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext trabajo){        
        if(Test.isRunningTest()){
            /*
            qr_LMCampana += ' and (CreatedById = \'' + String.escapeSingleQuotes(CreadorSND) + '\' or CreatedById = \'' + String.escapeSingleQuotes(CreadorPRO) + '\')';
            system.debug('@@@@@ QUERY TEST => ' + qr_LMCampana);
            */            
        }else{
            system.debug('@@@@ QUERY REAL => ' + qr_LMCampana);
        }
        return Database.getQueryLocator(qr_LMCampana);
    }
    
    global void execute(Database.BatchableContext trabajo,List<sObject> MCprocesar){
        try{        
            for (sObject sobjMC : MCprocesar){
                
                CampaignMember mc = (CampaignMember)sobjMC;
                
                mc.MCAMP_Campana_Activa__c = true;          
                
                update mc;

				/*
                a.PersonEmail = 'demovsprodoncologico@gmail.com';
                a.Email_Comercial__c = 'consultor@norvid.cl';
                
                update a;
                */
            }
        }catch(Exception ex){
            system.debug('@@@@@ ERROR - CLS_ProcesoBatchCTATeleventaOncologico - EXECUTE JOB => ' + ex);
            system.debug('@@@@@ ============================================================= ' + ex);
            system.debug('@@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()); 
            system.debug('@@@@@ ============================================================= ' + ex);            
        }
    }
    
    global void finish(Database.BatchableContext trabajo){
        system.debug('@@@@@ Ha finalizado trabajo gestor de consumos...');
    }        
    
}