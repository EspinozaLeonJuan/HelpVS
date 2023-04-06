/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-29-2021
 * @last modified by  : Juan Espinoza León
**/

@IsTest
public with sharing class TEST_CLS_UTL_Lightning {
    public TEST_CLS_UTL_Lightning() {
 
    }


    @IsTest
    public static void get_pickList_with_dependency_Test_01()
    {
        Test.startTest();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_UTL_Lightning.get_pickList_with_dependency(Case.CASO_Categoria__c, 'Seguros Individuales');
        Test.stopTest();
    }

    @IsTest
    public static void get_pickList_without_dependency_Test_01()
    {
        Test.startTest();
        Case Kase = new Case();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_UTL_Lightning.get_pickList_without_dependency(Kase, 'CASO_Categoria__c');
        Test.stopTest();
    }
}