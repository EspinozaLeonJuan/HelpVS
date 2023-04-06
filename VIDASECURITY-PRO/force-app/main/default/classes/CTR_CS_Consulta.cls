/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-18-2023
 * @last modified by  : Juan Espinoza León
**/
public class CTR_CS_Consulta {

    public String Mensaje {get; set;}
    public String URL {get; set;}
    public String ID {get; set;}

    public System.Pagereference callToVidaSecurity() {

        String Id = apexpages.currentpage().getparameters().get('id');
        String tipo = apexpages.currentpage().getparameters().get('tipo');//S: Siniestro/R: Rescate

        Case caso =  [SELECT Id, CaseNumber, AccountId, CASO_N_Poliza__c, Negocio__c, Detalle_Operacion__c, Detalle_de_Rescate__c, Tipo_de_Requerimiento__c,Detalle_Solicitud__c FROM Case WHERE Id =: Id];
        Account cuenta = [SELECT Id, Rut__c, DV__c FROM Account WHERE Id =: caso.AccountId];
        User usuario = [SELECT Rut_Usuario__c, Habilitado_Rescates_Web__c, Habilitado_Siniestros_Web__c FROM User WHERE Id =:UserInfo.getUserId() limit 1];
        Poliza__c poliza = [SELECT Id, Name FROM Poliza__c WHERE Id =: caso.CASO_N_Poliza__c];

        WSAccess.DatoAcceso persistencia = getPersistenciaEjecutivaSimulacion(usuario.RUT_Usuario__c, 'RESCATEWEB');

        String url = '';

        this.Mensaje = 'OK';

        Boolean error = false;

        try
        {
            if (tipo == 'R')
            {
                if (usuario.Habilitado_Rescates_Web__c == true)
                {
                    if (persistencia != null)
                    {
                        if (persistencia.IdPersistencia != 0){
                            url = 'http://portal.vidasecurity.cl/rescateweb/acceso.html';
                            url += '?cup=RESCATEWEB';
                            url += '&rut=' + usuario.RUT_Usuario__c;
                            url += '&PersistCode=' + persistencia.IdPersistencia;
                            url += '&poliza=' + poliza.Name;
                            url += '&rut_cliente=' + cuenta.Rut__c + '-' + cuenta.DV__c;
                            url += '&id_caso=' + caso.CaseNumber;
                        }
                        else if (persistencia.IdPersistencia == 0){
                            error = true;
                            this.Mensaje =  persistencia.Mensaje;
                        }
                    }
                }
                else {
                    this.Mensaje = 'Su cuenta no está configurada para poder consultar Rescates web, contacte al Administrador Salesforce.';
                    return null;
                }
            }
            else if (tipo == 'S')
            {
                if (usuario.Habilitado_Siniestros_Web__c == true)
                {
                    if (persistencia != null)
                    {
                        if (persistencia.IdPersistencia != 0){
                            url = 'http://clientes.vidasecurity.cl/CMSvidasecurity/widgets/crm/popup.aspx';
                            url += '?RUT_AGENTE=' + usuario.RUT_Usuario__c;
                            url += '&PERSIST_APP=' + persistencia.IdPersistencia;
                            url += '&USERNAME_APP=' + persistencia.NombreUsuario;
                            url += '&OPCION=SINIESTRO';
                            url += '&POLIZA=' + poliza.Name;
                            url += '&RUT_CLIENTE=' + cuenta.Rut__c + '-' + cuenta.DV__c;
                        }
                        else if (persistencia.IdPersistencia == 0){
                            error = true;
                            this.Mensaje =  persistencia.Mensaje;
                        }
                    }
                }
                else {
                    this.Mensaje = 'Su cuenta no está configurada para poder consultar Siniestros Web, contacte al Administrador Salesforce.';
                    return null;
                }
            }

            system.debug('@@@@ tipo -->  '+tipo);
            system.debug('@@@@ URL -->  '+url);

            if (tipo != '' && url == '')
            {
                this.Mensaje =  'No se pudo formar la ruta de acceso (URL) a la página del CMS, posiblemente debido a que el usuario podría no tener configurado el acceso a esta aplicación desde el CMS Vida';
            }
        }
        catch (Exception ex) {
            error = true;
            this.Mensaje = ex.getMessage();
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
        }

        this.URL = url;

        if (error == true)
        {
            if (tipo == 'R')
            {
                sendEmailIncidente('Error Rescate Web', usuario.RUT_Usuario__c, cuenta.Rut__c + '-' + cuenta.DV__c, poliza.Name, mensaje);
                this.Mensaje = 'Ha ocurrido un problema al acceder a Rescates Web, favor ponerse en contacto con Incidentes Vida.';
            }
            else  if (tipo == 'S')
            {
                sendEmailIncidente('Error Siniestro Web', usuario.RUT_Usuario__c, cuenta.Rut__c + '-' + cuenta.DV__c, poliza.Name, mensaje);
                this.Mensaje = 'Ha ocurrido un problema al acceder a Siniestros Web, favor ponerse en contacto con Incidentes Vida.';
            }
        }

        return null;
     }

    private static WSAccess.DatoAcceso getPersistenciaEjecutivaSimulacion(string rut, string cup) {
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
        else {
            datoAcceso = new WSAccess.DatoAcceso();
            datoAcceso.IdPersistencia = 1;
            return datoAcceso;
        }

        return null;
    }

    public void sendEmailIncidente(String asunto, String rutUsuario, String rutCuenta, String poliza, String mensaje)
    {
        if (!Test.isRunningTest())
        {
            Messaging.reserveSingleEmailCapacity(2);
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //    String[] toAddresses = new String[] {'incidentesvida@security.cl'};
        String[] toAddresses = new String[] {'donald@cl.ibm.com'};


        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Salesforce');
        mail.setSubject(asunto);
        mail.setUseSignature(false);
        mail.setHtmlBody('<b>RUT Usuario:</b> ' +  rutUsuario+ '<br/><b>Poliza:</b> ' + poliza+ '<br/><b>Rut Cliente:</b> ' + rutCuenta + '<br/><b>Exception:</b> ' + mensaje);

        if (!Test.isRunningTest())
        {
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}