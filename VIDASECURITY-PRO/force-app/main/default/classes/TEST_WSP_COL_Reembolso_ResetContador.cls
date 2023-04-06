/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_ResetContador {
    Static TestMethod void ResterscontadorError(){
        test.startTest();
        WSP_COL_Reembolso_ResetContador.Input input = new WSP_COL_Reembolso_ResetContador.Input();
        input.contadorin = '2';
        List<WSP_COL_Reembolso_ResetContador.Input> listInput = new List<WSP_COL_Reembolso_ResetContador.Input>();
    	listInput.add(input);
        WSP_COL_Reembolso_ResetContador.reserContador(listInput);
        test.stopTest();
    }
}