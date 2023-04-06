/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_Caso		                                              			|
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_Caso			   														|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/24   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@istest(seeAllData=true)
public class TEST_CTR_UR_Caso {

    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.cargaCaso();
        controlador.guardarEstado();
        controlador.editarEstadoBloque();
        controlador.cancelarEstadoBloque();
        controlador.guardarCambios();
        controlador.IniciaCaso();
        controlador.ErrorAcceso();
        Test.stopTest();
    }

    @isTest static void ValidaEscritorioDigital_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.cargaCaso();
        //controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Id_Requerimiento_EscritorioDigital__c = '79';
        controlador.ValidaEscritorioDigital();
        Test.stopTest();
    }

    /*@isTest static void CargaUsuario_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Usuario_Backup__c uback = new Usuario_Backup__c();
        uback.UBAC_Area__c = 'Producción RRVV';
        insert uback;
        controlador.CargaUsuario();
        Test.stopTest();
    }*/

     @isTest static void ActualizaValoresACSEL_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.ActualizaValoresACSEL();
        Test.stopTest();
    }

     @isTest static void getListarEstadosAcsel_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.getListarEstadosAcsel();
        Test.stopTest();
    }

     @isTest static void IniciaActualizaACSEL_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.IniciaActualizaACSEL();
        Test.stopTest();
    }

    @isTest static void IniciaNuevoComentario_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.EsNoCliente__c = false;
        controlador.IniciaNuevoComentario();
        Test.stopTest();
    }

    @isTest static void IniciaNuevoComentario_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.EsNoCliente__c = true;
        controlador.IniciaNuevoComentario();
        Test.stopTest();
    }

    @isTest static void GuardarComentario_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.GuardarComentario();
        Test.stopTest();
    }

     @isTest static void IniciaCambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.EsNoCliente__c = false;
        controlador.IniciaCambioResponsable();
        Test.stopTest();
    }

    @isTest static void IniciaCambioResponsable_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.EsNoCliente__c = false;
        controlador.IniciaCambioResponsable();
        Test.stopTest();
    }

     @isTest static void CambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.ComentarioUbk = 'This is a comment';
        controlador.CambioResponsable();
        Test.stopTest();
    }

      @isTest static void CambioResponsable_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Account cuenta = Factory.cuenta.buildInsert();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.ComentarioUbk = 'This is a comment';
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        controlador.IdResponsableActual =  uback.Id;
        controlador.CambioResponsable();
        Test.stopTest();
    }


     @isTest static void IniciaTareaUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.IniciaTareaUR();
        Test.stopTest();
    }

    @isTest static void getUnidades_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.listaUR = new  List<Cola_Usuario__c>();
        controlador.getUnidades();

        Test.stopTest();
    }

    @isTest static void getPrioridades_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.getPrioridades();
        Test.stopTest();
    }
    @isTest static void GuardarTarea_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        controlador.CasoPopup.CASO_Responsable_UR__c = uback.Id;
        controlador.GuardarTarea();
        Test.stopTest();
    }
    @isTest static void CargaTareaUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CargaTareaUR();
        Test.stopTest();
    }
    @isTest static void IniciaComentarioTareaUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.IniciaComentarioTareaUR();
        Test.stopTest();
    }

     @isTest static void GuardarComentarioTareaUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.GuardarComentarioTareaUR();
        Test.stopTest();
    }

     @isTest static void CasosUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasosUR();
        Test.stopTest();
    }

     @isTest static void CasosRevisionUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasosRevisionUR();
        Test.stopTest();
    }

     @isTest static void HistoricoUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.HistoricoUR();
        Test.stopTest();
    }

    @isTest static void GuardarAdjunto_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.Caso = new Case();
        controlador.GuardarAdjunto();
        Test.stopTest();
    }

    @isTest static void EnProceso_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.Caso = new Case();
        controlador.EnProceso();
        Test.stopTest();
    }

    @isTest static void IniciaCambioEstado_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        ApexPages.currentPage().getParameters().put('cambio', 'Retorno');
        controlador.IniciaCambioEstado();
        Test.stopTest();
    }

    @isTest static void IniciaCambioEstado_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        ApexPages.currentPage().getParameters().put('cambio', 'Cierre');
        controlador.IniciaCambioEstado();
        Test.stopTest();
    }

    @isTest static void IniciaCambioEstado_Test_03()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        ApexPages.currentPage().getParameters().put('cambio', 'Rechazo');
        controlador.IniciaCambioEstado();
        Test.stopTest();
    }

   /* @isTest static void CambioEstadoEscritorioDigital_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CambioEstadoEscritorioDigital(111179, 'FINALIZADO');
        Test.stopTest();
    }
    */
    @isTest static void CambioEstadoCaso_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.Id_Requerimiento_EscritorioDigital__c = '79';
        controlador.EstadoCambio = 'Cerrado';
        controlador.CambioEstadoCaso();
        Test.stopTest();
    }

     @isTest static void CambioEstadoCaso_Test_02()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.Id_Requerimiento_EscritorioDigital__c = '79';
        controlador.EstadoCambio = 'Rechazado';
        controlador.CambioEstadoCaso();
        Test.stopTest();
    }

     @isTest static void CambioEstadoCaso_Test_03()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.Id_Requerimiento_EscritorioDigital__c = '79';
        controlador.EstadoCambio = 'En Revisión';
        controlador.CambioEstadoCaso();
        Test.stopTest();
    }
  /*
     @isTest static void CambioEstadoCaso_Test_04()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.CasoPopup.Id_Requerimiento_EscritorioDigital__c = '79';
        controlador.CasoPopup.Detalle_Solicitud__c = 'ED - Endoso Capital Asegurado';
        controlador.EstadoCambio = 'En Revisión';
        controlador.CambioEstadoCaso();
        Test.stopTest();
    }*/

/*    @isTest static void ActualizaEstadoTareasUR_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.ActualizaEstadoTareasUR();
        Test.stopTest();
    }
  */
   /* @isTest static void ActualizaCasoAtencion_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.ActualizaCasoAtencion();
        Test.stopTest();
    }*/

     @isTest static void Generacion_Cartas_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.Generacion_Cartas('SOBREPRIMA','ED - Endoso Capital Asegurado');
        Test.stopTest();
    }

    @isTest static void Carta_Sobreprima_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        controlador.CasoPopup.CASO_Responsable_UR__c = uback.Id;
        controlador.IdCaso = controlador.CasoPopup.Id;
        controlador.UsuarioBackUp = uback.Id;
        controlador.Carta_Sobreprima();
        Test.stopTest();
    }

    @isTest static void Carta_Exclusion_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();

        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.CasoPopup = Factory.buildCasoSF('Solicitudes', cuenta);
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        controlador.CasoPopup.CASO_Responsable_UR__c = uback.Id;
        controlador.IdCaso = controlador.CasoPopup.Id;
        controlador.UsuarioBackUp = uback.Id;
        controlador.Carta_Exclusion();
        Test.stopTest();
    }

    @isTest static void AddEmail_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.Emails = new List<String>();
        controlador.Emails.add('juespinoza@security.cl');
        controlador.EmailManual = 'sacevedo@security.cl';
        controlador.AddEmail();
        Test.stopTest();
    }

    @isTest static void getEmailsSelect_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.getEmailsSelect();
        Test.stopTest();
    }

    @isTest static void RemoveEmail_Test()
    {
        Test.startTest();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        controlador.Emails = new List<String>();
        controlador.Emails.add('juespinoza@security.cl');
        controlador.EmailsDelete = new List<String>();
        controlador.EmailsDelete.add('juespinoza@security.cl');
        controlador.RemoveEmail();
        Test.stopTest();
    }

      @isTest static void validateEmail_Test()
    {
        Test.startTest();
        CTR_UR_Caso.validateEmail('juespinoza@security.cl');
        Test.stopTest();
    }
}