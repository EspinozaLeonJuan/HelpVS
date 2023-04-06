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
@isTest
public class TEST_CLS_INV_LINK_AsignarLink {

    @isTest(seeAllData=true)
    public static void  Execution() {
       	    
        Test.startTest();
 	    Opportunity op = [SELECT Id, Codigo_de_Link__c FROM Opportunity WHERE Codigo_de_Link__c =: null LIMIT 1];
        
        List<String> Ids = new List<String>();
        Ids.add(op.Id);    
        CLS_INV_LINK_AsignarLink.Execution(Ids);
        Test.stopTest();
        
    }    
    
    
}