/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-13-2021
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_CTR_CS_EscritorioDigital {
    @IsTest
    public static void cargaCaso_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'RUT_CLIENTE_NO_CORRESPONDE');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_02()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'RUT_CLIENTE_SIN_BENEFICIARIOS');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_03()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'POLIZA_NO_INGRESADA');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_04()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'POLIZA_OBSOLETA');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_05()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'CLIENTE_SIN_POLIZAS_ACTIVAS');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_06()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'POLIZA_NO_CORRESPONDE');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_07()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'CREA_REQUERIMIENTO_EXCEPCION');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

	@IsTest
    public static void cargaCasoError_Test_08()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_09()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error','PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_10()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_11()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_12()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_ERROR_USUARIO_INVALIDO');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_13()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_EXCEPCION');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_14()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_15()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'REQUERIMIENTO_NO_APV');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_16()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'REQUERIMIENTO_MAX_3');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_17()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'REQUERIMIENTO_MI_SEGURO');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_18()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'REQUERIMIENTO_NO_SOPORTADO');
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void cargaCasoError_Test_19()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('Error', 'REQUERIMIENTO_CERO');

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso_Error();
        Test.stopTest();
    }

    @IsTest
    public static void getListaSolicitantes_Test_01()
    {
        Test.startTest();      
        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.getListaSolicitantes();
        Test.stopTest();
    }
    
    @IsTest
    public static void crearRequerimiento_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso();
        controlador.crearRequerimiento();
        Test.stopTest();
    }
    
    @IsTest
    public static void verRequerimiento_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso();
        controlador.verRequerimiento();
        Test.stopTest();
    }
    
    @IsTest
    public static void eliminarRequerimiento_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso();
        controlador.eliminarRequerimiento();
        Test.stopTest();
    }

    @IsTest
    public static void ToCase_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);

        CTR_CS_EscritorioDigital controlador = new CTR_CS_EscritorioDigital();
        controlador.CargaCaso();
        controlador.ToCase();
        Test.stopTest();
    }


    
}