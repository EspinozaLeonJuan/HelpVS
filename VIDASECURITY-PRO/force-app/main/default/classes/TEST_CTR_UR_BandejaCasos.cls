/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_BandejaCasos                                                       |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_BandejaCasos                                                            |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/24   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@istest
public class TEST_CTR_UR_BandejaCasos {

    @isTest static void FirstPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FirstPage();
        Test.stopTest();
    }
    
    @isTest static void previous_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.Page = 10;
        controlador.previous();
        Test.stopTest();
    }
    
    @isTest static void next_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.Page = 10;
        controlador.next();
        Test.stopTest();
    }
    
    @isTest static void LastPage_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.Page = 10;
        controlador.totalRecs = 100;
        //OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        controlador.LastPage();
        Test.stopTest();
    }
    
    @isTest static void getprev_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getprev();
        Test.stopTest();
    }
    
    @isTest static void getnxt_Test()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getnxt();
        Test.stopTest();
    }
    
    @isTest static void getListarUsuarios_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getListarUsuarios();
        Test.stopTest();
    }
    
     @isTest static void getListarEstados_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();              
        controlador.CurrentPage = 'CASOS_UR';
        controlador.getListarEstados(); 
    }
    
      @isTest static void getListarEstados_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();                      
        controlador.CurrentPage = 'CASOS_UR_ENREVISION';
        controlador.getListarEstados(); 
    }
    
    @isTest static void getListarEstados_Test_03()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();              
        controlador.CurrentPage = 'CASOS_UR_HISTORICO';             
        controlador.getListarEstados(); 
    }
    
    @isTest static void getListarTipos_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getListarTipos();
        Test.stopTest();
    }
    
    @isTest static void getListarOrigenes_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getListarOrigenes();
        Test.stopTest();
    }
    
    @isTest static void getListarEstadosAcsel_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getListarEstadosAcsel();
        Test.stopTest();
    }
    
     @isTest static void NombreUsuarioBackup_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.LST_UsuariosBackup = new List<Usuario_Backup__c>();
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        controlador.LST_UsuariosBackup.add(uback);
        controlador.NombreUsuarioBackup(uback.Id);
        Test.stopTest();
    }
    
    @isTest static void IniciarBandejaCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        Usuario_Backup__c uback = new Usuario_Backup__c();
        uback.UBAC_Area__c = 'Producción RRVV';
		uback.UBAC_Activo__c = true;       
        insert uback;
        controlador.IniciarBandejaCasos();
        Test.stopTest();
    }
    
    @isTest static void ErrorAcceso_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();        
        controlador.ErrorAcceso();
        Test.stopTest();
    }
   
    @isTest static void IniciarBandejaCasos_EnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        Usuario_Backup__c uback = new Usuario_Backup__c();
        uback.UBAC_Area__c = 'Producción RRVV';
		uback.UBAC_Activo__c = true;       
        insert uback;
        controlador.IniciarBandejaCasos_EnRevision();
        Test.stopTest();
    }
    
     @isTest static void IniciarBandejaCasos_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        Usuario_Backup__c uback = new Usuario_Backup__c();
        uback.UBAC_Area__c = 'Producción RRVV';
		uback.UBAC_Activo__c = true;       
        insert uback;
        controlador.IniciarBandejaCasos_Historico();
        Test.stopTest();
    }

     @isTest static void seleccionResponsableUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.seleccionResponsableUR();
        Test.stopTest();
    }
    
    @isTest static void busquedaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.busquedaCasosUR();
        Test.stopTest();
    }
    
      @isTest static void limpiaBusquedaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.limpiaBusquedaCasosUR();
        Test.stopTest();
    }
    
    @isTest static void busquedaCasosUR_EnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.busquedaCasosUR_EnRevision();
        Test.stopTest();
    }
    
    @isTest static void limpiaBusquedaCasosUR_EnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.limpiaBusquedaCasosUR_EnRevision();
        Test.stopTest();
    }
    
    @isTest static void busquedaCasosUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.busquedaCasosUR_Historico();
        Test.stopTest();
    }
    
    @isTest static void limpiaBusquedaCasosUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.limpiaBusquedaCasosUR_Historico();
        Test.stopTest();
    }
          
    @isTest static void GetTime_Test_01()
    {
        Test.startTest();
        Time t = Time.newInstance(1, 2, 3, 4);
        CTR_UR_BandejaCasos.GetTime(t);
        Test.stopTest();
    }

    @isTest static void getListadoCategoriasBeneficios_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.getListadoCategoriasBeneficios();
        Test.stopTest();
    }
    
    @isTest static void ToTaskList_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.ToTaskList();
        Test.stopTest();
    }
    
    @isTest static void ToColaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.ToColaboraciones();
        Test.stopTest();
    }

    @isTest static void BandejaUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.BandejaUR();
        Test.stopTest();
    }
    @isTest static void BandejaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.BandejaCasosUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaCasosUR_EnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.BandejaCasosUR_EnRevision();
        Test.stopTest();
    }
    
     @isTest static void BandejaCasosUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.BandejaCasosUR_Historico();
        Test.stopTest();
    }
    
     @isTest static void verCasoUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.verCasoUR();
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.cargaParametrosPantallas();
        controlador.queryCasosUR('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = '1';
        controlador.cargaParametrosPantallas();
        controlador.queryCasosUR('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_03()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'Todos';
        controlador.cargaParametrosPantallas();
        controlador.queryCasosUR('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_04()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'Clientes';
        controlador.cargaParametrosPantallas();
        controlador.queryCasosUR('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_05()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'No Clientes';
        controlador.cargaParametrosPantallas();
        controlador.queryCasosUR('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosEnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = '1';
        controlador.queryCasosEnRevision('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosEnRevision_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'Todos';
        controlador.queryCasosEnRevision('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosEnRevision_Test_03()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'Clientes';
        controlador.queryCasosEnRevision('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosEnRevision_Test_04()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.Tipo = 'No Clientes';
        controlador.queryCasosEnRevision('');
        Test.stopTest();
    }
    
    @isTest static void queryCasosURHistorico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = Factory.buildUsuarioBackup().Id;
        controlador.UsuarioBackUp = '1';
        controlador.queryCasosURHistorico('');
        Test.stopTest();
    }
    
      @isTest static void queryCasosURHistorico_Test_02()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = Factory.buildUsuarioBackup().Id;
        controlador.Tipo = 'Todos';
        controlador.queryCasosURHistorico('');
        Test.stopTest();
    }
   
      @isTest static void queryCasosURHistorico_Test_03()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = Factory.buildUsuarioBackup().Id;
        controlador.Tipo = 'Clientes';
        controlador.queryCasosURHistorico('');
        Test.stopTest();
    }
    
      @isTest static void queryCasosURHistorico_Test_04()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.UsuarioBackUp = Factory.buildUsuarioBackup().Id;
        controlador.Tipo = 'No Clientes';
        controlador.queryCasosURHistorico('');
        Test.stopTest();
    }
    
    @isTest static void getCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.getCasosUR();
        Test.stopTest();
    }
    
    @isTest static void getCasosUR_EnRevision_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.getCasosUR_EnRevision();
        Test.stopTest();
    }
    
    @isTest static void getCasosUR_Historico_Test_01()
    {
        Test.startTest();
        CTR_UR_BandejaCasos controlador = new CTR_UR_BandejaCasos();
        controlador.FechaInicioDerivacion = Date.today().addDays(-30);
        controlador.FechaTerminoDerivacion = Date.today();
        controlador.getCasosUR_Historico();
        Test.stopTest();
    }
        
}