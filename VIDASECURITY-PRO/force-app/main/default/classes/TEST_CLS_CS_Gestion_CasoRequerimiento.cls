/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-06-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_CS_Gestion_CasoRequerimiento {

    private static String RecordTypeId_Colectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();
    private static String RecordTypeId_Individuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
    private static String RecordTypeId_Masivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Masivos').getRecordTypeId();
    private static String RecordTypeId_RRVV = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Rentas Vitalicias').getRecordTypeId();
    private static String RecordTypeId_PF = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').getRecordTypeId();
    private static String RecordTypeId_CuentaPersonal = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
    private static String RecordTypeId_CuentaCorporativa = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();


    @IsTest
    public static void getPolizas_Test_01()
    {
        Account cuentaPersonal = new Account(FirstName='A', LastName='B', RecordTypeId = RecordTypeId_CuentaPersonal, RUT__c = '482123880');
        insert cuentaPersonal;

        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = RecordTypeId_CuentaCorporativa, RUT__c = '482123881');
        insert cuentaCorporativa;


        Poliza__c poliza_Individual = new Poliza__c(Rut_Asegurado__c = cuentaPersonal.RUT__c, RecordTypeId = RecordTypeId_Individuales,  Cuenta__c = cuentaPersonal.Id,  Name = '1');
        insert poliza_Individual;

        // Poliza__c poliza_RRVV = new Poliza__c(Rut_Asegurado__c = cuentaPersonal.RUT__c, RecordTypeId = RecordTypeId_Individuales,  Cuenta__c = cuentaPersonal.Id,  Name = '1');
        // insert poliza_Individual;

        // Poliza__c poliza_Individual = new Poliza__c(Rut_Asegurado__c = cuentaPersonal.RUT__c, RecordTypeId = RecordTypeId_Individuales,  Cuenta__c = cuentaPersonal.Id,  Name = '1');
        // insert poliza_Individual;

        // Poliza__c poliza_Individual = new Poliza__c(Rut_Asegurado__c = cuentaPersonal.RUT__c, RecordTypeId = RecordTypeId_Individuales,  Cuenta__c = cuentaPersonal.Id,  Name = '1');
        // insert poliza_Individual;

        Poliza__c poliza_Colectivo = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, RecordTypeId = RecordTypeId_Colectivos,  Cuenta__c = cuentaCorporativa.Id,  Name = '2');
        insert poliza_Colectivo;

        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaCorporativa.Id, 'Seguros Colectivos', 'SEGURO COVID');
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaCorporativa.Id, 'Seguros Colectivos', '');
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaPersonal.Id, 'Seguros Familiares', '');
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaPersonal.Id, 'Seguros Individuales', '');
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaPersonal.Id, 'Seguros Masivos', '');
        CLS_CS_Gestion_CasoRequerimiento.getPolizas(cuentaPersonal.Id, 'RRVV', '');

        Test.stopTest();

    }

    @IsTest
    public static void get_pickList_Categorias_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_Categorias('Seguros Individuales');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_DetalleSolicitud_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleSolicitud('Documentos IND');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_DetalleRescate_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleRescate('ED - Solicitud Rescate Total');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_DetalleConfiguracion_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleConfiguracion('Configuración TRASSA');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_CantidadMesesSuspendido_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_CantidadMesesSuspendido();
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_Conceptos_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_Conceptos('Seguros Individuales');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_Productos_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_Productos('Seguros Individuales');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_TipoOperacion_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_TipoOperacion('Accidentes Personales');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_DetalleOperacion_Test_01()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.get_pickList_DetalleOperacion('Cursado fuera de plazo');
        Test.stopTest();
    }


    @IsTest
    public static void create_CasoRequerimiento_Solicitud_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Case casoPadre = Factory.buildCasoSF('Atención', cuenta);
        casoPadre.Negocio__c = 'Seguros Individuales';
        insert casoPadre;

        Test.startTest();
        String IdR =  CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Solicitud(casoPadre.Id, '', 'Documentos IND', 'Endoso IND', '' , '', '', '', '', '','description','Documentos sin revisar');
        Test.stopTest();
        system.debug('IdR '+IdR);
        System.assertNotEquals('ERROR', IdR);
    }


    @IsTest
    public static void create_CasoRequerimiento_Reclamo_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Case casoPadre = Factory.buildCasoSF('Atención', cuenta);
        casoPadre.Negocio__c = 'Seguros Individuales';
        insert casoPadre;

        Test.startTest();
        String IdR =  CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Reclamo(casoPadre.Id, '', 'Accidentes Personales', 'Cierre Producto', 'No Solicitado' , '', '', '','description');
        Test.stopTest();
        system.debug('IdR '+IdR);
        System.assertNotEquals('ERROR', IdR);
    }

     @IsTest
    public static void create_CasoRequerimiento_Consulta_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        CTR_UR_Caso controlador = new CTR_UR_Caso();
        Case casoPadre = Factory.buildCasoSF('Atención', cuenta);
        casoPadre.Negocio__c = 'Seguros Individuales';
        insert casoPadre;

        Test.startTest();
        String IdR =  CLS_CS_Gestion_CasoRequerimiento.create_CasoRequerimiento_Consulta(casoPadre.Id, '', 'Certificados', '', '','description', 'true', 'SI');
        Test.stopTest();
        system.debug('IdR '+IdR);
        System.assertNotEquals('ERROR', IdR);
    }

    @IsTest
    public static void SaveStatusCase_basic_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase(caso.Id, 'Cerrado', false);
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
        CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase(caso.Id, 'En Proceso', false);
        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Status, 'En Proceso');
    }

      @IsTest
    public static void SaveStatusCase_basic_03()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;

        Case casoS = Factory.buildCasoSF('Solicitudes', cuenta);
        casoS.ParentId = caso.Id;
        insert casoS;

        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase(caso.Id, 'En Proceso', true);
        CLS_CS_Gestion_CasoRequerimiento.SaveStatusCase(caso.Id, 'Cerrado', true);

        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: caso.Id];
        System.assertEquals(c.Status, 'Cerrado');
    }

    @IsTest
    public static void get_esCasoDerivable_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;

        String response = '';
        Test.startTest();
        response = CLS_CS_Gestion_CasoRequerimiento.get_esCasoDerivable(caso.Id);
        Test.stopTest();
        system.debug('@@@@ response '+response);
        System.assertEquals(response, 'false');
    }

    @IsTest
    public static void get_esDerivacionOptativa_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;

        String response = '';
        Test.startTest();
        response = CLS_CS_Gestion_CasoRequerimiento.get_esDerivacionOptativa(caso.Id);
        Test.stopTest();
        System.assertEquals(response, 'true');
    }

    @IsTest
    public static void get_cambioEscritorioDigital_Test_01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;

        String response = '';
        Test.startTest();
        response = CLS_CS_Gestion_CasoRequerimiento.get_cambioEscritorioDigital(caso.Id);
        Test.stopTest();

        System.assertNotEquals(response, '');
    }

    @IsTest
    public static void DerivarCaso_Test01()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;

        Test.startTest();
        Boolean response = CLS_CS_Gestion_CasoRequerimiento.DerivarCaso(caso.Id, '');
        Test.stopTest();
    }

    @IsTest
    public static void getAdjuntosCaso()
    {
        Account cuenta = Factory.cuenta.buildInsert();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;

        Test.startTest();
        List<Adjunto__c> response = CLS_CS_Gestion_CasoRequerimiento.getAdjuntosCaso(caso.Id);
        Test.stopTest();
    }


    @IsTest
    public static void getOptionsProtocolo()
    {
        Test.startTest();
        CLS_CS_Gestion_CasoRequerimiento.getOptionsProtocolo();
        Test.stopTest();
    }

    @IsTest(seeAllData = true)
    public static void getIsProtocoloAtencion()
    {

        Test.startTest();
        Boolean response = CLS_CS_Gestion_CasoRequerimiento.getIsProtocoloAtencion('Copia de Liquidacion');
        Test.stopTest();
    }

}