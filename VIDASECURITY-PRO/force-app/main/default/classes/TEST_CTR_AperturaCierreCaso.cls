@istest
public class TEST_CTR_AperturaCierreCaso {
     @isTest static void CierreAtencion_cargaCaso() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();    
        Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        Con.CierreAtencion_cargaCaso();
        Test.stopTest();
     }
    
    @isTest static void CierreAtencion_cargaCaso_1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();    
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.CierreAtencion_cargaCaso();
        Test.stopTest();
     }
    
     @isTest static void AperturaAtencion_cargaCaso() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();  
        Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        Con.AperturaAtencion_cargaCaso();
        Test.stopTest();
     }
    
     @isTest static void AperturaAtencion_cargaCaso_1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();        
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.AperturaAtencion_cargaCaso();
        Test.stopTest();
     }
    
     @isTest static void ToCase() {
        Account cuenta = Factory.cuenta.buildInsert();
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;   
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
        Con.Caso = new Case();    	
    	Con.caso.Id = caso.Id;
        Con.ToCase();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_cargaCaso() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
           Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        Con.CierreRequerimiento_cargaCaso();
        Test.stopTest();
     }
    
    @isTest static void CierreRequerimiento_cargaCaso1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();           
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.CierreRequerimiento_cargaCaso();
        Test.stopTest();
     }
   
     @isTest static void CierreRequerimiento_cargaCasoError_1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
                Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
         ApexPages.currentPage().getParameters().put('mensaje', 'caso_enproceso_sinasignar');
        Con.CierreRequerimiento_cargaCasoError();
        Test.stopTest();
     }
    
    @isTest static void CierreRequerimiento_cargaCasoError_2() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
               Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        ApexPages.currentPage().getParameters().put('mensaje', 'caso_nuevosinasignar');
        Con.CierreRequerimiento_cargaCasoError();
        Test.stopTest();
     }
    
    @isTest static void CierreRequerimiento_cargaCasoError_3() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();               
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.CierreRequerimiento_cargaCasoError();
        Test.stopTest();
     }
   
     @isTest static void AperturaRequerimiento_valida_1() {
         Test.startTest();
         CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
         Account cuenta = Factory.cuenta.buildInsert();  
         Case casoAt = Factory.buildCasoSF('Atención', cuenta);
         insert casoAt;
         Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
         caso.ParentId = casoAt.Id;
         insert caso;
         ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
         Con.AperturaRequerimiento_validaAtencion();         
         Test.stopTest();
     }
    
     @isTest static void AperturaRequerimiento_valida_2() {
         Test.startTest();
         CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();         
         ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
         Con.AperturaRequerimiento_validaAtencion();         
         Test.stopTest();
     }
  
    
     @isTest static void AperturaRequerimiento_cargaCaso() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
           Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        Con.AperturaRequerimiento_cargaCaso();
        Test.stopTest();
     }
    
    @isTest static void AperturaRequerimiento_cargaCaso_1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();         
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.AperturaRequerimiento_cargaCaso();
        Test.stopTest();
     }
     @isTest static void AperturaRequerimiento_GuardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
     	Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
    	Con.caso.Id = caso.Id;
        Con.AperturaRequerimiento_GuardarCaso();
        Test.stopTest();
     }
    
      @isTest static void AperturaCaso_cargaCasoSeleccionadoError() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
        Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        ApexPages.currentPage().getParameters().put('id', String.valueOf(caso.Id));
        Con.AperturaAtencion_cargaCasoError();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_cargaCasoSeleccionadoError1() {
        Test.startTest();
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
         
        ApexPages.currentPage().getParameters().put('id', String.valueOf(''));
        Con.AperturaAtencion_cargaCasoError();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_guardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();         
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;         
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
        Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
        Con.caso.Id = caso.Id;
        Con.CierreRequerimiento_guardarCaso();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_GuardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();         
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;         
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();
    	 Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
    	Con.caso.Id = caso.Id;         
        Con.AperturaAtencion_GuardarCaso();
        Test.stopTest();
     }
    
     @isTest static void CierreCaso_guardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();         
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();         
    	Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
        Con.caso.Id = caso.Id;
        Con.CierreAtencion_guardarCaso();
        Test.stopTest();
     }
    
    @isTest static void getCaso() {        
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
       // String Id = [Select Id from Case limit 1].Id;        
        CTR_AperturaCierreCaso Con = new CTR_AperturaCierreCaso();         
    	Con.GetCaso(caso.Id);
        Test.stopTest();
     }
}