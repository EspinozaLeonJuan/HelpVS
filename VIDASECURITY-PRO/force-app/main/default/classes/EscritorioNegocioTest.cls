@isTest
public class EscritorioNegocioTest {

    @isTest static void EvaluaObtenerPersistencia_Valido() {
        Test.startTest();
        WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='00';
        Integer salida = EscritorioNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == 45);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_02() {
        Test.startTest();
        WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Integer salida = EscritorioNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == -1);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_01() {
        Test.startTest();
        WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Integer salida = EscritorioNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == 0);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Valido() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Requerimiento = new WsEscritorioDigital.Requerimiento();
        Respuesta.Requerimiento.IdRequerimiento = 69;
        Respuesta.Resultado.Codigo ='00';
        Integer salida = EscritorioNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida == 69);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.';  
        Integer salida = EscritorioNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida == -1);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion02() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.';  
        Integer salida = EscritorioNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida == -1);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion03() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';  
        Integer salida = EscritorioNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida == -2);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_ExcepcionDesconocida() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'Excepcion desconocida';  
        Integer salida = EscritorioNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida == 0);	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CambiarEstadoRequerimiento_Valido() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='00';       
        String salida = EscritorioNegocio.EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
        System.assert(salida == 'ok');	
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CambiarEstadoRequerimiento_Invalido() {
        Test.startTest();
        WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento();
        Respuesta.Resultado = new WsEscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';       
        Respuesta.Resultado.Excepcion = 'Excepcion cambio estado';
        String salida = EscritorioNegocio.EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
        System.assert(salida == 'Excepcion cambio estado');	
        Test.stopTest();
    }
    
    @isTest static void ObtenerPersistencia()  {
        Test.startTest();
        String RutUsuario = '15045517-0';
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150';   
        EscritorioNegocio.obtenerPersistencia(RutUsuario,UserOS, Ip);        
        Test.stopTest();
    }
    
    @isTest static void ObtenerTPersistencia()  {
        Test.startTest();
        String RutUsuario = '15045517-0';
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150';   
        EscritorioNegocio.obtenerTPersistencia(RutUsuario,UserOS, Ip);        
        Test.stopTest();
    }
    
    @isTest static void CrearRequerimiento()  {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioNegocio.crearRequerimiento(12345, '12345678-0', 'RRVVTIPO0004',RutUsuario); 
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoRequerimiento() {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioNegocio.cambiarEstadoRequerimiento(12345, 45, 'INGRESADO', RutUsuario);     
        Test.stopTest();
    }
    
    @isTest static void ObtenerEstadoRequerimiento_01()  { 
        Test.startTest();
        String RutUsuario = '15045517-0';
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150'; 
        EscritorioNegocio.obtenerEstadoRequerimiento(RutUsuario, UserOS, Ip, 690);     
        Test.stopTest();
    }
    
    @isTest static void ObtenerEstadoRequerimiento_02()  { 
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioNegocio.obtenerEstadoRequerimiento(12345, RutUsuario, 690);   
        Test.stopTest();
    }
    
    @isTest static void ObtenerRequerimiento() { 
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioNegocio.ObtenerRequerimiento(12345, RutUsuario, 690);  
        Test.stopTest();
    }
}