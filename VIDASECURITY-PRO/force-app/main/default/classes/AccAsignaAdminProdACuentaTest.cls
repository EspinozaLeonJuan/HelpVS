/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccAsignaAdminProdACuentaTest {

	static testMethod void testInsertAsignandoAdminACuenta(){
		if(!TestVerificationService.ShouldExecute('AccAsignaAdminProdACuentaTest.testInsertAsignandoAdminACuenta')){return;}
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('FirstName','Winder').set('LastName','Ojeda').save();
		Id idContacto = (Id)contacto.get().get('Id');
		Contact con = (Contact)contacto.get();
		Set<Id> idsAdmins = new Set<Id>();
		Set<String> rutsAdmins = new Set<String>();
		Map<String, Contact> mapAdmins = new Map<String, Contact>();
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Test.startTest();
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
			.set('Name','Cuenta Corporativa')
			.set('Omitir_Validaciones_AMAC__c',true)
			.set('RUT_Administrador_de_Produccion__c','16355278')
			.set('Administrador_de_Produccion__c', con.Id)
			.save();
		
		List<Account> ac = [
			SELECT RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c, Name, RecordTypeId 
			FROM Account 
			WHERE Administrador_de_Produccion__c =: idContacto 
			AND RecordTypeId = :recordTypeCuentaCorporativa];
		
		for(Account acc : ac){
			AccAsignaAdminProdACuenta.getIdAdmin(acc, null, idsAdmins, recordTypeCuentaCorporativa);
			idsAdmins.add(acc.Administrador_de_Produccion__c);

			AccAsignaAdminProdACuenta.getRutsAdmin(acc, null, rutsAdmins, recordTypeCuentaCorporativa);
			rutsAdmins.add(acc.RUT_Administrador_de_Produccion__c.toUpperCase());
		}
		List<Contact> contcs = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsAdmins];
		
		for( Contact contactos : contcs ){
			Contact c = AccAsignaAdminProdACuenta.getMapAdmin(contactos, mapAdmins); 
			if (c != null){
				mapAdmins.put(c.Rut__c.toUpperCase(), c);
			}
		}

		Map<Id, Contact> mapContactosByIdAdmin = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsAdmins]);
		
		Account cuentaOld = new Account(); 
		
		Test.stopTest();
	}

	Static testMethod void testactualizarcuenta(){
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('FirstName','Winder').set('LastName','Ojeda').save();
		Id idContacto = (Id)contacto.get().get('Id');
		Set<Id> idsAdmins = new Set<Id>();
		Set<String> rutsAdmins = new Set<String>();
		Map<String, Contact> mapAdmins = new Map<String, Contact>();
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Id recordTypeCuentaEmpresa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Test.startTest();
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
			.set('Name','Cuenta Corporativa')
			.set('Omitir_Validaciones_AMAC__c',true)
			.set('RUT_Administrador_de_Produccion__c','16355278')
			.save();
		List<Account> ac = [
			SELECT RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c, Name, RecordTypeId 
			FROM Account 
			WHERE  RecordTypeId = :recordTypeCuentaCorporativa];
		
		for(Account acc : ac){
			AccAsignaAdminProdACuenta.getIdAdmin(acc, null, idsAdmins, recordTypeCuentaCorporativa);
			idsAdmins.add(acc.Administrador_de_Produccion__c);
			AccAsignaAdminProdACuenta.getRutsAdmin(acc, null, rutsAdmins, recordTypeCuentaCorporativa);
			rutsAdmins.add(acc.RUT_Administrador_de_Produccion__c.toUpperCase());
		}

		List<Contact> contcs = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsAdmins];
		
		for( Contact contactos : contcs ){
			Contact c = AccAsignaAdminProdACuenta.getMapAdmin(contactos, mapAdmins); 
			if (c != null){
				mapAdmins.put(c.Rut__c.toUpperCase(), c);
			}
		}
		
		Map<Id, Contact> mapContactosByIdAdmin = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsAdmins]);
		
		for(Account acc : ac){
			AccAsignaAdminProdACuenta.updateAccount(false, acc, null, recordTypeCuentaEmpresa, mapContactosByIdAdmin, mapAdmins);
		} 
		Test.stopTest();
	}
}