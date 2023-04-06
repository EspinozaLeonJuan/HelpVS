public  class DetalleContratoController {
	
  public Poliza__c poliza {get;set;}
  String polizaId = ApexPages.currentPage().getParameters().get('id');

  public DetalleContratoController(ApexPages.StandardController controller){
  	if (!Test.isRunningTest())
    	controller.addFields(new String[]{'Contratante__c', 'Intermediario_Poliza__c', 'Asegurado_Titular__c'});
    poliza = (Poliza__c)controller.getRecord();
  }

  public List<Contact> getContacto(){
    List<Contact> contactos= new List<Contact>();
    Contact[] contratantes = [SELECT Id, Rut__c, Name FROM Contact WHERE Id =:poliza.Contratante__c LIMIT 1];
    if (contratantes.size() == 0){
    	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING, 'No existe un contratante asociado en la poliza.'));
    }else{
    	Contact contratante = contratantes.get(0);
    	contratante.Rol__c='Contratante';
    	contactos.add(contratante);
    }
    
    Contact[] asegurados = [SELECT Id, Rut__c, Name FROM Contact WHERE Id =:poliza.Asegurado_Titular__c LIMIT 1];
    if (asegurados.size() == 0){
    	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING, 'No existe un asegurado asociado en la poliza.'));
    }else{
    	Contact asegurado = asegurados.get(0);
    	asegurado.Rol__c='Asegurado Titular';
    	contactos.add(asegurado);
    }
    
    Contact[] intermediarios = [SELECT Id, Rut__c, Name FROM Contact WHERE Id =:poliza.Intermediario_Poliza__c LIMIT 1];
    if (intermediarios.size() == 0){
    	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.WARNING, 'No existe un intermediario asociado en la poliza.'));
    }else{
    	Contact intermediario = intermediarios.get(0);
    	intermediario.Rol__c='Intermediario';
    	contactos.add(intermediario);    
    }
    
    return contactos;
  }

  public List<Beneficiario__c> getListaBenef(){
    List<Beneficiario__c> contactos= new List<Beneficiario__c>();
    WSCDS.ArrayOfDetalleBeneficiario  detalle = arrayDetalleBenef(); 
    List<WSCDS.DetalleBeneficiario> lista =detalle.DetalleBeneficiario;
    if(lista == null || lista.size() == 0){
      Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay beneficiarios que mostrar.'));
    }else{
      for(Integer x=0; x < detalle.DetalleBeneficiario.size();x++){
      	Beneficiario__c benef= new Beneficiario__c();
        benef.Name = lista[x].Bene_Nombre;
        benef.Rut__c = String.valueOf(lista[x].Bene_Rut.longValue());
        benef.Tipo__c = lista[x].Bene_Tipo;
        benef.Porcentaje__c = lista[x].Bene_Porcentaje;
        contactos.add(benef);
      }
    }
    return contactos;
  }

  public List<Dependiente__c> getListaDepend(){
    List<Dependiente__c> contactos= [SELECT Name, Rut__c, Parentesco__c FROM Dependiente__c where Poliza__c=:polizaId];
    WSCDS.ArrayOfDetalleDependiente  detalle = arrayDetalleDepend(); 
    List<WSCDS.DetalleDependiente> lista = detalle.DetalleDependiente;
    if(lista == null || lista.size() == 0){
    	Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'No hay dependientes que mostrar.'));
    }else{
      for(Integer x=0;x<detalle.DetalleDependiente.size();x++){
      	Dependiente__c depend = new Dependiente__c();
        depend.Name = lista[x].Aseg_Nombre;
        depend.Rut__c = String.valueOf(lista[x].Aseg_Rut.longValue());
        depend.Parentesco__c = lista[x].Aseg_Parentesco;
        contactos.add(depend);    
      }
      
    }
    return contactos; 
  }
  
  public WSCDS.ArrayOfDetalleBeneficiario arrayDetalleBenef(){
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
    return service.BeneficiariosIndividuales(accessInfo, nPoliza);
  }

  public WSCDS.ArrayOfDetalleDependiente arrayDetalleDepend(){
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
    return service.DependienteIndividual(accessInfo, nPoliza);
  }
}