public class AsignaFechaTopeHandler implements TriggerHandler.HandlerInterface,
	TriggerHandler.CountExecutionInterface  {


	public Map<String, Complejidad_Operacion__mdt> mapComplejidadDias = new Map<String, Complejidad_Operacion__mdt>();
    public Map<String, Complejidad_Operacion__mdt> mapCanalesFechaTope = new Map<String, Complejidad_Operacion__mdt>();

	Id recordTypeReclamos = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();

	public Integer getCount() {
		return 1;
	}

	public void handle() {


		List<Complejidad_Operacion__mdt> complejidadOperaciones = [Select Id, Complejidad__c, Dias_Habiles__c, Tipo_Operacion__c From Complejidad_Operacion__mdt];
		List<Complejidad_Operacion__mdt> canalesFechaTope = [Select Id, Label, Complejidad__c, Dias_Habiles_Legales__c, IsChannel__c From Complejidad_Operacion__mdt Where IsChannel__c = true];

		for (Complejidad_Operacion__mdt complejidad : complejidadOperaciones)
			mapComplejidadDias.put(complejidad.Tipo_Operacion__c, complejidad);

		for (Complejidad_Operacion__mdt canal : canalesFechaTope)
			mapCanalesFechaTope.put(canal.Label, canal);

		Map<Id, Case> mapCasos = new Map<Id, Case>();
    Id profileId = userinfo.getProfileId();
    Set<String> profiles = new Set<String>{
      '00e0H000001e5C2QAI', // Ejecutivo Calidad
      '00e0H000001lylGQAQ', // Gerencia y Jefatura SAC
      '00e0H000001lylLQAQ', // Jefe de calidad
      '00ei0000000r1FhAAI', // Administrador del sistema
      '00e0H000001e6mzQAA'  // Gestor Funcional
    };
    Boolean isAccess = false;
    isAccess = profiles.contains(profileId) ? true : false;
		for (Case caso : (Case[])Trigger.new) {

			Case oldCase  = (Case)(Trigger.isUpdate ? Trigger.oldMap.get(caso.Id) : null);
			if ( ( (oldCase != null && (caso.Canal__c != 'SVS' && caso.Canal__c != 'CMF') && caso.Fecha_tope_Vida_Security__c != oldCase.Fecha_tope_Vida_Security__c && String.isNotBlank(String.valueOf(caso.Fecha_tope_Vida_Security__c))) ||
			        (oldCase == null && caso.Canal__c != 'SVS' && String.isNotBlank(String.valueOf(caso.Fecha_tope_Vida_Security__c))) ) && isAccess == false
			   )
				caso.addError('No puede especificar la fecha si el canal es distinto de SVS/CMF');

			else if ( (oldCase != null && ( (oldCase.Tipo_Operacion__c != caso.Tipo_Operacion__c) || (oldCase.Canal__c != caso.Canal__c)) ) || (oldCase == null && !String.isEmpty(caso.Tipo_Operacion__c) ) )
				mapCasos.put(caso.Id, caso);

		}

		Date today = Date.today();
		for (Case caso : mapCasos.values()) {

			if(caso.RecordTypeId!=recordTypeReclamos)
			continue;

			/*se llena campo fecha cierre tope que depende exclusivamente del canal*/		
			if(  ( (caso.Canal__c == 'CMF' || caso.Canal__c=='SVS') && caso.Fecha_Cierre_Tope__c == null) || (caso.Canal__c != 'CMF' && caso.Canal__c!='SVS')  ) {
				Complejidad_Operacion__mdt canal =  mapCanalesFechaTope.containsKey(caso.Canal__c) ? mapCanalesFechaTope.get(caso.Canal__c) : null;
				if(canal != null) {	
					Integer diasHabilesLegales = Integer.valueOf(canal.Dias_Habiles_Legales__c);
					if (diasHabilesLegales != null)
						caso.Fecha_Cierre_Tope__c = HolidayUtils.addBussinessDays(today, diasHabilesLegales);
					else
						caso.addError('Debe configurar el campo Dias Habiles Legales para el Canal ' + caso.Canal__c);
				} else
					caso.addError('No existe definido en la metadata el canal ' + caso.Canal__c);
			/*se llena campo fecha cierre tope que depende exclusivamente del canal*/
			}

			String tipoOperacion = caso.Tipo_Operacion__c;

			if (String.isBlank(tipoOperacion))
				continue;

			Complejidad_Operacion__mdt complejidad;

			if (caso.Canal__c != 'CMF' && caso.Canal__c != 'SVS' && caso.Canal__c != 'Sernac' && caso.Canal__c != 'Sernac Financiero' && caso.Canal__c != 'DDA') {
				
				complejidad =  mapComplejidadDias.containsKey(tipoOperacion) ? mapComplejidadDias.get(tipoOperacion) : null;

				if(complejidad == null)
				continue;

				Integer diasHabiles = Integer.valueOf(complejidad.Dias_Habiles__c);

				if (diasHabiles == null)
					continue;

				caso.Fecha_tope_Vida_Security__c = HolidayUtils.addBussinessDays(today, diasHabiles);
				caso.Complejidad_del_Reclamo__c = String.valueOf(complejidad.Complejidad__c.setScale(0));

			} else if ( caso.Canal__c == 'CMF' || caso.Canal__c == 'SVS' || caso.Canal__c == 'Sernac' || caso.Canal__c == 'Sernac Financiero' || caso.Canal__c == 'DDA') {

				complejidad =  mapComplejidadDias.containsKey(caso.Canal__c) ? mapComplejidadDias.get(caso.Canal__c) : null;

				if(complejidad == null)
				continue;

				caso.Complejidad_del_Reclamo__c = String.valueOf(complejidad.Complejidad__c.setScale(0));
				
				Integer diasHabiles = Integer.valueOf(complejidad.Dias_Habiles__c);

				if( ( ( (caso.Canal__c == 'CMF' || caso.Canal__c == 'SVS') && caso.Fecha_tope_Vida_Security__c == null ) || (caso.Canal__c != 'CMF' && caso.Canal__c != 'SVS')) && diasHabiles != null ){
					caso.Fecha_tope_Vida_Security__c = HolidayUtils.addBussinessDays(today, diasHabiles);
				}
			}
		}

	}


}