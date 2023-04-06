@istest
public class TEST_CTR_BandejaTareasUR {

     
    @isTest static void getListarUsuarios()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.getListarUsuarios();

        test.stopTest();
    }
    
     @isTest static void InformacionCaso()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        
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
        Con.InformacionCaso();

        test.stopTest();
    }
    
     /*@isTest static void InformacionTarea()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        
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
        
        Con.InformacionTarea(t.Id);

        test.stopTest();
    }*/
    
    @isTest static void NuevoComentario()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.NuevoComentario();      
        test.stopTest();
    }
    
    
      @isTest static void GuardarComentario()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.GuardarComentario();      
        test.stopTest();
    }
    
    @isTest static void CancelarComentario()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.CancelarComentario();      
        test.stopTest();
    }
     @isTest static void Historial()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.Historial();      
        test.stopTest();
    }
@isTest static void cargaCaso()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.cargaCaso();      
        test.stopTest();
    }    
    @isTest static void ToCase()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.Tarea = new Task();
        Con.Tarea.Id = '00T4F000005raWS';
        Con.ToCase();      
        test.stopTest();
    }
    
    
    @isTest static void IniciarTareasUR()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.IniciarTareasUR();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.IdColaUR='12';
        Con.UsuarioSeleccionado='12';
        list<task> ltareas = new list<task>();
        con.mostrarTareasUR();
        test.stopTest();
    }
    
    @isTest static void mostrarTareasUR()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.mostrarTareasUR();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.UsuarioSeleccionado=null;
        Con.UsuarioSeleccionado='0';
        Con.listatareas=null;
        Con.COLA_ID='1234';
        con.mostrarTareasUR();
        test.stopTest();
    }
    
    @isTest static void mostrarTareasUR_b()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.mostrarTareasUR();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.UsuarioSeleccionado='0';
        list<task> ltareas = new list<task>();
        con.mostrarTareasUR();
        test.stopTest();
    }
    
    
    @isTest static void mostrarTareasUR_c()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.mostrarTareasUR();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.UsuarioSeleccionado='1';
        list<task> ltareas = new list<task>();
        
        con.mostrarTareasUR();
        test.stopTest();
    }
    
    @isTest static void ToTaskList()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToTaskList();
        Con.UsuarioSeleccionado='1';
        Con.ToViewTask();
        test.stopTest();
    }
    
    @isTest static void ToCaseList()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToCaseList();
        Con.UsuarioSeleccionado='1';
        Con.ToCaseHistory();
        test.stopTest();
    }
    
    
    @isTest static void ToColaboraciones()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToColaboraciones();
        Con.UsuarioSeleccionado='1';
        test.stopTest();
    }
    
    @isTest static void MostrarListaTareaUsuario()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.MostrarListaTareaUsuario();
        Con.UsuarioSeleccionado='1';
        test.stopTest();
    }
    
    @isTest static void ToViewTask()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToViewTask();
        Con.UsuarioSeleccionado='1';
        test.stopTest();
    }
    
    @isTest static void CargaTarea()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        
       
        
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
        
        Con.CargaTarea();
        test.stopTest();
    }
    /*
    @isTest static void CargaTarea_b()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
       	Con.Tarea = new Task();
        Con.IdTareaCaso='1234';
        Con.UsuarioSeleccionado='1';
        Con.TAREA_COMPLETADA='SI';
        Con.TAREA_ID='1234';
        Con.tarea.status='Completada';
        Con.IdCaso='123';
        Con.IdTareaCaso='123';
        Con.TAREA_ID='234';
        Account cuenta = Factory.cuenta.buildInsert();                           
        Con.caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
        Con.RESPONSABLE_ASIGNADO='S';
        Con.CargaTarea();
        test.stopTest();
    }
    
    @isTest static void CargaTarea_c()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
		Con.Tarea = new Task();
        Con.IdTareaCaso='1234';
        Con.UsuarioSeleccionado='1';
        Con.IdCaso='1234';
        Con.tarea.status='Completada';
        Con.TAREA_COMPLETADA='SI';
        Test.isRunningTest();
        Con.TAREA_ID='1234';
        Con.IdCaso='123';
        Con.IdTareaCaso='123';
        Con.TAREA_ID='234';
        Account cuenta = Factory.cuenta.buildInsert();                           
        Con.caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
        Con.RESPONSABLE_ASIGNADO='S';
        Con.CargaTarea();
        test.stopTest();
    }
    
    @isTest static void CargaTarea_d()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.Tarea = new Task();
        Con.IdTareaCaso='1234';
        Con.UsuarioSeleccionado='1';
        Con.tarea.status='Completada';
        Con.TAREA_COMPLETADA='SI';
        Con.IdCaso='1234';
        Con.RESPONSABLE_ASIGNADO='N';
        Account cuenta = Factory.cuenta.buildInsert();                           
        Con.caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
        Con.RESPONSABLE_ASIGNADO=null;
        Con.IdTareaCaso='123';
        Con.TAREA_ID='234';
        Con.CargaTarea();
        test.stopTest();
    }
    
    @isTest static void CargaTarea_e()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.Tarea = new Task();
        Con.TAREA_COMPLETADA='SI';
        Con.TAREA_ID='23';
        Con.tarea.status='Completada';
        Con.RESPONSABLE_ASIGNADO='S';
        Con.RESPONSABLE_ASIGNADO='N';
        Con.IdTareaCaso='123';
        Con.TAREA_ID='234';
        Account cuenta = Factory.cuenta.buildInsert();                           
        Con.caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
        Con.CargaTarea();
        test.stopTest();
    }*/
    
    @isTest static void volverMenuPrincipal()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.volverMenuPrincipal();
        test.stopTest();
    }
    
    @isTest static void ToTask()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToTask();
        Con.ToViewTask();
        test.stopTest();
    }
    
    
    @isTest static void SaveEstado()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.SaveEstado();
        test.stopTest();
    }
    
    @isTest static void ToEstado()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToEstado();
        test.stopTest();
    }
    
    @isTest static void ToResponsable()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToResponsable();
        test.stopTest();
    }
    
    @isTest static void SaveResponsable()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.SaveResponsable();
        test.stopTest();
    }
    /*
    @isTest static void Historial()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
        insert a;

        String IdCola = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;

      
        
        Case c = new Case ();
        c.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        c.Subject = 'Prueba Caso';
        c.Status = 'Nuevo';
       // c.OwnerId = IdCola;
        
        c.Tipo_de_Solicitante__c = 'Contratante';
        c.Negocio__c = 'RRVV';
        c.AccountId = a.Id;
        c.ContactId = a.PersonContactId;
        c.CASO_Categoria__c = 'Endoso RRVV';
        
        insert c;
        Con.NuevaTareaCaso = Factory.buildTask(c.Id);
        
        Con.NuevaTareaCaso.Status = 'Completada';
        ApexPages.currentPage().getParameters().put('id',Con.NuevaTareaCaso.Id);
        Con.Historial();
        LIST<User> usuario= new List<User>();
        Con.AREAUSUARIOLICENCIA= 'qwe';
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.IdResponsableTarea='123';
        Con.Registros=250;
        Con.Historial(); 
        Con.ListadoHistorial();
        Con.ToTaskHistory();
        test.stopTest();
    }
*/
    
    @isTest static void ListadoHistorial()
    {
        Test.startTest();
        
        //List<Cola_Usuario__c> colas = [SELECT Id_Cola__c FROM Cola_Usuario__c LIMIT 1];
        String IdCola = '00G0H0000067TVsUAM';//colas[0].Id_Cola__c;
        
        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.OwnerId = IdCola;
        ub1.UBAC_Area__c = 'Producción RRVV';
        ub1.Name = 'Juan';
        ub1.UBAC_ID_Cola_UR__c = IdCola;
        insert ub1;
        
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID = IdCola;
        Con.USER_BACKUP_ID= ub1.Id;
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        list<RecordType> listadoTareas= new list<RecordType>();
        Con.RecordTypeId='123';
        test.stopTest();
    }
    /*
    @isTest static void ListadoHistorial_b()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID='1';
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();  
        Con.RecordTypeId='123';
        test.stopTest();
    }
    
    @isTest static void ListadoHistorial_c()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID='0';
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();  
        Con.RecordTypeId='123';
        test.stopTest();
    }
    */
    
    @isTest static void mostrarHistorial()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ListadoHistorial();
        Con.mostrarHistorial();
        test.stopTest();
    }
    
    @isTest static void getListarNumeroRegistros()
    {
        Test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.getListarNumeroRegistros();
        test.stopTest();
    }
    
    @isTest static void ToColaboracionesHistory()
    {
        test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToColaboracionesHistory();
        test.stopTest();
    }
    
    @isTest static void ToTaskHistory()
    {
        test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToTaskHistory();
        test.stopTest();
    }
    
    @isTest static void ToCaseHistory()
    {
        test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.ToCaseHistory();
        test.stopTest();
    }
    
    @isTest static void getEstadosTarea()
    {
        test.startTest();
        CTR_BandejaTareasUR Con = new CTR_BandejaTareasUR();
        Con.getEstadosTarea();
        test.stopTest();
        
    }
}