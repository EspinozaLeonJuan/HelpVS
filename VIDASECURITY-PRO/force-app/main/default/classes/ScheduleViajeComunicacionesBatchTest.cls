@isTest
private class ScheduleViajeComunicacionesBatchTest {
    static testMethod void ScheduleViajeComunicacionesBatchTest(){
    	Date myDate = Date.newInstance(2022, 4, 1);
        Test.startTest();
        Account acc_batch_viaje_2 = new Account(name= 'acc_viaje_1',ownerId='005i0000000ij3TAAQ');
        insert acc_batch_viaje_2;
        Poliza__c pol_viaje_2 = new Poliza__c(Cuenta__c=acc_batch_viaje_2.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = false,
                                              Option_Viaje_Comunicaciones__c = null,
                                              Date_Next_Notification_Comunicacion__c = null,
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate );
        insert pol_viaje_2;
        
        ScheduleViajeComunicacionesUpdate m = new ScheduleViajeComunicacionesUpdate();
		String jobID = system.schedule( 'ScheduleViajeComunicacionesUpdate Test ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );
		
        //ScheduleViajeComunicacionesBatch.start();
        Test.stopTest();
    }
}