@IsTest 
public class TEST_RUTUtils {
    
    @isTest static void isValid()
    {
        Test.startTest();
        RUTUtils.isValid('150455170');
        Test.stopTest();
    }
    
    @isTest static void getDigito()
    {
        Test.startTest();
        RUTUtils.getDigito(15045517);
        Test.stopTest();
    }
    
}