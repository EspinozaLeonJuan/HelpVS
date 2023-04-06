/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-24-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-09-2021   Juan Espinoza León   Initial Version
**/
@isTest
public class TEST_CLS_LINK_Ranking {
    public TEST_CLS_LINK_Ranking() {

    }

    public static String CRON_EXP = '0 0 0 24 6 ? 2022';
    static List<String> letraApellidos = new List<String>{'A','B','C','D','E','F','G','H','I','J','K'};
    static String LinkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;

    @IsTest
    static void GestionarLinks(){
        
        Test.startTest();

        List<Opportunity> listaOportunidades = new List<Opportunity>();
        List<Contact> listaAgentes = new List<Contact>();
        List<Link_Asignado__c> listaLink = new List<Link_Asignado__c>();
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '013');
        insert region; 
        Ciudad__c ciudad = new Ciudad__c(Name='Santiago', CIUD_Region__c = region.Id);
        insert ciudad;      
        Account cuenta = new Account(Name = 'Account', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        
        for(Integer i = 0; i < 7; i++){
            listaAgentes.add(new Contact(LastName=letraApellidos[i], Ranking_de_agente__c = 'A', Activo__c=true,Tipo_Cargo__c = 'Agente')); 
        }
        for(Integer i = 0; i < 5; i++){
            listaAgentes.add(new Contact(LastName=letraApellidos[i], Ranking_de_agente__c = 'B', Activo__c=true,Tipo_Cargo__c = 'Agente')); 
        }
        for(Integer i = 0; i < 2; i++){
            listaAgentes.add(new Contact(LastName=letraApellidos[i], Ranking_de_agente__c = 'C', Activo__c=true,Tipo_Cargo__c = 'Supervisor FFVV')); 
        }
        
        for(Integer i = 0; i < 15; i++){
            //date d = VSL_AgentesFechasLinks.randomDate(system.today(), date.newInstance(2020, 8, 30));
            listaOportunidades.add(new Opportunity(Name = 'opRanking ' + i, AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType, Fecha_de_Auditoria__c = System.today(),
                                                   Tipo_Link__c='Bases Normales', Renta__c = 1000000, Fecha_Entrevista__c = System.today() +3, Codigo_de_Link__c = i + 400, Link_Auditado__c = true)); 
        }
        
        Contact a1 = new Contact(LastName='A', Ranking_de_agente__c = 'A', Activo__c=true,Tipo_Cargo__c = 'Agente');
        Contact b1 = new Contact(LastName='B', Ranking_de_agente__c = 'B', Activo__c=true,Tipo_Cargo__c = 'Agente');
        Contact c1 = new Contact(LastName='C', Ranking_de_agente__c = 'C', Activo__c=true,Tipo_Cargo__c = 'Supervisor FFVV');
        
        insert listaAgentes;
        insert listaOportunidades;
        
        listaLink.add(new Link_Asignado__c(Name= 'Link1', Fecha_Link__c = System.today() + 1, Contacto__c = listaAgentes[0].Id));
        listaLink.add(new Link_Asignado__c(Name= 'Link2', Fecha_Link__c = System.today() + 1, Contacto__c = listaAgentes[7].Id));
        listaLink.add(new Link_Asignado__c(Name= 'Link3', Fecha_Link__c = System.today() + 1, Contacto__c = listaAgentes[12].Id));
        listaLink.add(new Link_Asignado__c(Name= 'Link1', Fecha_Link__c = System.today(), Contacto__c = listaAgentes[0].Id));
        listaLink.add(new Link_Asignado__c(Name= 'Link2', Fecha_Link__c = System.today(), Contacto__c = listaAgentes[7].Id));
        listaLink.add(new Link_Asignado__c(Name= 'Link3', Fecha_Link__c = System.today(), Contacto__c = listaAgentes[12].Id));
        
        
        insert listaLink;
        
        CLS_LINK_GestionRanking.GestionarLinks(System.today(),System.today());

        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new CLS_LINK_Ranking());  

        Test.stopTest();
    }
}