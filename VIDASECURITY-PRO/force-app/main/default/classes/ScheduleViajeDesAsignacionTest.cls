@isTest
private class ScheduleViajeDesAsignacionTest {
    static testMethod void ScheduleViajeDesAsignacionTest(){
        Set<Id> ids_pol = new Set<Id>();
        Integer option = 1;
        Test.startTest();
        Date date_next_2 =  Date.Today();
        Date date_next_4 =  Date.newInstance(2022, Date.Today().Month() - 1 , 01);
        Account acc_viaje_1 = new Account(name= 'acc1',ownerId='005i0000000ij3TAAQ');
        insert acc_viaje_1;
        Poliza__c poli_viaje_1 = new Poliza__c(Cuenta__c=acc_viaje_1.Id,Estatus__c = 'ACTIVA',IsViajeComunicacion__c = true,RecordTypeId ='012i0000001IVdVAAW',Nombre_de_Producto__c = 'PROYEXXIÓN' );
        insert poli_viaje_1;
        Poliza__c poliza_1 = new Poliza__c(id=poli_viaje_1.Id,IsViajeComunicacion__c = false );
        update poliza_1;
        ids_pol.add(poli_viaje_1.id);
        if ( !ids_pol.isEmpty() ) { ScheduleViajeDesAsignacion.execute( poliza_1, ids_pol ); }
       Test.stopTest();
    }
}