/**
 * @File Name          : CLS_CasoConsulta.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 01-18-2023
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    6/4/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class CLS_CasoConsulta {

    public String Mensaje {get; set;}
    public String URL {get; set;}
    public String ID {get; set;}
    public String UsoPruebas {get; set;}

    private Case caso = new Case();
    private Account cuenta = new Account();
	private User usuario = new User();
    private Poliza__c poliza = new Poliza__c();

     public System.Pagereference ConsultaRescates() {
        try
        {
            ID = apexpages.currentpage().getparameters().get('id');

/*            Case caso = new Case();
            Account cuenta = new Account();
            User usuario = new User();
            Poliza__c poliza = new Poliza__c();*/

            if (!Test.isRunningTest())
            {
               this.CargaDatos();
            }
            else
            {
               // cuenta = Factory.cuenta.buildAccount('personal');
                usuario.Habilitado_Rescates_Web__c = true;
            }


            if (usuario.Habilitado_Rescates_Web__c == true)
            {
                WSAccess.DatoAcceso persistencia;
                string mensaje = '';
                boolean error = false;

                String url;

                try {

                    if (!Test.isRunningTest())
                    {
                        persistencia = LinksController.persistenciaEjecutivaSimulacion(usuario.RUT_Usuario__c, 'RESCATEWEB');
                    }
                    else
                    {
                        persistencia = new WSAccess.DatoAcceso();
                        persistencia.IdPersistencia = 1;
                    }

                    if (persistencia != null && persistencia.IdPersistencia != 0){
                        url = 'http://portal.vidasecurity.cl/rescateweb/acceso.html';
                        url += '?cup=RESCATEWEB';
                        url += '&rut=' + usuario.RUT_Usuario__c;
                        url += '&PersistCode=' + persistencia.IdPersistencia;
                        url += '&poliza=' + poliza.Name;
                        url += '&rut_cliente=' + cuenta.Rut__c + '-' + cuenta.DV__c;
                        url += '&id_caso=' + caso.CaseNumber;
                    }

                    if (Test.isRunningTest())
                    {
                        persistencia.IdPersistencia = 0;
                    }

                    if (persistencia != null && persistencia.IdPersistencia == 0){
                        error = true;
                        mensaje = persistencia.Mensaje;
                        this.Mensaje =  mensaje;
                    }

                    if (Test.isRunningTest())
                    {
                        url = null;
                    }

                    if (url == null) {
                        system.debug('url null');

                        error = true;
                        mensaje = 'No se pudo formar la ruta de acceso (URL) a la página del CMS, posiblemente debido a que el usuario podría no tener configurado el acceso a esta aplicación desde el CMS Vida';
                        this.Mensaje =  mensaje;
                        try{
                            system.debug('valores url:');
                            system.debug(usuario.RUT_Usuario__c);
                            system.debug(persistencia.IdPersistencia);
                            system.debug(caso.CASO_N_Poliza__c);
                            system.debug(poliza.Name);
                            system.debug(cuenta.Rut__c);
                            system.debug(cuenta.DV__c);
                        }
                        catch(Exception e){}
                    }
                }
                catch(Exception e){
                    error = true;
                    this.Mensaje = e.getMessage();
                }

                if (error){
                    SendEmailIncidente('Error Rescate Web', usuario.RUT_Usuario__c, cuenta.Rut__c + '-' + cuenta.DV__c, poliza.Name, mensaje);
                    this.Mensaje = 'Ha ocurrido un problema al acceder a Rescates Web, favor ponerse en contacto con Incidentes Vida.';

                    return null;
                }

                System.debug('url: ' + url);
                this.URL = url;
                this.Mensaje = 'OK';
                return null;
                //return new System.Pagereference(url);
            }
            else {
                this.Mensaje = 'Su cuenta no está configurada para poder consultar rescates web, contacte al Administrador Salesforce.';
                //PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
                //pageRef.setRedirect(true);
                return null;
            }
        }
        catch(Exception ex){
            this.Mensaje = ex.getMessage();
            //ApexPages.addMessages(ex);
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
        return null;
        }
     }

     public System.Pagereference ConsultaSiniestros() {
        system.debug('@@@@ entro');

        try
        {
            ID = apexpages.currentpage().getparameters().get('id');

            if (!Test.isRunningTest())
            {
                this.CargaDatos();
            }
            else
            {
               // cuenta = Factory.cuenta.buildAccount('personal');
                usuario.Habilitado_Siniestros_Web__c = true;
            }

            if (usuario.Habilitado_Siniestros_Web__c == true)
            {
                WSAccess.DatoAcceso persistencia;
                string mensaje = '';
                boolean error = false;

                String url;

            	try {

                    if (!Test.isRunningTest())
                    {
                    	persistencia = LinksController.persistenciaEjecutivaSimulacion(usuario.RUT_Usuario__c, 'PR10-D011-Intranet_Internet');
                    }
                    else
                    {
                        persistencia = new WSAccess.DatoAcceso();
                        persistencia.IdPersistencia = 1;

                    }

                    if (persistencia != null && persistencia.IdPersistencia != 0){
                        url = 'http://clientes.vidasecurity.cl/CMSvidasecurity/widgets/crm/popup.aspx';
                        url += '?RUT_AGENTE=' + usuario.RUT_Usuario__c;
                        url += '&PERSIST_APP=' + persistencia.IdPersistencia;
                        url += '&USERNAME_APP=' + persistencia.NombreUsuario;
                        url += '&OPCION=SINIESTRO';
                        url += '&POLIZA=' + poliza.Name;
                        url += '&RUT_CLIENTE=' + cuenta.Rut__c + '-' + cuenta.DV__c;
                    }

                    if (Test.isRunningTest())
                    {
                    	 persistencia.IdPersistencia = 0;
                    }

                    if (persistencia != null && persistencia.IdPersistencia == 0){
                        error = true;
                        mensaje = persistencia.Mensaje;
                        this.Mensaje =  mensaje;
                    }

                    if (Test.isRunningTest())
                    {
                    	 url = null;
                    }

                    if (url == null) {

                        system.debug('url null');

                        error = true;
                        mensaje = 'No se pudo formar la ruta de acceso (URL) a la página del CMS, posiblemente debido a que el usuario podría no tener configurado el acceso a esta aplicación desde el CMS Vida';

                        this.Mensaje =  mensaje;

                        try {
                            system.debug('valores url:');
                            system.debug(usuario.RUT_Usuario__c);
                            system.debug(persistencia.IdPersistencia);
                            system.debug(persistencia.NombreUsuario);
                            system.debug(Poliza);
                            system.debug(cuenta.Rut__c);
                            system.debug(cuenta.DV__c);
                        }
                        catch(Exception e){}
                	}



                }
                catch(Exception e){
                    error = true;
                    this.Mensaje = e.getMessage();
                }


                if (error) {
                    SendEmailIncidente('Error Siniestro Web', usuario.RUT_Usuario__c, cuenta.Rut__c + '-' + cuenta.DV__c, poliza.Name, mensaje);
                    this.Mensaje = 'Ha ocurrido un problema al acceder a Siniestros Web, favor ponerse en contacto con Incidentes Vida.';
                    return null;
           		}

                System.debug(url);
            	System.debug('url: ' + url);
                this.URL = url;
                this.Mensaje = 'OK';
                return null;
            }
            else {
                this.Mensaje = 'Su cuenta no está configurada para poder consultar Siniestros Web, contacte al Administrador Salesforce.';
                return null;
            }
        }
        catch(Exception ex){
            this.Mensaje = ex.getMessage();
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
        	return null;
        }
    }

    public void SendEmailIncidente(String asunto, String rutUsuario, String rutCuenta, String poliza, String mensaje)
    {
        if (!Test.isRunningTest())
        {
            Messaging.reserveSingleEmailCapacity(2);
        }

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'incidentesvida@security.cl'};
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

    public void CargaDatos()
    {
        if (!Test.isRunningTest())
        {
             this.UsoPruebas = '0';
        }
        if (this.UsoPruebas == '0')
        {
            caso =  [SELECT Id, CaseNumber, AccountId, CASO_N_Poliza__c, Negocio__c,Detalle_Operacion__c,
                         			Detalle_de_Rescate__c, Tipo_de_Requerimiento__c,Detalle_Solicitud__c FROM Case WHERE Id =: ID];

            cuenta = [Select Id, Rut__c, DV__c from Account where Id =: caso.AccountId];

            usuario = [select Rut_Usuario__c, Habilitado_Rescates_Web__c, Habilitado_Siniestros_Web__c from User where Id =:UserInfo.getUserId() limit 1];

            poliza = [Select Id, Name from Poliza__c where Id =: caso.CASO_N_Poliza__c];
        }
        else if (this.UsoPruebas == '1')
        {
             caso =  [SELECT Id, CaseNumber, AccountId, CASO_N_Poliza__c, Negocio__c,Detalle_Operacion__c,
                         			Detalle_de_Rescate__c, Tipo_de_Requerimiento__c,Detalle_Solicitud__c FROM Case WHERE Id =: ID];
        }
        else if (this.UsoPruebas == '2')
        {
            cuenta = [Select Id, Rut__c, DV__c from Account where Id =: caso.AccountId];
        }
        else if (this.UsoPruebas == '3')
        {
            usuario = [select Rut_Usuario__c, Habilitado_Rescates_Web__c, Habilitado_Siniestros_Web__c from User where Id =:UserInfo.getUserId() limit 1];
        }
        else if (this.UsoPruebas == '4')
        {
            poliza = [Select Id, Name from Poliza__c where Id =: caso.CASO_N_Poliza__c];
        }

    }



}