public without sharing class AsignaRutCuentaATaskYEventHandler implements TriggerHandler.HandlerInterface,
	TriggerHandler.CountExecutionInterface {

	private Log logger = new Log(AsignaRutCuentaATaskYEventHandler.class);

	public Integer getCount() {
		return 1;
	}

	public void handle() {


		List<SObject> actividades = Trigger.new;
		
		Set<Id> idsActividades = new Set<Id>();
	
		try {
			
			if (actividades == null || actividades.size() == 0) return;

            for (Integer i = 0; i < actividades.size(); i++) {
				SObject actividad = actividades[i];
                idsActividades.add((Id)actividad.get('WhatId'));            
            }
          
			Map<Id, Account> mapCuentas = new Map<Id, Account>([Select Id, Rut_con_dv__c From Account Where Id IN :idsActividades]);
			
			for (Integer i = 0; i < actividades.size(); i++) {
				SObject actividad = actividades[i];				
				Account cuenta = mapCuentas.get((Id)actividad.get('WhatId'));
				actividad.put('Rut_Cuenta__c', cuenta!=null ? cuenta.Rut_con_dv__c : null);
			}						

		} catch (Exception ex) {
			logger.error('Ha ocurrido una exception en el handler de AsignaRutCuentaATaskYEventHandler. ', ex);
		}
	}
}