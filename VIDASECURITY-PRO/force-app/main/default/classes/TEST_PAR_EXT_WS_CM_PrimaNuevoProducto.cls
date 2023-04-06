@IsTest 
public class TEST_PAR_EXT_WS_CM_PrimaNuevoProducto {
     @isTest static void go()
     {
         Test.startTest();
         PAR_EXT_WS_CM_PrimaNuevoProducto clase = new PAR_EXT_WS_CM_PrimaNuevoProducto();
         clase.primaProspecto = new PAR_EXT_WS_CM_PrimaNuevoProducto.cls_primaProspecto();
         clase.primaProspecto.coverageCode = 'PMCT';
         clase.primaProspecto.coverageName = 'PRESTACIONES MEDICAS CATASTROFICAS (TITULARES)';
         clase.primaProspecto.coverageRate = 0.0173;
         clase.primaProspecto.netPremium = 0.173;
         clase.primaProspecto.ivaPremium = 0.0329;
         clase.primaProspecto.totalPremium = 0.2059;        
         Test.stopTest();
     }
}