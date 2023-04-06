@istest
public class WsEscritorioDigitalTest {
    
    @isTest static void validarPersistencia() {
            String rutusuario = '15045517-0';
            Integer idpersistencia = 1234;
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio();
            WsEscritorioDigital.RespuestaValidarPersistencia Respuesta = WSED.ValidarPersistencia(rutusuario, idpersistencia);		
    }
        
           
    @isTest static void obtenerPersistencia() {
            String useros = 'GRP_SECURITY\\JUESPINOZA';
            String rutusuario = '15045517-0';
            String usuario = 'SALESFORCE';        
            String password = 'Security2017';        
            String ip = '10.240.45.150'; 
            
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());		
            
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio();              
            WsEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario,usuario,password,ip,useros);		
    }
    
    @isTest static void crearRequerimiento() {
            String rutusuario = '15045517-0';
            String rutcliente = '15045517-0';
            String usuario = 'SALESFORCE';        
            String password = 'Security2017';   
            Integer idpersistencia = 1234;
            String tiporequerimiento = 'RRVVTIPO0001';
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio();
            WsEscritorioDigital.RespuestaCrearRequerimiento Respuesta = WSED.CrearRequerimiento(idpersistencia,rutcliente,tiporequerimiento,rutusuario,usuario);		
    }
        
    @isTest static void cambiarEstadoRequerimiento() {
            String rutusuario = '15045517-0';
            String usuario = 'SALESFORCE';        
            Integer idpersistencia = 1234;
            String estado = 'ANULADO';
            Integer idRequerimiento = 23;
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio(); 
            WsEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = WSED.CambiarEstadoRequerimiento(idpersistencia,idrequerimiento, estado, rutusuario,usuario);    	
    }
        
    @isTest static void obtenerRequerimiento() {
            String rutusuario = '15045517-0';
            String usuario = 'SALESFORCE';        
            Integer idpersistencia = 6940621;
            Integer idRequerimiento = 190;
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio();                  
            WsEscritorioDigital.RespuestaObtenerRequerimiento Respuesta =  WSED.ObtenerRequerimiento(idpersistencia,idrequerimiento,rutusuario,usuario);    	
    }
        
    @isTest static void ObtenerRequerimientos() {
            String rutcliente = null;
            String rutusuario = '15045517-0';
            String usuario = 'SALESFORCE';        
            Integer idpersistencia = 1234;        
            Integer idRequerimiento = null;
            String codigotipo = null;//'RRVVTIPO0001';
            DateTime fechacreaciondesde = null;
            DateTime fechacreacionhasta = null;
            String estado = null;
            String sistema = null;
            Integer poliza = null;
            Integer filainicial = null ;
            Integer largopagina = null;
            Test.setMock(WebServiceMock.class, new WsEscritorioDigitalMockImpl());        
            WsEscritorioDigital.BasicHttpBinding_Servicio WSED = new WsEscritorioDigital.BasicHttpBinding_Servicio();
            WsEscritorioDigital.RespuestaObtenerRequerimientos Respuesta = WSED.ObtenerRequerimientos(idpersistencia,idrequerimiento,rutcliente,codigotipo, fechacreaciondesde,fechacreacionhasta, estado, sistema, poliza, filainicial, largopagina, rutusuario, usuario);
    }
       
    @istest static void newArrayOfBeneficiario() {
            WsEscritorioDigital.ArrayOfBeneficiario arr = new WsEscritorioDigital.ArrayOfBeneficiario();
    }
        
    @istest static void newAdjunto() {
             WsEscritorioDigital.Adjunto adj = new WsEscritorioDigital.Adjunto();
    }
        
    @istest static void newArrayOfAdjunto() {
             WsEscritorioDigital.ArrayOfAdjunto adj = new WsEscritorioDigital.ArrayOfAdjunto();
    }
        
    @istest static void newArrayOfFormulario() {
             WsEscritorioDigital.ArrayOfFormulario form = new WsEscritorioDigital.ArrayOfFormulario();
    }
        
    @istest static void newArrayOfRepresentanteLegal() {
             WsEscritorioDigital.ArrayOfRepresentanteLegal rep = new WsEscritorioDigital.ArrayOfRepresentanteLegal();
    }
        
    @istest static void newArrayOfRequerimiento() {
             WsEscritorioDigital.ArrayOfRequerimiento req = new WsEscritorioDigital.ArrayOfRequerimiento();
    }
        
    @istest static void newArrayOfTutor() {
             WsEscritorioDigital.ArrayOfTutor tut = new WsEscritorioDigital.ArrayOfTutor();
    }
        
    @istest static void newAsegurado() {
             WsEscritorioDigital.Asegurado tut = new WsEscritorioDigital.Asegurado();
    }
        
    @istest static void newBeneficiario() {
             WsEscritorioDigital.Beneficiario ben = new WsEscritorioDigital.Beneficiario();
    }
        
    @istest static void newCiudad() {
             WsEscritorioDigital.Ciudad ciu = new WsEscritorioDigital.Ciudad();
    }
        
    @istest static void newComuna() {
             WsEscritorioDigital.Comuna com = new WsEscritorioDigital.Comuna();
    }
        
    @istest static void newEstadoCivil() {
             WsEscritorioDigital.EstadoCivil est = new WsEscritorioDigital.EstadoCivil();
    }
        
    @istest static void newFormulario()  {
             WsEscritorioDigital.Formulario form = new WsEscritorioDigital.Formulario();
    }
        
    @istest static void newKeyValue()  {
             WsEscritorioDigital.KeyValue key = new WsEscritorioDigital.KeyValue();
    }
        
    @istest static void newParentesco() {
             WsEscritorioDigital.Parentesco par = new WsEscritorioDigital.Parentesco();
    }
        
    @istest static void newPersona() {
             WsEscritorioDigital.Persona per = new WsEscritorioDigital.Persona();
    }
        
    @istest static void newRegion() {
            WsEscritorioDigital.Region reg = new WsEscritorioDigital.Region();
    }
        
    @istest static void newRepresentanteLegal() {
             WsEscritorioDigital.RepresentanteLegal rep = new WsEscritorioDigital.RepresentanteLegal();
    }
        
    @istest static void newRespuestaObtenerRequerimiento() {
             WsEscritorioDigital.RespuestaObtenerRequerimiento rep = new WsEscritorioDigital.RespuestaObtenerRequerimiento();
    }
        
    @istest static void newRespuestaObtenerRequerimientos() {
             WsEscritorioDigital.RespuestaObtenerRequerimientos rep = new WsEscritorioDigital.RespuestaObtenerRequerimientos();
    }
        
    @istest static void newTipoPension() {
             WsEscritorioDigital.TipoPension rep = new WsEscritorioDigital.TipoPension();
    }
        
    @istest static void newTutor() {
             WsEscritorioDigital.Tutor rep = new WsEscritorioDigital.Tutor();
    }
}