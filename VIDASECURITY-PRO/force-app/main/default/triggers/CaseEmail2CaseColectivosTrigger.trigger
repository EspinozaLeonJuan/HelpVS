trigger CaseEmail2CaseColectivosTrigger on Case (before insert) {
  	Set<String> ORIGENES = new Set<String>{'Servicios Colectivos'};
    Set<String> ORIGENES2 = new Set<String>{'Servicios BCI', 'Servicios Telefónica'};
    for (Case caso : (Case[])Trigger.new){
        if (ORIGENES.contains(caso.Origin) && String.isNotBlank(caso.SuppliedEmail)) {
            caso.Negocio__c = 'Seguros Colectivos';
        }

        if (ORIGENES2.contains(caso.Origin) && String.isNotBlank(caso.SuppliedEmail)) {
            caso.Canal__c = caso.Origin;
            caso.Negocio__c = 'Seguros Colectivos';
        }
    }
}