/**
 * Quote trigger para Comercial
 * @author: Patricio Labin C.
 * @date: 08-05-2020
 */
trigger QuoteTrigger on Quote (before insert, before update, after insert, after update) {
    // Filtrar Quotes
    List<Quote> newList = new List<Quote>();
    Map<Id, Quote> newMap = new Map<Id, Quote>();

    for (Quote qt: Trigger.new) {
        if (qt.RecordTypeId == ComercialConstants.quoteComercial ||
            qt.RecordTypeId == ComercialConstants.quoteRenovacion ||
            qt.RecordTypeId == ComercialConstants.quoteCovid) {
            newList.add(qt);
            if(!(Trigger.isBefore && Trigger.isInsert)) newMap.put(qt.Id, qt);
        }
    }

    List<Quote> oldList = new List<Quote>();
    Map<Id, Quote> oldMap = new Map<Id, Quote>();

    if(!Trigger.isInsert){
        for (Quote qt: Trigger.old) {
            if (qt.RecordTypeId == ComercialConstants.quoteComercial || 
                qt.RecordTypeId == ComercialConstants.quoteRenovacion || 
                qt.RecordTypeId == ComercialConstants.quoteCovid) {
                oldList.add(qt);
                oldMap.put(qt.Id, qt);
            }
        }
    }
    //

    if(Trigger.isBefore && Trigger.isInsert) {
        QuoteTriggerHandler.inicializarCotizacionComercial(newList);
        QuoteTriggerHandler.registraCumplimientoRenovacionSLA(newList);
        //QuoteTriggerHandler.creacionPresupuestoSegunOpp(newList);
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        //Se comenta por solicitud de negocio
        //QuoteTriggerHandler.emailCotizacionCreada(newList);
        
    }

    if(Trigger.isBefore && Trigger.isUpdate) {
        QuoteTriggerHandler.modificarValoresOportunidad(newList, oldList);
        //QuoteTriggerHandler.validacionPropuestaComercial(newMap, oldMap);

        // DEBE MANTENERSE AL FINAL, necesita el ultimo cambio posible de etapa
        QuoteTriggerHandler.registraCumplimientoSLA(newMap, oldMap);
        
    }

    if(Trigger.isAfter && Trigger.isUpdate) {
        //Se comenta por solicitud de negocio
        //QuoteTriggerHandler.emailCotizacionNegociacion(newList, oldList);
        //QuoteTriggerHandler.emailCambioSuscriptor(newList, oldList);
        //QuoteTriggerHandler.notificacionesPresupuesto(newList, oldList);
    }    
}