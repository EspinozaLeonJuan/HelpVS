global class JobAlertaCasosAbiertos implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        system.debug('Inicio');
        
        integer minimo = 20;
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> sUsers = new Map<Id,User>([select id from User where IsActive = true and Profile.Name in ('Ejecutiva Atención al Cliente', 'Ejecutiva Atención al Cliente Totalpack', 'Ejecutiva Post Venta', 'Ejecutivo Call Center', 'Ejecutivo Call Center (WEB)','Ejecutiva Atención al Cliente Totalpack LGN','Ejecutivo Call Center LGN', 'Administrador del sistema')]).keySet() ;
        List<AggregateResult> casos = ([select OwnerId, Owner.Name nombre, count(Id) cantidadCasos from case where OwnerId in :sUsers and Entrega_Respuesta__c = false and RecordTypeId != :Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId() and Status ='Nuevo' and CreatedDate < TODAY group by OwnerId, Owner.Email, Owner.Name]);
        
        // Correos a ejecutivas
        for (AggregateResult u : casos) {
            if ((Integer)u.get('cantidadCasos') > minimo){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId((Id)u.get('OwnerId'));
                mail.setSaveAsActivity(false);
                mail.setSubject('Recordatorio de casos abiertos');
                mail.setPlainTextBody('Tiene ' + u.get('cantidadCasos') + ' casos (Solicitudes o Consultas) sin cerrar, puede verlos en la pestaña Casos, vista "Mis casos abiertos"');
                emails.add(mail);
            }
        }
        
        // Correo a Jefaturas/admins
        if (casos.size() > 0) {
            
            string bodyMail = 'La revisión semanal del sistema ha detectado que las siguientes ejecutivas tienen actualmente mas de ' + minimo + ' casos (Solicitudes o Consultas) sin cerrar: <br/><br/>';
            
            for (AggregateResult u : casos) {
                if ((Integer)u.get('cantidadCasos') > minimo){
                    bodymail += u.get('nombre') + ': ' + u.get('cantidadCasos') + ' casos<br/>';
                }
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.toAddresses = new String[] { 'mpereira@security.cl', 'cubal@security.cl', 'aruz@security.cl', 'mshackleford@security.cl' };
            mail.setSaveAsActivity(false);
            mail.setSubject('Resumen de casos abiertos');
            mail.setHtmlBody(bodyMail);
            emails.add(mail);
        }
        
        Messaging.SendEmailResult[] res = Messaging.sendEmail(emails);
        system.debug('Fin');
    }
    
}