public class CLS_DatosMetricasCasosAntiguos {
	
       
    //retorna # Solicitudes/Reclamos/Consultas para casos antiguos
    public static Integer GetTotalCasos_Tipo(Date dFecha, String Tipo)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: Tipo].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  and CreatedDate >: dFecha and ParentId = null];
         	
        return value;
    }    
    
     //retorna # x Negocio para casos antiguos    
    public static Integer GetTotalCasos_Negocio(Date dFecha, String Negocio)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Atención'].Id;
        
        Integer value = [Select Count() From Case Where CreatedDate >: dFecha and ParentId = null and 
                             RecordTypeId !=: IdRegistro 
                            and Negocio__c =: Negocio];
         	
        return value;
    }
  
    //retorna # x Negocio-Tipo para casos antiguos    
    public static Integer GetTotalCasos_TipoNegocio(Date dFecha, String Tipo, String Negocio)
    {        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name =: Tipo].Id;
        
        Integer value = [Select Count() From Case Where RecordTypeId =:IdRegistro  
                             and CreatedDate >: dFecha and ParentId = null
                            and Negocio__c =: Negocio];
        
        return value;
    }
    
    //retorna # Casos antiguos desde una fecha determinada
    public static Integer GetTotalCasos(Date dFecha)
    {             
        String IdRegistroCON = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Consultas'].Id;
        String IdRegistroREC = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Reclamos'].Id;
        String IdRegistroSOL = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        Integer value = [Select Count() From Case Where CreatedDate >: dFecha and ParentId = null and                         
                             (RecordTypeId =: IdRegistroCON or RecordTypeId =: IdRegistroREC or RecordTypeId =: IdRegistroSOL)];
       
        return value;
    }  
    
}