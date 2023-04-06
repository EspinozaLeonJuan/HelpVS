public with sharing class CobranzaService {
	
	public static EmailResult[] sendEmails(Id[] corredorIds, Bitacora.Evento event) {
		return sendEmails(corredorIds, event.name());
	}

	
	public static EmailResult[] sendEmails(Id[] corredorIds, String eventName) {
		return sendEmails(corredorIds, eventName, (Map<Id, Id>)null);
	}
	
	public static EmailResult[] sendEmails(Id[] corredorIds, Bitacora.Evento event, Map<Id, Id> whatMap) {
		return sendEmails(corredorIds, event.name(), whatMap);
	}
	

	/**
	* Este método envía los emails de aviso de notificación a los corredores y a los clientes según el evento especificado.
	* targetId siempre será el Contacto encontrado en la lista de distribución
	* parentIds es la lista de corredores o cuentas padre de los contactos que serán notificados.
	* whatMap es un mapa de parentId => objectId en caso de que no deseemos que el parent actue como whatId, en caso de tener valor objectId actua como whatId
	* Retorna un objeto EmailResult[] con elresultado del envío.
	*/
	public static EmailResult[] sendEmails(Id[] parentIds, String eventName, Map<Id, Id> whatMap) {
		if (parentIds == null || parentIds.isEmpty())
			return null;
		Map<Id, Id[]> arrayMap = new Map<Id, Id[]>();
		if (whatMap == null)
			whatMap = new Map<Id, Id>();
		for (Id key : whatMap.keySet()) {
			Id value = whatMap.get(key);
			arrayMap.put(key, new Id[] {value});
		}
		for (Id parentId : parentIds) {
			if (arrayMap.containsKey(parentId))
				continue;
			arrayMap.put(parentId, new Id[] {parentId});
					}
		return sendEmails(parentIds, eventName, arrayMap);
			}
	
	public static EmailResult[] sendEmails(Id[] parentIds, String eventName, Map<Id, Id[]> whatMap) {
		Evento_de_Notificacion__mdt[] eventos = [SELECT Id, DeveloperName, MasterLabel, Plantilla_de_Correo__c FROM Evento_de_Notificacion__mdt WHERE MasterLabel = :eventName];
		if (eventos.isEmpty()) {
			String developerName = eventName + '%';
			eventos = [SELECT Id, DeveloperName, MasterLabel, Plantilla_de_Correo__c FROM Evento_de_Notificacion__mdt WHERE DeveloperName LIKE :developerName];
		}
		if (eventos.isEmpty())
			throw new CobranzaException('No es posible notificar al destinatario en el evento ' + eventName + ', pues no existe una configuración de metadatos "Evento de Notificacion" configurado en el sistema.');
		return sendEmails(parentIds, eventos[0], whatMap);
	}
	
	private static Bitacora[] bitacoras = new List<Bitacora>();
	
	private static Boolean validate(Boolean condition, String message) {
	return validate(null, null, condition, message);
		}
		
	private static Boolean validate(Id parentId, String eventName, Boolean condition, String message) {
	Id corredorId = parentId != null && parentId.getSobjectType() == Schema.Corredor__c.getSobjectType() ? parentId : null;
	Id accountId = parentId != null && parentId.getSobjectType() == Schema.Account.getSobjectType() ? parentId : null;
	Corredor__c corredor = corredorId == null ? null : new Corredor__c(Id = corredorId);
	Account account = accountId == null ? null : new Account(Id = accountId);
			Bitacora.Evento evento = Bitacora.enumMap.get(eventName);
			if (eventName != null)
				System.assertNotEquals(null, evento, 'No se encontro el evento ' + eventName);
    
    system.debug('@@@@ validate fields into : ' + corredor + ' condition : ' + condition + ' eventName : ' + eventName );          
    if (condition && (corredor == null || !System.isBatch() || eventName == null)) 
			throw new CobranzaException(message + '. CorredorId: ' + corredorId + ', Event Name: ' + eventName);
			else if (condition && System.isBatch() && corredor != null && evento != null) {
			BitacoraCobranza bitacora = new BitacoraCobranza(evento, corredor);
			bitacora.addError(message);
			bitacoras.add(bitacora);
			return false;
						}
						return true;
	}
	
	private static EmailResult[] sendEmails(Id[] parentIds, Evento_de_Notificacion__mdt evento, Map<Id, Id[]> whatMap) {
		String templateName = evento.Plantilla_de_Correo__c; 
		String eventName = evento.DeveloperName;
		System.assertNotEquals(null, eventName, 'El nombre del evento no se ha especificado en: ' + evento);
		List<EmailUtils.Target> targets = new List<EmailUtils.Target>();
		List<Id> whatIds = new List<Id>();
		Lista_de_Distribucion__c[] listasDistribucion = [SELECT Id, Tipo_Destinatario__c, Contacto__r.Email, Contacto__r.Name, Id_Destinatario__c, Contacto__c FROM Lista_de_Distribucion__c WHERE Id_Destinatario__c IN :parentIds AND Tipo_de_Notificacion__c = :evento.MasterLabel];
		system.debug( '@@@@ listasDistribucion : ' + listasDistribucion );
    if ( listasDistribucion.isEmpty() ) {
      for ( Id parentIdNew : parentIds ){ Id corredorId = parentIdNew != null && parentIdNew.getSobjectType() == Schema.Corredor__c.getSobjectType() ? parentIdNew : null;
        
        Corredor__c corredor = corredorId == null ? null : new Corredor__c(Id = corredorId);
        system.debug('@@@isBatch : ' + System.isBatch() ); Bitacora.Evento evento1 = Bitacora.enumMap.get(eventName);
        
        if (System.isBatch() && corredor != null && evento1 != null) { BitacoraCobranza bitacoraNew = new BitacoraCobranza(evento1, corredor);
          
          bitacoraNew.addError('No se ha enviado ningún Email debido a que no se ha especificado un "contacto asignado a la lista de NOTIFICACIONES para el evento de ' + evento.MasterLabel + ' y el(los) Corredor(es) (IDs): ' + parentIds); bitacoras.add(bitacoraNew);
          
        }
      }
      if (!bitacoras.isEmpty())
      BitacoraService.registrarEventos(bitacoras);
    }
    validate(listasDistribucion.isEmpty(), 'No se ha especificado un contacto asignado a la lista de notificaciones para el evento de ' + evento.MasterLabel + ' y el ID: ' + parentIds);
		Map<Id, Lista_de_Distribucion__c[]> listaMap = new Map<Id, Lista_de_Distribucion__c[]>();
		for (Lista_de_Distribucion__c lista : listasDistribucion) {
			Id parentId = lista.Id_Destinatario__c; // Id_Destinatario__c puede ser Cuenta__c o Corredor__c
			Lista_de_Distribucion__c[] listaLocal = listaMap.get(parentId);
			if (!listamap.containsKey(parentId)) {
				listaLocal = new List<Lista_de_Distribucion__c>();
				listaMap.put(parentId, listaLocal);
			}
			listaLocal.add(lista);
		}

    system.debug('@@@@ validate ejecutivos');
    Map<Id,Corredor__c> ejecutivosOfCorredor = new Map<Id,Corredor__c>([SELECT Id, Ejecutivo_de_Cobranza__r.Email FROM Corredor__c WHERE Ejecutivo_de_Cobranza__r.Email <> null]);
    system.debug('@@@@ ejecutivosOfCorredor : ' + ejecutivosOfCorredor );

		for (Id parentId : parentIds) {
      system.debug( '@@@@ whatMap : ' + whatMap );
			Id[] whatList = whatMap == null || whatMap.isEmpty() ? new Id[] {parentId} : whatMap.get(parentId);
      system.debug( '@@@@ whatList : ' + whatList );
			System.assertNotEquals(null, whatList, 'No se asignó la lista de Ids al whatMap');
			Lista_de_Distribucion__c[] listas = listaMap.get(parentId);
      system.debug('@@@@ validate fields : ' + parentId + ' eventName : ' + eventName + ' listas : ' + listas );
			if (!validate(parentId, eventName, listas == null || listas.isEmpty(), ' No se ha especificado un contacto asignado a la lista de notificaciones para el evento de ' + evento.MasterLabel + ' y el ID: ' + parentId))
			continue;
      system.debug('@@@@ validate continue');
      for (Id whatId : whatList) {
        system.debug('@@@@ whatId' + whatId);
				System.assertNotEquals(null, whatId, 'No se ha especificado el whatId');
								EmailUtils.Target target = new EmailUtils.Target();
				for (Lista_de_Distribucion__c lista : listas) {
					if (!validate(parentId, eventName, lista == null, 'No se ha especificado una lista de distribución para el id ' +parentId)) continue;
					if (!validate(parentId, eventName, String.isBlank(lista.Tipo_Destinatario__c), 'El tipo de destinatario es obligatorio para el contacto ' + lista.Contacto__r.Name + ' en la lista de notificaciones.')) continue;
					if (!validate(parentId, eventName, target.recipientId != null && lista.Tipo_Destinatario__c == 'Para', 'Solo puede haber un tipo de destinatario especificado con Para. Por favor establezca el tipo de destinatario en CC o CCO para el contacto ' + lista.Contacto__r.Name)) continue;
					if (target.recipientId == null && lista.Tipo_Destinatario__c == 'Para')
					target.recipientId = lista== null ? null : lista.Contacto__c;
					else if (lista.Tipo_Destinatario__c == 'CC')
					target.addCc(lista== null ? null : lista.Contacto__c);
					else if (lista.Tipo_Destinatario__c == 'CCO')
					target.addBcc(lista== null ? null : lista.Contacto__c);
				}
        if (validate(parentId, eventName, target.recipientId == null, 'No se ha especificado un destinatario en la lista de distribución en el evento ' + eventName)) {
					system.debug('@@@ 1 : ' + ejecutivosOfCorredor);
          system.debug('@@@ 2 : ' + parentId);
          Corredor__c recordEjecutivo = ejecutivosOfCorredor.get(parentId);
          system.debug('@@@ email : ' + recordEjecutivo);
          if ( !ejecutivosOfCorredor.isEmpty() && recordEjecutivo != null ) {
            system.debug( '@@@@ corredorEjecutivoCobranza : ' + recordEjecutivo.Ejecutivo_de_Cobranza__r.Email );
            target.addBcc( recordEjecutivo.Ejecutivo_de_Cobranza__r.Email );
          }
          targets.add(target);
					whatIds.add(whatId);
					}
			}
		}
		System.assertEquals(targets.size(),whatIds.size(), 'Las listas no son del mismo tamaño');
    system.debug('bitacoras : ' + bitacoras);
		if (!bitacoras.isEmpty()) { BitacoraService.registrarEventos(bitacoras); }
		
		if (targets.isEmpty()) { return new List<EmailResult>(); }
			
      system.debug('targets : ' + targets + ' whatIds :  ' + whatIds + ' templateName ' + templateName);
				return EmailUtils.sendEmails(targets, whatIds, templateName);
	}

	public static Boolean userToNotify(Id[] parentIds, String eventName){
		Evento_de_Notificacion__mdt[] eventos = [SELECT Id, DeveloperName, MasterLabel, Plantilla_de_Correo__c FROM Evento_de_Notificacion__mdt WHERE MasterLabel = :eventName];
		SYSTEM.DEBUG('@@@ parentIds : '+ parentIds + '@@@ eventName : ' + eventName );
    if (eventos.isEmpty()) { String developerName = eventName + '%'; eventos = [SELECT Id, DeveloperName, MasterLabel, Plantilla_de_Correo__c FROM Evento_de_Notificacion__mdt WHERE DeveloperName LIKE :developerName];
		}
		if (eventos.isEmpty()) { throw new CobranzaException('No es posible notificar al destinatario en el evento ' + eventName + ', pues no existe una configuración de metadatos "Evento de Notificacion" configurado en el sistema.');
    }
			
		Lista_de_Distribucion__c[] notificaciones = [SELECT Id, Id_Destinatario__c, Contacto__c FROM Lista_de_Distribucion__c 
		WHERE Id_Destinatario__c =:parentIds AND Tipo_de_Notificacion__c = :eventos[0].MasterLabel];
		SYSTEM.DEBUG('@@@ notificaciones : '+ notificaciones );
		return !notificaciones.isEmpty();
	}

	public static Boolean notifyProcessResult(String processName, List<String> errorCollection){
		
		Notificacion_Procesos__c notificacionProcesos = Notificacion_Procesos__c.getOrgDefaults();
		System.debug('notificacionProcesos:'+notificacionProcesos);

		if (notificacionProcesos == null){ System.debug('notifyProcessResult - Notificacion_Procesos__c default value not found '); throw new CobranzaException('No se ha definido un email de notificación en la configuración personalizada');
		}
		String addressTo = notificacionProcesos.Email__c;
        
        if (Test.isRunningTest())
        {
            addressTo = 'email@prueba.cl';
        }
        
        System.assertNotEquals(null, addressTo, 'El email de notificación de procesos es nulo.');    
           
		String subject = 'Resultado proceso ' + processName;
		String plainBody = '';
		if (errorCollection.isEmpty()){ plainBody = 'El proceso ' + processName.toUpperCase() + ' se ha ejecutado con éxito.';
		}
		else {
			plainBody = 'Se ha detectado uno o más errores en la ejecución del proceso ' + processName.toUpperCase() + '.\n';
			plainBody += 'Error(es) detectado(s):\n';
			plainBody += String.join(errorCollection, '\n');
		}
		Messaging.SendEmailResult emailResult = EmailUtils.sendSingleEmail(addressTo, subject, plainBody);
		if (Test.isRunningTest())
			return true;
		return emailResult.isSuccess();

	}

}