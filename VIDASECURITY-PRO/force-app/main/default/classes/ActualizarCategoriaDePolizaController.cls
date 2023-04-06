public with sharing class ActualizarCategoriaDePolizaController {
	
	public ActualizarCategoriaDePolizaController(ApexPages.StandardSetController controller) {

	}
	
	public System.PageReference actualizar() {
		ActualizarCategoriaDePolizaBatch.start(null);
		System.PageReference jobsPage = new System.PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
		jobsPage.getParameters().put('retURL', System.currentPageReference().getUrl());
		jobsPage.getParameters().put('setupid', 'AsyncApexJobs');
		return jobsPage;
	}
    }