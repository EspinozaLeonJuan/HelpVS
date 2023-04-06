@isTest
private class ScheduleBatchOpportunityTest {
    static testMethod void ScheduleBatchOpportunityTest(){
        Test.startTest();
        Date date_batch =  Date.Today().addDays(7);
        Account acc_batch = new Account(name= 'acc_batch',ownerId='005i0000000ij3TAAQ');
        insert acc_batch;
        Opportunity opp = new Opportunity(name='opp_batch', cuenta__c=acc_batch.Id,StageName='Ingresar Negocio',Sub_estado_oportunidad__c='En proceso',RecordTypeId ='0126S000001UbVLQA0',Tipo_Cotizaci_n__c = 'Renta Gold (Provada)',CloseDate=date_batch);
    	insert opp;
        Opportunity opp2 = new Opportunity(name='opp_batch_2', cuenta__c=acc_batch.Id,StageName='Ingresar Negocio',Sub_estado_oportunidad__c='En proceso',RecordTypeId ='0126S000001UbVLQA0',Tipo_Cotizaci_n__c = 'Renta Gold (Provada)',CloseDate=date_batch);
    	insert opp2;
        
        ScheduleBatchOpportunity m = new ScheduleBatchOpportunity();
		String jobID = system.schedule( 'ScheduleBatchOpportunity Test ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );
		
        //BatchOpportunityDaysToClose.start();
        Test.stopTest();
    }
}