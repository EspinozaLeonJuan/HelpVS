public class ActualizaPropietarioParticipantes implements TriggerHandler.HandlerInterface{
	
    public void handle() {
        if (Trigger.isUpdate) {
            Set<Id> recordIds = Trigger.newMap.keySet();
            if(!recordIds.isEmpty()){
                          
                Participantes_de_Campa_a__c[] participantes = [SELECT Id, Cuenta__r.Id, OwnerId, Cuenta__r.OwnerId
                                                               FROM Participantes_de_Campa_a__c 
                                                               WHERE Poliza__r.Estatus__c = 'ACTIVA' AND
                                                               		 Estado_Cierre__c != 'Finalizado' AND 
                                                                     Estado_Cierre__c != 'Finalizado (Cierre Administrativo)' AND 
                                                                     Cuenta__r.Id in: recordIds];
    
                if(participantes.size() > 0){
                    List<Participantes_de_Campa_a__c> participantesUpdate = new List<Participantes_de_Campa_a__c>();
                    
                    for(Participantes_de_Campa_a__c p : participantes){
                        if(p.OwnerId != p.Cuenta__r.OwnerId){
                            p.OwnerId = p.Cuenta__r.OwnerId;
                            participantesUpdate.Add(p);
                        }               
                    }
                                  
                    if(participantesUpdate.Size() > 0)
                        update participantesUpdate;
                }
            }
        }
    }
}