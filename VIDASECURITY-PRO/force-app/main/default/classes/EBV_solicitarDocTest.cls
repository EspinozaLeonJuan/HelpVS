@isTest
public class EBV_solicitarDocTest {

    Static TestMethod void solicitarDoc(){
        test.startTest();
        EBV_solicitarDoc.Input input = new EBV_solicitarDoc.Input();
        input.Input = '1';
        List<EBV_solicitarDoc.Input> listInput = new List<EBV_solicitarDoc.Input>();
    	listInput.add(input);
        EBV_solicitarDoc.SolicitarDoc(listInput);
        test.stopTest();
    }
}