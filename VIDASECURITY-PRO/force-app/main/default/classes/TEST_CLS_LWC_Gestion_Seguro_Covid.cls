/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-15-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_LWC_Gestion_Seguro_Covid {

    static String CsvBase64_1 = '"RUT EMPRESA,RUT CONTACTO,NOMBRE CONTACTO,APELLIDO CONTACTO,TIPO CONTACTO,CORREO ELECTRONICO,RUT EMPRESA CORREDORA\\r\\n76525140-0,12669391-5,Sandra ,Garces,Corredor,sandra.garces@security.cl,99301000-6\\r\\n76047102-K,12669391-5,Sandra ,Garces,Corredor,sandra.garces@security.cl,99301000-6\\r\\n"';

    static String CsvBase64_2 = '"RUT EMPRESA\\r\\n76525140-0\\r\\n76047102-K\\r\\n"';

    @Istest
    static void test_1()
    {

        Test.startTest();
        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact>  lista1 =  CLS_LWC_Gestion_Seguro_Covid.uploadFileContacts(CsvBase64_1);
         List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa>  lista12=  CLS_LWC_Gestion_Seguro_Covid.uploadFileRutEmpresas(CsvBase64_2);

         Boolean  r1 =  CLS_LWC_Gestion_Seguro_Covid.saveFileContacts(CsvBase64_1);
         Integer  r2 =   CLS_LWC_Gestion_Seguro_Covid.sendEmail(CsvBase64_2);
        Test.stopTest();

       }
}