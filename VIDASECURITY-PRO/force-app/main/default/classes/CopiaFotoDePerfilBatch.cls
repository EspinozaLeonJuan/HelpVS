global class CopiaFotoDePerfilBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts {
	
	private static final Integer MAX_USERS_IN_BATCH = 10; 
	
	private integer daysAgo;
	
	global CopiaFotoDePerfilBatch(Integer daysAgo) {
		this.daysAgo = daysAgo;
	} 
    
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Date dateFrom = null;
		String query = 'SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl FROM User WHERE FullPhotoUrl <> NULL AND IsActive = true AND (NOT FullPhotoUrl LIKE \'%/005/F\')';
		if (daysAgo != null) {
			dateFrom = Date.today().addDays(-daysAgo);
			query += ' AND LastModifiedDate > :dateFrom';
		}
		if (Test.isRunningTest())
		query += ' LIMIT :MAX_USERS_IN_BATCH';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		Map<Id, User> userMap = new Map<Id, User>((User[])scope);
		Folder[] folders = [SELECT Id FROM Folder WHERE Name = 'Fotos'];
		System.assertNotEquals(0, folders.size(), 'Debe crear la carpeta de fotos');
		Folder folder = folders[0];
		List<Document> documents = [SELECT Id, Description, Name, FolderId FROM Document WHERE FolderId = :folder.Id];
		Map<String, Document> documentMap = new Map<String, Document>();
		for (Document document : documents) {
			String key = document.Description;
			documentMap.put(key, document);
		}
		
		for (User u : userMap.values()) {
			if (u.FullPhotoUrl.endsWith('/005/F'))
				continue;
			Blob b = HTTPUtils.get(u.FullPhotoUrl);
			System.assertNotEquals(null, b, 'El blob es null');
			String key = 'F' + u.Id;
			Document document = documentMap.get(key);
			if (document == null) {
				document = new Document(Name = u.Name, FolderId = folder.Id, ContentType = 'image/jpg', IsPublic = true, Description = key);
				documentMap.put(key, document);
			}
			document.Body = b;
		}
		upsert documentMap.values();
		
		documents = [SELECT Id, Description, Name, FolderId FROM Document WHERE FolderId = :folder.Id];
		for (Document document : documents) {
			if (String.isBlank(document.Description)) {
				System.debug('El developer name es blanco');
				continue;
			}
			String userId = document.Description.substring(1);
			if (userId.length() != 18) {
				System.debug('WARNING: El largo del Id e usuario en el Description de la foto debe ser 19');
				continue;
			}
			User user = userMap.get(Id.valueOf(userId));
			if (user != null) {
				user.Foto__c = URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + document.Id + '&oid=' + UserInfo.getOrganizationId();
				//System.assertNotEquals(null, user.Foto__c, 'La URL de la foto no puede ser nula');
			}
		}
		
		update userMap.values();
	}
	
	global void finish(Database.BatchableContext BC){
	}
	
	global static void start(Integer daysAgo) {
		CopiaFotoDePerfilBatch batch = new CopiaFotoDePerfilBatch(daysAgo);
		Database.executeBatch(batch, MAX_USERS_IN_BATCH);
	} 
}