@IsTest
public with sharing class AvisoBloqueoServiceTest2 {
	
	@TestSetup
	public static void init() {
		AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
		CorredorFabricate corredor = Corredor.fabricate();
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
		ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion('Aviso de Bloqueo').save();
		PolizaFabricate poliza = Poliza.fabricate().colectivos().activa().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().activo().setPoliza(poliza);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()+1).save();
	}

	@IsTest
	public static void testAvisoBloqueoController(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();//.load(new String[] {'Id','MyCustomField__c'});
		
		Test.startTest();
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(corredor.get());
		AvisoBloqueoController controller = new AvisoBloqueoController(standardController);

		Filial__c[] filiales = controller.getFiliales();
		Boolean hasCorredoresIdPorBloquear = controller.getNotificarAvisoBloqueo();
		Boolean hasFiliales = controller.getHasFiliales();
		System.PageReference viewResult = controller.sendEmail();

		Test.stopTest();

	/*	System.assert(filiales.size() > 0, 'No se encontraron filiales');
		System.assert(hasCorredoresIdPorBloquear);
		System.assert(hasFiliales);
		System.assert(viewResult != null);*/
	}

	@IsTest
	public static void testAvisoBloqueoService(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
		AvisoBloqueoService.getFilialesPorBloquear(corredor.getId());

		Id[] idCorredores = new Id[] { corredor.getId() };

		Test.startTest();
		List<Factura__c> facturasPorBloquear = AvisoBloqueoService.getFacturasPorBloquear(idCorredores);
		Test.stopTest();

		//System.assert(facturasPorBloquear.size() > 0);
	}

    @IsTest
	public static void criterioFacturasPorBloquear(){
		Test.startTest();        
		AvisoBloqueoService.criterioFacturasPorBloquear();
		Test.stopTest();
    }
    
    @IsTest
	public static void getFilialesPorBloquear(){
		Test.startTest();        
		AvisoBloqueoService.getFilialesPorBloquear();
		Test.stopTest();
    }
      
    @IsTest
	public static void formatDate(){
		Test.startTest();         
        Date fecha = Date.newInstance(1969, 12, 28);
        
		AvisoBloqueoService.formatDate(fecha);
		Test.stopTest();
    }
}