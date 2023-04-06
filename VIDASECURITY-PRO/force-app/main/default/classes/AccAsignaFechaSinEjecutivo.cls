public class AccAsignaFechaSinEjecutivo {

    public static Account getAccountListDates(Account accountNew, Account accountOld){
        System.debug('_getAccountListDates '); 
        if( accountOld == null || accountOld.OwnerId != accountNew.OwnerId || accountOld.Agente_Actual__c != accountNew.Agente_Actual__c) {
            return accountNew;
        }
        return null;
    }

    public static Id getAgentID(Account accountNew, Account accountOld, Set<Id> ownerIds , Set<Id> agenteIds){
        System.debug('_getAgentID '); 
        if( accountOld == null || ( accountOld != null || accountOld.OwnerId != accountNew.OwnerId || accountOld.Agente_Actual__c != accountNew.Agente_Actual__c ) ) {
            System.debug('_ownerIds: '+ownerIds);
            System.debug('_accountNew: '+ accountNew.OwnerId );
            if( ownerIds != null && !ownerIds.contains( accountNew.OwnerId ) ){
                return accountNew.OwnerId;
            }
            if( agenteIds != null && accountNew.Agente_Actual__c != null && !agenteIds.contains(accountNew.Agente_Actual__c)){
                return accountNew.Agente_Actual__c;
            }
        }
        return null;
    }

    public static void insertDateAccount(Account accountNew, Account accountOld, Map<Id, Contact> agenteMap, Map<Id, User> ejecutivoMap){
        System.debug('insertDateAccount '); 
        if( agenteMap.containsKey( accountNew.Agente_Actual__c ) && ejecutivoMap.containsKey( accountNew.OwnerId ) ){
            Contact agente = agenteMap.get(accountNew.Agente_Actual__c);
            User ejecutivo = ejecutivoMap.get(accountNew.OwnerId);
            if( ( accountNew.Agente_Actual__c != null && agente != null && agente.Estado__c == 'Vigente' ) || ( ejecutivo != null && ejecutivo.IsActive && (ejecutivo.Ejecutivo_de_Cliente__c) ) ){
                accountNew.Fecha_Sin_Asignacion_Ejecutivo__c = null;
            }
            else{
                accountNew.Fecha_Sin_Asignacion_Ejecutivo__c = Date.today(); 
            }
        }
    }
}