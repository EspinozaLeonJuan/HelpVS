@istest
public class CLS_FlujoNotificacionControlador_Test {
    @istest
    public static void cargaCaso_a()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCaso_b()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('1'));
        Con.ESTADO = '1';
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCaso_c()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('2'));
        Con.ESTADO = '2';
        Con.cargaCaso();
        Test.stopTest();
    }
    
    
    
    @istest
    public static void cargaCaso_d()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        Con.ESTADO = '3';
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_a()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('1'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '1';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_b()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('2'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '2';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_c()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_d()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_NOTIFI = true;
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_e()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_ASUNTO = 'asunto del caso';
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }    
    
    @istest
    public static void guardarCasoCerrado_f()
    {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_COMENT = 'comentario del caso';
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }   
    
    @istest
    public static void cancelarCerrarCaso()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.cancelarCerrarCaso();
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_a()
    {
        Test.startTest();
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'INGRESADO');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_b()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = '69'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'FINALIZADO');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_c()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = '69'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'REVISION');
        Test.stopTest();
    }
    
    
    @istest
    public static void CambioEstado_EscritorioDigital_d()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = 'NO_REQED'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'REVISION');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_e()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = 'NO_REQED'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'FINALIZADO');
        Test.stopTest();
    }
    @istest 
    public static void CargaRequerimientoED_a()
    {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CargaRequerimientoED();
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoED_b()
    {
        Test.startTest();        
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CASO_PRI.Id_Requerimiento_EscritorioDigital__c = '69';       
        Con.CargaRequerimientoED();
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoED_c()
    {
        Test.startTest();       
        Account cuenta = Factory.cuenta.buildInsert();        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CASO_PRI.Id_Requerimiento_EscritorioDigital__c = null;
        Con.CASO_PRI.Detalle_Solicitud__c  = 'Solicitud Cuota Mortuoria';
        Con.CargaRequerimientoED();
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoCobranzasVida(){
        Account cuenta = Factory.buildAccount('Cuenta personal');
        cuenta.PersonEmail = 'mailcaso@test.cl';
        insert cuenta;
        
        Contact contacto = new Contact();
        contacto.FirstName = 'NombreContacto';
        contacto.LastName = 'ApellidoContacto';
        contacto.Email = 'mailcaso@test.cl';
        
        insert contacto;
        
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        caso.Origin = 'Cobranzas Vida';
        caso.Canal__c = 'Cobranzas Vida';
        caso.SuppliedEmail = 'mailcaso@test.cl';
        caso.SuppliedName = 'NombreCaso';
        caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        
        insert caso;
        
        Case caso2 = new Case();
        caso2.Origin = 'Cobranzas Vida';
        caso2.SuppliedName = caso.SuppliedName;
        caso2.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        caso2.ParentId = caso.Id;
        caso2.Canal__c = caso.Canal__c;
        caso2.Correo_electronico_Solicitante__c = 'mailcaso@test.cl';
        caso2.Correo_electronico_alternativo__c = 'mailcaso@test.cl';
        caso2.AccountId = cuenta.Id;
        caso2.ContactId = contacto.Id;
        insert caso2;        
        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        ApexPages.currentPage().getParameters().put('IdCaso', String.valueOf(caso2.Id));
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('1'));
        Con.ESTADO = '1';
        Con.C_NOTIFI = true;
        Con.CASO_ID = caso2.Id;
        Con.CASO_PRI = caso2;
        Con.cargaCaso();        
        Con.guardarCasoCerrado();         
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoRecepcionPagos(){
        Account cuenta = Factory.buildAccount('Cuenta personal');
        cuenta.PersonEmail = 'mailcaso@test.cl';
        insert cuenta;
        
        Contact contacto = new Contact();
        contacto.FirstName = 'NombreContacto';
        contacto.LastName = 'ApellidoContacto';
        contacto.Email = 'mailcaso@test.cl';
        
        insert contacto;
        
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        caso.Origin = 'Recepción Pagos';
        caso.Canal__c = 'Recepción Pagos';
        caso.SuppliedEmail = 'mailcaso@test.cl';
        caso.SuppliedName = 'NombreCaso';
        caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        caso.Status = 'Nuevo';
        caso.Entrega_Respuesta__c = false;
        
        insert caso;
        Case caso2 = null;
        caso2 = [SELECT Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, 
                 SourceId, CommunityId, BusinessHoursId, ParentId, SuppliedName, 
                 SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, RecordTypeId, 
                 Status, Reason, Origin, Subject, Priority, Description, IsClosed, 
                 ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate, 
                 IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, 
                 LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, 
                 MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName, 
                 Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, 
                 Entrega_Respuesta__c, Problema__c, Apellidos__c, Atencion_Presencial__c, 
                 Canal__c, Cantidad_Dias__c, Cargo_Propietario__c, Celular__c, 
                 Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c, 
                 Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, 
                 Concepto_Final__c, ContactEmail, Correo_Electronico__c, Correo_electronico_Solicitante__c, 
                 Correo_electronico_alternativo__c, Descripcion__c, Descripcion_de_Respuesta__c, 
                 Detalle_Operacion__c, Detalle_Solicitud__c, Direccion_Comercial__c, 
                 Direccion_Particular__c, Direccion_Postal_Alternativa__c, 
                 Direccion_Solicitante__c, Direccion_envio_respuesta__c, 
                 Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, Email_1__c, 
                 Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c, Fecha_de_nacimiento__c, 
                 Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c, 
                 Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, 
                 Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Producto__c, 
                 RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Region_Comercial__c, 
                 Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c, 
                 Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, 
                 Telefono_Solicitante__c, Tipo_Contacto_Final__c, Tipo_Operacion__c, 
                 Tipo_de_Solicitante__c, Campa_a_Mailing__c, Fecha_Hora_de_Cierre__c, 
                 Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c, 
                 Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, 
                 Fecha_de_EPA_Contact_Center_Caso__c, Colectivo_Banco_BCI__c, 
                 Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c, 
                 Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, 
                 Detalle_de_Rescate__c, Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, 
                 Cantidad_Dias_Desde_Creacion__c, Cumplimiento_Fecha_Cierre__c, 
                 Cliente_Compania__c, Carta_Cliente__c, Estado_Requerimiento_EscritorioDigital__c, 
                 Id_Requerimiento_EscritorioDigital__c, Tipo_Requerimiento_EscritorioDigital__c, 
                 Genero__c, Anular_aprobacion_reclamo_repetitivo__c, Aprobado_Reclamo__c, 
                 Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c, 
                 Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c, 
                 CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, 
                 CASO_Responsable_UR__c, Tipo_de_Requerimiento__c, PolizaED__c, 
                 CASO_Poliza_Asoc__c, Casos_Hijos_cerrados__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Parent.OwnerId
                 FROM Case
                 WHERE Id =: caso.Id];
        
        CLS_FlujoNotificacionControlador Con = new CLS_FlujoNotificacionControlador();
        
        con.ORIGENES = new Set<String>{'Cobranzas Vida', 'Recepción Pagos','Producción Individuales'};
        ApexPages.currentPage().getParameters().put('IdCaso', String.valueOf(caso2.Id));
        ApexPages.currentPage().getParameters().put('estado', String.valueOf('3'));
        Con.ESTADO = '3';
        Con.C_NOTIFI = true;
        Con.CASO_ID = caso2.Id;
        Con.CASO_PRI = caso2;
        Con.cargaCaso();        
        Con.guardarCasoCerrado();         
        Test.stopTest();
    }    
    
    
    
}