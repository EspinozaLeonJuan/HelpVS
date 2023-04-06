public with sharing class BitacoraCobranza extends Bitacora{
	
	private Factura__c factura {get; set;}
	private Filial__c filial {get; set;}
	private Corredor__c corredor {get; set;}
	
    public BitacoraCobranza(Bitacora.Evento evento, Corredor__c corredor) {
    	super(evento);
    	this.corredor = corredor;
    }
	
    public BitacoraCobranza(Bitacora.Evento evento, Factura__c factura) {
    	super(evento);
    	this.factura = factura;
    }
    

    public BitacoraCobranza(Bitacora.Evento evento, Filial__c filial) {
    	super(evento);
    	this.filial = filial;
    }
    
	public override Bitacora__c getSobject() {
		Bitacora__c bitacora = super.getSobject();
		bitacora.Factura__c = this.factura == null? null : this.factura.Id;
		bitacora.Corredor__c = this.corredor != null ? this.corredor.Id : (this.factura != null ? this.factura.Poliza__r.Corredor__c : (this.filial != null ? this.filial.Poliza__r.Corredor__c : null));
		bitacora.Filial__c = this.factura != null ? this.factura.Filial__c : (this.filial != null ? this.filial.Id : null);
		return bitacora;
	}
}