@istest
public class TEST_CTR_ColaboracionReclamo {

    @isTest static void pruebaObjetoNode(){
        Test.startTest();

        CTR_ColaboracionReclamo con = new CTR_ColaboracionReclamo();
        CTR_ColaboracionReclamo.Node nodo = new CTR_ColaboracionReclamo.Node();
        nodo.Id = '12341234';
        nodo.Name = 'Hola';
        nodo.UserId = UserInfo.getUserId();
        nodo.Selected = true;
        Test.stopTest();
    }
 
    @isTest static void cargaCaso() {
        Test.startTest();

        Cola_Usuario__c cola1 = new Cola_Usuario__c();
        cola1.Usuario__c = UserInfo.getUserId();
        cola1.Id_Cola__c = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;
        cola1.Nombre_Cola__c = [SELECT Queue.Name FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].Queue.Name;
        insert cola1;

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

        PageReference pgCargaCaso = new PageReference(Page.SEC_VF_CS_NuevaColaboracion.getUrl() + '?id=' + c.Id);
        Test.setCurrentPage(pgCargaCaso);
        CTR_ColaboracionReclamo con = new CTR_ColaboracionReclamo();
        con.cargaCaso();

        //List<CTR_ColaboracionReclamo.Node> URs = new List<CTR_ColaboracionReclamo.Node>();

        Task t1 = new Task();
        t1.Subject = 'Prueba Derivación Tarea';
        t1.ActivityDate = Date.today()-1;
        t1.Status = 'Descartada';
        t1.WhatId = c.Id;
        t1.WhoId = a.PersonContactId;
        t1.OwnerId = UserInfo.getUserId();
        t1.Responsable_Backup__c = c.CASO_Responsable_UR__c;

        con.NewTask = t1;
        con.SaveTask();

        Task t2 = new Task();
        t2.Subject = 'Prueba Derivación Tarea';
        t2.ActivityDate = Date.today()+1;
        t2.Status = 'Descartada';
        t2.WhatId = c.Id;
        t2.WhoId = a.PersonContactId;
        t2.OwnerId = UserInfo.getUserId();
        t2.Responsable_Backup__c = c.CASO_Responsable_UR__c;

        con.NewTask = t2;
        for(CTR_ColaboracionReclamo.Node n : con.URS){
            n.Selected = true;
        }
        con.SaveTask();
        con.Exito='N1';
        Test.stopTest();
    }

    @isTest static void cargaColaboracionCaso(){
        Test.startTest();

        Cola_Usuario__c cola1 = new Cola_Usuario__c();
        cola1.Usuario__c = UserInfo.getUserId();
        cola1.Id_Cola__c = [SELECT QueueId FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].QueueId;
        cola1.Nombre_Cola__c = [SELECT Queue.Name FROM QueueSobject WHERE Queue.Name LIKE '%RRVV%' LIMIT 1].Queue.Name;
        insert cola1;

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

        Task t2 = new Task();
        t2.Subject = 'Prueba Derivación Tarea';
        t2.ActivityDate = Date.today()+1;
        t2.Status = 'Descartada';
        t2.WhatId = c.Id;
        t2.WhoId = a.PersonContactId;
        t2.OwnerId = UserInfo.getUserId();
        t2.Responsable_Backup__c = c.CASO_Responsable_UR__c;

        PageReference pgCargaColaboracion = new PageReference(Page.SEC_VF_CS_ColaboracionReclamo.getUrl() + '?id=' + t2.Id);
        Test.setCurrentPage(pgCargaColaboracion);
        CTR_ColaboracionReclamo con = new CTR_ColaboracionReclamo();
        con.CargaColaboracion();
        Test.stopTest();
    }
/*
    @isTest static void ToCase() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        PageReference pageCaso = new PageReference (page.SEC_VF_CS_ColaboracionReclamo.getUrl()  + Con.Idcaso);        
        Test.stopTest();
    }
  */  
    @isTest static void cargaUnidades() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Test.stopTest();
    }
    
    @isTest static void getUnidadesUnselect() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        list<SelectOption> getUnidadesUnselect= new list<SelectOption>();
        Con.getUnidadesUnselect();
        Test.stopTest();
    }
    
    @isTest static void getUnidadesSelect() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.getUnidadesSelect();
        Test.stopTest();
    }
    
    @isTest static void getUnidadesSelect_b() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.getUnidadesSelect();
        Test.stopTest();
    }
                             
    @isTest static void getUnidadesSelect_c() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.getUnidadesSelect();
        Test.stopTest();
    }
    
    @isTest static void AddUR() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.UR_Select = new String[1];
        Con.UR_Select[0] ='val01';
        Con.URS = new List<CTR_ColaboracionReclamo.Node>();
        Con.AddUR();
        Test.stopTest();
    }
    
    @isTest static void RemoveUR() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.UR_Unselect = new String[1];
        Con.UR_Unselect[0] ='val01';
        Con.URS = new List<CTR_ColaboracionReclamo.Node>();
        Con.RemoveUR();
        Test.stopTest();
    }
    
    /*
    @isTest static void SaveTask() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.NewTask= new task();
        Con.NewTask.Subject = 'Prueba Derivación Tarea';
        Con.NewTask.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Solicitudes' AND SobjectType = 'Case'].Id;
        Con.NewTask.OwnerId='12345678';
        Con.NewTask.ActivityDate = Date.today();
        Con.NewTask.Status = 'Descartada';
        Con.NewTask.Priority = 'Normal';
        Con.NewTask.caso_numero__c = Con.caso.CaseNumber;
        Con.NewTask.description= Con.NewTask.description;
        Con.SaveTask();
        Test.stopTest();
    }*/


    
    @isTest static void ListadoTareas() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.ListadoTareas();
        Test.stopTest();
    }
    
    @isTest static void ListadoTareas_b() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.ListadoTareas();
        Test.stopTest();
    }
    
    @isTest static void ToList() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        PageReference p1 = new Pagereference(Page.SEC_VF_UR_ColaboracionesReclamo.getUrl() + '?id=' + Con.Idcaso);
        Con.ToList();
        Test.stopTest();
    }
    
    @isTest static void ToNew() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        PageReference p1 = new Pagereference(Page.SEC_VF_CS_NuevaColaboracion.getUrl() + '?id=' + Con.Idcaso);
        Con.ToNew();
        Test.stopTest();
    }
    
    @isTest static void verColaboracionSeleccionada() {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        PageReference p1 = new Pagereference(Page.SEC_VF_CS_ColaboracionReclamo.getUrl() + '?id=' + Con.IdTarea);
        con.Idcaso=con.Tarea.WhatId;
        Con.IdTarea=con.IdTarea;
        Con.verColaboracionSeleccionada();
        Test.stopTest();
    }
    
    @isTest static void CargaColaboracion()
    {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        
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
        Con.Caso = FactoryEscritorio.buildCasoED('Solicitudes', a);     
        
        Con.CargaColaboracion();
        
        test.stopTest();
    }

   
    
    @istest static void ToCase()
    {
         test.startTest();
 		CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo(); 
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
        
        Con.Caso = c;
        Con.ToCase();
         test.stopTest();
    }
    
   @isTest static void NuevoComentario()
    {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.NuevoComentario();      
        test.stopTest();
    }
    
    @isTest static void GuardarComentario()
    {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
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
        Con.GuardarComentario();      
        test.stopTest();
    }
    
    @isTest static void CancelarComentario()
    {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.CancelarComentario();      
        test.stopTest();
    }

    @isTest static void ToColaboracion()
    {
        Test.startTest();
        CTR_ColaboracionReclamo Con = new CTR_ColaboracionReclamo();
        Con.ToColaboracion();      
        test.stopTest();
    }

    
    
}