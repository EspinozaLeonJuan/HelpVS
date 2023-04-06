/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 12-09-2021
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CTR_CS_EscritorioDigital {

    public Case Caso {get; set;}

    public String  TipoRequerimientoED { get; set; }

    public String  Solicitante { get; set; }

    public String  Solicitud { get; set; }

    public String  Botonera { get; set; }

    public Integer IdRequerimiento { get; set; }

    public Integer NumPoliza { get; set; }

    public Integer Persistencia { get; set; }
    public String  RutUsuario { get; set; }
    public String  UserOS { get; set; }
    public String  Ip { get; set; }

    public CLS_EscritorioDigital_Consume.Respuesta_Persistencia RespuestaPersistencia {get; set;}
    public CLS_EscritorioDigital_Consume.Respuesta_Requerimiento RespuestaRequerimiento {get; set;}
    public CLS_EscritorioDigital_Internal.Usuario Usuario {get; set;}

    public String Operation {get; set;}

    public CTR_CS_EscritorioDigital() {

    }

    public Pagereference CargaCaso()
    {
        try{
            String IDCASO = apexpages.currentpage().getparameters().get('id');

            if(IDCASO != '')
            {
                this.Caso = new Case();
                this.Operation = '';
                this.NumPoliza = 0;
              
                this.Caso = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c, Status,
                             Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, CaseNumber, Tipo_de_Requerimiento__c, CASO_Responsable_UR__c, CASO_N_Poliza__c,
                             Negocio__c, CASO_Categoria__c FROM Case WHERE Id =: IDCASO];
              
                system.debug('@@@@ CASO ==>'+this.Caso);

                this.Solicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);
                
                if (Test.isRunningTest())
                {
                    this.Solicitud = 'S';
                }

                if(String.isNotBlank(this.Caso.CASO_Poliza_Asoc__c))
                {
                    this.NumPoliza = Integer.valueOf(this.Caso.CASO_Poliza_Asoc__c);
                }


                system.debug('@@@@ EtiquetaSolicitud ==>'+this.Solicitud);
                system.debug('@@@@ UserInfo ==>'+ UserInfo.getUserId());

                if (this.Solicitud != '')
                {
                    Usuario = CLS_EscritorioDigital_Internal.CargaDatosUsuario(UserInfo.getUserId());

                    this.RutUsuario = Usuario.RUT;
                    this.Ip = Usuario.Ip;
                    this.UserOS = Usuario.UserOS;

                    if (this.RutUsuario == '16942371-7')//problema con usuario Evelyn Estay
                    {
                        this.RutUsuario = '14343349-8';//RUT usuario Pamela Tirapegui
                    }
                }
                else
                {
                    this.Operation = 'NOT_SUPPORT';
                }

                if (String.isBlank(this.Operation))
                {
                    if (String.isNotBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c))
                    {
                        this.IdRequerimiento = Integer.valueOf(this.Caso.Id_Requerimiento_EscritorioDigital__c);
                        String tipo = this.Caso.Tipo_Requerimiento_EscritorioDigital__c;
                        this.Solicitante = CLS_EscritorioDigital_Internal.Solicitante(tipo);

                        this.Operation = 'VIEW';

                        if (this.Caso.Status == 'Cerrado' || this.Caso.Status == 'Rechazado' || this.Caso.Status == 'Back Office' ||
                        (this.Caso.Status == 'En Proceso' && String.isNotBlank(this.Caso.CASO_Responsable_UR__c)))
                        {
                            this.Botonera = 'NO';
                        }
                    }
                    else
                    {
                        this.Operation = 'NEW';
                    }
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
            }
       }catch (Exception ex)
       {
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            ApexPages.addMessages(ex);
       }

       return null;
    }

    public Pagereference CargaCaso_Error()
    {
        try{
            String IDCASO = apexpages.currentpage().getparameters().get('id');
            String errorResponse = apexpages.currentpage().getparameters().get('Error');

            if(IDCASO != '')
            {
                this.Caso = new Case();
                this.Operation = '';
                this.NumPoliza = 0;

                this.Caso = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c, Status,
                                    Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, CaseNumber, Tipo_de_Requerimiento__c, CASO_Responsable_UR__c, CASO_N_Poliza__c,
                                    Negocio__c, CASO_Categoria__c FROM Case
                                    WHERE Id =: IDCASO];
                
                system.debug('@@@@ CASO ==>'+this.Caso);

                this.Solicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);

                String message = generaMensaje(errorResponse);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
            }
       }catch (Exception ex)
       {
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            ApexPages.addMessages(ex);
       }

       return null;
    }

    public List<SelectOption> getListaSolicitantes() {
        return CLS_EscritorioDigital_Internal.getListaSolicitantes(this.Caso.Detalle_Solicitud__c);
    }

    public PageReference crearRequerimiento() {

      /*  this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.userOS, this.ip);
        this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

        RespuestaRequerimiento = new CLS_EscritorioDigital_Consume.Respuesta_Requerimiento();
        RespuestaRequerimiento.Response = 'REQUERIMIENTO_CREADO';
        RespuestaRequerimiento.IdRequerimiento = 80346;

        Caso.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;
        Caso.Id_Requerimiento_EscritorioDigital__c = String.valueOf(RespuestaRequerimiento.IdRequerimiento);
        this.IdRequerimiento = RespuestaRequerimiento.IdRequerimiento;

        Update Caso;

        return null;*/

        if (!Test.isRunningTest())
        {
            this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.userOS, this.ip);
        }
        else
        {
            this.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
            this.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        }

        if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_OK')
        {
            this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

            system.debug('@@@@ this.Persistencia  --> '+this.Persistencia);
            system.debug('@@@@ this.Caso.RUT__c --> '+this.Caso.RUT__c);
            system.debug('@@@@ this.NumPoliza  --> '+this.NumPoliza);
            system.debug('@@@@ this.TipoRequerimientoED  --> '+this.TipoRequerimientoED);
            system.debug('@@@@ this.RutUsuario  --> '+this.RutUsuario);

            if (!Test.isRunningTest())
        	{
                RespuestaRequerimiento = CLS_EscritorioDigital_Consume.crearRequerimiento(this.Persistencia, this.Caso.RUT__c, Integer.valueOf(this.NumPoliza), this.TipoRequerimientoED, this.RutUsuario);
        	}
            else {
                RespuestaRequerimiento = new CLS_EscritorioDigital_Consume.Respuesta_Requerimiento();
                RespuestaRequerimiento.Response = 'REQUERIMIENTO_CREADO';
                RespuestaRequerimiento.IdRequerimiento = 221;
            }

            system.debug('@@@@ RespuestaRequerimiento --> '+ RespuestaRequerimiento);

            if (RespuestaRequerimiento.Response == 'REQUERIMIENTO_CREADO')
            {
                Caso.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;
                Caso.Id_Requerimiento_EscritorioDigital__c = String.valueOf(RespuestaRequerimiento.IdRequerimiento);
                this.IdRequerimiento = RespuestaRequerimiento.IdRequerimiento;

                if (!Test.isRunningTest())
        		{
                     Update Caso;
            	}

                return null;
            }
            else
            {
                String error = RespuestaRequerimiento.Response;
                PageReference page = new PageReference ('/apex/SEC_VF_CS_EscritorioDigital_Error?Id='+ this.Caso.Id);
                page.getParameters().put('Error', error);
                page.setRedirect(true);
                return page;
            }
        }
        else
        {
            String error = RespuestaRequerimiento.Response;
            PageReference page = new PageReference ('/apex/SEC_VF_CS_EscritorioDigital_Error?Id='+ this.Caso.Id);
            page.getParameters().put('Error', error);
            page.setRedirect(true);
            return page;
        }
    }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }

    private String generaMensaje(String errorResponse)
    {
        String mensaje = '';
        system.debug('@@@@ errorResponse --> '+ errorResponse);

        if (errorResponse == 'RUT_CLIENTE_NO_CORRESPONDE')
        {
            mensaje = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún Asegurado registrado.';
        }
        else if (errorResponse == 'RUT_CLIENTE_SIN_BENEFICIARIOS')
        {
            mensaje = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';
        }
        else if (errorResponse == 'POLIZA_OBSOLETA')
        {
            mensaje = 'La Poliza ingresada se encuentra obsoleta.';
        }
        else if (errorResponse == 'POLIZA_NO_INGRESADA')
        {
            mensaje = 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.';
        }
        else if (errorResponse == 'CLIENTE_SIN_POLIZAS_ACTIVAS')
        {
            mensaje = 'El Cliente ingresado no posee una Poliza activa.';
        }
        else if (errorResponse == 'POLIZA_NO_CORRESPONDE')
        {
            mensaje = 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.';
        }
        else if (errorResponse == 'CREA_REQUERIMIENTO_EXCEPCION')
        {
            mensaje = 'Ha ocurrido un error inesperado en la Creación del Requerimiento, favor intente nuevamente. Si el error continua favor comuniquese con los administradores del Sistema.';
        }
        else if (errorResponse == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse== 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse == 'PERSISTENCIA_EXCEPCION')
        {
            mensaje = 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.';
        }
        else if (errorResponse == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO')
        {
            mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.';
        }
        else if (errorResponse == 'REQUERIMIENTO_NO_APV')
        {
            mensaje = 'El Requerimiento no está habilitado para productos APV.';
        }
        else if (errorResponse == 'REQUERIMIENTO_MAX_3')
        {
            mensaje = 'El Requerimiento está habilitado solo para MAX 3.0';
        }
        else if (errorResponse == 'REQUERIMIENTO_MI_SEGURO')
        {
            mensaje = 'El Requerimiento está habilitado solo para productos Mi Seguro.';
        }
        else if (errorResponse == 'REQUERIMIENTO_NO_SOPORTADO')
        {
            mensaje = 'La Solicitud asociada al Requerimiento no es soportada por Escritorio Digital.';
        }
        else if (errorResponse == 'REQUERIMIENTO_CERO')
        {
            mensaje = 'Ha ocurrido un Error creando el Requerimiento en Escritorio Digital, favor adjuntar el o los documentos asociados al Requerimiento al Caso Salesforce creado.';
        }

        return mensaje;
    }

    public PageReference verRequerimiento()
    {
        if (!Test.isRunningTest())
        {
            this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.userOS, this.ip);
        }
		else
        {
            this.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
			this.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO';
        }

        if (this.RespuestaPersistencia.Response != 'PERSISTENCIA_OK')
        {
            PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);
         	page.getParameters().put('Error', this.RespuestaPersistencia.Response);

            return page;
        }

        this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

        return null;
    }

    public PageReference eliminarRequerimiento()
    {
        system.debug('@@@@ CASO ==>'+this.Caso);
        this.Caso.Id_Requerimiento_EscritorioDigital__c = '';
        this.Caso.Tipo_Requerimiento_EscritorioDigital__c = '';
        system.debug('@@@@ CASO UPD ==>'+this.Caso);
        update this.Caso;

        return null;
    }
}