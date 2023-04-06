@isTest
public class EBV_validateRutTest {
    
     static TestMethod void validateRutTest(){
       	test.startTest();
        EBV_ValidateRut.Input input = new EBV_ValidateRut.Input();
        input.rut = '19.885521-9';
        String dv = input.rut.substring(input.rut.length() - 1);
        List<EBV_ValidateRut.Input> listInput = new List<EBV_ValidateRut.Input>();
    	listInput.add(input);
        String conca = String.valueOf(input.rut) + String.valueOf(dv); 
        EBV_ValidateRut.getRutValidate(listInput);
        test.stopTest();
    } 
    

}