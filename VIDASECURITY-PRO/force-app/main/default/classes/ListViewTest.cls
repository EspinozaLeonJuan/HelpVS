@IsTest
private class ListViewTest {
	
	@TestSetup
	static void init() {
		Account account = new Account(Name = 'Foo');
		insert account;
	}
	
	static testMethod void csvTest() {
		ListView listView = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Account' LIMIT 1];
		ApexPages.StandardSetController standard = new ApexPages.StandardSetController([SELECT Id FROM Account]);
		standard.setFilterId(listView.Id);
		String responseJson = '{"columns":[{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"Name","hidden":false,"label":"Nombre de la cuenta","selectListItem":"Name","sortDirection":"ascending","sortIndex":0,"sortable":true,"type":"string"},{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"Site","hidden":false,"label":"Sitio de la cuenta","selectListItem":"Site","sortDirection":null,"sortIndex":null,"sortable":true,"type":"string"},{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"BillingState","hidden":false,"label":"Estado o provincia de facturación","selectListItem":"BillingState","sortDirection":null,"sortIndex":null,"sortable":true,"type":"string"},{"ascendingLabel":"9-0","descendingLabel":"0-9","fieldNameOrPath":"Phone","hidden":false,"label":"Teléfono","selectListItem":"Phone","sortDirection":null,"sortIndex":null,"sortable":true,"type":"phone"},{"ascendingLabel":"Bajo a alto","descendingLabel":"Alto a bajo","fieldNameOrPath":"Type","hidden":false,"label":"Tipo","selectListItem":"toLabel(Type)","sortDirection":null,"sortIndex":null,"sortable":true,"type":"picklist"},{"ascendingLabel":"Z-A","descendingLabel":"A-Z","fieldNameOrPath":"Owner.Alias","hidden":false,"label":"Alias del propietario de la cuenta","selectListItem":"Owner.Alias","sortDirection":null,"sortIndex":null,"sortable":true,"type":"string"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"Id","hidden":true,"label":"Id. de la cuenta","selectListItem":"Id","sortDirection":null,"sortIndex":null,"sortable":false,"type":"id"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"CreatedDate","hidden":true,"label":"Fecha de creación","selectListItem":"CreatedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"LastModifiedDate","hidden":true,"label":"Fecha de la última modificación","selectListItem":"LastModifiedDate","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"},{"ascendingLabel":null,"descendingLabel":null,"fieldNameOrPath":"SystemModstamp","hidden":true,"label":"Modstamp del sistema","selectListItem":"SystemModstamp","sortDirection":null,"sortIndex":null,"sortable":false,"type":"datetime"}],"id":"00B1H00000AMhVg","orderBy":[{"fieldNameOrPath":"Name","nullsPosition":"first","sortDirection":"ascending"},{"fieldNameOrPath":"Id","nullsPosition":"first","sortDirection":"ascending"}],"query":"SELECT Name, Site, BillingState, Phone, toLabel(Type), Owner.Alias, Id, CreatedDate, LastModifiedDate, SystemModstamp FROM Account ORDER BY Name ASC NULLS FIRST, Id ASC NULLS FIRST","scope":null,"sobjectType":"Account","whereCondition":{"conditions":[],"conjunction":"and"}}';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		Test.startTest();
		ListViewController controller = new ListViewController(standard);
		String csv = controller.getCSV();
		Test.stopTest();
		System.assertNotEquals(null, csv);
	} 
    }