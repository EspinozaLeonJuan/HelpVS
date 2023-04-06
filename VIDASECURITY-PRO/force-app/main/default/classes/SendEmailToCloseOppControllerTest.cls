@isTest
public class SendEmailToCloseOppControllerTest {

    @isTest
    public static void execute(){

          
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

           

            op.StageName = ComercialConstants.oppStageCotizacion;

            update op;
    

            Quote qt = new Quote(
                Name = '1',
                OpportunityId = op.Id,
                Status = 'Negociación',
                Suscriptor__c = u.id,
                FechaRecepAntecendentes__c = Date.today(),
                Fecha_de_Entrega_Requerida__c = Date.today(),
                RecordTypeId = ComercialConstants.quoteComercial
            );

            insert qt;

            qt.Status = 'Tarificacion';
            update qt; 

               
            Test.startTest();
            SendEmailToCloseOppController.sendEmail(op.Id);
            Test.stopTest();
        }

    }
}