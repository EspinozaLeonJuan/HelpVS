@istest(seeAllData=true)
public class TEST_BAT_TV_GestionMiembroCampagna {
//@isTest(seealldata=true)
    static testmethod void test() {        
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
    
        BAT_TV_GestionMiembroCampagna j_MConco = new BAT_TV_GestionMiembroCampagna(mc.Id);     
        Id IdJobs = Database.executeBatch(j_MConco, 1); 
        Test.stopTest();
    }
}