@istest
public class TEST_CLS_CM_CorreoMasivoSaludProtegida {

    public static String CRON_EXP = '0 0 0 24 6 ? 2022';
    
      @IsTest  static void execute_text()
    {      
        Test.startTest();    
        
        String RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();
        system.debug('@@@@ RecordTypeId 1 '+ RecordTypeId);
        Lead lead = new Lead(); 
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '0';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'A';
        lead.LastName = 'B';	
        lead.RecordTypeId = RecordTypeId;
        lead.Email = 'juanespinozaleon@ibm.com';
        lead.Sub_Estado__c = '';
        lead.SP_Correo_Masivo__c = false;
        insert lead;
        
         system.debug('@@@@ lead 1 '+ lead);
 
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new CLS_CM_CorreoMasivoSaludProtegida()); 
        test.stopTest();
    }
}