@isTest
private class CopiaAgenteACasoTest {

	static {
    	TriggerHandler.enable(CopiaAgenteACasoHandler.class);
	}

	@isTest static void asignaAgente() {
		Group colaAsistenciaAgente = [select Id from Group where  Type = 'Queue' AND NAME = 'Asistencia Agente' LIMIT 1];
		Id recordTypeIdAtencion = ReflectionUtils.getRecordTypeId(Schema.Case.sObjectType, 'Atención de Reclamos y Solicitudes');
		Id recordTypeIdAgente = ReflectionUtils.getRecordTypeId(Schema.Contact.sObjectType, 'Agente');

		AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().corporativa().save();
		ContactFabricate supervisor = (ContactFabricate)Fabricate.contacto().supervisor().setCuenta(cuenta).set('Email', 'a@b.com').save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().setCuenta(cuenta).asignarSupervisor(supervisor).set('Email', 'b@b.com').save();
		CaseFabricate caso = (CaseFabricate)Fabricate.caso().setCuenta(cuenta).email2Case('Winder', 'b@b.com').set('Via_contacto__c', 'Mail').set('Origin', 'Asistencia Agente');
		Test.startTest();
		caso.save();
		Test.stopTest();

		Id agenteId = (Id)agente.get().get('Id');
		Id supervisorId = (Id)supervisor.get().get('Id');

		Id casoId = (Id)caso.get().get('Id');

		Case casoResultado = [Select Id, OwnerId, SuppliedEmail, Agente__c From Case Where Id = :casoId];
		System.assertNotEquals(null, casoResultado.Agente__c);
		System.assertEquals(agenteId, casoResultado.Agente__c, 'agente:'+ agenteId + ' sup:' +supervisorId);
		System.assertEquals(colaAsistenciaAgente.Id, casoResultado.OwnerId);

	}

	@isTest static void NOAsignaAgente() {
		Group colaAsistenciaAgente = [select Id from Group where  Type = 'Queue' AND NAME = 'Asistencia Agente' LIMIT 1];
		Id recordTypeIdAtencion = ReflectionUtils.getRecordTypeId(Schema.Case.sObjectType, 'Atención de Reclamos y Solicitudes');
		Id recordTypeIdAgente = ReflectionUtils.getRecordTypeId(Schema.Contact.sObjectType, 'Agente');

		AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().corporativa().save();
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().agente().setCuenta(cuenta).set('Email', 'a@b.com').save();
		CaseFabricate caso = (CaseFabricate)Fabricate.caso().setCuenta(cuenta).email2Case('Winder', '').set('Via_contacto__c', 'Mail');
		Test.startTest();
		caso.save();
		Test.stopTest();

		Id agenteId = (Id)contacto.get().get('Id');
		Id casoId = (Id)caso.get().get('Id');

		Case casoResultado = [Select Id, OwnerId, SuppliedEmail, Agente__c From Case Where Id = :casoId];
		System.assertEquals(null, casoResultado.Agente__c);
		System.assertEquals(colaAsistenciaAgente.Id, casoResultado.OwnerId);

	}


}