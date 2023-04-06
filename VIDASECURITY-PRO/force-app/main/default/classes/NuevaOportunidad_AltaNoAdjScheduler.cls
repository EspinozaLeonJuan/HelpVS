global class NuevaOportunidad_AltaNoAdjScheduler Implements Schedulable{

    global void execute(SchedulableContext ctx){
        createOpps();
    }

    
    global void createOpps(){

        String comercialNuevoType = ComercialConstants.opportunityComercialNuevo;
        List<Opportunity> newOppList = new List<Opportunity>();        
    
        List<Opportunity> oppList = [select id, UFA_Supuesta__c, CorredorPropuesta__c,
                                    CloseDate, OwnerId, Fecha_de_inicio_vigencia__c,
                                    name, NumTrabajadores__c, Coberturas__c,ActividadAsegurados__c,
                                    AccountId, Proactiva__c, OPOR_Codigo_Sucursal__c,
                                    Estado__c, AntiguedadYears__c, Corredor_actual__c,
                                    Tipo_de_cuenta__c, Aseguradora_Adjudicada__c,
                                    AseguradoraVigente__c, TieneBMI__c, TieneDEF__c,
                                    Account.Cliente_Asegurado_Empresa__c
                                    from Opportunity where StageName = 'Cerrada' 
                                    and Estado_cierre__c = 'No adjudicada' 
                                    and Posible_Cierre_Pr_ximo_A_o__c = 'Alta' 
                                    and (Fecha_Cierre_Absoluta__c = THIS_MONTH Or
                                    CloseDate = THIS_MONTH)
                                    and RecordTypeId = :comercialNuevoType];//0120H000000yVTjQAM

        if(oppList.size() == 0) return;

        //Buscar si la cuenta relacionada a la oportunidad procesada contiene algua oportunidad en Reserva
        Set<String> accountIdwReserva = new set<String>();
        for(Opportunity tempOpp : oppList) {accountIdwReserva.add(tempOpp.AccountId); } 
        Map<Id,Account> accList = new Map<Id,Account>([select id, (select id from Opportunities where Estado__c = 'Reserva') 
                                     from Account where id IN : accountIdwReserva]);

        if(accList.size() == 0) return;

        List<String> oppNoCreated = new List<String>();
        Opportunity newOpp;

        for(Opportunity tempOpp : oppList)
        {
            //aparta las oportundidades en "Reserva" para envio de correo
            if(accList.get(tempOpp.AccountId).Opportunities.size() > 0) 
            {
                oppNoCreated.add(tempOpp.Name); continue;
            }

            //preparacion de valores de la oportunidad procesada para ser creada
            newOpp = new Opportunity();
           /* newOpp.Name                        = (tempOpp.Account.FirstName != null) ? tempOpp.Account.FirstName + ' ' : '';
            newOpp.Name                       += (tempOpp.Account.LastName!= null) ? tempOpp.Account.LastName + ' ' : '';*/
            newOpp.Name                        = tempOpp.Account.Cliente_Asegurado_Empresa__c ;
            newOpp.Name                       += ' ' + tempOpp.CloseDate.addYears(1).year();//tempOpp.name.replace(tempOpp.name.right(4),' ' + String.valueOf(tempOpp.CloseDate.year() + 1));//
            newOpp.RecordTypeId                = comercialNuevoType;
            newOpp.UFA_Supuesta__c             = tempOpp.UFA_Supuesta__c;
            newOpp.CorredorPropuesta__c        = tempOpp.CorredorPropuesta__c;
            newOpp.CloseDate                   = tempOpp.CloseDate.addYears(1);
            newOpp.OwnerId                     = tempOpp.OwnerId;
            newOpp.StageName                   = 'Ingresar Negocio';
            newOpp.Fecha_de_inicio_vigencia__c = tempOpp.Fecha_de_inicio_vigencia__c.addYears(1).addMonths(-3);
            newOpp.NumTrabajadores__c          = tempOpp.NumTrabajadores__c;
            newOpp.Coberturas__c               = tempOpp.Coberturas__c;
            newOpp.ActividadAsegurados__c      = tempOpp.ActividadAsegurados__c;
            newOpp.Proactiva__c                = true;
            newOpp.OPOR_Codigo_Sucursal__c     = tempOpp.OPOR_Codigo_Sucursal__c;
            newOpp.AccountId                   = tempOpp.AccountId;
            newOpp.Estado__c                   = tempOpp.Estado__c;
            newOpp.AntiguedadYears__c          = tempOpp.AntiguedadYears__c;
            newOpp.Corredor_actual__c          = tempOpp.Corredor_actual__c;
            newOpp.Tipo_de_cuenta__c           = tempOpp.Tipo_de_cuenta__c;
            newOpp.Aseguradora_Adjudicada__c   = tempOpp.Aseguradora_Adjudicada__c;
            newOpp.AseguradoraVigente__c       = tempOpp.AseguradoraVigente__c;
            newOpp.TieneBMI__c                 = tempOpp.TieneBMI__c;
            newOpp.TieneDEF__c                 = tempOpp.TieneDEF__c;
            newOppList.add(newOpp);
        }

        insert newOppList;

        //Envio de correo por oportunidad ya en "Reserva"
        if(!oppNoCreated.isEmpty()){

            List<User> jefatura = [select id, email, Profile.name 
                                   from user where Profile.name IN ('Jefatura Comercial Colectivo', 'Jefatura Técnica Colectivo')];

            List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
            messaging.SingleEmailMessage singleMail;
            List<String> subsEmail;
            String body = '';
            String subject;

            subsEmail = new List<String>();
            //subsEmail.add('alvaro.rojas@vasslatam.com');
            for(User user : jefatura) {
                if(user.email != null) subsEmail.add(user.email);
            }

            if(subsEmail.isEmpty()) return;
            singleMail = new messaging.SingleEmailMessage();
            singleMail.setUseSignature(false);
            singleMail.setSaveAsActivity(false);
            singleMail.setReplyTo('example@example.com');
            singleMail.setToAddresses(subsEmail);

            subject = 'Proceso nueva oportunidad no adjudicada-alta (En reserva)';
            singleMail.setSubject(subject);

            body = 'Estimados(a) ,\nTe informamos que las siguientes oportunidad no pudieron crearse por motivos de reserva:';
            for(String op : oppNoCreated) body +=  '\n- ' + op;
            singleMail.setPlainTextBody(body);
            
            mailsToSend.add(singleMail); 
    
            if(mailsToSend.isEmpty()){
                return;
            } else {
                Messaging.sendEmail(mailsToSend);
            }
        }
    }

}