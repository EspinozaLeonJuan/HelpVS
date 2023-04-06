@isTest
private class CasoHibernacionTest {

	static {
		Id recordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
		Account cuenta =  new Account(RecordTypeId=recordType, Rut__c='76316883', DV__c='2', Name='Cuenta');
		insert cuenta;

		Case caso = new Case(RUT_Solicitante__c='33547799-5',AccountId = cuenta.Id, Status= 'Hibernado', Fecha_termino_hibernacion__c = Date.today());
		insert caso;
	}

	@isTest static void casoHibernacion() {
		Test.startTest();
			CasoHibernacionSchedulable trabajoProgramado = new CasoHibernacionSchedulable();
			trabajoProgramado.execute(null);
		Test.stopTest();

		List<Case> casoDetenidoHibernacion = [Select Id, Status, Fecha_termino_hibernacion__c
		                                      from Case
		                                      Where Status = 'En Proceso'];

		System.assertEquals(1, casoDetenidoHibernacion.size());

	}

}