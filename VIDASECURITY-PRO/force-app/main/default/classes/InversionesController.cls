public class InversionesController {

	public class Detalle {
		public WSCDS.DetalleConsolidado fila {get; set;}
		public List<Detalle> detalles {get; set;}
		public String tipo {get; set;}
		public String total {get; set;}
		
		public Detalle(WSCDS.DetalleConsolidado fila, String tipo){
			this.detalles = new List<Detalle>();
			this.fila = fila;
			this.tipo = tipo;
		}
		
		public Detalle(WSCDS.DetalleConsolidado fila, String tipo, String total){
			this(fila, tipo);
			this.total = total;
		}
		
		public void addDetalle(Detalle d) {
			this.detalles.add(d);
		}
	}

  public Account account {get; set;}
  private static Boolean anonymous = false;
  public String filtroCol1 {get;set;}
  public String filtroCol2 {get;set;}
  public String filtroCol3 {get;set;}
  public List<Detalle> resumenConsolidados {get; set;}

  public InversionesController(ApexPages.StandardController controller){
    if (!Test.isRunningTest() && !anonymous){
      controller.addFields(new String[] {'Name', 'Rut__c', 'Rut_contacto__pc'});
    }
    this.account = (Account)controller.getRecord();
    this.filtroCol1='';
    this.filtroCol2='';
    this.filtroCol3='';
    this.resumenConsolidados = new List<Detalle>();
    List<WSCDS.DetalleConsolidado> detalles = getDetallesConsolidados();
    if (detalles == null){
    	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No existen detalles consolidados para este rut.'));
    	return;
    }
    for (WSCDS.DetalleConsolidado d : detalles) {
    	if (d.Col_7 == 'T1' || d.Col_7 == 'S1'){
    		if (d.Col_7 == 'T1')	
    			this.resumenConsolidados.add(new Detalle(d, d.Col_7));
    		else
    			this.resumenConsolidados.add(new Detalle(d, d.Col_7, d.Col_6));
    		continue;
    	}
    	if (d.Col_7 == 'T2' || d.Col_7 == 'S2'){
    		Detalle lastTitle = this.resumenConsolidados[this.resumenConsolidados.size() - 1];
    		if (d.Col_7 == 'T2')
    			lastTitle.addDetalle(new Detalle(d, d.Col_7));
    		else
    			lastTitle.addDetalle(new Detalle(d, d.Col_7, d.Col_6));
    		continue;
    	}
    	if (d.Col_7 == 'T3'){
    		Detalle lastTitle = this.resumenConsolidados[this.resumenConsolidados.size() - 1];
    		Detalle lastSubtitle = lastTitle.detalles[lastTitle.detalles.size() - 1];
    		lastSubtitle.addDetalle(new Detalle(d, d.Col_7));
    		continue;
    	}
    	if (d.Col_7 == 'D1') {
    		Detalle lastTitle = this.resumenConsolidados[this.resumenConsolidados.size() - 1];
    		Detalle lastSubtitle = lastTitle.detalles[lastTitle.detalles.size() - 1];
    		Detalle lastSubSubTitle = lastSubtitle.detalles[lastSubtitle.detalles.size() - 1];
    		lastSubSubTitle.addDetalle(new Detalle(d, d.Col_7));
    		continue;
    	}
    }
  }

  public WSCDS.ArrayOfDetalleConsolidado arrayDetalleConsolidado(){
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
		String rut = (this.account.Rut_contacto__pc == null || this.account.Rut_contacto__pc == '') ? this.account.Rut__c : this.account.Rut_contacto__pc;
		return service.ResumenConsolidado(accessInfo, rut);
  }

  private List<WSCDS.DetalleConsolidado> getDetallesConsolidados() {
    return arrayDetalleConsolidado().DetalleConsolidado;
  }

}