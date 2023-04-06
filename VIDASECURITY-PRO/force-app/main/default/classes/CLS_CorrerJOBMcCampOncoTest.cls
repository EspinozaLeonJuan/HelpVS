/*******************************************************************************************
 *  NOMBRE                 : CLS_CorrerJOBMcCampOncoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 13/07/2018 - G.Pinto          - Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_CorrerJOBMcCampOncoTest {
    
    
      static testMethod void procesarMCCampOnco(){
        
        try{
            
            Test.startTest();
            
            List<Campaign> lCampana = new List<Campaign>();
            
            Campaign c = new Campaign();
            c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Campana_Televenta_Oncologico'].Id;
            c.Name = 'Campaña TVTA JOB BATCH 1';
            c.Status = 'En Curso';
            c.IsActive = true;
            c.StartDate = Date.today();
            c.EndDate = Date.today() + 10;
            c.CAMPA_Script_Televenta__c = 'Prueba Script Campaña...';
            c.CAMPA_Ejecutivo_Televenta__c = '9869387-4';
            insert c;

            CampaignMember mc = new CampaignMember();
            mc.CampaignId = c.Id;
            mc.MCAMP_Carga_RUT__c = '14093476';
            mc.MCAMP_Carga_Dv__c = '3';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Manuel';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Soto';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            
            insert mc;            
          
            /*
            c.IsActive = true;
			c.Status = 'En Curso';
			*/

            lCampana.add(c);
            CLS_CorrerJOBMcCampOnco.procesarMCCampOnco(lCampana);
        
         }catch(Exception ex){
             
            system.debug('@@@@ ERROR METODO TEST CAMPAÑA ACTIVA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
             
        }
      }
        
    

}