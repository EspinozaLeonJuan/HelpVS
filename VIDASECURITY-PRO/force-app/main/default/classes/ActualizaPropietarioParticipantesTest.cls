@isTest
public class ActualizaPropietarioParticipantesTest {
	static {
		TriggerHandler.enable(ActualizaPropietarioParticipantes.class);
    }
	
    static TestMethod void test(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        Test.startTest();
        
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas PV';
        insert campaign;
        
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
         
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas PV'].Id;
        
        User u1 = new User();
        u1.LastName = 'Aaaa';
        u1.FirstName='Aaa';
        u1.Alias = 'Aaaaa';
        u1.Email = 'aaa.aaa@vidatest12.com';
        u1.Username = 'aaa.aaa@vidatest12.com';
        u1.ProfileId = profileId.id;
        u1.TimeZoneSidKey = 'GMT';
        u1.LanguageLocaleKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LocaleSidKey = 'en_US';
        u1.RUT_Usuario__c = '12321';
                           
        User u2 = new User();
        u2.LastName = 'Bbbb';
        u2.FirstName='Bbb';
        u2.Alias = 'Bbbbb';
        u2.Email = 'bbb.bbb@vidatest12.com';
        u2.Username = 'bbb.bbb@vidatest12.com';
        u2.ProfileId = profileId.id;
        u2.TimeZoneSidKey = 'GMT';
        u2.LanguageLocaleKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LocaleSidKey = 'en_US';
        u2.RUT_Usuario__c = '32123';
        
        List<User> users = new List<User>();
        users.add(u1);
        users.add(u2);
        insert users;
        
        Account a1 = new Account();
        a1.FirstName = 'Cccc';
        a1.LastName = 'Cccc';
        a1.Rut__c = '15315161';
        a1.Rut__pc = '15315161';
        a1.Rut_contacto__pc = '15315161';
        a1.DV__c = 'K';
        a1.DV_contacto__pc = 'K';
        a1.OwnerId = u1.Id;
        
        insert a1;
        
        Date myDate = Date.today().addMonths(-4);
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = a1.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'M';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  0.864000;
        poliza.Valor_Poliza__c = 0;
        
        insert poliza;
              
        Participantes_de_Campa_a__c par1 = new Participantes_de_Campa_a__c();
        par1.Name = 'Poliza test 1';
		par1.Campa_a_Vida_Security__c = idCampana;
		par1.Contacto__c = a1.PersonContactId;
		par1.Estado_Cierre__c= 'Abierto';
		par1.Nombre_de_Contacto__c = a1.Name;
		par1.Poliza__c = poliza.Id;
		par1.OwnerId = a1.OwnerId;
		par1.Cuenta__c = a1.Id;
		par1.RecordTypeId = recordId;
		par1.Prioridad_en_Campa_a__c = '1';
        
        Participantes_de_Campa_a__c par2 = new Participantes_de_Campa_a__c();
        par2.Name = 'Poliza test 2';
		par2.Campa_a_Vida_Security__c = idCampana;
		par2.Contacto__c = a1.PersonContactId;
		par2.Estado_Cierre__c= 'Abierto';
		par2.Nombre_de_Contacto__c = a1.Name;
		par2.Poliza__c = poliza.Id;
		par2.OwnerId = a1.OwnerId;
		par2.Cuenta__c = a1.Id;
		par2.RecordTypeId = recordId;
		par2.Prioridad_en_Campa_a__c = '1';
        
        List<Participantes_de_Campa_a__c> pars = new List<Participantes_de_Campa_a__c>();
        pars.add(par1);
        pars.add(par2);
        insert pars;
        
        a1.OwnerId = u2.Id;
        update a1;
        
        List<Participantes_de_Campa_a__c> participantes = [SELECT Id, OwnerId FROM Participantes_de_Campa_a__c WHERE Cuenta__r.Id =: a1.Id]; 
        for(Participantes_de_Campa_a__c p : participantes){
			System.assertEquals(p.OwnerId, u2.Id);
        }
        
        Test.stopTest();
    }
}