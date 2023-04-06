@IsTest
public with sharing class RecordatorioBloqueoTest {
	
	@TestSetup
	public static void init() {
				AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
		CorredorFabricate corredor = Corredor.fabricate();
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
		ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion('Recordatorio de Bloqueo').save();
		PolizaFabricate poliza = Poliza.fabricate().activa().colectivos().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().bloqueado().setPoliza(poliza).setFechaBloqueoDeBeneficio(Date.today()-1);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoPagado().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()-1).save();
	}

	@IsTest
	public static void testRecordatorioBloqueoService(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
        Id[] idCorredores = new Id[] { corredor.getId() };
		List<Filial__c> filialesBloqueadas = RecordatorioBloqueoService.getFilialesBloqueadas();

		Test.startTest();
		RecordatorioBloqueoService.notificarRecordatorioBloqueo(idCorredores);
		Test.stopTest();

		System.assert(filialesBloqueadas.size() > 0);
	}

	@IsTest
	public static void testRecordatorioRecordatorioBloqueoProcess(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
		RecordatorioBloqueoProcess process = new RecordatorioBloqueoProcess();
		SchedulableContext sc = null;

		Test.startTest();
		process.execute(sc);
		Test.stopTest();
		//AvisoBloqueoBatch.start();

	}

}