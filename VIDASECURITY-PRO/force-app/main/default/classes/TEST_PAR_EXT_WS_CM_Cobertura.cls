@IsTest 
public class TEST_PAR_EXT_WS_CM_Cobertura {
     @isTest static void go()
     {
          Test.startTest();
         PAR_EXT_WS_CM_Cobertura clase = new PAR_EXT_WS_CM_Cobertura(); 
         clase.primaPoliza = new PAR_EXT_WS_CM_Cobertura.cls_primaPoliza();
         clase.primaPoliza.rut = '19203876-6';
         clase.primaPoliza.product = 'MD01972000B003';
         clase.primaPoliza.flagPolicyHolder = 'N';
         clase.primaPoliza.coverages = new PAR_EXT_WS_CM_Cobertura.cls_coverages[1];
         clase.primaPoliza.coverages[0] = new PAR_EXT_WS_CM_Cobertura.cls_coverages();
         clase.primaPoliza.coverages[0].codeCobert = 'PMCN';
         clase.primaPoliza.coverages[0].nameCobert = 'PRESTACIONES MEDICAS CATASTROFICAS (NO TITULARES)';
         clase.primaPoliza.coverages[0].capital = 15000;
         clase.primaPoliza.coverages[0].premium = 0;
         clase.primaPoliza.coverages[0].extraPremium = 0;
         clase.primaPoliza.coverages[0].extraPremiumType = '';
         clase.primaPoliza.coverages[0].fecu = '0109';
      
          Test.stopTest();
     }
}