@isTest
public class EBV_validateOptionTest {
    static TestMethod void testvalidateoption(){
       	test.startTest();
        EBV_validateOption.optionInput input = new EBV_validateOption.optionInput();
        input.option = '1';
        List<EBV_validateOption.optionInput> listInput = new List<EBV_validateOption.optionInput>();
    	listInput.add(input);
        EBV_validateOption.validateOption(listInput);
        test.stopTest();
    }
    static TestMethod void testvalidateoptionFalse(){
       	test.startTest();
        EBV_validateOption.optionInput input = new EBV_validateOption.optionInput();
        input.option = '3';
        List<EBV_validateOption.optionInput> listInput = new List<EBV_validateOption.optionInput>();
    	listInput.add(input);
        EBV_validateOption.validateOption(listInput);
        test.stopTest();
    }
}