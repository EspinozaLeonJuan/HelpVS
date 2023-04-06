@isTest

public class EBV_validateRutDependTest {
    
    static TestMethod void validateRutDepenTest(){
       	test.startTest();
        EBV_ValidateRutDepend.DepenInput input = new EBV_ValidateRutDepend.DepenInput();
        input.rut = '19.885521-9';
        List<EBV_ValidateRutDepend.DepenInput> listInput = new List<EBV_ValidateRutDepend.DepenInput>();
    	listInput.add(input);
        EBV_ValidateRutDepend.rutDependent(listInput);
        test.stopTest();
    }
    
     static TestMethod void testvalidateoptionFalse(){
       	test.startTest();
        EBV_ValidateRutDepend.DepenInput input = new EBV_ValidateRutDepend.DepenInput();
        input.rut = '44266888-27';
        List<EBV_ValidateRutDepend.DepenInput> listInput = new List<EBV_ValidateRutDepend.DepenInput>();
    	listInput.add(input);
        EBV_ValidateRutDepend.rutDependent(listInput);
        test.stopTest();
    }
   

}