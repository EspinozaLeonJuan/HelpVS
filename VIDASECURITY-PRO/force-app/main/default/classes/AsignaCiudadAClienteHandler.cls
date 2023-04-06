public class AsignaCiudadAClienteHandler implements TriggerHandler.HandlerInterface {
    public void handle() { 
        Ciudad__c[] ciudades = [SELECT Id, Name FROM Ciudad__c];
        Map<String, Ciudad__c> ciudadMap = new Map<String, Ciudad__c>();
        
        for (Ciudad__c ciudad : ciudades) {
            ciudadMap.put(ciudad.Name, ciudad);
        }      
               
        for (Account account : (Account[])Trigger.new) {
            Ciudad__c ciudad = ciudadMap.get(account.Ciudad_Particular__pc);
            if (ciudad != null)
                account.Ciudad_Particular_B__c = ciudad.Id;
        }
    }   
}