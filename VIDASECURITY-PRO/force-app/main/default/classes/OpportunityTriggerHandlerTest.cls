/* Tests para el handler de oportunidad para Comercial */
@isTest
private class OpportunityTriggerHandlerTest{
    
    public static void insertUserTec(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :ComercialConstants.profileEjecutivoTecnico].Id,
            LastName = 'prueba',
            Email = 'test@test.com',
            username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'prueba',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Santiago',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'es_CL',
            EmailEncodingKey = 'ISO-8859-1',
            RUT_Usuario__c = '2004486857',
            UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'Administrador'].Id
        );
        Insert u;

        User uN = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :ComercialConstants.profileEjecutivoComercial].Id,
            LastName = 'prueba',
            Email = 'test1@test.com',
            username = 'test1@test.com' + System.currentTimeMillis(),
            CompanyName = 'prueba1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Santiago',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'es_CL',
            EmailEncodingKey = 'ISO-8859-1',
            RUT_Usuario__c = '2004486858',
            UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'Administrador'].Id
        );
        Insert uN;        
    }

    @testSetup static void setUpData(){
        insertUserTec();

        User u = [SELECT Id FROM User WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial ORDER BY Id DESC LIMIT 1];        

        System.runAs(u){

            Account ac = new Account(
                Name = 'Pruebas',
                Rut__c = '200448685',
                Coberturas__c = 'Vida;Catastrófico',
                RecordTypeId = ComercialConstants.accountComercial
            );
            Insert ac;

            Corredor__c co = new Corredor__c(
                Name = 'Pruebas',
                Rut__c = '200448685',
                Cuenta__c = ac.Id
            );
            Insert co;

            Contact c = new Contact(
                FirstName = 'pruebas',
                LastName = 'pruebas',
                Salutation = 'Sr.',
                Empresa_Corredora__c = co.Id,
                AccountId = ac.Id,
                Email = 'test@test.com',
                RecordTypeId = ComercialConstants.contactComercial
            );
            Insert c;
        
            Opportunity op = new Opportunity(
                Name = 'prueba',
                AccountId = ac.Id,
                Estado__c = 'Sin Reserva',
                StageName = ComercialConstants.oppStageOpen,
                CloseDate = Date.today() + 1,
                checklist_NominaTrabajadores__c = true,
                RecordTypeId = ComercialConstants.opportunityComercialNuevo,
                FechaInicioVigencia__c = Date.today() + 1
            );
            Insert op;

            Corredores_Venta__c cv = new Corredores_Venta__c(
                Id_Oportunidad__c = op.Id,
                Corredor__c = co.Id,
                Contacto__c = c.Id
            );
            Insert cv;
        }
    }

    @isTest static void inicializarOportunidadComercial(){
        User uN = [SELECT Id FROM User 
        WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial
        ORDER BY Id DESC LIMIT 1];        

        System.runAs(uN){
            Opportunity op = new Opportunity(
                Name = 'abc',
                CloseDate = Date.today() + 1,
                StageName = 'Ingresar Negocio'
            );
            
            Test.startTest();
            insert op;
            Test.stopTest();

            op = [SELECT StageName FROM Opportunity WHERE Id = :op.Id];
            System.assertEquals(op.StageName, ComercialConstants.oppStageOpen);
        }
    }

    @isTest static void validacionCuentaConReservaTest() {
        User uN = [SELECT Id FROM User 
        WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial
        ORDER BY Id DESC LIMIT 1];        

        System.runAs(uN){
            Account cuenta = [SELECT Id FROM Account];
            Opportunity opp = [SELECT Estado__c FROM Opportunity];
            opp.Estado__c = 'Reserva';
            update opp;

            Opportunity op = new Opportunity(
                Name = 'prueba',
                AccountId = cuenta.Id,
                StageName = 'Ingresar Negocio',
                CloseDate = Date.today() + 1
            );

            try{
                Test.startTest();
                insert op;
                Test.stopTest();
            }catch(Exception e) {
                System.Assert(e.getMessage().contains('Cliente ya posee una oportunidad en reserva, favor cierre primero esa oportunidad'), 'No se está generando la exepción'); 
            }
        }
    }

    @isTest static void validaCotizacionNOCerradaTest() {
        Opportunity op = [SELECT Id, StageName FROM Opportunity LIMIT 1];

        op.StageName = ComercialConstants.oppStageRequest;
        op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() +1;
        op.FechaInicioVigencia__c = Date.today() + 1;
        update op;
        
        op.StageName = ComercialConstants.oppStageCotizacion;
        update op;

        Quote qt = new Quote(
            Name = '1',
            OpportunityId = op.Id,
            Status = 'Negociación',
            RecordTypeId = ComercialConstants.quoteComercial
        );

        insert qt;

        Opportunity opp = [SELECT StageName,Id FROM Opportunity WHERE Id =: op.Id];
        opp.StageName = 'Cerrada';
        opp.Estado_cierre__c = 'Adjudicada';
        opp.Ranking_cotizacion_cerrada__c = 2;
        opp.Diferencia_con_mejor_propuesta__c = 1;
        opp.Diferencia_mejor_propuesta_ultima_oferta__c = 3;
        opp.Fecha_de_inicio_vigencia__c = System.today();

        try{
            Test.startTest();
            update opp;
            Test.stopTest();
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('Debe cerrar al menos una cotización antes de cerrar la oportunidad'), 'No se está generando la exepción'); 
        }
    }    

    /*
    @isTest static void validaCotizacionCerradaTest() {   
        
        Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];
        
        op.StageName = ComercialConstants.oppStageRequest;
        op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() +1;
        op.FechaInicioVigencia__c = Date.today() + 1;
        update op; 
        
        op.StageName = ComercialConstants.oppStageCotizacion;
        update op; 

        User u = [SELECT Id FROM User 
                    WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico 
                    ORDER BY Id DESC LIMIT 1];         

        Quote qt = new Quote(
            Name = '1',
            OpportunityId = op.Id,
            RecordTypeId = ComercialConstants.quoteComercial,
            Status = ComercialConstants.qtStatusPrepAntecedentes
        );

        insert qt;

        qt.Suscriptor__c = u.Id;
                
        update qt;

        ContentVersion cv = new ContentVersion(
            Title = 'Propuesta Comercial',
            PathOnClient = 'NonExistent',
            VersionData = Blob.valueOf('This is a test')
        );

        insert cv;

        ContentDocument cd = [
            SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id LIMIT 1
        ];

        qt.IdPropuestaComercial__c = cd.Id;
        qt.Status = ComercialConstants.qtStatusNegociacion;
        update qt; 
            
        qt.Status = ComercialConstants.qtStatusClosed;
        update qt;        

        Opportunity opp = [SELECT StageName,Id FROM Opportunity WHERE Id =: op.Id];
        opp.StageName = 'Cerrada';
        opp.Estado_cierre__c = 'Adjudicada';
        opp.Ranking_cotizacion_cerrada__c = 2;
        opp.Diferencia_con_mejor_propuesta__c = 1;
        opp.Diferencia_mejor_propuesta_ultima_oferta__c = 3;
        opp.Fecha_de_inicio_vigencia__c = System.today();

        Test.startTest();
        update opp;
        Test.stopTest();

        System.assertEquals('Cerrada', opp.StageName);
    }
    
    @isTest static void modificaCuentaDeclinadaTest() {

        User uN = [SELECT Id FROM User 
                    WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial
                    ORDER BY Id DESC LIMIT 1];        

        System.runAs(uN){
            
            EmailTemplate template = new EmailTemplate (
                developerName = 'Correo_Oportunidad_Cotizacion',
                FolderId = UserInfo.getUserId(),
                TemplateType= 'Text',
                Name = 'test',
                isActive = true
            ); 
            Insert template;

            Account cuenta = [SELECT Id, Empresa_declinada__c, Motivo_de_declinado__c FROM Account LIMIT 1];
            Opportunity op = [SELECT Estado__c, StageName, Motivo_de_perdida__c, Sub_motivo_de_perdida__c, FechaInicioVigencia__c FROM Opportunity LIMIT 1];
            
            op.StageName = ComercialConstants.oppStageRequest;
            op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() +1;
            op.FechaInicioVigencia__c = Date.today() + 1;
            update op;            
            
            op.Estado__c = 'Reserva';
            op.StageName = ComercialConstants.oppStageCotizacion;
            Update op;        

            User u = [SELECT Id FROM User 
                        WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico 
                        ORDER BY Id DESC LIMIT 1];

            Quote qt = new Quote(
                Name = '1',
                OpportunityId = op.Id,
                RecordTypeId = ComercialConstants.quoteComercial,
                Status = ComercialConstants.qtStatusPrepAntecedentes
            );
            Insert qt;

            qt.Suscriptor__c = uN.Id;
            Update qt;

            Productos_comercial__c pr = new Productos_comercial__c(
                N_Titulares__c = 34,
                Precio__c = 456.567,
                Productos__c = 'Vida',
                Id_Cotizacion__c = qt.Id
            );
            Insert pr;

            ContentVersion cv = new ContentVersion(
                Title = 'Propuesta Comercial',
                PathOnClient = 'NonExistent',
                VersionData = Blob.valueOf('This is a test')
            );
            Insert cv;

            ContentDocument cd = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId = :cv.Id LIMIT 1];

            qt.IdPropuestaComercial__c = cd.Id;
            qt.Status = ComercialConstants.qtStatusNegociacion;
            Update qt;        

            qt.Status = ComercialConstants.qtStatusClosed;
            Update qt;    

            op.StageName = 'Cerrada';
            op.Estado_cierre__c = 'Declinada';
            op.Motivo_de_perdida__c = 'Declinada - Comercial';
            op.Sub_motivo_de_perdida__c = 'Plazo';
            op.Ranking_cotizacion_cerrada__c = 2;
            op.Diferencia_con_mejor_propuesta__c = 1;
            op.Diferencia_mejor_propuesta_ultima_oferta__c = 3;
            op.Fecha_de_inicio_vigencia__c = System.today();

            Test.startTest();
                Update op;
            Test.stopTest();

            Account cuentaNueva = [SELECT Id, Empresa_declinada__c, Motivo_de_declinado__c FROM Account WHERE Id =: cuenta.Id];

            System.assertEquals(false, cuenta.Empresa_declinada__c);
            System.assertEquals(null, cuenta.Motivo_de_declinado__c);
            System.assertEquals(true, cuentaNueva.Empresa_declinada__c);
            System.assertEquals('Plazo', cuentaNueva.Motivo_de_declinado__c);
        }
    }   
	*/
    
    @isTest static void validaCotizacionCerradaOppCerradaTest(){
        Opportunity op = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        
        op.StageName = ComercialConstants.oppStageRequest;
        op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() + 3;
        op.FechaInicioVigencia__c = Date.today() + 6;
        update op;        
        
        op.StageName = ComercialConstants.oppStageCotizacion;
        update op;

        Quote qt = new Quote(
            Name = '1',
            OpportunityId = op.Id,
            Status = 'Negociación',
            RecordTypeId = ComercialConstants.quoteComercial
        );

        insert qt;

        Opportunity opp = [SELECT StageName, Id FROM Opportunity WHERE Id =: op.Id];
        opp.StageName = 'Cerrada';
        opp.Estado_cierre__c = 'No Adjudicada';
        opp.Motivo_de_perdida__c = 'Por condiciones';
        opp.Posible_Cierre_Pr_ximo_A_o__c = 'Media';
        opp.Ranking_cotizacion_cerrada__c = 2;
        opp.Fecha_de_inicio_vigencia__c = System.today();
        opp.Diferencia_con_mejor_propuesta__c = 1;
        opp.Diferencia_mejor_propuesta_ultima_oferta__c = 3;

        update opp;
       
        Test.startTest();
        update opp;
        Test.stopTest();
    }

    @isTest static void seteoInicialOportunidadRenovacion(){
        Test.startTest();
        Date hoy = Date.today();
        Date hoy60 = hoy.addDays(60);

        Account cuenta = new Account();
        cuenta.Name = 'cuenta 12';
        cuenta.Rut__c = '2553227';
        cuenta.DV__c = '2';
        cuenta.Holding__c = true;

        insert cuenta;

        Account ssd = [SELECT Id FROM Account WHERE Name =: cuenta.Name];

        Corredor__c co = new Corredor__c();
        co.Name = 'Pruebases';
        co.Rut__c = '20044868523';
        co.Cuenta__c = ssd.Id;

        insert co;

        Id recordTypeIndColectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();

        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = ssd.Id;
        poliza.Name = '1234';
        poliza.Fecha_Inicio_de_Poliza__c = hoy;
        poliza.Fecha_Termino_de_Poliza__c = hoy60;
        poliza.Fecha_Inicio_de_Vigencia_Original__c = hoy;
        poliza.RecordTypeId = recordTypeIndColectivos;
        poliza.Estatus__c = 'ACTIVA';
        poliza.Corredor__c = co.Id;
        poliza.Agrupacion_Comercial__c = '1234 (cuenta)';

        insert poliza;

        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = ssd.Id;
        poliza2.Name = '12345';
        poliza2.Fecha_Inicio_de_Poliza__c = hoy;
        poliza2.Fecha_Termino_de_Poliza__c = hoy60;
        poliza2.Fecha_Inicio_de_Vigencia_Original__c = hoy;
        poliza2.RecordTypeId = recordTypeIndColectivos;
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.Corredor__c = co.Id;
        poliza2.Agrupacion_Comercial__c = '1234 (cuenta)';

        insert poliza2;

        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = ssd.Id;
        poliza3.Name = '123456';
        poliza3.Fecha_Inicio_de_Poliza__c = hoy;
        poliza3.Fecha_Termino_de_Poliza__c = hoy60;
        poliza3.Fecha_Inicio_de_Vigencia_Original__c = hoy;
        poliza3.RecordTypeId = recordTypeIndColectivos;
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.Corredor__c = co.Id;
        poliza3.Agrupacion_Comercial__c = '12 (cuenta)';

        insert poliza3;

        Poliza__c poliza4 = new Poliza__c();
        poliza4.Cuenta__c = ssd.Id;
        poliza4.Name = '1244567';
        poliza4.Fecha_Inicio_de_Poliza__c = hoy;
        poliza4.Fecha_Termino_de_Poliza__c = hoy60;
        poliza4.Fecha_Inicio_de_Vigencia_Original__c = hoy;
        poliza4.RecordTypeId = recordTypeIndColectivos;
        poliza4.Estatus__c = 'ACTIVA';
        poliza4.Corredor__c = co.Id;
        poliza4.Agrupacion_Comercial__c = '1234 (cuenta)';

        insert poliza4;

        Opportunity op = new Opportunity(
            Name = '1234 prueba23 2020',
            AccountId = ssd.Id,
            Estado__c = 'Sin Reserva',
            StageName = ComercialConstants.oppStageOpen,
            CloseDate = Date.today() + 1,
            checklist_NominaTrabajadores__c = true,
            RecordTypeId = ComercialConstants.opportunityComercialRenovacion
        );
        insert op;
        Test.stopTest();
    }
}