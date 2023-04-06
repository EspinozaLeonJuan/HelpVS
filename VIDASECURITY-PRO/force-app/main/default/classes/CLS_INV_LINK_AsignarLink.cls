/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 02-08-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-02-2021   Juan Espinoza León   Initial Version
**/
public class CLS_INV_LINK_AsignarLink {
    @InvocableMethod 
    public static void Execution (List<String> Ids)
    {
        try
        {
            Opportunity op = [SELECT Id, Codigo_de_Link__c FROM Opportunity WHERE Id =: Ids[0]];

            if (op.Codigo_de_Link__c == null)
            {
                AggregateResult[] groupedResults = [SELECT Max(Codigo_de_Link__c) maximus FROM Opportunity];
                Integer maxLink = Integer.valueOf(groupedResults[0].get('maximus'));
                system.debug('@@@@@ maxLink'+ maxLink);
                maxLink = maxLink + 1;
                system.debug('@@@@@ new maxLink'+ maxLink);
                op.Codigo_de_Link__c = maxLink;
                update op;
            }
        }
        catch(Exception ex)
        {
   			system.debug('@@@@ Exception Line -->'+ ex.getLineNumber());            
            system.debug('@@@@ Exception Causa -->'+ ex.getCause());            
            system.debug('@@@@ Exception Mensaje -->'+ ex.getMessage());            
        }
        
    }
}