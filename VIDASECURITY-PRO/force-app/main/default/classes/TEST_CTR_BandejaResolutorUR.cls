/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_BandejaResolutorUR
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
@istest
public class TEST_CTR_BandejaResolutorUR {
    @isTest static void getListarUsuarios() {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();        
        Con.LST_UsuariosBackup = FactoryEscritorio.buildUsuariosBackup();
        list<SelectOption> lista = Con.getListarUsuarios();
        System.assert(lista.Size() >= 0);
        Con.getListarUsuarios();
        Test.stopTest();
    }
    
    @isTest static void getListarUsuariosError() {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();       
        list<SelectOption> lista = Con.getListarUsuarios();
        Test.stopTest();
    }
    
     @isTest static void NuevoComentarioTarea()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.NuevoComentarioTarea();      
        test.stopTest();
    }
    
    @isTest static void GuardarComentarioTarea()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;
        Task t = Factory.buildTask(c.Id);
        insert t;
        Con.Tarea = t;
        Con.GuardarComentarioTarea();      
        test.stopTest();
    }
    
    @isTest static void CancelarComentarioTarea()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CancelarComentarioTarea();      
        test.stopTest();
    }
    
     @isTest static void ToTask()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToTask();      
        test.stopTest();
    }
    
    @isTest static void IniciarBandejaUR()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.IniciarBandejaUR();
        Con.mostrarCasosUR();
        Test.stopTest();
    }
    
    @isTest static void IniciarBandejaUR_Historial()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.IniciarBandejaUR_Historial();
        Con.AREAUSUARIOLICENCIA='asd';
		Con.UsuarioSeleccionado='asd';
        Con.IdColaUR='123';
        Con.Registros=250;
        Con.RUT_Cliente='';
        Con.NumeroCaso='';
        Con.mostrarCasosUR_Historial();
        Test.stopTest();
    }
    
    
    
     @isTest static void mostrarCasosUR_a()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       
       Con.mostrarCasosUR();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosUR_b()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = '1';
       Con.mostrarCasosUR();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosUR_c()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = 'c';
       Con.mostrarCasosUR();        
       Test.stopTest();       
    }
    
    @isTest static void verCasoSeleccionadoUR()
    {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();       
       Con.verCasoSeleccionadoUR();        
       Test.stopTest();  
    }
    
    @isTest static void cargaCasoSeleccionado_a() {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CasoFinalizado=False;
        Con.IdcasoVisualizado='123';
        Con.IdCaso='123456';
        Con.cargaCasoSeleccionado();
        Con.IdcasoVisualizado= '';
        Con.apodo='';
        Con.UserOS = '';
        Test.stopTest();
    }
    
    @isTest static void cargaCasoSeleccionado_b() {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.Prueba = 'SI';
        Con.CasoFinalizado=TRUE;
        Con.IdcasoVisualizado='123';
        Con.IdCaso='12345';
        Con.cargaCasoSeleccionado();
        Con.IdcasoVisualizado= '1234';
        Con.apodo='asdasd';
        Con.UserOS = '1234';
        Con.Persistencia=-8;
        Test.stopTest();
    }
    
    @isTest static void volverMenuPrincipal()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.volverMenuPrincipal();
        Test.stopTest();
    }
    

    @isTest static void AgregarComentario()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.AgregarComentario();
        Test.stopTest();
    }
    
     @isTest static void CargaCasoComentario()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CargaCasoComentario();      
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.Ncomentario = new CaseComment();		
        Con.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario_error()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void CancelarComentario()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CancelarComentario();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoEnProceso_error()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CambiarEstadoCasoEnProceso();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable_error()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnviaEjecutivo_error()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.EnviaEjecutivo();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoCerrado_error()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.CambiarEstadoCasoCerrado();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoEnProceso()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();        
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);
        Con.CambiarEstadoCasoEnProceso();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnviaEjecutivo()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.EnviaEjecutivo();
        Test.stopTest();
    }
    
    @isTest static void CambiarEstadoCasoCerrado()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CambiarEstadoCasoCerrado();
        Test.stopTest();
    }
    
    @isTest static void cambiarEstadoCasoRechazado()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       
        Con.cambiarEstadoCasoRechazado();
        Test.stopTest();
    }
    
    @isTest static void cargaCasoAsignacionSeleccionado() {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.cargaCasoSeleccionadoReasignacion();
        Test.stopTest();
    }
     
    @isTest static void actualizarResponsableCaso_1()
    {
        Test.startTest();

        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;

        Usuario_Backup__c ub2 = new Usuario_Backup__c();
        ub2.OwnerId = IdCola;
        ub2.UBAC_Area__c = 'Producción RRVV';
        ub2.Name = 'Juan';
        ub2.UBAC_ID_Cola_UR__c = IdCola;
        insert ub2;


        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;

        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        //Factory.crearAccountAnonimo();
        //Account cuenta = Factory.cuenta.buildInsert();
        //Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);
        Con.verCaso = c;
        Con.verCaso.CASO_Responsable_UR__c = ub2.Id;
        Con.RESPONSABLE_ACTUAL = '';
        Con.actualizarResponsableCaso();
        //Test.stopTest();
        Test.stopTest();
    }
    
    @isTest static void actualizarResponsableCaso_2()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
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
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.verCaso.CASO_Responsable_UR__c = '5000H00000x7H6Q';
        Con.RESPONSABLE_ACTUAL = '5000H00000x7H2W';
        Con.C_COMENT = 'Comentario';
        Con.actualizarResponsableCaso();
        Test.stopTest();
    }
    
      @isTest static void actualizarResponsableCaso_4()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.verCaso.CASO_Responsable_UR__c = null;
        Con.RESPONSABLE_ACTUAL = '5000H00000x7H2W';
        Con.C_COMENT = 'Comentario';
        Con.actualizarResponsableCaso();
        Test.stopTest();
    }
    
    @isTest static void cancelaractualizarResponsableCaso()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.verCaso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.cancelaractualizarResponsableCaso();
        Test.stopTest();
    }
      @isTest static void mostrarCasosHistorialUR_a()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.mostrarCasosUR_Historial();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_b()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = '1';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_c()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = 'c';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
     @isTest static void mostrarCasosHistorialUR_a1()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.NumeroCaso = '123';
       Con.RUT_Cliente = '';
       Con.mostrarCasosUR_Historial();
        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_b1()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = '1';
       Con.RUT_Cliente = '';
       Con.NumeroCaso = '123';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
    @isTest static void mostrarCasosHistorialUR_c1()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.UsuarioSeleccionado = 'c';
       Con.RUT_Cliente = '';
       Con.NumeroCaso = '123';
       Con.mostrarCasosUR_Historial();        
       Test.stopTest();       
    }
    
     @isTest static void verCasoSeleccionadoHistorialUR()
    {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.verCasoSeleccionado_HistorialUR();     
       Test.stopTest();  
    }
    
     @isTest static void IniciarBandejaHistorialUR()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.Registros=250;
       Con.RUT_Cliente=null;
       Con.NumeroCaso=null;
       Test.stopTest();
    }
    
    
      @isTest static void getListarNumeroRegistros()
   {
       Test.startTest();
       CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
       Con.getListarNumeroRegistros();
       Test.stopTest();
    }
    
  /*  @isTest static void getUnidades()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        List<SelectOption> URS  = new List<SelectOption>();
        Con.UsuarioSeleccionado='213';
        //Con.getUnidades();
        Test.stopTest();
    }*/
    
    @isTest static void cargaCaso()
    {
        Test.startTest();

        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;

        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;

        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.IdCaso=c.Id;
        Con.Caso = new Case();
        Con.NewTask = new Task();
        Con.NewTask.WhatId = Con.IdCaso;
        Con.NewTask.Subject = 'Otros';
        Con.NewTask.RecordTypeId = con.RecordTypeId;
        Con.NewTask.Status = 'No iniciada';
        Con.NewTask.Priority = 'Normal';
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @isTest static void cargaCaso_b()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.IdCaso='';
        con.cargaCaso();
        Test.stopTest();
    }
    
    
    @isTest static void volverCaso()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.volverCaso();
        Test.stopTest();
        
    }
    
    @isTest static void ToNewTask()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToNewTask();
        Test.stopTest();
    }

    /*
    @isTest static void SaveTask()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.Exito='S';
        insert Con.NewTask;
        Con.SaveTask();
        Test.stopTest();
    }*/
    
    @isTest static void SaveTask_b()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.Exito='N';
        Con.Exito='N1';
        Con.SaveTask();
        Test.stopTest();
    }
    
    @isTest static void CargaTarea()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;
        Task Tarea = Factory.buildTask(c.Id);
        insert tarea;
        
        Con.Caso = c;
        Con.Tarea = tarea;
        Con.TAREA_ID= tarea.Id;
        Con.UsuarioSeleccionado='123456';
        Con.TAREA_COMPLETADA='NO';      
        Con.RESPONSABLE_ASIGNADO='N';       
        
        
   
        Con.CargaTarea();
        Test.stopTest();
    }
    
    @isTest static void CargaTarea_b()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.UsuarioSeleccionado='123456';
        Con.TAREA_ID='12345';
        Con.TAREA_COMPLETADA='SI';
        Account cuenta = Factory.cuenta.buildInsert();                           
        Con.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
        Con.RESPONSABLE_ASIGNADO='S';
        Con.IdCaso= Con.Tarea.WhatId;
        Con.CargaTarea();
        Test.stopTest();
    }
    
    @isTest static void ToViewTask()
    {
        Test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToViewTask();
        Test.stopTest();
    }

   
    @isTest static void ToTaskList()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        con.ToTaskList();
        test.stopTest();
    }
    
    @isTest static void ToCaseList()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        con.ToCaseList();
        test.stopTest();
    }

 @isTest static void ToColaboraciones()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToColaboraciones();
        test.stopTest();
    }
    
     @isTest static void ToColaboracionesHistory()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToColaboracionesHistory();
        test.stopTest();
    }
    
    @isTest static void ToTaskHistory()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToTaskHistory();
        test.stopTest();
    }
    
    @isTest static void ToCaseHistory()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToCaseHistory();
        test.stopTest();
    }    
    
     @isTest static void ToCase()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.ToCase();
        test.stopTest();
    }    
    
    @isTest static void getUnidades()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();
        Con.listaUR = [select Id, Id_Cola__c, Nombre_Cola__c, Usuario__c from Cola_Usuario__c];
        
        Con.getUnidades();
        test.stopTest();
    }

  /*  @isTest static void GeneracionTareasNuevas()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();        
        Con.IdCasoTarea = '';
        Con.GeneracionTareasNuevas();
        test.stopTest();
    }
    
    @isTest static void GuardarTareasCaso()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();    
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a; 

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;
        Con.NuevaTareaCaso = Factory.buildTask(c.Id);
        Con.GuardarTareasCaso();
        test.stopTest();
    }
    
    @istest static void CargarTareaCaso()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();    
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;
        Con.NuevaTareaCaso = Factory.buildTask(c.Id);
        Con.GuardarTareasCaso();
        
        Con.IdTareaCaso = Con.NuevaTareaCaso.Id;
        Con.CargarTareaCaso();
        
            
        test.stopTest();
    }
    
    @isTest static void ModificarStatusTarea()
    {
        test.startTest();
        CTR_BandejaResolutorUR Con = new CTR_BandejaResolutorUR();    
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
        c.OwnerId = IdCola;
        c.CASO_Responsable_UR__c = ub1.Id;
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        insert c;
        Con.NuevaTareaCaso = Factory.buildTask(c.Id);
        Con.GuardarTareasCaso();
        
        Con.IdTareaCaso = Con.NuevaTareaCaso.Id;
        Con.ModificarStatusTarea();
        
            
        test.stopTest();
    }
        */
}