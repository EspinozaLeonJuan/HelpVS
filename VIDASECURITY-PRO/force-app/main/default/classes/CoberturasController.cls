public class CoberturasController {
  
 	public Poliza__c poliza {get;set;}
 	public static Boolean anonymous = false;
 
 	public CoberturasController(ApexPages.StandardController controller){
	  if (!Test.isRunningTest() && !anonymous)
	    controller.addFields(new String[] {'Name', 'N_Poliza__c'});
	  this.poliza = (Poliza__c)controller.getRecord();
	}

	public List<Cobertura__c> getListaCoberturas(){
	  List<WSCDS.DetalleCobertura> detalle = arrayDetalleCobertura().DetalleCobertura;
	  List<Cobertura__c> coberturas= new List<Cobertura__c>();
	  Double totalCapitalAsegurado=0;
	  Double totalPrimaNeta=0;
	  Double totalIVA=0;
	  Double totalPrimaMinima=0;
	  if(detalle == null || detalle.size() == 0){
	  	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay coberturas que mostrar.'));
	  }else{
	    for(Integer x=0; x < detalle.size(); x++){
	    	Cobertura__c cobertura = new Cobertura__c();
	      cobertura.Name = String.valueOf(detalle[x].CodCob);
	      cobertura.Capital_Asegurado__c = detalle[x].Cap_Aseg;
	      System.debug(cobertura.Capital_Asegurado__c);
	      cobertura.Prima_Neta__c = detalle[x].Pri_Neta_Spp;
	      cobertura.IVA__c = detalle[x].Iva;
	      cobertura.Prima_Minima__c = detalle[x].Pri_Minima;
	      coberturas.add(cobertura);
	    }
	    for(Integer x=0; x < detalle.size();x++){
	      totalCapitalAsegurado=totalCapitalAsegurado+detalle[x].Cap_Aseg;
	      totalPrimaNeta=totalPrimaNeta+detalle[x].Pri_Neta_Spp;
	      totalIVA =totalIVA+detalle[x].Iva;
	      totalPrimaMinima=totalPrimaMinima+detalle[x].Pri_Minima;
	    }
	    Cobertura__c total = new Cobertura__c();
	    total.Name= 'Total';
	    total.Capital_Asegurado__c= totalCapitalAsegurado;
	    total.Prima_Neta__c= totalPrimaNeta;
	    total.IVA__c= totalIVA;
	    total.Prima_Minima__c=totalPrimaMinima;
	    coberturas.add(total);
	  }
	  return coberturas;
	}
	
	public WSCDS.ArrayOfDetalleCobertura arrayDetalleCobertura(){
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

    Double nPoliza=(Double)poliza.N_Poliza__c;
    return service.CoberturaPolizaIndividual(accessInfo, nPoliza);
  }
  
  /* public List<WSCDS.DetalleCobertura> getListaCobertura() {

    WSCDS.ArrayOfDetalleCobertura detalle = arrayDetalleCobertura(); 
    return detalle.DetalleCobertura;
  }*/

}