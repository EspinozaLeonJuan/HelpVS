/*******************************************************************************************
 *  NOMBRE                 : CLS_OncologicoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - G.Pinto          - Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_GeneracionTareasCampanaTeleventaTest {
 static testMethod void productosActualesContratante(){
        
        try{                                   
           Test.startTest();
           CLS_GeneracionTareasCampanaTeleventa cls=new CLS_GeneracionTareasCampanaTeleventa();
           CampaignMember cm = new CampaignMember();
           
            cm=[select LeadId,
                       ContactId,
                       MCAMP_Fecha_Fin_Campana__c,
                       MCAMP_Script_Televenta__c,
                       Id,
                       CampaignId
                from
                	CampaignMember
                limit 1];
            
           cls.generarTareaCampanaTeleventaOncologico(cm);
           
           Test.stopTest();
        }
     catch(Exception e)
     {
         
     }
     
     /*
 Campaign campana = new Campaign();
            campana.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            campana.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospectos Campañas - Ventas Oncológico'].Id;
            campana.Name = 'Campañana Oncologico Test';
            campana.Status = 'En Curso';
            campana.IsActive = true;
            campana.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
            campana.Type = 'Televenta - Oncológico';
            campana.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            campana.Description = 'Test';
            campana.CAMPA_Script_Televenta__c = 'Test';
            campana.StartDate = Date.today();
            campana.EndDate = Date.today() + 1;
            
            
           CampaignMember cmCliente = new CampaignMember();
            
                    //CampaignMember cmCliente = new CampaignMember();
            
        cmCliente.CampaignId = campana.Id;
        cmCliente.MCAMP_Carga_RUT__c = '15154056';
        cmCliente.MCAMP_Carga_Dv__c = '2';
        cmCliente.MCAMP_Carga_Tel_fono_1__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_2__c = '+56224565556';
        cmCliente.MCAMP_Carga_Poliza_Mandatoria__c = '';
        cmCliente.MCAMP_Carga_Email_1__c = 'consultor@norvid.cl';
        cmCliente.MCAMP_Carga_Email_2__c = '';
            
*/
 }
}