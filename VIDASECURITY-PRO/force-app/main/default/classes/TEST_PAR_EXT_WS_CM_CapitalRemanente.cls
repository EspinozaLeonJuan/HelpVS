@IsTest 
public class TEST_PAR_EXT_WS_CM_CapitalRemanente {
     @isTest static void go()
     {
          Test.startTest();
         PAR_EXT_WS_CM_CapitalRemanente clase = new PAR_EXT_WS_CM_CapitalRemanente();
         clase.principalAmount = 0.042;
         clase.remainingAmount = 0.008; 
    
         PAR_EXT_WS_CM_CapitalRemanente.parse('{"principalAmount":15000, "remainingAmount":0}');
          Test.stopTest();
     }
}