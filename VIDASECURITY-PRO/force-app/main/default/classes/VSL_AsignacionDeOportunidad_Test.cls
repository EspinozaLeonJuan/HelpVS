@isTest
public class VSL_AsignacionDeOportunidad_Test {
    @isTest
    public static void polizaProceso(){
        String LinkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;
        String polizaIndivRecorType = [select id from RecordType where name = 'Individuales'].Id;
        
        Account cuenta = new Account(Name='test1');
        insert cuenta;
        
        Opportunity oportunidad = new Opportunity(Name = 'test1-', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                       Tipo_Link__c='Bases Normales', Codigo_de_Link__c = 1, Link_Auditado__c = true); 
        insert oportunidad;
        
        Poliza__c poliza = new Poliza__c(Name = 'test1-poliza', Cuenta__c = cuenta.Id, RecordTypeId = polizaIndivRecorType);
        insert poliza;
    }
}