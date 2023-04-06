@istest
public class TEST_CTR_CM_PolizasVigentes {

    @isTest static void PolizasVigentes_Test01()
    {
        Test.startTest();
        
        
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;
        
        CTR_CM_PolizasVigentes Con = new CTR_CM_PolizasVigentes();
        ApexPages.currentPage().getParameters().put('rutContratante', '88888888-8');
        ApexPages.currentPage().getParameters().put('PolizaMandatoria', '234500'); 
        Con.PolizasVigentes();
        test.stopTest();
    }

}