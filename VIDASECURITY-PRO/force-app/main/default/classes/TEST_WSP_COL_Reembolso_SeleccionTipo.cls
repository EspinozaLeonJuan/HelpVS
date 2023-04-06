/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-20-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class TEST_WSP_COL_Reembolso_SeleccionTipo {
    static TestMethod void testvalidateoption(){
        Test.startTest();
        WSP_COL_Reembolso_SeleccionTipo.Input input = new WSP_COL_Reembolso_SeleccionTipo.Input();
        input.option = 'Ambulatorio (consulta, exámenes, medicamentos, ópticos)';
        List<WSP_COL_Reembolso_SeleccionTipo.Input> listInput = new List<WSP_COL_Reembolso_SeleccionTipo.Input>();
        listInput.add(input);
        WSP_COL_Reembolso_SeleccionTipo.validateOption(listInput);
        Test.stopTest();
    }

    static TestMethod void testvalidateoptionFalse(){
        Test.startTest();
        WSP_COL_Reembolso_SeleccionTipo.Input input = new WSP_COL_Reembolso_SeleccionTipo.Input();
        input.option = '3';
        List<WSP_COL_Reembolso_SeleccionTipo.Input> listInput = new List<WSP_COL_Reembolso_SeleccionTipo.Input>();
        listInput.add(input);
        WSP_COL_Reembolso_SeleccionTipo.validateOption(listInput);
        Test.stopTest();
    }

}