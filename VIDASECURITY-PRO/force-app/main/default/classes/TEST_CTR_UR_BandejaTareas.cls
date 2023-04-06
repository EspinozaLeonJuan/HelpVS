/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_BandejaTareas                                              			|
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_BandejaTareas   														|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/24   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@istest(seeAllData=true)
public class TEST_CTR_UR_BandejaTareas {
  @isTest static void FirstPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.FirstPage();
        Test.stopTest();
    }
    
    @isTest static void previous_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.Page = 10;
        controlador.previous();
        Test.stopTest();
    }
    
    @isTest static void next_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.Page = 10;
        controlador.next();
        Test.stopTest();
    }
    
    @isTest static void LastPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.Page = 10;
        controlador.totalRecs = 100;
        //OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        controlador.LastPage();
        Test.stopTest();
    }
    
    @isTest static void getprev_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.getprev();
        Test.stopTest();
    }
    
    @isTest static void getnxt_Test()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.getnxt();
        Test.stopTest();
    }
    
    @isTest static void getListarUsuarios_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();
        controlador.getListarUsuarios();
        Test.stopTest();
    }
    
     @isTest static void getListarEstados_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();              
        controlador.CurrentPage = 'TAREAS_UR';
        controlador.getListarEstados(); 
    }
    
      @isTest static void getListarEstados_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas();                      
        controlador.CurrentPage = 'TAREAS_UR_HISTORICO';
        controlador.getListarEstados(); 
    }
    
     @isTest static void seleccionResponsableUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        controlador.CurrentPage = 'TAREAS_UR';
        controlador.seleccionResponsableUR(); 
    }
    
    @isTest static void seleccionResponsableUR_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        controlador.CurrentPage = 'TAREAS_UR_HISTORICO';
        controlador.seleccionResponsableUR(); 
    }
    
    @isTest static void IniciarBandejaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.IniciarBandejaTareasUR(); 
    }
    
    @isTest static void getTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getTareasUR(); 
    }
    
    @isTest static void BandejaUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaUR(); 
    }
    
     @isTest static void BandejaTareasUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaTareasUR_Historico(); 
    }
    
     @isTest static void BandejaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.BandejaTareasUR(); 
    }
  
     @isTest static void busquedaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.busquedaTareasUR(); 
    }
    
     @isTest static void limpiabusquedaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.limpiabusquedaTareasUR(); 
    }
    
      @isTest static void verTareaUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.verTareaUR(); 
    }
 
     @isTest static void IniciarBandejaTareasUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.IniciarBandejaTareasUR_Historico(); 
    }
 
  /*    @isTest static void queryTareasHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.queryTareasURHistorico(); 
    }
    */
     @isTest static void getTareasURHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getTareasURHistorico(); 
    }
   
      @isTest static void getListarSolicitudes_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getListarSolicitudes(); 
    }
 
    @isTest static void busquedaTareasURHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.busquedaTareasURHistorico(); 
    }
    
        @isTest static void limpiabusquedaTareasURHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.limpiabusquedaTareasURHistorico(); 
    } 
    
    @isTest static void ErrorAcceso_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.ErrorAcceso(); 
    } 
    
    @isTest static void getUnidades_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaTareas controlador = new CTR_UR_BandejaTareas(); 
        //controlador.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        controlador.getUnidades(); 
    } 
    
    
    
    
}