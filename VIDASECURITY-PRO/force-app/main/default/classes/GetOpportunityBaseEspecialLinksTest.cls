@isTest
private class GetOpportunityBaseEspecialLinksTest {
    public GetOpportunityBaseEspecialLinksTest() {

    }

    @isTest static void getAllOppsTest(){

        if (!String.isBlank(GetOpportunityBaseEspecialLinks.getAllOpps())) {
            System.assert(true);
        }
    }

    @isTest static void getAgentsTest(){

        List<Contact> listCon = new List<Contact>();

        Contact cont1 = new Contact(
            FirstName = 'Agente1',
            LastName = 'Apellido2',
            Tipo_Cargo__c = 'Supervisor FFVV'
        );

        Contact cont2 = new Contact(
            FirstName = 'Agente2',
            LastName = 'Apellido3',
            Tipo_Cargo__c = 'Supervisor PF'
        );

        listCon.add(cont1);
        listCon.add(cont2);
        insert listCon;

        if (GetOpportunityBaseEspecialLinks.getAgents().size() > 0 ) {
            System.assert(true);
        }
    }

    @isTest (SeeAllData=true) static void asignacionEspecialTest(){
        
        List<String> ruts = new List<String>{'12263698','12933320','14928041','18061804','15645839','15311474','18494367','11684381','24257908','21029264'};
        List<String> dv = new List<String>{'4','0','3','k','2','9','0','1','9','0'};
        String LinkRecordTypeOpp = [select Id from RecordType where name = 'Venta - Link'].Id;
        Account[] accToCreate = new Account[]{};
        Opportunity[] oppToCreate = new Opportunity[]{};
        set<String> accRut = new set<String>();
        List<String> lista = new List<String>();

        for(Integer x=0; x<10;x++){
            
            Account newAccount2 = new Account(Name='Account'+x , Rut__c=ruts[x], DV__c = dv[x]);   
            accToCreate.add(newAccount2);
            accRut.add(newAccount2.Rut__c);
        }
        system.debug('Cuentas a crear' + accToCreate);
        insert accToCreate;

        List<Account> oppToAccount = [SELECT Id, Rut__c from Account Where Rut__c IN :accRut]; 

        Integer count = 200;
        for(Account tn: oppToAccount){
             
            Opportunity newOpportunity2 = new Opportunity(Name='newOpportunityAccount', 
                                                          AccountId=tn.id, 
                                                          CreatedDate=Datetime.newinstance(2018,4,20,12,6,6),
                                                          CloseDate=System.today().AddDays(10),
                                                          RecordTypeId = LinkRecordTypeOpp,
                                                          Codigo_de_Link__c = count,
                                                          Tipo_Link__c = 'Bases Especiales',
                                                          agente_asignado__c=false,
                                                          Link_Auditado__c = true,
                                                          StageName='Validación');
            count++;                                        
            oppToCreate.add(newOpportunity2);
        }
                
        insert oppToCreate;

        List<Contact> listCon = new List<Contact>();
        Contact cont1 = new Contact(
            FirstName = 'Agente1',
            LastName = 'Apellido2',
            Tipo_Cargo__c = 'Supervisor FFVV'
        );

        Contact cont2 = new Contact(
            FirstName = 'Agente2',
            LastName = 'Apellido3',
            Tipo_Cargo__c = 'Supervisor PF'
        );
        listCon.add(cont1);
        listCon.add(cont2);
        insert listCon;

        Map<Id, Contact> contactyMap = new Map<Id, Contact>(listCon);
        System.debug(contactyMap);
        Set<String> idStrs = (Set<String>)JSON.deserialize(JSON.serialize(contactyMap.keySet()), Set<String>.class);
        System.debug('IDSTRS '+idStrs);
        Lista.addAll(idStrs);
        system.assertEquals(GetOpportunityBaseEspecialLinks.asignacionEspecial(lista), true);
    }
}