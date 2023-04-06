/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
@istest(seeAllData=true)
public class TEST_CTR_UR_Caso_Optativo {
    public TEST_CTR_UR_Caso_Optativo() {

    }
    
    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.cargaCaso();
        Test.stopTest();
    }
    
    @isTest static void IniciaCaso_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.IniciaCaso();
        Test.stopTest();
    }
    
    @isTest static void CargaUsuario_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.CargaUsuario();
        Test.stopTest();
    }
    
    @isTest static void ValidaEscritorioDigital_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.ValidaEscritorioDigital();
        Test.stopTest();
    }
    
    @isTest static void CargaParametros_Caso_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.CargaParametros_Caso();
        Test.stopTest();
    }
    
    @isTest static void Es_EndosoIndividual_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.Es_EndosoIndividual('');
        Test.stopTest();
    }
    
    @isTest static void ErrorAcceso_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.ErrorAcceso();
        Test.stopTest();
    }
    
     @isTest static void CasosOptativos_Test_01()
    {
        Test.startTest();
        CTR_UR_Caso_Optativo controlador = new CTR_UR_Caso_Optativo();
        controlador.CasosOptativos();
        Test.stopTest();
    }
    }