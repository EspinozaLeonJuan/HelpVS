public with sharing class CertificadoDeudaPDFController {
    public Filial__c    filial {get;set;}

    public Integer ultimoPeriodoPagado {get;set;} 
    public Integer montoPeriodoPagado {get;set;} 
    public Integer periodoSiguiente {get; set;} 
    public Integer montoPrima {get; set;} 
    // public String  estadoDeuda {get;set;} //Filial.Estado de pago
    public Integer diasVencidos {get; set;} 
    public Integer periodosVencidos {get;set;} 
    // public String estadoBeneficio {get;set;} //Filial.estado_beneficio
    // public Date fechaPosibleBloqueo {get;set;} //Filia.Proxima_fecha_bloqueo , puede ser vacia
    public Integer timeZone {get;set;}

    public CertificadoDeudaPDFController(ApexPages.StandardController controller) {

        this.timeZone = UserInfo.getTimeZone().getOffset(Datetime.now())/3600000;
		if (!Test.isRunningTest())
			controller.addFields(new String[] {'Numero_Poliza__c','Poliza__c','Poliza__r.Cuenta__r.Name','Poliza__r.Cuenta__r.Rut_con_dv__c','Rut_Filial__c','Name','Estado_Pago__c','Fecha_Bloqueo_de_Beneficios__c','Estado_Beneficio__c'});
		this.filial = (Filial__c)controller.getRecord();
        System.debug('filial:'+filial);
        // this.cuenta = [SELECT Name, Rut__c FROM Account WHERE id = :this.filial.Poliza__r.Cuenta__c];

        //ultimoPeriodoPagado : Mínimo factura.periodo_cobertura que tenga todas las facturas.estado = pagado 
        //Considerar el caso que puede no tener ningún período pagado
        //con un max y un having.
        List<Factura__c> facturasPoliza = 
            [SELECT Id, Periodo_Cobertura_Numerico__c
            FROM Factura__c 
            WHERE Filial__c =: this.filial.Id AND Estado_Pago__c = 'Cerrado' ORDER BY Periodo_Cobertura_Numerico__c DESC]; //averiguar limit 1
        System.debug('facturasPoliza:'+facturasPoliza);
        // System.assert(false, 'facturasPoliza:'+facturasPoliza);
        this.ultimoPeriodoPagado = facturasPoliza.isEmpty() ? null : Integer.valueOf(facturasPoliza[0].Periodo_Cobertura_Numerico__c);

        if  (this.ultimoPeriodoPagado != null){
            //montoPeriodoPagado : Suma del campo pago.monto de los pagos que tengan el campo pagos.periodo_cobertura = “Ultimo periodo pagado”
            AggregateResult[] groupedPagoResults = [SELECT SUM(Monto__c)sumMonto FROM Pago__c WHERE Periodo_Cobertura__c =: String.valueOf(this.ultimoPeriodoPagado) AND Filial__c =: this.filial.Id];
            this.montoPeriodoPagado = !groupedPagoResults.isEmpty() && groupedPagoResults[0].get('sumMonto') != null ? Integer.valueOf(groupedPagoResults[0].get('sumMonto')) : 0;
            System.debug('groupedPagoResults:'+groupedPagoResults);

            //periodoSiguiente : Mínimo factura.periodo_cobertura que sea mayor al “ultimo periodo pagado”, si no existe se muestra vacio
            List<Factura__c> facturasSiguientes = [SELECT Id,Periodo_Cobertura_Numerico__c FROM Factura__c WHERE Periodo_Cobertura_Numerico__c >: this.ultimoPeriodoPagado AND Filial__c =: this.filial.Id ORDER BY Periodo_Cobertura_Numerico__c ASC ];
            this.periodoSiguiente = !facturasSiguientes.isEmpty() && facturasSiguientes[0].Periodo_Cobertura_Numerico__c != null ? Integer.valueOf(facturasSiguientes[0].Periodo_Cobertura_Numerico__c) : null;
            System.debug('facturasSiguientes:'+facturasSiguientes);
        }
        else{
            List<Factura__c> allFacturasFilial = 
            [SELECT Id, Periodo_Cobertura_Numerico__c
            FROM Factura__c 
            WHERE Filial__c =: this.filial.Id AND Estado_Pago__c = 'Abierto' ORDER BY Periodo_Cobertura_Numerico__c ASC];
            this.periodoSiguiente = allFacturasFilial.isEmpty() ? null : Integer.valueOf(allFacturasFilial[0].Periodo_Cobertura_Numerico__c);
        }
        
        if  (this.periodoSiguiente != null){
            //montoPrima : Suma de factura.monto_bruto donde factura.periodo_cobertura = “periodo siguiente” menos Suma de pago.monto del pago.periodo_cobertura =  “periodo siguiente”
            AggregateResult[] groupedFacturaResults = [SELECT SUM(Monto_Bruto__c)sumMontoBruto FROM Factura__c WHERE Periodo_Cobertura_Numerico__c =: this.periodoSiguiente AND Filial__c =: this.filial.Id];
            AggregateResult[] groupedPagoSgteResults = [SELECT SUM(Monto__c)sumMonto FROM Pago__c WHERE Periodo_Cobertura__c =: String.valueOf(this.periodoSiguiente) AND Filial__c =: this.filial.Id];
            // System.assert(false,'groupedFacturaResults:'+groupedFacturaResults);
            // System.assert(false,'groupedPagoSgteResults:'+groupedPagoSgteResults);
            Integer sumMontoBruto = !groupedFacturaResults.isEmpty() && groupedFacturaResults[0].get('sumMontoBruto') != null ? Integer.valueOf(groupedFacturaResults[0].get('sumMontoBruto')) : 0;
            Integer sumMontoPago = !groupedPagoSgteResults.isEmpty() && groupedPagoSgteResults[0].get('sumMonto') != null  ? Integer.valueOf(groupedPagoSgteResults[0].get('sumMonto')): 0;
            this.montoPrima =  sumMontoBruto - sumMontoPago;
        }

        //diasVencidos : Días vencidos de la factura impaga mas antigua Factura.estado_pago = “Abierto” (La más antigua se utiliza usando el campo Factura.Fecha_Vencimiento_Plazo)
        List<Factura__c> facturasImpagas = [SELECT Id, Dias_vencido__c FROM Factura__c WHERE Estado_Pago__c = 'Abierto' AND Filial__c =: this.filial.Id ORDER BY Fecha_Vencimiento_Plazo__c ASC ];
        // System.assert(false,'facturasImpagas:'+facturasImpagas);
        this.diasVencidos = !facturasImpagas.isEmpty() && facturasImpagas[0].Dias_vencido__c != null ? Integer.valueOf(facturasImpagas[0].Dias_vencido__c) : null;
        System.debug('facturasImpagas:'+facturasImpagas);

        //periodosVencidos : Total de periodos que tienen Factura.Estado_deuda = “Vencida”
        AggregateResult[] groupedFacturasVencidasResults = [SELECT COUNT_DISTINCT(Periodo_Cobertura_Numerico__c)countPeriodos FROM Factura__c WHERE Estado_Deuda__c = 'Vencida' AND Filial__c =: this.filial.Id];
        this.periodosVencidos = !groupedFacturasVencidasResults.isEmpty() && groupedFacturasVencidasResults[0].get('countPeriodos') != null ? Integer.valueOf(groupedFacturasVencidasResults[0].get('countPeriodos')) : 0;
        System.debug('groupedFacturasVencidasResults:'+groupedFacturasVencidasResults);
    }
}