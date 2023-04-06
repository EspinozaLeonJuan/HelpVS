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
@IsTest
public class TEST_CTR_CS_DerivarCaso_Error {
    public TEST_CTR_CS_DerivarCaso_Error() {

    }
    
     @istest static void LoadError_01() {
        Test.startTest();
        CTR_CS_DerivarCaso_Error Con = new CTR_CS_DerivarCaso_Error();        
        Con.Error = 'DERIVACION_NO_PERMITIDA';
        Con.LoadError();       
        Test.StopTest();
    } 


    @isTest static void cargaCasoSeleccionado_a() {
        Test.startTest();
        CTR_CS_DerivarCaso_Error Con = new CTR_CS_DerivarCaso_Error();
        Con.CargaCaso();
        Test.stopTest();
    }
}