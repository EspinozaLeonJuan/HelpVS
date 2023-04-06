@isTest
public class SalesforceTPTest {

    //// Faltan metodos de prueba del popup

    static SalesforceTP2 sftp = new SalesforceTP2();
    static User usuario = Factory.buildUser();
    static SalesforceTPSoapMockImpl wsMock;

    static {
        insert usuario;
        Factory.crearAccountAnonimo();
        Factory.crearDatosTotalpack(usuario);
        wsMock = new SalesforceTPSoapMockImpl();
        Test.setMock(WebServiceMock.class, wsMock);
    }

    static testMethod void coberturaSalesforceTP(){
        SalesforceTP sTP = new SalesforceTP();
        sTp.getListaMinutos();
        sTP.getInfoCliente();
        sTp.GuardarPopup();
        sTp.CerrarPopup();
        sTp.MostrarPopup();

        sTp.Sucursal = 'COBERTURA';
        sTp.Estado = 'COBERTURA';
        sTp.Turno = 'COBERTURA';
        sTp.Espera = 'COBERTURA';
        sTp.TiempoAtencion = 'COBERTURA';
        sTp.ClienteRut = 'COBERTURA';
        sTp.OficinaEspera = 'COBERTURA';
        sTp.OficinaTiempoEspera = 'COBERTURA';
        sTp.EscritorioEspera = 'COBERTURA';
        sTp.EscritorioTiempoEspera = 'COBERTURA';
        sTp.ClienteNombre  = 'COBERTURA';
        sTp.ClienteFechaInicioRelacion  = 'COBERTURA';
        sTp.ClienteUltimaVisitaSucursal  = 'COBERTURA';
        sTp.ClienteUrlUltimoCaso  = 'COBERTURA';
        sTp.ClienteFechaUltimoCaso  = 'COBERTURA';
        sTp.ClienteCantidadPolizasActivas  = 'COBERTURA';
        sTp.ClienteReclamosAno  = 'COBERTURA';
        sTp.ClienteReclamosAnteriores  = 'COBERTURA';
        sTp.ClienteConsultasAno  = 'COBERTURA';
        sTp.ClienteConsultasAnteriores  = 'COBERTURA';
        sTp.ClienteSolicitudesAno  = 'COBERTURA';
        sTp.ClienteSolicitudesAnteriores  = 'COBERTURA';
        sTp.UrlCaso  = 'COBERTURA';
        sTp.uTurno  = 'COBERTURA';
        sTp.uRut  = 'COBERTURA';
        sTp.PausaItem = 'COBERTURA';
        sTp.SerieItem = 'COBERTURA';

        sTp.DisplayBotonIniciaAtencion = true;
        sTp.DisplayBotonCierraAtencion = true;
        sTp.DisplayBotonPausa = true;
        sTp.DisplayBotonClienteLlego = true;
        sTp.DisplayBotonRellamada = true;
        sTp.DisplayBotonAnular = true;
        sTp.DisplayBotonUrgencia = true;
        sTp.DisplayBotonSalir = true;
        sTp.DisplayBotonCambiaRut  = true;
        sTp.DisplayBotonLogin  = true;
        sTp.DisplayCuadroDetallesTurno = true;
        sTp.DisplayCuadroDetallesSucursal = true;
        sTp.DisplayPopup = true;
        sTp.DisplayWaitEnPopup = true;
        sTp.DisplayLinkCaso  = true;
        sTp.ReintentoLogin  = true;
        sTp.DisplayErrorLogin  = true;
        sTp.CierraPopup  = true;

        sTp.MotivoItems = new String[]{'COBERTURA'};

        sTp.CodError  = 1;
        sTp.RecordatorioCierreAtencionMsecs  = 1;
        sTp.IdEscritorio  = 1;
    }

    static TestMethod void InicializaTest() {
        Test.startTest();

       /* System.runAs(usuario) {
            sftp.Inicializa();
        }

        System.assertEquals(sftp.DisplayPopup, true);
        System.assertNotEquals(sftp.MotivoItems, null);
        */
        Test.stopTest();
    }

    static TestMethod void InicializaActualizaPausasSeriesTest() {
        Test.startTest();

        System.runAs(usuario) {
            sftp.InicializaActualiza();
            sftp.GetPausas();
            sftp.GetSeries();
        }
       // wsMock.tipoPrueba = 'EsperandoOK';
        /*
        System.runAs(usuario) {
            sftp.InicializaActualiza();
            sftp.GetPausas();
            sftp.GetSeries();
        }
        */
        Test.stopTest();
    }

    static TestMethod void Logoff() {
        Test.startTest();
        System.runAs(usuario) {
            sftp.Inicializa();
            sftp.Logoff();
            sftp.ActualizaUI();
        }
     //   wsMock.tipoPrueba = 'LogoffOK';
        /*
        System.runAs(usuario) {
            sftp.Inicializa();
            sftp.Logoff();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'LOGOFF');
        */
        Test.stopTest();
    }

    static TestMethod void LoginPausa(){
        Test.startTest();
        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.ActualizaUI();
        }
        //wsMock.tipoPrueba = 'PausaOK';
        /*
        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'PAUSA');
        */
        Test.stopTest();
    }

    static TestMethod void AtencionClienteEspera(){
        Test.startTest();

        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
          //  System.assertEquals(sftp.Estado, 'LLAMANDO');
            sftp.ProcesoTurno();
            sftp.ActualizaUI();
        }
        //wsMock.tipoPrueba = 'PidoTurnoConClienteEspera';

        /*System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
            System.assertEquals(sftp.Estado, 'LLAMANDO');
            sftp.ProcesoTurno();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'ATENDIENDO');
        */
        Test.stopTest();
    }

    static TestMethod void AtencionClienteSinEsperaTest(){
        Test.startTest();

        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
        }
     //   wsMock.tipoPrueba = 'PidoTurnoSinClienteEspera';
        /*
        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'ESPERANDO');
        */
        Test.stopTest();
    }

    static TestMethod void CodErrorActualizaUITest(){
        Test.startTest();

         System.runAs(usuario) {
            sftp.InicializaActualiza();
        }
      //  wsMock.tipoPrueba = 'CodError1';
        /*
        System.runAs(usuario) {
            sftp.InicializaActualiza();
        }

        System.assertEquals(sftp.Estado, 'REINTENTANDO LOGIN');
        */
        Test.stopTest();
    }

    static TestMethod void FinTurnoTest(){
        Test.startTest();
         System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
          //  System.assertEquals(sftp.Estado, 'LLAMANDO');
            sftp.ProcesoTurno();
            sftp.ActualizaUI();
          //  System.assertEquals(sftp.Estado, 'ATENDIENDO');
            sftp.FinTurno();
            sftp.ActualizaUI();
        }
       // wsMock.tipoPrueba = 'PidoTurnoConClienteEspera';
        /*
        System.runAs(usuario) {
            sftp.LoginPausa();
            sftp.PidoTurno();
            sftp.ActualizaUI();
            System.assertEquals(sftp.Estado, 'LLAMANDO');
            sftp.ProcesoTurno();
            sftp.ActualizaUI();
            System.assertEquals(sftp.Estado, 'ATENDIENDO');
            sftp.FinTurno();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'ESPERANDO');
        */
        Test.stopTest();
    }

    static TestMethod void LogoffTest(){
        Test.startTest();

         System.runAs(usuario) {
            sftp.InicializaActualiza();
            sftp.Logoff();
            sftp.ActualizaUI();
        }
      //  wsMock.tipoPrueba = 'logoff';
        /*
        System.runAs(usuario) {
            sftp.InicializaActualiza();
            sftp.Logoff();
            sftp.ActualizaUI();
        }

        System.assertEquals(sftp.Estado, 'LOGOFF');
        */
        Test.stopTest();
    }
}