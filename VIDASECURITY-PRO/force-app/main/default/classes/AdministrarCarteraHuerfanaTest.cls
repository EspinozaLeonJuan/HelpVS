@IsTest
private class AdministrarCarteraHuerfanaTest {
  static testMethod void AdministrarCarteraHuerfanaTest() {
    Test.startTest();
    Account acc = new Account( name='test', OwnerId='005i0000000ij3TAAQ', isCartera__c=false);
    insert acc;
    Account acc2 = new Account( name='test', OwnerId='0050H00000CCwrGQAT');
    insert acc2;
    Set<Id> accountsIdsCartera = new Set<Id>();
    Integer option = 1;
    Id result = AdministrarCarteraHuerfana.getAccountIdCartera(acc, acc2, accountsIdsCartera);
    accountsIdsCartera.add(acc.Id);
    accountsIdsCartera.add(acc2.Id);
    Poliza__c poli = new Poliza__c( Name='123', Cuenta__c=acc.Id , Estatus__c='ACTIVA', Con_o_Sin_Ahorro__c= 'Con Ahorro',Tipo_Producto__c='APV' );
    insert poli;
    secondProccess(accountsIdsCartera,option);
    Test.stopTest();
  }
	
  @future
  static void secondProccess(Set<Id> accountsIdsCartera, Integer option)
  {
    EmailTemplate newTemplate = new EmailTemplate(name='Plantilla A Con Ahorro',DeveloperName='Plantilla_A_Con_Ahorro', subject='aea', TemplateType='Custom',FolderId='005i0000000ij3TAAQ',IsActive = true);
    upsert newTemplate;
    EmailTemplate newTemplate2 = new EmailTemplate(name='Plantilla B APV',DeveloperName='Plantilla_B_APV', subject='aea', TemplateType='Custom',FolderId='005i0000000ij3TAAQ',IsActive = true);
    upsert newTemplate2;
    AdministrarCarteraHuerfana.execute(accountsIdsCartera, option);
    AdministrarCarteraHuerfana.execute(accountsIdsCartera, option + 1);
  }
}