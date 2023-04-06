/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-12-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class TEST_PAR_UR_Bandeja {
    public TEST_PAR_UR_Bandeja() {

    }
    
    @isTest
    static void testParse() {
        Test.startTest();
        String json=		'{'+
		'"Botonera": '+
		'{ '+
		'"CasosUR" : true, '+
		'"TareasUR" : false, '+
        '"ColaboracionesUR" : true, '+
        '"AsignacionesUR" : true, '+
		'"SeleccionUsuario" : true, '+
        '"CasosOptativos" : true '+
		'}'+
		'} ';
		PAR_UR_Bandeja obj = PAR_UR_Bandeja.parse(json);
        system.debug('CasosUR  ' +obj.Botonera.CasosUR);
        system.debug('TareasUR  ' +obj.Botonera.TareasUR);
        system.debug('ColaboracionesUR  ' +obj.Botonera.ColaboracionesUR);
        system.debug('AsignacionesUR  ' +obj.Botonera.AsignacionesUR);
        system.debug('SeleccionUsuario  ' +obj.Botonera.SeleccionUsuario);
        system.debug('CasosOptativos  ' +obj.Botonera.CasosOptativos);
		///System.assert(obj != null);
        Test.stopTest();		
	}
}