public class DetallePolizaController {

	 public Poliza__c poliza {get;set;}
	 public static Boolean anonymous = false;
	 
	public DetallePolizaController(ApexPages.StandardController controller){
		if (!Test.isRunningTest() && !anonymous)
			controller.addFields(new String[] {'Name', 'N_Poliza__c'});
		this.poliza = (Poliza__c)controller.getRecord();
	 
	}
	
}