/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CLS_INV_Caso_CierraReclamo                                                |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_CS_Colaboracion                                                            |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/09/16   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@isTest(seeAllData=true)
public class TEST_CLS_INV_Caso_CierraReclamo {
    @isTest 
    public static void ActualizaColaboraciones()
    { 
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();     
        Case caso = Factory.buildCasoSF('Reclamos', cuenta);
        insert caso;

        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
       	
 
       // List<Usuario_Backup__c> Uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE UBAC_Area__c = 'Producción RRVV' LIMIT 1];
		system.debug('@@@@ Uback --> '+Uback);
        
        Task colaboracion1 = Factory.buildTask_Colaboracion(caso.Id);
        
        system.debug('@@@@ colaboracion1 --> '+colaboracion1);
        colaboracion1.Responsable_Backup__c = Uback.Id;
        insert colaboracion1;

        Task colaboracion2 = Factory.buildTask_Colaboracion(caso.Id);
        colaboracion2.Responsable_Backup__c = Uback.Id;
        insert colaboracion2;

        List<String> Ids = new List<String>();
        Ids.add(caso.Id);        
        CLS_INV_Caso_CierraReclamo.ActualizaColaboraciones(Ids);
        Test.stopTest();
    }
}