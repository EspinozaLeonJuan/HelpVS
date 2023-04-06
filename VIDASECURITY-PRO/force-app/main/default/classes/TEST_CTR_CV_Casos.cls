/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_CV_Casos                                                               |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_CV_Casos                                                                    |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/22   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@isTest
public class TEST_CTR_CV_Casos {

    @isTest static void FirstPage_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.FirstPage();
        Test.stopTest();
    }
    
    @isTest static void previous_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.Page = 10;
        controlador.previous();
        Test.stopTest();
    }
    
    @isTest static void next_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.Page = 10;
        controlador.next();
        Test.stopTest();
    }
    
    @isTest static void LastPage_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.Page = 10;
        controlador.totalRecs = 100;
        //OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        controlador.LastPage();
        Test.stopTest();
    }
    
    @isTest static void getprev_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.getprev();
        Test.stopTest();
    }
    
    @isTest static void getnxt_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.getnxt();
        Test.stopTest();
    }
    
    @isTest static void queryCasos_Test_01()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryCasos('LIMIT 100');
        Test.stopTest();
    }
    
    @isTest static void queryCasos_Test_02()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryCasos('');
        Test.stopTest();
    }
    
    
    @isTest static void queryMisCasos_Test_01()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryMisCasos('LIMIT 100');
        Test.stopTest();
    }
    
    @isTest static void queryMisCasos_Test_02()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryMisCasos('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosCount_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryCasosCount();
        Test.stopTest();
    }
    
    @isTest static void queryMisCasosCount_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryMisCasosCount();
        Test.stopTest();
    }
    
    @isTest static void IniciarBandeja_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.IniciarBandeja();
        Test.stopTest();
    }
    
    @isTest static void IniciarMiBandeja_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.IniciarMiBandeja();
        Test.stopTest();
    }
    
    
    @isTest static void getListarEstados_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.getListarEstados();
        Test.stopTest();
    }
    
    @isTest static void getListarTipos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.getListarTipos();
        Test.stopTest();
    }
    
    @isTest static void busquedaCasos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.FechaInicio = Date.today().addDays(-30);
        controlador.FechaTermino = Date.today();
        controlador.busquedaCasos();
        Test.stopTest();
    }
    
    @isTest static void limpiaBusquedaCasos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.limpiaBusquedaCasos();
        Test.stopTest();
    }
    
    @isTest static void getCasos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.FechaInicio = Date.today().addDays(-30);
        controlador.FechaTermino = Date.today();controlador.getCasos();        
        Test.stopTest();
    }
    
    @isTest static void getMisCasos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.FechaInicio = Date.today().addDays(-30);
        controlador.FechaTermino = Date.today();controlador.getMisCasos();        
        Test.stopTest();
    }
    
    @isTest static void ListadoCasos_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.ListadoCasos();
        Test.stopTest();
    }
    
    @isTest static void verCaso_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.verCaso();
        Test.stopTest();
    }
    
    @isTest static void IniciarDerivacionMultiple_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        
        Case caso1 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso1;
        Case caso2 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso2;
        Case caso3 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso3;
        Case caso4 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso4;
        
        String Ids = caso1.Id+'@'+caso2.Id+'@'+caso3.Id+'@'+caso4.Id+'@';
        ApexPages.currentPage().getParameters().put('Ids', Ids);
        controlador.IniciarDerivacionMultiple();
        Test.stopTest();
    }
    
    @isTest static void IniciarDerivacionMultiple_Test_02()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        
        String Ids = '@';
        ApexPages.currentPage().getParameters().put('Ids', Ids);
        controlador.IniciarDerivacionMultiple();
        Test.stopTest();
    }
    
    @isTest static void queryCasosDerivacion_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.queryCasosDerivacion();
        Test.stopTest();
    }
    
    @isTest static void getCasosDerivacion_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.getCasosDerivacion();
        Test.stopTest();
    }
    
    @isTest static void DerivarCasos_Test()
    {
        Test.startTest();
        
        Account cuenta = Factory.crearAccountSF();  
        
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        
        Case caso1 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso1;
        Case caso2 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso2;
        Case caso3 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso3;
        Case caso4 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso4;
        controlador.CasosUPD = new List<Case>();
        controlador.CasosUPD.add(caso1);
        controlador.CasosUPD.add(caso2);
        controlador.CasosUPD.add(caso3);
        controlador.CasosUPD.add(caso4);
        
        
        controlador.DerivarCasos();
        Test.stopTest();
    }

  	@isTest static void CambioEstado_EscritorioDigital_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.CambioEstado_EscritorioDigital(79);
        Test.stopTest();
    }    
    
    @isTest static void NuevoCaso_Test()
    {
        Test.startTest();
        CTR_CV_Casos controlador = new CTR_CV_Casos();
        controlador.NuevoCaso();
        Test.stopTest();
    }      
    
        
        
}