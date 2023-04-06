/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_Colaboracion                                                       |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_Colaboracion                                                            |
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
public class TEST_CTR_UR_Colaboracion {

     @isTest static void CargaColaboracion_Test_01()
     {
         Test.startTest();
         CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
         Account cuenta = Factory.cuenta.buildInsert();         
         Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
         Task tarea = Factory.buildTask_TareaUR(caso.Id);
         tarea.Status = 'No Iniciada';
         insert tarea;
         List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
         tarea.Responsable_Backup__c = Uback[0].Id;                        
      //   update tarea;
         ApexPages.currentPage().getParameters().put('Id', tarea.Id);
         ApexPages.currentPage().getParameters().put('idResponsable', '0');
         ApexPages.currentPage().getParameters().put('procedencia', 'COLABORACIONES_UR');
         controlador.CargaColaboracion();
         Test.stopTest();
     }
    
    
    @isTest static void CargaColaboracion_Test_02()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        tarea.Status = 'En Curso';
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
        tarea.Responsable_Backup__c = Uback[0].Id;
        //update tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.CargaColaboracion();
        Test.stopTest();
    }
    
    @isTest static void CargaColaboracion_Test_03()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);        
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
        tarea.Responsable_Backup__c = Uback[0].Id;
        tarea.Status = 'Rechazada';
       // update tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        
        controlador.CargaColaboracion();
        Test.stopTest();
    }
    
    @isTest static void CargaColaboracion_Test_04()
     {
         Test.startTest();
         CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
         Account cuenta = Factory.cuenta.buildInsert();         
         Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
         Task tarea = Factory.buildTask_TareaUR(caso.Id);                 
         insert tarea;
         ApexPages.currentPage().getParameters().put('Id', tarea.Id);
         ApexPages.currentPage().getParameters().put('idResponsable', '0');
         ApexPages.currentPage().getParameters().put('procedencia', 'COLABORACIONES_UR');
         controlador.CargaColaboracion();
         Test.stopTest();
     }
     @isTest static void GuardarAdjunto_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.GuardarAdjunto();
        Test.stopTest();
    }
    
     @isTest static void IniciaCambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);   
        insert tarea;          
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
        tarea.Responsable_Backup__c = Uback[0].Id;
		//update tarea;        
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.IniciaCambioResponsable();
        Test.stopTest();
    }
    
    @isTest static void CambioResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
       Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
        Task tarea = Factory.buildTask_TareaUR(caso.Id);   
        insert tarea;
        tarea.Responsable_Backup__c = Uback[0].Id;
        tarea.Id_Solicitante_UR__c= Uback[0].Id;
        
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('idResponsable', '0');
        ApexPages.currentPage().getParameters().put('procedencia', 'TARRAS_UR');
        controlador.ColaboracionPopup = tarea;
        controlador.CambioResponsable();
        Test.stopTest();
    }
    
    @isTest static void EnCurso_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        insert tarea;
        List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción Individuales' LIMIT 1];        
        tarea.Responsable_Backup__c = Uback[0].Id;
       // update tarea;
        controlador.Colaboracion = tarea;
        controlador.EnCurso();
        Test.stopTest();
    }
    
    @isTest static void IniciaNuevoComentario_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
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
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void IniciaCambioEstado_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
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
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
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
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.ComentarioUbk = 'this is a comment';
        controlador.EstadoCambio = 'COMPLETADA';
        controlador.Comentario = new Task_Comment__c();
        controlador.CambioEstado();
        Test.stopTest();
    }
    
     @isTest static void Colaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.Colaboraciones();
        Test.stopTest();
    }
    
    @isTest static void HistoricoUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.HistoricoUR();
        Test.stopTest();
    }
    
    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        CTR_UR_Colaboracion controlador = new CTR_UR_Colaboracion();
        controlador.cargaCaso();
        Test.stopTest();
    }   
}