/**
 * @File Name          : TEST_CTR_UR_Bandeja_CierreMultiple.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/23/2020, 5:18:01 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/23/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public with sharing class TEST_CTR_UR_Bandeja_CierreMultiple {
    @isTest static void CargaCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        
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
        
        controlador.CargaCasos();
        Test.stopTest();
    }
    
    @isTest static void CargaCasos_Test_02()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();        
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
        
        controlador.CargaCasos();
        Test.stopTest();
    }
    
    @isTest static void CargaCasos_Test_03()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        
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
        
        controlador.CargaCasos();
        Test.stopTest();
    }
    
    @isTest static void queryCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.queryCasosUR();
        Test.stopTest();
    }
    
    @isTest static void queryTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.queryTareasUR();
        Test.stopTest();
    }
    
     @isTest static void queryColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.queryColaboracionesUR();
        Test.stopTest();
    }
    
    @isTest static void getCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.getCasosUR();
        Test.stopTest();
    }
    
    @isTest static void getTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.getTareasUR();
        Test.stopTest();
    }

    @isTest static void getColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        controlador.getColaboracionesUR();
        Test.stopTest();
    }

 /*   @isTest static void Cerrar_Casos_Test_01()
    {
        Test.startTest();
        CTR_UR_Casos_CierreMultiple controlador = new CTR_UR_Casos_CierreMultiple();        
        controlador.Tipo = 'CASOS_UR';
        controlador.Cerrar();
        Test.stopTest();
    }
    
    @isTest static void Cerrar_Tareas_Test_01()
    {
        Test.startTest();
        CTR_UR_Casos_CierreMultiple controlador = new CTR_UR_Casos_CierreMultiple();        
        controlador.Tipo = 'TAREAS_UR';
        controlador.Cerrar();
        Test.stopTest();
    }
    
    @isTest static void Cerrar_Colaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_Casos_CierreMultiple controlador = new CTR_UR_Casos_CierreMultiple();        
        controlador.Tipo = 'COLABORACIONES_UR';
        controlador.Cerrar();
        Test.stopTest();
    }*/
    
    @isTest static void Cerrar_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();        
        controlador.Tipo = 'COLABORACIONES_UR';
        controlador.Cerrar();
        Test.stopTest();
    }

     @isTest static void CerrarCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
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
        controlador.Cerrar_Casos();
        Test.stopTest();
    }

     @isTest static void CerrarTareas_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        task1.Status = 'No Iniciada';
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        task2.Status = 'No Iniciada';
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        task3.Status = 'No Iniciada';
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
        controlador.TareasUPD = new List<Task>();
        controlador.TareasUPD.add(task1);
        controlador.TareasUPD.add(task2);
        controlador.TareasUPD.add(task3);
        controlador.TareasUPD.add(task4);
        controlador.Cerrar_Tareas();
        Test.stopTest();
    }
    
    @isTest static void CerrarColaboraciones_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_CierreMultiple controlador = new CTR_UR_Bandeja_CierreMultiple();
        Account cuenta = Factory.crearAccountSF();  
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task task1 = Factory.buildTask_TareaUR(caso.Id);
        task1.Status = 'No Iniciada';
        insert task1;
        Task task2 = Factory.buildTask_TareaUR(caso.Id);
        task2.Status = 'No Iniciada';
        insert task2;
        Task task3 = Factory.buildTask_TareaUR(caso.Id);
        task3.Status = 'No Iniciada';
        insert task3;
        Task task4 = Factory.buildTask_TareaUR(caso.Id);
        insert task4;
        controlador.TareasUPD = new List<Task>();
        controlador.TareasUPD.add(task1);
        controlador.TareasUPD.add(task2);
        controlador.TareasUPD.add(task3);
        controlador.TareasUPD.add(task4);
        controlador.Cerrar_Colaboraciones();
        Test.stopTest();
    }
}