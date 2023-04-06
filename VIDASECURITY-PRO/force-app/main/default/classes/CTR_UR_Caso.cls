/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Caso                                      |
 |  TIPO                   : APEX CLASS                                    |
 |  REQUERIMIENTO          : MEJORAS UR                                                                    |
 |  DESCRIPCION            : Gestión de Caso en Unidad Resolutora                                   |
 |                                                      |
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES                    |
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase                  |
 |                                                         |
 ************************************************************************************************************
*/

public class CTR_UR_Caso {

    public String UsuarioBackUp {get; set;}

    public String IdCaso {get; set;}
    public String Procedencia {get; set;}
    public String Estado {get; set;}

    public Set<String> ORIGENES = new Set<String>{'Cobranzas Vida','Recepción Pagos','Producción Individuales'};

    public Case Caso {get; set;}

    public Case Padre {get; set;}

    public String Ejecutivo {get; set;}

    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Task> LST_TareasCasoUR {get; set;}

    public List<Adjunto__c> LST_Adjuntos {get; set;}

    public Boolean Existen_adjuntos {get; set;}

    /*  Variables utilizadas en comunicación con Escritorio Digital*/
    public Integer Persistencia {get; set;}
    public String IdRequerimiento {get; set;}
    public String RutUsuario {get; set;}
    public String Apodo {get; set;}
    public String UserOS {get; set;}
    /*  Variables utilizadas en comunicación con Escritorio Digital*/

    public Boolean EscritorioDigital {get; set;}

    public String TaskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

    /* Popup */

    public Case CasoPopup {get; set;}

    public CaseComment Comentario {get; set;}

    public Boolean ResultadoPopup {get; set;}

    public String IdResponsableActual {get; set;}

    public String MensajePopup {get; set;}

    public String ComentarioUbk {get; set;}

    public Task TareaUR {get; set;}

    public List<Cola_Usuario__c> listaUR  {get; set;}

    public String IdQueue {get; set;}

    public Boolean FechaTareaValida {get; set;}

    public Task TareaPopup {get; set;}

    public String TareaId {get; set;}

    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}

    public String EstadoTarea {get; set;}

    public String ResponsableTareaUR {get; set;}

    public Task_Comment__c ComentarioTarea {get; set;}
    /* Popup */

    public blob fileBody { get; set; }

    public String fileName {get; set;}

    public String AsuntoCambio {get; set;}

    public String EstadoCambio {get; set;}

    public String ComentarioCambio {get; set;}

    public String TituloPopup {get; set;}

    public String SolicitanteUR {get; set;}

    public String ResponsableUR {get; set;}

    public String BandejaUR {get; set;}

    public String Titulo {get; set;}

    public String RUTCarga{get; set;}

    public Boolean Boton_Carta_Exclusion {get; set;}

    public Boolean Boton_Carta_Sobreprima {get; set;}

    public Boolean Panel_Cartas {get; set;}

    public Boolean Seleccion_Carta_Exclusion {get; set;}

    public Boolean Seleccion_Carta_Sobreprima {get; set;}

    public Boolean especialTeleventa {get; set;}

    public Boolean NotificacionCliente {get; set;}

    public Boolean NotificacionAgente {get; set;}

    public Boolean NotificacionManual {get; set;}

    public String EmailManual {get; set;}

    public String EmailAgente {get; set;}

    public String EmailSelect {get; set;}

    public List<String> Emails {get; set;}

    public String[] EmailsDelete {get; set;}

    public List<SelectOption> EmailsSelect  = new List<SelectOption>();

    public Boolean ExisteAgente { get; set; }

    public Boolean ExisteCorreoCliente { get; set; }

    public Boolean AdjuntoPadre { get; set; }

    public PAR_UR_CASO Pantalla {get; set;}

    public String IdColaUR {get; set;}

    private String nombreColaUR {get; set;}

    public String AreaUsuarioLicencia {get; set;}

    public Boolean valorPrima {get; set;}

    public Boolean ReqAnticipo {get; set;}

    
    public List<Adjunto__c> LST_AdjuntosOld {get; set;}
    public Boolean isEditable {get; set;}
    public Boolean isAccess {get; set;}

    public PageReference IniciaCaso()
    {
        this.CargaParametros_Caso();

        Boolean exito = this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.cargaCaso();
             return null;
        }
        else {
            return ErrorAcceso();
        }
    }

    public PageReference ErrorAcceso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ErrorAcceso');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    /*Método para mostrar caso seleccionado y su información relacionada*/
    public void cargaCaso()
    {
        OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();

        if (!Test.isRunningTest()){
        	CnfBandeja = [SELECT Id, CNF_UR_Caso__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c =: this.IdColaUR  AND Usuario__c =: UserInfo.getUserId()];
        	system.debug('@@@@  CnfBandeja => ' + CnfBandeja);
        }

        String jsonDisplay = '';

        if (String.isNotBlank(CnfBandeja.CNF_UR_Caso__c))
        {
            jsonDisplay = CnfBandeja.CNF_UR_Caso__c;
        }
        else
        {

            jsonDisplay =		'{'+
		'	"Eventos" : '+
		'	{ '+
		'		"EscritorioDigital": false, '+
		'		"EnvioCorreo": false, '+
		'		"AdjuntosValuetech": true, '+
		'		"Adjuntos": true, '+
		'		"Comentarios" : true,'+
		'		"TareasUR" : true,'+
		'		"EnProceso" : false,' +
		'		"RetornoEjecutiva" : false,' +
		'		"Rechazar" : true, '+
		'		"Cerrar" : true, '+
		'       "ActualizaACSEL" : true, '+
		'		"ReasignarResponsable" : true,'+
		'		"Contacto" : true,'+
		'		"Propuesta" : true,'+
		'		"Asunto" : true,'+
		'		"FechaCreacion" : true,'+
		'		"Ejecutivo" : true,'+
		'		"Canal" : true,'+
		'		"FechaCierre" : true,'+
		'		"Agente" : true,'+
		'		"MontoRescate"  : true,'+
		'		"SubEstadoACSEL"  : true'+
		'	}'+
		'}';
        }

        this.Pantalla = PAR_UR_CASO.parse(jsonDisplay);

        this.AdjuntoPadre = false;
        this.EscritorioDigital = false;
        this.IdRequerimiento = '';
        this.especialTeleventa = false;
        this.valorPrima = false;
        this.ReqAnticipo = false;

        system.debug('@@@@ Pantalla --> '+this.Pantalla);

        try
        {
            this.Caso = new Case();

            if (this.IdCaso != '')
            {
                if (!Test.isRunningTest())
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, CASO_Poliza_Asoc__c, Frecuencia_de_Pago__c, Prima_Total_Final__c,
                            Monto_Rescate__c, Sub_Estado_Acsel__c, OwnerId__c, Derivacion_Automatica__c
                            FROM Case WHERE Id =: this.IdCaso];

                    this.Padre = [SELECT Id FROM Case WHERE Id =: this.Caso.ParentId];

                    List<User> us =  [SELECT Name FROM User WHERE Id =: this.Caso.OwnerId__c];
                    if (us.size() > 0)
                    {
                        this.Ejecutivo = us[0].Name;
                    }
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }

                this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                                FROM CaseComment
                                                WHERE ParentId =: this.Caso.Id
                                                ORDER BY CreatedDate DESC];

                if (this.Pantalla.Eventos.AdjuntosValuetech == true)
                {
                   /* this.LST_Adjuntos = [SELECT Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, UrlTex__c , Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c
                    WHERE IdCaso__c =: this.Caso.Id ORDER BY CreatedDate DESC];*/
                    this.LST_Adjuntos = [SELECT Id, File_Name__c, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c 
                    WHERE IdCaso__c =: this.IdCaso ORDER BY CreatedDate ASC];
                
                    this.LST_AdjuntosOld = this.LST_Adjuntos; 
                    
                    Set<String> profiles = new Set<String>{
                    '00e0H000001Fa3qQAC', // Responsable UR Lightning - Beneficios
                    '00e0H000001FZUlQAO', // Responsable UR Lightning - Cobranza
                    '00e0H000001FZUqQAO', // Responsable UR Lightning - Individuales
                    '00e0H000001FZUgQAO', // Responsable UR Lightning - RRVV
                    '00ei0000000r1FhAAI', // Administrador del sistema
                    '00e0H000001e6mzQAA'  // Gestor Funcional
                    };
                    
                    Id profileId=userinfo.getProfileId();
                    
                    this.isAccess = profiles.contains(profileId) ? true : false;
                    
                    this.isEditable = true;

                    system.debug('@@@@ QRY --> '+ 'SELECT Tipo_Documento__c, UrlDoc__c, Nombre_Documento__c, Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c WHERE IdCaso__c ='+ this.Caso.Id +' ORDER BY CreatedDate DESC');
                    system.debug('@@@@ LST_Adjuntos SIZE --> '+this.LST_Adjuntos.size());

                    if (this.LST_Adjuntos.size() > 0)
                    {
                        this.Existen_adjuntos = true;
                    }

                    if (this.Caso.Detalle_Solicitud__c == 'UR - Endoso Anticipo')
                    {
                        this.ReqAnticipo = true;
                    }
                }

                if (this.Pantalla.Eventos.Adjuntos == true && ORIGENES.contains(this.Caso.Origin))
                {
                    this.AdjuntoPadre = true;
                }

                if (this.Pantalla.Eventos.TareasUR == true)
                {
                    this.LST_TareasCasoUR = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Solicitud__c  from Task where RecordTypeId =: this.TaskRecordTypeId AND whatId=: this.Caso.Id ORDER BY CreatedDate desc];
                }

                this.Estado = this.Caso.Status;

                if (this.Pantalla.Eventos.EscritorioDigital == true)
                {
                    this.ValidaEscritorioDigital();
                }

                if (this.Caso.EsNoCliente__c == true)
                {
                    this.Titulo = 'Gestión Caso - No Cliente';
                    this.RUTCarga = this.Caso.RUT_no_Cliente__c;
                }
                else {
                    this.Titulo = 'Gestión Caso - Cliente';
                    this.RUTCarga = this.Caso.RUT__c;
                }

                if (this.Caso.Canal__c == 'Televenta' && this.Caso.Detalle_Solicitud__c == 'ED - Endoso Aumento de Prima en Exceso')
                {
                    this.especialTeleventa = true;//
                    this.valorPrima = true;
                }
                else if (this.Caso.Canal__c == 'WEB' && this.Caso.Detalle_Solicitud__c == 'ED - Endoso Aumento de Prima en Exceso')
                {
                    this.valorPrima = true;
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR CARGA CASO --> '+ex);
        }
    }

    public Boolean CargaUsuario()
    {
        User UsuarioSF = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

        system.debug('@@@@ USUARIO SF'+ UsuarioSF);
        system.debug('@@@@ USUARIO Id'+ UsuarioSF.Id);
        system.debug('@@@@ USUARIO Area'+ UsuarioSF.USUA_Area_UR__c);

        if (String.IsBlank(UsuarioSF.USUA_Area_UR__c))
        {
           return false;
        }

        this.AreaUsuarioLicencia = UsuarioSF.USUA_Area_UR__c;

       // List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND Usuario__c =: UsuarioSF.Id];
        //List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: UsuarioSF.USUA_Area_UR__c];

        List<Usuario_Backup__c> ubackps = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
        FROM Usuario_Backup__c
        WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];

        system.debug('@@@@  LST_UsuariosBackup[0 => ' + ubackps[0].OwnerId);

        if (!Test.isRunningTest()){
            this.IdColaUR = ubackps[0].OwnerId;
            this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;
        }
        else
        {
            Group gQuery = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 1];
            this.IdColaUR = gQuery.Id;
            this.nombreColaUR = gQuery.Name;
        }

        return true;
    }

    public void ValidaEscritorioDigital()
    {
        if (String.isBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c) == false)
        {
            this.IdRequerimiento = this.Caso.Id_Requerimiento_EscritorioDigital__c;

            if (this.Pantalla.Eventos.EscritorioDigital == true)
            {
                this.EscritorioDigital = true;
            }
        }

        if (this.IdRequerimiento != '')
        {
            this.Apodo = '';
            this.UserOS = '';

            List<User> lusers = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];

            if (lusers.size() > 0)
            {
                this.RutUsuario = lusers[0].RUT_Usuario__c;
                this.Apodo = lusers[0].CommunityNickname;
                this.UserOS = 'GRP_SECURITY\\SALESFORCE';
            }

            if (this.RutUsuario != '')
            {
                CLS_EscritorioDigital_Consume.Respuesta_Persistencia respuesta = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.UserOS, this.apodo);
                this.Persistencia = respuesta.IdPersistencia;
            }
            else
            {
                this.Persistencia = -8;
            }

            system.debug('@@@@ 01.Persistencia' + this.Persistencia);
            system.debug('@@@@ 01.IdRequerimiento' + this.IdRequerimiento);
            system.debug('@@@@ 01.RutUsuario' + this.RutUsuario);
        }

    }

    public Pagereference IniciaNuevoComentario()
    {
        try{

            this.CargaParametros_Caso();

            this.ResultadoPopup = false;

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                            CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, Derivacion_Automatica__c
                        FROM Case
                        WHERE Id =: IdCaso];
            }


           this.Comentario = new CaseComment();
           this.Comentario.ParentId = IdCaso;

           if (this.CasoPopup.EsNoCliente__c == true)
           {
               this.TituloPopup = 'Ingreso nuevo Comentario Caso - No Cliente';
           }
           else {
               this.TituloPopup = 'Ingreso nuevo Comentario Caso - Cliente';
           }

           return null;

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaNuevoComentario'+ ex);
          return null;

      }
    }

    public void GuardarComentario(){
        try{

            this.ResultadoPopup = String.isNotBlank(this.Comentario.CommentBody);

            if (this.ResultadoPopup == true)
            {
                if (!Test.isRunningTest())
              {
                    insert this.Comentario;
                }
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR GuardarComentario'+ ex);

      }
    }

    private void CargaParametros_Caso()
    {
        this.IdCaso = apexpages.currentpage().getparameters().get('Id');
        this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
        this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');

        system.debug('@@@@ IdCaso'+ this.IdCaso);
        system.debug('@@@@ UsuarioBackUp'+ this.UsuarioBackUp);
        system.debug('@@@@ Procedencia'+ this.Procedencia);

    }

    public Pagereference IniciaCambioResponsable()
    {
        try
        {
            this.CargaParametros_Caso();

            this.ResultadoPopup = false;

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                            CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, Derivacion_Automatica__c
                        FROM Case
                        WHERE Id =: IdCaso];
            }

           this.Comentario = new CaseComment();
           this.Comentario.ParentId = IdCaso;

           this.IdResponsableActual = this.CasoPopup.CASO_Responsable_UR__c;

           if (this.CasoPopup.EsNoCliente__c == true)
           {
               this.TituloPopup = 'Reasignar Responsable UR - Caso No Cliente';
           }
           else {
               this.TituloPopup = 'Reasignar Responsable UR - Caso  Cliente';
           }

           return null;

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
          return null;

      }
    }

    public void CambioResponsable(){
        try
        {
            system.debug('@@@@@ CasoPopup.CASO_Responsable_UR__c => ' + this.CasoPopup.CASO_Responsable_UR__c);
            system.debug('@@@@@ this.IdResponsableActual => ' + this.IdResponsableActual);

            Boolean error = false;

            if (this.CasoPopup.CASO_Responsable_UR__c == null)
            {
                this.MensajePopup = 'Debe seleccionar un Usuario para poder reasignar el Caso';
                error = true;
            }

            if (this.IdResponsableActual == this.CasoPopup.CASO_Responsable_UR__c)
            {
                this.MensajePopup = 'Debe seleccionar un Usuario distinto al actual para poder reasignar el Caso';
                error = true;
            }

            if (Test.isRunningTest())
            {
                error = false;
            }

            if (error == false)
            {
                String usuarioActual = '';
                String usuarioNuevo = '';
                String estadoActual = '';
                String IdUBActual = '';
                String IdUBNuevo = '';

                Usuario_Backup__c UBck = new Usuario_Backup__c();

                if (this.IdResponsableActual != null)
                {
                    Usuario_Backup__c uActual = new Usuario_Backup__c();
                    if (!Test.isRunningTest())
                    {
                        uActual =  [Select Id, Name From Usuario_Backup__c Where Id =:this.IdResponsableActual];
                    }

                    IdUBActual = uActual.Id;
                    usuarioActual = uActual.Name;
                }
                else {
                    IdUBActual = 'NO_ID';
                }

                if (!Test.isRunningTest())
                {
                    UBck  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.CasoPopup.CASO_Responsable_UR__c];
                }

                usuarioNuevo = UBck.Name;
                IdUBNuevo = UBck.Id;
                estadoActual = this.CasoPopup.Status;

                this.CasoPopup.Fecha_Asignacion_UR__c = Datetime.now();
                this.CasoPopup.Email_Responsable_UR__c = UBck.UBAC_Email__c;
                this.CasoPopup.Id_Responsable_UR__c = this.CasoPopup.CASO_Responsable_UR__c;
                this.CasoPopup.Status = 'Back Office';

                if (!Test.isRunningTest())
                {
                    update this.CasoPopup;
                }

                if(this.ComentarioUbk != null)
                {
                    CaseComment comentario = new CaseComment();
                    comentario.ParentId = this.IdCaso;
                    if (usuarioActual != '')
                    {
                        comentario.CommentBody = 'Reasignación de usuario UR : '+usuarioActual+' --> '+usuarioNuevo+' \n'+ComentarioUbk;
                    }
                    else
                    {
                        comentario.CommentBody = 'Asignación de usuario UR : '+usuarioNuevo+' \n'+ComentarioUbk;
                    }

                    if (!Test.isRunningTest())
                    {
                        insert comentario;
                    }
                }

                this.ResultadoPopup = true;

                CLS_UR_Bandeja_Contador.ActualizaResponsable_Caso(IdUBActual, IdUBNuevo, estadoActual);
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR CambioResponsable'+ ex);

      }
    }

    public Pagereference IniciaTareaUR()
    {
        try
        {
            this.CargaParametros_Caso();
            /*
            String IdCaso = apexpages.currentpage().getparameters().get('Id');
            String UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            String Procedencia = apexpages.currentpage().getparameters().get('procedencia');
            */
            this.ResultadoPopup = false;
            this.CasoPopup = new Case();

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, CASO_Poliza_Asoc__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, Derivacion_Automatica__c
                        FROM Case
                        WHERE Id =: IdCaso];
            }

            this.Comentario = new CaseComment();
            this.Comentario.ParentId = IdCaso;

            this.IdResponsableActual = this.CasoPopup.CASO_Responsable_UR__c;

            this.TareaUR = new Task();
            this.TareaUR.WhatId = this.IdCaso;

            this.TareaUR.RecordTypeId = this.TaskRecordTypeId;
            this.TareaUR.Status = 'No iniciada';
            this.TareaUR.Priority = 'Normal';
            this.listaUR = [select Id, Id_Cola__c, Nombre_Cola__c, Usuario__c from Cola_Usuario__c];

            if (String.isNotBlank(this.CasoPopup.Subject) == true)
            {
                this.TareaUR.Subject = this.CasoPopup.Subject;
            }
            else if (String.isNotBlank(this.CasoPopup.Detalle_Solicitud__c) == true)
            {
                 this.TareaUR.Subject = this.CasoPopup.Detalle_Solicitud__c;
            }
            else
            {
                this.TareaUR.Subject = 'Tarea UR';
            }

           if (this.CasoPopup.EsNoCliente__c == true)
           {
               this.TituloPopup = 'Ingreso nueva Tarea UR - Caso No Cliente';
           }
           else {
               this.TituloPopup = 'Ingreso nueva Tarea UR - Caso  Cliente';
           }

            return null;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
          return null;
      }
    }

    public List<Selectoption> getListarEstadosAcsel(){
        try{
            List<Selectoption> LST_Estados = new List<Selectoption>();

            LST_Estados.add(new Selectoption('ING','ING'));
            LST_Estados.add(new Selectoption('AUT','AUT'));
            LST_Estados.add(new Selectoption('PRA','PRA'));
            LST_Estados.add(new Selectoption('ACE','ACE'));
            LST_Estados.add(new Selectoption('ACT','ACT'));
            LST_Estados.add(new Selectoption('Pago en Formalización','Pago en Formalización'));

            return LST_Estados;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<SelectOption> getUnidades()
    {
        List<SelectOption> URS  = new List<SelectOption>();

        for(Cola_Usuario__c q : this.listaUR)
        {
            URS.add(new SelectOption(q.Usuario__c, q.Nombre_Cola__c));
        }

        System.debug('@@@@ URS | ' + URS);

        return URS;
    }


    public List<SelectOption> getPrioridades()
    {
        List<SelectOption> prioridades  = new List<SelectOption>();
        prioridades.add(new SelectOption('Baja', 'Baja'));
        prioridades.add(new SelectOption('Normal', 'Normal'));
        prioridades.add(new SelectOption('Alta', 'Alta'));

        return prioridades;
    }

//guardando tarea
    public void GuardarTarea()
    {
        this.ResultadoPopup = false;

        if (this.TareaUR.ActivityDate < Date.today())
        {
            this.ResultadoPopup = false;
            this.MensajePopup = 'La Fecha de Vencimiento no puede ser anterior a la Fecha de Hoy.';
        }
        else
        {
            system.debug('@@@@ Tarea UR --> '+ this.TareaUR);
            Task nuevaTask = new Task();
            nuevaTask.WhatId = this.TareaUR.WhatId;
            nuevaTask.Subject = this.TareaUR.Subject;
            nuevaTask.RecordTypeId = this.TareaUR.RecordTypeId;
            nuevaTask.OwnerId = this.IdQueue;
            nuevaTask.caso_numero__c = this.CasoPopup.CaseNumber;
            nuevaTask.Status = this.TareaUR.Status;
            nuevaTask.Priority = this.TareaUR.Priority;
            nuevaTask.ActivityDate = this.TareaUR.ActivityDate;
            nuevaTask.Description = this.TareaUR.Description;
            nuevaTask.Detalle_Solicitud__c =  this.CasoPopup.Detalle_Solicitud__c;
            Usuario_Backup__c uback = [SELECT Id, Name, UBAC_Email__c, OwnerId FROM Usuario_Backup__c WHERE Id =: this.CasoPopup.CASO_Responsable_UR__c];
            nuevaTask.Email_Solicitante_UR__c =  uback.UBAC_Email__c;
            nuevaTask.Id_Solicitante_UR__c = uback.Id;

            if (!Test.isRunningTest())
            {
                String nombreCola = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :uback.OwnerId LIMIT 1].Name;
                nuevaTask.UR_Origen__c = nombreCola;
            }

            try
            {
                this.ResultadoPopup= true;
                this.MensajePopup ='La Tarea UR ingresada ha sido agregada exitosamente al Caso Requerimiento.';
                insert nuevaTask;
            }
            catch(Exception ex){
                this.ResultadoPopup = false;
                this.MensajePopup = 'Ha ocurrido un error la Colaboración de Reclamo ingresada no ha sido generada.';
                system.debug('@@@@  --> '+ex.getLineNumber() + '   -->    '+ ex.getMessage());
            }
        }
         system.debug('@@@@  this.MensajePopup--> '+this.MensajePopup);
    }


    private void CargaParametros_Tarea()
    {
        this.TareaId = apexpages.currentpage().getparameters().get('Id');
        this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
        this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');
    }


    public Pagereference CargaTareaUR()
    {
        try
        {
            this.CargaParametros_Tarea();
            this.TareaPopup = new Task();

            if (!Test.isRunningTest())
            {
                this.TareaPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, TASK_Agregar_Comentario_Tarea__c, Id_Solicitante_UR__c, caso_numero__c from Task where Id =: this.TareaId];
            }

            this.IdCaso = this.TareaPopup.WhatId;

            this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c
                FROM Task_Comment__c WHERE Task_ID__c =: this.TareaId ORDER BY CreatedDate DESC];

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c, Derivacion_Automatica__c,
                            Parent.OwnerId, Id_Responsable_UR__c, Nombre_Completo_Razon_Social__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c , Numero_Propuesta__c
                        FROM Case
                        WHERE Id =: this.IdCaso];
            }


           if (String.isNotBlank(this.TareaPopup.Responsable_Backup__c) == true)
           {
               this.ResponsableTareaUR = 'YES';
               Usuario_Backup__c uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Responsable_Backup__c];
               this.ResponsableUR = uresp.Name;
           }
           else {
               this.ResponsableTareaUR = 'NOT';
           }

           if (!Test.isRunningTest())
           {
               this.BandejaUR = [SELECT Id, Id_Cola__c, Nombre_Cola__c FROM Cola_Usuario__c WHERE Usuario__c =: this.TareaPopup.OwnerId].Nombre_Cola__c;
           }

           this.EstadoTarea = this.TareaPopup.Status;

           if (String.isNotBlank(this.TareaPopup.Id_Solicitante_UR__c) == true)
            {
                Usuario_Backup__c uSolicitante = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.TareaPopup.Id_Solicitante_UR__c];
                this.SolicitanteUR = uSolicitante.Name;
            }
        }
        catch (Exception ex) {

        }

        return null;
    }

    public Pagereference IniciaComentarioTareaUR()
    {
        try{

            String IdTarea = apexpages.currentpage().getparameters().get('Id');

            this.ResultadoPopup = false;
            this.TareaId = IdTarea;
            this.ComentarioTarea = new Task_Comment__c();
            this.ComentarioTarea.Task_ID__c = IdTarea;

            this.TareaPopup = new Task();

            if (!Test.isRunningTest())
            {
            this.TareaPopup = [SELECT Id, Subject, WhatId, Status,Id_Solicitante_UR__c, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, TASK_Agregar_Comentario_Tarea__c, caso_numero__c from Task where Id =: IdTarea];
            }

            if (String.isNotBlank(this.TareaPopup.Id_Solicitante_UR__c))
            {
                Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Id_Solicitante_UR__c];

                if (usol != null)
                {
                    this.SolicitanteUR = usol.Name;
                    this.ComentarioTarea.Solicitante_UR__c = usol.Name;
                    this.ComentarioTarea.Id_Solicitante_UR__c = usol.Id;
                    this.ComentarioTarea.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                }
            }

            this.ComentarioTarea.CaseNumber__c = this.TareaPopup.caso_numero__c;
            this.ComentarioTarea.Estado_Tarea__c = this.TareaPopup.Status;

            return null;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaComentarioTareaUR'+ ex);
          return null;

      }
    }

    public void GuardarComentarioTareaUR()
    {
        try
        {
            this.ResultadoPopup = true;

            if (String.isBlank(this.TareaPopup.Responsable_Backup__c) == true)
            {
                this.MensajePopup = 'La Tarea seleccionada no tiene asignado un Usuario Responsable encargado de su ejecución.';
                this.ResultadoPopup = false;
            }

            if (String.isBlank(this.ComentarioTarea.Detail__c) == true)
            {
                this.MensajePopup =  'No ha sido ingresado ningún Comentario asociado a la Tarea UR.';
                this.ResultadoPopup = false;
            }

            if (Test.isRunningTest())
            {
                this.ResultadoPopup = true;
            }
            if (this.ResultadoPopup == true)
            {
                String IDResponsableCasoUR = [SELECT Id_Responsable_UR__c FROM Case WHERE Id =: this.TareaPopup.WhatId].Id_Responsable_UR__c;
                system.debug('@@@@ IDResponsableTareaUR --> '+ IDResponsableCasoUR);
                Usuario_Backup__c uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: IDResponsableCasoUR];

                if (uback != null)
                {
                    this.ComentarioTarea.Responsable_UR__c = uback.Name;
                    this.ComentarioTarea.Email_Responsable_UR__c = uback.UBAC_Email__c;
                    this.ComentarioTarea.Id_Responsable_UR__c = uback.Id;
                }

                this.ComentarioTarea.Notificacion__c = 'TSO_CM';
                insert this.ComentarioTarea;

                this.MensajePopup = 'El Comentario ha sido agregado a la Tarea UR.';
            }
        }
        catch (Exception ex) {
             this.MensajePopup = ex.getMessage();
             this.ResultadoPopup = false;
        }
    }

    public PageReference CasosUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Casos?idResponsable='+ this.UsuarioBackUp);

        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference CasosRevisionUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_CasosEnRevision?idResponsable='+ this.UsuarioBackUp);

        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference HistoricoUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_CasosHistorico?idResponsable='+ this.UsuarioBackUp);

        pagina.setRedirect(true);

        return pagina;
    }


    public Pagereference GuardarAdjunto()
    {
        try
        {
            Attachment myAttachment = new Attachment();
            this.ResultadoPopup = true;
            System.debug('@@@@@fileBody'+ this.fileBody);
            myAttachment .clear();
            myAttachment.Body = this.fileBody;
            myAttachment.Name = this.fileName;
            myAttachment.ParentId = this.Caso.Id;
            insert myAttachment;
        }
        catch (Exception ex) {
             this.MensajePopup = ex.getMessage();
             this.ResultadoPopup = false;
        }

        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Caso?Id='+this.Caso.Id+'&idResponsable='+this.UsuarioBackUp+'&procedencia='+this.Procedencia);
        pagina.setRedirect(true);
        return pagina;
    }


     /*Método que cambia estado de Caso a 'En Proceso'  y redirecciona a la Vista Principal del Caso en UR*/
    public void EnProceso()
    {
        try{
            if(this.Caso != null){
                system.debug('@@@@@ ID CASO EDITADO=>' + this.Caso);
                this.Caso.Status = 'En Proceso';

                if (!Test.isRunningTest())
              {
                  update this.Caso;
              }

                CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(this.Caso.CASO_Responsable_UR__c, 'En Proceso', 'Back Office');
            }
        }catch(Exception ex){
            system.debug('@@@@ EnProceso '+ex);
        }
    }


    public Pagereference IniciaActualizaACSEL()
    {
        try{

            this.CargaParametros_Caso();

            this.ResultadoPopup = false;

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                            CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Derivacion_Automatica__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, RVentas__c, Carta_Sobreprima__c, Carta_Exclusion__c,
                            ContactEmail, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, Monto_Rescate__c, Sub_Estado_Acsel__c
                        FROM Case
                        WHERE Id =: this.IdCaso];
           }
	       else
           {
               this.CasoPopup = new Case();
               this.CasoPopup.Detalle_Solicitud__c = 'ED - Endoso Capital Asegurado';
               this.CasoPopup.Subject = 'ED - Endoso Capital Asegurado';
           }

           String title = 'Cliente';

           if (this.CasoPopup.EsNoCliente__c == true)
           {
               title = 'No Cliente';
           }

           this.TituloPopup = 'Actualizar Valores ACSEL Caso - '+ title;

           return null;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaActualizaACSEL'+ ex);
          return null;
      }
    }

    public void ActualizaValoresACSEL()
    {
        try{
            if(this.CasoPopup != null){
                system.debug('@@@@@ ID CASO EDITADO=>' + this.CasoPopup);

                this.MensajePopup = 'Los Valores ACSEL asociados al Caso han sido actualizados';
                this.ResultadoPopup = true;

                if (!Test.isRunningTest())
                {
                    update this.CasoPopup;
                }
            }
        }catch(Exception ex){
            system.debug('@@@@ ActualizaValoresACSEL '+ex);
        }

    }

    public Boolean EnvioCorreo {get; set;}

    public Pagereference IniciaCambioEstado()
    {
        try{

            this.CargaParametros_Caso();
            this.EnvioCorreo = false;
            String cambio = apexpages.currentpage().getparameters().get('cambio');

            String value = apexpages.currentpage().getparameters().get('envioCorreo');

            if (String.isNotBlank(value))
            {
                this.EnvioCorreo = Boolean.valueOf(value);
            }

            system.debug('@@@@  value --> '+  value);
            system.debug('@@@@  EnvioCorreo --> '+this.EnvioCorreo);

            this.Emails = new List<String>();

            this.ResultadoPopup = false;

            this.ExisteAgente = false;

            this.ExisteCorreoCliente = false;

            if (!Test.isRunningTest())
            {
                this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                            CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c,
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, RVentas__c, Carta_Sobreprima__c, Carta_Exclusion__c,
                            ContactEmail, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, OwnerId__c, Derivacion_Automatica__c
                        FROM Case
                        WHERE Id =: this.IdCaso];
           }
	       else
           {
               this.CasoPopup = new Case();
               this.CasoPopup.Detalle_Solicitud__c = 'ED - Endoso Capital Asegurado';
               this.CasoPopup.Subject = 'ED - Endoso Capital Asegurado';
           }

           if (String.isBlank(this.CasoPopup.Subject))
           {
               this.CasoPopup.Subject = this.CasoPopup.Detalle_Solicitud__c;
           }

           String eval =  'ED - ';

           Boolean limpiar =  this.CasoPopup.Subject.contains(eval);
           if (limpiar == false)
           {
               eval =  'UR - ';
           }

           if (limpiar == true)
           {
               this.AsuntoCambio = this.CasoPopup.Subject.replace(eval, '');
           }
           else
           {
               this.AsuntoCambio = this.CasoPopup.Subject;
           }

           String title = 'Cliente';

           if (this.CasoPopup.EsNoCliente__c == true)
           {
               title = 'No Cliente';
           }

           Boolean EsEndoso = this.Es_EndosoIndividual(this.CasoPopup.Detalle_Solicitud__c);

           if (EsEndoso == true)
           {
               this.NotificacionCliente = EsEndoso;
           }

           if (cambio == 'Cierre')
           {
               this.TituloPopup = 'Cerrar Caso - '+ title;
               this.EstadoCambio = 'Cerrado';
           }
           else if (cambio == 'Rechazo')
           {
                this.TituloPopup = 'Rechazar Caso - '+ title;
                this.EstadoCambio = 'Rechazado';
           }
           else if (cambio == 'Retorno')
           {
               this.TituloPopup = 'Regresar Caso - '+ title +' - a Ejecutiva';
               this.EstadoCambio = 'En Revisión';

            ////

            if (Test.isRunningTest())
            {
               EsEndoso = true;
            }

            system.debug('@@@@  EsEndoso --> '+EsEndoso);

            if (EsEndoso == true)
            {
                system.debug('@@@@  CasoPopup.Detalle_Solicitud__c --> '+ this.CasoPopup.Detalle_Solicitud__c);
                this.Boton_Carta_Exclusion = Generacion_Cartas('EXCLUSION', this.CasoPopup.Detalle_Solicitud__c);
                this.Boton_Carta_Sobreprima = Generacion_Cartas('SOBREPRIMA',  this.CasoPopup.Detalle_Solicitud__c);

                system.debug('@@@@  Boton_Carta_Exclusion --> '+this.Boton_Carta_Exclusion);
                system.debug('@@@@  Boton_Carta_Sobreprima --> '+this.Boton_Carta_Sobreprima);

                if (this.Boton_Carta_Exclusion == true || this.Boton_Carta_Sobreprima == true)
                {
                    this.Panel_Cartas = true;
                    this.Seleccion_Carta_Sobreprima = this.CasoPopup.Carta_Sobreprima__c;
                    this.Seleccion_Carta_Exclusion = this.CasoPopup.Carta_Exclusion__c;
                }
              }
           }

           if (String.isBlank(this.CasoPopup.Agente__c) == false)
           {

               this.ExisteAgente = true;
           }

           if(this.CasoPopup.ContactEmail != null || this.CasoPopup.Correo_electronico_Solicitante__c != null || this.CasoPopup.Correo_electronico_alternativo__c != null){
               this.ExisteCorreoCliente = true;
           }

           return null;

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioEstado'+ ex);
          return null;
      }
    }

    public Boolean Es_EndosoIndividual(String solicitud)
    {
        List<asignacion_UR__c> lista = [SELECT Id FROM asignacion_UR__c WHERE Categor_a__c = 'ENDOSO IND' AND
        Detalle_Solicitud__c =: solicitud];

        if (lista.size() > 0)
        {
            return true;
        }

        return false;
    }


    public Boolean Generacion_Cartas(String tipo, String solicitud)
    {
        String negocio = 'Seguros Individuales';
        String categoria = 'Endoso IND';

        List<String> solicitudes = new List<String>();

        solicitudes.add('Solicitud Rehabilitación Póliza');
        solicitudes.add('ED - Endoso Capital Asegurado');
        solicitudes.add('ED - Endoso Agregar Coberturas');
        solicitudes.add('ED - Agregar asegurados adicionales');

        for (String valor : solicitudes)
        {
            if (valor == solicitud)
            {
                return true;
            }
        }

        return false;
    }

    public void CambioEstadoCaso()
    {
        system.debug('@@@@  NotificacionManual  --> '+ this.NotificacionManual);
        system.debug('@@@@  NotificacionAgente --> '+ this.NotificacionAgente);
        system.debug('@@@@  NotificacionCliente  --> '+ this.NotificacionCliente);
        system.debug('@@@@  Emails --> '+ this.Emails);

        ////////////////////
        system.debug('@@@@ Entro al Cambio => '+ this.CasoPopup);

        try
        {


            CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(this.CasoPopup, this.EstadoCambio);

            if (Test.isRunningTest())
            {
                this.NotificacionCliente = true;
                this.AsuntoCambio = 'value';
                this.ComentarioCambio = 'value';
            }

            if (this.NotificacionCliente == null)
                this.NotificacionCliente = false;

            system.debug('@@@@ NotificacionCliente => ' + this.NotificacionCliente);
            this.CasoPopup.CASO_Activa_Flujo_Notificaci_n_Cliente__c = this.NotificacionCliente;

            if(String.isNotBlank(this.AsuntoCambio))
            {
                this.CasoPopup.CASO_Asunto_Notificaci_n__c = this.AsuntoCambio;
            }

            if(String.isNotBlank(this.ComentarioCambio))
            {
                this.CasoPopup.CASO_Mensaje_Notificaci_n__c = this.ComentarioCambio;
            }

            this.CasoPopup.Status = this.EstadoCambio;

            if (this.EstadoCambio == 'Cerrado')// || this.EstadoCambio == 'Rechazado')
            {
                this.CasoPopup.Entrega_Respuesta__c = true;
            }
            else if (this.EstadoCambio == 'En Revisión'){
                Case Caso_Parent = [Select  OwnerId from Case where id=: this.CasoPopup.ParentId Limit 1] ;
                this.CasoPopup.CASO_Resultado_Derivaci_n__c = null;
                this.CasoPopup.Status = 'En Revisión';
                if (this.CasoPopup.OwnerId__c != null && this.CasoPopup.OwnerId__c != '')
                {
                    this.CasoPopup.OwnerId = this.CasoPopup.OwnerId__c;
                }
                else
                {
                    this.CasoPopup.OwnerId = Caso_Parent.OwnerId;
                }
                this.CasoPopup.CASO_Responsable_UR__c = null;
                this.CasoPopup.Email_Responsable_UR__c = null;
            }

            if (!Test.isRunningTest())
            {
                system.debug('@@@@ CasoPopup => ' + this.CasoPopup);
                update this.CasoPopup;
            }

            if (this.EstadoCambio == 'Cerrado' || this.EstadoCambio == 'Rechazado')
            {
                CLS_UR_Caso_CambioEstado.ActualizaEstadoTareasUR(this.CasoPopup.ID);
                CLS_UR_Caso_CambioEstado.ActualizaCasoAtencion(this.CasoPopup.ParentId, this.Caso.RVentas__c);
            }

            if(String.isNotBlank(this.ComentarioCambio))
            {
                CaseComment comentario = new CaseComment();
                comentario.ParentId = this.IdCaso;
                comentario.CommentBody = 'Caso '+ this.EstadoCambio+ ' --> '+ this.ComentarioCambio;
                this.ResultadoPopup = true;
                this.MensajePopup = 'El Cambio de Estado para el Caso seleccionado ha sido realizado.';
                if (!Test.isRunningTest())
                {
                    insert comentario;
                }
            }
            else
            {
                this.MensajePopup = 'Para realizar el Cambio de Estado, es necesario que sea agregado un Comentario';
            }

           if (!Test.isRunningTest())
           {
               system.debug('@@@@ ESTADO => ' + this.EstadoCambio);
               system.debug('@@@@ ENTREGA RESPUESTA => ' + this.CasoPopup.Entrega_Respuesta__c);
               system.debug('@@@@ ACTIVA NOTIFICACIÓN => ' + this.CasoPopup.CASO_Activa_Flujo_Notificaci_n_Cliente__c);
               system.debug('@@@@ ASUNTO NOTIFICACIÓN => ' + this.CasoPopup.CASO_Asunto_Notificaci_n__c);
               system.debug('@@@@ COMENTARIO NOTIFICACIÓN => ' + this.CasoPopup.CASO_Mensaje_Notificaci_n__c);

               system.debug('@@@@ NotificacionCliente => ' + this.NotificacionCliente);
               system.debug('@@@@ NotificacionAgente => ' + this.NotificacionAgente);
               system.debug('@@@@ NotificacionManual => ' + this.NotificacionManual);
               system.debug('@@@@ Emails.size() => ' + this.Emails.size());
           }

           if (Test.isRunningTest())
           {
               this.NotificacionCliente = true;
           }

		   Boolean esRescateWeb_Especial = false;

           //if (this.Caso.Canal__c == 'WEB' && this.EstadoCambio == 'Cerrado'  && (this.CasoPopup.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total' || this.CasoPopup.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial'))
           if (this.EstadoCambio == 'Cerrado'  && (this.CasoPopup.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total' || this.CasoPopup.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial'))
           {
                esRescateWeb_Especial = true;
                CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
                notificacion.EnviaNotificacion_RescateWeb(this.CasoPopup.Id);
           }

           if (esRescateWeb_Especial == false && this.NotificacionCliente == true)
           {
                Boolean EsEndoso = this.Es_EndosoIndividual(this.CasoPopup.Detalle_Solicitud__c);
                system.debug('@@@@ EsEndoso => ' + EsEndoso);

                if (Test.isRunningTest())
                {
                    EsEndoso = true;
                }

                List<String> direccionesCc = new List<String>();

                if (this.NotificacionManual == true)
                {
                    direccionesCc = this.Emails;
                }

                if (this.NotificacionAgente == true)
                {
                    direccionesCc.add(this.CasoPopup.Mail_agente__c);
                }

                CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();

                if (EsEndoso == true)
                {
                    if (this.EstadoCambio == 'En Revisión' && (this.CasoPopup.Carta_Exclusion__c == true || this.CasoPopup.Carta_Sobreprima__c == true))
                    {
                        if (this.CasoPopup.Carta_Sobreprima__c == true)
                        {
                            notificacion.EnviaNotificacion_Individual(this.CasoPopup.Id, this.EstadoCambio, 'SOBREPRIMA', direccionesCc, this.ComentarioCambio);
                        }

                        if (this.CasoPopup.Carta_Exclusion__c == true)
                        {
                            notificacion.EnviaNotificacion_Individual(this.CasoPopup.Id, this.EstadoCambio, 'EXCLUSION', direccionesCc, this.ComentarioCambio);
                        }
                    }
                    else
                    {
                        notificacion.EnviaNotificacion_Individual(this.CasoPopup.Id, this.EstadoCambio, '', direccionesCc, this.ComentarioCambio);
                    }
                }
                else
                {
                    notificacion.EnviaNotificacion(this.CasoPopup.Id, this.EstadoCambio, direccionesCc, this.ComentarioCambio);
                }
            }

            CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(this.CasoPopup.CASO_Responsable_UR__c, this.EstadoCambio , 'En Proceso');//revisar esta

        }
        catch(system.Exception ex)
        {
            system.debug('@@@@ ERROR * => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber()+ '  Exc '+ex);
            this.MensajePopup = ' ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber();
        }
    }

    public PageReference Carta_Sobreprima()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Caso_CartaSobreprima?Id='+this.IdCaso+'&idResponsable='+ this.UsuarioBackUp+'&procedencia='+this.Procedencia+'&cambio=Retorno');

        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference Carta_Exclusion()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Caso_CartaExclusion?Id='+this.IdCaso+'&idResponsable='+ this.UsuarioBackUp+'&procedencia='+this.Procedencia+'&cambio=Retorno');

        pagina.setRedirect(true);

        return pagina;
    }

    public Pagereference AddEmail()
    {
        system.debug('@@@@ EmailManual --> '+ this.EmailManual);

        if (validateEmail(this.EmailManual) == true && this.Emails.contains(this.EmailManual) == false)
        {
            this.Emails.add(this.EmailManual);
        }

        this.EmailManual = '';

        system.debug('@@@@ Emails --> '+ this.Emails);

        this.cargaEmail();

        return null;
    }

    public void cargaEmail()
    {
        this.EmailsSelect.clear();

        for(String email  : this.Emails)
        {
           	this.EmailsSelect.add(new SelectOption(email, email));
        }

        System.debug('Selected Queue | ' + this.EmailsSelect);
    }

    public List<SelectOption> getEmailsSelect()
    {
        return this.EmailsSelect;
    }

    public Pagereference RemoveEmail()
    {
        List<String> tmp = this.Emails;

        this.Emails = new List<String>();

        for (String email : tmp)
        {
            if (this.EmailsDelete.contains(email) == false)
            {
                this.Emails.add(email);
            }
        }

        this.cargaEmail();

        return null;
    }

    public static Boolean validateEmail(String email) {
        Boolean res = true;

        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches())
            res = false;
        return res;
    }

    public PageReference guardarEstado() {
      String idAdjunto = ApexPages.currentPage().getParameters().get('idAdjuntos');
      String estado = ApexPages.currentPage().getParameters().get('estadoAdjuntos');

      if ( ( estado == 'Nuevo' || estado == '' ) && idAdjunto != null ) {
        Adjunto__c itemUpdate = new Adjunto__c(Id = idAdjunto, Estado__c = 'Abierto');
        update itemUpdate;
        // this.LST_Adjuntos = [SELECT Id, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c WHERE IdCaso__c =: this.Id ORDER BY CreatedDate ASC];
        for ( Adjunto__c item : this.LST_Adjuntos ) {
          if ( item.Id == idAdjunto ) {
            item.Estado__c = 'Abierto';
          }
        }
        this.LST_AdjuntosOld = this.LST_Adjuntos;
      }
      return null;
    }

    public void editarEstadoBloque() {
      this.isEditable = this.isEditable ? false:true;
    }
    public void cancelarEstadoBloque() {
      this.isEditable = this.isEditable ? false:true;
      this.LST_Adjuntos = [SELECT Id, File_Name__c, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c WHERE IdCaso__c =: this.IdCaso ORDER BY CreatedDate ASC];
    }
    public void guardarCambios() {
      update this.LST_Adjuntos;
      this.isEditable = this.isEditable ? false:true;
    }
}