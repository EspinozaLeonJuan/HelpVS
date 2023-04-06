/**
 * Tests para el handler de Cotización para Comercial
 * @author: ChangeMeIn@UserSettingsUnder.SFDoc
 */
@isTest
public class QuoteTriggerHandlerTest {

    public static void insertUserTec(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =: ComercialConstants.profileEjecutivoTecnico].Id,
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
            IsActive = true,
            UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'Administrador'].Id
        );

        insert u;

        User uN = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name =:ComercialConstants.profileEjecutivoComercial].Id,
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
            IsActive = true,
            UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'Administrador'].Id
        );

        insert uN;           
    }

    @testSetup 
    static void setUpData(){
        
        insertUserTec();
        User u = [SELECT Id FROM User WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial ORDER BY Id DESC LIMIT 1];        
        System.runAs(u){
            
            Account ac = new Account(
                Name = 'Pruebas',
                Rut__c = '200448685',
                RecordTypeId = ComercialConstants.accountComercial
            );
            insert ac;

            Corredor__c co = new Corredor__c(
                Name = 'Pruebas',
                Rut__c = '200448685',
                Cuenta__c = ac.Id
            );
            insert co;
            
            Contact c = new Contact(
                FirstName = 'pruebas',
                LastName = 'pruebas',
                Salutation = 'Sr.',
                Empresa_Corredora__c = co.Id,
                AccountId = ac.Id,
                Email = 'test@test.com',
                RecordTypeId = ComercialConstants.contactComercial
            );
            insert c;        

            Opportunity op = new Opportunity(
                Name = 'prueba',
                AccountId = ac.Id,
                Estado__c = 'Reserva',
                CloseDate = Date.today() + 1,
                StageName = ComercialConstants.oppStageOpen,
                checklist_NominaTrabajadores__c = true,
                RecordTypeId = ComercialConstants.opportunityComercialRenovacion,
                FechaInicioVigencia__c = Date.today() + 1,
                OwnerId = u.Id
            );
            insert op;

            Corredores_Venta__c cv = new Corredores_Venta__c(
                Id_Oportunidad__c = op.Id,
                Corredor__c = co.Id,
                Contacto__c = c.Id
            );
            insert cv;  
            
            op.StageName = ComercialConstants.oppStageRequest;
            op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() + 1;
            op.FechaInicioVigencia__c = Date.today() + 1;
            update op;            
        }      
    }
    
	@isTest 
    static void crearCotizacionComercial_Success() {
        
        User uN = [SELECT Id FROM User WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial ORDER BY Id DESC LIMIT 1];        
        System.runAs(uN){
            
            Account ac = new Account(
                Name = 'Pruebas',
                Rut__c = '100448685',
                RecordTypeId = ComercialConstants.accountComercial
            );
            insert ac;

            Corredor__c co = new Corredor__c(
                Name = 'Pruebas',
                Rut__c = '400448685',
                Cuenta__c = ac.Id
            );
            insert co;
            
            Contact c = new Contact(
                FirstName = 'pruebas',
                LastName = 'pruebas',
                Salutation = 'Sr.',
                Empresa_Corredora__c = co.Id,
                AccountId = ac.Id,
                Email = 'vass@test.com.mx',
                RecordTypeId = ComercialConstants.contactComercial
            );
            insert c;        

            Opportunity op = new Opportunity(
                Name = 'abc',
                CloseDate = Date.today() + 1,
                Estado__c = 'Reserva',
                checklist_NominaTrabajadores__c = true,
                RecordTypeId = ComercialConstants.opportunityComercialNuevo,
                StageName = ComercialConstants.oppStageOpen
            );
            insert op;

            Corredores_Venta__c cv = new Corredores_Venta__c(
                Id_Oportunidad__c = op.Id,
                Corredor__c = co.Id,
                Contacto__c = c.Id
            );
            insert cv;             
        
            op.StageName = ComercialConstants.oppStageRequest;
            op.Fecha_de_recepcion_de_antecedentes__c  = Date.today() + 1;
            op.FechaInicioVigencia__c = Date.today() + 1;
            update op; 
            
            op.StageName = ComercialConstants.oppStageCotizacion;
            update op;
            
            if(op.StageName == ComercialConstants.oppStageCotizacion){
                Quote qt = new Quote(
                    Name = '1',
                    OpportunityId = op.Id,
                    RecordTypeId = ComercialConstants.quoteComercial
                    );
                insert qt;
    
                qt = [
                    SELECT Id
                    , IdCotizacionComercial__c
                    , FechaPrepAntecedentes__c
                    , FechaTarificacion__c
                    , FechaPrepCotizacion__c
                    , CreatedDate
                    FROM Quote WHERE Id = :qt.Id
                ];
                
                Date today = Date.today();
                Date fechaPrepAntecedentes = today.addDays(ComercialConstants.diasPrepAntecedentes);
                Date fechaTarificacion = fechaPrepAntecedentes.addDays(ComercialConstants.diasTarificacion);
                Date fechaPrepCoti = fechaTarificacion.addDays(ComercialConstants.diasPrepCotizacion);
                System.assert(qt.IdCotizacionComercial__c.contains('-COT1'), 'El id de la cotizacion no se esta asignando de la forma correcta');                
            }else{
            	System.assert(op.StageName != ComercialConstants.oppStageCotizacion, 'La oportunidad no se esta asignando a la etapa correcta');                                
            }
        }
    }

    @isTest
    static void getSuscriptoresdeRenovacion_Success(){
        User u = [SELECT Id FROM User WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial ORDER BY Id DESC LIMIT 1];        
        System.runAs(u){
			Test.startTest();
            User tecnico = [SELECT Id FROM User WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico ORDER BY Id DESC LIMIT 1];
            Account cuenta = [SELECT Id, Empresa_declinada__c, Motivo_de_declinado__c FROM Account];
            Opportunity op = [SELECT Id, Estado__c
                              , StageName
                              , Ranking_cotizacion_cerrada__c
                              , Cotizacion_de_cierre__c
                              , Cierre_UFA_totales__c
                              , Total_participantes_en_el_proceso__c 
                              FROM Opportunity LIMIT 1];

            op.StageName = ComercialConstants.oppStageRenovacion;
            update op;
            
            Quote qt = new Quote(Name = '1'
                                 , OpportunityId = op.Id
                                 , Suscriptor__c = tecnico.Id
                                 , RecordTypeId = ComercialConstants.quoteRenovacion);
            insert qt;
            
            List<Quote> lst = new List<Quote>();
            lst.add(qt);
            
            QuoteTriggerHandler.getSuscriptoresdeRenovacion(lst);
            Test.stopTest();            
        }
    }
    
    @isTest
    static void modificarValoresOportunidad_Success(){
        User u = [SELECT Id FROM User WHERE Profile.Name =:ComercialConstants.profileEjecutivoComercial ORDER BY Id DESC LIMIT 1];        
        System.runAs(u){
			Test.startTest();
            
            User tecnico = [SELECT Id FROM User WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico ORDER BY Id DESC LIMIT 1];
            Account cuenta = [SELECT Id, Empresa_declinada__c, Motivo_de_declinado__c FROM Account];
            Opportunity op = [SELECT Id, Estado__c
                              , StageName
                              , Ranking_cotizacion_cerrada__c
                              , Cotizacion_de_cierre__c
                              , Cierre_UFA_totales__c
                              , Total_participantes_en_el_proceso__c 
                              FROM Opportunity LIMIT 1];

            op.StageName = ComercialConstants.oppStageRenovacion;
            update op;
            
            Quote qt = new Quote(Name = '1'
                                 , OpportunityId = op.Id
                                 , Suscriptor__c = tecnico.Id
                                 , IdPropuestaTecnica__c = 'XX1'
                                 , Status = ComercialConstants.qtStatusTarificacion
                                 , RecordTypeId = ComercialConstants.quoteRenovacion);
            insert qt;
            
            List<Quote> oldlst = new List<Quote>();
            oldlst.add(qt);
            
            Productos_comercial__c prd = new Productos_comercial__c(
                Id_Cotizacion__c = qt.Id,
                Precio__c = 420,
                N_Titulares__c = 69,
                Productos__c = Productos_comercial__c.Productos__c.getDescribe().getPicklistValues().get(0).value
            );
            insert prd;            

            qt.Status = ComercialConstants.qtStatusPrepCotizacion;
            update qt;
            
            qt.Status = ComercialConstants.qtStatusNegociacion;
            update qt;            
            
            qt.Status = ComercialConstants.qtStatusClosed;
            update qt;
            
            List<Quote> newlst = new List<Quote>();
            newlst.add(qt);            
            
            QuoteTriggerHandler.modificarValoresOportunidad(newlst, oldlst);
            Test.stopTest();            
        }        
    }
    
}