@isTest
private class CopiaCasoSFATareaTest {
	
	static {
		TriggerHandler.enable(CopiaCasoSFATareaHandler.class);
	}
    
    private static Account cuenta;
    private static Case casoReclamo;
    private static Case casoConsulta;
    private static Case casoSolicitud;
    
    static {
        Factory.crearAccountAnonimo();
        cuenta = Factory.buildAccount('Cuenta Corporativa');
        insert cuenta;
        cuenta = reloadAccount(cuenta.Id);

        Contact contacto = Factory.buildContact(cuenta);
        insert contacto;

        casoReclamo = Factory.buildCasoSF('Reclamos', cuenta);
        casoReclamo.Contact = contacto;
        casoReclamo.AccountId = cuenta.Id; 
        
        casoConsulta = Factory.buildCasoSF('Consultas', cuenta);
        casoConsulta.Contact = contacto;
        casoConsulta.AccountId = cuenta.Id;
        
        casoSolicitud = Factory.buildCasoSF('Solicitudes', cuenta);
        casoSolicitud.Contact = contacto;
        casoSolicitud.AccountId = cuenta.Id;
        
        insert new Case[] {casoReclamo, casoConsulta, casoSolicitud};
    }
    
    static Account reloadAccount(Id id) {
        return [SELECT Id, OwnerId FROM Account WHERE Id = :id];
    }
    
    static Task reloadTask(Id id) {
        return [SELECT Id, WhoId, WhatId, OwnerId, Linea_de_Negocio__c, Concepto__c FROM Task WHERE Id = :id];
    }
    
    static testMethod void crearTareaBajoOtroObjeto() {
        Task tarea = Factory.buildTask(cuenta.Id);
        Test.startTest();
        insert tarea;
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.WhoId, null, 'EL WhoId no es nulo esta tarea paso por el trigger y no deberia haber pasado.');
    }
    
    static testMethod void crearTareaBajoObjetoCasoVidaSecurityNoLlamada() {
        Task tarea = Factory.buildTask(casoReclamo.Id);
        tarea.Subject = 'No Llamada!';
        Test.startTest();
        insert tarea;       
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.WhoId, null, 'EL WhoId no es nulo esta tarea paso por el trigger y no deberia haber pasado.');
    }
    
    static testMethod void crearTareaBajoObjetoCasoVidaSecurityReclamo() {
        Task tarea = Factory.buildTask(casoReclamo.Id);
        tarea.Subject = 'Llamada';
        Test.startTest();
        insert tarea;
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.OwnerId, cuenta.OwnerId, 'Los owners no son iguales');
       // System.assertEquals(tarea.WhoId, casoReclamo.Nombre_del_Contacto__c, 'El contacto de la tarea no es igual el del caso vida security');
        //System.assertEquals(tarea.Linea_de_Negocio__c, casoReclamo.Negocio__c, 'El campo Linea de Negocio de tarea debe ser igual al campo Negocio de Caso de Vida Security cuando éste es Reclamos.');
        //System.assertEquals(tarea.Concepto__c, casoReclamo.Detalle_Solicitud__c, 'El campo Concepto__c de Tarea debe ser igual al campo Detalle de Solicitud de Caso de VIda Security cuando éste es Reclamos.');        
    }
    
    static testMethod void crearTareaBajoObjetoCasoVidaSecurityConsulta() {
        Task tarea = Factory.buildTask(casoConsulta.Id);
        tarea.Subject = 'Llamada';
        Test.startTest();
        insert tarea;
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.OwnerId, cuenta.OwnerId, 'Los owners no son iguales');
        //System.assertEquals(tarea.WhoId, casoConsulta.Nombre_del_Contacto__c, 'El contacto de la tarea no es igual el del caso vida security');
        //System.assertEquals(tarea.Linea_de_Negocio__c, casoConsulta.Linea_Negocio__c, 'El campo Linea de Negocio de tarea debe ser igual al campo Linea Negocio de Caso de Vida Security cuando éste es Consultas.');
        //System.assertEquals(tarea.Concepto__c, casoConsulta.Concepto__c, 'El campo Concepto__c de Tarea debe ser igual al campo Concepto de Caso de VIda Security cuando éste es Consultas.');

    }
    
    static testMethod void crearTareaBajoObjetoCasoVidaSecuritySolicitud() {
        Task tarea = Factory.buildTask(casoSolicitud.Id);
        tarea.Subject = 'Llamada';
        Test.startTest();
        insert tarea;
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.OwnerId, cuenta.OwnerId, 'Los owners no son iguales');
        //System.assertEquals(tarea.WhoId, casoSolicitud.Nombre_del_Contacto__c, 'El contacto de la tarea no es igual el del caso vida security');
        //System.assertEquals(tarea.Linea_de_Negocio__c, casoSolicitud.Negocio__c, 'El campo Linea de Negocio de tarea debe ser igual al campo Negocio de Caso de Vida Security cuando éste es Solicitudes.');
        //System.assertEquals(tarea.Concepto__c, casoSolicitud.Detalle_Solicitud__c, 'El campo Concepto__c de Tarea debe ser igual al campo Detalle de Solicitud de Caso de VIda Security cuando éste es Solicitudes.');

    }
    
    static testMethod void crearTareaBajoObjetoCasoVidaSecuritySolicitud2() {
        Task tarea = Factory.buildTask(casoSolicitud.Id);
        tarea.Subject = 'Llamada';
        tarea.WhoId = null;
        Test.startTest();
        insert tarea;
        Test.stopTest();
        tarea = reloadTask(tarea.Id);
        System.assertEquals(tarea.OwnerId, cuenta.OwnerId, 'Los owners no son iguales');
        //System.assertEquals(tarea.WhoId, casoSolicitud.Nombre_del_Contacto__c, 'El contacto de la tarea no es igual el del caso vida security');
        //System.assertEquals(tarea.Linea_de_Negocio__c, casoSolicitud.Negocio__c, 'El campo Linea de Negocio de tarea debe ser igual al campo Negocio de Caso de Vida Security cuando éste es Solicitudes.');
        //System.assertEquals(tarea.Concepto__c, casoSolicitud.Detalle_Solicitud__c, 'El campo Concepto__c de Tarea debe ser igual al campo Detalle de Solicitud de Caso de VIda Security cuando éste es Solicitudes.');

    }
}