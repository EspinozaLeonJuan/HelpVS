public class CopiaAgenteACasoHandler implements TriggerHandler.HandlerInterface {
		
	public void handle() {
      	Group colaAsistenciaAgente = [select Id from Group where  Type = 'Queue' AND NAME = 'Asistencia Agente' LIMIT 1];
		Id recordTypeIdAtencion = ReflectionUtils.getRecordTypeId(Schema.Case.sObjectType, 'Atención');
		Id recordTypeIdAgente = ReflectionUtils.getRecordTypeId(Schema.Contact.sObjectType, 'Agente');

		Set<String> correosWeb = new Set<String>();
		for (Case caso : (List<Case>)Trigger.new) {
            if( caso.Origin == 'Asistencia Agente' &&
            	String.isNotBlank(caso.SuppliedEmail) && 
            	caso.RecordTypeId == recordTypeIdAtencion && 
            	caso.OwnerId == colaAsistenciaAgente.Id && 
            	!correosWeb.contains(caso.SuppliedEmail)){
            	correosWeb.add(caso.SuppliedEmail);
            }
        }	

        if(correosWeb.isEmpty())
        return;
      
     	List<Contact> agentes = [Select Id, Email From Contact Where RecordTypeId = :recordTypeIdAgente and Email IN :correosWeb and Cargo_Agente__c = 'Agente'];
     	Map<String, Contact> mapAgentes = new Map<String, Contact>();
     	for(Contact agente : agentes){
     		if(!mapAgentes.containsKey(agente.Email))
     			mapAgentes.put(agente.Email, agente);
		
		}

        if(mapAgentes.isEmpty())
        return;

		for (Case caso : (List<Case>)Trigger.new) {
            if(caso.Origin == 'Asistencia Agente' && String.isNotBlank(caso.SuppliedEmail) && 	caso.RecordTypeId == recordTypeIdAtencion && caso.OwnerId == colaAsistenciaAgente.Id){
            	Contact agente = mapAgentes.get(caso.SuppliedEmail);
            	if(agente!=null)
            		caso.Agente__c = agente.Id;
            }
        }	


    }
}