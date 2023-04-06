@isTest
public class EscritorioDigital_Internal_Test {
    
     @isTest static void Solicitud_01() {
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        String Valida =  EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);
        System.debug('@@ED@@ EscritorioDigital_Internal.Etiqueta -> '+ Valida); 
        //System.assert(Valida == 'ED - Solicitud pensión sobrevivencia');  
        Test.stopTest();
    }
    
    @isTest static void Solicitantes_01()
    {
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        List<SelectOption> lista =  EscritorioDigital_Internal.getListaSolicitantes(DetalleSolicitud);
        
       
        Test.stopTest();
    }
    
    @isTest static void Solicitante_01()
    {
        Test.startTest();
        String Tipo = 'RRVVTIPO0005';
        
        String value =  EscritorioDigital_Internal.Solicitante(Tipo);
        
       
        Test.stopTest();
    }
  

	@isTest static void EsUsuarioValido()
    {  
       Test.startTest();
       Boolean valido = EscritorioDigital_Internal.EsUsuarioValido();
       Test.stopTest();
    }
    
    @isTest static void RequerimientoEDIND_01()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Aumento de Prima en Exceso'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_02()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Capital Asegurado'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_03()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Cambio Periodicidad de Pago'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_04()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Eliminar Coberturas'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();
    }
    
    @isTest static void RequerimientoEDIND_05()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Agregar Coberturas'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_06()
    {
        Test.startTest();
        String Solicitud =  'ED - Designación y Actualización de Beneficiarios'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_07()
    {
        Test.startTest();
        String Solicitud =  'ED - Modificación de Tipo de Pago'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_08()
    {
        Test.startTest();
        String Solicitud =  'ED - Cambio de Plan APV Max 3.0 y Dominium Max 3.0'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest(); 
    }
    
    @isTest static void RequerimientoEDIND_09()
    {
        Test.startTest();
        String Solicitud =  'ED - Cambio de Plan Mi Proyecto Seguro y Mi APV Seguro'; 
		Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_10()
    {
        Test.startTest();
        String Solicitud =  'Devolución por Excepción Comercial'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_11()
    {
        Test.startTest();
        String Solicitud =  'Endosos'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_12()
    {
        Test.startTest();
        String Solicitud =  'On Time - Solicitud Renuncia'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_13()
    {
        Test.startTest();
        String Solicitud =  'Siniestro Catastrófico'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_14()
    {
        Test.startTest();
        String Solicitud =  'Siniestro Individuales'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_15()
    {
        Test.startTest();
        String Solicitud =  'Solicitud copia de póliza'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_16()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de ajuste de utilidades'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_17()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de Certificados de cobertura'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_18()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de Certificados Tributarios'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_19()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de copia formulario notificación Ley APV'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_20()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de devolución de prima'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_21()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de problema con Traspaso In'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_22()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de Rescate Parcial'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_23()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de Rescate Total'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_24()
    {
        Test.startTest();
        String Solicitud =  'Solicitud de suspensión de primas'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_25()
    {
        Test.startTest();
        String Solicitud =  'Solicitud Devolución de Prima'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_26()
    {
        Test.startTest();
        String Solicitud =  'Solicitud imputación de pagos'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_27()
    {
        Test.startTest();
        String Solicitud =  'Solicitud Otros Endosos'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_28()
    {
        Test.startTest();
        String Solicitud =  'Solicitud Póliza no Aperturada'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_29()
    {
        Test.startTest();
        String Solicitud =  'Solicitud por disconformidad certificado declaraci√≥n renta'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_30()
    {
        Test.startTest();
        String Solicitud =  'Solicitud préstamo'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_31()
    {
        Test.startTest();
        String Solicitud =  'Solicitud préstamo'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_32()
    {
        Test.startTest();
        String Solicitud =  'Solicitud préstamo'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_33()
    {
        Test.startTest();
        String Solicitud =  'Solicitud préstamo'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_34()
    {
        Test.startTest();
        String Solicitud =  'Solicitud préstamo'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_35()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Modificacion de Prima en Exceso'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_36()
    {
        Test.startTest();
        String Solicitud =  'ED - Solicitud de Rescate Patrimonial'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_37()
    {
        Test.startTest();
        String Solicitud =  'Solicitud refechaje'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_38()
    {
        Test.startTest();
        String Solicitud =  'Solicitud rehabilitación póliza'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
    @isTest static void RequerimientoEDIND_39()
    {
        Test.startTest();
        String Solicitud =  'Solicitud Tarjeta Club Viva'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
    
       @isTest static void RequerimientoEDIND_40()
    {
        Test.startTest();
        String Solicitud =  'Solicitud valores garantizados'; 
        Boolean valido = EscritorioDigital_Internal.RequerimientoEDIND(Solicitud);
        Test.stopTest();        
    }
}