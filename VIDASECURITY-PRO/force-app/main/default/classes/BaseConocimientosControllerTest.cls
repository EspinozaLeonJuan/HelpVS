@isTest
private class BaseConocimientosControllerTest {

	static {
		CategoriaSolucionFabricate categoria = (CategoriaSolucionFabricate)Fabricate.categoriaSolucion().save();
		SolucionFabricate solucion1 = (SolucionFabricate)Fabricate.solucion().setCategoria(categoria).save();
		SolucionFabricate solucion2 = (SolucionFabricate)Fabricate.solucion().setCategoria(categoria).save();
	}

	@isTest static void baseConocimientosControllerTest() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			BaseConocimientosController.Pagination resultados = new BaseConocimientosController.Pagination();
			List<String> estados = BaseConocimientosController.getEstadosSolucion();
			resultados = BaseConocimientosController.getSolutions(busqueda, false, false, 0, 10);
			System.assertNotEquals(0, resultados.solutions.size());
			System.assertEquals(2, resultados.total);

			//eliminamos la solucion
			Solution solucionEliminar = resultados.solutions[0];
			BaseConocimientosController.deleteSolution(solucionEliminar);

			//realizamos busqueda y no deberia haber coincidencia
			resultados = BaseConocimientosController.getSolutions(busqueda, false, false, 0, 10);
			System.assertEquals(1, resultados.solutions.size());
			System.assertEquals(1, resultados.total);
		Test.stopTest();

	}

	@isTest static void guardarSolucion() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			BaseConocimientosController.Pagination resultados = new BaseConocimientosController.Pagination();
			resultados = BaseConocimientosController.getSolutions(busqueda, false, false, 0, 10);
			System.assertNotEquals(0, resultados.solutions.size());
			System.assertEquals(2, resultados.total);
			Solution sol = [Select Id, SolutionName From Solution Limit 1];
			BaseConocimientosController.SolutionResult resultado = BaseConocimientosController.saveSolution(sol);
			System.assertEquals(false, resultado.hasErrors);
			resultados = BaseConocimientosController.getSolutions(busqueda, false, false, 0, 10);
			System.assertNotEquals(0, resultados.solutions.size());
			System.assertEquals(2, resultados.total);
        	busqueda.add('Test');
        	BaseConocimientosController.applyQuotes(busqueda);
        	BaseConocimientosController.buildFilter('Categoria__c', busqueda);
		Test.stopTest();

	}

	@isTest static void getCategorias() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			List<BaseConocimientosController.Item> resultados = new List<BaseConocimientosController.Item>();
			resultados = BaseConocimientosController.getCategorias();
			System.assertNotEquals(0, resultados.size());
			System.assertEquals(1, resultados.size());
		Test.stopTest();
	}

	@isTest static void getSolutionsByCategory() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			BaseConocimientosController.Pagination resultados = new BaseConocimientosController.Pagination();
			Categoria_Solucion__c categoria = [Select Id From Categoria_Solucion__c Limit 1];
			resultados = BaseConocimientosController.getSolutionsByCategory(categoria.Id, false, false, 0, 10);
			System.assertNotEquals(0, resultados.solutions.size());
			System.assertEquals(2, resultados.total);
		Test.stopTest();
	}

	@isTest static void actualizarCategoria() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			Categoria_Solucion__c categoria = [Select Id, Categoria_Solucion__c From Categoria_Solucion__c Limit 1];
			BaseConocimientosController.saveCategory(categoria.Id, categoria.Categoria_Solucion__c, 'Otro Nombre');
			Categoria_Solucion__c categoriaResult = [Select Id, Name From Categoria_Solucion__c Limit 1];
			System.assertNotEquals(null, categoriaResult);
			System.assertEquals('Otro Nombre', categoriaResult.Name);
		Test.stopTest();
	}


	@isTest static void eliminarCategoria() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			Categoria_Solucion__c categoria = [Select Id, Categoria_Solucion__c From Categoria_Solucion__c Limit 1];
			BaseConocimientosController.deleteCategory(categoria.Id);
			List<Categoria_Solucion__c> categorias = [Select Id, Name From Categoria_Solucion__c];
			System.assertNotEquals(null, categorias);
			System.assertEquals(0, categorias.size());
		Test.stopTest();
	}


	@isTest static void getSolutionByID() {
		List<String> busqueda = new List<String>();
		Test.startTest();
			Solution sol = [Select Id, SolutionName From Solution Limit 1];
			Solution solResult = BaseConocimientosController.getSolutionByID(sol.Id);
			System.assertNotEquals(null, solResult);
		Test.stopTest();
	}


}