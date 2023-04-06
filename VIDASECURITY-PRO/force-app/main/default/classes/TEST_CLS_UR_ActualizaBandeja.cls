/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CLS_UR_ActualizaBandeja                                                  	|
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CLS_UR_ActualizaBandeja                                                        |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |     1.0      *    2019/09/27   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@istest(seeAllData=true)
public class TEST_CLS_UR_ActualizaBandeja {
    @isTest
    public static void actualizaCasosUsuariosBackup_Test01 ()
    {
        Test.startTest();
        CLS_UR_ActualizaBandeja.actualizaCasosUsuariosBackup('Producción Individuales');
        Test.stopTest();
    }

     @isTest
    public static void actualizaTareasUsuariosBackup_Test01 ()
    {
        Test.startTest();
        CLS_UR_ActualizaBandeja.actualizaTareasUsuariosBackup('Producción Individuales');
        Test.stopTest();
    }

      @isTest
    public static void actualizaColaboracionesUsuariosBackup_Test01 ()
    {
        Test.startTest();
        CLS_UR_ActualizaBandeja.actualizaColaboracionesUsuariosBackup('Producción Individuales');
        Test.stopTest();
    }
}