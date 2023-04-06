/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-29-2021   Juan Espinoza León   Initial Version
**/
@istest
public with sharing class TEST_OBJ_WS_CC_RealizaLlamada {
    public TEST_OBJ_WS_CC_RealizaLlamada() {

    } 

    @isTest static void IniciarBandeja()
   {
       Test.startTest();
       OBJ_WS_CC_RealizaLlamada Con = new OBJ_WS_CC_RealizaLlamada();
       Con.StatusCode = 1;
       Con.Status = '';
       Con.Body = '';
       Con.Message = '';
       Test.stopTest();
    }
}