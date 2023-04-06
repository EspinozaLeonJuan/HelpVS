public without sharing class BaseConocimientosController {

	private static integer pagesize;
	private static integer offset;
	private static Map<String, Item> categorias;
	private static Set<String> setItemsIds;
	public class Item {  
	   	@AuraEnabled public String parentId { get; set; }
	   	@AuraEnabled public String identificador { get; set; }
	   	@AuraEnabled public string label { get; set; }    
	   	@AuraEnabled public string name { get; set; } 
	   	@AuraEnabled public Boolean expanded { get; set; }  
	   	@AuraEnabled public List<Item> items { get; set; } 
	   	public Item( String identificador, String name, String label, Boolean expanded, String parentId) {  
		    this.label = label;  
		    this.name = name;  
		    this.expanded = expanded;  
		    this.identificador = identificador;
		    this.parentId = parentId;
	   }  
 	}  

	public class SolutionResult {
		@AuraEnabled public Solution solucion {set; get;}
		@AuraEnabled public Boolean hasErrors {set; get;}
		@AuraEnabled String[] errorMessages {set; get;}
		public SolutionResult() {
			this.hasErrors = false;
		}
	}

	public class CategoryResult {
		@AuraEnabled public Boolean hasErrors {set; get;}
		@AuraEnabled String[] errorMessages {set; get;}
		public CategoryResult() {
			this.hasErrors = false;
		}
	}

	public class Pagination {
		@AuraEnabled public List<Solution> solutions;
		@AuraEnabled public integer offst;
		@AuraEnabled public integer total;
		@AuraEnabled public boolean hasprev;
		@AuraEnabled public boolean hasnext;
		@AuraEnabled public boolean accesible;
		@AuraEnabled public boolean editable;
		@AuraEnabled public boolean creatable;
		@AuraEnabled public boolean deletable;
		@AuraEnabled public boolean categoryAccesible;
		@AuraEnabled public boolean categoryEditable;
		@AuraEnabled public boolean categoryCreatable;
		@AuraEnabled public boolean categoryDeletable;
		@AuraEnabled public Map<String, Boolean> mapFieldsAccesibility;
		@AuraEnabled public Map<String, Boolean> mapFieldsUpdateable;

		public Pagination() {}
	}

	@AuraEnabled
	public static Solution getSolutionByID(String id){
		Solution solucion = [Select Id, Categoria_Solucion__c, Categoria_Solucion__r.Name, Status, IsPublished, IsPublishedInPublicKb, SolutionName, SolutionNote, SolutionNumber from Solution Where IsPublished = true and Id = :id Limit 1 ];
		return solucion;
	}

	@AuraEnabled
	public static Pagination getSolutions(List<String> busqueda, boolean next, boolean prev, decimal off, decimal pag) {
		offset = (integer)off;
		pagesize = (integer)pag;
		List<Solution> li = new List<Solution>();
		integer listlength = 0;

		if (busqueda.isEmpty() || (busqueda.size()==1 && busqueda[0].length()<2)) {
			listlength = [Select count() from Solution Where IsPublished = true];
		} else {
			List<Solution> resultados = getListadoSoluciones(busqueda,  pagesize, offset);
			listlength = resultados.size();
		}


		if (next == false && prev == false) {

			li = getListadoSoluciones(busqueda, pagesize, offset);

		} else if (next == true && (offset + pagesize) <= listlength) {

			offset = offset + pagesize;
			li = getListadoSoluciones(busqueda, pagesize, offset);

		} else if (prev == true && offset > 0) {

			offset = offset - pagesize;
			li = getListadoSoluciones(busqueda, pagesize, offset);

		}

		Map<String, Boolean> mapFieldsAccesibility = new Map<String, Boolean>();
		Map<String, Boolean> mapFieldsUpdateable = new Map<String, Boolean>();

		String [] expenseAccessFields = new String [] { 'Id', 'Categoria_Solucion__c', 'Status', 'IsPublished', 'IsPublishedInPublicKb', 'SolutionName', 'SolutionNote', 'SolutionNumber' };
	    Map<String,Schema.SObjectField> m = Schema.SObjectType.Solution.fields.getMap();
	    for (String fieldToCheck : expenseAccessFields) {
	       	mapFieldsAccesibility.put(fieldToCheck, m.get(fieldToCheck).getDescribe().isAccessible());
	       	mapFieldsUpdateable.put(fieldToCheck, m.get(fieldToCheck).getDescribe().isUpdateable());
	    }
	    
		Pagination pg = new Pagination();
		pg.solutions = li;
		pg.offst = offset;
		pg.hasprev = hasprev(offset);
		pg.hasnext = hasnxt(offset, listlength, pagesize);
		pg.total = listlength;
		pg.accesible = Schema.sObjectType.Solution.isAccessible();
		pg.creatable = Schema.sObjectType.Solution.isCreateable();
		pg.deletable = Schema.sObjectType.Solution.isDeletable();
		pg.editable = Schema.sObjectType.Solution.isUpdateable();
		pg.categoryAccesible = Schema.sObjectType.Categoria_Solucion__c.isAccessible();
		pg.categoryCreatable = Schema.sObjectType.Categoria_Solucion__c.isCreateable();
		pg.categoryDeletable = Schema.sObjectType.Categoria_Solucion__c.isDeletable();
		pg.categoryEditable = Schema.sObjectType.Categoria_Solucion__c.isUpdateable();
		pg.mapFieldsAccesibility = mapFieldsAccesibility;
		pg.mapFieldsUpdateable =  mapFieldsUpdateable;
		return pg;
	}

	@AuraEnabled
	public static Pagination getSolutionsByCategory(String categoriaId, boolean next, boolean prev, decimal off, decimal pag) {
		offset = (integer)off;
		pagesize = (integer)pag;
		List<Solution> li = new List<Solution>();
		integer listlength = 0;
		List<Item> children = new List<Item>();
		Set<String> idsCategories = new Set<String>();
		Item itemSeleccionado = findItem(categoriaId, getCategorias());

		idsCategories.add(categoriaId);
		if(itemSeleccionado!=null)
			children = itemSeleccionado.items;

		idsCategories = childCategoriesByParentId(children, categoriaId, idsCategories);

		List<Solution> resultados = getListadoSolucionesByCategoria(idsCategories,  pagesize, offset);
		if(!idsCategories.isEmpty())
			listlength = [Select count() from Solution Where Categoria_Solucion__c IN :idsCategories AND IsPublished = true];
		else 
			listlength = resultados.size();
		
		if (next == false && prev == false) {

			li = getListadoSolucionesByCategoria(idsCategories,  pagesize, offset);

		} else if (next == true && (offset + pagesize) <= listlength) {

			offset = offset + pagesize;
			li = getListadoSolucionesByCategoria(idsCategories,  pagesize, offset);

		} else if (prev == true && offset > 0) {

			offset = offset - pagesize;
			li = getListadoSolucionesByCategoria(idsCategories,  pagesize, offset);

		}

		Pagination pg = new Pagination();
		pg.solutions = li;
		pg.offst = offset;
		pg.hasprev = hasprev(offset);
		pg.hasnext = hasnxt(offset, listlength, pagesize);
		pg.total = listlength;
		pg.accesible = Schema.sObjectType.Solution.isAccessible();
		pg.creatable = Schema.sObjectType.Solution.isCreateable();
		pg.deletable = Schema.sObjectType.Solution.isDeletable();
		pg.editable = Schema.sObjectType.Solution.isUpdateable();
		pg.categoryAccesible = Schema.sObjectType.Categoria_Solucion__c.isAccessible();
		pg.categoryCreatable = Schema.sObjectType.Categoria_Solucion__c.isCreateable();
		pg.categoryDeletable = Schema.sObjectType.Categoria_Solucion__c.isDeletable();
		pg.categoryEditable = Schema.sObjectType.Categoria_Solucion__c.isUpdateable();
		return pg;
	}

	@AuraEnabled
	public static List<String> getEstadosSolucion(){
		Set<String> opciones = ReflectionUtils.getPicklistValues(Solution.Status);
		List<String> estados = new List<String>();
		for (String opcion : opciones)
			estados.add(opcion);
		return estados;
	}


	private static List<Solution> getListadoSoluciones(List<String> busqueda, integer pagesize, integer offset) { //WHERE IsPublishedInPublicKb = true
		List<Solution> soluciones = null;
		if (busqueda.isEmpty() || (busqueda.size()==1 && busqueda[0].length()<2 ) )
			soluciones = [Select Id, Categoria_Solucion__c, Categoria_Solucion__r.Name, Status, IsPublished, IsPublishedInPublicKb, SolutionName, SolutionNote, SolutionNumber from Solution Where IsPublished = true  Order By SolutionNumber Desc LIMIT :pagesize OFFSET :offset ];
		else {
			//String queryString =  'FIND '+ buildFilterSOSL(busqueda)+'  IN NAME FIELDS RETURNING Solution(Id, SolutionName, SolutionNote, SolutionNumber, Categoria_Solucion__c, Categoria_Solucion__r.Name Where ' + buildFilter('SolutionName', busqueda) +  ' IsPublished = true Order By SolutionNumber Desc LIMIT '+ pagesize +'  OFFSET ' + offset+' )';
			String queryString =  'Select Id, SolutionName, SolutionNote, SolutionNumber, Categoria_Solucion__c, Categoria_Solucion__r.Name  From Solution Where ' + buildFilter('SolutionName', busqueda) +  ' IsPublished = true Order By SolutionNumber Desc LIMIT '+ pagesize +'  OFFSET ' + offset+' ';
			System.debug(queryString);

			soluciones = (List<Solution>) Database.query(queryString);

			//List<sObject> sobjList = Database.query('SELECT Id FROM MyCustomObject__c WHERE Name = :myTestString');

			/*List<List <sObject>> searchList = search.query(queryString);
			soluciones = ((List<Solution>)searchList[0]);*/
		}
		return soluciones;
	}

	private static List<Solution> getListadoSolucionesByCategoria(Set<String> idsCategories, integer pagesize, integer offset) { //WHERE IsPublishedInPublicKb = true
		List<Solution> soluciones = [Select Id, Categoria_Solucion__c, Categoria_Solucion__r.Name, Status, IsPublished, IsPublishedInPublicKb, SolutionName, SolutionNote, SolutionNumber from Solution Where Categoria_Solucion__c IN :idsCategories AND IsPublished = true  Order By SolutionNumber Desc LIMIT :pagesize OFFSET :offset ];
		return soluciones;
	}

	private static boolean hasprev(integer off) {
		if (off > 0)
			return false;
		return true;
	}
	private static boolean hasnxt(integer off, integer li, integer ps) {
		if (off + ps < li)
			return false;
		return true;
	}

	private static Item findItem(String identificador, List<Item> categorias){
		Item result = null;
		if(categorias!=null){
			for(Item item: categorias){
				System.debug('item.identificador : ' + item.identificador +  ' identificador ' +identificador); 
				if(item.identificador == identificador)
				return item;
				else 
					result = findItem(identificador, item.items);
					if(result!=null)
						return result;
			}
		} 
		return null;
	}

	@AuraEnabled
	public static SolutionResult saveSolution(Solution solucion) {
		SolutionResult solutionResult = actualizarSolucion(solucion);
		return solutionResult;
	}

	@AuraEnabled
	public static CategoryResult saveCategory(String identificador, String parentId, String label) {
		CategoryResult categoryResult = actualizarCategoria(identificador, parentId, label);
		return categoryResult;
	}

	@AuraEnabled
	public static SolutionResult deleteSolution(Solution solucion) {
		SolutionResult solutionResult = eliminarSolucion(solucion);
		return solutionResult;
	}

	@AuraEnabled
	public static CategoryResult deleteCategory(String identificador) {
		CategoryResult categoryResult = eliminarCategoria(identificador);
		return categoryResult;
	}

	public static List<String> applyQuotes(List<String> busqueda) {
		List<String> lista = new List<String>();
		for (String elemento : busqueda) {
			String el = '\'' + elemento + '\'';
			lista.add(el);
		}
		return lista;
	}

	public static String buildFilter(String fieldName, List<String> values) {
		Boolean first = true;
		String query = '';
		for (String el : values) {
			
			if(el=='')
				continue;

			if(first)
				query+= '(';

			if (!first) {
				query += ' OR ';
			}

			query = query + fieldName + ' LIKE \'%' + el + '%\'';
			first = false;
		}
		if(query.length()>0)
			query = query + ') AND ';
		return query;
	}

	private static String buildFilterSOSL(List<String> values) {
		Boolean first = true;
		String query = '\'';
		for (String el : values) {
			if (!first) {
				query += ' OR ';
			}
			query += '*' + el + '*';
			first = false;
		}
		query+='\'';
		return query;
	}

	private static SolutionResult actualizarSolucion(Solution solucion) {
		List<Solution> soluciones = new List<Solution>();
		soluciones.add(solucion);
		String[] errorMessages = new String[] {};
		Database.SaveResult[] results;
		if (String.isBlank(solucion.Id)) {
			results	= DatabaseUtils.inserts(soluciones, false, false);
		} else {
			results = DatabaseUtils.updates(soluciones);
		}

		for (Database.SaveResult result : results) {
			if (!result.isSuccess()){ 
			Database.Error[] errors = result.getErrors();
			for (Database.Error error : errors)
				errorMessages.add(error.getMessage());
			}
		}

		SolutionResult solutionResult = new SolutionResult();
		solutionResult.solucion = solucion;
		solutionResult.errorMessages = errorMessages;
		solutionResult.hasErrors = errorMessages.size() > 0;
		return solutionResult;
	}

	private static CategoryResult actualizarCategoria(String identificador, String parentId, String label) {
		List<Categoria_Solucion__c> soluciones = new List<Categoria_Solucion__c>();
		String[] errorMessages = new String[] {};
		Categoria_Solucion__c categoria;
		Database.SaveResult[] results;
		if(String.isBlank(identificador)){
			categoria = new Categoria_Solucion__c(Categoria_Solucion__c = parentId, Name = label);
			results = DatabaseUtils.inserts(new List<Categoria_Solucion__c>{categoria}, false, false);
		} else {
			categoria = new Categoria_Solucion__c(Id=identificador, Categoria_Solucion__c = parentId, Name = label);
			results = DatabaseUtils.updates(new List<Categoria_Solucion__c>{categoria}, false, false);
		}

		for(Database.SaveResult result: results){
			if (!result.isSuccess()){ 
				Database.Error[] errors = result.getErrors();
				for (Database.Error error : errors)
					errorMessages.add(error.getMessage());
			}
		}
		
		CategoryResult categoryResult = new CategoryResult();
		categoryResult.errorMessages = errorMessages;
		categoryResult.hasErrors = errorMessages.size() > 0;
		return categoryResult;
	}

	private static SolutionResult eliminarSolucion(Solution solucion) {
		List<Solution> soluciones = new List<Solution>();
		soluciones.add(solucion);
		String[] errorMessages = new String[] {};
		Database.DeleteResult[] results;
		results	= DatabaseUtils.deletes(solucion);
	
		for (Database.DeleteResult result : results) {
			if (result.isSuccess()) continue;
			Database.Error[] errors = result.getErrors();
			for (Database.Error error : errors)
				errorMessages.add(error.getMessage());
		}

		SolutionResult solutionResult = new SolutionResult();
		solutionResult.solucion = solucion;
		solutionResult.errorMessages = errorMessages;
		solutionResult.hasErrors = errorMessages.size() > 0;
		return solutionResult;
	}

	private static CategoryResult eliminarCategoria(String identificador) {
		List<Categoria_Solucion__c> categories = [Select Id, Categoria_Solucion__c From Categoria_Solucion__c Where Id = :identificador];
		String parentId;
		Categoria_Solucion__c categoria;
		if(categories.size() > 0){
			categoria = categories.get(0);
			parentId = categoria.Categoria_Solucion__c;
		}

		List<Categoria_Solucion__c> childCategories = [Select Id, Categoria_Solucion__c From Categoria_Solucion__c Where Categoria_Solucion__c = :identificador];
		for(Categoria_Solucion__c cat: childCategories)
			cat.Categoria_Solucion__c = parentId;

		if(!childCategories.isEmpty())
			DatabaseUtils.updates(childCategories);

		String[] errorMessages = new String[] {};
		Database.DeleteResult[] results;
		
		if(categoria!=null)
			results	= DatabaseUtils.deletes(categoria);
		
		for (Database.DeleteResult result : results) {
			if (result.isSuccess()) continue;
			Database.Error[] errors = result.getErrors();
			for (Database.Error error : errors)
				errorMessages.add(error.getMessage());
		}

		CategoryResult categoryResult = new CategoryResult();
		categoryResult.errorMessages = errorMessages;
		categoryResult.hasErrors = errorMessages.size() > 0;
		return categoryResult;
	}

	private static Set<String> childCategoriesByParentId(List<Item> items, String parentId, Set<String> childrenIds){
		if(items!=null){
			for(Item item: items){
				childrenIds.add(item.identificador);
				if(item.items!=null)
					childCategoriesByParentId(item.items, parentId, childrenIds);	
			}
		}
		return childrenIds;
	}

   	@AuraEnabled  
   	public static List<Item> getCategorias() {     
     	Item root = new Item('-1', 'TODAS', 'TODAS', true, null);
     	categorias = new Map<String, Item>();
     	setItemsIds = new Set<String>();
     	categorias.put(root.identificador, root); 
     	setItemsIds.add(root.identificador);
     	Map<Id, Categoria_Solucion__c> mapCategorias = new Map<Id, Categoria_Solucion__c>([Select Id, Name, Categoria_Solucion__c From Categoria_Solucion__c ORDER BY Name asc]);
        if(mapCategorias.size() > 0)
        {
        	for(Categoria_Solucion__c cat: mapCategorias.values()){
        		String catSuperior = '';
        		if(cat.Categoria_Solucion__c != null)
        			catSuperior = cat.Categoria_Solucion__c;
        		else 
        			catSuperior = '-1';
        		Item it = new Item(cat.Id, cat.Id, cat.Name, false, catSuperior);	
        		categorias.put(it.identificador, it);
        	}

        }
        List<Item> arbolOrdenado = new List<Item>();
	    buildHierarchyTree(root, arbolOrdenado); 
     	return arbolOrdenado;    
   	}

   	private static void buildHierarchyTree(Item it, List<Item> arbol) {
		Item item = it;
		List<Item> children = getChildrenById(item.identificador);
		item.items = children;
		
		if(item.identificador!= '-1' && children!=null){
			for (Item hijo : children) {
				hijo.expanded = true;
				//agrego todos los hijos, esto es para que no aparezcan duplicados en el arbol
	        	setItemsIds.add(hijo.identificador);
	        }
	    }

		if(!setItemsIds.contains(item.identificador)){
			arbol.add(item);
			setItemsIds.add(item.identificador);	
		}
		
        if (children.size() == 0) {
            return;
        }

        for (Item i : children) {
        	buildHierarchyTree(i, arbol);
        }
	}

	private static List<Item> getChildrenById(String parentId) {
		List<Item> items = new List<Item>();
		for (Item i : categorias.values()) {
        	if (i.parentId == parentId) {
           		items.add(i);
           	}
		}
		return items;
	 }

}