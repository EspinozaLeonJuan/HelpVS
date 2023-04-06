@isTest
private class VSL_AR_ValidacionDeCarga_ProspectoTest {
    
    @isTest static void validacionDeCarga_campaignMember(){

        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        
        Lead[] leadsToCreate = new Lead[]{};
        Lead[] leadsToCreate2 = new Lead[]{};
            
        set<String> leadRut = new set<String>();

        campaignMember[] cmpMembers = new campaignMember[]{};

         //Generación de la campaña inicial, en donde se insertarán todos los prospectos
        Campaign cmp = New Campaign(Name='Campagin Test Lead', Status='En Curso', Type='Televenta-Links',
                                            CAMP_Producto__c= '19', CAMPA_Ejecutivo_Televenta__c='9919804-4', CurrencyIsoCode='CLP', IsActive=true);
        insert cmp;
        
        //Obtención del ID de la campaña recién creada, para vincular prospectos a campaña
        Campaign[] campa = [SELECT Id from Campaign WHERE Name='Campagin Test Lead' Limit 1];

        String idCampaign = campa[0].id;
        
        //Generación de 200 prospectos inicialmente, que no existen en la base.-
        for(Integer x=0; x<10;x++)
        {   
                Lead ld = new Lead(FirstName='Name'+ x , lastname='test' + x,  PROSP_Carga_RUT__c= '9'+ x,
                                   RecordTypeId=LinkRecordType);
                leadsToCreate.add(ld);
                leadRut.add(ld.PROSP_Carga_RUT__c);
        }
                
        //empiezan las operaciones DML
        Test.startTest();
        upsert leadsToCreate;
                
        List<Lead> leadExist = [SELECT Id from Lead Where PROSP_Carga_RUT__c  IN :leadRut ];
        
        for (Lead ld: leadExist )
        {
            campaignMember cm = New CampaignMember(campaignId=idCampaign, leadId=ld.Id);
            cmpMembers.add(cm);
        }
        
        insert cmpMembers;
        
        for(Integer x=0; x<10;x++)
        {
            Lead ld = new Lead(FirstName='Name'+ x , lastname='test' + x,  PROSP_Carga_RUT__c= '9'+ x,
                               RecordTypeId=LinkRecordType);
            leadsToCreate2.add(ld);
        }
        
        system.debug('LEADS PARA VALIDAR' + leadsToCreate2);
        try {
            insert leadsToCreate2;

        } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
            e.getDmlStatusCode(0));
        }
   
        Test.stopTest();
        
    }
    
    @istest  static void validacionDeCarga_cuentaPoliza(){
        
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        String PolizaRecordType = [select Id from RecordType where name = 'Individuales'].Id;

        Lead[] leadsToCreate = new Lead[]{};
        Account[] accToCreate = new Account[]{};
        set<String> accRut = new set<String>();
        Poliza__c[] ProdActivo = new Poliza__c[]{};
            
            for(Integer x=0; x<10;x++){
                
                Account acct = new Account(Name='Name '+ x, Rut__c= '9'+ x, Empresa_Origen__c='Vida Security');
                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }            

      insert accToCreate;
        
      //Se seleccionan las cuentas creadas para asignación de polizas.
      system.debug('RUTS PARA POLIZA' + accRut);
      List<Account> AccountToPoliza = [SELECT Id, Rut__c from Account Where Rut__c IN :accRut ];        
      //generación de polizas
      for(Account ac: AccountToPoliza)
        {
            Poliza__c pol = new Poliza__c(Name=ac.Rut__c, Cuenta__c=ac.Id, Estatus__c='ACTIVA', RecordTypeId = PolizaRecordType );  
            ProdActivo.add(pol);
        }
        
      system.debug('POLIZAS PARA CARGAR' + ProdActivo);
      insert ProdActivo;
        
      Test.startTest();
       for(Integer x=0; x<10;x++)
        {
            Lead ld = new Lead(FirstName='Name'+ x , lastname='test' + x,  PROSP_Carga_RUT__c= '9'+ x,
                               RecordTypeId=LinkRecordType);
            leadsToCreate.add(ld);
        }
        try {
            insert leadsToCreate;

        } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
            e.getDmlStatusCode(0));
        }
      Test.stopTest();
        
      
    }
    
    @istest  static void validacionDeCarga_cuentaOportunidad(){
        
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        String LinkRecordTypeOpp = [select Id from RecordType where name = 'Venta - Link'].Id;

        Lead[] leadsToCreate = new Lead[]{};
        Account[] accToCreate = new Account[]{};
        Opportunity[] oppToCreate = new Opportunity[]{};
        set<String> leadRut = new set<String>();
            
        for(Integer x=0; x<10;x++){
            
            Account newAccount2 = new Account(Name='Account'+x , Rut__c='2'+x );   
            leadRut.add(newAccount2.Rut__c);
            accToCreate.add(newAccount2);
        }
        system.debug('Cuentas a crear' + accToCreate);
        insert accToCreate;

        List<Account> oppToAccount = [SELECT Id, Rut__c from Account Where Rut__c IN :leadRut ]; 
        
        Integer count = 0;
        for(Account tn: oppToAccount){
             
            Opportunity newOpportunity2 = new Opportunity(Name='newOpportunityAccount', 
                                                          AccountId=tn.id, 
                                                          CreatedDate=Datetime.newinstance(2018,4,20,12,6,6),
                                                          CloseDate=System.today().AddDays(10),
                                                          RecordTypeId = LinkRecordTypeOpp,
                                                          Codigo_de_Link__c = count+1,
                                                          StageName='Validación');
            count++;                                        
            oppToCreate.add(newOpportunity2);
        }
                
        insert oppToCreate;
        //Inserción de leads
         system.debug('Oportunidades a crear' + oppToCreate);
       Test.startTest();
       for(Integer x=0; x<10;x++)
        {
            Lead newLead_2 = new Lead(Lastname= 'newLead'+x, Company='Company'+x, PROSP_Carga_RUT__c='2'+x);
            leadsToCreate.add(newLead_2);
        }
		
      system.debug('Leads a crear' + leadsToCreate);  
        try {
            insert leadsToCreate;

        } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
            e.getDmlStatusCode(0));
        }      
      Test.stopTest();
    }
    
    @istest static void validacionDeCarga_EjecutivoPostVenta(){
        
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        Lead[] leadsToCreate = new Lead[]{};
        Account[] accToCreate = new Account[]{};

        String ejecutivo = [SELECT id FROM User WHERE Alias = 'mschi'].Id;

        set<String> leadRut = new set<String>();
        for(Integer x=0; x<10;x++){
            
            Account newAccount2 = new Account(Name='Account'+x , Rut__c='2'+x );   
            leadRut.add(newAccount2.Rut__c);
            accToCreate.add(newAccount2);
        }
        
        system.debug('Cuentas a crear' + accToCreate);
        insert accToCreate;
        
        Test.startTest();
       for(Integer x=0; x<10;x++)
        {
            Lead newLead_2 = new Lead(Lastname= 'newLead'+x, 
                                      Company='Company'+x, 
                                      PROSP_Carga_RUT__c='2'+x, 
                                      RecordTypeId = LinkRecordType, 
                                      Ejecutivo_Postventa__c=ejecutivo);
            leadsToCreate.add(newLead_2);
        }
		
	  system.debug('Leads a crear' + leadsToCreate);        
      insert leadsToCreate;
      Test.stopTest();
        
    }

    @istest static void validacionFechaEntrevistaAgente(){

        String LinkRecordTypePrs = [select Id from RecordType where name = 'Prospecto Links'].Id;
        String LinkRecordTypeOpp = [select Id from RecordType where name = 'Venta - Link'].Id;
        String contactRecordType = [select Id from RecordType where name = 'Agente'].Id;

        Contact cont = new Contact(
            FirstName = 'Agente Demo',
            LastName = 'Apellido',
            RecordTypeId = contactRecordType
        );

        insert cont;

        String agente = [SELECT Id FROM Contact WHERE FirstName = 'Agente Demo'].Id;

        Opportunity opp = New Opportunity(
            Name = 'Oportunity Assign',
            Fecha_Entrevista__c = system.today(),
            RecordTypeId = LinkRecordTypeOpp,
            Agente_de_Venta__c = agente,
            StageName = 'Asignado',
            CloseDate = System.today().addDays(10),
            Codigo_de_Link__c = 1
        );

        Test.startTest();
        insert opp;

        Lead prs = new Lead(
            FirstName = 'LeadTest',
            LastName = 'LeadLastName',
            Agente_Venta__c = agente,
            Tipo_Link__c = 'Bases Propias'
        );

        insert prs;

        List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE FirstName = 'LeadTest'];

        for (Lead ids : leadIds) {

            ids.Fecha_Entrevista__c = system.today();

        }

        try {
            update leadIds;
            
        } catch (DmlException e) {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  , 
            e.getDmlStatusCode(0));
        }
        
        Test.stopTest();

    }

}