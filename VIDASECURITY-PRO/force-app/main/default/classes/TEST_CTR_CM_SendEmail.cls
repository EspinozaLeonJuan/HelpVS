/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-31-2021   Juan Espinoza León   Initial Version
**/
@istest
public with sharing class TEST_CTR_CM_SendEmail {
    public TEST_CTR_CM_SendEmail() {
 
    }

    @isTest static void getListadoRegiones()
    {
        Test.startTest();
        CTR_CM_SendEmail Con = new CTR_CM_SendEmail();
          
        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        insert lead;

        ApexPages.currentPage().getParameters().put('Call', 'L');
        ApexPages.currentPage().getParameters().put('Id', lead.Id);
        Con.inicio();
        test.stopTest();
    }
}