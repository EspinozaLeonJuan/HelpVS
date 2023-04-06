/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 02-09-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-09-2021   Juan Espinoza León   Initial Version
**/
@isTest
public class TEST_OBJ_LINK_GestionRanking {
    public TEST_OBJ_LINK_GestionRanking() {

    }

    @IsTest
    static void LoadObject(){
        
        Test.startTest();

        OBJ_LINK_GestionRanking objeto = new OBJ_LINK_GestionRanking();
        objeto.Oportunidades = new List<Opportunity>();
        objeto.Actualizar_Oportunidades = new List<Opportunity>();
        objeto.Registro_Links = new List<Link_Asignado__c>();
        Test.stopTest();
    }
  
}