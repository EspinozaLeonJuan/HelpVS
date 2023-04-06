/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-15-2022
 * @last modified by  : Juan Espinoza León
**/

@isTest
public with sharing class TEST_CLS_BAK_Gestion_Caso {
    @isTest static void getListBandejaUR()
    {
        OBJ_BandejaUR_Configuracion__c obj = new OBJ_BandejaUR_Configuracion__c();
        obj.Colaboracion_Reclamo__c = true;
        obj.Id_Cola__c = '00G0H0000067TVsUAM';
        obj.Nombre_Cola__c = 'UR - Cobranza';
        obj.Usuario__c = '0050H00000CCv56QAD';
       
        insert obj;
        
        Test.startTest();

        CLS_BAK_Gestion_Caso.getListBandejaUR();

        Test.stopTest();
    }
}