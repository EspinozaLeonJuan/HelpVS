/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_Contador {
    static TestMethod void contadorError(){
        test.startTest();
        WSP_COL_Reembolso_Contador.Input input = new WSP_COL_Reembolso_Contador.Input();
        input.contador = '1';
        List<WSP_COL_Reembolso_Contador.Input> listInput = new List<WSP_COL_Reembolso_Contador.Input>();
    	listInput.add(input);
        WSP_COL_Reembolso_Contador.contadorOpcion(listInput);
        test.stopTest();
    }
}