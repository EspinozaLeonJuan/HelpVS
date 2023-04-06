@istest
private class TEST_TRG_Lead_ValidacionDeCargaLinks {
    public TEST_TRG_Lead_ValidacionDeCargaLinks() {

    }

    private static String Lead_RecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();
    private static String Poliza_RecordType = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

    private static String Opportunity_RecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').getRecordTypeId();

    private static String Contact_RecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId();

  
    @istest static void validacionDeCarga_Update(){

        Contact cont = new Contact(
                                FirstName = 'Agente Demo',
                                LastName = 'Apellido',
                                RecordTypeId = Contact_RecordType
        );

        insert cont;

        String agente = [SELECT Id FROM Contact WHERE FirstName = 'Agente Demo'].Id;

        Opportunity opp1 = new Opportunity(
                                    Name = 'Oportunity Assign',
                                    Fecha_Entrevista__c = system.today(),
                                    RecordTypeId = Opportunity_RecordType,
                                    Agente_de_Venta__c = agente,
                                    StageName = 'Asignado',
                                    CloseDate = System.today().addDays(10),
                                    Codigo_de_Link__c = 1
        );
		
       String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

       
      
        
        Test.startTest();

        insert opp1;

       

       

        
        Lead prs = new Lead(
            FirstName = 'LeadTest',
            LastName = 'LeadLastName 1',
            Agente_Venta__c = agente,
            Tipo_Base__c = 'Bases Normales',
            Tipo_Link__c = 'Bases Propias',
            Nombre_Base__c = 'Bases Normales'
        );

        insert prs;



        List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE FirstName = 'LeadTest'];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }

        Test.stopTest();
    }

    @istest static void validacionDeCarga_Update_1(){

        Contact cont = new Contact(
                                FirstName = 'Agente Demo',
                                LastName = 'Apellido',
                                RecordTypeId = Contact_RecordType
        );

        insert cont;
		
       String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

       
       Opportunity opp2 = new Opportunity(
                                    Name = 'Oportunity Assign 2',
                                    Fecha_Entrevista__c = system.today(),
                                    RecordTypeId = Opportunity_RecordType,
            						Ejecutivo_Post_Venta__c = IdUsuario,
                                    StageName = 'Asignado',
                                    CloseDate = System.today().addDays(10),
                                    Codigo_de_Link__c = 2
        );
        
        Test.startTest();

       

        insert opp2;

       

        Lead prb = new Lead(
            FirstName = 'LeadTest',
            LastName = 'LeadLastName 2',
            Tipo_Link__c = 'Bases Propias',
            Tipo_Base__c = 'Bases Normales',
            Ejecutivo_PostVenta__c = IdUsuario,            
            Nombre_Base__c = 'Bases Normales'
        );

        insert prb;


        List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE FirstName = 'LeadTest'];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }

        Test.stopTest();
    }

    
     
    @istest  static void validacionDeCarga_Insert_1(){

        CampaignMember[] cmpMembers = new CampaignMember[]{};

         //Generación de la campaña inicial, en donde se insertarán todos los prospectos
        Campaign cmp = new Campaign(
                                    Name = 'Campagin Test Lead',
                                    Status = 'En Curso',
                                    Type = 'Televenta-Links',
                                    CAMP_Producto__c = '19',
                                    CAMPA_Ejecutivo_Televenta__c = '9919804-4',
                                    CurrencyIsoCode = 'CLP',
                                    IsActive = true
                                    );
        insert cmp;

        Lead[] leadsToCreate = new Lead[]{};
        Lead[] leadsToCreate2 = new Lead[]{};
        Account[] accToCreate = new Account[]{};

        set<String> leadRut = new set<String>();
        set<String> accRut = new set<String>();
        Poliza__c[] ProdActivo = new Poliza__c[]{};

        Task[] tareas = new Task[]{};

            for(Integer x=0; x<3; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security'//,
                    //Fecha_Ultimo_Reclamo__c = Date.today(),
                    //Sin_Trabajo__c  = true,
                    //Con_Problema_Economico__c  = true,
                    //Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }

         	for(Integer x=3; x<7; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security',
                    //Fecha_Ultimo_Reclamo__c = Date.today(),
                    Sin_Trabajo__c  = true,
                    Con_Problema_Economico__c  = true,
                    Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }
        
            for(Integer x=7; x<10; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security',
                    Fecha_Ultimo_Reclamo__c = Date.today()//,
                    //Sin_Trabajo__c  = true,
                    //Con_Problema_Economico__c  = true,
                    //Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }
        insert accToCreate;

        String  Tarea_RecordTypeId_Llamada_Cliente  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Llamada Cliente').getRecordTypeId();
        //String  Tarea_RecordTypeId_PostVenta  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PostVenta').getRecordTypeId();



        //Se seleccionan las cuentas creadas para asignación de polizas.
        system.debug('RUTS PARA POLIZA' + accRut);
        List<Account> AccountToPoliza = [SELECT Id, Rut__c FROM Account WHERE Rut__c IN :accRut ];
              
        //generación de polizas
        for(Account ac: AccountToPoliza)
        {
            Poliza__c pol = new Poliza__c(
                                        Name=ac.Rut__c,
                                        Cuenta__c=ac.Id,
                                        Estatus__c='ACTIVA',
                                        RecordTypeId = Poliza_RecordType
                                        );
            ProdActivo.add(pol);

            Task task = new Task(
                        WhatId = ac.Id,
                        RecordTypeId = Tarea_RecordTypeId_Llamada_Cliente,
                        Status = 'Abierta',
                        Subject = 'Asunto'
                );

            tareas.add(task);
        }

        system.debug('POLIZAS PARA CARGAR' + ProdActivo);
        insert ProdActivo;

        system.debug('TAREAS PARA CARGAR' + tareas);
        insert tareas;

  		Opportunity[] oppToCreate = new Opportunity[]{};
        Integer count = 0;
        for(Account tn: AccountToPoliza){

            Opportunity newOpportunity2 = new Opportunity(
                                                    Name = 'newOpportunityAccount',
                                                    AccountId = tn.id,
                                                    CreatedDate = Datetime.newinstance(2018,4,20,12,6,6),
                                                    CloseDate = System.today().AddDays(10),
                                                    RecordTypeId = Opportunity_RecordType,
                                                    Codigo_de_Link__c = count+1,
                                                    StageName = 'Validación'
                                                );
            count++;
            oppToCreate.add(newOpportunity2);
        }

        insert oppToCreate;

       

      Test.startTest();
        String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

        for(Integer x=0; x<6;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias',
                            RecordTypeId = Lead_RecordType,
		                    Ejecutivo_PostVenta__c = IdUsuario
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }

        for(Integer x=6; x<10;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases Normales',
			                Nombre_Base__c = 'Bases Normales',
                            Tipo_Link__c = 'Bases Normales',
                            RecordTypeId = Lead_RecordType
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }
        
      
        
        try
        {
            insert leadsToCreate;


        }
        catch (DmlException e) {
            system.debug('EXCEPTION' + e);
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }
        	  
        
       for(Integer x=0; x<10; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias'
                            );

            leadsToCreate2.add(ld);
        }
        
        for(Integer x=10; x<20; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = ''
                            );

            leadsToCreate2.add(ld);
        }

        system.debug('LEADS PARA VALIDAR' + leadsToCreate2);


         List<Lead> leadExist = [SELECT Id, PROSP_Carga_RUT__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];
		 system.debug('leadRut' + leadRut.size());
         system.debug('leadExist' + leadExist.size());
          for (Lead ld: leadExist )
          {
              CampaignMember cm = new CampaignMember(
                  campaignId = cmp.Id,
                  
                  leadId = ld.Id
              );
              cmpMembers.add(cm);
          }

         system.debug('cmpMembers' + cmpMembers.size());
        try
        {

            insert cmpMembers;

            insert leadsToCreate2;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }


        /* List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }*/

        Test.stopTest();
    }

     
      @istest  static void validacionDeCarga_Insert_3(){

        CampaignMember[] cmpMembers = new CampaignMember[]{};

         //Generación de la campaña inicial, en donde se insertarán todos los prospectos
        Campaign cmp = new Campaign(
                                    Name = 'Campagin Test Lead',
                                    Status = 'En Curso',
                                    Type = 'Televenta-Links',
                                    CAMP_Producto__c = '19',
                                    CAMPA_Ejecutivo_Televenta__c = '9919804-4',
                                    CurrencyIsoCode = 'CLP',
                                    IsActive = true
                                    );
        insert cmp;

        Lead[] leadsToCreate = new Lead[]{};
        Lead[] leadsToCreate2 = new Lead[]{};
        Account[] accToCreate = new Account[]{};

        set<String> leadRut = new set<String>();
        set<String> accRut = new set<String>();
        Poliza__c[] ProdActivo = new Poliza__c[]{};

        Task[] tareas = new Task[]{};

            for(Integer x=0; x<10; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security'                    
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }

         
        insert accToCreate;

        String  Tarea_RecordTypeId_Llamada_Cliente  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Llamada Cliente').getRecordTypeId();
        //String  Tarea_RecordTypeId_PostVenta  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PostVenta').getRecordTypeId();



        //Se seleccionan las cuentas creadas para asignación de polizas.
        system.debug('RUTS PARA POLIZA' + accRut);
        List<Account> AccountToPoliza = [SELECT Id, Rut__c FROM Account WHERE Rut__c IN :accRut ];
              
        //generación de polizas
        for(Account ac: AccountToPoliza)
        {
            Poliza__c pol = new Poliza__c(
                                        Name=ac.Rut__c,
                                        Cuenta__c=ac.Id,
                                        Estatus__c='ACTIVA',
                                        RecordTypeId = Poliza_RecordType
                                        );
            ProdActivo.add(pol);

            Task task = new Task(
                        WhatId = ac.Id,
                        RecordTypeId = Tarea_RecordTypeId_Llamada_Cliente,
                        Status = 'Abierta',
                        Subject = 'Asunto'
                );

            tareas.add(task);
        }

        system.debug('POLIZAS PARA CARGAR' + ProdActivo);
        insert ProdActivo;

        system.debug('TAREAS PARA CARGAR' + tareas);
        insert tareas;

  		Opportunity[] oppToCreate = new Opportunity[]{};
        Integer count = 0;
        for(Account tn: AccountToPoliza){

            Opportunity newOpportunity2 = new Opportunity(
                                                    Name = 'newOpportunityAccount',
                                                    AccountId = tn.id,
                                                    CreatedDate = Datetime.newinstance(2018,4,20,12,6,6),
                                                    CloseDate = System.today().AddDays(10),
                                                    RecordTypeId = Opportunity_RecordType,
                                                    Codigo_de_Link__c = count+1,
                                                    StageName = 'Validación'
                                                );
            count++;
            oppToCreate.add(newOpportunity2);
        }

        insert oppToCreate;

       

      Test.startTest();
        String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

        for(Integer x=0; x<6;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias',
                            RecordTypeId = Lead_RecordType,
		                    Ejecutivo_PostVenta__c = IdUsuario
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }

        for(Integer x=6; x<10;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases Normales',
			                Nombre_Base__c = 'Bases Normales',
                            Tipo_Link__c = 'Bases Normales',
                            RecordTypeId = Lead_RecordType
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }
        
      
        
        try
        {
            insert leadsToCreate;


        }
        catch (DmlException e) {
            system.debug('EXCEPTION' + e);
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }
        	  
        
       for(Integer x=0; x<10; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias'
                            );

            leadsToCreate2.add(ld);
        }
        
        for(Integer x=10; x<20; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = ''
                            );

            leadsToCreate2.add(ld);
        }

        system.debug('LEADS PARA VALIDAR' + leadsToCreate2);


         List<Lead> leadExist = [SELECT Id, PROSP_Carga_RUT__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];
		 system.debug('leadRut' + leadRut.size());
         system.debug('leadExist' + leadExist.size());
          for (Lead ld: leadExist )
          {
              CampaignMember cm = new CampaignMember(
                  campaignId = cmp.Id,
                  
                  leadId = ld.Id
              );
              cmpMembers.add(cm);
          }

         system.debug('cmpMembers' + cmpMembers.size());
        try
        {

            insert cmpMembers;

            insert leadsToCreate2;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }


        /* List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }*/

        Test.stopTest();
    }

  
    @istest  static void validacionDeCarga_Insert_2(){

        CampaignMember[] cmpMembers = new CampaignMember[]{};

         //Generación de la campaña inicial, en donde se insertarán todos los prospectos
        Campaign cmp = new Campaign(
                                    Name = 'Campagin Test Lead',
                                    Status = 'En Curso',
                                    Type = 'Televenta-Links',
                                    CAMP_Producto__c = '19',
                                    CAMPA_Ejecutivo_Televenta__c = '9919804-4',
                                    CurrencyIsoCode = 'CLP',
                                    IsActive = true
                                    );
        insert cmp;

        Lead[] leadsToCreate = new Lead[]{};
        Lead[] leadsToCreate2 = new Lead[]{};
        Account[] accToCreate = new Account[]{};

        set<String> leadRut = new set<String>();
        set<String> accRut = new set<String>();
        Poliza__c[] ProdActivo = new Poliza__c[]{};

        Task[] tareas = new Task[]{};

            for(Integer x=0; x<3; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security'//,
                    //Fecha_Ultimo_Reclamo__c = Date.today(),
                    //Sin_Trabajo__c  = true,
                    //Con_Problema_Economico__c  = true,
                    //Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }

         	for(Integer x=3; x<7; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security',
                    //Fecha_Ultimo_Reclamo__c = Date.today(),
                    Sin_Trabajo__c  = true,
                    Con_Problema_Economico__c  = true,
                    Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }
        
            for(Integer x=7; x<10; x++){

                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security',
                    Fecha_Ultimo_Reclamo__c = Date.today()//,
                    //Sin_Trabajo__c  = true,
                    //Con_Problema_Economico__c  = true,
                    //Vive_en_el_Extranjero__c = true
                );

                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }
        insert accToCreate;

        String  Tarea_RecordTypeId_Llamada_Cliente  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Llamada Cliente').getRecordTypeId();
        //String  Tarea_RecordTypeId_PostVenta  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PostVenta').getRecordTypeId();



        //Se seleccionan las cuentas creadas para asignación de polizas.
        system.debug('RUTS PARA POLIZA' + accRut);
        List<Account> AccountToPoliza = [SELECT Id, Rut__c FROM Account WHERE Rut__c IN :accRut ];
              
        //generación de polizas
        for(Account ac: AccountToPoliza)
        {
            Poliza__c pol = new Poliza__c(
                                        Name=ac.Rut__c,
                                        Cuenta__c=ac.Id,
                                        Estatus__c='ACTIVA',
                                        RecordTypeId = Poliza_RecordType,
                                        Fecha_de_inicio_de_suspensi_n__c = Date.today(),
                                        Cantidad_de_meses_suspendido__c = '12'
                                        );
            ProdActivo.add(pol);

            Task task = new Task(
                        WhatId = ac.Id,
                        RecordTypeId = Tarea_RecordTypeId_Llamada_Cliente,
                        Status = 'Abierta',
                        Subject = 'Asunto'
                );

            tareas.add(task);
        }

        system.debug('POLIZAS PARA CARGAR' + ProdActivo);
        insert ProdActivo;

        system.debug('TAREAS PARA CARGAR' + tareas);
        insert tareas;

  		Opportunity[] oppToCreate = new Opportunity[]{};
        Integer count = 0;
        for(Account tn: AccountToPoliza){

            Opportunity newOpportunity2 = new Opportunity(
                                                    Name = 'newOpportunityAccount',
                                                    AccountId = tn.id,
                                                    CreatedDate = Datetime.newinstance(2018,4,20,12,6,6),
                                                    CloseDate = System.today().AddDays(10),
                                                    RecordTypeId = Opportunity_RecordType,
                                                    Codigo_de_Link__c = count+1,
                                                    StageName = 'Validación'
                                                );
            count++;
            oppToCreate.add(newOpportunity2);
        }

        insert oppToCreate;

       

      Test.startTest();
        String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

        for(Integer x=0; x<6;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias',
                            RecordTypeId = Lead_RecordType,
		                    Ejecutivo_PostVenta__c = IdUsuario
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }

        for(Integer x=6; x<10;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases Normales',
			                Nombre_Base__c = 'Bases Normales',
                            Tipo_Link__c = 'Bases Normales',
                            RecordTypeId = Lead_RecordType
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }
        
      
        
        try
        {
            insert leadsToCreate;


        }
        catch (DmlException e) {
            system.debug('EXCEPTION' + e);
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }
        	  
        
       for(Integer x=0; x<10; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias'
                            );

            leadsToCreate2.add(ld);
        }
        
        for(Integer x=10; x<20; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = ''
                            );

            leadsToCreate2.add(ld);
        }

        system.debug('LEADS PARA VALIDAR' + leadsToCreate2);


         List<Lead> leadExist = [SELECT Id, PROSP_Carga_RUT__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];
		 system.debug('leadRut' + leadRut.size());
         system.debug('leadExist' + leadExist.size());
          for (Lead ld: leadExist )
          {
              CampaignMember cm = new CampaignMember(
                  campaignId = cmp.Id,
                  
                  leadId = ld.Id
              );
              cmpMembers.add(cm);
          }

         system.debug('cmpMembers' + cmpMembers.size());
        try
        {

            insert cmpMembers;

            insert leadsToCreate2;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }


        /* List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }*/

        Test.stopTest();
    }

    @istest  static void validacionDeCarga_Insert_4(){

        CampaignMember[] cmpMembers = new CampaignMember[]{};

         //Generación de la campaña inicial, en donde se insertarán todos los prospectos
        Campaign cmp = new Campaign(
                                    Name = 'Campagin Test Lead',
                                    Status = 'En Curso',
                                    Type = 'Televenta-Links',
                                    CAMP_Producto__c = '19',
                                    CAMPA_Ejecutivo_Televenta__c = '9919804-4',
                                    CurrencyIsoCode = 'CLP',
                                    IsActive = true
                                    );
        insert cmp;

        Lead[] leadsToCreate = new Lead[]{};
        Lead[] leadsToCreate2 = new Lead[]{};
        Account[] accToCreate = new Account[]{};

        set<String> leadRut = new set<String>();
        set<String> accRut = new set<String>();
        Poliza__c[] ProdActivo = new Poliza__c[]{};
//String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;
        Task[] tareas = new Task[]{};

            for(Integer x=0; x<10; x++){
                
                Account acct = new Account(
                    Name='Name '+ x,
                    Rut__c= '9'+ x,
                    Empresa_Origen__c='Vida Security'//,
//                    Ejecutivo_de_Cliente__c = IdUsuario
                    //Fecha_Ultimo_Reclamo__c = Date.today(),
                    //Sin_Trabajo__c  = true,
                    //Con_Problema_Economico__c  = true,
                    //Vive_en_el_Extranjero__c = true
                );
                
                accToCreate.add(acct);
                accRut.add(acct.Rut__c);
            }

         	
        insert accToCreate;

        String  Tarea_RecordTypeId_Llamada_Cliente  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Llamada Cliente').getRecordTypeId();
        //String  Tarea_RecordTypeId_PostVenta  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PostVenta').getRecordTypeId();



        //Se seleccionan las cuentas creadas para asignación de polizas.
        system.debug('RUTS PARA POLIZA' + accRut);
        List<Account> AccountToPoliza = [SELECT Id, Rut__c FROM Account WHERE Rut__c IN :accRut ];
              
        //generación de polizas
        for(Account ac: AccountToPoliza)
        {
            Poliza__c pol = new Poliza__c(
                                        Name=ac.Rut__c,
                                        Cuenta__c=ac.Id,
                                        Estatus__c='ACTIVA',
                                        RecordTypeId = Poliza_RecordType
                                        );
            ProdActivo.add(pol);

            Task task = new Task(
                        WhatId = ac.Id,
                        RecordTypeId = Tarea_RecordTypeId_Llamada_Cliente,
                        Status = 'Abierta',
                        Subject = 'Asunto'
                );

            tareas.add(task);
        }

        system.debug('POLIZAS PARA CARGAR' + ProdActivo);
        insert ProdActivo;

        system.debug('TAREAS PARA CARGAR' + tareas);
        insert tareas;
  system.debug('@@@@ TAREAS ID ' + tareas[0].Id);
  		Opportunity[] oppToCreate = new Opportunity[]{};
        Integer count = 0;
        for(Account tn: AccountToPoliza){

            Opportunity newOpportunity2 = new Opportunity(
                                                    Name = 'newOpportunityAccount',
                                                    AccountId = tn.id,
                                                    CreatedDate = Datetime.newinstance(2018,4,20,12,6,6),
                                                    CloseDate = System.today().AddDays(10),
                                                    RecordTypeId = Opportunity_RecordType,
                                                    Codigo_de_Link__c = count+1,
                                                    StageName = 'Validación'
                                                );
            count++;
            oppToCreate.add(newOpportunity2);
        }

        insert oppToCreate;

       

      Test.startTest();
        
        String IdUsuario = [SELECT Id FROM User LIMIT 1].Id;

        for(Integer x=0; x<6;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias',
                            RecordTypeId = Lead_RecordType,
		                    Ejecutivo_PostVenta__c = IdUsuario
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }

        for(Integer x=6; x<10;x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            Tipo_Base__c = 'Bases Normales',
			                Nombre_Base__c = 'Bases Normales',
                            Tipo_Link__c = 'Bases Normales',
                            RecordTypeId = Lead_RecordType
                            );

            leadsToCreate.add(ld);
            leadRut.add(ld.PROSP_Carga_RUT__c);
        }
        
      
        
        try
        {
            insert leadsToCreate;


        }
        catch (DmlException e) {
            system.debug('EXCEPTION' + e);
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }
        	  
        
       for(Integer x=0; x<10; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = 'Bases BI',
                            Nombre_Base__c = 'Bases BI',
                            Tipo_Link__c = 'Bases Propias'
                            );

            leadsToCreate2.add(ld);
        }
        
        for(Integer x=10; x<20; x++)
        {
            Lead ld = new Lead(
                            FirstName = 'Name'+ x ,
                            Lastname = 'test' + x,
                            PROSP_Carga_RUT__c = '9'+ x,
                            RecordTypeId = Lead_RecordType,
                            Tipo_Base__c = ''
                            );

            leadsToCreate2.add(ld);
        }

        system.debug('LEADS PARA VALIDAR' + leadsToCreate2);


         List<Lead> leadExist = [SELECT Id, PROSP_Carga_RUT__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];
		 system.debug('leadRut' + leadRut.size());
         system.debug('leadExist' + leadExist.size());
          for (Lead ld: leadExist )
          {
              CampaignMember cm = new CampaignMember(
                  campaignId = cmp.Id,
                  
                  leadId = ld.Id
              );
              cmpMembers.add(cm);
          }

         system.debug('cmpMembers' + cmpMembers.size());
        try
        {

            insert cmpMembers;

            insert leadsToCreate2;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }


        /* List<Lead> leadIds = [SELECT Id, Fecha_Entrevista__c FROM Lead WHERE PROSP_Carga_RUT__c  IN :leadRut];

        for (Lead ids : leadIds)
        {
            ids.Fecha_Entrevista__c = system.today();
        }

        try
        {
            update leadIds;
        }
        catch (DmlException e)
        {
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION'  ,
            e.getDmlStatusCode(0));
        }*/

        Test.stopTest();
    }

}