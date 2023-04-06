/**
 * @File Name          : LinksController.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 01-18-2023
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    6/12/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class LinksController {

    public Id objectId {get; set;}
    public String rutAgente {get; set;}
    public SObject genericSObject {get; set;}

    public LinksController(ApexPages.StandardController controller) {
        this.objectId = Id.valueOf(controller.getId());
        User agente = [SELECT RUT_Usuario__c FROM User WHERE Id = :UserInfo.getUserId()];
        rutAgente = agente.RUT_Usuario__c;
    }

    //migración casos vs a casos sf
    public Case getCasoSF(){
        if (genericSObject != null && ((Case)genericSObject).Id == objectId)
            return (Case)genericSObject;
        genericSObject = [SELECT Id, CaseNumber, Rut__c, Fecha_Cierre_Tope__c, Nombre_Solicitante__c, Region_Solicitante__c,
                          Rut_Solicitante__c, Ciudad_Solicitante__c, Telefono_Solicitante__c,
                          Comuna_Solicitante__c, Correo_electronico_Solicitante__c, Direccion_Solicitante__c,
                          Nombre_Completo_Razon_Social__c, RUT1__c, Contact.Id,
                          Telefono_Particular__c, Domicilio_Particular_Completo__c, Celular__c,
                          Domicilio_Comercial_Completo__c, Correo_Electronico__c, Telefono_Comercial__c,
                          Motivo_de_la_Solicitud__c, Negocio__c, Producto__c, Tipo_Operacion__c,
                          Detalle_Operacion__c, Description, Direccion_envio_respuesta__c,
                          Solicita_envio_a_otra_direccion__c, Descripcion_de_Respuesta__c, Direccion_Postal_Alternativa__c,
                          Correo_electronico_alternativo__c, Detalle_Solicitud__c, Tipo_de_Cliente__c,Fecha_Cierre_Tope_1__c,
                          Canal__c, Concepto__c, Tipo_de_Contacto__c, Linea_Negocio__c, Descripcion__c, Fecha_Hora_de_Cierre__c,
                          Detalle_de_Rescate__c, Tipo_de_Resoluci_n_del_Reclamo__c
                          FROM Case WHERE Id = :objectId LIMIT 1];
        return (Case)genericSObject;
    }

    public Case getCasoEstandar(){
        return getCasoSF();
    }

    public static Integer persistenciaId() {
        System.Pagereference currentPage = System.currentPageReference();
        String browser = 'browser';
        String ip = '1.1.1.1';
        String url = 'Salesforce';
        String referer = 'Salesforce';
        if (currentPage != null) {
            browser = currentPage.getHeaders().get('User-Agent');
            url = currentPage.getUrl();
            referer = currentPage.getHeaders().get('Referer');
            ip = currentPage.getHeaders().get('X-Salesforce-SIP');
        }
        WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
        service.timeout_x = 120000;
        WSAccess.AppInfo appInfo = new WSAccess.AppInfo();
        appInfo.Cup = 'SalesForce';
        appInfo.Option = 0;

        WSAccess.UserInfo userInfo = new WSAccess.UserInfo();
        userInfo.UserName = 'SalesForce';
        userInfo.Password = 'S4l3sForce';
        userInfo.UserOS = 'UsuarioOS';
        userInfo.Ip = ip == null ? '' : ip;
        userInfo.Rut=76749930;
        userInfo.Dv ='2';
        userInfo.PersistCode = 0;

        WSAccess.WebInfo webInfo = new WSAccess.WebInfo();
        webInfo.Browser = browser == null ? '' : browser;
        webInfo.Environment = 'PROD';
        webInfo.GeoLatitude = 0;
        webInfo.GeoLongitude = 0;
        webInfo.InfoMovile = '-';
        webInfo.IsMobile = false;
        webInfo.Method = 'POST';
        webInfo.Parameters = '';
        webInfo.Os = 'SO';
        webInfo.SessionId = '12345678';
        webInfo.Url = url == null ? '' : url;
        webInfo.UrlReferrer = referer == null ? '' : referer;

        WSAccess.AccessInfo accessInfo = new WSAccess.AccessInfo();
        accessInfo.AppInfo = appInfo;
        accessInfo.UserInfo = userInfo;
        accessInfo.WebInfo = webInfo;

        WSAccess.DatoAcceso datoAcceso = null;
        Integer retries = 5;
        for (Integer i=0; i < retries; i++) {
            datoAcceso = service.Login(accessInfo);
            // System.debug('\nMENSAJE:' + datoAcceso.Mensaje);
            //System.debug('\nAcceso Válido: ' + datoAcceso.AccesoValido);
            if (datoAcceso != null)
                return datoAcceso.IdPersistencia;
        }
        return 0;
    }

    public static WSAccess.DatoAcceso persistenciaEjecutivaSimulacion(string rut, string cup) {
        System.Pagereference currentPage = System.currentPageReference();
        String browser = 'browser';
        String ip = '1.1.1.1';
        String url = 'Salesforce';
        String referer = 'Salesforce';
        if (currentPage != null) {
            browser = currentPage.getHeaders().get('User-Agent');
            url = currentPage.getUrl();
            referer = currentPage.getHeaders().get('Referer');
            ip = currentPage.getHeaders().get('X-Salesforce-SIP');
        }
        WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
        service.timeout_x = 120000;
        WSAccess.AppInfo appInfo = new WSAccess.AppInfo();
        appInfo.Cup = cup;
        appInfo.Option = 0;

        WSAccess.UserInfo userInfo = new WSAccess.UserInfo();
        userInfo.UserName = 'SalesForce';
        userInfo.Password = 'S4l3sForce';
        userInfo.UserOS = 'UsuarioOS';
        userInfo.Ip = ip == null ? '' : ip;
        userInfo.Rut=77777777;
        userInfo.Dv ='7';
        userInfo.PersistCode = 0;

        WSAccess.WebInfo webInfo = new WSAccess.WebInfo();
        webInfo.Browser = browser == null ? '' : browser;
        webInfo.Environment = 'PROD';
        webInfo.GeoLatitude = 0;
        webInfo.GeoLongitude = 0;
        webInfo.InfoMovile = '-';
        webInfo.IsMobile = false;
        webInfo.Method = 'POST';
        webInfo.Parameters = '';
        webInfo.Os = 'SO';
        webInfo.SessionId = '12345678';
        webInfo.Url = url == null ? '' : url;
        webInfo.UrlReferrer = referer == null ? '' : referer;

        WSAccess.AccessInfo accessInfo = new WSAccess.AccessInfo();
        accessInfo.AppInfo = appInfo;
        accessInfo.UserInfo = userInfo;
        accessInfo.WebInfo = webInfo;

        WSAccess.DatoAcceso datoAcceso = null;
        Integer retries = 5;
        if (!Test.isRunningTest())
        {
            for (Integer i=0; i < retries; i++) {
            	datoAcceso = service.SimularUsuario(accessInfo, rut);
            	// System.debug('\nMENSAJE:' + datoAcceso.Mensaje);
            	//System.debug('\nAcceso Válido: ' + datoAcceso.AccesoValido);
            	if (datoAcceso != null)
                	return datoAcceso;
       		}
        }

        return null;
    }

    public System.Pagereference linkPoliza(String opcion) {
        Poliza__c poliza = [SELECT Name FROM Poliza__c WHERE Id = :objectId LIMIT 1];
        //String url = 'http://www.vidasecurity.cl/cmsvidasecurity/widgets/crm/popup.aspx?';
        String url = 'http://clientes.vidasecurity.cl/cmsvidasecurity/widgets/crm/popup.aspx?';
        url += 'RUT_AGENTE=' + rutAgente;
        url += '&PERSIST_APP=' + persistenciaId();
        url += '&USERNAME_APP=SalesForce';
        url += '&POLIZA=' + poliza.Name + '&OPCION=' + opcion;
        return new System.Pagereference(url);
    }

    public System.Pagereference aportaCartola() {
        return linkPoliza('CARTOLA');
    }

    public System.Pagereference aportaDatosPoliza() {
        return linkPoliza('DATOSPOLIZA');
    }

    public System.Pagereference aportaEstadoPago() {
        return linkPoliza('ESTADOPAGO');
    }

    public System.Pagereference aportaRentabilidad() {
        return linkPoliza('RENTABILIDAD');
    }

    public System.Pagereference aportaTraslados() {
        return linkPoliza('TRASLADOS');
    }

    public System.Pagereference aportaValoresCuota() {
        return linkPoliza('VALORESCUOTA');
    }

    public System.Pagereference fichaCliente() {
        Account account = [SELECT Rut__c, DV__c FROM Account WHERE Id = :objectId];
        //String url = 'http://www.vidasecurity.cl/cmsvidasecurity/widgets/crm/popup.aspx?';
        String url = 'http://clientes.vidasecurity.cl/cmsvidasecurity/widgets/crm/popup.aspx?';
        url += 'RUT_AGENTE=' + rutAgente;
        url += '&PERSIST_APP=' + persistenciaId();
        url += '&USERNAME_APP=SalesForce';
        url += '&RUT_CLIENTE=' + account.Rut__c + '-' + account.DV__c;
        url += '&OPCION=PRODUCTO';
        system.debug('@@@@ url FichaCliente '+url);
        return new System.Pagereference(url);
    }

    public System.Pagereference rescatesConsulta() {
        // link en CUENTA
        //Case caso = [SELECT Account.Rut__c, Account.DV__c, Detalle_Solicitud__c, RecordTypeId, Negocio__c FROM Case WHERE Id = :objectId];
        Account c = [SELECT Rut__c, DV__c FROM Account WHERE Id = :objectId limit 1];

        //Map<ID,RecordType> rt_Map = New Map<ID,RecordType>([Select ID, Name From RecordType Where sObjectType = 'Case']);
        //String nombreRecordType = rt_Map.get(caso.recordTypeID).name;

        //System.debug('nombre recordtype: ' + nombreRecordType + '; detalle sol: ' + caso.Detalle_Solicitud__c + '; obj ID: ' + ObjectId);

        String url;

        //if (getAplicaConsultaRescate(nombreRecordType, caso)) {
        User usuario = [select Rut_Usuario__c, Habilitado_Rescates_Web__c from User where Id =:UserInfo.getUserId() limit 1];

        if (Test.isRunningTest())
        {
            usuario.Habilitado_Rescates_Web__c = true;
        }

        if (usuario.Habilitado_Rescates_Web__c == true){
            List<Profile> perfiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String nombrePerfil = perfiles[0].Name;

            if (nombrePerfil.contains('Call')) {
                nombrePerfil = 'CALL';
            }
            else {
                nombrePerfil = 'SUCURSAL';
            }

            WSAccess.DatoAcceso persistencia;
            string mensaje = '';
            boolean error = false;

            try {
                persistencia = persistenciaEjecutivaSimulacion(usuario.RUT_Usuario__c, 'RESCATEWEB');

                if (persistencia != null && persistencia.IdPersistencia != 0){
                    url = 'http://portal.vidasecurity.cl/rescateweb/acceso.html';
                    url += '?cup=RESCATEWEB';
                    url += '&rut=' + usuario.RUT_Usuario__c;
                    url += '&PersistCode=' + persistencia.IdPersistencia;
                    url += '&poliza=' + Poliza;
                    url += '&rut_cliente=' + c.Rut__c + '-' + c.DV__c;
                    url += '&id_caso=CUENTA';
                }
                else if (persistencia != null && persistencia.IdPersistencia == 0){
                    error = true;
                    mensaje = persistencia.Mensaje;
                }

                if (url == null) {
                    system.debug('url null');

                    error = true;
                    mensaje = 'No se pudo formar la ruta de acceso (URL) a la página del CMS, posiblemente debido a que el usuario podría no tener configurado el acceso a esta aplicación desde el CMS Vida';

                    try{
                        system.debug('valores url:');
                        system.debug(usuario.RUT_Usuario__c);
                        system.debug(persistencia.IdPersistencia);
                        system.debug(Poliza);
                        system.debug(c.Rut__c);
                        system.debug(c.DV__c);
                        system.debug(c.DV__c);
                    }
                    catch(Exception e){}
                }
            }
            catch(Exception e){
                error = true;
                mensaje = e.getMessage();
            }

            if (error){
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
//                String[] toAddresses = new String[] {'incidentesvida@security.cl'};
                String[] toAddresses = new String[] {'donald@cl.ibm.com'};
                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Salesforce');
                mail.setSubject('Error Rescate Web');
                mail.setUseSignature(false);
                mail.setHtmlBody('<b>RUT Usuario:</b> ' +  usuario.RUT_Usuario__c + '<br/><b>Poliza:</b> ' + Poliza + '<br/><b>Rut Cliente:</b> ' + c.Rut__c + '-' + c.DV__c + '<br/><b>Exception:</b> ' + mensaje);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Ha ocurrido un problema al acceder a Rescates Web, favor ponerse en contacto con Incidentes Vida.'));
                return null;
            }

            System.debug('url: ' + url);
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Su cuenta no está configurada para poder consultar rescates web, contacte al Administrador Salesforce'));
            //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
            //pageRef.setRedirect(true);
            return null;
        }
        //}
        // else{
        //System.debug('Error 1');
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No es posible consultar rescates ya que el caso no está tipificado como rescate'));
        //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        //pageRef.setRedirect(true);
        //return null;
        //}

        return new System.Pagereference(url);
    }

    public String Poliza{get; set;}

    public List<SelectOption> getPolizasCuenta() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','--Seleccione una Póliza--'));

        //Case caso = [SELECT Account.Poliza__c FROM Case WHERE Id = :objectId];

        //Map<ID,Case> mapaCasosCuentas = New Map<ID,Case>([SELECT id, AccountId FROM Case WHERE Id =: objectId]);
        List<string> polizas = new List<string>();

        //for(Case c : mapaCasosCuentas.values()) {
        //    polizas.add(mapaCasosCuentas.get(c.Id).AccountId);
        //}

        System.debug('cuenta: ' + objectId);

        for (Poliza__c p : [select id, Name from Poliza__c where Cuenta__c =: objectId]) {
            System.debug('poliza: ' + p.Name);
            polizas.add(p.Name);
        }

        for (Integer j=0;j<polizas.size();j++) {
            options.add(new SelectOption(polizas[j],polizas[j]));
        }

        return options;
    }

    public boolean getAplicaConsultaRescate(String nombreRecordType, Case caso) {
        System.debug(nombreRecordType);
        System.debug(caso.Detalle_Solicitud__c);
        System.debug(caso.Negocio__c);
        return (nombreRecordType.ContainsIgnoreCase('Solicitud') && caso.Negocio__c.ContainsIgnoreCase('Seguros Individuales') && caso.Detalle_Solicitud__c.containsIgnoreCase('Solicitud rescate'));
    }

    public System.Pagereference siniestrosConsulta() {
        Account c = [SELECT Rut__c, DV__c FROM Account WHERE Id = :objectId limit 1];

        String url;
        User usuario = [select Rut_Usuario__c, Habilitado_Siniestros_Web__c from User where Id =:UserInfo.getUserId() limit 1];

        if (Test.isRunningTest())
        {
            usuario.Habilitado_Siniestros_Web__c = true;
        }

        if (usuario.Habilitado_Siniestros_Web__c == true){

            WSAccess.DatoAcceso persistencia;
            string mensaje = '';
            boolean error = false;

            try {
                persistencia = persistenciaEjecutivaSimulacion(usuario.RUT_Usuario__c, 'PR10-D011-Intranet_Internet');

                system.debug('persistencia null?: ' + string.valueof(persistencia == null));

                if (persistencia != null && persistencia.IdPersistencia != 0){
                    //url = 'http://www.vidasecurity.cl/CMSvidasecurity/widgets/crm/popup.aspx';
                    url = 'http://clientes.vidasecurity.cl/CMSvidasecurity/widgets/crm/popup.aspx';
                    url += '?RUT_AGENTE=' + usuario.RUT_Usuario__c;
                    url += '&PERSIST_APP=' + persistencia.IdPersistencia;
                    url += '&USERNAME_APP=' + persistencia.NombreUsuario;
                    url += '&OPCION=SINIESTRO';
                    url += '&POLIZA=' + Poliza;
                    url += '&RUT_CLIENTE=' + c.Rut__c + '-' + c.DV__c;
                }
                else if (persistencia != null && persistencia.IdPersistencia == 0){
                    error = true;
                    mensaje = persistencia.Mensaje;
                }

                if (url == null) {

                    system.debug('url null');

                    error = true;
                    mensaje = 'No se pudo formar la ruta de acceso (URL) a la página del CMS, posiblemente debido a que el usuario podría no tener configurado el acceso a esta aplicación desde el CMS Vida';

                    try {
                        system.debug('valores url:');
                        system.debug(usuario.RUT_Usuario__c);
                        system.debug(persistencia.IdPersistencia);
                        system.debug(persistencia.NombreUsuario);
                        system.debug(Poliza);
                        system.debug(c.Rut__c);
                        system.debug(c.DV__c);
                    }
                    catch(Exception e){}
                }
            }
            catch(Exception e){
                error = true;
                mensaje = e.getMessage();
            }

            if (error) {
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
               // String[] toAddresses = new String[] {'incidentesvida@security.cl'};
               String[] toAddresses = new String[] {'donald@cl.ibm.com'};

                mail.setToAddresses(toAddresses);
                mail.setSenderDisplayName('Salesforce');
                mail.setSubject('Error Siniestro Web');
                mail.setUseSignature(false);
                mail.setHtmlBody('<b>RUT Usuario:</b> ' +  usuario.RUT_Usuario__c + '<br/><b>Poliza:</b> ' + Poliza + '<br/><b>Rut Cliente:</b> ' + c.Rut__c + '-' + c.DV__c + '<br/><b>Exception:</b> ' + mensaje);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Ha ocurrido un problema al acceder a Siniestros Web, favor ponerse en contacto con Incidentes Vida.'));
                return null;
            }

            System.debug(url);
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Su cuenta no está configurada para poder consultar siniestros web, contacte al Administrador Salesforce'));
            return null;
        }

        return new System.Pagereference(url);
    }
}