public class ActualizaDatosSuspensionPolizaHandler implements TriggerHandler.HandlerInterface{
    
    public void handle() {
        String recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Solicitudes' LIMIT 1].Id;
        List<Id> idsPoliza = new List<String>();
        for(Case caso: (Case[]) Trigger.new){
            if(caso.RecordTypeId==recordTypeId && !idsPoliza.contains(caso.CASO_N_Poliza__c)){
                idsPoliza.add(caso.CASO_N_Poliza__c);
            }
        }        
        Map<Id, Poliza__c> polizasMap = new Map<Id, Poliza__c>([SELECT Id, Cantidad_de_meses_suspendido__c, Fecha_de_inicio_de_suspensi_n__c FROM Poliza__c WHERE Id in: idsPoliza]);
        
        if(polizasMap.size()>0){
            List<Poliza__c> polizasUpdate = new List<Poliza__c>();       
            for(Case c: (Case[]) Trigger.new){
                Poliza__c p = polizasMap.get(c.CASO_N_Poliza__c);
                if(p != null && !String.isBlank(c.Cantidad_de_meses_suspendido__c) && c.Fecha_de_inicio_de_suspensi_n__c!=null){
                    if(c.Cantidad_de_meses_suspendido__c != p.Cantidad_de_meses_suspendido__c || c.Fecha_de_inicio_de_suspensi_n__c != p.Fecha_de_inicio_de_suspensi_n__c){
                        p.Cantidad_de_meses_suspendido__c = c.Cantidad_de_meses_suspendido__c;
                        p.Fecha_de_inicio_de_suspensi_n__c = c.Fecha_de_inicio_de_suspensi_n__c;
                        if(!polizasUpdate.contains(p)){
                            polizasUpdate.add(p);
                        }
                    }
                }
            }
            if(polizasUpdate.size()>0){
                update polizasUpdate;
            }
        }
    }
}