public with sharing class AvisoBloqueoController {
	
	public Corredor__c corredor {get; set;}
	
	public AvisoBloqueoController(ApexPages.StandardController controller) {
		this.corredor = (Corredor__c)controller.getRecord();
	}  
	
    public AvisoBloqueoController() {
    }
    
	public Filial__c[] getFiliales() {
		return AvisoBloqueoService.getFilialesPorBloquear(this.corredor.Id);
	}

	public Boolean getHasFiliales(){
		Filial__c[] filiales = [SELECT Id FROM Filial__c WHERE Poliza__r.Corredor__c =: this.corredor.id ];
		return !filiales.isEmpty();
	}	

	public Boolean getFilialesBloqueadas(){
		Filial__c[] filiales = [SELECT Id FROM Filial__c WHERE Poliza__r.Corredor__c =: this.corredor.id AND Estado_Beneficio__c <> 'BLOQUEADO'];
		return filiales.isEmpty();
	}	
	
	public Boolean getNotificarAvisoBloqueo() {
		Factura__c[] facturas = AvisoBloqueoService.getFacturasPorBloquear(new Id[] {this.corredor.Id});
		return !facturas.isEmpty();
	}
	
	public System.PageReference sendEmail() {
		AvisoBloqueoService.notificarAvisosBloqueo(new List<Id> {corredor.Id});
		return new ApexPages.StandardController(this.corredor).view();
	}
        }