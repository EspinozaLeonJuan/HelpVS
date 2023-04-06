@isTest
public class EBV_contadorErrorTest {
    
    Static TestMethod void contadorError(){
        test.startTest();
        EBV_contadorError.tipoGastoInput input = new EBV_contadorError.tipoGastoInput();
        input.contador = '1';
        List<EBV_contadorError.tipoGastoInput> listInput = new List<EBV_contadorError.tipoGastoInput>();
    	listInput.add(input);
        EBV_contadorError.contadorOpcion(listInput);
        test.stopTest();
    }

}