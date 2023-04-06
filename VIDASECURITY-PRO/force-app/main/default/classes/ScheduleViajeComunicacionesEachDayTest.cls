@isTest
private class ScheduleViajeComunicacionesEachDayTest {
    static testMethod void ScheduleViajeComunicacionesEachDayTest(){
    	Date myDate = Date.newInstance(2022, 4, 1);
        Test.startTest();
        Account acc_batch_viaje_3 = new Account(name= 'acc_viaje_3',ownerId='005i0000000ij3TAAQ');
        insert acc_batch_viaje_3;
        Account acc_batch_viaje_4 = new Account(name= 'acc_viaje_4',ownerId='005i0000000ij3TAAQ');
        insert acc_batch_viaje_4;
        Account acc_batch_viaje_5 = new Account(name= 'acc_viaje_5',ownerId='005i0000000ij3TAAQ');
        insert acc_batch_viaje_5;
        Poliza__c pol_viaje_3 = new Poliza__c(Cuenta__c=acc_batch_viaje_3.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                              Option_Viaje_Comunicaciones__c = 10,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate );
        insert pol_viaje_3;
        Poliza__c pol_viaje_4 = new Poliza__c(Cuenta__c=acc_batch_viaje_4.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                              Option_Viaje_Comunicaciones__c = 10,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate );
        insert pol_viaje_4;
        Poliza__c pol_viaje_5 = new Poliza__c(Cuenta__c=acc_batch_viaje_5.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                              Option_Viaje_Comunicaciones__c = 3,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate );
        insert pol_viaje_5;
        
        Set<Id> ids = new Set<Id>();
    	Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();
        ids.add(acc_batch_viaje_3.Id);
        ids.add(acc_batch_viaje_4.Id);
        map_ids.put(10, ids);
        
        ScheduleViajeComunicacionesEachDay m = new ScheduleViajeComunicacionesEachDay();
		String jobID = system.schedule( 'ScheduleViajeComunicacionesEachDay Test ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );
		ScheduleViajeComunicaciones updateJob = new ScheduleViajeComunicaciones( 10 , map_ids );
        ScheduleViajeComunicaciones updateJob2 = new ScheduleViajeComunicaciones( 11 , map_ids );
        AdministrarViajeComunicaciones.execute( ids, 3, map_ids );
        AdministrarViajeComunicaciones.execute( ids, 4, map_ids );
        //ScheduleViajeComunicacionesEachDay.start();
        Test.stopTest();
    }
}