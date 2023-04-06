/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_BandejaColaboraciones                                              |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_BandejaColaboraciones                                                   |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/24   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@isTest
public class TEST_CTR_UR_BandejaColaboraciones {
	  @isTest static void FirstPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.FirstPage();
        Test.stopTest();
    }
    
    @isTest static void previous_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.Page = 10;
        controlador.previous();
        Test.stopTest();
    }
    
    @isTest static void next_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.Page = 10;
        controlador.next();
        Test.stopTest();
    }
    
    @isTest static void LastPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.Page = 10;
        controlador.totalRecs = 100;
        //OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        controlador.LastPage();
        Test.stopTest();
    }
    
    @isTest static void getprev_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.getprev();
        Test.stopTest();
    }
    
    @isTest static void getnxt_Test()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.getnxt();
        Test.stopTest();
    }
    
    @isTest static void getListarUsuarios_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();
        controlador.getListarUsuarios();
        Test.stopTest();
    }
    
     @isTest static void getListarEstados_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();              
        controlador.CurrentPage = 'COLABORACIONES_UR';
        controlador.getListarEstados(); 
    }
    
      @isTest static void getListarEstados_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones();                      
        controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getListarEstados(); 
    }
    
     @isTest static void seleccionResponsableUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        controlador.CurrentPage = 'COLABORACIONES_UR';
        controlador.seleccionResponsableUR(); 
    }
    
    @isTest static void seleccionResponsableUR_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.seleccionResponsableUR(); 
    }
    
    @isTest static void IniciarBandejaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.IniciarBandejaColaboracionesUR(); 
    }
    
    @isTest static void getColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getColaboracionesUR(); 
    }
    
    @isTest static void BandejaUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaUR(); 
    }
    
     @isTest static void BandejaColaboracionesUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaColaboracionesUR_Historico(); 
    }
    
     @isTest static void BandejaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaColaboracionesUR(); 
    }
  
     @isTest static void busquedaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.busquedaColaboracionesUR(); 
    }
    
     @isTest static void limpiabusquedaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.limpiabusquedaColaboracionesUR(); 
    }
    
      @isTest static void verColaboracion_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.verColaboracion(); 
    }
 
     @isTest static void IniciarBandejaColaboracionesUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.IniciarBandejaColaboracionesUR_Historico(); 
    }
 
      @isTest static void queryColaboracionesHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.queryColaboracionesHistorico(); 
    }
    
     @isTest static void getColaboracionesURHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getColaboracionesURHistorico(); 
    }
    
       
    
      @isTest static void getColaboracionesHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getColaboracionesHistorico(); 
    }
 
    @isTest static void busquedaColaboracionesHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.busquedaColaboracionesHistorico(); 
    }
    
        @isTest static void limpiabusquedaColaboracionesHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaColaboraciones controlador = new CTR_UR_BandejaColaboraciones(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.limpiabusquedaColaboracionesHistorico(); 
    }
    	
}