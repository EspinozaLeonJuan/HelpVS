@IsTest
public with sharing class BitacoraTest {
     @TestSetup
	public static void init() {
		AccountFabricate cuenta = Cuenta.fabricate().personal();
		ContactFabricate contacto = Contacto.fabricate();
		CorredorFabricate corredor = Corredor.fabricate();
		ListaDeDistribucionFabricate listaDistribucion = ListaDistribucion.fabricate().setCorredor(corredor).setContacto(contacto);
		PolizaFabricate poliza = Poliza.fabricate().colectivos().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().activo().setPoliza(poliza);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()+1).save();
	}
	
    @IsTest
	public static void testBitacora(){
		//addError setGlosa getsObject Bitacora(evento)
        FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().load(new String[]{ 'Poliza__r.Corredor__c', 'Filial__c'});
        BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Aviso_de_Bloqueo, (Factura__c)factura.get());
        Test.startTest();
        bitacora.addError('glosa');
        bitacora.getSobject();
        Test.stopTest();

        System.assertEquals('glosa', bitacora.getSObject().Glosa__c);
        System.assertEquals('Error', bitacora.getSObject().Estado__c);
	}

}