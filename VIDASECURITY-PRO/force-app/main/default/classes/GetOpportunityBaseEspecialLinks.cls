/*******************************************************************************************
 *  NOMBRE                 : GetOpportunityBaseEspecialLinks
 *  TIPO                   : APEX CLASS FOR LWC
 *  REQUERIMIENTO          : PROYECTO LINKS - TELEVENTA LINKS
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE    - OBSERVACIONES
 *  1.1     - 22/06/2020 - JP. HERNANDEZ - CLASE HELPER PARA LWC CARRUSEL.JS
 * *****************************************************************************************/
public with sharing class GetOpportunityBaseEspecialLinks {
    public GetOpportunityBaseEspecialLinks() {

    }

    @AuraEnabled(cacheable=true)
    public static String getAllOpps() {
        List<Opportunity> opp = [SELECT Id, Name ,StageName, CloseDate ,Type ,Probability,Account.Name 
                                    from Opportunity where Tipo_Link__c = 'Bases Especiales' AND agente_asignado__c=false AND Link_Auditado__c = true];
                                    return String.valueOf(opp.size());
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getAgents() {
        return [SELECT Id, Name, FirstName, LastName FROM Contact Where Tipo_Cargo__c ='Supervisor FFVV' 
        OR Tipo_Cargo__c='Supervisor PF' ORDER BY Name ASC NULLS LAST];
    }

    @AuraEnabled
    public static boolean asignacionEspecial(String[] valor) {
    
      List<Contact> cont = [SELECT id, Name FROM Contact WHERE Id In:valor];

      List<Opportunity> oppEsp = [SELECT Id, Agente_de_Venta__c
                                    from Opportunity where Tipo_Link__c = 'Bases Especiales' AND agente_asignado__c=false AND Link_Auditado__c = true];
                                    
      List<Opportunity> oppToUpdate = new List<Opportunity>();

      if(oppEsp.size() > 0 && cont.size() <= oppEsp.size() && cont.size() > 0){

        Integer countET = 0;

        for (Opportunity opp: oppEsp) {
            opp.Agente_de_venta__c = cont[countET].Id;
            opp.agente_asignado__c = true;
            opp.StageName = 'Asignación';
            oppToUpdate.add(opp);
            if(countET == cont.size() - 1){
                countET = 0;
            }else{
                countET++;
            }
        }

        update oppToUpdate;
        return true;
     }
     else {
         return false;
     }
    }
}