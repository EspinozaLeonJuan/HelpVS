/*
@author: eoffermann@gmail.com
@description:

- Asignado a: campo Owner y corresponde al propietario de la cuenta del caso vida security
- contacto: campo Who y corresponde al contacto del caso vida security
- Linea de Negocio: campo Linea_de_Negocio__c, cuando el caso es de tipo de registro Consultas se extrae del campo Linea_Negocio__c
- del caso, cuando es el tipo de registro Solicitudes o Reclamos se extrae del campo Negocio__c
- concepto: campo concepto__c, cuando el caso es de tipo de registro Consultas se extrae del campo Concepto__c del caso, cuando es el
- tipo de registro Solicitudes o Reclamos se extrae del campo Detalle_Solicitud__c
- descripcion: campo Descripcion__c, se extrae del campo Descripcion__c del caso
*/
public class CopiaCasoSFATareaHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
        List<Task> tareasCaso = new List<Task>();
        List<Task> tareasPC = new List<Task>();
        List<Id> casoIds = new List<Id>();
        List<Id> pcIds = new List<Id>();
        
        String recordTypeOnco = [SELECT Id FROM RecordType WHERE Name = 'Ventas Oncológico'].Id;   
            
        for(Task t : (Task[])Trigger.new) {
                    
            if(t.RecordTypeId != recordTypeOnco) {
                if(t.WhatId != null && t.WhatId.getSobjectType() == Schema.Case.sObjectType && t.WhoId == null && t.Subject == 'Llamada'){
                    tareasCaso.add(t);
                    casoIds.add(t.WhatId);
                }  
                if(t.WhatId != null && t.WhatId.getSobjectType() == Schema.Participantes_de_Campa_a__c.sObjectType &&
                    t.WhoId == null && t.Subject == 'Llamada'){
                        tareasPC.add(t);
                        pcIds.add(t.WhatId);
                }
            }           
        }
    
        //CASOS
        if (tareasCaso.size() > 0){
    
            Map<Id, Case> mapCasos =
                new Map<Id, Case>([SELECT Id, Account.OwnerId,
                                   Contact.Id, Linea_Negocio__c,
                                   Negocio__c, Concepto__c, Detalle_Solicitud__c,
                                   RecordType.Name, Description
                                   FROM Case WHERE Id IN :casoIds]);
    
            for (Task tarea : tareasCaso) {
                Case caso = mapCasos.get(tarea.WhatId);
    
                Map<String,String> mapLineaNegocio = new Map<String,String>{'Consultas' => caso.Linea_Negocio__c, 'Reclamos' => caso.Negocio__c, 'Solicitudes' => caso.Negocio__c};
                Map<String,String> mapConcepto = new Map<String,String>{'Consultas' => caso.Concepto__c, 'Reclamos' => caso.Detalle_Solicitud__c, 'Solicitudes' => caso.Detalle_Solicitud__c};
    
                tarea.OwnerId = caso.Account.OwnerId;
                tarea.WhoId = caso.Contact.Id;
                tarea.Linea_de_Negocio__c = mapLineaNegocio.get(caso.RecordType.Name);
                tarea.Concepto__c = mapConcepto.get(caso.RecordType.Name);
                tarea.Description = caso.Description;
            }
        }
    
        //Participantes de campaña
        if(tareasPC.size() > 0 || Test.isRunningTest()){
    
            Map<Id, Participantes_de_Campa_a__c> mapPCs =
                new Map<Id, Participantes_de_Campa_a__c>([SELECT Id, Contacto__r.OwnerId, Contacto__r.Id, Campa_a_Vida_Security__r.Name, Contactado__c FROM Participantes_de_Campa_a__c WHERE Id IN :pcIds]);
    
            for (Task tarea : tareasPC) {
                Participantes_de_Campa_a__c pc = mapPCs.get(tarea.WhatId);
    
                if (pc.Campa_a_Vida_Security__r.Name.StartsWithIgnoreCase('9_MESES') && pc.Contactado__c == 'Si' && tarea.Status == 'Reasignar a Ejec. PV') {
                    System.debug('Reasignación Propietario Tarea a Propietario Cuenta');
                    tarea.Status = 'No iniciada';
                    tarea.OwnerId = pc.Contacto__r.OwnerId;
                    tarea.WhoId = pc.Contacto__r.Id;
                }
            }
        }
	}
}