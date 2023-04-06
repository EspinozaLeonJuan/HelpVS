@istest(seeAllData=true)
public class TEST_CTR_UR_Caso_Cartas {
    
    @isTest static void CargaParametros_Caso_Test()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.CargaParametros_Caso();
        Test.stopTest();
    }
    
    @isTest static void Inicia_Carta_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Inicia_Carta_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void Inicia_Carta_Sobreprima_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Carta_Sobreprima__c = true;
        controlador.Inicia_Carta_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void Guarda_Carta_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        
        controlador.Nombre_Carta = 'nombre carta';
        controlador.Direccion_Carta = 'direccion carta';
        controlador.Comuna_Carta = 'comuna carta';
        controlador.Ciudad_Carta = 'ciudad carta';
        controlador.Poliza_Carta = 'poliza carta';   
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_cobertura>(); 
        controlador.Guarda_Carta_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void Actualiza_Carta_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Carta = new Carta_Caso__c();
        controlador.Nombre_Carta = 'nombre carta';
        controlador.Direccion_Carta = 'direccion carta';
        controlador.Comuna_Carta = 'comuna carta';
        controlador.Ciudad_Carta = 'ciudad carta';
        controlador.Poliza_Carta = 'poliza carta';   
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_cobertura>(); 
        controlador.Actualiza_Carta_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void getCoberturas_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.getCoberturas_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void getCoberturas_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.getCoberturas_Exclusion();
        Test.stopTest();
    }
    
    @isTest static void getListaCoberturas_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.getListaCoberturas();
        Test.stopTest();
    }
    
    @isTest static void AddCobertura_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.Contador_Coberturas = 0;
        controlador.Cobertura = 'Cobertura';
        controlador.Sobreprima = '0,69';
        controlador.AddCobertura_Sobreprima();
        Test.stopTest();
    }
    
/*	@isTest static void AddCobertura_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.Contador_Coberturas = 0;
        controlador.Cobertura = 'Cobertura';        
        controlador.AddCobertura_Exclusion();
        Test.stopTest();
    }
  */  
    @isTest static void DeleteCobertura_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        ApexPages.currentPage().getParameters().put('IdCob', '1'); 
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>(); 
        controlador.DeleteCobertura();
        Test.stopTest();
    }
    
    @isTest static void Inicia_Carta_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Inicia_Carta_Exclusion();
        Test.stopTest();
    }
    
    @isTest static void Inicia_Carta_Exclusion_Test_02()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Carta_Exclusion__c = true;
        controlador.Carta = new Carta_Caso__c();
        controlador.Inicia_Carta_Exclusion();
        Test.stopTest();
    }
    
    @isTest static void Guarda_Carta_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);        
        controlador.Nombre_Carta = 'nombre carta';
        controlador.Direccion_Carta = 'direccion carta';
        controlador.Comuna_Carta = 'comuna carta';
        controlador.Ciudad_Carta = 'ciudad carta';
        controlador.Poliza_Carta = 'poliza carta';   
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_cobertura>();
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
        controlador.Guarda_Carta_Exclusion();
        Test.stopTest();
    }
    
    @isTest static void Actualiza_Carta_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Carta = new Carta_Caso__c();
        controlador.Nombre_Carta = 'nombre carta';
        controlador.Direccion_Carta = 'direccion carta';
        controlador.Comuna_Carta = 'comuna carta';
        controlador.Ciudad_Carta = 'ciudad carta';
        controlador.Poliza_Carta = 'poliza carta';   
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_cobertura>(); 
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
        controlador.Actualiza_Carta_Exclusion();
        Test.stopTest();
    }

    @isTest static void AddExclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
        controlador.Contador_Coberturas = 0;
        controlador.Exclusion_Nombre = 'Cobertura';
        controlador.Exclusion_Condicion = '0,69';
        controlador.AddExclusion();
        Test.stopTest();
    }
    
    @isTest static void DeleteExclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        ApexPages.currentPage().getParameters().put('IdCob', '1'); 
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
        controlador.DeleteExclusion();
        Test.stopTest();
    }
    
    @isTest static void generaPfd_CartaSobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Carta = new Carta_Caso__c();        
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
		controlador.Carta.Detalle__c = 'Cobertura1#123&Cobertura2#456';
        controlador.generaPfd_CartaSobreprima();
        
        Test.stopTest();
    }
    
    @isTest static void generaPfd_CartaExclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Carta = new Carta_Caso__c();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
		controlador.Carta.Detalle__c = 'Cobertura1#sobre#123&Cobertura2#sobre#456';
        controlador.generaPfd_CartaExclusion();
        
        Test.stopTest();
    }
    
     @isTest static void cargaPDF_Carta_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Carta = new Carta_Caso__c();
        ApexPages.currentPage().getParameters().put('id', '1');        
        controlador.cargaPDF_Carta_Sobreprima();
        
        Test.stopTest();
    }
    
    @isTest static void cargaPDF_Carta_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Carta = new Carta_Caso__c();
        ApexPages.currentPage().getParameters().put('id', '1');         
		controlador.Carta.Cobertura__c = 'Cobertura1&Cobertura2';
        controlador.cargaPDF_Carta_Exclusion();
        
        Test.stopTest();
    }
    
    @isTest static void getDetalleCarta_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Detalle_Carta  = new List<String>();
        controlador.Detalle_Carta.add('Detalle de carta');
        controlador.getDetalleCarta();
        Test.stopTest();
    }
    
    @isTest static void getCoberturaCarta_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();
        controlador.Cobertura_Carta = new List<String>();
        controlador.Cobertura_Carta.add('Cobertura de carta');
        controlador.getCoberturaCarta();
        Test.stopTest();
    }
    
    @isTest static void Genera_Carta_Sobreprima_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();   
        controlador.Carta = new Carta_Caso__c();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
		controlador.Carta.Cobertura__c = 'Cobertura1#123&Cobertura2#456';
        controlador.Genera_Carta_Sobreprima();
        Test.stopTest();
    }
    
    @isTest static void Genera_Carta_Exclusion_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Cartas controlador = new CTR_UR_Caso_Cartas();    
        controlador.Carta = new Carta_Caso__c();
        controlador.Lista_Coberturas = new List<CTR_UR_Caso_Cartas.Nodo_Cobertura>();
        controlador.Lista_Exclusiones = new List<CTR_UR_Caso_Cartas.Nodo_exclusion>();
		controlador.Carta.Detalle__c = 'Cobertura1#123&Cobertura2#456';
        controlador.Carta.Cobertura__c = 'Cobertura1&Cobertura2';
        controlador.Genera_Carta_Exclusion();
        Test.stopTest();
    }
}