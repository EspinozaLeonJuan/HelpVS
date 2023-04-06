@istest
public class CLS_DatosMetricasCasos_Test {
	@istest public static void GetMetricasCasos_Derivacion_Solicitud()
    {
        Test.startTest();
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String solicitud = '';
        CLS_DatosMetricasCasos.GetMetricasCasos_Derivacion_Solicitud(dFecha, solicitud);
        
        Test.stopTest();
    }
    
            
    @istest public static void GetMetricasCasos_Derivacion_EstadoSolicitud()
    {
        Test.startTest();
        
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String solicitud = '';
        String estado = '';
        CLS_DatosMetricasCasos.GetMetricasCasos_Derivacion_EstadoSolicitud(dFecha, solicitud, estado);
       
        Test.stopTest();
    }
   
   
    
    @istest public static void GetTotalCasos_Atencion()
    {
        Test.startTest();
       
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        CLS_DatosMetricasCasos.GetTotalCasos_Atencion(dFecha);
        
        Test.stopTest();
        
    }
    
     @istest public static void GetTotalCasos_Requerimientos()
    {
        Test.startTest();
       
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Tipo = 'Solicitudes';
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos(dFecha, Tipo);
        
        Test.stopTest();
        
    }
    
     @istest public static void GetTotalCasos_Atencion_Negocio()
    {
        Test.startTest();
        
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';        
       
        CLS_DatosMetricasCasos.GetTotalCasos_Atencion_Negocio(dFecha, Negocio);
        
        Test.stopTest();
        
    }
    
     @istest public static void GetTotalCasos_Requerimientos_Negocio()
    {
        Test.startTest();
        
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';        
       
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos_Negocio(dFecha, Negocio);
        
        Test.stopTest();
        
    }
    
    @istest public static void GetTotalCasos_Requerimientos_TipoNegocio()
    {
        Test.startTest();
        
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';   
        String Tipo = 'Solicitudes';
        
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos_TipoNegocio(dFecha, Tipo, Negocio);
        
        Test.stopTest();
        
    }
        
    @istest public static void GetTotalCasos_Requerimientos_Derivacion_Negocio()
    {
        Test.startTest();
       
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';   
        
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos_Derivacion_Negocio(dFecha, Negocio);
        
        Test.stopTest();
        
    }
    
    @istest public static void GetTotalCasos_Requerimientos_Derivacion_Negocio_EnRevision()
    {
        Test.startTest();
       
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';   
        
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos_Derivacion_Negocio_EnRevision(dFecha, Negocio);
        
        Test.stopTest();
        
    }
    
    @istest public static void GetTotalCasos_Requerimientos_Derivacion_NegocioEstado()
    {
        Test.startTest();
        
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';   
        String Estado = '';
        
        CLS_DatosMetricasCasos.GetTotalCasos_Requerimientos_Derivacion_Negocio(dFecha, Negocio, Estado);
        
        Test.stopTest();
        
    }
    
    
}