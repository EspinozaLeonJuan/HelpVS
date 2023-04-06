@IsTest public class TEST_OBJ_WS_ConsultaPersona {

    @isTest static void go()
    {
        Test.startTest();
    	OBJ_WS_ConsultaPersona p = new OBJ_WS_ConsultaPersona();
        p.Apellido_Materno = 'Leon';
        p.Apellido_Paterno = 'Espinoza';
        p.Nombres = 'Juan';
        p.RUT = '12345678-0';
        Test.stopTest();
    }
}