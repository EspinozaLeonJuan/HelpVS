@IsTest 
public class TEST_PAR_EXT_WS_CM_PrimaFinal {
     @isTest static void go()
     {
          Test.startTest();
         PAR_EXT_WS_CM_PrimaFinal clase = new PAR_EXT_WS_CM_PrimaFinal();
         clase.primaPoliza = new PAR_EXT_WS_CM_PrimaFinal.cls_primaPoliza();
         clase.primaPoliza.netPremium = 0.042;
         clase.primaPoliza.ivaPremium = 0.008;
         clase.primaPoliza.totalPrima = 0.05;
    
         PAR_EXT_WS_CM_PrimaFinal.parse('{"primaPoliza":{"netPremium":0.12,"ivaPremium":0,"totalPrima":0.12}}');
          Test.stopTest();
     }
}