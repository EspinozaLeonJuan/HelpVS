@IsTest 
public class TEST_PAR_EXT_WS_CM_PrimaPoliza {
     @isTest static void go()
     {
          Test.startTest();
         PAR_EXT_WS_CM_PrimaPoliza clase = new PAR_EXT_WS_CM_PrimaPoliza(); 
         clase.netPremium = 0.042;
         clase.ivaPremium = 0.008;
         clase.totalPrima = 0.05;
      
         PAR_EXT_WS_CM_PrimaPoliza.parse('{"netPremium":0.12,"ivaPremium":0,"totalPrima":0.12}');
          Test.stopTest();
     }
}