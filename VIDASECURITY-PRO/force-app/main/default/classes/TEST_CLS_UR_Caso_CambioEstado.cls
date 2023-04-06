/**
 * @File Name          : TEST_CLS_UR_Caso_CambioEstado.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Juan Espinoza Leon
 * @Last Modified On   : 08-31-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification 
 * 1.0    6/2/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public with sharing class TEST_CLS_UR_Caso_CambioEstado {
    
    //public static void Actualiza_EscritorioDigital(Case caso,  String estado, String rutUsuario)
    //private static String CambioEstadoEscritorioDigital(Integer IdReq, string estadoED, String rutUsuario)
    //public static  void ActualizaEstadoTareasUR(String idCaso)
    //public static void ActualizaCasoAtencion(String idAtencion, Boolean casoVenta)
    //
    
    
    @isTest static void CambioEstadoEscritorioDigital_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
       
        caso.Id_Requerimiento_EscritorioDigital__c = '79';
        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(caso, 'Cerrado');
        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(caso, 'Rechazado');
        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(caso, 'En Revisión');
        Test.stopTest();
    }


    @isTest static void CambioEstadoEscritorioDigital_Test1()
    {
        Test.startTest();

        List<User> lusers = [SELECT RUT_Usuario__c FROM User WHERE Id = :UserInfo.getUserId()];
                
        String rutUsuario = '';
        
        if (lusers.size() > 0)
        {
            rutUsuario = lusers[0].RUT_Usuario__c;      
        }

        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(79, 'Cerrado', rutUsuario);
        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(79, 'Rechazado', rutUsuario);
        CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(79, 'En Revisión', rutUsuario);
        Test.stopTest();
    }
    
    @isTest static void ActualizaEstadoTareasUR_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();         
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
        CLS_UR_Caso_CambioEstado.ActualizaEstadoTareasUR(caso.Id);
        Test.stopTest();
    }
    
    @isTest static void ActualizaCasoAtencion_Test()
    {
        Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();         
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        CLS_UR_Caso_CambioEstado.ActualizaCasoAtencion(caso.Id, false);
        Test.stopTest();
    } 
}