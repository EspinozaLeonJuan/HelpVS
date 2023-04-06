/**
Si no funciona la validación de bloqueo
{!REQUIRESCRIPT("/soap/ajax/46.0/connection.js")} 
{!REQUIRESCRIPT("/soap/ajax/46.0/apex.js")} 

if ("{!Filial__c.Estado_Beneficio__c}" == "BLOQUEADO") {
	alert("No es posible bloquear esta filial porque ya se encuentra bloqueada.");
	return;
}
window.location.href = "/apex/bloqueoFilial?id={!Filial__c.Id}";


*/
public with sharing class BloqueoController {
	
	public Filial__c filial {get; set;}

	public Boolean showSections {get; set;}
    public String requestLabel;
	public String continuationResult {get;set;}
	
	public BloqueoController(ApexPages.StandardController controller) {
		if (!Test.isRunningTest())
			controller.addFields(new String[] {'Name', 'Estado_Beneficio__c', 'Numero_Poliza__c', 'Poliza__r.Corredor__c', 'Rut_Empresa__c', 'Dv_Empresa__c', 'Rut_Filial__c', 'Grupo_Cobranza__c'});
		this.filial = (Filial__c)controller.getRecord();
		this.showSections = true;
	}

	public System.Pagereference init(){
		if (this.filial.Estado_Beneficio__c == BloqueoService.BLOQUEADO){
				this.showSections = false;
				PageUtils.addError('Esta filial ya se encuentra bloqueada');
		}
		return null;
	}
    
	public Object bloquearFilial() {
        this.continuationResult = 'bloquearFilial Continuation iniciado';
		System.debug('BloqueoController.bloquearFilial - BEGIN');

		try {
			if (this.filial.Estado_Beneficio__c == BloqueoService.BLOQUEADO){
				this.showSections = false;
				throw new CobranzaException('Esta filial ya se encuentra bloqueada.');
			}
				
            EstadoBeneficioRequest request = new EstadoBeneficioRequest(filial);
            ContinuationContext ctx = EstadoBeneficioAPI.initContinuationBloquearBeneficio(request, 'bloquearFilialCallback');
            this.requestLabel = ctx.requestLabel;
    		return ctx.continuation;
		} catch (Exception e) {
			PageUtils.addError(e);
			return null;
		}
	}

	public Object bloquearFilialCallback() {
		this.showSections = false; 

		try {
			System.debug('BloqueoController.bloquearFilialCallback - BEGIN');
			HttpResponse response = Continuation.getResponse(this.requestLabel);
			EstadoBeneficioResponse estadoBeneficioResponse = (EstadoBeneficioResponse)System.JSON.deserialize(response.getBody(), EstadoBeneficioResponse.class);

			BloqueoService.procesarResponseAPI(estadoBeneficioResponse, filial);
			this.continuationResult = 'PROCESO FINALIZADO!!!';
			
			if (PageUtils.hasErrors())
				return null;
			
			PageUtils.addInfo('Proceso Finalizado. Por favor, revise el resultado del bloqueo de beneficios en la bitácora asociada a la filial.');
		} catch (Exception e) {
			PageUtils.addError(e.getMessage());
		}

		//Return null to re-render the original Visualforce page
		return null;

    }

}