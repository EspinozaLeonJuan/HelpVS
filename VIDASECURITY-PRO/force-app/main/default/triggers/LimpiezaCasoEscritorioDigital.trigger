trigger LimpiezaCasoEscritorioDigital on Case (after update) {
   /* List<Case> ListaCasosUpdate = new List<Case>();
    
    Map<Id, Case> mapCasos = 
            new Map<Id, Case>([SELECT Id, Detalle_Solicitud__c,
                               Id_Requerimiento_EscritorioDigital__c,
                               Tipo_Requerimiento_EscritorioDigital__c,
                               Estado_Requerimiento_EscritorioDigital__c FROM Case WHERE Id_Requerimiento_EscritorioDigital__c !='']);
    
    for( Id cNew : Trigger.newMap.keySet() ) {
        if( 
            Trigger.oldMap.get(cNew).Id_Requerimiento_EscritorioDigital__c != '' &&
            Trigger.oldMap.get(cNew).Detalle_Solicitud__c != Trigger.newMap.get(cNew).Detalle_Solicitud__c ) {
            Case caso = mapCasos.get(cNew);
                if (caso != null)
                {
                    caso.Id_Requerimiento_EscritorioDigital__c = null;
                    caso.Tipo_Requerimiento_EscritorioDigital__c = null;
                    caso.Estado_Requerimiento_EscritorioDigital__c = null;                 
                    ListaCasosUpdate.add(caso);                            
                }
            
        }
    }
    
    
    update ListaCasosUpdate;     */
}