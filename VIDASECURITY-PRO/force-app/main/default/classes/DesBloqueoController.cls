public with sharing class DesBloqueoController {
	
	public Filial__c filial {get; set;}
	public Corredor__c corredor {get; set;}

	public Boolean showSections {get; set;}
	public String requestLabel;
	public String continuationResult {get;set;}
	
	public DesBloqueoController() {
		this(null);
	}
	
	public DesBloqueoController(ApexPages.StandardController controller) {
		this.showSections = true;
		String recordIdString  = controller != null ? controller.getId() : System.currentPageReference().getParameters().get('id');
		if (recordIdString == null)
		return;
		Id recordId = Id.valueOf(recordIdString);
		if (recordId != null && recordId.getSobjectType() == Schema.Filial__c.getSobjectType())
			desbloqueoControllerPorFilial(controller, recordId);
		else if (recordId != null && recordId.getSobjectType() == Schema.Corredor__c.getSobjectType())
			desbloqueoControllerPorCorredor(controller, recordId);
			}
	
	public void desbloqueoControllerPorFilial(ApexPages.StandardController controller, Id recordId) {
		if (controller != null && !Test.isRunningTest())
			controller.addFields(new String[] {'Name', 'Estado_Beneficio__c', 'Numero_Poliza__c', 'Poliza__r.Corredor__c', 'Rut_Empresa__c', 'Dv_Empresa__c', 'Rut_Filial__c', 'Grupo_Cobranza__c'});
		this.filial = controller != null ? (Filial__c)controller.getRecord() : [SELECT Id, Name, Estado_Beneficio__c, Numero_Poliza__c, Poliza__r.Corredor__c, Rut_Empresa__c, Dv_Empresa__c, Rut_Filial__c, Grupo_Cobranza__c FROM Filial__c WHERE Id = :recordId LIMIT 1];
	}
	
	public void desbloqueoControllerPorCorredor(ApexPages.StandardController controller, Id recordId) {
		if (controller != null && !Test.isRunningTest())
			controller.addFields(new String[] {'Name'});
		this.corredor = controller != null ? (Corredor__c)controller.getRecord() : [SELECT Id, Name FROM Corredor__c WHERE Id = :recordId LIMIT 1];
	}

	public System.Pagereference init(){
		if (this.filial != null && this.filial.Estado_Beneficio__c != BloqueoService.BLOQUEADO){
				this.showSections = false;
				PageUtils.addError('Esta filial no se encuentra bloqueada');
		}
		return null;
	}
	
	public Object desBloquearFilial() {
		this.continuationResult = 'desbloquearFilial Continuation iniciado';
		System.debug('DesBloqueoController.desbloquearFilial - BEGIN');

		try {
			if (this.filial.Estado_Beneficio__c != BloqueoService.BLOQUEADO){
			this.showSections = false;
			throw new CobranzaException('Esta filial no se encuentra bloqueada.');
			}

			EstadoBeneficioRequest request = new EstadoBeneficioRequest(filial);
            ContinuationContext ctx = EstadoBeneficioAPI.initContinuationDesbloquearBeneficio(request, 'desbloquearFilialCallback');
            this.requestLabel = ctx.requestLabel;
    		return ctx.continuation;
		} catch (Exception e) {
			PageUtils.addError(e);
			return null;
		}
	}

	public Object desbloquearFilialCallback() {
		this.showSections = false;

		try {
        	System.debug('DesBloqueoController.desbloquearFilialCallback - BEGIN');
			HttpResponse response = Continuation.getResponse(this.requestLabel);
			EstadoBeneficioResponse estadoBeneficioResponse = (EstadoBeneficioResponse)System.JSON.deserialize(response.getBody(), EstadoBeneficioResponse.class);
	
			DesBloqueoService.procesarResponseAPI(estadoBeneficioResponse, filial);
			this.continuationResult = 'PROCESO FINALIZADO!!!';
			
			if (PageUtils.hasErrors())
				return null;
				
			this.continuationResult = 'PROCESO FINALIZADO!!!';
			PageUtils.addInfo('Proceso Finalizado. Por favor, revise el resultado del desbloqueo de beneficios en la bitácora asociada a la filial.');
		} catch (Exception e) {
			PageUtils.addError(e.getMessage());
		}
		return null;

    }
    
	public Filial__c[] getFiliales() {
		return DesbloqueoService.getFilialesDesbloqueadas(this.corredor == null ? null : this.corredor.Id);
	}
}