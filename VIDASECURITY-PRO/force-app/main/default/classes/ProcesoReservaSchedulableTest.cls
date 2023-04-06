@isTest private class ProcesoReservaSchedulableTest
{
    static String cronExpr = '0 0 0 15 3 ? 2025';
    
    @isTest static void jobTest()
    {
        Test.startTest();
            setData();
            ProcesoReservaSchedulable prs = new ProcesoReservaSchedulable();
            String jobId = System.schedule('testProcesoReserva', cronExpr, prs);
            prs.execute(null);
        Test.stopTest();
    }
    
    private static void setData()
    {
        Account acc = new Account(
            Name = 'Test Company',
            RecordTypeId = getRecordTypeId('Cuenta Corporativa'),
            Rut__c = '22333444',
            DV__c = '4'
        );
        Insert acc;
               
        Corredor__c cor = new Corredor__c(
            Name = 'Test Corredor',
            RUT__c = '11222333'
        );
        Insert cor;
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            AccountId = acc.Id,
            RecordTypeId = getRecordTypeId('Comercial Nuevo'),
            UFA_Supuesta__c = 100001,
            StageName = 'Solicitud Antecedentes',
            Sub_estado_oportunidad__c = 'Pendiente Comercial',
            QuienFinanciaPrima__c = 'Mixto',
            CorredorPropuesta__c = cor.Id,
            CloseDate = System.today(),
            Estado__c = 'Reserva',
            FechaInicioVigencia__c = Date.today().addDays(getDate())
        );
        Insert opp;
        
        Contact con = new Contact(
            Lastname = 'Test Contacto',
            Email = 'test@test.com',
            RecordTypeId = getRecordTypeId('Corredor'),
        	Empresa_Corredora__c = cor.Id,
        	AccountId = acc.Id
        );
        Insert con;
       
        Corredores_Venta__c cv = new Corredores_Venta__c(
            Id_Oportunidad__c = opp.Id,
            Corredor__c = cor.Id,
            Contacto__c = con.Id
        );
        Insert cv;
        
        opp.StageName = 'Solicitud Antecedentes';
        opp.Estado__c = 'Reserva';
        Update opp;
    }
    
    private static Id getRecordTypeId(String name){
        return [SELECT Id FROM RecordType WHERE Name = :name LIMIT 1].Id;
    }
    
    private static Integer getDate(){
        Date now = Date.today();
        Integer days = 5;
        Integer response;
        
        for(Integer i = 0; i <= days; i++){
            if(twoDaysBeforeExpiration(now.addDays(i))){
                response = i;
            }
        }

        return response;
    }
    
    private static Boolean twoDaysBeforeExpiration(Date inputDate)
    {
        Set<String> businessDays = new Set<String>{'SUN','SAT'};
        String dayOfWeek;

        Integer contDaysOfWeek = 0;
        Integer contDays = 0;
        Integer days = 5;

        Datetime myDateTime;
        Datetime inputParameter = inputDate; 
        Datetime now = Date.today();

        for(Integer i = 0; i <= days; i++){
            if(i == 0){
                myDateTime = now;
            } else {
                myDateTime =  now.addDays(i);
            }

            dayOfWeek = myDateTime.addDays(1).format('E');

            if(businessDays.contains(dayOfWeek.toUpperCase())){
                contDaysOfWeek = 2;
            }
            
            if(inputParameter == myDateTime){
                contDays = (i - contDaysOfWeek);
            }
        }

        Boolean response = (contDays == 2);

        return response;
    }
}