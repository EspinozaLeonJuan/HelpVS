public class AsignaContactoAMiembroDeCampanaHandler implements TriggerHandler.HandlerInterface {
    
    private static final String TEMPORAL_CONTACT_NAME = 'Contacto Temporal';
    
    public void handle() {  
        Set<String> numeros = new Set<String>();
    
        for (CampaignMember member : (CampaignMember[])Trigger.new) {           
            member.Numero_de_Poliza__c = member.Numero_de_Poliza__c;
        }
            
    }
}