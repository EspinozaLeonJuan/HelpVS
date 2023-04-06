/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_Bandeja       		                                                |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_Bandeja           		                                                |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/25   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@istest(seeAllData=true)
public class TEST_CTR_UR_Bandeja {
    
    @isTest static void BandejaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.BandejaCasosUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.BandejaTareasUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.BandejaColaboracionesUR();
        Test.stopTest();
    }

    @isTest static void IniciarBandeja_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.IniciarBandeja();
        Test.stopTest();

    }
    
     @isTest static void RefrescaDatosDashboard_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.RefrescaDatosDashboard();
        Test.stopTest();
    }


     @isTest static void getPieDataCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataCasosUR = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.getPieDataCasos();
        Test.stopTest();
    }

     @isTest static void getPieDataTareas_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataTareasUR = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.getPieDataTareas();
        Test.stopTest();
    }    
     @isTest static void getPieDataColaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataColaboraciones = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.getPieDataColaboraciones();
        Test.stopTest();
    }
    
    @isTest static void ErrorAcceso_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataColaboraciones = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.ErrorAcceso();
        Test.stopTest();
    }
    
    @isTest static void seleccionResponsableUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataColaboraciones = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.seleccionResponsableUR();
        Test.stopTest();
    }
    
    @isTest static void getListarUsuarios_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja controlador = new CTR_UR_Bandeja();
        controlador.dataColaboraciones = new List<CTR_UR_Bandeja.PieWedgeData>();
        controlador.getListarUsuarios();
        Test.stopTest();
    }
    
    
}