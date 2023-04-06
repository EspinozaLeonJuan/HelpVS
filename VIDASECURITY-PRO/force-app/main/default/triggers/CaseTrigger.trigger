trigger CaseTrigger on Case (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	new TriggerHandler()
		.bind(TriggerHandler.BEFORE_INSERT, new TriggerHandler.TriggerInterface[] {
					new AsignaCuentaWeb2CaseHandler(),                          // Asigna cuenta a caso cuando viene de un Web2Case. Debe estar el campo Rut_Solicitante__c con algun valor para que opere.
					new AsignaInstanciaReclamoHandler(),
					new RevisaCuentaAsignadaEmail2CaseHandler(),
					new LlenadoAutomaticoColectivosHandler(),
					new RequerimientosAutomaticosCaseHandler(),
					new CopiaAgenteACasoHandler()
		})
		.bind(TriggerHandler.BEFORE_UPDATE, new TriggerHandler.TriggerInterface[]{
					new CalculaHorasHabilesHandler()
		})
		.bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.TriggerInterface[]{
					new AccountAssignCasoSFHandler(),                               // Asigna el contacto cuando ya existe su cuenta. No utilizado en Email2Case y Web2Case.
					new RevisionCartasReclamosHandler(),                        // Validación de cartas de reclamo.
					new AsignaFechaTopeHandler(),
					new CalculaDiasHabilesEntreAperYCieHandler(),
					new ActualizaFechaHoraDeCierreHandler()
		})
		.bind(TriggerHandler.AFTER_UPDATE, new TriggerHandler.TriggerInterface[]{
					new ActualizaEnvioEncuestaHandler()                         // Marca la cuenta como pendiente envio de encuesta.
		})
		.bind(TriggerHandler.AFTER_INSERT, new TriggerHandler.TriggerInterface[]{
					new RequerimientosAutomaticosCaseHandler()
		}).bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.TriggerInterface[]{
					new ActualizaDatosSuspensionPolizaHandler()
		})
		.manage();
}