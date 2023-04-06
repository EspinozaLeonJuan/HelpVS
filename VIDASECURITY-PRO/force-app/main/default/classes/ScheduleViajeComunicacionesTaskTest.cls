@isTest
private class ScheduleViajeComunicacionesTaskTest {
    static testMethod void ScheduleViajeComunicacionesTaskTest(){
        Date date_next_4 =  Date.newInstance(Date.Today().Year(), Date.Today().Month() - 3 , 01);
    	Date myDate = Date.newInstance(2022, 4, 1);
        Test.startTest();
        Account acc_task_viaje = new Account(name= 'acc_task_viaje',ownerId='005i0000000ij3TAAQ');
        insert acc_task_viaje;
        Poliza__c pol_task_viaje = new Poliza__c(Cuenta__c=acc_task_viaje.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                                 isViajeTaskCreated__c = false,
                                              Option_Viaje_Comunicaciones__c = 10,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate,
                                              Fecha_Ultimo_Pago__c = date_next_4 );
        insert pol_task_viaje;
        
        Account acc_task_viaje_2 = new Account(name= 'acc_task_viaje_2',ownerId='005i0000000ij3TAAQ');
        insert acc_task_viaje_2;
        
        Poliza__c pol_task_viaje_2 = new Poliza__c(Cuenta__c=acc_task_viaje_2.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                                   isViajeTaskCreated__c = true,
                                                   AlgunaVezAlDia__c = false,
                                              Option_Viaje_Comunicaciones__c = 10,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate,
                                              Fecha_Ultimo_Pago__c = Date.Today() );
        insert pol_task_viaje_2;
        
        Account acc_task_viaje_3 = new Account(name= 'acc_task_viaje_3',ownerId='005i0000000ij3TAAQ');
        insert acc_task_viaje_3;
        
        Poliza__c pol_task_viaje_3 = new Poliza__c(Cuenta__c=acc_task_viaje_3.Id,
                                              Estatus__c ='ACTIVA',
                                              IsViajeComunicacion__c = true,
                                                   isViajeTaskCreated__c = true,
                                                   AlgunaVezAlDia__c = true,
                                              Option_Viaje_Comunicaciones__c = 10,
                                              Date_Next_Notification_Comunicacion__c = Date.Today(),
                                              RecordTypeId ='012i0000001IVdVAAW',
                                              Nombre_de_Producto__c = 'PROYEXXIÓN',
                                              Fecha_Inicio_de_Poliza__c = myDate,
                                              Fecha_Ultimo_Pago__c = date_next_4 );
        insert pol_task_viaje_3;
        
        
        ScheduleViajeComunicacionesTask m = new ScheduleViajeComunicacionesTask();
		String jobID = system.schedule( 'ScheduleViajeComunicacionesTask Test ' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );

        Test.stopTest();
    }
}