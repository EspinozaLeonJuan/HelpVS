@isTest
public class EscritorioDigital_Consume_Test {

	@isTest static void EvaluaObtenerPersistencia_Valido() {
        Test.startTest();
        WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia Respuesta = new WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='00';
        Integer salida = EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == 45);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_01() {
        Test.startTest();
        WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia Respuesta = new WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Integer salida = EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == -1);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_02() {
        Test.startTest();
        WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia Respuesta = new WS_EscritorioDigital_Principal.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Integer salida = EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Valido() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new Ws_EscritorioDigital_Principal.Resultado();
        Respuesta.Requerimiento = new Ws_EscritorioDigital_CR.Requerimiento();
        Respuesta.Requerimiento.IdRequerimiento = 69;
        Respuesta.Resultado.Codigo ='00';
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 69);  
        Test.stopTest();
    }
   
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01_a() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new Ws_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -1);  
        Test.stopTest();
    }

	@isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01_b() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new Ws_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -1);  
        Test.stopTest();
    }

    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion02() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new Ws_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -2);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion03() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'La Poliza ingresada se encuentra obsoleta.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -3);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion04() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -4);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion05() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El Cliente ingresado no posee una Poliza activa.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -5);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion06() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == -6);  
        Test.stopTest();
    }
    
     @isTest static void EvaluaRespuesta_CrearRequerimiento_ExcepcionNoControlada() {
        Test.startTest();
        Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new WS_EscritorioDigital_Principal.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'Excepcion desconocida';  
        EscritorioDigital_Consume.Respuesta_Requerimiento salida = EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void ObtenerPersistencia()  {
        Test.startTest();
        String RutUsuario = '15045517-0';
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150';   
        Integer respuesta = EscritorioDigital_Consume.obtenerPersistencia(RutUsuario,UserOS, Ip);        
        Test.stopTest();
    }
        
    @isTest static void CrearRequerimiento()  {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioDigital_Consume.Respuesta_Requerimiento respuesta = EscritorioDigital_Consume.crearRequerimiento(12345, '12345678-0', 0, 'RRVVTIPO0004',RutUsuario); 
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoRequerimiento() {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        EscritorioDigital_Consume.Respuesta_CambioEstado respuesta =  EscritorioDigital_Consume.cambiarEstadoRequerimiento(45, 'INGRESADO', RutUsuario);   
        
        Test.stopTest();
    }
}