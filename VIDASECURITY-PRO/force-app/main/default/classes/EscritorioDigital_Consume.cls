public class EscritorioDigital_Consume {
    
    public class Respuesta_CambioEstado{
        public String Codigo {get; set;}
        
        public String Mensaje {get; set;}
        
        public Integer SalidaLlamada {get; set;} // se completa informacion donde es llamada la funcion cambio Estado
    }
    
    public class Respuesta_Requerimiento{
        public String Codigo {get; set;}
        
        public String Mensaje {get; set;}
         
        public String Excepcion {get; set;}
        
        public Integer IdRequerimiento {get; set;} 
    }
    
    private static String Usuario = 'SALESFORCE';
    //private static String Password = 'Security2017';
    private static String Password = 'S4l3sForce';
        
    public static Integer obtenerPersistencia(String rutUsuario, String userOS, string ip) {        
        try
        {
            Ws_EscritorioDigital_Principal.EscritorioDigitalSoap ED = new Ws_EscritorioDigital_Principal.EscritorioDigitalSoap();
            
            System.debug('@@@@|ParameterWS-Persistencia@@'+'R:'+rutUsuario+'Po:'+userOS+'IR:'+ip); 
       
            Ws_EscritorioDigital_Principal.RespuestaObtenerPersistencia Response = ED.ObtenerPersistencia(rutUsuario, Usuario, Password, ip, userOS);
            System.debug('@@@@|ParameterWS-Response ED'+ Response);             
            return EvaluaRespuesta_ObtenerPersistencia(Response);          
        } 
        catch (Exception e) {
             System.debug('@@@@|ParameterWS-Exception ED'+ e); 
            return -2;
        }        
    }
        
    public static Integer EvaluaRespuesta_ObtenerPersistencia(Ws_EscritorioDigital_Principal.RespuestaObtenerPersistencia Respuesta)
    {
        if (Respuesta.Resultado.Codigo == '00') {
            return Respuesta.IdPersistencia;            
        }
        if (Respuesta.Resultado.Codigo == '01' || Respuesta.Resultado.Codigo == '03') {
            return -1;            
        }       
        
        return 0;
    }
    
        public static Respuesta_Requerimiento crearRequerimiento(Integer idPersistencia, String rutCliente, Integer poliza, String tipoRequerimiento, String rutUsuario) {  
       //return idPersistencia + '  '+ rutCliente+ '  '+ poliza+ '  '+ tipoRequerimiento+ '  '+ rutUsuario;
       
        System.debug('@@@@|ParameterWS-CreaReq@@'+'P:'+idPersistencia+'R:'+rutCliente+'Po:'+poliza+'TR:'+tipoRequerimiento+'US:'+rutUsuario); 
        
        Ws_EscritorioDigital_Principal.EscritorioDigitalSoap ED = new Ws_EscritorioDigital_Principal.EscritorioDigitalSoap();
        
        try
        {                   
            Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Response = ED.CrearRequerimiento(idPersistencia, rutCliente, poliza, tipoRequerimiento, rutUsuario, Usuario);
            
            return EvaluaRespuesta_CrearRequerimiento(Response);   
        }
        catch(Exception ex)
        {           
            Respuesta_Requerimiento Salida = new Respuesta_Requerimiento();
            Salida.Codigo = '';
            Salida.Mensaje = '';
            Salida.Excepcion = ex.getMessage();
            System.debug('@@@@|ExcCreaED-0@@'+ex); 
            Salida.IdRequerimiento = -7;            
            return Salida;
        }
    }
    
    public static Respuesta_Requerimiento EvaluaRespuesta_CrearRequerimiento(Ws_EscritorioDigital_CR.RespuestaCrearRequerimiento Respuesta) {
        //System.debug('@@jhotha|Respuesta@@'+Respuesta); 
        
        Respuesta_Requerimiento Salida = new Respuesta_Requerimiento();
        Salida.Codigo = Respuesta.Resultado.Codigo;
        Salida.Mensaje = Respuesta.Resultado.Mensaje;
        
        if (Respuesta.Resultado.Codigo == '00')  {
            System.debug('@@jhotha|IdReqED@@'+Respuesta.Requerimiento.IdRequerimiento); 
            Salida.Excepcion = '';
            Salida.IdRequerimiento = Respuesta.Requerimiento.IdRequerimiento;
           // return Respuesta.Requerimiento.IdRequerimiento;            
        }
        else 
        {
            Salida.Excepcion = Respuesta.Resultado.Excepcion;
             Salida.IdRequerimiento = 0;
            System.debug('@@jhotha|ExcCreaED@@'+Respuesta.Resultado.Excepcion); 
            if (Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.' ||
                Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.')  {
                    Salida.IdRequerimiento = -1;
            } 
            else if(Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.') {
                Salida.IdRequerimiento = -2;
            }  
            else if(Respuesta.Resultado.Excepcion == 'La Poliza ingresada se encuentra obsoleta.') {
                Salida.IdRequerimiento = -3;
            }  
            else if(Respuesta.Resultado.Excepcion == 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.') {
                Salida.IdRequerimiento = -4;
            }  
            else if(Respuesta.Resultado.Excepcion == 'El Cliente ingresado no posee una Poliza activa.') {
                Salida.IdRequerimiento = -5;
            }
            else if(Respuesta.Resultado.Excepcion == 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.') {
                Salida.IdRequerimiento = -6;
            }
        } 
       
        
        
        return Salida;
    }
    
    public static Respuesta_CambioEstado cambiarEstadoRequerimiento(Integer idRequerimiento, String estado, String rutUsuario)
    {       
        Respuesta_CambioEstado RespuestaCE = new Respuesta_CambioEstado();
        
        try
        {
            Ws_EscritorioDigital_Principal.EscritorioDigitalSoap ED = new Ws_EscritorioDigital_Principal.EscritorioDigitalSoap();
            
         	Ws_EscritorioDigital_Principal.RespuestaCambiarEstadoRequerimiento Respuesta = ED.CambiarEstadoRequerimiento(idRequerimiento, estado, rutUsuario);
            System.debug('@@@@|CAMBIOESTADORESP@@'+ Respuesta.Resultado.Codigo); 
            
            
            RespuestaCE.Codigo = Respuesta.Resultado.Codigo;
            RespuestaCE.Mensaje = Respuesta.Resultado.Excepcion;
           
    	}
        catch(Exception ex)
        {
            System.debug('@@@@jhotha|CAMBIOESTADOEX@@'+ex); 
        	RespuestaCE.Codigo = '09';//Error de Comunicación con Escritorio Digital';      
            RespuestaCE.Mensaje = ex.getMessage();
        }
        
         return RespuestaCE;
    }
    
  
}