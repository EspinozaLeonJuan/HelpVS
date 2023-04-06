@IsTest 
public class TEST_PAR_EXT_WS_CM_Exclusiones {
     @isTest static void go()
     {
          Test.startTest();
          PAR_EXT_WS_CM_Exclusiones clase = new PAR_EXT_WS_CM_Exclusiones();
          clase.sobrePrima = new PAR_EXT_WS_CM_Exclusiones.cls_sobrePrima();
          clase.sobrePrima.ensuredRut = '19203876-6';
          clase.sobrePrima.product = 'MD01972000B003';
          clase.sobrePrima.coverageCode = 'PMCN';
          clase.sobrePrima.coverageName = 'PRESTACIONES MEDICAS CATASTROFICAS (NO TITULARES)';
          clase.sobrePrima.recaDctoExcl = new PAR_EXT_WS_CM_Exclusiones.cls_recaDctoExcl[1];
          clase.sobrePrima.recaDctoExcl[0] = new PAR_EXT_WS_CM_Exclusiones.cls_recaDctoExcl();
          clase.sobrePrima.recaDctoExcl[0].actionType = 'E';
         clase.sobrePrima.recaDctoExcl[0].porcentajeMilaje = '0';
         clase.sobrePrima.recaDctoExcl[0].extraPremiumFactor = 0;
         clase.sobrePrima.recaDctoExcl[0].extraPremiumAmount = 0;
         clase.sobrePrima.recaDctoExcl[0].cause = 'Cirugía para Miopía gastos asociados, secuelas y complicaciones';
         /*
public cls_sobrePrima sobrePrima;
	
	public class cls_sobrePrima {
		public String 
		public String 
		public String 
		public String 
		public cls_recaDctoExcl[] recaDctoExcl {get; set;}
	}

	public class cls_recaDctoExcl {
		public String actionType {get; set;}	//E
		public String porcentajeMilaje {get; set;}	//
		public Integer extraPremiumFactor {get; set;}	//0
		public Integer extraPremiumAmount {get; set;}	//0
		public String cause {get; set;}	//
	}
    
*/
         
         
         //PAR_EXT_WS_CM_PrimaFinal.parse('{"primaPoliza":{"netPremium":0.12,"ivaPremium":0,"totalPrima":0.12}}');
          Test.stopTest();
     }
}