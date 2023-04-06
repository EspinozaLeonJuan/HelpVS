trigger AddRelationshipKeyToNotificacion on Lista_de_Distribucion__c (before insert, before update) {
	RecordType notificacionesCorredorRecord = [SELECT Id FROM RecordType WHERE Name = 'Notificaciones de Corredor'];
    RecordType notificacionesCuentaRecord = [SELECT Id FROM RecordType WHERE Name = 'Notificaciones de Cuenta'];

    Set<Id> idContactoNotificaciones = new Set<Id>();
    Map<Id,List<Lista_de_Distribucion__c>> mapContactoNotificaciones = new Map<Id,List<Lista_de_Distribucion__c>>();

	for (Lista_de_Distribucion__c notificacion : Trigger.new) {
        
        //Armamos el mapa de idContacto - Notificaciones
        Id contactId = notificacion.Contacto__c;
        if (!mapContactoNotificaciones.containsKey(contactId))
            mapContactoNotificaciones.put(contactId,new List<Lista_de_Distribucion__c>());

        List<Lista_de_Distribucion__c> notificacionesCurrentContact = mapContactoNotificaciones.get(contactId);
        notificacionesCurrentContact.add(notificacion);
        mapContactoNotificaciones.put(contactId,notificacionesCurrentContact);

        //Armamos el set de idContacto para la query de contactos
        idContactoNotificaciones.add(notificacion.Contacto__c);

        //Según tipo de registro, agregamos la llave duplicidad 
        if (notificacion.RecordTypeId == notificacionesCorredorRecord.Id) 
            notificacion.Llave_Relacion_Notificacion__c = String.valueOf(notificacion.Corredor__c) + '-' + String.valueOf(notificacion.Contacto__c) + '-' + String.valueOf(notificacion.Tipo_de_Notificacion__c);
        if (notificacion.RecordTypeId == notificacionesCuentaRecord.Id)
            notificacion.Llave_Relacion_Notificacion__c = String.valueOf(notificacion.Cuenta__c) + '-' + String.valueOf(notificacion.Contacto__c) + '-' + String.valueOf(notificacion.Tipo_de_Notificacion__c);
	}

    List<Contact> contactos = [SELECT Id, Email FROM Contact WHERE Id IN :idContactoNotificaciones];
    //recorremos los contactos revisando si no tienen mail
    //en tal caso, todas las notificaciones relacionadas se le agrega error
    for (Contact contacto : contactos) {
        if (contacto.Email == null){
            List<Lista_de_Distribucion__c> notificacionesCurrentContact = mapContactoNotificaciones.get(contacto.Id);
            for (Lista_de_Distribucion__c notificacion : notificacionesCurrentContact) 
                notificacion.addError('No es posible asignar un contacto sin Email a la notificación');
        }
    }
}