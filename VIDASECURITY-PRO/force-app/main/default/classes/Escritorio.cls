public class Escritorio {
    //En esta clase se deben configurar los item's que son desplegados en las pantallas de solicitudes ED
  public static List<SelectOption> getListaSolicitudes() {
        List<SelectOption> options = new List<SelectOption>();
        boolean exito = false;         
        options.add(new SelectOption('SOL0001','Solicitud Pensión Sobrevivencia'));
        options.add(new SelectOption('SOL0002','Solicitud Cuota Mortuoria'));
        options.add(new SelectOption('SOL0003','Solicitud cambio Pago Pensión'));
        options.add(new SelectOption('SOL0004','Solicitud Periodo Garantizado'));
        options.add(new SelectOption('SOL0006','Solicitud de Asignación Familiar'));
        options.add(new SelectOption('SOL0007','Renovación de Asignación Familiar'));         
        options.add(new SelectOption('SOL0008','Solicitud de Extinción Asignación Familiar'));
        options.add(new SelectOption('SOL0009','Solicitud Garantía Estatal'));
        options.add(new SelectOption('SOL0010','Renuncia Garantía Estatal')); 
        
        return options; 
    }
    
    public static List<SelectOption> getListaSolicitantes(String CodigoSolicitud) {        
        List<SelectOption> options = new List<SelectOption>();        
        if (CodigoSolicitud == 'SOL0001') {
            options.add(new SelectOption('RRVVTIPO0001','Conyuge'));
            options.add(new SelectOption('RRVVTIPO0002','Madre Filiación'));
            options.add(new SelectOption('RRVVTIPO0003','Hijo menor 18 años'));
            options.add(new SelectOption('RRVVTIPO0004','Hijo mayor 18 años')); 
        }
        else if  (CodigoSolicitud == 'SOL0002') {
            options.add(new SelectOption('RRVVTIPO0005','Persona o Entidad que realiza el gasto'));              
        }
        else if  (CodigoSolicitud == 'SOL0003') {
            options.add(new SelectOption('RRVVTIPO0006','Rentista Titular'));   
        }        
        else if  (CodigoSolicitud == 'SOL0004') {
            options.add(new SelectOption('RRVVTIPO0008','Rentista Titular'));            
        }
        else if  (CodigoSolicitud == 'SOL0006') {
            options.add(new SelectOption('RRVVTIPO0013','Afiliado Titular'));            
        }
        else if  (CodigoSolicitud == 'SOL0007') {
            options.add(new SelectOption('RRVVTIPO0016','Afiliado Titular'));       
        }
        else if  (CodigoSolicitud == 'SOL0008') {            
            options.add(new SelectOption('RRVVTIPO0017','Cónyuge'));                        
            options.add(new SelectOption('RRVVTIPO0018','Hijo menor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0019','Hijo mayor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0020','Otros'));            
            options.add(new SelectOption('RRVVTIPO0021','Madre o Padre (Ascendente)'));                        
        }
        else if  (CodigoSolicitud == 'SOL0009') {
            options.add(new SelectOption('RRVVTIPO0022','Afiliado Titular'));            
            options.add(new SelectOption('RRVVTIPO0023','Cónyuge'));            
            options.add(new SelectOption('RRVVTIPO0024','Madre Filiación N/M'));            
            options.add(new SelectOption('RRVVTIPO0025','Hijo menor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0026','Hijo mayor de 18 años'));                        
        }       
        else if (CodigoSolicitud == 'SOL0010') {
            options.add(new SelectOption('RRVVTIPO0027','Afiliado Titular'));             
        }       
        
        return options; 
    }
    
    public static String getSolicitante(String TipoRequerimiento) {
        
        String solicitante = '';
        
        if (TipoRequerimiento == 'RRVVTIPO0001') {
            solicitante = 'Conyuge';           
        }
        else if (TipoRequerimiento == 'RRVVTIPO0002') {
            solicitante = 'Madre Filiación';                   
        }
        else if (TipoRequerimiento == 'RRVVTIPO0003') {
            solicitante = 'Hijo menor 18 años';                       
        }
        else if (TipoRequerimiento == 'RRVVTIPO0004') {
            solicitante = 'Hijo mayor 18 años';          
        }
        else if (TipoRequerimiento == 'RRVVTIPO0005') {
            solicitante = 'Persona o Entidad que realiza el gasto';                  
        }
        else if (TipoRequerimiento == 'RRVVTIPO0006') {
            solicitante = 'Rentista Titular';                  
        }
        else if (TipoRequerimiento == 'RRVVTIPO0008') {
            solicitante = 'Rentista Titular';           
        }
        else if (TipoRequerimiento == 'RRVVTIPO0013') {
            solicitante = 'Afiliado Titular';             
        }
        else if (TipoRequerimiento == 'RRVVTIPO0016') {
            solicitante = 'Afiliado Titular';                         
        }
        else if (TipoRequerimiento == 'RRVVTIPO0017') {
            solicitante = 'Conyuge';             
        }
        else if (TipoRequerimiento == 'RRVVTIPO0018') {
            solicitante = 'Hijo menor de 18 años';             
        }
        else if (TipoRequerimiento == 'RRVVTIPO0019') {
            solicitante = 'Hijo mayor de 18 años';                                     
        }
        else if (TipoRequerimiento == 'RRVVTIPO0020') {
            solicitante = 'Otros'; 
        }
        else if (TipoRequerimiento == 'RRVVTIPO0021') {
            solicitante = 'Madre o Padre (Ascendente)';                   
        }
        else if (TipoRequerimiento == 'RRVVTIPO0022') {
            solicitante = 'Afiliado Titular';                         
        }
        else if (TipoRequerimiento == 'RRVVTIPO0023') {
            solicitante = 'Conyuge';                        
        }
        else if (TipoRequerimiento == 'RRVVTIPO0024') {
            solicitante = 'Madre Filiación N/M';            
        }
        else if (TipoRequerimiento == 'RRVVTIPO0025') {              
            solicitante = 'Hijo menor de 18 años';                      
        }
        else if (TipoRequerimiento == 'RRVVTIPO0026') {
            solicitante = 'Hijo mayor de 18 años';                          
        }
        else if (TipoRequerimiento == 'RRVVTIPO0027') {               
            solicitante = 'Afiliado Titular';           
        }
        
        return solicitante; 
    }
    
    public static String getSolicitud(String CodigoSolicitud) {
        
        String solicitud = '';
        
        if (CodigoSolicitud == 'SOL0001') {
            solicitud = 'Solicitud Pensión Sobrevivencia';
        }
        else if  (CodigoSolicitud == 'SOL0002') {
            solicitud = 'Solicitud Cuota Mortuoria';            
        }
        else if  (CodigoSolicitud == 'SOL0003') {
            solicitud = 'Solicitud cambio Pago Pensión';        
        }        
        else if  (CodigoSolicitud == 'SOL0004') {
            solicitud = 'Solicitud Periodo Garantizado';         
        }
        else if  (CodigoSolicitud == 'SOL0006') {
            solicitud = 'Solicitud de Asignación Familiar';      
        }
        else if  (CodigoSolicitud == 'SOL0007') {
            solicitud = 'Renovación de Asignación Familiar';       
        }
        else if  (CodigoSolicitud == 'SOL0008') {            
            solicitud = 'Solicitud de Extinción Asignación Familiar';
        }
        else if  (CodigoSolicitud == 'SOL0009') {
            solicitud = 'Solicitud Garantía Estatal';
        }       
        else if (CodigoSolicitud == 'SOL0010') {
            solicitud = 'Renuncia Garantía Estatal';
        }       
        
        return solicitud; 
    }
    
    //Reemplazar en un futuro por actualizacion de estado desde webservice ED (servidor 64 bits o FUSE)
    ////Comentar codigo para prueba rapida
    public static String consultaEstadoSolicitud(String RutUsuario, String UserOS, String Ip, Solicitud__c Solicitud) {
        try
        {
            String estado = EscritorioNegocio.obtenerEstadoRequerimiento(RutUsuario, UserOS, Ip, Integer.valueOf(Solicitud.IdRequerimiento__c));
            
            return estado;
        }
        catch(Exception e) {
            return 'error';
        }        
    }
    
    //Reemplazar en un futuro por actualizacion de estado desde webservice ED (servidor 64 bits o FUSE)
    ////Comentar codigo para prueba rapida
    public static String consultaEstadoSolicitud(Integer IdPersistencia, String RutUsuario, Solicitud__c Solicitud)  {
        try
        {
            String estado = EscritorioNegocio.obtenerEstadoRequerimiento(IdPersistencia, RutUsuario, Integer.valueOf(Solicitud.IdRequerimiento__c));
            
            return estado;
        }
        catch(Exception e) {
            return 'error';
        }        
    }
    
     public static String CodigoSolicitud(String Solicitud)
     {
        String CodigoSolicitud = 'SOL0001';
         
        if (Solicitud == 'Solicitud Pensión Sobrevivencia') 
        {
            CodigoSolicitud = 'SOL0001';
        }
        else if (Solicitud == 'Solicitud Cuota Mortuoria') 
        {
            CodigoSolicitud = 'SOL0002';
        }
        else if (Solicitud == 'Solicitud cambio Pago Pensión') 
        {
            CodigoSolicitud = 'SOL0003';
        }
        else if (Solicitud == 'Solicitud Periodo Garantizado') 
        {
            CodigoSolicitud = 'SOL0004';
        }
        else if (Solicitud == 'Solicitud de Asignación Familiar') 
        {
            CodigoSolicitud = 'SOL0006';
        }       
        else if (Solicitud == 'Renovación de Asignación Familiar') 
        {
            CodigoSolicitud = 'SOL0007';
        }  
        else if (Solicitud == 'Solicitud de Extinción Asignación Familiar') 
        {
            CodigoSolicitud = 'SOL0008';
        }
        else if (Solicitud == 'Solicitud Garantía Estatal') 
        {
            CodigoSolicitud = 'SOL0009';
        }
        else if (Solicitud == 'Renuncia Garantía Estatal') 
        {
            CodigoSolicitud = 'SOL0010';
        }
      
        return CodigoSolicitud; 
    }  
}