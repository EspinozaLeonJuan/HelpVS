/**
 * Opportunity trigger para Comercial
 * @author: ChangeMeIn@UserSettingsUnder.SFDoc
 * @date: 05-05-2020
 */
trigger OpportunityTrigger on Opportunity (before insert, before update)
{

    // Filtrar Opportunidades
    List<Opportunity> newList = new List<Opportunity>();
    Map<Id, Opportunity> newMap = new Map<Id, Opportunity>();

    List<Opportunity> listOpportunityRenovacion = new List<Opportunity>();

    for (Opportunity op: Trigger.new)
    {
        if (
            op.RecordTypeId == ComercialConstants.opportunityComercialNuevo ||
            op.RecordTypeId == ComercialConstants.opportunityComercialRenovacion ||
            op.RecordTypeId == ComercialConstants.opportunityCovidCliente ||
            op.RecordTypeId == ComercialConstants.opportunityCovidNoCliente
        )
        {
            newList.add(op);
            if(!(Trigger.isBefore && Trigger.isInsert))
            {
                newMap.put(op.Id, op);
            }
        }

        if(op.RecordTypeId == ComercialConstants.opportunityComercialRenovacion)
        {
            listOpportunityRenovacion.add(op);
        }
    }

    List<Opportunity> oldList = new List<Opportunity>();
    Map<Id, Opportunity> oldMap = new Map<Id, Opportunity>();
    if (!trigger.isInsert)
    {
        for (Opportunity opt: Trigger.old)
        {
            if (
                opt.RecordTypeId == ComercialConstants.opportunityComercialNuevo ||
                opt.RecordTypeId == ComercialConstants.opportunityComercialRenovacion ||
                opt.RecordTypeId == ComercialConstants.opportunityCovidCliente ||
                opt.RecordTypeId == ComercialConstants.opportunityCovidNoCliente
            )
            {
                oldList.add(opt);
                oldMap.put(opt.Id, opt);
            }
        }
    }
    if(Trigger.isBefore && Trigger.isInsert)
    {
        OpportunityTriggerHandler.tieneOportunidadEnProceso(newList);
        OpportunityTriggerHandler.validacionReserva(newList);
        OpportunityTriggerHandler.asignarCorrelativo(newList);
        OpportunityTriggerHandler.cambiarEtapaOportunidad(newList);
        OpportunityTriggerHandler.validacionCuentasRelacionadas(newList);
        OpportunityTriggerHandler.seteoInicialTipoRenovacion(listOpportunityRenovacion);
        OpportunityTriggerHandler.validacionProcesoReserva(newList);
    }

    if(Trigger.isBefore && Trigger.isUpdate)
    {
        OpportunityTriggerHandler.tieneContactoCorredores(newList);
        OpportunityTriggerHandler.validaCotizacionesCerrada(newList, oldList);
        OpportunityTriggerHandler.cambiarDeclinadaCuenta(newList, oldList);
        //OpportunityTriggerHandler.notificacionCambioEstadoCotizacion(newList, oldList); // comentado por solicitud: UH 42049
        OpportunityTriggerHandler.alertaSuscriptoresOppCerrada(newList, oldList);
        OpportunityTriggerHandler.alertaDeclinacionOpp(newList);
        //OpportunityTriggerHandler.notificacionesCierreProceso(newList, oldList); // comentado por solicitud: UH 42049
        OpportunityTriggerHandler.validacionProcesoReserva(newList);
        //OpportunityTriggerHandler.emailOportunidadCerradaGanada(newList, oldList);
    }
}