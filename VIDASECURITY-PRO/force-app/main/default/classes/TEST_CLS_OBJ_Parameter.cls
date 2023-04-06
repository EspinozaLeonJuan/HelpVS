@istest public class TEST_CLS_OBJ_Parameter {
    
    static testmethod void test_GetValue() {        
        Test.startTest();
        OBJ_Parameter__c para = new OBJ_Parameter__c();
        para.Descripcion__c = 'descripcion';
        para.Key__c = 'KEY';
        para.Value__c = 'VALUE';
        insert para;

        CLS_OBJ_Parameter.GetValue('KEY');
        
        Test.stopTest();
        
    }
}