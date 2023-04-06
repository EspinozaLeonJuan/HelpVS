@IsTest
public class CertificadoDeudaPDFTest {
    @IsTest
	public static void testCertificado(){
        AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().personal().save();
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().save();
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().save();
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().colectivos().setCorredor(corredor).setCuenta(cuenta).save();
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().activo().setPoliza(poliza).save();
		
        
        FacturaFabricate factura201901 = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoPagado().setPeriodoCobertura('201901').save();
        FacturaFabricate factura201902 = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoPagado().setPeriodoCobertura('201902').set('Monto_Bruto__c',50).save();
        FacturaFabricate factura201903V = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setPeriodoCobertura('201903').set('Monto_Bruto__c',100).set('Estado_Deuda__c','Vencida').set('Dias_vencido__c',10).save();
        FacturaFabricate factura201904 = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setPeriodoCobertura('201904').set('Monto_Bruto__c',100).set('Dias_vencido__c',10).save();
        
        PagoFabricate pago201901 = (PagoFabricate)Pago.fabricate().setFilial(filial).setPoliza(poliza).setMonto(10).setPeriodoCobertura('201901').save();
        PagoFabricate pago201902 = (PagoFabricate)Pago.fabricate().setFilial(filial).setPoliza(poliza).setMonto(20).setPeriodoCobertura('201902').save();
        PagoFabricate pago201902_1 = (PagoFabricate)Pago.fabricate().setFilial(filial).setPoliza(poliza).setMonto(20).setPeriodoCobertura('201902').save();
        PagoFabricate pago201903 = (PagoFabricate)Pago.fabricate().setFilial(filial).setPoliza(poliza).setMonto(30).setPeriodoCobertura('201903').save();
        Test.startTest();
        Apexpages.StandardController stdController = new Apexpages.StandardController((Filial__c)filial.get());
        CertificadoDeudaPDFController controller = new CertificadoDeudaPDFController(stdController);
        Test.stopTest();

        System.assert(controller.filial != null,'No se encontró filial');

        System.assertEquals(201902, controller.ultimoPeriodoPagado);
        System.assertEquals(10, controller.diasVencidos);
        System.assertEquals(40, controller.montoPeriodoPagado);
        System.assertEquals(201903, controller.periodoSiguiente);
        System.assertEquals(70, controller.montoPrima);
        System.assertEquals(1, controller.periodosVencidos);
        
    }
}