/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 11-19-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_CS_Gestion_CasoAtencion {
    public TEST_CLS_CS_Gestion_CasoAtencion() {

    }

    @IsTest
    public static void SaveStatusCase_basic_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoAtencion.SaveStatusCase(caso.Id, 'Cerrado');
        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Status, 'Cerrado');
    }

    @IsTest
    public static void SaveStatusCase_basic_02()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoAtencion.SaveStatusCase(caso.Id, 'En Proceso');
        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Status, 'En Proceso');
    }

    @IsTest
    public static void SaveStatusCase_televentas_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoAtencion.SaveStatusCase(caso.Id, 'Cerrado', 'No le interesa');
        Test.stopTest();

        Case c = [SELECT Id, Sub_estado__c FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Sub_estado__c, 'No le interesa');
    }

    @IsTest
    public static void SaveStatusCase_televentas_02()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoAtencion.SaveStatusCase(caso.Id, 'En Proceso' , 'Volver a llamar');
        Test.stopTest();

        Case c = [SELECT Id, Sub_estado__c FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Sub_estado__c, 'Volver a llamar');
    }

    @IsTest
    public static void PoseeHijos_EnProceso()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoAtencion.PoseeHijos_EnProceso(caso.Id);
        Test.stopTest();
    }
}