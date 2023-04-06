/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_CV_Caso                                                               |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_CV_Caso                                                                    |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/19   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@isTest
public class TEST_CTR_CV_Caso {
    public TEST_CTR_CV_Caso() {

    }


    @isTest static void IngresoRUT_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.IngresoRUT();
        Test.stopTest();
    }


    @isTest static void InicioNuevoCasoCliente_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();     
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        ApexPages.currentPage().getParameters().put('Id', cuenta.Id);
        ApexPages.currentPage().getParameters().put('Negocio', 'Seguros Individuales');
        controlador.InicioNuevoCasoCliente();
        Test.stopTest();
    }

    @isTest static void InicioNuevoCasoCliente_Test_02()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        //ApexPages.currentPage().getParameters().put('Id', '');
        ApexPages.currentPage().getParameters().put('Negocio', 'Seguros Individuales');
        controlador.InicioNuevoCasoCliente();
        Test.stopTest();
    } 

    @isTest static void InicioNuevoCasoCliente_Test_03()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        //ApexPages.currentPage().getParameters().put('Id', '0010H00002OBxgv');
        ApexPages.currentPage().getParameters().put('Id', '12345');
        ApexPages.currentPage().getParameters().put('Negocio', 'Seguros Individuales');
        controlador.InicioNuevoCasoCliente();
        Test.stopTest();
    }

    @isTest static void InicioNuevoCasoNoCliente_Test_01()
    {
        Test.startTest();
        Lead prospecto = Factory.buildProspectoSF();   
        Factory.crearAccountAnonimoVentas();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        ApexPages.currentPage().getParameters().put('Rut', '88888888');
        ApexPages.currentPage().getParameters().put('Dv', '8');
        ApexPages.currentPage().getParameters().put('LeadId', prospecto.Id);
        ApexPages.currentPage().getParameters().put('LeadName', prospecto.FirstName);
        ApexPages.currentPage().getParameters().put('LeadLastName', prospecto.LastName);
        ApexPages.currentPage().getParameters().put('Negocio', 'Seguros Individuales');
        controlador.InicioNuevoCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void InicioNuevoCasoNoCliente_Test_02()
    {
        Test.startTest();
        Lead prospecto = Factory.buildProspectoSF();           
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        ApexPages.currentPage().getParameters().put('Rut', '88888888');
        ApexPages.currentPage().getParameters().put('Dv', '8');
        ApexPages.currentPage().getParameters().put('LeadId', prospecto.Id);
        ApexPages.currentPage().getParameters().put('LeadName', prospecto.FirstName);
        ApexPages.currentPage().getParameters().put('LeadLastName', prospecto.LastName);
        ApexPages.currentPage().getParameters().put('Negocio', 'Seguros Individuales');
        controlador.InicioNuevoCasoNoCliente();
        Test.stopTest();     
    }
    
    @isTest static void validaRut_Test_01()
    {
        Test.startTest();        
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.RUT = '13895200-2';
        controlador.validaRut();
        Test.stopTest();
    }
    
    @isTest static void validaRut_Test_02()
    {
        Test.startTest();
        Lead prospecto = Factory.buildProspectoSF();   
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.RUT = '88888888-8';//'13895200-2';
        controlador.validaRut();
        Test.stopTest();
    }
    
    @isTest static void validaRut_Test_03()
    {
        Test.startTest();
        Factory.crearAccountSF();   
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.RUT = '88888888-8';//'13895200-2';
        controlador.validaRut();
        Test.stopTest();
    }
    
     @isTest static void validaRut_Test_04()
    {
        Test.startTest(); 
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.RUT = '1-8';//'13895200-2';
        controlador.validaRut();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_02()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Parcial';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_03()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Patrimonial';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_04()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Total';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_05()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'Solicitud de Rescate Total';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_06()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'Solicitud de Rescate Parcial';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_07()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud Otros Endosos';
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoCliente_Test_08()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();   
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud Otros Endosos';
        controlador.Caso.AccountId = cuenta.Id;
        
        Contact contacto = Factory.buildContactSF(cuenta);
        system.debug('@@@@ Contacto Test -->'+ contacto);
        controlador.Caso.Agente__c = contacto.Id;
        controlador.GuardaCasoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();  
        controlador.NoCliente_Nombres = '';
        controlador.NoCliente_Apellidos = '';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();        
    }
    
     @isTest static void GuardaCasoNoCliente_Test_02()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();     
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Parcial';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_03()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Patrimonial';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_04()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();    
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud de Rescate Total';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_05()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();  
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'Solicitud de Rescate Total';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_06()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'Solicitud de Rescate Parcial';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    
    @isTest static void GuardaCasoNoCliente_Test_07()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso = new Case();        
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
    @isTest static void GuardaCasoNoCliente_Test_08()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud Otros Endosos';
        controlador.LeadId = 'newLead';
        controlador.GuardaCasoNoCliente();
        Test.stopTest();
    }
    
     @isTest static void GuardaCasoNoCliente_Test_09()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.Caso = new Case();
        controlador.NoCliente_Nombres = 'Juan';
        controlador.NoCliente_Apellidos = 'Espinoza';
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud Otros Endosos';
        Lead prospecto = Factory.buildProspectoSF();   
        controlador.LeadId = prospecto.Id;        
                
        Contact contacto = Factory.buildContactSF();
        system.debug('@@@@ Contacto Test -->'+ contacto);
        controlador.Caso.Agente__c = contacto.Id;
        
        controlador.GuardaCasoNoCliente();
        
        Test.stopTest();
    }
    
        
    @isTest static void GetDetalleSolicitud_Test_01() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Declaración Ingresos Actualización');
        System.assert(solicitud == 'ED - Renovación de Asignación Familiar');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_02() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Renuncia Garantía Estatal');
        System.assert(solicitud == 'ED - Renuncia Garantía Estatal');     
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_03() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud cambio pago pensión');
        System.assert(solicitud == 'ED - Solicitud cambio pago pensión');
        Test.stopTest();         	
    }

    @isTest static void GetDetalleSolicitud_Test_04() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();         
        String solicitud = controlador.GetDetalleSolicitud('Solicitud cuota mortuoria');
        System.assert(solicitud == 'ED - Solicitud cuota mortuoria');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_05() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud de incorporación/ Renovación asignación familiar');
        System.assert(solicitud == 'ED - Solicitud de Asignación Familiar');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_06() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud de Extinción');
        System.assert(solicitud == 'ED - Solicitud de Extinción Asignación Familiar');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_07() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud garantía estatal');
        System.assert(solicitud == 'ED - Solicitud garantía estatal');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_08() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud pensión sobrevivencia');
        System.assert(solicitud == 'ED - Solicitud pensión sobrevivencia');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_09() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud periodo garantizado');
        System.assert(solicitud == 'ED - Solicitud periodo garantizado');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_10() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Sitio web');
        System.assert(solicitud == 'Sitio web (error o problema)');
        Test.stopTest();
    }

 

    @isTest static void GetDetalleSolicitud_Test_11() {
        Test.startTest();        
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Siniestro Tradicional Vida COL');
        System.assert(solicitud == 'Siniestro Tradicional Vida');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_12() {
        Test.startTest(); 
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud endoso');
        System.assert(solicitud == 'Solicitud endoso a la póliza');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_13() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud cambio CCAF');
        System.assert(solicitud == 'Solicitud cambio CCAF (Caja Compensación)');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_14() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud CCAF');
        System.assert(solicitud == 'Solicitud CCAF (Caja Compensación)');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_15() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud de problema con Traspaso In');
        System.assert(solicitud == 'Solicitud de problema con Traspaso In (Entrada)');        
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_16() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('ED - Solicitud de Rescate Patrimonial');
        System.assert(solicitud == 'Solicitud de Rescate Patrimonial');        
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_17() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud eliminar empleados de planilla (PF-APV)');
        System.assert(solicitud == 'Solicitud eliminar empleados de planilla'); 
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_18() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Endosos');
        System.assert(solicitud == 'Solicitud Endoso');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_19() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud endoso');
        System.assert(solicitud == 'Solicitud endoso a la póliza');
        Test.stopTest();
    }

    @isTest static void GetDetalleSolicitud_Test_20() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud nuevo FUN');
        System.assert(solicitud == 'ED - Solicitud nuevo FUN');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_21() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud préstamo');
        System.assert(solicitud == 'Solicitud préstamo (CDS)');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_22() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud valores garantizados');
        System.assert(solicitud == 'Solicitud valores garantizados (CDS)');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_23() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Solicitud Otros Endosos');
        System.assert(solicitud == 'ED - Solicitud Otros Endosos');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_24() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('ED - Endoso Aumento de Prima en Exceso');
        System.assert(solicitud == 'ED - Endoso Modificacion de Prima en Exceso');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_25() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('ED - Endoso Agregar Coberturas');
        System.assert(solicitud == 'ED - Endoso Agregar Cobertura');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_26() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('ED - Endoso Eliminar Coberturas');
        System.assert(solicitud == 'ED - Endoso Eliminar Cobertura');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_27() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('ED - Modificación de Tipo de Pago');
        System.assert(solicitud == 'ED - Modificación de Tipo de Pago PAC o PAT');
        Test.stopTest();     
    }

    @isTest static void GetDetalleSolicitud_Test_28() {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        String solicitud = controlador.GetDetalleSolicitud('Dato de prueba');
        System.assert(solicitud == 'Dato de prueba');
        Test.stopTest();     
    }
        
    @isTest static void ReiniciaCasoCliente_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.ReiniciaCasoCliente();
        Test.stopTest();           
    }
    
    @isTest static void ReiniciaCasoNoCliente_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.RUTNoCliente = '15045517-0';
        controlador.ReiniciaCasoNoCliente();
        Test.stopTest();           
    }
    
    @isTest static void ListadoCasos_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.ListadoCasos();
        Test.stopTest();           
    }
    
    @isTest static void NuevoCaso_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.NuevoCaso();
        Test.stopTest();           
    }
    
    @isTest static void getListaPolizas_Test()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();   
        CTR_CV_Caso controlador = new CTR_CV_Caso();
        controlador.IdCuenta = cuenta.Id;
        controlador.getListaPolizas();
        Test.stopTest();        
    }
    
    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.cargaCaso();
        Test.stopTest();        
    }
    
    @isTest static void IniciaNuevoComentario_Test()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();        
        controlador.IniciaNuevoComentario();
        Test.stopTest(); 
    }
    
    @isTest static void LoadError_EscritorioDigital_Test() {
        Test.startTest();       
        CTR_CV_Caso controlador = new CTR_CV_Caso();
       
		controlador.loadError('RUT_CLIENTE_NO_CORRESPONDE');
        controlador.loadError('RUT_CLIENTE_SIN_BENEFICIARIOS');
        controlador.loadError('POLIZA_OBSOLETA');
        controlador.loadError('POLIZA_NO_INGRESADA');
        controlador.loadError('CLIENTE_SIN_POLIZAS_ACTIVAS');
        controlador.loadError('POLIZA_NO_CORRESPONDE');
        controlador.loadError('CREA_REQUERIMIENTO_EXCEPCION');
        controlador.loadError('PERSISTENCIA_EXCEPCION_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_PARAMETROS_FALTANTES_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_INVALIDO_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA_CREA_REQ');
        controlador.loadError('PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ');
        controlador.loadError('PERSISTENCIA_EXCEPCION');
        controlador.loadError('PERSISTENCIA_ERROR_PARAMETROS_FALTANTES');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_INVALIDO');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO');
        controlador.loadError('PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED');
        controlador.loadError('PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA');
        controlador.loadError('PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO');
        controlador.loadError('REQUERIMIENTO_NO_APV');
        controlador.loadError('REQUERIMIENTO_MAX_3');
        controlador.loadError('REQUERIMIENTO_MI_SEGURO');
        controlador.loadError('REQUERIMIENTO_NO_SOPORTADO');
		controlador.loadError('OTRO_ERROR');
        
        Test.stopTest();
    } 
    
    @isTest static void DerivaCaso_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();  
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        controlador.Caso = caso;
        
        controlador.DerivaCaso();
        Test.stopTest(); 
    }
    
    @isTest static void DerivaCaso_Test_02()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        controlador.Caso = caso;
        controlador.Caso.Id_Requerimiento_EscritorioDigital__c = '1224';
        controlador.DerivaCaso();
        Test.stopTest(); 
    }
    
    @isTest static void DerivaCaso_Test_03()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.Caso = new Case();
        controlador.Caso.Status = 'Cerrado';
        controlador.DerivaCaso();
        Test.stopTest(); 
    }
    
    @isTest static void DerivaCaso_Test_04()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.Caso = new Case();
        controlador.Caso.Status = 'Back Office';
        controlador.DerivaCaso();
        Test.stopTest(); 
    }
    
    @isTest static void CierreCaso_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.Caso = new Case();
        controlador.CierreCaso();
        Test.stopTest(); 
    }
    
    
    @isTest static void CierreCaso_Test_02()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.Caso = new Case();
        controlador.Caso.Status = 'Cerrado';
        controlador.CierreCaso();
        Test.stopTest(); 
    }
    
    @isTest static void CierreCaso_Test_03()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        controlador.Caso = new Case();
        controlador.Caso.Status = 'Back Office';
        controlador.CierreCaso();
        Test.stopTest(); 
    }
    
    @isTest static void IniciaEscritorioDigital_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        CTR_CV_Caso controlador = new CTR_CV_Caso();   
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        controlador.IniciaEscritorioDigital();
        Test.stopTest(); 
    }
    
     @isTest static void getListaSolicitantes_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();           
        controlador.getListaSolicitantes();
        Test.stopTest(); 
    }
    
    @isTest static void getListaNegocios_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();           
        controlador.getListaNegocios();
        Test.stopTest(); 
    }
    
    @isTest static void AdjuntarArchivo_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();          
        CTR_CV_Caso controlador = new CTR_CV_Caso();           
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.AdjuntarArchivo();        
        Test.stopTest(); 
    }
    
    
    @isTest static void crearRequerimiento_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();  
        controlador.CasoPopup = new Case();
        controlador.TipoRequerimientoED = 'RRVVTIPO0045';
        controlador.crearRequerimiento();
        Test.stopTest(); 
    }
    
    @isTest static void GuardarComentario_Test_01()
    {
        Test.startTest();
        CTR_CV_Caso controlador = new CTR_CV_Caso();  
        controlador.Comentario = new CaseComment();
        controlador.GuardarComentario();
        Test.stopTest(); 
    }
    
    
    
   
}