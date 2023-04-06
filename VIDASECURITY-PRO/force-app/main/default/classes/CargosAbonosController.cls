public class CargosAbonosController {
	public Poliza__c poliza {get;set;}
	public static Boolean anonymous = false;
	public String meses {get;set;}
	public String anios {get;set;}
	public String mesesH {get;set;}
	public String aniosH {get;set;}
	public String consulta{get;set;}
	public String panelResultado{get;set;}
 
	public CargosAbonosController(ApexPages.StandardController controller){
	  if (!Test.isRunningTest() && !anonymous)
	    controller.addFields(new String[] {'Name', 'N_Poliza__c'});
	  this.poliza = (Poliza__c)controller.getRecord();
	  this.PanelResultado = '';
	}
	
	public PageReference mostrarResPeriodo() {
	  this.panelResultado = 'panelPeriodo';
	  return null;
	}

	public Pagereference mostrarResMeses(){
	  this.panelResultado = 'panelMeses';
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
		opcionConsulta.add(new SelectOption('mes','Meses'));
		opcionConsulta.add(new SelectOption('periodo','Periodo'));
		return opcionConsulta;
	} 
	
	public List<CargoAbono__c> getCargoAbonoPeriodo(){
	  List<WSCDS.DetalleCargoAbono> detalle = arrayCargoAbonoPeriodo().DetalleCargoAbono; 
	  List<CargoAbono__c> cargosAbonos = new List<CargoAbono__c>();
	  if(detalle == null || detalle.size() == 0){
	  	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay cargos que mostrar.'));
	  }else{
	    for(Integer x=0; x < detalle.size();x++){
	    	CargoAbono__c cargoAbono = new CargoAbono__c();
	      cargoAbono.Tipo__c = detalle[x].Tip_Movimiento;
	      cargoAbono.Exceso__c = detalle[x].Exceso_Unico;
	      cargoAbono.Fecha_Movimiento__c = WSCDS.stringToDate(detalle[x].Fec_Movimiento);
	      cargosAbonos.add(cargoAbono);
	    }
	  }
	  return cargosAbonos;
	} 

	public List<Movimiento__c> getCargoAbonoMensuales(){
	  List<WSCDS.DetalleMovimiento> detalle = arrayCargoAbonoMensuales().DetalleMovimiento; 
	  List<Movimiento__c> cargosAbonos = new List<Movimiento__c>();
	  if(detalle == null || detalle.size() == 0){
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay cargos que mostrar.'));	  		
	  }else{
	    for(Integer x=0; x < detalle.size(); x++){
	    	Movimiento__c cargoAbono = new Movimiento__c();
	    	cargoAbono.Name = detalle[x].Pol_Inumer;
	    	cargoAbono.Poliza__c = this.poliza.Id;
		    cargoAbono.Ramo__c=detalle[x].Pla_Cramo;
		    cargoAbono.Plan__c = detalle[x].Pla_Ccodg;
		    
		    cargoAbono.Fecha__c = WSCDS.stringToDate(detalle[x].Cga_Ifceca);
		    cargoAbono.Glosa__c = detalle[x].Ele_Vglosa;
		    cargoAbono.Rm_Tomo__c = detalle[x].Cga_Rmtomo;

	      cargosAbonos.add(cargoAbono);
	    }
	  }
	  return cargosAbonos;
	}
	
	// <DetalleCargoAbono> CargoAbonoPoliza(AccessInfo informacion, double poliza, string periodo);    
	public WSCDS.ArrayOfDetalleCargoAbono arrayCargoAbonoPeriodo(){
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
		
		String fecha = this.anios + this.meses; 
		Double nPoliza = (Double)poliza.N_Poliza__c;
		
		System.debug('Fecha: ' + fecha);
		if (!WSCDS.isValidPeriod(fecha)) {
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay cargos que mostrar.'));
			return new WSCDS.ArrayOfDetalleCargoAbono();
		}
		
		return service.CargoAbonoPoliza(accessInfo, nPoliza, fecha);
  }

  public WSCDS.ArrayOfDetalleMovimiento arrayCargoAbonoMensuales(){
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
			String fechaDesde = this.anios + this.meses;
			String fechaHasta = this.aniosH + this.mesesH;
			Double nPoliza=(Double)poliza.N_Poliza__c;
			
			System.debug('Fecha Desde: ' + fechaDesde);
			System.debug('Fecha Hasta: ' + fechaHasta);
			System.debug('Fecha nPoliza: ' + nPoliza);
			
			return service.ObtieneMovimientos(accessInfo, nPoliza, fechaDesde, fechaHasta);
  }
  
  public List<WSCDS.DetalleMovimiento> getListaMensuales() {
    WSCDS.ArrayOfDetalleMovimiento detalle = arrayCargoAbonoMensuales(); 
    return detalle.DetalleMovimiento;
  }

}