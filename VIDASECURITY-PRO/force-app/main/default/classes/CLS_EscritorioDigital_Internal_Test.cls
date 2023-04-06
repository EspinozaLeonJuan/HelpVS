@istest
public  class CLS_EscritorioDigital_Internal_Test {
    
     @isTest static void Solicitud_01() { 
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        String Valida =  CLS_EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);
        System.debug('@@ED@@ CLS_EscritorioDigital_Internal.Etiqueta -> '+ Valida); 
        //System.assert(Valida == 'ED - Solicitud pensión sobrevivencia');  
        Test.stopTest();
    }
    
    @isTest static void Solicitantes_01()
    {
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        List<SelectOption> lista =  CLS_EscritorioDigital_Internal.getListaSolicitantes(DetalleSolicitud);
        
       
        Test.stopTest();
    }
    
    @isTest static void Solicitante_01()
    {
        Test.startTest();
        String Tipo = 'RRVVTIPO0005';
        
        String value =  CLS_EscritorioDigital_Internal.Solicitante(Tipo);
        
       
        Test.stopTest();
    }
  

	

}