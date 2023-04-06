/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 06-08-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   06-08-2021   Juan Espinoza León   Initial Version
**/
@IsTest
public class SEC_CTRL_AceptaCommunication_TEST {   
    
    @isTest(SeeAllData=true) 
    static void getData(){
        SEC_CTRL_AceptaCommunication controller = setController();
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AceptaCalloutMock());
        controller.doPDF();
        Test.stopTest();        
    }
 
    private static SEC_CTRL_AceptaCommunication setController(){
        Corredor__c corredor = new Corredor__c();
        corredor.Name = 'XXX';
        corredor.RUT__c = '16408297';
        corredor.DV__C = '0';
        Insert corredor; 
        
        Account cuenta = new Account();
        cuenta.name = 'XXX';
        cuenta.RUT__c = '15045517';
        cuenta.DV__C = '0';
        Insert cuenta;    
        
        Blob b = Crypto.GenerateAESKey(128);
      	String h = EncodingUtil.ConvertTohex(b);
      	String uid = h.SubString(0,8);        
        Profile p = [SELECT Id FROM Profile LIMIT 1];

		User propietario = new User();
        propietario.Email = uid +'@xxx.com';
        propietario.RUT_Usuario__c = '92343788-0';
        propietario.Username = uid +'@xxx.com';
        propietario.LastName = 'XXX';
        propietario.Alias = uid;
        propietario.LocaleSidKey = 'en_US ';
        propietario.TimeZoneSidKey = 'America/Los_Angeles';
        propietario.EmailEncodingKey = 'UTF-8';
        propietario.ProfileId = p.Id;
        propietario.LanguageLocaleKey = 'en_US';
        Insert propietario;
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.CorredorPropuesta__c = corredor.Id;
        oportunidad.AccountId = cuenta.Id;
        oportunidad.Name = 'COVID TEST'; 
        oportunidad.OwnerId = propietario.Id;
        oportunidad.StageName = 'Ingresar Negocio'; 
        oportunidad.CloseDate = System.today();
        Insert oportunidad;
        
        Corredor__c empresacorre = new Corredor__c();
        empresacorre.Name = 'XXX';
        empresacorre.RUT__c = '18022109';
        empresacorre.DV__c = '3';
        Insert empresacorre;         

        Contact contacto1 = new Contact();
        contacto1.Email = 'xxxs@xxxs.com';
        contacto1.Rut__c = '11134111-1';
        contacto1.LastName = 'xxxas';
        contacto1.Empresa_Corredora__c  = empresacorre.Id;
        insert contacto1;
        
        Corredores_Venta__c contcorredor = new Corredores_Venta__c();
        contcorredor.Contacto__c = contacto1.Id;
        contcorredor.Corredor__c = empresacorre.Id;
        contcorredor.Id_Oportunidad__c = oportunidad.Id;
        insert contcorredor;       

        Contact contacto2 = new Contact();
        contacto2.Email = 'xx2s@xxxs.com';
        contacto2.Rut__c = '11234111-1';
        contacto2.LastName = 'x2xas';
        contacto2.Empresa_Corredora__c  = empresacorre.Id;
        insert contacto2;  
        
        Corredores_Venta__c corcorredor = new Corredores_Venta__c();
        corcorredor.Contacto__c = contacto2.Id;
        corcorredor.Corredor__c = empresacorre.Id;  
        corcorredor.Id_Oportunidad__c = oportunidad.Id;        
        insert corcorredor;
        
        Contact contacto = new Contact();
        contacto.Email = 'xxx@xxx.com';
        contacto.Rut__c = '11111111-1';
        contacto.LastName = 'xxx';
        insert contacto;
        
        Contacto_Cuenta__c representante = new Contacto_Cuenta__c(); 
        representante.Oportunidad__c = oportunidad.Id;
        representante.Representante_Legal__c = true;
        representante.Contacto__c = contacto.Id;
        insert representante;
        
        Quote presupuesto = new Quote();
        presupuesto.Name = 'XXX';
        presupuesto.OpportunityId = oportunidad.Id;
        Insert presupuesto;
       
        ApexPages.StandardController sc = new ApexPages.StandardController(presupuesto);
        SEC_CTRL_AceptaCommunication controller = new SEC_CTRL_AceptaCommunication(sc);

        
        
        return controller;
    } 
}