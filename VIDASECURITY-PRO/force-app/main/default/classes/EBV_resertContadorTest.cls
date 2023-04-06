@isTest
public class EBV_resertContadorTest {

    Static TestMethod void ResterscontadorError(){
        test.startTest();
        EBV_resertContador.contadorInput input = new EBV_resertContador.contadorInput();
        input.contadorin = '2';
        List<EBV_resertContador.contadorInput> listInput = new List<EBV_resertContador.contadorInput>();
    	listInput.add(input);
        EBV_resertContador.reserContador(listInput);
        test.stopTest();
    }
}