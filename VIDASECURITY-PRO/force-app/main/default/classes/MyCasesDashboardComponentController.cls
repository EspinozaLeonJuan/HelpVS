public without sharing class MyCasesDashboardComponentController {

	private static final String SOBJECTTYPE = 'Case';
	private static final String LISTVIEW_DEVELOPER_NAME = 'MyCases';

	// DOC: https://developer.salesforce.com/docs/atlas.ja-jp.api.meta/api/sforce_api_objects_listview.htm
	public String listViewId { get {
		ListView[] listas = [SELECT Id, Name FROM ListView WHERE DeveloperName = :LISTVIEW_DEVELOPER_NAME AND SobjectType = :SOBJECTTYPE];
		System.debug(listas);
		if (listas.size() > 0)
			return String.valueOf(listas[0].Id).substring(0,15); // Se tuvo que convertir el Id a 15 caracteres debido a que si no detectaba otra List View.
		return '';
	}}

}