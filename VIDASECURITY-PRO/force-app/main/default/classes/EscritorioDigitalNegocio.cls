public class EscritorioDigitalNegocio {
	public static Integer obtenerPersistencia(String rutUsuario, String userOS, string ip)
    {        
        try
        {
            WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
      
			String usuario = 'SALESFORCE';        
        	String password = 'S4l3sForce';      
            
            WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario,usuario,password,ip,useros);        
            return EvaluaRespuesta_ObtenerPersistencia(Respuesta);          
		} 
        catch (Exception e) {
     		return -6;
		}
        
        //return 0;
    }
    
    public static Integer EvaluaRespuesta_ObtenerPersistencia(WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta)
    {
        if (Respuesta.Resultado.Codigo == '00')
        {
            return Respuesta.IdPersistencia;            
        }
        if (Respuesta.Resultado.Codigo == '01' || Respuesta.Resultado.Codigo == '03')
        {
            return -1;            
        }       
        
        return 0;
    }
    
    public static Integer crearRequerimiento(Integer idPersistencia, String rutCliente, String tipoRequerimiento, String rutUsuario) {  
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
        String usuario = 'SALESFORCE';   
        try
        {
            WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta = WSED.CrearRequerimiento(idPersistencia, rutCliente, tipoRequerimiento, rutusuario, usuario); 
        /*    if (Respuesta.Resultado.Codigo == '00')
            {
                return Respuesta.Requerimiento.IdRequerimiento;            
            }
            else
            {
                if (Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.' ||
                    Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.')
                {
                    return -1;
                } 
                else if(Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.')
                {
                    return -2;
                }            
            } */
            return EvaluaRespuesta_CrearRequerimiento(Respuesta);
        }catch(Exception e)
        {
            
        }
        
        return 0;
    }
    
    public static Integer EvaluaRespuesta_CrearRequerimiento(WSEscritorioDigital.RespuestaCrearRequerimiento Respuesta)
    {
        if (Respuesta.Resultado.Codigo == '00')
        {
            return Respuesta.Requerimiento.IdRequerimiento;            
        }
        else
        {
            if (Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no es válido o no corresponde a ningún asegurado registrado.' ||
                Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no pertenece a ningún Asegurado existente en la plataforma.')
            {
                return -1;
            } 
            else if(Respuesta.Resultado.Excepcion == 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.')
            {
                return -2;
            }            
        } 
        
        return 0;
    }
    
    public static String cambiarEstadoRequerimiento(Integer idPersistencia, Integer idRequerimiento, String estado, String rutUsuario)
    {
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
     	String usuario = 'SALESFORCE';  
        try
        {
         	WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta = WSED.CambiarEstadoRequerimiento(idPersistencia, idRequerimiento, estado, rutUsuario, usuario);
            
            return EvaluaRespuesta_CambiarEstadoRequerimiento(Respuesta);
    	}
        catch(Exception ex)
        {
        	return 'Error de Comunicación con Escritorio Digital';                        
        }
    }
    
    public static String EvaluaRespuesta_CambiarEstadoRequerimiento(WSEscritorioDigital.RespuestaCambiarEstadoRequerimiento Respuesta)
    {
        if (Respuesta.Resultado.Codigo == '00')
        {
            return 'ok';            
        }
            
        return Respuesta.Resultado.Excepcion;
    }
    
   /* public static String obtenerEstadoRequerimiento(String rutUsuario, String userOS, string ip, Integer idRequerimiento)
    {
        WSEscritorioDigital.BasicHttpBinding_Servicio WSED = new WSEscritorioDigital.BasicHttpBinding_Servicio();
      
		String usuario = 'SALESFORCE';        
        String password = 'S4l3sForce';        
          
        WSEscritorioDigital.RespuestaObtenerPersistencia Respuesta = WSED.ObtenerPersistencia(rutusuario,usuario,password,ip,useros);        
   		
        if (Respuesta.Resultado.Codigo == '00')
        {            
            WSEscritorioDigital.RespuestaObtenerRequerimiento Requerimiento = WSED.ObtenerRequerimiento(Respuesta.IdPersistencia,idRequerimiento, rutUsuario, usuario);
           
            if (Requerimiento.Resultado.Codigo == '00')
            {
				return Requerimiento.Requerimiento.Estado;                
            }
            else
            {
            	return 'errorReq';                
            }
            
        }
        if (Respuesta.Resultado.Codigo == '01' || Respuesta.Resultado.Codigo == '03')
        {
            return 'errorPer';            
        }        
        
        return 'errorPer';            
    }
    */
}