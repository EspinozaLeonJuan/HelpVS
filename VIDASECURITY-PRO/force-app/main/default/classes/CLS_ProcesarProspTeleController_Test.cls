/*******************************************************************************************
 *  NOMBRE                 : CLS_ProcesarProspTeleController_Test
 *  TIPO                   : APEX CLASS TEST
 *  REQUERIMIENTO          : PROYECTO TELEVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 17/12/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@isTest(SeeAllData=true)
private class CLS_ProcesarProspTeleController_Test {

    static testMethod void escenarioCorrerJOBClientesNuevosTeleventa_A(){
        
        try{
            
            Test.startTest();

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
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';

            Insert mc;
            
            Pagereference p1 = new Pagereference(Page.SEC_VF_ProcesarProspectosTeleventa.getUrl() + '?id=' + cam.Id);       
            Test.setCurrentPage(p1);          
            ApexPages.StandardController sccamp = new ApexPages.StandardController(cam);
            CLS_ProcesarProspTeleController Sc = new CLS_ProcesarProspTeleController(sccamp);
            Sc.volverCampana();
            

            Test.stopTest();

        }catch(Exception ex){

            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
            
        }        
        
    }
    
}