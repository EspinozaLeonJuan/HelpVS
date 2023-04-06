@isTest
private class RegularizaPolizaProyexxionScheduleTest {
    static testMethod void RegularizaPolizaProyexxionScheduleTest(){
        Test.startTest();
        Account acc_batch_viaje_1 = new Account(name= 'acc_viaje_1',ownerId='005i0000000ij3TAAQ');
        insert acc_batch_viaje_1;
        Poliza__c pol_viaje_1 = new Poliza__c(Cuenta__c=acc_batch_viaje_1.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Nombre_de_Producto__c = 'PROYEXXIÓN2' );
        insert pol_viaje_1;
        Poliza__c poliza_1 = new Poliza__c(id=pol_viaje_1.Id, Nombre_de_Producto__c = 'PROYEXXIÓN' );
        update poliza_1;
        
        RegularizaPolizaProyexxionSchedule m = new RegularizaPolizaProyexxionSchedule();
		String jobID = system.schedule( 'RegularizaPolizaProyexxionSchedule Test ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );
		
        //RegularizaPolizaProyexxionSchedule.start();
        Test.stopTest();
    }
}