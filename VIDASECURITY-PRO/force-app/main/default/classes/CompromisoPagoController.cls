public with sharing class CompromisoPagoController {
	
	public Factura__c[] facturas {get; set;}
	public Date fecha {get; set;}

	public Boolean showSections {get; set;}
	public String requestLabel;
	public String continuationResult {get;set;}
	
    public CompromisoPagoController(ApexPages.StandardSetController controller) {
		this.continuationResult = 'Controller iniciado';
		System.debug('CompromisoPagoController.ctor BEGIN');
    	if (!Test.isRunningTest())
    	controller.addFields(new String[] {'Name', 'Id_Factura__c', 'Numero_Factura__c', 'Rut_Empresa__c', 'Razon_Social__c', 'Periodo_Cobranza__c', 'Filial__r.Name', 'Fecha_Bloqueo_Beneficios__c', 'Estado_Pago__c', 'Filial__r.Estado_Beneficio__c', 'Poliza__c','Poliza__r.Corredor__c','Fecha_Bloqueo_Automatica__c'});    	
    	this.facturas = (Factura__c[])controller.getSelected();
		this.showSections = true;
    }
    
	public System.PageReference init() {
		if (this.facturas == null || this.facturas.isEmpty()){
			this.showSections = false;
			return PageUtils.addError('Debe seleccionar al menos una factura pendiente de pago.');
		}
		return null;
	}
    
	public Object establecerCompromiso() {
		this.continuationResult = 'establecerCompromiso Continuation iniciado';
		// System.debug('CompromisoPagoController.establecerCompromiso - BEGIN');

    	if (this.fecha == null)
    		return PageUtils.addError('Debe seleccionar una fecha de compromiso de pago');
    	if (this.fecha < Date.today())
    		return PageUtils.addError('La fecha comprometida debe ser igual o posterior a la fecha actual');
	
    	Id[] facturaIds = new List<Id>();
		for (Factura__c factura : facturas) {
			// System.assertNotEquals(null, factura.Id, 'El id de la factura es null');
			if (factura.Estado_Pago__c == FacturaService.Cerrado){
				this.showSections = false;
				PageUtils.addError('No es posible establecer compromiso de pago para la factura ' + factura.Numero_Factura__c + ' de ' + factura.Razon_Social__c + ', pues ya se encuentra pagada. Por favor seleccione solo facturas pendientes de pago.');				
			}
			facturaIds.add(factura.Id);
			//System.debug('factura abierta encontrada');
			//System.debug(factura);
			//System.debug(factura.Estado_Pago__c);
		}
    	if (ApexPages.hasMessages())
    		return null;

		/* Se setean las facturas con todas sus props requeridas. 
		Se necesitarán con toda esta data ya cargaa para la segunda parte del Continuation, 
		en este estado, y no ejecutar nuevamente la query */
		System.debug('seteo facturas, request y continuation');
		List<Factura__c> facturas = (Factura__c[])CompromisoPagoService.getFacturas(facturaIds);
		System.debug(facturas);
		IngresarCompromisoPagoRequest[] requests = CompromisoPagoService.getCompromisoPagoRequest(facturas, this.fecha);
		System.debug(requests);
		ContinuationContext ctx = CompromisoPagoAPI.initContinuationEnviarCompromiso(requests, 'establecerCompromisoCallback');
		System.debug(ctx);

		this.requestLabel = ctx.requestLabel;
		return ctx.continuation;

    }

	public Object establecerCompromisoCallback(){
		try {
			System.debug('CompromisoPagoController.establecerCompromisoCallback - BEGIN');
      system.debug('@@@ this.requestLabel : ' + this.requestLabel);
			HttpResponse response = Continuation.getResponse(this.requestLabel);
      system.debug('@@@ response : ' + response);
      system.debug('@@@ response body : ' + response.getBody());
			IngresarCompromisoPagoResponse[] responses = (IngresarCompromisoPagoResponse[])System.JSON.deserialize(response.getBody(), List<IngresarCompromisoPagoResponse>.class);
			system.debug('@@@ responses : ' + responses);
			CompromisoPagoService.procesarResponseAPI(responses, facturas, this.fecha);
			
			this.continuationResult = 'PROCESO FINALIZADO!!!';
			if (PageUtils.hasErrors())
				return null;

			PageUtils.addInfo('El proceso a finalizado. Por favor verifique el resultado en la bitácora asociada a la filial.');
			this.showSections = false;
		} catch (Exception e) {
			PageUtils.addError(e);
		}
		return null;
	}
}