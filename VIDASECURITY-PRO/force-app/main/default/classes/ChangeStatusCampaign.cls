public class ChangeStatusCampaign {
    public static List<Participantes_de_Campa_a__c> ChangeStatus(String start_date, String end_date, String state, String id_campaign) {
        List<Participantes_de_Campa_a__c> participantes = [select id, Campa_a_Vida_Security__r.id, CreatedDate, Estado_Cierre__c
                                                           from Participantes_de_Campa_a__c where 
                                                           Campa_a_Vida_Security__r.id = :id_campaign AND
                                                          (Estado_Cierre__c = 'En proceso' OR
                                                          Estado_Cierre__c = 'Abierto')];
      	Date start = Date.valueOf(start_date);
        Date end_d = Date.valueOf(end_date);
		List<Participantes_de_Campa_a__c> updateParticipantes = new List<Participantes_de_Campa_a__c>();						      
        for ( Participantes_de_Campa_a__c parts: participantes ) {
            if (parts.CreatedDate.date() >= start && parts.CreatedDate.date() <= end_d){
                parts.Estado_Cierre__c = state; updateParticipantes.add(parts);
            }
        }
        update updateParticipantes;
        system.debug(updateParticipantes); 
        return updateParticipantes;
    } 
}