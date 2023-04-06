/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_CS_Colaboracion                                                       |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_CS_Colaboracion                                                            |
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
public class TEST_CTR_CS_Colaboracion {

  
    @isTest static void pruebaObjetoNode_Test(){
        Test.startTest();

        CTR_CS_Colaboracion con = new CTR_CS_Colaboracion();
        CTR_CS_Colaboracion.Node nodo = new CTR_CS_Colaboracion.Node();
        nodo.Id = '12341234';
        nodo.Name = 'Hola';
        nodo.UserId = UserInfo.getUserId();
        nodo.Selected = true;
        Test.stopTest();
    }
    
    @isTest static void cargaCaso_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.cargaCaso();
        Test.stopTest();
    }
    
    @isTest static void ToCase_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso = caso;
        controlador.ToCase();
        Test.stopTest();
    }
    
    @isTest static void cargaUnidades_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        controlador.cargaUnidades();
        Test.stopTest();
    }
    
    @isTest static void getUnidadesSelect_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        controlador.UR_Select = new String[1];
        controlador.UR_Unselect = new String[1];
        controlador.getUnidadesSelect();
        Test.stopTest();
    }
    
    @isTest static void getUnidadesUnselect_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        controlador.UR_Select = new String[1];
        controlador.UR_Unselect = new String[1];
        controlador.getUnidadesUnselect();
        Test.stopTest();
    }
    
    @isTest static void AddUR_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        controlador.UR_Select = new String[1];
        controlador.UR_Unselect = new String[1];
        controlador.AddUR();
        Test.stopTest();
    }
    
    @isTest static void RemoveUR_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        controlador.UR_Select = new String[1];
        controlador.UR_Unselect = new String[1];
        controlador.RemoveUR();
        Test.stopTest();
    }
    
    @isTest static void SaveTask_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.URS = new List<CTR_CS_Colaboracion.Node>();
        
        CTR_CS_Colaboracion.Node nodo = new CTR_CS_Colaboracion.Node();
        nodo.Id = '12341234';
        nodo.Name = 'Hola';
        nodo.UserId = UserInfo.getUserId();
        nodo.Selected = true;
        controlador.URS.add(nodo);
        controlador.SaveTask();
        Test.stopTest();
    }
   
    @isTest static void ListadoTareas_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.ListadoTareas();
        Test.stopTest();
    }
    
    @isTest static void ToList_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.ToList();
        Test.stopTest();
    }
    
    @isTest static void ToNew_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.ToNew();
        Test.stopTest();
    }
    
    @isTest static void verColaboracionSeleccionada_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.verColaboracionSeleccionada();
        Test.stopTest();
    }
 
	@isTest static void CargaColaboracion_Test_01(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
        //Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        //tarea.Responsable_Backup__c = uback.Id;
        tarea.Status = 'Completada';
        insert tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        controlador.CargaColaboracion();
        Test.stopTest();
    }    
    
    @isTest static void CargaColaboracion_Test_02(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Task tarea = Factory.buildTask_TareaUR(caso.Id);    
        tarea.Status = 'Completada';
        insert tarea;
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        controlador.CargaColaboracion();
        Test.stopTest();
    }
    
    @isTest static void NuevoComentario_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.NuevoComentario();
        Test.stopTest();
    }
    
    @isTest static void GuardarComentario_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
    //    Usuario_Backup__c uback = Factory.buildUsuarioBackup();
        Task tarea = Factory.buildTask_TareaUR(caso.Id);
     //   tarea.Responsable_Backup__c = uback.Id;
        insert tarea;
        controlador.Tarea = tarea;
        controlador.ComentTask = new Task_Comment__c();
        controlador.GuardarComentario();
        Test.stopTest();
    }
    
    @isTest static void CancelarComentario_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.CancelarComentario();
        Test.stopTest();
    }
    
    @isTest static void ToColaboracion_Test(){
        Test.startTest();
        CTR_CS_Colaboracion controlador = new CTR_CS_Colaboracion();
        controlador.ToColaboracion();
        Test.stopTest();
    }
}