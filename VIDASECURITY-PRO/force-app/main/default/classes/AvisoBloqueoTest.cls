@IsTest
public with sharing class AvisoBloqueoTest {
	
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
	public static void testAvisoBloqueoControllerFilialesBloqueadas(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();//.load(new String[] {'Id','MyCustomField__c'});
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().load();
		filial.bloqueado().save();
		
		Test.startTest();
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(corredor.get());
		AvisoBloqueoController controller = new AvisoBloqueoController(standardController);

		Filial__c[] filiales = controller.getFiliales();
		Boolean hasCorredoresIdPorBloquear = controller.getNotificarAvisoBloqueo();
		Boolean hasFiliales = controller.getHasFiliales();
		Boolean filialesBloqueadas = controller.getFilialesBloqueadas();
		Test.stopTest();

		//Filial ya se encuentra bloqueada
		//System.assert(!hasCorredoresIdPorBloquear);
		//System.assert(hasFiliales);
	//	System.assert(filialesBloqueadas);
	}

	@IsTest
	public static void testAvisoBloqueoControllerNotFiliales(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();//.load(new String[] {'Id','MyCustomField__c'});
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().load();
		FilialFabricate filial2 = (FilialFabricate)Filial.fabricate().bloqueado().setPoliza(poliza).save();
		delete [select id from factura__c];
		Test.startTest();
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(corredor.get());
		AvisoBloqueoController controller = new AvisoBloqueoController(standardController);

		Filial__c[] filiales = controller.getFiliales();
		Boolean notificarAvisoBloqueo = controller.getNotificarAvisoBloqueo();
		Boolean hasFiliales = controller.getHasFiliales();
		Boolean filialesBloqueadas = controller.getFilialesBloqueadas();
		Test.stopTest();

		//No hay filiales que cumplan con los criterios de aviso de bloqueo.
//		System.assert(!notificarAvisoBloqueo);
	//	System.assert(hasFiliales);
		//System.assert(!filialesBloqueadas);
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
	public static void testAvisoBloqueoProcess(){
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
		AvisoBloqueoProcess process = new AvisoBloqueoProcess();
		SchedulableContext sc = null;

		Test.startTest();
		process.execute(sc);
		Test.stopTest();
		//AvisoBloqueoBatch.start();

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
    public static void prueba()
    {
        Test.startTest(); 
        AvisoBloqueoBatch batch = new AvisoBloqueoBatch();
        batch.execute(null, null);
		//Database.executeBatch(batch, 50);
        Test.stopTest();
    }
    
  /* @IsTest
    public static void notificarAvisosBloqueo() 
    {
        Test.startTest();        
        Id[] corredorIds = new Id[0];
		AvisoBloqueoService.notificarAvisosBloqueo(corredorIds);
		Test.stopTest();
    }*/
         
    @IsTest
	public static void formatDate(){
		Test.startTest();         
        Date fecha = Date.newInstance(1969, 12, 28);
        
		AvisoBloqueoService.formatDate(fecha);
		Test.stopTest();
    }
}