/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_SolicitarDoc {
    static TestMethod void solicitarDoc(){
        test.startTest();
        WSP_COL_Reembolso_SolicitarDoc.Input input = new WSP_COL_Reembolso_SolicitarDoc.Input();
        input.Input = '1';
        List<WSP_COL_Reembolso_SolicitarDoc.Input> listInput = new List<WSP_COL_Reembolso_SolicitarDoc.Input>();
    	listInput.add(input);
        WSP_COL_Reembolso_SolicitarDoc.SolicitarDoc(listInput);
        test.stopTest();
    }
}