@IsTest
private class AbstractFabricateTest {
	
  @isTest
  static void itShouldTestChainingModel() {
    AccountFabricate accountFabricate = new AccountFabricate();
    accountFabricate.set('Name', 'Nombre cuenta');
    accountFabricate.get();
    accountFabricate.save(); // No se puede llamar a este metodo debido a que lanza error
    accountFabricate.load();
    accountFabricate.load('Name', 'Nombre cuenta');
    accountFabricate.reload();
    accountFabricate.duplicate();
  }
    
}