@istest
public class CLS_AperturaCierreCaso_Controlador_Test {

     @isTest static void CierreCaso_cargaCasoSeleccionado() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();    
        Con.CierreCaso_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_cargaCasoSeleccionado() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = '';
        Con.AperturaCaso_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_cargaCasoSeleccionado_1() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK1';
        Con.AperturaCaso_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_cargaCasoSeleccionado_2() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK2';
        Con.AperturaCaso_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void ToCase() {
        Account cuenta = Factory.cuenta.buildInsert();
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;   
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
        Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
    	Con.caso.Id = caso.Id;
        Con.ToCase();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_cargaCasoSeleccionado() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    
        Con.CierreRequerimiento_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_cargaCasoSeleccionado_1() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK';
        Con.CierreRequerimiento_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_cargaCasoSeleccionado_2() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK1';
        Con.CierreRequerimiento_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_cargaCasoSeleccionadoError() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = '';
        Con.CierreRequerimiento_cargaCasoSeleccionadoError();
        Test.stopTest();
     }
    
    @isTest static void CierreRequerimiento_cargaCasoSeleccionadoError_2() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK';
        Con.CierreRequerimiento_cargaCasoSeleccionadoError();
        Test.stopTest();
     }
    
   
     @isTest static void AperturaRequerimiento_validaAtencion() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = '';
        Con.AperturaRequerimiento_validaAtencion();
        Test.stopTest();
     }
    
    @isTest static void AperturaRequerimiento_validaAtencion_2() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK';
        Con.AperturaRequerimiento_validaAtencion();
        Test.stopTest();
     }
    
     @isTest static void AperturaCasoHijo_cargaCasoSeleccionado() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    
        Con.AperturaCasoHijo_cargaCasoSeleccionado();
        Test.stopTest();
     }
    
     @isTest static void AperturaRequerimiento_GuardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
     	Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
    	Con.caso.Id = caso.Id;
        Con.AperturaRequerimiento_GuardarCaso();
        Test.stopTest();
     }
    
      @isTest static void AperturaCaso_cargaCasoSeleccionadoError() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = '';
        Con.AperturaCaso_cargaCasoSeleccionadoError();
        Test.stopTest();
     }
    
     @isTest static void AperturaCaso_cargaCasoSeleccionadoError1() {
        Test.startTest();
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	Con.Prueba = 'OK';
        Con.AperturaCaso_cargaCasoSeleccionadoError();
        Test.stopTest();
     }
    
     @isTest static void CierreRequerimiento_guardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();         
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;         
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
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
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();
    	 Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
    	Con.caso.Id = caso.Id;         
        Con.AperturaCaso_GuardarCaso();
        Test.stopTest();
     }
    
     @isTest static void CierreCaso_guardarCaso() {
        Account cuenta = Factory.cuenta.buildInsert();         
        Test.startTest();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        CLS_AperturaCierreCaso_Controlador Con = new CLS_AperturaCierreCaso_Controlador();         
    	Con.Caso = new Case();
    	//Con.Caso.Id = '5000R000004eapT';//modificar segun ambiente
    	//Con.Caso.Id = '5000H00001A3tTS';
        Con.caso.Id = caso.Id;
        Con.CierreCaso_guardarCaso();
        Test.stopTest();
     }
}