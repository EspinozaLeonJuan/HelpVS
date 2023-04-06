@IsTest
private class ACSELQueueableTest {
	
	static testMethod void test() {
	    AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().corporativa().save();
	    Id cuentaId = (Id)cuenta.get().get('Id');
	    Set<Id> cuentasId = new Set<Id>{cuentaId};
	    ACSELQueueable cola = new ACSELQueueable(cuentasId);
	    System.enqueueJob(cola);
  	}

}