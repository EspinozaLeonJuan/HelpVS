@isTest
public  class OportunidadRenovacionSchedulableTest {
    
    @isTest
    public static void jobTest()
    {
        Test.startTest();
        String jobId = System.schedule('testOportunidadRenovacion','0 0 0 12 4 ? 2025',new OportunidadRenovacionSchedulable());
        Test.stopTest();

    }
}