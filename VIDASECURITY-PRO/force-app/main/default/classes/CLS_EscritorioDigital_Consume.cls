/*******************************************************************************************
 *  NOMBRE                 : CLS_EscritorioDigital_Consume
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/

public class CLS_EscritorioDigital_Consume {
    
    public class Respuesta_CambioEstado{
        public String Codigo {get; set;}
        
        public String Mensaje {get; set;}

        public String Excepcion {get; set;}
        
        public String Response {get; set;} 
    }
    
    public class Respuesta_Requerimiento{
        public String Codigo {get; set;}
        
        public String Mensaje {get; set;}
         
        public String Excepcion {get; set;}
        
        public Integer IdRequerimiento {get; set;} 

        public String Response {get; set;} 
    }
    
    public class Estado_Requerimiento{
        public String Estado {get; set;}
        
        public Integer IdRequerimiento {get; set;} 
    }

    public class Respuesta_Persistencia
    {
        public Integer IdPersistencia {get; set;}

        public String Response {get; set;} 
    }

    private static String Usuario = 'SALESFORCE';   
    private static String Password = 'S4l3sForce';
        
    public static Respuesta_Persistencia obtenerPersistencia(String rutUsuario, String userOS, string ip) {        
        try
        {
            EXT_WS_EscritorioDigital.EscritorioDigitalSoap ED = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
            
            System.debug('@@@@|ParameterWS-Persistencia@@'+'R:'+rutUsuario+'Po:'+userOS+'IR:'+ip); 
       
            EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Response = ED.ObtenerPersistencia(rutUsuario, Usuario, Password, ip, userOS);
            System.debug('@@@@|ParameterWS-Response ED'+ Response);             
            return EvaluaRespuesta_ObtenerPersistencia(Response);          
        } 
        catch (Exception e) {
            Respuesta_Persistencia Response = new Respuesta_Persistencia();
            Response.IdPersistencia = 0;
            Response.Response = 'PERSISTENCIA_EXCEPCION';
            System.debug('@@@@|ParameterWS-Exception ED'+ e); 
            return Response;
        }        
    }
        
    public static Respuesta_Persistencia EvaluaRespuesta_ObtenerPersistencia(EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia Respuesta)
    {
        Respuesta_Persistencia Response = new Respuesta_Persistencia();
        Response.IdPersistencia = 0;
        Response.Response = 'PERSISTENCIA_ERROR_INDEFINIDO';
        
        if (Respuesta.Resultado.Codigo == '00') {
            Response.IdPersistencia = Respuesta.IdPersistencia;
            Response.Response = 'PERSISTENCIA_OK';                
        }
        else 
        {
            if (Respuesta.Resultado.Excepcion.contains('Todos los párametros son obligatorios.')){
                Response.Response = 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES';
            }
            else if (Respuesta.Resultado.Excepcion.contains('es inválido  o no posee condiciones validas para acceder.')){
                Response.Response = 'PERSISTENCIA_ERROR_USUARIO_INVALIDO';
            }
            else if (Respuesta.Resultado.Excepcion.contains('no se encuentra registrado.')){
                Response.Response = 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO';
            }
            else if (Respuesta.Resultado.Excepcion.contains('no posee permisos para acceder a Escritorio Digital.')){
                Response.Response = 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED';
            }
            else if (Respuesta.Resultado.Excepcion.contains('La Persistencia es inválida.')){
                Response.Response = 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA';
            }
            else if (Respuesta.Resultado.Excepcion.contains('es inválido.')){   
                Response.Response = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO';
            }
        }

        return Response;
    }
    
    public static Respuesta_Requerimiento crearRequerimiento(Integer idPersistencia, String rutCliente, Integer poliza, String tipoRequerimiento, String rutUsuario) {  
        System.debug('@@@@ crearRequerimiento'+'P:'+idPersistencia+'R:'+rutCliente+'Po:'+poliza+'TR:'+tipoRequerimiento+'US:'+rutUsuario); 
        
        EXT_WS_EscritorioDigital.EscritorioDigitalSoap ED = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
        
        try
        {                   
            EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Response = ED.CrearRequerimiento(idPersistencia, rutCliente, poliza, tipoRequerimiento, rutUsuario, Usuario);
            
            return EvaluaRespuesta_CrearRequerimiento(Response);   
        }
        catch(Exception ex)
        {           
            Respuesta_Requerimiento Salida = new Respuesta_Requerimiento();
            Salida.Codigo = '';
            Salida.Mensaje = '';
            Salida.Excepcion = ex.getMessage();
            System.debug('@@@@|ExcCreaED-0@@'+ex); 
            Salida.IdRequerimiento = 0;
            Salida.Response = 'CREA_REQUERIMIENTO_EXCEPCION';            
            return Salida;
        }
    }
    
    public static Respuesta_Requerimiento EvaluaRespuesta_CrearRequerimiento(EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta) {        
        Respuesta_Requerimiento Salida = new Respuesta_Requerimiento();
        Salida.Codigo = Respuesta.Resultado.Codigo;
        Salida.Mensaje = Respuesta.Resultado.Mensaje;
        System.debug('@@@@ Respuesta --> '+Respuesta); 
        if (Respuesta.Resultado.Codigo == '00')  {
            System.debug('@@jhotha|IdReqED@@'+Respuesta.Requerimiento.IdRequerimiento); 
            Salida.Excepcion = '';
            Salida.IdRequerimiento = Respuesta.Requerimiento.IdRequerimiento;
            Salida.Response = 'REQUERIMIENTO_CREADO';

            if(Salida.IdRequerimiento == 0)
            {
                 Salida.Response = 'REQUERIMIENTO_CERO';   
            }
           // return Respuesta.Requerimiento.IdRequerimiento;            
        }
        else 
        {
            Salida.Excepcion = Respuesta.Resultado.Excepcion;
            Salida.IdRequerimiento = 0;
            System.debug('@@@@|ExcCreaED@@'+Respuesta.Resultado.Excepcion); 
            if (Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.' ||
                Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.')  {
              //Salida.IdRequerimiento = -1;
                Salida.Response = 'RUT_CLIENTE_NO_CORRESPONDE';
            } 
            else if(Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.') {
              //Salida.IdRequerimiento = -2;
                Salida.Response = 'RUT_CLIENTE_SIN_BENEFICIARIOS';
            }  
            else if(Respuesta.Resultado.Excepcion == 'La Poliza ingresada se encuentra obsoleta.') {
                //Salida.IdRequerimiento = -3;
                Salida.Response = 'POLIZA_OBSOLETA';
            }  
            else if(Respuesta.Resultado.Excepcion == 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.') {
                //Salida.IdRequerimiento = -4;
                Salida.Response = 'POLIZA_NO_INGRESADA';
            }  
            else if(Respuesta.Resultado.Excepcion == 'El Cliente ingresado no posee una Poliza activa.') {
                //Salida.IdRequerimiento = -5;
                Salida.Response = 'CLIENTE_SIN_POLIZAS_ACTIVAS';
            }
            else if(Respuesta.Resultado.Excepcion == 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.') {
                //Salida.IdRequerimiento = -6;
                Salida.Response = 'POLIZA_NO_CORRESPONDE';
            }
            else if (Respuesta.Resultado.Excepcion == 'El Requerimiento no está habilitado para productos APV.')
            {
                Salida.Response = 'REQUERIMIENTO_NO_APV';                
            }
            else if (Respuesta.Resultado.Excepcion == 'El Requerimiento está habilitado solo para MAX 3.0')
            {
                Salida.Response = 'REQUERIMIENTO_MAX_3';                
            }
            else if (Respuesta.Resultado.Excepcion == 'El Requerimiento está habilitado solo para productos Mi Seguro.')
            {
                Salida.Response = 'REQUERIMIENTO_MI_SEGURO';                
            }
            
        } 

        return Salida;
    }
    
   public static Respuesta_CambioEstado cambiarEstadoRequerimiento(Integer idRequerimiento, String estado, String rutUsuario)
    {       
        Respuesta_CambioEstado RespuestaCE = new Respuesta_CambioEstado();
        
        try
        {
            EXT_WS_EscritorioDigital.EscritorioDigitalSoap ED = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
            
            EXT_WS_EscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta;
                     	
            if (!Test.isRunningTest())
            {   
                Respuesta = ED.CambiarEstadoRequerimiento(idRequerimiento, estado, rutUsuario);
                System.debug('@@@@|CAMBIOESTADORESP@@'+ Respuesta.Resultado.Codigo); 
            }
            else
            {
                Respuesta = new  EXT_WS_EscritorioDigital.RespuestaCambiarEstadoRequerimiento();
                Respuesta.Resultado = new EXT_WS_EscritorioDigital.Resultado();
                Respuesta.Resultado.Codigo = '00';
                Respuesta.Resultado.Mensaje = 'Mensaje';
                Respuesta.Resultado.Excepcion = 'El requerimiento se encuentra en estado "Ingresado".';
            }

            RespuestaCE.Codigo = Respuesta.Resultado.Codigo;
            RespuestaCE.Mensaje = Respuesta.Resultado.Mensaje;
            RespuestaCE.Excepcion = Respuesta.Resultado.Excepcion;

            System.debug('@@@@|RespuestaCE.Codigo  --> '+ Respuesta.Resultado.Codigo); 
            System.debug('@@@@|RespuestaCE.Mensaje -->'+ Respuesta.Resultado.Mensaje); 
            System.debug('@@@@|RespuestaCE.Excepcion -->'+ Respuesta.Resultado.Excepcion); 

            Boolean respuestaEspecial = false;

            if (RespuestaCE.Excepcion == 'Documentos y firmas inválidas.')
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'PENDIENTE_DOCUMENTOS_VALUETECH';
            }
            else if (RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "Ingresado".') == true ||  RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "INGRESADO".') == true)
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'REQUERIMIENTO_ESTADO_INGRESADO';
            }
            else if (RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "Finalizado".') == true || RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "FINALIZADO".') == true)
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'REQUERIMIENTO_ESTADO_FINALIZADO';
            }
            else if (RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "Pendiente".') == true || RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "PENDIENTE".') == true) //El requerimiento se encuentra en estado "PENDIENTE". No es posible pasarlo al estado "Finalizado"
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'REQUERIMIENTO_ESTADO_PENDIENTE';
            }
            //
            else if (RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "Nuevo".') == true || RespuestaCE.Excepcion.contains('El requerimiento se encuentra en estado "NUEVO".') == true) //El requerimiento se encuentra en estado "NUEVO". No es posible pasarlo al estado "Finalizado"
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'REQUERIMIENTO_ESTADO_NUEVO';
            }            
            else if (RespuestaCE.Excepcion.contains('Requerimiento '+IdRequerimiento+' no existe') == true)
            {
                respuestaEspecial = true;
                RespuestaCE.Response = 'REQUERIMIENTO_NO_CARGADO_VALUETECH';
            }

            if (Test.isRunningTest())
            {
                respuestaEspecial = false;
            }
                
            
            if (respuestaEspecial == false)
            {
                if (Respuesta.Resultado.Codigo == '00')
                {
                    RespuestaCE.Response = 'CAMBIO_ESTADO_OK';
                }
                else if (Respuesta.Resultado.Codigo == '05')
                {                    
                    RespuestaCE.Response = 'VALUETECH_ERROR';// + Respuesta.Resultado.Mensaje;//Error al cambiar estado en ED o Valuetech.          6                                              
                }
                else
                {
                    RespuestaCE.Response = 'CAMBIO_ESTADO_ERROR';//Error al cambiar estado en ED o Valuetech.                      3    
                } 
            }

             
    	}
        catch(Exception ex)
        {
            System.debug('@@@@|CAMBIOESTADOEX@@'+ex); 
        	RespuestaCE.Codigo = '09';//Error de Comunicación con Escritorio Digital';      
            RespuestaCE.Mensaje = ex.getMessage();
            RespuestaCE.Response = 'EXCEPCION';
        }

        System.debug('@@@@|RespuestaCE -->'+ RespuestaCE +' ####'); 
        
         return RespuestaCE;
    }
    
    

}