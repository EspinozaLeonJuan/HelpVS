@isTest
public class EscritorioDigitalNegocioTest {
 	@isTest static void EvaluaObtenerPersistencia_Valido() {
       WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='00';
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
       System.assert(salida == 45);	
	}
    
    @isTest static void EvaluaObtenerPersistencia_InValido_02() {
       WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       //Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='01';
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
       System.assert(salida == -1);	
	}
    
    @isTest static void EvaluaObtenerPersistencia_InValido_01() {
       WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = new WSEscritorioDigital.RespuestaObtenerPersistencia();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       //Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='02';
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
       System.assert(salida == 0);	
	}
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Valido() {
       WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Requerimiento = new WsEscritorioDigital.Requerimiento();
       Respuesta.Requerimiento.IdRequerimiento = 69;
        Respuesta.Resultado.Codigo ='00';
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
       System.assert(salida == 69);	
	}
    
     @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01() {
       WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='01';
       Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.';  
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
       System.assert(salida == -1);	
	}
    
        
     @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion02() {
       WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='01';
       Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.';  
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
       System.assert(salida == -1);	
	}
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion03() {
       WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='01';
       Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';  
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
       System.assert(salida == -2);	
	}
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_ExcepcionDesconocida() {
       WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCrearRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='01';
       Respuesta.Resultado.Excepcion = 'Excepcion desconocida';  
       Integer salida = EscritorioDigitalNegocio.EvaluaRespuesta_CrearRequerimiento(Respuesta);
       System.assert(salida == 0);	
	}
    
    @isTest static void EvaluaRespuesta_CambiarEstadoRequerimiento_Valido() {
       WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='00';       
       String salida = EscritorioDigitalNegocio.EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
       System.assert(salida == 'ok');	
	}
    
    @isTest static void EvaluaRespuesta_CambiarEstadoRequerimiento_Invalido() {
       WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = new WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento();
       Respuesta.Resultado = new WsEscritorioDigital.Resultado();
       Respuesta.Resultado.Codigo ='01';       
       Respuesta.Resultado.Excepcion = 'Excepcion cambio estado';
       String salida = EscritorioDigitalNegocio.EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
       System.assert(salida == 'Excepcion cambio estado');	
	}
}