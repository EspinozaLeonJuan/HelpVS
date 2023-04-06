/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 06-14-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
public class CLS_CM_CotizadorExpress_Consume {
    
    private static String Usuario = 'SALESFORCE';   
    private static String Password = 'S4l3sForce';

    public class CLS_TarifaOnco {
		public Double PrimaNetaUF {get; set;}
		public Double PrimaIVAUF {get; set;}
		public Double PrimaBrutaUF {get; set;}
		public Double PrimaNetaPS {get; set;}
		public Double PrimaIVAPS {get; set;}
		public Double PrimaBrutaPS {get; set;}
        public Double TasaRiesgo {get; set;}
    }

    public class Response 
    {
        public Boolean Consulta { get; set; }

        public String FechaValida { get; set; }

        public String ValorUF { get; set; }

        public String ValorCLP { get; set; }
    }

    public static Integer obtienePersistencia() {
        
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

        EXT_WS_Access.WsAccessSoap service = new EXT_WS_Access.WsAccessSoap();

        service.timeout_x = 120000;
        EXT_WS_Access.AppInfo appInfo = new EXT_WS_Access.AppInfo();
        appInfo.Cup = 'PR10-D011-Intranet_Internet';
        appInfo.Option = 0;

        EXT_WS_Access.UserInfo userInfo = new EXT_WS_Access.UserInfo();
        userInfo.UserName = Usuario;
        userInfo.Password = Password;
        userInfo.UserOS = 'UsuarioOS';
        userInfo.Ip = ip == null ? '' : ip;
        userInfo.Rut = 76749930;
        userInfo.Dv = '2';
        userInfo.PersistCode = 0;

        EXT_WS_Access.WebInfo webInfo = new EXT_WS_Access.WebInfo();
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

        EXT_WS_Access.AccessInfo accessInfo = new EXT_WS_Access.AccessInfo();
        accessInfo.AppInfo = appInfo;
        accessInfo.UserInfo = userInfo;
        accessInfo.WebInfo = webInfo;
        System.debug('@@@@ Obtencion Persistencia paso');
        EXT_WS_Access.DatoAcceso datoAcceso = null;
        Integer retries = 5;

        for (Integer i = 0; i < retries; i++) {
            try {
                datoAcceso = service.Login(accessInfo);
                
                if (datoAcceso != null)
                {
                    System.debug('@@@@ Acceso: ' + datoAcceso);
                    System.debug('@@@@ Acceso Válido: ' + datoAcceso.AccesoValido);
                    System.debug('@@@@ datoAcceso.IdPersistencia: ' + datoAcceso.IdPersistencia);
                    return datoAcceso.IdPersistencia;
                }
                
            } catch (Exception ex) {
                System.debug('@@@@ Exception: ' + ex);
            }
        }
        
        return 0;

    }

    public static String ValidacionFechaNacUsuario(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer fechaNacimiento)
    {
        EXT_WS_Oncologico.WsProductoOncologicoSoap service = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
        
        EXT_WS_Oncologico.UsuarioValido valido = service.ValidacionUsuarioPorFecNac(usuario, ramo, prod, plan, revPlan, tipoDeAsegurado, relacionConTitular, fechaNacimiento);

        String outResult = '';
        
        system.debug('@@@@ valido'+ valido);

        try
        {
            outResult = valido.Respuesta;
        }
        catch(Exception ex)
        {
        }
       //return 'OK';		       
        return outResult;
    }

    public static  CLS_TarifaOnco GetTarifaOncoFechaNacimiento(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer fecNacimiento)
    {
        EXT_WS_Oncologico.WsProductoOncologicoSoap service = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
        
        EXT_WS_Oncologico.Tarificacion respuesta = service.GetTarificacionOncoFechaNacimiento(usuario, ramo, prod, plan, revPlan, tipoDeAsegurado, relacionConTitular, fecNacimiento);

        CLS_TarifaOnco tarifa = new CLS_TarifaOnco();
        
        try
        {
        	tarifa.PrimaBrutaUF = respuesta.PrimaBrutaUF;
        	tarifa.PrimaBrutaPS = respuesta.PrimaBrutaPS;    
        }
        catch(Exception ex)
        {
            tarifa.PrimaBrutaUF = 0;
        	tarifa.PrimaBrutaPS = 0;
        }

        return tarifa;
    }


    /* XONSUMO WS*/

 @Future(callout=true)
 public static void ConsumirWSAsync(String IdCotizador)
 {
     Cotizador_Express__c cotizador = [SELECT Id, Fecha_Nacimiento_Int__c, WS_Valida_Fecha_Nacimiento__c,  WS_Valor_UF__c, WS_Valor_CLP__c,
     UsuarioTV__c, Ramo__c, Codigo_Producto__c, Plan__c, Revision__c, Tipo_Cliente__c, Relacion_Titular__c, Asegurable__c FROM Cotizador_Express__c WHERE Id =: IdCotizador];

     ////// realiza 3 intentos (max) de consumo del WS
     Integer cont = 1;
     Response respuesta = new Response();
     respuesta.Consulta =  false;
     
     while(cont <= 3 && respuesta.Consulta == false)
     {
         respuesta = consumoWS(cotizador.UsuarioTV__c, cotizador.Ramo__c, cotizador.Codigo_Producto__c, cotizador.Plan__c, cotizador.Revision__c, cotizador.Tipo_Cliente__c, cotizador.Relacion_Titular__c, Integer.valueOf(cotizador.Fecha_Nacimiento_Int__c));
         cont++;
     }
     ////// realiza 3 intentos (max) de consumo del WS  

     if (respuesta.Consulta = true)
     {
         cotizador.WS_Valida_Fecha_Nacimiento__c = respuesta.FechaValida;
         cotizador.WS_Valor_UF__c = respuesta.ValorUF;
         cotizador.WS_Valor_CLP__c = respuesta.ValorCLP;
         
         if(cotizador.WS_Valida_Fecha_Nacimiento__c == 'S')
         {
             cotizador.Asegurable__c = 'SI';
         }
         else
         {
             cotizador.Asegurable__c = 'NO';
         }
     }

     update cotizador;
 }
 
 private static Response consumoWS(String usuarioTv, String ramo, String codProducto, String plan, String revision, String tipoCliente, String parentesco, Integer fechaNacimiento)
 {
     system.debug('@@@@ ENTER');
     Response query = new Response();
     try 
     {
         system.debug('@@@@ usuarioTv'+ usuarioTv);
         system.debug('@@@@ ramo'+ ramo);
         system.debug('@@@@ codProducto '+ codProducto);
         system.debug('@@@@ plan '+ plan);
         system.debug('@@@@ revision '+ revision);
         system.debug('@@@@ tipoCliente '+  tipoCliente);
         system.debug('@@@@ parentesco'+ parentesco);
         system.debug('@@@@ fechaNacimiento '+ fechaNacimiento);
         
         query.FechaValida = ValidacionFechaNacUsuario(usuarioTv, ramo, codProducto, plan, 
         revision, tipoCliente, parentesco, fechaNacimiento);  
         system.debug('@@@@ query.FechaValida '+ query.FechaValida  );
         if (query.FechaValida == 'S')
         {
             CLS_CM_CotizadorExpress_Consume.CLS_TarifaOnco tarifa = GetTarifaOncoFechaNacimiento(usuarioTv, ramo, codProducto, plan, 
             revision, tipoCliente, parentesco, fechaNacimiento);        
             system.debug('@@@@ tarifa '+ tarifa  );
             query.ValorUF = String.valueOf(tarifa.PrimaBrutaUF);
             query.ValorCLP = String.valueOf(tarifa.PrimaBrutaPS);
         }

         system.debug('@@@@ WS_Valor_UF__c '+ query.ValorUF );
         system.debug('@@@@ WS_Valor_CLP__c '+ query.ValorCLP);
         query.Consulta = true;
     } 
     catch (Exception exc) {
         system.debug('@@@@ Excepcion --> '+ exc);           
         query.Consulta = false;
         query.FechaValida = 'S';
         query.ValorUF = '0,4623';
         query.ValorCLP = '13.506';
     }
     return query;
 }

 public static Response consumoWS(Cotizador_Express__c cotizacion)
 {
     system.debug('@@@@ ENTER');
     Response query = new Response();
     try 
     {
         system.debug('@@@@ this.Cotizador '+ cotizacion );

         system.debug('@@@@ cotizador.UsuarioTV__c '+ cotizacion.UsuarioTV__c );
         system.debug('@@@@ cotizador.Ramo__c '+ cotizacion.Ramo__c);
         system.debug('@@@@ cotizador.Codigo_Producto__c '+ cotizacion.Codigo_Producto__c );
         system.debug('@@@@ cotizador.Plan__c '+ cotizacion.Plan__c );
         system.debug('@@@@ cotizador.Revision__c '+ cotizacion.Revision__c );
         system.debug('@@@@ cotizador.Tipo_Cliente__c '+ cotizacion.Tipo_Cliente__c );
         system.debug('@@@@ asegurado.Relacion_Titular__c '+ cotizacion.Relacion_Titular__c  );
         system.debug('@@@@ Integer.valueOf(fechaNacimiento) '+ Integer.valueOf(cotizacion.Fecha_Nacimiento_Int__c) );
         
         query.FechaValida = ValidacionFechaNacUsuario(cotizacion.UsuarioTV__c, cotizacion.Ramo__c, cotizacion.Codigo_Producto__c,
         cotizacion.Plan__c, cotizacion.Revision__c, cotizacion.Tipo_Cliente__c, cotizacion.Relacion_Titular__c, Integer.valueOf(cotizacion.Fecha_Nacimiento_Int__c));  
         system.debug('@@@@ query.FechaValida '+ query.FechaValida  );
         if (query.FechaValida == 'S')
         {
             CLS_CM_CotizadorExpress_Consume.CLS_TarifaOnco tarifa = GetTarifaOncoFechaNacimiento(cotizacion.UsuarioTV__c, cotizacion.Ramo__c, cotizacion.Codigo_Producto__c,
             cotizacion.Plan__c, cotizacion.Revision__c, cotizacion.Tipo_Cliente__c, cotizacion.Relacion_Titular__c, Integer.valueOf(cotizacion.Fecha_Nacimiento_Int__c));        

             query.ValorUF = String.valueOf(tarifa.PrimaBrutaUF);
             query.ValorCLP = String.valueOf(tarifa.PrimaBrutaPS);
         }

         system.debug('@@@@ WS_Valor_UF__c '+ query.ValorUF );
         system.debug('@@@@ WS_Valor_CLP__c '+ query.ValorCLP);
         query.Consulta = true;

     } 
     catch (Exception exc) {
         system.debug('@@@@ Excepcion --> '+ exc);           
         query.Consulta = false;
         query.FechaValida = 'S';
         query.ValorUF = '0,4623';
         query.ValorCLP = '13.506';
     }
     return query;
 }

 

}