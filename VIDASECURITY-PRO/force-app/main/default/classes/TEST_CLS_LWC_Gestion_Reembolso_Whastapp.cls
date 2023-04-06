/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-05-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_LWC_Gestion_Reembolso_Whastapp {
    static String CsvBase64_1 ='"REMESA\\r\\nAMBUL20225120430\\r\\nAMBUL20225120425\\r\\nDENTAL20225120453\\r\\nDENTAL20225120452\\r\\nAMBUL20225120451\\r\\nDENTAL20225120433\\r\\nAMBUL20225120430\\r\\n"';

    @Istest
    static void test_1()
    {
        Test.startTest();
        CLS_LWC_Gestion_Reembolso_Whastapp.uploadFile(CsvBase64_1);
        Test.stopTest();
    }


    @Istest
    static void test_2()
    {
        Test.startTest();
        CLS_LWC_Gestion_Reembolso_Whastapp.proccessFile(CsvBase64_1);
        Test.stopTest();
    }


    @Istest
    static void test_3()
    {
        Test.startTest();
        CLS_LWC_Gestion_Reembolso_Whastapp.Wrapper_Reembolso wp = new CLS_LWC_Gestion_Reembolso_Whastapp.Wrapper_Reembolso();
        wp.HoraInicio = System.now();
        wp.HoraTermino = System.now();
        wp.Estado = '';
        wp.Remesa = '';
        wp.NumeroDenuncio = '';
        wp.IdSolicitud = '';
        Test.stopTest();
    }



    @Istest
    static void test_4()
    {
        Test.startTest();
        CLS_LWC_Gestion_Reembolso_Whastapp.getDataLine('"REMESA"');
        Test.stopTest();
    }


}