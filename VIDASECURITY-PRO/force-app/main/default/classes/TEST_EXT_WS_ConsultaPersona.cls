/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-03-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-03-2020   Juan Espinoza Leon   Initial Version
**/
@IsTest(SeeAllData=true) 
public class TEST_EXT_WS_ConsultaPersona {

     @isTest static void getDatosPersona()
    {
        Test.startTest();
        EXT_WS_ConsultaPersona.getDatosPersona('15045517-0');
        Test.stopTest();
    }
    
     @isTest static void mapConsultaPersona()
    {
        Test.startTest();
        EXT_WS_ConsultaPersona.mapConsultaPersona(null);
        Test.stopTest();
    }
    
    @isTest static void DatosPersona()
    {
        Test.startTest();
        EXT_WS_ConsultaPersona.DatosPersona('15045517-0');
        Test.stopTest();
    }
    
    //
}