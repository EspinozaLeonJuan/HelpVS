/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 02-05-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-05-2021   Juan Espinoza León   Initial Version
**/
public with sharing class OBJ_LINK_GestionRanking {
    public OBJ_LINK_GestionRanking() {

    }

    public List<Opportunity> Oportunidades  {get; set;}

    public List<Opportunity> Actualizar_Oportunidades {get; set;}

    public List<Link_Asignado__c> Registro_Links {get; set;}
}