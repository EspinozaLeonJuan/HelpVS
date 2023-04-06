@istest
public class CLS_DatosMetricasCasosAntiguos_Test {
	@istest public static void GetTotalCasos_Tipo()
    {
        Test.startTest();
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Tipo = 'Solicitudes';
        CLS_DatosMetricasCasosAntiguos.GetTotalCasos_Tipo(dFecha, Tipo);
        
        Test.stopTest();
    }
    
    @istest public static void GetTotalCasos_Negocio()
    {
        Test.startTest();
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';
        CLS_DatosMetricasCasosAntiguos.GetTotalCasos_Negocio(dFecha, Negocio);
        
        Test.stopTest();
    }
    
    @istest public static void GetTotalCasos_TipoNegocio()
    {
        Test.startTest();
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha); 
        String Negocio = '';
        String Tipo = 'Solicitudes';
        CLS_DatosMetricasCasosAntiguos.GetTotalCasos_TipoNegocio(dFecha, Tipo, Negocio);
        
        Test.stopTest();
    }
    
      @istest public static void GetTotalCasos()
    {
        Test.startTest();
        String fecha = '2018-01-01T00:00:00Z';
        Date dFecha = date.valueOf(fecha);  
        CLS_DatosMetricasCasosAntiguos.GetTotalCasos(dFecha);
        
        Test.stopTest();
    }
    
}