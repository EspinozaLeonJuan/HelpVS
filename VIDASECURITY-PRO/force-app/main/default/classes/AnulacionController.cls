public with sharing class AnulacionController {
	
	public Poliza__c poliza {get; set;}
	public Poliza__c[] polizas {get; set;}
	public Boolean showSections {get; set;}
	
	public AnulacionController(ApexPages.StandardController controller) {
		if (!Test.isRunningTest())
			controller.addFields(new String[] {'Name', 'Estatus__c', 'RecordType.Name', 'Corredor__c','Cuenta__c'});
		this.poliza = (Poliza__c)controller.getRecord();
		this.polizas = null;
		this.showSections = true;
	}
	
	public AnulacionController(ApexPages.StandardSetController controller) {
		if (!Test.isRunningTest())
			controller.addFields(new String[] {'Name', 'Estatus__c', 'RecordType.Name', 'Corredor__c','Cuenta__c'});
		this.polizas = (Poliza__c[])controller.getSelected();
		this.poliza = null;
		this.showSections = true;
	}
	
	public System.PageReference init() {
		if (this.poliza == null && (this.polizas == null || this.polizas.isEmpty()))
			PageUtils.addError('Debe seleccionar al menos una póliza para anular');
		if (this.poliza != null && this.poliza.Estatus__c == 'ANULADA')
			PageUtils.addInfo('Esta poliza ya se encuentra anulada.');
		if (ApexPages.hasMessages())
			this.showSections = false;
		return null;
	}
	
	public System.PageReference anularPoliza() {
		try {
			AnulacionService.anular(poliza);
			PageUtils.addInfo('Se ha anulado la póliza exitosamente.');
		} catch (Exception e) {
			PageUtils.addError(e);
					}
		this.showSections = false;
		return null;
	}

	
	public System.PageReference notificarAnulacion() {
		try {
			if (this.polizas != null)
				AnulacionService.notificarAnulacion(this.polizas);
			else if (this.poliza != null)
				AnulacionService.notificarAnulacion(this.poliza);
			PageUtils.addInfo('Se ha notificado la anulación de la(s) póliza(s) exitosamente.');
		} catch (Exception e) {
			PageUtils.addError(e);
					}
		this.showSections = false;
		return null;
	}
}