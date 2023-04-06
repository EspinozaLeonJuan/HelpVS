public with sharing class IngresarCompromisoPagoRequest {
	
	public Integer numPoliza {get; set;}
	public String rutFilial {get; set;}
	public Integer codFactura {get; set;}
	public String usuarioIng {get; set;} //Usuario que ingresa el compromiso de pago
	public String fechaComp {get; set;} //format date . Fecha de cuando se está realizando el compromiso de pago.
	
	
	public IngresarCompromisoPagoRequest(Integer numPoliza, String rutFilial, Integer codFactura, String usuarioIng, String fechaComp) {
		this.numPoliza = numPoliza;
		this.rutFilial = rutFilial;
		this.codFactura = codFactura;
		this.usuarioIng = usuarioIng;
		this.fechaComp = fechaComp;
			}
			
	public IngresarCompromisoPagoRequest(Integer numPoliza, String rutFilial, Integer codFactura, String fechaComp) {
		this(numPoliza, rutFilial, codFactura, UserInfo.getName(), fechaComp);
	}
	
	public IngresarCompromisoPagoRequest(Integer numPoliza, String rutFilial, Integer codFactura, Date fechaComp) {
				this(numPoliza, rutFilial, codFactura, fechaComp == null ? null : Datetime.newInstance(fechaComp, Time.newInstance(0, 0, 0, 0)).format('dd-MM-yyyy'));
	}
    
	public IngresarCompromisoPagoRequest(Factura__c factura, Date fechaCompromisoPago) {
		this(factura == null ||  factura.N_Poliza__c == null ? null : Integer.valueOf(factura.N_Poliza__c),
			factura == null || factura.Filial__r.Rut_Empresa__c == null ? null : (String.valueOf(factura.Filial__r.Rut_Empresa__c) + '-' + factura.Filial__r.DV_Empresa__c),
			//factura == null || factura.Numero_Factura__c == null ? null : Integer.valueOf(factura.Numero_Factura__c),
			factura == null || factura.Id_Factura__c == null ? null : Integer.valueOf(factura.Name),
			fechaCompromisoPago
		);        
	}

	public IngresarCompromisoPagoRequest() {
		this(null, null);
        	}
}