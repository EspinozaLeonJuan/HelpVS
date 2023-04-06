public class CLS_DatosMetricasCasos {

    public static Integer GetMetricasCasos_Derivacion_Solicitud(Date dFecha, String solicitud)
    {
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: 'Solicitudes'].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  and CreatedDate >: dFecha 
                            and Detalle_Solicitud__c =: solicitud  and CASO_Responsable_UR__c != null];
         	
        return value;
    }
    
    public static Integer GetMetricasCasos_Derivacion_EstadoSolicitud(Date dFecha, String solicitud, String estado)
    {
         String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: 'Solicitudes'].Id;
        
         Integer value  = [Select Count() From Case Where RecordTypeId =:IdRegistro  and CreatedDate >: dFecha 
                            and Detalle_Solicitud__c =: solicitud and Status =: estado  and CASO_Responsable_UR__c != null];
        
        return value;
    }
    /*
    //entrega # Total de Casos generados desde una fecha 
    private static Integer GetTotalCasos(Date dFecha)
    {       
        List<Case> result = [Select Id From Case Where CreatedDate >: dFecha];
        
        Integer value = result.size();
         	
        return value;
    }
*/
    
    //entrega # Total de Casos Atencion generados desde una fecha 
    public static Integer GetTotalCasos_Atencion(Date dFecha)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: 'Atención'].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  and CreatedDate >: dFecha and
                          (Negocio__c = 'RRVV' or Negocio__c = 'Seguros Colectivos' or
    					   Negocio__c = 'Seguros Familiares' or Negocio__c = 'Seguros Masivos' or
        				   Negocio__c = 'Sin Linea de Negocio' or Negocio__c = 'Seguros Individuales')
                        ];
        
        return value;
    }
    
    //entrega # Total de Casos requerimientos (tipo) generados desde una fecha 
    public static Integer GetTotalCasos_Requerimientos(Date dFecha, String Tipo)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: Tipo].Id;
        
        
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro and
                          (Negocio__c = 'RRVV' or Negocio__c = 'Seguros Colectivos' or
    					   Negocio__c = 'Seguros Familiares' or Negocio__c = 'Seguros Masivos' or
        				   Negocio__c = 'Sin Linea de Negocio' or Negocio__c = 'Seguros Individuales')
                         and CreatedDate >: dFecha and ParentId != null];
         	
        return value;
    }
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Atencion x negocio generados desde una fecha 
    public static Integer GetTotalCasos_Atencion_Negocio(Date dFecha, String Negocio)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Atención'].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  
                             and CreatedDate >: dFecha  
                            and Negocio__c =: Negocio];
        
       
        return value;
    }
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Requerimientos x negocio generados desde una fecha 
    public static Integer GetTotalCasos_Requerimientos_Negocio(Date dFecha, String Negocio)
    {             
        String IdRegistroCON = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Consultas'].Id;
        String IdRegistroREC = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Reclamos'].Id;
        String IdRegistroSOL = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        Integer value = [Select Count() From Case Where CreatedDate >: dFecha and ParentId != null
                            and Negocio__c =: Negocio and 
                             (RecordTypeId =: IdRegistroCON or RecordTypeId =: IdRegistroREC or RecordTypeId =: IdRegistroSOL)];
         	
        return value;
    }  
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Requerimientos x negocio y tipo generados desde una fecha
    public static Integer GetTotalCasos_Requerimientos_TipoNegocio(Date dFecha, String Tipo, String Negocio)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: Tipo].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  
                             and CreatedDate >: dFecha and ParentId != null
                            and Negocio__c =: Negocio];
         	
        return value;
    }
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Requerimientos derivados x negocio generados desde una fecha 
    public static Integer GetTotalCasos_Requerimientos_Derivacion_Negocio(Date dFecha, String Negocio)
    {   
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        Integer value  = [Select Count() From Case Where CreatedDate >: dFecha and ParentId != null
                            and Negocio__c =: Negocio and RecordTypeId =: IdRegistro  and CASO_Responsable_UR__c != null];
         	
        return value;
    } 
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Requerimientos derivados x negocio generados desde una fecha 
    public static Integer GetTotalCasos_Requerimientos_Derivacion_Negocio_EnRevision(Date dFecha, String Negocio)
    {   
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        List<Case> result = [Select Id From Case Where CreatedDate >: dFecha and ParentId != null
                            and Negocio__c =: Negocio and RecordTypeId =: IdRegistro and Status = 'En Revisión'];
        
        Integer value = result.size();
         	
        return value;
    } 
    
    //RRVV
    //Seguros Colectivos
    //Seguros Familiares
    //Seguros Individuales
    //Seguros Masivos
    //Sin Linea de Negocio
    
    //entrega # Total de Casos Requerimientos derivados x negocio y estado (resultado) generados desde una fecha 
    public static Integer GetTotalCasos_Requerimientos_Derivacion_Negocio(Date dFecha, String Negocio, String Estado)
    {   
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        List<Case> result = [Select Id From Case Where CreatedDate >: dFecha and ParentId != null
                            and Negocio__c =: Negocio and RecordTypeId =: IdRegistro  and CASO_Responsable_UR__c != null
                            and Status =: Estado];
        
        Integer value = result.size();
         	
        return value;
    } 
    
}