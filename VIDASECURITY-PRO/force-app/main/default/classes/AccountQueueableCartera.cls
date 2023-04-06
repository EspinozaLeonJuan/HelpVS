/**

**********************************************************************************************************************/
public class AccountQueueableCartera implements Queueable, Database.AllowsCallouts{
  
  private Set<Id> accountsIdsCartera;
  private Integer option;

  public AccountQueueableCartera( Set<Id> accountsIdsCartera, Integer option) {
    this.accountsIdsCartera = accountsIdsCartera;
    this.option = option;
  }

  public void execute(QueueableContext context) {
    AdministrarCarteraHuerfana.execute( accountsIdsCartera, option );
  }
}