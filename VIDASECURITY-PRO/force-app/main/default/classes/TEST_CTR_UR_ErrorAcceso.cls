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
@isTest
public class TEST_CTR_UR_ErrorAcceso {
    @isTest static void Inicio_Test()
    {
        Test.startTest();
        CTR_UR_ErrorAcceso CTR = new CTR_UR_ErrorAcceso();
        CTR.Inicio();
        Test.stopTest();
    }
      
}