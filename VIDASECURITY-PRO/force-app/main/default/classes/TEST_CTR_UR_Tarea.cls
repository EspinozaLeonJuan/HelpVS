/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_Tarea                                                               |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_Tarea                                                                    |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/25   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@isTest(seeAllData=true)
public class TEST_CTR_UR_Tarea {



    @isTest static void CargaTarea_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        tarea.Status = 'No Iniciada';               
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.CargaTarea();
        Test.stopTest();
    }
    
    @isTest static void CargaTarea_Test_02()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        tarea.Status = 'En Curso';        
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];
        tarea.Responsable_Backup__c = Uback[0].Id;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.CargaTarea();
        Test.stopTest();
    }
    
     @isTest static void CargaTarea_Test_03()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);   
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];
        tarea.Responsable_Backup__c = Uback[0].Id;
        tarea.Status = 'Completada';        
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.CargaTarea();
        Test.stopTest();
    }
    
    @isTest static void GuardarAdjunto_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.GuardarAdjunto();
        Test.stopTest();
    }
    
    @isTest static void IniciaCambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);  
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];
        tarea.Responsable_Backup__c = Uback[0].Id;        
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.IniciaCambioResponsable();
        Test.stopTest();
    }
    
    @isTest static void CambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);                
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];
        tarea.Responsable_Backup__c = Uback[0].Id;
        tarea.Id_Solicitante_UR__c= Uback[0].Id;       
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.TareaPopup = tarea;
        controlador.CambioResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnCurso_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];
        tarea.Responsable_Backup__c = Uback[0].Id;
        tarea.Id_Solicitante_UR__c = Uback[0].Id;        
        controlador.Tarea = tarea;
        controlador.EnCurso();
        Test.stopTest();
    }
    
    @isTest static void IniciaNuevoComentario_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.IniciaNuevoComentario();
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void IniciaCambioEstado_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        ApexPages.currentPage().getParameters().put('cambio', 'C');
        controlador.IniciaCambioEstado();
        Test.stopTest();
    }
    
    @isTest static void IniciaCambioEstado_Test_02()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        ApexPages.currentPage().getParameters().put('cambio', 'R');
        controlador.IniciaCambioEstado();
        Test.stopTest();
    }
    
    @isTest static void CambioEstado_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.ComentarioUbk = 'this is a comment';
        controlador.EstadoCambio = 'COMPLETADA';
        controlador.Comentario = new Task_Comment__c();
        controlador.CambioEstado();
        Test.stopTest();
    }
    
    @isTest static void TareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.TareasUR();
        Test.stopTest();
    }
    
    @isTest static void HistoricoUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.HistoricoUR();
        Test.stopTest();
    }
    
    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        CTR_UR_Tarea controlador = new CTR_UR_Tarea();
        controlador.cargaCaso();
        Test.stopTest();
    }   
}