global class ListViewController {

	
	public class ListViewData {
		public String sobjectType;
		public String query;
		public Column[] columns {get; set;}
			}
	
	public class Column {
		public String ascendingLabel, descendingLabel; 
		public String fieldNameOrPath {get; set;}
		public String hidden {get; set;}
		public String label {get; set;}
		public String selectListItem, sortDirection, sortIndex, sortable, type;
			}
			
						public ListViewData listView {get; set;}
						//private SObject[] records;
						private Map<Id, Sobject> referenceMap;
			
	global ListViewController(ApexPages.StandardSetController controller) {
		String filterId = controller.getFilterId();
		System.assertNotEquals(null, filterId, 'Debe seleccionar una vista primero.');
		ListView lv = [SELECT Id, sObjectType FROM ListView WHERE Id = :filterId];
		String sobjectType = lv.sObjectType;
		System.assertNotEquals(null, sobjectType, 'El tipo de objeto no se ha especificado.');
		this.listView = getListView(sobjectType, filterId);
			}
	
	public static ListViewData getListView(String sobjectName, String filterId) {
		HttpRequest req = new HttpRequest();
		String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		String endPointURL = baseUrl + '/services/data/v32.0/sobjects/' + sobjectName + '/listviews/' + filterId + '/describe';
		req.setEndpoint(endPointURL);
		req.setMethod('GET');
		req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
		Http http = new Http();
		HTTPResponse response = http.send(req);
		String responseBody = response.getBody();
		System.debug('\nRespuesta de ListView Metadata:\n' + responseBody);
		//Map<String, Object> tokenResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
		//System.debug(tokenResponse.keySet());
		ListViewController.ListViewData listView = (ListViewController.ListViewData)Json.deserialize(responseBody, ListViewController.ListViewData.class);
		return listView;
	}
	
	public void prepareReferenceMap(Sobject[] records) {
		Set<String> paths = new Set<String>();
		for (Column column : listView.columns) {
			if (column.fieldNameOrPath.contains('.'))
				paths.add(column.fieldNameOrPath);
		}
		prepareReferenceMap(paths, records);
	}
			
	private void prepareReferenceMap(Set<String> paths, Sobject[] records) {
		Map<Schema.SobjectType, Query> queryMap = new Map<Schema.SobjectType, Query>();
		for (Sobject record : records) {
			for (String path : paths) {
				setQueryMap(queryMap, path, record);
			}
		}
		this.referenceMap = new Map<Id, Sobject>();
		for (Query query : queryMap.values()) {
			Map<Id, Sobject> recordMap = query.getRecordMap();
			for (Id refId : recordMap.keySet()) {
				Sobject record = recordMap.get(refId);
				referenceMap.put(refId, record);
			}
		}
	}
	
	private void setQueryMap(Map<Schema.SobjectType, Query> queryMap, String path, Sobject record) {
		String[] parts = path.split('\\.');
		String referenceName = parts.remove(0);
		String referenceFieldName = (referenceName.endsWith('__r') ? referenceName.replace('__r', '__c') : (referenceName+'Id'));
		Id referenceId = (Id)record.get(referenceFieldName);
		if (referenceId == null)
		return;
		String fieldName = String.join(parts, '.');
		Schema.SobjectType stype = referenceId.getSobjectType();
		Query query = queryMap.get(stype);
		if (query == null) {
			query = new Query(stype);
			queryMap.put(stype, query);
		}
		query.addField(fieldName);
		query.addId(referenceId);
		
	}
	
	public String getReferencedValue(String path, Sobject record) {
		String[] parts = path.split('\\.');
		String referenceName = parts.remove(0);
		String referenceFieldName = (referenceName.endsWith('__r') ? referenceName.replace('__r', '__c') : (referenceName+'Id'));
		Id referenceId = (Id)record.get(referenceFieldName);
		if (referenceId == null)
			return '';
		String fieldName = String.join(parts, '.');
		Sobject referencedObj = referenceMap.get(referenceId);
		Object value = referencedObj.get(fieldName);
		if (value == null)
			return '';
		return String.valueOf(value);
			}
	
	
	global String getCSV() {
		Sobject[] records = Database.query(listView.query);
		prepareReferenceMap(records);
		String sep = ';';
		String nl = '\n';
		String result = '';
		for (Column column : listView.columns) {
			result += ((String.isBlank(result) ? '' : sep) + column.label.escapeCSV());
		}
		result += nl;
		for (Sobject record : records) {
			String row = '';
			for (Column column : listView.columns) {
				String value ='';
				if (column.fieldNameOrPath.contains('.'))
					value = getReferencedValue(column.fieldNameOrPath, record);
					else
					value = String.valueOf(record.get(column.fieldNameOrPath));
				value = value == null ? '' : value.escapeCSV();
				row += ((String.isBlank(row) ? '' : sep) + value);
									}
									result += row + nl;
		}
		return result;
	}
}