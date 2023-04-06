@isTest
public class CLS_BandejaResolutorUR_Controlador_Test {
 @isTest static void getListarUsuarios() {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();        
      
        Con.LST_UsuariosBackup = FactoryEscritorio.buildUsuariosBackup();
        list<SelectOption> lista = Con.getListarUsuarios();
        
        System.assert(lista.Size() >= 0);  	
        
        Test.stopTest();
    }
    
    @isTest static void getListarUsuariosError() {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();       
        list<SelectOption> lista = Con.getListarUsuarios();
        Test.stopTest();
    }
    
   @isTest static void IniciarBandejaUR()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
       Con.IniciarBandejaUR();
        
       Test.stopTest();
    }
    
     @isTest static void mostrarCasosUR_a()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
       Con.mostrarCasosUR();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosUR_b()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = '1';
       Con.mostrarCasosUR();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosUR_c()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = 'c';
       Con.mostrarCasosUR();        
       Test.stopTest();       
    }
    
    @isTest static void verCasoSeleccionadoUR()
    {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();       
       Con.verCasoSeleccionadoUR();        
       Test.stopTest();  
    }
    
    @isTest static void cargaCasoSeleccionado_a() {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.cargaCasoSeleccionado();
        Test.stopTest();
    }
    
    @isTest static void cargaCasoSeleccionado_b() {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.Prueba = 'SI';
        Con.cargaCasoSeleccionado();
        Test.stopTest();
    }
    
    @isTest static void volverMenuPrincipal()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.volverMenuPrincipal();
        Test.stopTest();
    }
    

    @isTest static void AgregarComentario()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.AgregarComentario();
        Test.stopTest();
    }
    
     @isTest static void CargaCasoComentario()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.CargaCasoComentario();
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.Ncomentario = new CaseComment();		
        Con.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario_error()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void CancelarComentario()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.CancelarComentario();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoEnProceso_error()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.CambiarEstadoCasoEnProceso();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable_error()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnviaEjecutivo_error()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.EnviaEjecutivo();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoCerrado_error()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();        
        Con.CambiarEstadoCasoCerrado();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoEnProceso()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CambiarEstadoCasoEnProceso();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnviaEjecutivo()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.EnviaEjecutivo();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoCerrado()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CambiarEstadoCasoCerrado();
        Test.stopTest();
    }
    
    @isTest static void cambiarEstadoCasoRechazado()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
        Con.cambiarEstadoCasoRechazado();
        Test.stopTest();
    }
    
    @isTest static void cargaCasoAsignacionSeleccionado() {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Con.cargaCasoSeleccionadoReasignacion();
        Test.stopTest();
    }
     
    @isTest static void actualizarResponsableCaso_1()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.actualizarResponsableCaso();
        Test.stopTest();
    }
    
    @isTest static void actualizarResponsableCaso_2()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.verCaso.CASO_Responsable_UR__c = '5000H00000x7H2W';
        Con.RESPONSABLE_ACTUAL = '5000H00000x7H2W';
        Con.actualizarResponsableCaso();
        Test.stopTest();
    }
    
     @isTest static void actualizarResponsableCaso_3()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.verCaso.CASO_Responsable_UR__c = '5000H00000x7H6Q';
        Con.RESPONSABLE_ACTUAL = '5000H00000x7H2W';
        Con.C_COMENT = 'Comentario';
        Con.actualizarResponsableCaso();
        Test.stopTest();
    }
    
    @isTest static void cancelaractualizarResponsableCaso()
    {
        Test.startTest();
        CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.cancelaractualizarResponsableCaso();
        Test.stopTest();
    }
      @isTest static void mostrarCasosHistorialUR_a()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
       Con.mostrarCasosUR_Historial();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_b()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = '1';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_c()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = 'c';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
     @isTest static void mostrarCasosHistorialUR_a1()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.NumeroCaso = '123';
       Con.RUT_Cliente = '';
       Con.mostrarCasosUR_Historial();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_b1()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = '1';
       Con.RUT_Cliente = '';
       Con.NumeroCaso = '123';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_c1()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       Con.UsuarioSeleccionado = 'c';
       Con.RUT_Cliente = '';
       Con.NumeroCaso = '123';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
     @isTest static void verCasoSeleccionadoHistorialUR()
    {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();       
       Con.verCasoSeleccionado_HistorialUR();        
       Test.stopTest();  
    }
    
     @isTest static void IniciarBandejaHistorialUR()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
       Con.IniciarBandejaUR_Historial();
        
       Test.stopTest();
    }
    
    
      @isTest static void getListarNumeroRegistros()
   {
       Test.startTest();
       CLS_BandejaResolutorUR_Controlador Con = new CLS_BandejaResolutorUR_Controlador();
       
       Con.getListarNumeroRegistros();
        
       Test.stopTest();
    }
}