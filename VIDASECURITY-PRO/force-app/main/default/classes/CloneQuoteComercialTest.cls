/**
 * Clone Quote Test para Comercial
 * @author: Brayan Mullor S.
 * @date: 24-06-2020
 */
@isTest
public class CloneQuoteComercialTest {
    @TestSetup
    public static void setUpData(){
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
            UserRoleId = [SELECT ID FROM UserRole WHERE Name = 'Administrador'].Id
        );

        insert u;

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
                RecordTypeId = ComercialConstants.opportunityComercialNuevo
            );
    
            insert op;

            op.StageName = ComercialConstants.oppStageCotizacion;

            update op;             
    
            Corredores_Venta__c cv = new Corredores_Venta__c(
                Id_Oportunidad__c = op.Id,
                Corredor__c = co.Id,
                Contacto__c = c.Id
            );
    
            insert cv; 
        }
       
    }
    @isTest
    static void clonarCotizacionTest() {

        User u = [SELECT Id FROM User 
                    WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico 
                    ORDER BY Id DESC LIMIT 1];        

        System.runAs(u){
            Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];

            // Crear quote
            Quote qt = new Quote(
                Name = 'testQuote',
                OpportunityId = op.Id,
                RecordTypeId = ComercialConstants.quoteComercial,
                Status = ComercialConstants.qtStatusPrepAntecedentes
            );
            insert qt;
    
            qt.Suscriptor__c = UserInfo.getUserId();
            
            update qt;
    
            Productos_comercial__c prd = new Productos_comercial__c(
                Id_Cotizacion__c = qt.Id,
                N_Titulares__c = 123,
                Precio__c = 123,
                Productos__c = 'Vida'
            );
    
            insert prd;
    
            Cargos_comercial__c ch = new Cargos_comercial__c(
                Id_Cotizacion__c = qt.Id,
                Precio__c = 123,
                Cargos__c = 'Fondos'
            );
    
            insert ch;        
    
            Test.startTest(); 
            Boolean result = CloneQuoteComercial.clonarCotizacion(qt.Id);
            Test.stopTest();
            
            Quote quote = [SELECT Id, Cantidad_de_cotizaciones_clonadas__c FROM Quote WHERE Id =:qt.Id];
            Opportunity opp = [SELECT Id, Cotizaciones__c FROM Opportunity WHERE Id =: op.Id];
    
            System.assertEquals(1, quote.Cantidad_de_cotizaciones_clonadas__c,'Cantidad de coti en quote incorrecto');
            System.assertEquals(2, opp.Cotizaciones__c, 'Cantidad de coti en opp incorrecto');
            System.assertEquals(true, result);            
        }
    }

    @isTest
    static void clonarCotizacionMultipleTest() {

        User u = [SELECT Id FROM User 
                    WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico 
                    ORDER BY Id DESC LIMIT 1];        

        System.runAs(u){
            Opportunity op = [SELECT Id FROM Opportunity LIMIT 1];

            // Crear quote
            Quote qt = new Quote(
                Name = 'testQuote',
                OpportunityId = op.Id,
                RecordTypeId = ComercialConstants.quoteComercial,
                Status = ComercialConstants.qtStatusPrepAntecedentes
            );
            insert qt;
    
            qt.Suscriptor__c = UserInfo.getUserId();
            
            update qt;
    
            Productos_comercial__c prd = new Productos_comercial__c(
                Id_Cotizacion__c = qt.Id,
                N_Titulares__c = 123,
                Precio__c = 123,
                Productos__c = 'Vida'
            );
    
            insert prd;
    
            Cargos_comercial__c ch = new Cargos_comercial__c(
                Id_Cotizacion__c = qt.Id,
                Precio__c = 123,
                Cargos__c = 'Fondos'
            );
    
            insert ch;
            Boolean clone = CloneQuoteComercial.clonarCotizacion(qt.Id);    
    
            Test.startTest();
            User datosUsuario = [SELECT id, Profile.Name FROM User WHERE ID =: userinfo.getuserid()];
            Profile idPerfil = [SELECT Id FROM Profile WHERE Profile.Name =: ComercialConstants.profileEjecutivoTecnico ];
            datosUsuario.Profile = idPerfil;
            update datosUsuario;        
            Boolean result = CloneQuoteComercial.clonarCotizacion(qt.Id);
            Test.stopTest();
    
            Quote quote = [SELECT Id, Cantidad_de_cotizaciones_clonadas__c FROM Quote WHERE Id =:qt.Id];
            Opportunity opp = [SELECT Id, Cotizaciones__c FROM Opportunity WHERE Id =: op.Id];
    
            System.assertEquals(2, quote.Cantidad_de_cotizaciones_clonadas__c);
            System.assertEquals(3, opp.Cotizaciones__c);
            System.assertEquals(true, result);
        }
    }    
}