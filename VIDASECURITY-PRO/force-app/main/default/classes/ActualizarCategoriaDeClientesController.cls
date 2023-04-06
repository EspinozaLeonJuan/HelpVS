public with sharing class ActualizarCategoriaDeClientesController {
	
	public ActualizarCategoriaDeClientesController(ApexPages.StandardSetController controller) {

	}
	
	public System.PageReference actualizar() {
		ActualizaCategoriasDeClientesBatch.start(null);
		System.PageReference jobsPage = new System.PageReference('/apexpages/setup/listAsyncApexJobs.apexp');
		jobsPage.getParameters().put('retURL', System.currentPageReference().getUrl());
		jobsPage.getParameters().put('setupid', 'AsyncApexJobs');
		return jobsPage;
	}
    }