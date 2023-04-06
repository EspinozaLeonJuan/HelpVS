global class ProcesoReservaSchedulable implements Schedulable
{
    global void execute(SchedulableContext sc){
        notificaionesProcesoReserva();
    }

    public static void notificaionesProcesoReserva()
    {
        try
        {
            List<Opportunity> oppData = new List<Opportunity>();
            if(Schema.sObjectType.Opportunity.isAccessible()){
                oppData = [SELECT Id, OwnerId, FechaInicioVigencia__c
                            FROM Opportunity
                            WHERE RecordType.Name = 'Comercial Nuevo'
                            AND StageName = 'Solicitud Antecedentes'
                            AND FechaInicioVigencia__c <> null];
            }

            if(oppData.isEmpty()){ return; }

            List<Opportunity> oppVigentes = new List<Opportunity>();
            List<Opportunity> oppVencidas = new List<Opportunity>();
            Date now = Date.today();

            for(Opportunity item: oppData)
            {
                Date inicioVigencia = item.FechaInicioVigencia__c;

                // Oportunidades con 2 días previos al vencimiento
                if(twoDaysBeforeExpiration(inicioVigencia)){
                    oppVigentes.add(item);
                }

                // Oportunidades Vencidas
                if(now == inicioVigencia){
                    oppVencidas.add(item);
                }
            }

            if(!oppVigentes.isEmpty()){
                Map<String, List<String>> corredoresOpp = corredoresPorOportunidad(oppVigentes);
                Map<String, String> propietariosOpp = propietariosPorOportunidad(oppVigentes);
                if(!corredoresOpp.isEmpty() && !propietariosOpp.isEmpty()){
                    emailGeneration('Notificacion_reserva_proxima_vencer', oppVigentes, corredoresOpp, propietariosOpp);
                }
            }

            if(!oppVencidas.isEmpty()){
                Map<String, List<String>> corredoresOpp = corredoresPorOportunidad(oppVencidas);
                Map<String, String> propietariosOpp = propietariosPorOportunidad(oppVencidas);
                if(!corredoresOpp.isEmpty() && !propietariosOpp.isEmpty()){
                    emailGeneration('Notificacion_reserva_vencida', oppVencidas, corredoresOpp, propietariosOpp);
                }
            }
        }
        catch(Exception e)
        {
            System.debug('Exception type caught: ' + e.getTypeName());   
            System.debug('Message: ' + e.getMessage());   
            System.debug('Cause: ' + e.getCause()); 
            System.debug('Line number: ' + e.getLineNumber());   
            System.debug('Stack trace: ' + e.getStackTraceString());
        }
    }

    private static Boolean twoDaysBeforeExpiration(Date fechaInicioReserva)
    {
        Set<String> businessDays = new Set<String>{'SUN','SAT'};
        String dayOfWeek;

        Integer contDaysOfWeek = 0;
        Integer contDays = 0;
        Integer days = 5;

        Datetime myDateTime;
        Datetime inputParameter = fechaInicioReserva; 
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

    private static Map<String, List<String>> corredoresPorOportunidad(List<Opportunity> opps)
    {
        Map<String, List<String>> response = new Map<String, List<String>>();
        Set<Id> idOpp = new Set<Id>();

        for (Opportunity item: opps){
            idOpp.add(item.Id);
        }

        List<Corredores_Venta__c> dataCorredor = new List<Corredores_Venta__c>();
        if(Schema.sObjectType.Corredores_Venta__c.isAccessible()){
            dataCorredor = [SELECT Id_Oportunidad__c, Email_contacto__c
                            FROM Corredores_Venta__c
                            WHERE Id_Oportunidad__c IN :(idOpp)];
        }

        if(dataCorredor.isEmpty()) { return response; }
        
        List<String> email;

        for(Corredores_Venta__c item: dataCorredor)
        {
            String idop = item.Id_Oportunidad__c;

            if(!response.containsKey(idOp)){
                response.put(idop, new List<String>());
            }
            response.get(idop).add(item.Email_contacto__c);
        }

        return response;
    }

    private static Map<String, String> propietariosPorOportunidad(List<Opportunity> opps)
    {
        Set<Id> idOwners = new Set<Id>();

        for (Opportunity item: opps){
            idOwners.add(item.OwnerId);
        }

        Map<Id, User> dataOwners = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN :(idOwners)]);
        Map<String, String> response = new Map<String, String>();

        if(!dataOwners.isEmpty()){
            for(Opportunity item: opps){
                response.put(item.Id, dataOwners.get(item.OwnerId).Email);
            }
        }

        return response;
    }

    private static void emailGeneration(String nombrePlantilla,
                                        List<Opportunity> opps,
                                        Map<String, List<String>> corredoresOpp,
                                        Map<String, String> propietariosOpp)
    {
        EmailTemplate emailTemplate = new EmailTemplate();
        if(Schema.sObjectType.EmailTemplate.isAccessible()){
            emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
                            FROM EmailTemplate
                            WHERE DeveloperName = :nombrePlantilla];
        }

        /*List<OrgWideEmailAddress> orgEmail = new List<OrgWideEmailAddress>();
        if(Schema.sObjectType.OrgWideEmailAddress.isAccessible()){
            orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'sfvida@security.cl'];
        }*/

        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
        List<String> listEmail = new List<String>();
        List<String> listEmailCc = new List<String>();

        Contact cnt = new Contact();
        cnt.LastName = 'sfvida';
        cnt.Email = 'sfvida@security.cl';
        Insert cnt;
        
        if(String.isEmpty(cnt.Id)){ return; }

        for (Opportunity item: opps)
        {
            String idOpp = item.Id;

            if(corredoresOpp.keySet().contains(idOpp))
            {
                for(String email: corredoresOpp.get(idOpp)){
                    listEmail.add(email);
                }

                listEmailCc.add(propietariosOpp.get(idOpp));

                singleMail.setToAddresses(listEmail);
                singleMail.setCcAddresses(listEmailCc);
                singleMail.setWhatId(idOpp);
                singleMail.setTemplateID(emailTemplate.Id);
                singleMail.setTargetObjectId(cnt.Id);
                singleMail.setTreatTargetObjectAsRecipient(false);

                /*if(!orgEmail.isEmpty()){
                    singleMail.setOrgWideEmailAddressId(orgEmail.get(0).Id);
                }*/

                singleMail.setUseSignature(false);
                singleMail.setSaveAsActivity(false);
                mailsToSend.add(singleMail);
                singleMail = new messaging.SingleEmailMessage();
                listEmail = new List<String>();
                listEmailCc = new List<String>();
            }    
        }      
            
        if(mailsToSend.isEmpty()){
            return;
        } else {
            Messaging.sendEmail(mailsToSend);
            Delete cnt;
        }
    }
}