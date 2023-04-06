public with sharing class RecordatorioBloqueoController {
	
	public Corredor__c corredor {get; set;}
	
	public RecordatorioBloqueoController(ApexPages.StandardController controller) {
		this.corredor = (Corredor__c)(controller == null ? null : controller.getRecord());
	}  
	
    public RecordatorioBloqueoController() {
    	this((ApexPages.StandardController)null);
    }
    
	public Filial__c[] getFiliales() {
		return RecordatorioBloqueoService.getFilialesBloqueadas	(this.corredor.Id);
	}
}