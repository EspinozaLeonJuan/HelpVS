@isTest
private class ConcatenaNombreProductoTest {
	
	static {
		TriggerHandler.enable(ConcatenaNombreProductoHandler.class);
			}
	
    static testMethod void myUnitTest() {       
    	ControlTest.ConcatenaNombreProducto = true;
    	ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        Campana_Vida_Security__c cmp = new Campana_Vida_Security__c();
        cmp.Name = 'Test Campaign';
        insert cmp;
        Poliza_de_Participante_de_Campana__c ppc = new Poliza_de_Participante_de_Campana__c();
        Participantes_de_Campa_a__c pc = new Participantes_de_Campa_a__c();
        pc.Nombres_del_Cliente__c = account.Name;         
        
        Contact contacto = Factory.buildContact(account);
        insert contacto;
        pc.Campa_a_Vida_Security__c = null;
        pc.P_liza_1_Recuperacion__c = poliza.Name;
        pc.Contacto__c = contacto.Id;
        pc.Campa_a_Vida_Security__c = cmp.Id;
        insert pc;
        
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today();
        insert poliza;
        ppc.Participante_de_Campana__c = pc.id;
        ppc.Poliza__c = poliza.Id;
        ppc.Codigo__c = 'TestPPC';
        Test.startTest();
       // 
        insert ppc;
        ppc.Name = 'Test!!!';
        update ppc;
        delete ppc;
        undelete ppc;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
        ControlTest.ConcatenaNombreProducto = false;
    }
}