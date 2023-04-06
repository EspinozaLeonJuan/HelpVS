// ACTUALIZADO 13/04/2017 por eduardo@gocode.cl.
// Este trigger es utilizado unicamente para cuando existe contacto pero no existe su cuenta.
// Por tanto actualiza la cuenta del contacto relacionado al caso.
// No se utiliza para Web2Case e Email2Case.
// 
/*******************************************************************************************
 *  NOMBRE                 : AccountAssignCasoSFHandler
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : CASOS
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 04/12/2018 - I. SALAZAR       - Se agregan nuevos origenes
 * 
 * *****************************************************************************************/
public class AccountAssignCasoSFHandler implements TriggerHandler.HandlerInterface {

	private static final Set<String> ORIGENES = new Set<String>{'Contacto SBS','Contacto Vida','Servicios Colectivos','Cobranzas Vida','Recepción Pagos','Producción Individuales', 'Servicios BCI', 'Servicios Telefónica', 'Asistencia Agente'};

	public void handle() {
		Map<Id, Case> casoMap = new Map<Id, Case>();

		for (Case caso : (Case[])Trigger.new) {
			// Se descarta la ejecución de este trigger para los origenes de Contacto Vida y Servicios Colectivos.
			// por Web2Case, se envia el campo origin en "Servicios Colectivos".
			// por Email2Case, se especifica en la configuración del Email2Case.
			if (ORIGENES.contains(caso.Origin) || String.isNotBlank(caso.SuppliedEmail)) continue;
			if (caso.AccountId != null && caso.ContactId == null) continue;
			if (caso.AccountId == null && caso.ContactId != null)
				casoMap.put(caso.ContactId, caso);
			if (caso.ContactId == null && caso.AccountId == null) {
				caso.addError('No se puede crear el caso, debe indicar la cuenta o el contacto');
				continue;
			}
		}

		if (casoMap.size() == 0) return;

		Contact[] contacts = [SELECT Id, AccountId FROM Contact WHERE Id IN :casoMap.keySet()];

		for (Contact contact : contacts) {
			System.assert(casoMap.containsKey(contact.Id), 'El mapa de casos no contiene la llave ' + contact.Id);
			Case caso = casoMap.get(contact.Id);
			caso.AccountId = contact.AccountId;
			if (caso.AccountId == null && !ORIGENES.contains(caso.Origin))
				TriggerHandler.addError('El nombre de la cuenta es obligatorio (Paso 2).', caso);
		}

	}
}