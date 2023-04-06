@istest
public class NuevaOportunidad_AltaNoAdjSchedulerTEST {

    public static String CRON_EXP = '0 0 0 24 6 ? 2022';

    @istest
    static void testScheduledJob(){
        
        List<Opportunity> oppList = new List<Opportunity>();


        Account ac = new Account(
            Name = 'Pruebas',
            Rut__c = '200448685',
            Coberturas__c = 'Vida;Catastrófico',
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
            Estado__c = 'Sin Reserva',
            StageName = ComercialConstants.oppStageOpen,
            CloseDate = Date.today() + 1,
            checklist_NominaTrabajadores__c = true,
            RecordTypeId = ComercialConstants.opportunityComercialNuevo
        );
    
        insert op;

        Corredores_Venta__c cv = new Corredores_Venta__c(
            Id_Oportunidad__c = op.Id,
            Corredor__c = co.Id,
            Contacto__c = c.Id
        );

        insert cv;
    
 

        /*Quote qt = new Quote(
            Name = 'Qt1',
            Opportunityid = op.id
        );
        insert qt;
*/  
        
        op.StageName = 'Cerrada';
        op.Motivo_de_perdida__c = 'Por condiciones'; 
        op.Fecha_de_inicio_vigencia__c = System.Today().addDays(2);
        op.Estado_cierre__c =  'No adjudicada'; 
        op.Sub_estado_oportunidad__c =  'Terminada'; 
        op.Fecha_Cierre_Absoluta__c = System.Today().addDays(2);
        op.Posible_Cierre_Pr_ximo_A_o__c = 'Alta';
        update op;
        


        Test.startTest();
           String jobId = System.schedule('ScheduledApexTest',
           CRON_EXP, 
           new NuevaOportunidad_AltaNoAdjScheduler()); 
        Test.stopTest();
        
    }

    @istest
    static void testScheduledJob2(){
        
        List<Opportunity> oppList = new List<Opportunity>();


        Account ac = new Account(
            Name = 'Pruebas',
            Rut__c = '200448685',
            Coberturas__c = 'Vida;Catastrófico',
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
            Estado__c = 'Sin Reserva',
            StageName = ComercialConstants.oppStageOpen,
            CloseDate = Date.today() + 1,
            checklist_NominaTrabajadores__c = true,
            RecordTypeId = ComercialConstants.opportunityComercialNuevo
        );
    
        insert op;

        Opportunity op2 = new Opportunity(
            Name = 'prueba',
            AccountId = ac.Id,
            Estado__c = 'Reserva',
            StageName = ComercialConstants.oppStageOpen,
            CloseDate = Date.today() + 1,
            checklist_NominaTrabajadores__c = true,
            RecordTypeId = ComercialConstants.opportunityComercialNuevo
        );
    
        insert op2;

        Corredores_Venta__c cv = new Corredores_Venta__c(
            Id_Oportunidad__c = op.Id,
            Corredor__c = co.Id,
            Contacto__c = c.Id
        );

        insert cv;
    
 

        /*Quote qt = new Quote(
            Name = 'Qt1',
            Opportunityid = op.id
        );
        insert qt;
*/  
        
        op.StageName = 'Cerrada';
        op.Motivo_de_perdida__c = 'Por condiciones'; 
        op.Fecha_de_inicio_vigencia__c = System.Today().addDays(2);
        op.Estado_cierre__c =  'No adjudicada'; 
        op.Sub_estado_oportunidad__c =  'Terminada'; 
        op.Fecha_Cierre_Absoluta__c = System.Today().addDays(2);
        op.Posible_Cierre_Pr_ximo_A_o__c = 'Alta';
        update op;
        


        Test.startTest();
           String jobId = System.schedule('ScheduledApexTest',
           CRON_EXP, 
           new NuevaOportunidad_AltaNoAdjScheduler()); 
        Test.stopTest();
        
    }
}