public class AccAsignaEjecutivoDeCliente {

    public static Id getOwnerID(Account accountNew, Account accountOld, Set<Id> ownerIds ){
        if (accountOld != null && !ownerIds.contains(accountNew.OwnerId) && ( ( ( accountOld.OwnerId != accountNew.OwnerId ) && ( accountNew.ultima_actualizacion_amac__c == null || ( accountNew.ultima_actualizacion_amac__c != null && ( ( DateTime.now().getTime() - accountNew.ultima_actualizacion_amac__c.getTime() ) > 60000 ) ) ) ) || ( accountOld.Sincronizar_Ejecutivo__c == false && accountNew.Sincronizar_Ejecutivo__c == true && accountOld.ultima_actualizacion_amac__c == null ) || ( accountOld.Sincronizar_Ejecutivo__c == true && accountNew.Sincronizar_Ejecutivo__c == true && accountNew.ultima_actualizacion_amac__c != null && ( ( DateTime.now().getTime() - accountNew.ultima_actualizacion_amac__c.getTime() ) > 60000 ) ) ) ) {	
          accountNew.ultima_actualizacion_amac__c = DateTime.now();
          return accountNew.OwnerId;
        }
        return null;
    }

    public static void asignarEjecurivoCliente(Account accountNew, Account accountOld, Map<Id, Ejecutivo_de_Cliente__c> ejecutivoClienteMap, Ejecutivo_de_Cliente__c sinAsignar){
        Ejecutivo_De_Cliente__c ejecutivo = ejecutivoClienteMap.get(accountNew.OwnerId);
        if( ejecutivo == null && sinAsignar != null ){
            accountNew.Ejecutivo_de_Cliente__c = sinAsignar.Id;
        }else if( ejecutivo != null ){
            accountNew.Ejecutivo_de_Cliente__c = ejecutivo.Id;
        }
    }
}