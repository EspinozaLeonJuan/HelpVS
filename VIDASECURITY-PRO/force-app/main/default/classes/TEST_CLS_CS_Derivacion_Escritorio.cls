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
public class TEST_CLS_CS_Derivacion_Escritorio {
    public TEST_CLS_CS_Derivacion_Escritorio() {

    }
    
     @isTest static void RequerimientoEscritorioDigital()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Aumento de Prima en Exceso'; 
        String ID = '';
        String UsuarioID = '';
		String response = CLS_CS_Derivacion_Escritorio.Valida_EstadoRequerimiento(ID, UsuarioID);
        Test.stopTest();        
    }
}