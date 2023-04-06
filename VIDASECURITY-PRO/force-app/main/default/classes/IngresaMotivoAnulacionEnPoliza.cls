public class IngresaMotivoAnulacionEnPoliza implements TriggerHandler.HandlerInterface {
	
    public void handle() {
        
        if(UserInfo.getName() != 'Integracion Servicios'){
                  
            Map<Id, Poliza__c> mapUpdate = new Map<Id, Poliza__c>();
            
            Participantes_de_campa_a__c[] participantes = 
                [SELECT Id, Estado_de_Gesti_n__c, Campa_a_Vida_Security__r.Name, RecordType.Name, 
                        Poliza__r.Id, Poliza__r.RecordType.Name, Poliza__r.Tipo_de_anulacion__c, Poliza__r.Motivo_de_anulacion__c
                 FROM Participantes_de_campa_a__c 
                 WHERE Campa_a_Vida_Security__r.Name = 'Campaña Rescates / Traspasos' AND 
                       (recordType.Name = 'Rescates' OR recordType.Name = 'Traspasos Out') AND
                       poliza__r.RecordType.Name = 'Individuales' AND	
                       Id in: Trigger.newMap.keySet()];
            
            for(Participantes_de_campa_a__c p : participantes) {           
                if(p.Campa_a_Vida_Security__r.Name == 'Campaña Rescates / Traspasos' && (p.recordType.Name == 'Rescates' || p.recordType.Name == 'Traspasos Out')){       		
                    Poliza__c poliza = p.Poliza__r;
                    if(poliza != null && poliza.RecordType.Name == 'Individuales' && !mapUpdate.containsKey(poliza.Id)){
                        if(p.RecordType.Name == 'Rescates'){
                            poliza.Tipo_de_anulacion__c = 'Rescate Total';
                            poliza.Motivo_de_anulacion__c = p.Estado_de_Gesti_n__c;
                            mapUpdate.put(poliza.Id, poliza);
                        }
                        else if(p.RecordType.Name == 'Traspasos Out'){
                            poliza.Tipo_de_anulacion__c = 'Traspaso Total';
                            poliza.Motivo_de_anulacion__c = p.Estado_de_Gesti_n__c;
                            mapUpdate.put(poliza.Id, poliza);
                        }
                    }
                }
            }
            if(mapUpdate.size() > 0){
                update mapUpdate.values();
            }
        }
    }    
}