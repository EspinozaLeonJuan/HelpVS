/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-01-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   12-01-2020   Juan Espinoza León   Initial Version
**/
@istest
public class TEST_CLS_TV_GestionCarga {
    public TEST_CLS_TV_GestionCarga() {

    }

    @istest
    public static void RefreshCargaTeleventa()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        insert carga;
        CLS_TV_GestionCarga.RefreshCargaTeleventa(carga.Id, 100, 30, 70, 70);
        Test.stopTest();
    }
}