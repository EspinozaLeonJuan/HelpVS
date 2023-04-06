/*******************************************************************************************
 *  NOMBRE                 : CLS_CasoHijoControlador
 *  TIPO                                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 *
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 06/06/2018 - J. ESPINOZA      - Creación Clase
 *  1.1     - 29/08/2018 - I. SALAZAR       - Se agrega corredor, y polizas de empresas
 * *****************************************************************************************/
public class CLS_CasoHijoControlador {

    public String ID_CasoPrincipal {get; set;}
    public String IdTipoRegistro {get; set;}
    public String NomNegocio {get; set;}
    public String ID_Cuenta {get; set;}

    public Case CASO_Principal {get; set;}

    public Case CASO_Hijo {get; set;}

    public List<Case> LST_SubCasos {get; set;}
    public List<RecordType> LST_TipoRegistros {get; set;}
    public List<SelectOption> LST_Polizas {get; set;}

    public String Poliza {get; set;}
    public String RUTTitular { get; set; }
    public String NombreTitular { get; set; }
    public String NumeroCaso { get; set; }

    public String valorTipoRequerimiento {get; set;}
    public String Panel {get; set;}
    public String Titulo {get; set;}
    public String ErrorValidacion {get; set;}
    public String ErrorCreacion {get; set;}

    public String ID_CASO {get; set;}

    public String Perfil_JefaturaColectivo_Id = [SELECT Id FROM Profile WHERE Name = 'Jefatura Colectivos'].Id;
    public String Perfil_EjecutivaColectivoUR_Id = [SELECT Id FROM Profile WHERE Name = 'Ejecutiva Colectivo - UR'].Id;
    public String Perfil_JefaturaComercialColectivo_Id = [SELECT Id FROM Profile WHERE Name = 'Jefatura Comercial Colectivo'].Id;

    public Boolean ReclamoOpcion { get; set;}

    public Boolean Es_Protocolo {get; set;}

    public Boolean Ckeck_Protocolo {get; set;}

    public void VerificaProtocolo_Concepto()
    {
        String perfilesProtocolo = CLS_OBJ_Parameter.GetValue('PROTOCOLO_ATENCION_PERFILES');

        String[] listadoPerfiles = perfilesProtocolo.split('\\|');

        String perfilUsuario = [SELECT Name FROM Profile WHERE Id =:  UserInfo.getProfileId()].Name;

        if (listadoPerfiles.contains(perfilUsuario))
        {
            String tipificacionesProtocolo = CLS_OBJ_Parameter.GetValue('PROTOCOLO_ATENCION_CONCEPTOS');

            String[] listadoTipificaciones = tipificacionesProtocolo.split('\\|');

            if (listadoTipificaciones.contains(this.CASO_Hijo.Concepto__c) == true)
            {
                this.Es_Protocolo = true;
                this.CASO_Hijo.Es_Protocolo__c = true;
                this.Ckeck_Protocolo = true;
            }
            else {
                this.Es_Protocolo = false;
                this.CASO_Hijo.Es_Protocolo__c = false;
                this.CASO_Hijo.Protocolo_Envio_Informacion__c = '';
                this.Ckeck_Protocolo = false;
            }
        }
        else {
            this.Es_Protocolo = false;
            this.CASO_Hijo.Es_Protocolo__c = false;
            this.CASO_Hijo.Protocolo_Envio_Informacion__c = '';
            this.Ckeck_Protocolo = false;
        }
    }

    public void Protocolo_Ckeck()
    {
       if (this.CASO_Hijo.Es_Protocolo__c == true)
       {
           this.Ckeck_Protocolo = true;
       }
       else {
           this.Ckeck_Protocolo = false;
           this.CASO_Hijo.Protocolo_Envio_Informacion__c = '';
       }
    }

    //Método de carga página VF
    public PageReference RecuperarIDCasoPrincipal(){
        try{
            ID_CasoPrincipal = ApexPages.CurrentPage().getParameters().get('idCaso');

            CASO_Hijo = new Case();
            System.debug('@@@@@@@@@@@@@@ poliza 0'+ ID_Cuenta );
    		return null;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR => ' + ex));
            return null;
        }
    }

     //Método para procesar página VF correspondiente tipo de requerimiento
    public PageReference OpcionRequerimiento(){
        try{
            this.ErrorCreacion = '';

            List<Case> casos = [SELECT Id, AccountId, Negocio__c,Status from Case where Id=:ID_CasoPrincipal];

            List<RecordType> registros = [SELECT Name FROM RecordType WHERE Id =: IdTipoRegistro];

            System.debug('@@@@@@@@@@@@@@ IdTipoRegistro '+ IdTipoRegistro );
            System.debug('@@@@@@@@@@@@@@ registros '+ registros );
            System.debug('@@@@@@@@@@@@@@ registros size '+ registros.size() );
            if (casos.size() > 0)
            {
                if (registros.size() > 0)
                {
                    if (casos[0].Negocio__c == 'Sin Línea de Negocio (Basura)' || casos[0].Negocio__c == 'Sin Linea de Negocio')
                    {
                        if (registros[0].Name == 'Solicitudes' || registros[0].Name == 'Reclamos')
                        {
                            this.ErrorCreacion = 'ERROR_SIN_LINEA_NEGOCIO';
                        }
                    }

                    if (this.ErrorCreacion == '')
                    {
                        String AnonimoId = [Select Id from Account where Rut__c='99999998'].Id;

                        if (casos[0].AccountId == AnonimoId)
                        {
                            if (registros[0].Name == 'Solicitudes' || registros[0].Name == 'Reclamos')
                            {
                                this.ErrorCreacion = 'ERROR_CUENTA_ANONIMO';
                            }
                        }
                    }
                }
                else
                {
                    this.ErrorCreacion = 'ERROR_TIPO_NOSELEC';
                }
            }

            if (this.ErrorCreacion == '')
            {
                //'Sin Línea de Negocio (Basura)';
                PageReference pagReq = new PageReference('/apex/SEC_VF_NuevoCaso?idCaso=' + ID_CasoPrincipal + '&idRecordType=' + IdTipoRegistro);
                pagReq.setRedirect(true);
                return pagReq;
            }
            else
            {
                return null;
            }
        }catch(System.Exception ex){
            system.debug('@@@@ ERROR SELECCIONAR OPCION REQUERIMINETO => ' + ex);
            return null;
        }
    }

    public PageReference CargaCaso()
    {
        try{
            ID_CasoPrincipal = ApexPages.CurrentPage().getParameters().get('idCaso');
            this.ObtieneParametrosCaso();

			ActualizaFormatoTipoRegistro();
            return null;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR => ' + ex));
            return null;
        }
    }

    //Método de renderizado bloque para datos de caso...
    public PageReference ActualizaFormatoTipoRegistro(){
        try{
            valorTipoRequerimiento = [SELECT Name FROM RecordType WHERE Id =: IdTipoRegistro].Name;
            if(ID_CasoPrincipal != ''){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'ID CASO PRINCIPIPAL => ' + ID_CasoPrincipal));

                CASO_Principal = new Case();

                if (!Test.isRunningTest())
                {
                    CASO_Principal = [SELECT
										Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, SourceId,
                                  		CommunityId, BusinessHoursId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone,
                                  		SuppliedCompany, Type, RecordTypeId, Status, Reason, Origin, Subject, Priority,
                                  		Description, IsClosed, ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate,
                                  		IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                  		SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate,
                                  		LastReferencedDate, MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName,
                                  		Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, Entrega_Respuesta__c,
                                  		Problema__c, Apellidos__c, Atencion_Presencial__c, Canal__c, Cantidad_Dias__c,
                                  		Cargo_Propietario__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c,
                                  		Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c,
                                  		Correo_Electronico__c, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c,
                                  		Descripcion__c, Descripcion_de_Respuesta__c, Detalle_Operacion__c, Detalle_Solicitud__c,
                                  		Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c,
                                  		Direccion_Solicitante__c, Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c,
                                  		Domicilio_Particular_Completo__c, Email_1__c, Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c,
                                  		Fecha_de_nacimiento__c, Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c,
                                  		Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, Nombre_Solicitante__c,
                                  		Nombres__c, Numero_caso_estandar__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c,
                                  		Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c,
                                  		Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c,
                                  		Tipo_Contacto_Final__c, Tipo_Operacion__c, Tipo_de_Solicitante__c, Campa_a_Mailing__c,
                                  		Fecha_Hora_de_Cierre__c, Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c,
                                  		Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, Fecha_de_EPA_Contact_Center_Caso__c,
                                  		Colectivo_Banco_BCI__c, Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c,
                                  		Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, Detalle_de_Rescate__c,
                                  		Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, Cantidad_Dias_Desde_Creacion__c,
                                  		Cumplimiento_Fecha_Cierre__c, Cliente_Compania__c, Carta_Cliente__c,
                                  		Estado_Requerimiento_EscritorioDigital__c, Id_Requerimiento_EscritorioDigital__c,
                                  		Tipo_Requerimiento_EscritorioDigital__c, Genero__c, Anular_aprobacion_reclamo_repetitivo__c,
                                  		Aprobado_Reclamo__c, Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c,
                                  		Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c,
                                  		CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, CASO_Responsable_UR__c,
                                  		Tipo_de_Requerimiento__c, Corredor__c, Protocolo_Envio_Informacion__c, Es_Protocolo__c, Detalle_Configuracion__c, Detalle_Error_de_liquidaci_n__c
                                  FROM
                                  		Case
                                  WHERE
                                  		Id =: ID_CasoPrincipal];
                }

                if(CASO_Principal != null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'CASO PRINCIPAL RECUPERADO...'));
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, String.valueOf(CASO_Principal)));
                    //Nueva instancia de caso
                    Case cHijo1 = new Case();
                    if(valorTipoRequerimiento == 'Solicitudes'){
                        System.debug('@@@@@@@@@@@@ entra en solicitudes...');
                        cHijo1.RecordTypeId = IdTipoRegistro;
                        cHijo1.ParentId = CASO_Principal.Id;
                        chijo1.Negocio__c = CASO_Principal.Negocio__c;
                        NomNegocio = CASO_Principal.Negocio__c;
                        cHijo1.OwnerId = CASO_Principal.OwnerId;
                        cHijo1.AccountId = CASO_Principal.AccountId;
                        cHijo1.ContactId = CASO_Principal.ContactId;
                        cHijo1.Priority = CASO_Principal.Priority;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_Electronico__c;
                        cHijo1.Tipo_de_Solicitante__c = CASO_Principal.Tipo_de_Solicitante__c;
                        cHijo1.Canal__c = CASO_Principal.Canal__c;
                        cHijo1.Origin = CASO_Principal.Origin;
                        cHijo1.Tipo_de_Requerimiento__c = valorTipoRequerimiento;
                        cHijo1.Tipo_de_Cliente__c = CASO_Principal.Tipo_de_Cliente__c;
                        cHijo1.Nombre_Solicitante__c = CASO_Principal.Nombre_Solicitante__c;
                        cHijo1.RUT_Solicitante__c = CASO_Principal.RUT_Solicitante__c;
                        cHijo1.Telefono_Solicitante__c = CASO_Principal.Telefono_Solicitante__c;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_electronico_Solicitante__c;
                        cHijo1.Region_Solicitante__c = CASO_Principal.Region_Solicitante__c;
                        cHijo1.Ciudad_Solicitante__c = CASO_Principal.Ciudad_Solicitante__c;
                        cHijo1.Comuna_Solicitante__c = CASO_Principal.Comuna_Solicitante__c;
                        cHijo1.Direccion_Solicitante__c = CASO_Principal.Direccion_Solicitante__c;
                        /*  sección tipificación	*/
                        cHijo1.Description = Caso_Principal.Description;
                        cHijo1.Problema__c = Caso_Principal.Problema__c;
                        cHijo1.Entrega_Respuesta__c = Caso_Principal.Entrega_Respuesta__c;
                        cHijo1.Fecha_Hora_de_Cierre__c = Caso_Principal.Fecha_Hora_de_Cierre__c;
                        cHijo1.Fecha_Cierre_Tope__c = Caso_Principal.Fecha_Cierre_Tope__c;
                         /* Informacion Requerimiento*/
                        cHijo1.CASO_Categoria__c = caso_principal.CASO_Categoria__c;
                        cHijo1.Detalle_Solicitud__c = caso_principal.Detalle_Solicitud__c;
                        cHijo1.Detalle_Operacion__c = caso_principal.Detalle_Operacion__c;
                        cHijo1.Detalle_Configuracion__c = caso_principal.Detalle_Configuracion__c;
                        //Se agrega detalle error de liquidación
                        cHijo1.Detalle_Error_de_liquidaci_n__c = CASO_Principal.Detalle_Error_de_liquidaci_n__c;
                    }
                    if(valorTipoRequerimiento == 'Reclamos'){

                        cHijo1.RecordTypeId = IdTipoRegistro;
                        cHijo1.ParentId = CASO_Principal.Id;
                        chijo1.Negocio__c = CASO_Principal.Negocio__c;
                        NomNegocio = CASO_Principal.Negocio__c;
                        cHijo1.OwnerId = CASO_Principal.OwnerId;
                        cHijo1.AccountId = CASO_Principal.AccountId;
                        cHijo1.ContactId = CASO_Principal.ContactId;
                        cHijo1.Priority = CASO_Principal.Priority;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_Electronico__c;
                        cHijo1.Tipo_de_Solicitante__c = CASO_Principal.Tipo_de_Solicitante__c;
                        cHijo1.Canal__c = CASO_Principal.Canal__c;
                        cHijo1.Origin = CASO_Principal.Origin;
                        cHijo1.Tipo_de_Requerimiento__c = valorTipoRequerimiento;
                        cHijo1.Tipo_de_Cliente__c = CASO_Principal.Tipo_de_Cliente__c;
                        cHijo1.Nombre_Solicitante__c = CASO_Principal.Nombre_Solicitante__c;
                        cHijo1.RUT_Solicitante__c = CASO_Principal.RUT_Solicitante__c;
                        cHijo1.Telefono_Solicitante__c = CASO_Principal.Telefono_Solicitante__c;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_electronico_Solicitante__c;
                        cHijo1.Region_Solicitante__c = CASO_Principal.Region_Solicitante__c;
                        cHijo1.Ciudad_Solicitante__c = CASO_Principal.Ciudad_Solicitante__c;
                        cHijo1.Comuna_Solicitante__c = CASO_Principal.Comuna_Solicitante__c;
                        cHijo1.Direccion_Solicitante__c = CASO_Principal.Direccion_Solicitante__c;

                        cHIjo1.Problema__c = CASO_Principal.Problema__c;
                        cHijo1.Entrega_Respuesta__c = CASO_Principal.Entrega_Respuesta__c;
                        cHijo1.CASO_N_Poliza__c = CASO_Principal.CASO_N_Poliza__c;
                        cHijo1.Fecha_Hora_de_Cierre__c = CASO_Principal.Fecha_Hora_de_Cierre__c;
                        cHijo1.Description = CASO_Principal.Description;
                        cHijo1.Fecha_Cierre_Tope__c = CASO_Principal.Fecha_Cierre_Tope__c;

						cHijo1.Producto__c = CASO_Principal.Producto__c;
                        cHijo1.Tipo_Operacion__c = CASO_Principal.Tipo_Operacion__c;
                        cHijo1.Detalle_Operacion__c = CASO_Principal.Detalle_Operacion__c;
                        cHIjo1.Complejidad_del_Reclamo__c = CASO_Principal.Complejidad_del_Reclamo__c;
						cHijo1.Fecha_tope_Vida_Security__c = CASO_Principal.Fecha_tope_Vida_Security__c;
                        cHijo1.Numero_de_Caso_Anterior__c = CASO_Principal.Numero_de_Caso_Anterior__c;
                        cHijo1.Instancia_del_Reclamo__c = CASO_Principal.Instancia_del_Reclamo__c;
                        cHijo1.Carta_Cliente__c = CASO_Principal.Carta_Cliente__c;
                        cHijo1.Tipo_de_Resoluci_n_del_Reclamo__c = CASO_Principal.Tipo_de_Resoluci_n_del_Reclamo__c;

                        //Se agrega Corredor 29-08-2018
                        cHijo1.Corredor__c = CASO_Principal.Corredor__c;
                        //Se agrega detalle error de liquidación
                        cHijo1.Detalle_Error_de_liquidaci_n__c = CASO_Principal.Detalle_Error_de_liquidaci_n__c;
                    }
                    if(valorTipoRequerimiento == 'Consultas'){

                        cHijo1.RecordTypeId = IdTipoRegistro;
                        cHijo1.ParentId = CASO_Principal.Id;
                        chijo1.Negocio__c = CASO_Principal.Negocio__c;
                        NomNegocio = CASO_Principal.Negocio__c;
                        cHijo1.OwnerId = CASO_Principal.OwnerId;
                        cHijo1.AccountId = CASO_Principal.AccountId;
                        cHijo1.ContactId = CASO_Principal.ContactId;
                        cHijo1.Priority = CASO_Principal.Priority;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_Electronico__c;
                        cHijo1.Tipo_de_Solicitante__c = CASO_Principal.Tipo_de_Solicitante__c;
                        cHijo1.Canal__c = CASO_Principal.Canal__c;
                        cHijo1.Origin = CASO_Principal.Origin;
                        cHijo1.Tipo_de_Requerimiento__c = valorTipoRequerimiento;
                        cHijo1.Tipo_de_Cliente__c = CASO_Principal.Tipo_de_Cliente__c;
                        cHijo1.Nombre_Solicitante__c = CASO_Principal.Nombre_Solicitante__c;
                        cHijo1.RUT_Solicitante__c = CASO_Principal.RUT_Solicitante__c;
                        cHijo1.Telefono_Solicitante__c = CASO_Principal.Telefono_Solicitante__c;
                        cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_electronico_Solicitante__c;
                        cHijo1.Region_Solicitante__c = CASO_Principal.Region_Solicitante__c;
                        cHijo1.Ciudad_Solicitante__c = CASO_Principal.Ciudad_Solicitante__c;
                        cHijo1.Comuna_Solicitante__c = CASO_Principal.Comuna_Solicitante__c;
                        cHijo1.Direccion_Solicitante__c = CASO_Principal.Direccion_Solicitante__c;
                        cHijo1.Problema__c = CASO_Principal.Problema__c;
                        cHijo1.Entrega_Respuesta__c = CASO_Principal.Entrega_Respuesta__c;
                        cHijo1.CASO_N_Poliza__c = CASO_Principal.CASO_N_Poliza__c;
                        cHijo1.Fecha_Hora_de_Cierre__c = CASO_Principal.Fecha_Hora_de_Cierre__c;
                        cHijo1.Description = CASO_Principal.Description;
                        cHijo1.Fecha_Cierre_Tope__c = CASO_Principal.Fecha_Cierre_Tope__c;

                        cHijo1.Concepto__c = CASO_Principal.Concepto__c;

                        //Se agrega Corredor 29-08-2018
                        cHijo1.Corredor__c = CASO_Principal.Corredor__c;
                    }

                    CASO_Hijo = cHijo1;
                    return null;
                }
                else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'CASO PRINCIPAL NO RECUPERADO...'));
                    return null;
                }
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'SIN ID CASO PRINCIPAL...'));
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR => ' + ex));
            return null;
        }

    }

    public void ObtieneParametrosCaso()
    {
        if (!Test.isRunningTest())
        {
        	this.IdTipoRegistro = ApexPages.CurrentPage().getParameters().get('idRecordType');
        }

        List<Case> lcase = [Select AccountId, RUT__c, Nombre_Completo_Razon_Social__c, CaseNumber From Case Where Id = :this.ID_CasoPrincipal];
        if (lcase.size() > 0)
        {
            this.ID_Cuenta =  lcase[0].AccountId;
            this.RUTTitular = lcase[0].RUT__c;
            this.NombreTitular = lcase[0].Nombre_Completo_Razon_Social__c;
            this.NumeroCaso = lcase[0].CaseNumber;
        }

        this.ValorTipoRequerimiento = [SELECT Name FROM RecordType WHERE Id =: this.IdTipoRegistro].Name;
        if (this.ValorTipoRequerimiento == 'Consultas')
        {
            this.Panel = 'CONSULTA';
            this.Titulo = 'Ingreso de nueva Consulta';
        }
        else if (this.ValorTipoRequerimiento == 'Reclamos')
        {
            this.ReclamoOpcion = true;
            this.Panel = 'RECLAMO';
            this.Titulo = 'Ingreso de nuevo Reclamo';
            User usuario = [SELECT Id, ProfileId FROM User WHERE Id=: UserInfo.getUserId()];

            if (usuario.ProfileId == Perfil_JefaturaColectivo_Id || usuario.ProfileId == Perfil_JefaturaComercialColectivo_Id ||usuario.ProfileId == Perfil_EjecutivaColectivoUR_Id)
            {
                this.ReclamoOpcion = false;
            }
        }
        else if (this.ValorTipoRequerimiento == 'Solicitudes')
        {
            this.Panel = 'SOLICITUD';
            this.Titulo = 'Ingreso de nueva Solicitud';
        }

    }

    //Método para guardar caso nuevo...
    public PageReference guardarCasos(){
        this.ErrorValidacion = 'false';

        if(valorTipoRequerimiento == 'Solicitudes'){
        	if (CASO_Hijo.Detalle_Solicitud__c == null || CASO_Hijo.Detalle_Solicitud__c == '')
            {
                this.ErrorValidacion = 'SOL_NOT_DETSOL';
            }
            else
            {
                if (CASO_Hijo.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial' ||
                    CASO_Hijo.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Patrimonial'||
                    CASO_Hijo.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total' ||
                    CASO_Hijo.Detalle_Solicitud__c == 'Solicitud de Rescate Total' ||
                    CASO_Hijo.Detalle_Solicitud__c == 'Solicitud de Rescate Parcial')
                {
                    if (CASO_Hijo.Detalle_de_Rescate__c  == null || CASO_Hijo.Detalle_de_Rescate__c  == '')
                    {
                        this.ErrorValidacion = 'SOL_NOT_RESSOL';
                    }                    
                }
                else if(CASO_Hijo.Detalle_Solicitud__c == 'Solicitud de suspensión de primas'){
					if((CASO_Hijo.Fecha_de_inicio_de_suspensi_n__c == null && !String.isBlank(CASO_Hijo.Cantidad_de_meses_suspendido__c)) || 
                       (String.isBlank(CASO_Hijo.Cantidad_de_meses_suspendido__c) && CASO_Hijo.Fecha_de_inicio_de_suspensi_n__c != null))
                    {
						this.ErrorValidacion = 'SOL_NOT_MESFCH';
					}
				}
            }

            if (this.ErrorValidacion == 'false')
            {
                CASO_Hijo.Subject = this.GetDetalleSolicitud(CASO_Hijo.Detalle_Solicitud__c);
            }
        }
        else if(valorTipoRequerimiento == 'Consultas'){

            if (CASO_Hijo.Es_Protocolo__c == true && String.isNotBlank(CASO_Hijo.Protocolo_Envio_Informacion__c) == false)
            {
                this.ErrorValidacion = 'CON_NOT_ENV_INF_PRO';
            }

            if (CASO_Hijo.Concepto__c == null || CASO_Hijo.Concepto__c == '')
            {
                this.ErrorValidacion = 'CON_NOT_CON';
            }


            if (this.ErrorValidacion == 'false')
            {
            	CASO_Hijo.Subject = this.GetConcepto(CASO_Hijo.Concepto__c);
            }
        }
        else if(valorTipoRequerimiento == 'Reclamos'){
            if (CASO_Hijo.Detalle_Operacion__c == null || CASO_Hijo.Detalle_Operacion__c == '')
            {
                this.ErrorValidacion = 'REC_NOT_DETOP';
            }

            if (this.ReclamoOpcion == true && this.ErrorValidacion == 'false' && CASO_Hijo.Respuesta_por_Carta__c == false && CASO_Hijo.Respuesta_por_Email__c == false)
            {
                this.ErrorValidacion = 'REC_NOT_RESPONSE';
            }

            if (this.ErrorValidacion == 'false')
            {
            	CASO_Hijo.Subject = this.GetDetalleOperacion(CASO_Hijo.Detalle_Operacion__c);
            }
        }

        if (this.ErrorValidacion == 'false')
        {
            if (this.Poliza != null && this.Poliza != '')
            {
                List<Poliza__c> rts = [Select  Id, Name  From Poliza__c
                                       Where ID =: this.Poliza];

                if(rts.size() > 0){
                    CASO_Hijo.CASO_Poliza_Asoc__c = rts[0].Name;
                    CASO_Hijo.CASO_N_Poliza__c = rts[0].Id;
                }
            }

            try{
                //cHijo1.Tipo_de_Requerimiento__c = valorTipoRequerimiento;
                system.debug('@@@@ CASO GUARDAR => ' + CASO_Hijo);

                insert CASO_Hijo;

                ID_CASO = CASO_Hijo.Id;
                system.debug('@@@@@ ID_CASO => ' + ID_CASO);
            }catch(Exception ex){
                system.debug('@@@@@ ERROR => ' + ex);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR => ' + ex));
            }
        }

        return null;
    }

    //Método para cancelar registro y volver a la selección tipo requerieinto...
    public PageReference cancelarRequerimiento(){
        try{
            PageReference pagIni = new PageReference('/apex/SEC_VF_SeleccionTipoCaso?idCaso=' + ID_CasoPrincipal);
            pagIni.setRedirect(true);
            return pagIni;
        }catch(Exception ex){
            system.debug('@@@@@ ERROR => ' + ex);
            return null;
        }
    }

    //Método para listar valores de tipos de registros para casos...
	public list<SelectOption> getListaTipoRegistro() {
        List<SelectOption> tregistro = new list<SelectOption>();
        tregistro.add(new SelectOption('','-- Ninguno --'));
        for (List<RecordType> rts : [SELECT ID, name
                                     FROM RecordType
                                     WHERE SObjectType = 'Case' AND (DeveloperName = 'Consultas' OR
                                                                     DeveloperName = 'Reclamos' OR
                                                                     DeveloperName = 'Solicitudes') AND
                                           IsActive = true
                                     ORDER BY name]) {
            for (RecordType rt : rts) {
                tregistro.add(new SelectOption(rt.ID, rt.Name));
            }
        }
        return tregistro;
	}

    public list<SelectOption> getListaPolizas() {
        List<SelectOption> tregistro = new list<SelectOption>();

        tregistro.add(new SelectOption('','-- Seleccione Poliza --'));

        if (this.NomNegocio == 'Seguros Colectivos') {
            List<Poliza_Colectivo__c> rts2 = [Select Poliza__c, N_Poliza__c From Poliza_Colectivo__c
                                    Where Cuenta__c =: this.ID_Cuenta
                                    ORDER by N_Poliza__c];

            for (Poliza_Colectivo__c rt : rts2) {
                tregistro.add(new SelectOption(rt.Poliza__c, rt.N_Poliza__c ));
            }

            List<Poliza__c> rts3 = [Select Id, Name, Nombre_de_Producto__c   From Poliza__c
                                        Where Cuenta__c =: this.ID_Cuenta AND RecordType.Name = 'Colectivos'
                                        ORDER by Name];

            for (Poliza__c rt : rts3) {
                    //String etiqueta = ;
                    tregistro.add(new SelectOption(rt.ID, rt.Name));
            }

        }
        else
        {
            List<Poliza__c> rts = [Select Id, Name, Nombre_de_Producto__c   From Poliza__c
                                        Where Cuenta__c =: this.ID_Cuenta
                                        ORDER by Name];

            for (Poliza__c rt : rts) {
                    //String etiqueta = ;
                    tregistro.add(new SelectOption(rt.ID, rt.Name+' - '+rt.Nombre_de_Producto__c ));
            }
        }

        return tregistro;
    }

    public String GetDetalleSolicitud(String solicitud)
    {
        String asunto = '';

        if(solicitud == 'Declaración Ingresos Actualización')
        {
            asunto = 'ED - Renovación de Asignación Familiar';
        }
        else if(solicitud == 'Renuncia Garantía Estatal')
        {
            asunto = 'ED - Renuncia Garantía Estatal';
        }
        else if(solicitud == 'Solicitud cambio pago pensión')
        {
            asunto = 'ED - Solicitud cambio pago pensión';
        }
        else if(solicitud == 'Solicitud cuota mortuoria')
        {
            asunto = 'ED - Solicitud cuota mortuoria';
        }
        else if(solicitud == 'Solicitud de incorporación/ Renovación asignación familiar')
        {
            asunto = 'ED - Solicitud de Asignación Familiar';
        }
        else if(solicitud == 'Solicitud de Extinción')
        {
            asunto = 'ED - Solicitud de Extinción Asignación Familiar';
        }
        else if(solicitud == 'Solicitud garantía estatal')
        {
            asunto = 'ED - Solicitud garantía estatal';
        }
        else if(solicitud == 'Solicitud pensión sobrevivencia')
        {
            asunto = 'ED - Solicitud pensión sobrevivencia';
        }
        else if(solicitud == 'Solicitud periodo garantizado')
        {
            asunto = 'ED - Solicitud periodo garantizado';
        }
        else if(solicitud == 'Sitio web')
        {
            asunto = 'Sitio web (error o problema)';
        }
        else if(solicitud == 'Siniestro Tradicional Vida COL')
        {
            asunto = 'Siniestro Tradicional Vida';
        }
        else if(solicitud == 'Solicitud endoso')
        {
            asunto = 'Solicitud endoso a la póliza';
        }
        else if(solicitud == 'Solicitud cambio CCAF')
        {
            asunto = 'Solicitud cambio CCAF (Caja Compensación)';
        }
        else if(solicitud == 'Solicitud CCAF')
        {
            asunto = 'Solicitud CCAF (Caja Compensación)';
        }
        else if(solicitud == 'Solicitud de problema con Traspaso In')
        {
            asunto = 'Solicitud de problema con Traspaso In (Entrada)';
        }
        else if(solicitud == 'ED - Solicitud de Rescate Patrimonial')
        {
            asunto = 'Solicitud de Rescate Patrimonial';
        }
        else if(solicitud == 'Solicitud eliminar empleados de planilla (PF-APV)')
        {
            asunto = 'Solicitud eliminar empleados de planilla';
        }
        else if(solicitud == 'Endosos')
        {
            asunto = 'Solicitud Endoso';
        }
        else if(solicitud == 'Solicitud endoso')
        {
            asunto = 'Solicitud endoso a la póliza';
        }
        else if(solicitud == 'Solicitud nuevo FUN')
        {
            asunto = 'ED - Solicitud nuevo FUN';
        }
        else if(solicitud == 'Solicitud préstamo')
        {
            asunto = 'Solicitud préstamo (CDS)';
        }
        else if(solicitud == 'Solicitud valores garantizados')
        {
            asunto = 'Solicitud valores garantizados (CDS)';
        }
        else if(solicitud == 'Solicitud Otros Endosos')
        {
            asunto = 'ED - Solicitud Otros Endosos';
        }
        else if(solicitud == 'ED - Endoso Aumento de Prima en Exceso')
        {
            asunto = 'ED - Endoso Modificacion de Prima en Exceso';
        }
        else if(solicitud == 'ED - Endoso Agregar Coberturas')
        {
            asunto = 'ED - Endoso Agregar Cobertura';
        }
        else if(solicitud == 'ED - Endoso Eliminar Coberturas')
        {
            asunto = 'ED - Endoso Eliminar Cobertura';
        }
        else if(solicitud == 'ED - Modificación de Tipo de Pago')
        {
            asunto = 'ED - Modificación de Tipo de Pago PAC o PAT';
        }

        if (asunto == '')
        {
            asunto = solicitud;
        }

        return asunto;
    }

    public String GetDetalleOperacion(String solicitud)
    {
        String asunto = '';

        if (asunto == '')
        {
            asunto = solicitud;
        }

        return asunto;
    }

    public String GetConcepto(String concepto)
    {
        String asunto = '';

        if (asunto == '')
        {
            asunto = concepto;
        }

        return asunto;
    }
}