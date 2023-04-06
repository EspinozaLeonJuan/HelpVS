/*******************************************************************************************
 *  NOMBRE                 : TEST_CLS_EscritorioDigital_Consume
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 *  2.0     - 2019/02/07 - J.ESPINOZA       - Actualización Clase
 * *****************************************************************************************/
@istest
public  class TEST_CLS_EscritorioDigital_Consume {

    @isTest static void EvaluaObtenerPersistencia_Valido() {
        Test.startTest();        
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.IdPersistencia = 45;
        Respuesta.Resultado.Codigo ='00';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 45);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_01() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'es inválido  o no posee condiciones validas para acceder.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaObtenerPersistencia_InValido_02() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Respuesta.Resultado.Excepcion = 'Todos los párametros son obligatorios.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }

    @isTest static void EvaluaObtenerPersistencia_InValido_03() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Respuesta.Resultado.Excepcion = 'no se encuentra registrado.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }

    @isTest static void EvaluaObtenerPersistencia_InValido_04() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Respuesta.Resultado.Excepcion = 'no posee permisos para acceder a Escritorio Digital.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }

    @isTest static void EvaluaObtenerPersistencia_InValido_05() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Respuesta.Resultado.Excepcion = 'La Persistencia es inválida.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }

    @isTest static void EvaluaObtenerPersistencia_InValido_06() {
        Test.startTest();
        EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta = new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='02';
        Respuesta.Resultado.Excepcion = 'es inválido.';
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_ObtenerPersistencia(Respuesta);
        System.assert(salida.IdPersistencia == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Valido() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Requerimiento = new EXT_WS_EscritorioDigital_CR.Requerimiento();
        Respuesta.Requerimiento.IdRequerimiento = 69;
        Respuesta.Resultado.Codigo ='00';
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 69);  
        Test.stopTest();
    }
   
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01_a() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }

	@isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion01_b() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }

    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion02() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion03() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'La Poliza ingresada se encuentra obsoleta.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion04() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion05() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El Cliente ingresado no posee una Poliza activa.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion06() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion07() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El requerimiento se encuentra en estado "Finalizado".';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion08() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El requerimiento se encuentra en estado "Pendiente".';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion09() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El requerimiento se encuentra en estado "Nuevo".';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion10() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El Requerimiento no está habilitado para productos APV.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion11() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El Requerimiento está habilitado solo para MAX 3.0';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void EvaluaRespuesta_CrearRequerimiento_Excepcion12() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'El Requerimiento está habilitado solo para productos Mi Seguro.';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
     @isTest static void EvaluaRespuesta_CrearRequerimiento_ExcepcionNoControlada() {
        Test.startTest();
        EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta = new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
        Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
        Respuesta.Resultado.Codigo ='01';
        Respuesta.Resultado.Excepcion = 'Excepcion desconocida';  
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento salida = CLS_EscritorioDigital_Consume.EvaluaRespuesta_CrearRequerimiento(Respuesta);
        System.assert(salida.IdRequerimiento == 0);  
        Test.stopTest();
    }
    
    @isTest static void ObtenerPersistencia()  {
        Test.startTest();
        String RutUsuario = '15045517-0';
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150';   
        CLS_EscritorioDigital_Consume.Respuesta_Persistencia respuesta = CLS_EscritorioDigital_Consume.obtenerPersistencia(RutUsuario,UserOS, Ip);        
        Test.stopTest();
    }
        
    @isTest static void CrearRequerimiento()  {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        CLS_EscritorioDigital_Consume.Respuesta_Requerimiento respuesta = CLS_EscritorioDigital_Consume.crearRequerimiento(12345, '12345678-0', 0, 'RRVVTIPO0004',RutUsuario); 
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoRequerimiento() {
        Test.startTest();
        String RutUsuario = '15045517-0';        
        CLS_EscritorioDigital_Consume.Respuesta_CambioEstado respuesta =  CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(45, 'INGRESADO', RutUsuario);   
        
        Test.stopTest();
    }
    
}