@IsTest
public class TEST_CTR_TV_BotoneraCarga {
    
    @isTest static void inicioBotonera()
    {
        Test.startTest();
        CTR_TV_BotoneraCarga ctr = new CTR_TV_BotoneraCarga();
        ctr.inicioBotonera();
        Test.stopTest();
    }
   
    @isTest static void  HistorialCargasCampagnas()
    {
        Test.startTest();
        CTR_TV_BotoneraCarga ctr = new CTR_TV_BotoneraCarga();
        ctr.HistorialCargasCampagnas();
        Test.stopTest();
    }

    @isTest static void  NuevaCargaCampagna()
    {
        Test.startTest();
        CTR_TV_BotoneraCarga ctr = new CTR_TV_BotoneraCarga();
        ctr.NuevaCargaCampagna();
        Test.stopTest();
    }
    
}