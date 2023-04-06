@IsTest public class TEST_OBJ_TV_TareasEjecutivo {

    @isTest static void go()
    {
        Test.startTest();
        Id tid;
    	OBJ_TV_TareasEjecutivo p = new OBJ_TV_TareasEjecutivo('12345678-0', tId, 11);
        OBJ_TV_TareasEjecutivo r = new OBJ_TV_TareasEjecutivo('12345678-0', tId, 12);
        r.compareTo(p);
        Test.stopTest();
    }
    
    
     
}