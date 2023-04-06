public class AccAsignaAgenteActualACuenta {

    public static string GetCodeAccount( Account accountNew, Set<String> codigos){
        if( accountNew.Codigo_Agente__c != null && !codigos.contains(accountNew.Codigo_Agente__c) ){
			return accountNew.Codigo_Agente__c;
        }
        return null;     
    }

    public static void InsertAgent(Account accountNew, Map<String, Contact> agenteMap){
        Contact agente = agenteMap.get(accountNew.Codigo_Agente__c);
        if( agente == null ){
			return;
        }
        if( accountNew.Agente_Actual__c != agente.Id ){
            accountNew.Agente_Actual__c = agente.Id;
            if( accountNew.Agente_Original__c == null ){
                accountNew.Agente_Original__c =agente.Id;
            }
        }
    }
}