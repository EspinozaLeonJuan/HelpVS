public class EscritorioNegocio {
	private static String Usuario = 'SALESFORCE';
    //private static String Password = 'Security2017';
    private static String Password = 'S4l3sForce';
    
    public static Integer obtenerPersistencia(String rutUsuario, String userOS, string ip) {        
        try
        {
            WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
            
            WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario, Usuario, Password, ip,useros);        
            
            return EvaluaRespuesta_ObtenerPersistencia(Respuesta);          
        } 
        catch (Exception e) {
            return -6;
        }        
    }
    
    public static String obtenerTPersistencia(String rutUsuario, String userOS, string ip) {        
        try
        {
            WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
            
            WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario, Usuario, Password, ip,useros);        
            
            return String.valueOf(EvaluaRespuesta_ObtenerPersistencia(Respuesta));          
        } 
        catch (Exception e) {
            return e.getMessage();
        }
    }
    
    public static Integer EvaluaRespuesta_ObtenerPersistencia(WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta)
    {
        if (Respuesta.Resultado.Codigo == '00') {
            return Respuesta.IdPersistencia;            
        }
        if (Respuesta.Resultado.Codigo == '01' || Respuesta.Resultado.Codigo == '03') {
            return -1;            
        }       
        
        return 0;
    }
    
    public static Integer crearRequerimiento(Integer idPersistencia, String rutCliente, String tipoRequerimiento, String rutUsuario) {  
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
        
        try
        {
            WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = WSED.CrearRequerimiento(idPersistencia, rutCliente, tipoRequerimiento, rutusuario, Usuario); 
            
            return EvaluaRespuesta_CrearRequerimiento(Respuesta);            
        }
        catch(Exception e) {
            return 0;
        }
    }
    
    public static Integer EvaluaRespuesta_CrearRequerimiento(WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta) {
        if (Respuesta.Resultado.Codigo == '00')  {
            return Respuesta.Requerimiento.IdRequerimiento;            
        }
        else {
            if (Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.' ||
                Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.')  {
                    return -1;
                } 
            else if(Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.') {
                return -2;
            }            
        } 
        
        return 0;
    }
    
    public static String cambiarEstadoRequerimiento(Integer idPersistencia, Integer idRequerimiento, String estado, String rutUsuario) {
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
        
        try
        {
            WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = WSED.CambiarEstadoRequerimiento(idPersistencia, idRequerimiento, estado, rutUsuario, Usuario);
            
            return EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
        }
        catch(Exception ex) {
            return 'Error de Comunicación con Escritorio Digital';                        
        }
    }
    
    public static String EvaluaRespuesta_CambiarEstadoRequerimiento(WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta) {
        if (Respuesta.Resultado.Codigo == '00') {
            return 'ok';            
        }
        
        return Respuesta.Resultado.Excepcion;
    }
    
    //Reemplazar en un futuro por actualizacion de estado desde webservice ED (servidor 64 bits o FUSE)
    public static String obtenerEstadoRequerimiento(String rutUsuario, String userOS, string ip, Integer idRequerimiento)  {
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
        
        try
        {
            WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario, Usuario, Password,ip,useros);        
            
            if (Respuesta.Resultado.Codigo == '00') {            
                WSEscritorioDigital.RespuestaObtenerRequerimiento Requerimiento = ObtenerRequerimiento(Respuesta.IdPersistencia,rutUsuario, idRequerimiento);
                
                if (Requerimiento != null && Requerimiento.Resultado.Codigo == '00') {
                    return Requerimiento.Requerimiento.Estado;                
                }
            }                    
        } 
        catch(Exception ex)  {           
        }
        
        return 'error';            
    }  
    
    //Reemplazar en un futuro por actualizacion de estado desde webservice ED (servidor 64 bits o FUSE)
    public static String obtenerEstadoRequerimiento(Integer IdPersistencia, String rutUsuario, Integer idRequerimiento)  {
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
        
        try
        {
            WSEscritorioDigital.RespuestaObtenerRequerimiento Requerimiento = ObtenerRequerimiento(IdPersistencia,rutUsuario, idRequerimiento);
            
            if (Requerimiento != null && Requerimiento.Resultado.Codigo == '00') {
                return Requerimiento.Requerimiento.Estado;                
            }
        } 
        catch(Exception ex) {            
        }
        
        return 'error';            
    } 
    
    public static WSEscritorioDigital.RespuestaObtenerRequerimiento ObtenerRequerimiento(Integer IdPersistencia, String rutUsuario, Integer idRequerimiento) {
        try
        {
            WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
            WSEscritorioDigital.RespuestaObtenerRequerimiento Requerimiento = WSED.ObtenerRequerimiento(IdPersistencia,idRequerimiento, rutUsuario, Usuario);
            
            return Requerimiento;  
        } 
        catch(Exception ex) {
            return null;
        }
    }
}