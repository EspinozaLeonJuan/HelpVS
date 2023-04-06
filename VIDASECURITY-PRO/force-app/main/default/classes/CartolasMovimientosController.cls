public  class CartolasMovimientosController {

  public Poliza__c poliza {get;set;}
  public static Boolean anonymous = false;
  public String[] consulta {get;set;}
  public String meses {get;set;}
  public String anios {get;set;}
  public String mesesH {get;set;}
  public String aniosH {get;set;}
  public String movimiento{get;set;}

  public CartolasMovimientosController(ApexPages.StandardController controller){
    if (!Test.isRunningTest() && !anonymous)
      controller.addFields(new String[] {'Name', 'N_Poliza__c'});
    this.poliza = (Poliza__c)controller.getRecord();
    this.movimiento='ahoraNo';
  }

  public PageReference muestraResultado() {
    this.movimiento = 'ahoraSi';
    return null;
  }

  public List<SelectOption> getMonths() {
    List<SelectOption> opcionMes = new List<SelectOption>();
    opcionMes.add(new SelectOption('01','Enero'));
    opcionMes.add(new SelectOption('02','Febrero'));
    opcionMes.add(new SelectOption('03','Marzo'));
    opcionMes.add(new SelectOption('04','Abril'));
    opcionMes.add(new SelectOption('05','Mayo'));
    opcionMes.add(new SelectOption('06','Junio'));
    opcionMes.add(new SelectOption('07','Julio'));
    opcionMes.add(new SelectOption('08','Agosto'));
    opcionMes.add(new SelectOption('09','Septiembre'));
    opcionMes.add(new SelectOption('10','Octubre'));
    opcionMes.add(new SelectOption('11','Noviembre'));
    opcionMes.add(new SelectOption('12','Diciembre'));
    return opcionMes;
  }

  public List<SelectOption> getYears() {
    List<SelectOption> opcionAnio = new List<SelectOption>();
    opcionAnio.add(new SelectOption('2010','2010'));
    opcionAnio.add(new SelectOption('2011','2011'));
    opcionAnio.add(new SelectOption('2012','2012'));
    opcionAnio.add(new SelectOption('2013','2013'));
    opcionAnio.add(new SelectOption('2014','2014'));
    opcionAnio.add(new SelectOption('2015','2015'));
    opcionAnio.add(new SelectOption('2016','2016'));
    return opcionAnio;
  }

  public List<SelectOption> getTipoConsulta(){
   List<SelectOption> opcionConsulta = new List<SelectOption>();
   opcionConsulta.add(new SelectOption('movimientos','Movimientos'));
   opcionConsulta.add(new SelectOption('cartolas','Cartolas'));
   return opcionConsulta;
   
 }

 	public List<Movimiento__c> getMovimientos(){
 		List<Movimiento__c> movimientos= new List<Movimiento__c>();
 		try {
		  List<WSCDS.DetalleMovimiento> detalle = arrayOfDetalleMovimiento().DetalleMovimiento;
		  if(detalle == null || detalle.size() == 0){
		  	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay movimientos que mostrar.'));
		  }else{
		    for(Integer x=0; x < detalle.size(); x++){
		      Movimiento__c movimiento = new Movimiento__c();
		      movimiento.Name = detalle[x].Pol_Inumer;
		      movimiento.Ramo__c=detalle[x].Pla_Cramo;
		      movimiento.Plan__c = detalle[x].Pla_Ccodg;
		      movimientos.add(movimiento);
		    }
		  }
 		}catch (Exception e) {
 			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.FATAL, e.getMessage()));
 		}
 		return movimientos;
	}

	public WSCDS.ArrayOfDetalleMovimiento arrayOfDetalleMovimiento(){
		WSCDS.IWsCdsSoap service = WSCDS.getInstance();
		service.setTimeout(WSCDS.TIMEOUT);
		service.setEndpoint(WSCDS.ENDPOINT);
		WSCDS.AccessInfo accessInfo= new WSCDS.AccessInfo();
		
		WSCDS.AppInfo appInfo = WSCDS.getAppInfoInstance();
		WSCDS.UserInfo userInfo = WSCDS.getUserInfoInstance();
		WSCDS.WebInfo webInfo = WSCDS.getWebInfoInstance();
		     
		accessInfo.AppInfo = appInfo;
		accessInfo.UserInfo = userInfo;
		accessInfo.WebInfo = webInfo;
		String fechaDesde = this.anios+this.meses;
		String fechaHasta = this.aniosH+this.mesesH;
		Double nPoliza=(Double)poliza.N_Poliza__c;
		
		System.debug('Fecha Desde: ' + fechaDesde);
		System.debug('Fecha Hasta: ' + fechaHasta);
		System.debug('Fecha nPoliza: ' + nPoliza);
		
		return service.ObtieneMovimientos(accessInfo, nPoliza, fechaDesde, fechaHasta);
  }

  public List<WSCDS.DetalleMovimiento> getListaPeriodo() {
    WSCDS.ArrayOfDetalleMovimiento detalle = arrayOfDetalleMovimiento(); 
    return detalle.DetalleMovimiento;
  }

}