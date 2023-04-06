/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_UR_ResponsableMultiple		                                              			|
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_UR_ResponsableMultiple			   														|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/25   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@isTest
public class TEST_CTR_UR_ResponsableMultiple {
    
    @isTest static void getListarUsuarios_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.getListarUsuarios();
        Test.stopTest();
    }
    
    @isTest static void IniciarAsignacion_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        
        Account cuenta = Factory.crearAccountSF();  
        Case caso1 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso1;
        Case caso2 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso2;
        Case caso3 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso3;
        Case caso4 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso4;
        
        String Ids = caso1.Id+'@'+caso2.Id+'@'+caso3.Id+'@'+caso4.Id+'@';
        ApexPages.currentPage().getParameters().put('Ids', Ids);
        ApexPages.currentPage().getParameters().put('Tipo', 'CASOS_UR');       
        
        controlador.IniciarAsignacion();
        Test.stopTest();
    }
    
    @isTest static void IniciarAsignacion_Test_02()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();        
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
              
        String Ids = task1.Id+'@'+task2.Id+'@'+task3.Id+'@'+task4.Id+'@';
        ApexPages.currentPage().getParameters().put('Ids', Ids);    
        ApexPages.currentPage().getParameters().put('Tipo', 'TAREAS_UR');       
        
        controlador.IniciarAsignacion();
        Test.stopTest();
    }
    
    @isTest static void IniciarAsignacion_Test_03()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
              
        String Ids = task1.Id+'@'+task2.Id+'@'+task3.Id+'@'+task4.Id+'@';
        ApexPages.currentPage().getParameters().put('Ids', Ids);       
        ApexPages.currentPage().getParameters().put('Tipo', 'COLABORACIONES_UR');       
        
        controlador.IniciarAsignacion();
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.queryCasosUR();
        Test.stopTest();
    }
    
    @isTest static void queryTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.queryTareasUR();
        Test.stopTest();
    }
    
     @isTest static void queryColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.queryColaboracionesUR();
        Test.stopTest();
    }
    
    @isTest static void getCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.getCasosUR();
        Test.stopTest();
    }
    
    @isTest static void getTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.getTareasUR();
        Test.stopTest();
    }

    @isTest static void getColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        controlador.getColaboracionesUR();
        Test.stopTest();
    }

    @isTest static void CambiarResponsable_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();        
        controlador.Tipo = 'CASOS_UR';
        controlador.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable_Test_02()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();        
        controlador.Tipo = 'TAREAS_UR';
        controlador.CambiarResponsable();
        Test.stopTest();
    }
    
    @isTest static void CambiarResponsable_Test_03()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();        
        controlador.Tipo = 'COLABORACIONES_UR';
        controlador.CambiarResponsable();
        Test.stopTest();
    }

     @isTest static void CambiaResponsable_Casos_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        Account cuenta = Factory.crearAccountSF();  
        Case caso1 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso1;
        Case caso2 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso2;
        Case caso3 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso3;
        Case caso4 = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso4;
        
        controlador.CasosUPD = new List<Case>();
        controlador.CasosUPD.add(caso1);
        controlador.CasosUPD.add(caso2);
        controlador.CasosUPD.add(caso3);
        controlador.CasosUPD.add(caso4);
        controlador.CambiaResponsable_Casos();
        Test.stopTest();
    }

     @isTest static void CambiaResponsable_Tareas_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
        controlador.TareasUPD = new List<Task>();
        controlador.TareasUPD.add(task1);
        controlador.TareasUPD.add(task2);
        controlador.TareasUPD.add(task3);
        controlador.TareasUPD.add(task4);
        controlador.CambiaResponsable_Tareas();
        Test.stopTest();
    }
    
    @isTest static void GeneraComentarioTarea_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        tarea.Status = 'No Iniciada';                            
        insert tarea;
        
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        tarea.Responsable_Backup__c = uback.Id;
        
        controlador.GeneraComentarioTarea(tarea.Id, 'textoComentario', 'NOT_TM', uback, uback, 'Completada', caso.CaseNumber);
        Test.stopTest();
    }
    
     @isTest static void CambiaResponsable_Colaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        
         Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
        controlador.TareasUPD = new List<Task>();
        controlador.TareasUPD.add(task1);
        controlador.TareasUPD.add(task2);
        controlador.TareasUPD.add(task3);
        controlador.TareasUPD.add(task4);
        
        controlador.CambiaResponsable_Colaboraciones();
        Test.stopTest();
    }
    
    @isTest static void GeneraComentarioColaboracion_Test_01()
    {
        Test.startTest();
        CTR_UR_ResponsableMultiple controlador = new CTR_UR_ResponsableMultiple();
        
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        tarea.Status = 'No Iniciada';                            
        insert tarea;
        
        Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        tarea.Responsable_Backup__c = uback.Id;
        
        User ejecutiva = new User();
        
        controlador.GeneraComentarioColaboracion(tarea.Id, 'textoComentario', 'NOT_TM', ejecutiva, uback, 'Completada', caso.CaseNumber);
        
        Test.stopTest();
    }
}