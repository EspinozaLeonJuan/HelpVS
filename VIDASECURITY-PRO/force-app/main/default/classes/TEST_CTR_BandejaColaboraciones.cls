@istest(SeeAllData=True)
public class TEST_CTR_BandejaColaboraciones {

   @isTest static void IniciarBandeja()
   {
       Test.startTest();
       CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
       Con.IniciarBandeja();
       Con.CASO_ID='asd';
       Con.ListadoTareas();
       Test.stopTest();
    }
    
    @isTest static void Historial()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.Historial();
        LIST<User> usuario= new List<User>();
        Con.AREAUSUARIOLICENCIA= 'qwe';
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.Registros=1;
        Con.ListadoHistorial(); 
        test.stopTest();
    }
    
    @isTest static void ListadoTareas_A()
    {
        Test.startTest();

        User usuario = [SELECT Id,Name,USUA_Area_UR__c FROM User
                        WHERE Name LIKE '%RRVV%' LIMIT 1];
        Cola_Usuario__c cusu = [SELECT Id,Id_Cola__c,Nombre_Cola__c,Usuario__c FROM Cola_Usuario__c
                                WHERE Nombre_Cola__c LIKE '%RRVV%' LIMIT 1];
        Usuario_Backup__c ub1 = [SELECT Id,Name,UBAC_Area__c,UBAC_ID_Cola_UR__c,OwnerId FROM Usuario_Backup__c
                                 WHERE OwnerId =: cusu.Id_Cola__c AND UBAC_Activo__c = TRUE LIMIT 1];

        Task t1 = new Task();
        t1.Subject = 'Prueba Derivación Tarea';
        t1.ActivityDate = Date.today();
        t1.Status = 'Descartada';
        t1.OwnerId = cusu.Usuario__c;
        //t1.Responsable_Backup__c = ub1.Id;
        insert t1;
        
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoTareas();
        Con.USER_ID=usuario.Id;
        Con.COLA_ID=cusu.Id_Cola__c;
        Con.USER_BACKUP_ID=ub1.Id;
        Con.TAREA_ID=t1.Id;
        Con.ListadoTareas();

        test.stopTest();
    }
    
    @isTest static void ListadoTareas_b()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoTareas();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID='0';
        Con.getEstadosTarea();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();      
        test.stopTest();
    }
    
    
    @isTest static void ListadoHistorial()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID='0';
        Con.Historial();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();      
        test.stopTest();
    }
    
    @isTest static void ListadoHistorial_b()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID='1';
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();      
        test.stopTest();
    }
    
    @isTest static void ListadoHistorial_c()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoHistorial();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID=null;
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();      
        test.stopTest();
    }
    
    @isTest static void getListarUsuarios()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.getListarUsuarios();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.USER_ID='123';
        Con.COLA_ID='123';
        Con.USER_BACKUP_ID=null;    
        test.stopTest();
    }
    
    @isTest static void mostrarTareas()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.mostrarTareas();     
        test.stopTest();
    }
    
    @isTest static void ToColaboracion()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToColaboracion();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.TAREA_ID='12345';  
        test.stopTest();
    }
    
     @isTest static void ToResponsable()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToResponsable();
        Con.USER_ID='123';
        Con.RESPONSABLE_ASIGNADO='S';
        test.stopTest();
    }
    
     @isTest static void SaveResponsable()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.SaveResponsable();
        Con.ToColaboracion();
        test.stopTest();
    }
    
     @isTest static void ToEstado()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.TAREA_ID='12345';
        Con.ToEstado();
        Con.ToColaboracion();
        test.stopTest();
    }
    
     @isTest static void SaveEstado()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.TAREA_ID='12345';
        Con.SaveEstado();
        Con.ToColaboracion();
        test.stopTest();
    }
    
    @isTest static void ToHistorial()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.TAREA_ID='12345';
        Con.ToHistorial();
        test.stopTest();
    }
    
     @isTest static void mostrarHistorial()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ListadoHistorial();
        Con.mostrarHistorial();
        test.stopTest();
    }
    
    @isTest static void getListarNumeroRegistros()
   {
       Test.startTest();
       CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
       Con.getListarNumeroRegistros();
       Test.stopTest();
    }
    
    @isTest static void ToTaskList()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        con.ToTaskList();
        test.stopTest();
    }
    
    @isTest static void ToCaseList()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        con.ToCaseList();
        test.stopTest();
    }
    
    @isTest static void ToColaboraciones()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToColaboraciones();
        test.stopTest();
    }
    
     @isTest static void ToColaboracionesHistory()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToColaboracionesHistory();
        test.stopTest();
    }
    
    @isTest static void ToTaskHistory()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToTaskHistory();
        test.stopTest();
    }
    
    @isTest static void ToCaseHistory()
    {
        test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.ToCaseHistory();
        test.stopTest();
    }
    
    @isTest static void CargaColaboracion_A()
    {
        Test.startTest();

        Usuario_Backup__c ub1 = new Usuario_Backup__c();
        ub1.Name = 'Maestro';
        ub1.UBAC_Activo__c = true;
        ub1.UBAC_Area__c = 'Producción RRVV';
        insert ub1;

        system.debug('@@@@ USUARIO BCK TEST CARGA COLABORACIÓN A => ' + ub1);

        Task t1 = new Task();
        t1.Subject = 'Prueba Derivación Tarea';
        t1.ActivityDate = Date.today();
        t1.Status = 'Descartada';
        //t1.Responsable_Backup__c = ub1.Id;
        insert t1;

        system.debug('@@@@ TAREA TEST CARGA COLABORACIÓN A => ' + t1);

        PageReference p1 = new Pagereference(Page.SEC_VF_UR_ColaboracionesReclamo.getUrl() + '?id=' + t1.Id);
        Test.setCurrentPage(p1);

        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.CargaColaboracion();


        Con.Caso=null;
        Con.USER_ID='';
        Con.RESPONSABLE_ASIGNADO='N';
        test.stopTest();
    }

    @isTest static void CargaColaboracion_b()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.CargaColaboracion();
        list<Usuario_Backup__c> lstUsuario= new list<Usuario_Backup__c>();
        Con.TAREA_ID='12345';
        Con.TAREA_COMPLETADA='true';
        Con.CASO_ID='123';
        Con.USER_ID='123';
        Con.RESPONSABLE_ASIGNADO='S';
        test.stopTest();
    }
    
     @isTest static void NuevoComentario()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.NuevoComentario();      
        test.stopTest();
    }
    
    @isTest static void GuardarComentario()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name LIKE '%Person%' LIMIT 1].Id;
        a.FirstName = 'Juan';
        a.LastName = 'Pedro';
            a.Rut_contacto__pc = '88888888';
        	a.DV_contacto__pc = '8';
        
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
        Con.GuardarComentario();      
        test.stopTest();
    }
    
    @isTest static void CancelarComentario()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.CancelarComentario();      
        test.stopTest();
    }
    
    @isTest static void cargaCaso()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.cargaCaso();      
        test.stopTest();
    }   
    
     @isTest static void ToCase()
    {
        Test.startTest();
        CTR_BandejaColaboraciones Con = new CTR_BandejaColaboraciones();
        Con.Tarea = new Task();
        Con.Tarea.Id = '00T4F000005raWS';
        Con.ToCase();      
        test.stopTest();
    }
}