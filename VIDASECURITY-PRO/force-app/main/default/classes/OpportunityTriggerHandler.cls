/**
     * Opportunity Trigger Handler para Comercial
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @date: 05-05-2020
     */
    public with sharing class OpportunityTriggerHandler 
    {
        public static final String COMERCIAL_NUEVO = 'Comercial Nuevo';
        public static final String COMERCIAL_RENOVACION = 'Comercial Renovación';
        public static final String CERRADA = 'Cerrada';
        public static final String EMPTY = '';

        public static void asignarCorrelativo(List<Opportunity> newOpps){
            List<Opportunity> ultima_oportunidad = [SELECT id, name, codigo_comercial__c FROM Opportunity 
                                                    WHERE codigo_comercial__c != null
                                                    ORDER BY codigo_comercial__c DESC LIMIT 1];

            Integer correlativo_temporal = 0;
            if(ultima_oportunidad.size() > 0){
                if(!String.IsBlank(ultima_oportunidad[0].codigo_comercial__c)){
                    correlativo_temporal = Integer.valueOf(ultima_oportunidad[0].codigo_comercial__c.substring(7));    
                }
            }

            String correlativo_final;

            for (Opportunity op: newOpps) {
                correlativo_temporal = correlativo_temporal + 1;
                correlativo_final = String.valueOf(system.today().year()) + '-OP' + String.valueOf(correlativo_temporal);
                op.codigo_comercial__c = correlativo_final;            
            }
        }

        /**
         * validacionReserva
         * Valida que no exista una oportunidad en reserva con el mismo rut
         * @author: ChangeMeIn@UserSettingsUnder.SFDoc
         * @param: newOpps List<Opportunity: before insert opportunities
         * @return: void
         * @date: 08-06-2020
         */
        public static void validacionReserva(List<Opportunity> newOpps)
        {
            Set<Id> idCuentas = new Set<Id>();
            Boolean closedAndDeclined;
            Boolean oppComercial = false;
            Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();

            for (Opportunity op: newOpps) {
                closedAndDeclined = (op.StageName == CERRADA && op.Estado_cierre__c == 'Declinada');
                if(!closedAndDeclined){
                    idCuentas.add(op.AccountId);
                    oppComercial = (op.RecordTypeId == comercialNuevo);
                }
            }

            if(!oppComercial){ return; }

            List<Opportunity> oportinidades = [SELECT Estado__c, AccountId, StageName FROM Opportunity Where AccountId IN :idCuentas];

            Set<Id> idCuentasConReserva = new Set<Id>();
            for (Opportunity opo: oportinidades){
                if(opo.Estado__c == 'Reserva' && opo.StageName != CERRADA){
                    idCuentasConReserva.add(opo.AccountId);
                }
            }

            if(idCuentasConReserva.isEmpty()) return;

            for (Opportunity op: newOpps) {
                if(idCuentasConReserva.contains(op.AccountId)){
                    op.addError('Cliente ya posee una oportunidad en reserva, favor cierre primero esa oportunidad');
                }
            }
        }

        /**
         * validaCotizacionesCerrada
         * Valida que se haya cerrada una cotización antes de cerrar la oportunidad
         * @author: ChangeMeIn@UserSettingsUnder.SFDoc
         * @param: newOpps List<Opportunity: before update opportunities
         * @return: void
         * @date: 12-06-2020
         */
        public static void validaCotizacionesCerrada(List<Opportunity> newOpps,List<Opportunity> oldOpps) {
            Set<Id> idOp = new Set<Id>();
            Boolean estadoModificado = false;
            for(Opportunity op: newOpps){
                for (Opportunity opp: oldOpps) {
                    if (opp.Id == op.Id && opp.Poliza__c != null) {
                        op.Poliza__c = opp.Poliza__c;
                    }
                    if(op.Id == opp.Id && op.StageName != opp.StageName && op.StageName == CERRADA && op.Estado_cierre__c == 'Renovada'){
                        estadoModificado = true;
                    }
                }
            }

            if (!estadoModificado) return;

            for (Opportunity op: newOpps) {
                idOp.add(op.Id);
            }

            List<Quote> cotis = [SELECT Id, Status, OpportunityId FROM Quote WHERE OpportunityId IN: idOp];
            
            Map<Id,List<Quote>> quotesByOpp = new Map<Id,List<Quote>>();

            List<Quote> qts;
            for (Quote qt: cotis) {
                if (qt.OpportunityId == null) continue;

                qts = quotesByOpp.get(qt.OpportunityId);
                if (qts == null) {
                    qts = new List<Quote>();
                    quotesByOpp.put(qt.OpportunityId, qts);
                } 
                qts.add(qt);
            }
            if (quotesByOpp.isEmpty()) return;

            Map<Id, Opportunity> oppsInfo = new Map<Id, Opportunity>([
                SELECT Id, StageName
                FROM Opportunity WHERE Id in :quotesByOpp.keySet()
            ]);

            Opportunity opInfo;
            Set<Id> opError = new Set<Id>();
            //Boolean qtCerrada = false;
            for (Id opId: quotesByOpp.keySet()) {
                opInfo = oppsInfo.get(opId);

                for (Quote qt: quotesByOpp.get(opId)) {
                    if(qt.Status != CERRADA){
                        opError.add(opInfo.Id);
                    }
                }
            }

            //if(qtCerrada) return;
            if (opError.isEmpty()) return;
            for (Opportunity op: newOpps) {
                if(opError.contains(op.Id)){
                    op.addError('Debe cerrar al menos una cotización antes de cerrar la oportunidad');
                }
            }
        }
        
        /**
         * cambiarDeclinadaCuenta
         * Modifica el campo declinado en la cuenta si se cierra perdida la oportunidad
         * @author: ChangeMeIn@UserSettingsUnder.SFDoc
         * @param: newOpps List<Opportunity: before update opportunities
         * @return: void
         * @date: 17-06-2020
         */
        public static void cambiarDeclinadaCuenta(List<Opportunity> newOpps,List<Opportunity> oldOpps) { 
            Set<Id> idAcc = new Set<Id>();
            Boolean stageUpdate = false;
            for(Opportunity op: newOpps){
                for (Opportunity opp: oldOpps) {
                    if(op.Id == opp.Id && op.StageName != opp.StageName && op.StageName == CERRADA){
                        stageUpdate = true;
                    }
                }
            }

            if (!stageUpdate) return;

            for (Opportunity op: newOpps) {
                idAcc.add(op.AccountId);
            }

            if (idAcc.isEmpty()) return;

            List<Account> accounts = [SELECT Id, Empresa_declinada__c, Motivo_de_declinado__c 
                                        FROM Account WHERE Id IN: idAcc];
            
            Boolean isUpdate = false;
            for (Opportunity op: newOpps) {
                if (op.AccountId == null) continue;
                for (Account ac: accounts){
                    if (op.AccountId == ac.Id){
                        ac.Empresa_declinada__c = true;
                        ac.Motivo_de_declinado__c = op.Sub_motivo_de_perdida__c;
                        isUpdate = true;
                    }
                }
            }

            if(!isUpdate) return;
            update accounts;
        }

        /*
        * cambiarEtapaOportunidad
        * @descripción: Modifica el campo Etapa en la oportunidad, si la oprtunidad es Comercial Nuevo o Comercial renovación este 
        * campo debera tener el valor Ingresar Negocio.
        * @author: ChangeMeIn@UserSettingsUnder.SFDoc
        * @param: newOpps List<Opportunity: before insert opportunities
        * @return: void
        * @date: 25-02-2021
        */
        public static void cambiarEtapaOportunidad(List<Opportunity> newOpps)
        {    
            Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();
            Id comercialRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_RENOVACION).getRecordTypeId();

            for (Opportunity op: newOpps) {
                if(op.StageName == CERRADA) { return; }
                if(op.RecordTypeId == comercialNuevo )
                {
                    op.StageName = 'Ingresar Negocio';
                }
                else if (op.RecordTypeId == comercialRenovacion)
                {
                    op.StageName = 'Renovación';
                }
            }
        }

        /*
        * validacionCuentasRelacionadas
        * @descripción: Si la cuenta asociada a la oportunidad tiene cuentas relacionadas y la oportunidad esta en reserva no permitira crear la oportunidad.
        * @author: ChangeMeIn@UserSettingsUnder.SFDoc
        * @param: newOpps List<Opportunity: before insert opportunities
        * @return: void
        * @date: 01-03-2021
        */
        public static void validacionCuentasRelacionadas(List<Opportunity> newOpps)
        {    
            Set<Id> idCuentas = new Set<Id>();

            for (Opportunity op: newOpps) {
                idCuentas.add(op.AccountId);
            }

            List<Account> cuentas = new List<Account>();
            if(Schema.sObjectType.Account.isAccessible()){
                cuentas = [SELECT Id, ParentId FROM Account WHERE Id IN :idCuentas AND Holding__c <> true AND ParentId <> NULL];
            }
            
            if(cuentas.size() > 0){
                Set<Id> idCuentasPrincipales = new Set<Id>();

                for (Account acc: cuentas) {
                    idCuentasPrincipales.add(acc.ParentId);
                }

                List<Opportunity> oportunidades = new List<Opportunity>();
                if(Schema.sObjectType.Opportunity.isAccessible()){
                    oportunidades = [SELECT Id, Estado__c, AccountId FROM Opportunity WHERE AccountId IN :idCuentasPrincipales];
                }

                if(oportunidades.size() > 0){
                    Set<Id> idCuentasConReserva = new Set<Id>();
                    String estado;
                    for (Opportunity opo: oportunidades){
                        if(opo.Estado__c == 'Reserva' || opo.Estado__c == 'Sin reserva'){
                            idCuentasConReserva.add(opo.AccountId);
                            estado = opo.Estado__c;
                        }
                    }
            
                    if(!idCuentasConReserva.isEmpty()){
                        newOpps[0].addError('La cuenta principal posee una oportunidad en Estado de reserva: ' + estado);
                    } else {
                        return;
                    }
                } else {
                    return;
                }
            } else {
                return;
            }
        }

        
        /*
        * notificacionCambioEstadoCotizacion
        * Envia el email al propietario de la oportunidad y los contactos del corredor al cambiar a estado Cotización.
        * @author: ChangeMeIn@UserSettingsUnder.SFDoc
        * @param: newOpps List<Opportunity: before update opportunities
        * @return: void
        * @date: 03-03-2021
        */
        public static void notificacionCambioEstadoCotizacion(List<Opportunity> newOpps, List<Opportunity> oldOpps)
        { 
            Id rtComercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();
            Boolean oldStage = false;
            Boolean newStage = false;
            Set<Id> idOpps = new Set<Id>();
            Set<Id> idOwners = new Set<Id>();

            for (Opportunity op: oldOpps) {
                if(op.StageName == 'Solicitud Antecedentes' && op.RecordTypeId == rtComercialNuevo){
                    oldStage = true;
                }
            }
            
            for(Opportunity op: newOpps){
                if(op.StageName == 'Cotización' && op.RecordTypeId == rtComercialNuevo && oldStage){
                    newStage = true;
                    idOpps.add(op.Id);
                    idOwners.add(op.OwnerId);
                }
            }

            if (!oldStage && !newStage) { return; }
            if (idOpps.isEmpty() || idOwners.isEmpty()) { return; }


            List<User> dataOwners = new List<User>();
            if(Schema.sObjectType.User.isAccessible()){
                dataOwners = [SELECT Id, Email FROM User WHERE Id IN :(idOwners)];
            }

            if (dataOwners.isEmpty()) { return; }

            Map<String, List<String>> contactosCorredor = corredoresPorOportunidad(idOpps);

            if (contactosCorredor.isEmpty()) { return; }

            EmailTemplate emailTemplate = new EmailTemplate();
            if(Schema.sObjectType.EmailTemplate.isAccessible()){
                emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
                                FROM EmailTemplate
                                WHERE DeveloperName = 'Correo_Oportunidad_Cotizacion'];
            }

            /*List<OrgWideEmailAddress> orgEmail = new List<OrgWideEmailAddress>();
            if(Schema.sObjectType.OrgWideEmailAddress.isAccessible()){
                orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'sfvida@security.cl'];
            }*/
            
            List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
            messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
            List<String> listEmail = new List<String>();
         
            Contact cnt = new Contact();
            cnt.LastName = 'sfvida';
            cnt.Email = 'sfvida@security.cl';
            Insert cnt;
            
            if(String.isEmpty(cnt.Id)){ return; }

            for (Opportunity item: newOpps)
            {
                String idOpp = item.Id;

                if(contactosCorredor.keySet().contains(idOpp))
                {
                    for(String itemS: contactosCorredor.get(idOpp)){
                        if(String.isNotEmpty(itemS)){
                            listEmail.add(itemS);
                        }
                    }

                    for(User itemU: dataOwners){
                        if(String.isNotEmpty(itemU.Email)){
                            listEmail.add(itemU.Email);
                        }
                    }
                    
                    if (listEmail.isEmpty()) { return; }

                    singleMail.setToAddresses(listEmail);
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
                    singleMail = new messaging.SingleEmailMessage ();
                    listEmail = new List<String>();
                }
            }      
            
            if(mailsToSend.isEmpty()){
                return;
            } else {
                if(!Test.isRunningTest()){ Messaging.sendEmail(mailsToSend); }
                Delete cnt;
            }
        }

        /**
         * emailOportunidadCerradaGanada
         * Envia el email cuando se cierra ganada adjudicada la oportunidad
         * @author: ChangeMeIn@UserSettingsUnder.SFDoc
         * @param: newOpps List<Opportunity: before update opportunities
         * @return: void
         * @date: 17-06-2020
         */
        // public static void emailOportunidadCerradaGanada(List<Opportunity> newOpps,List<Opportunity> oldOpps) { 
        //     Boolean stageUpdate = false;
        //     for(Opportunity op: newOpps){
        //         for (Opportunity opp: oldOpps) {
        //             if(op.Id == opp.Id && op.StageName != opp.StageName && op.StageName == 'Cerrada' && op.Estado_Cierre__c == 'Adjudicada'){
        //                 stageUpdate = true;
        //             }
        //         }
        //     }

        //     if (!stageUpdate) return;

        //     Set<Id> idOpp = new Set<Id>();
        //     for (Opportunity op: newOpps) {
        //         idOpp.add(op.Id);
        //     }    
            
        //     if(idOpp.isEmpty()) return;
            
        //     List<Opportunity> dataAccount = [SELECT Id, Account.NP_Nombre_Cliente_Completo__c, Account.Email_Comercial__c, Account.Id
        //                                     FROM Opportunity WHERE Id IN: (idOpp)];

        //     if(dataAccount.isEmpty()) return;                                        

        //     Set<Id> idAccounts = new Set<Id>();

        //     for (Opportunity ac: dataAccount){
        //         idAccounts.add(ac.Account.Id);
        //     }

        //     List<Contact> dataContact = [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN:idAccounts];

        //     Map<Id, List<Corredores_Venta__c>> contactEmailByOp = contactosCorredoresPorOportunidad(idOpp);

        //     if(contactEmailByOp.isEmpty()) return;

        //     Map<Id, List<ContentVersion>> filesByOp = archivosPorOportunidad(idOpp);

        //     EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
        //                                     FROM EmailTemplate 
        //                                     WHERE DeveloperName = 'Correo_Oportunidad_Ganada_Comercial'];


        //     List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();

        //     messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
        //     List<String> listEmail = new List<String>();
        //     List<String> listFiles = new List<String>();
        //     String client;
        //     String emailReply;
        //     String contact;
        //     Set<Id> opError = new Set<Id>();
        //     for (Opportunity op: newOpps) {
        //         if(contactEmailByOp.keySet().contains(op.Id)){
        //             for(Corredores_Venta__c e: contactEmailByOp.get(op.Id)){
        //                 listEmail.add(e.Email_contacto__c);
        //             }     

        //             singleMail.setToAddresses(listEmail);

        //             for(Opportunity o: dataAccount){
        //                 if(op.Id == o.Id){
        //                     client = o.Account.Id;                        
        //                     continue;
        //                 }
        //             }
        //             for(Contact c: dataContact){
        //                 if(c.AccountId == client){
        //                     contact = c.Id;
        //                     if(!String.Isblank(c.Email)){
        //                         emailReply = c.Email;
        //                     }
        //                     continue;
        //                 }
        //             }
        //             if (String.isBlank(emailReply)) return;

        //             singleMail.setTargetObjectId(contact);
        //             singleMail.setWhatId(client);
        //             singleMail.setTemplateID(emailTemplate.Id);                
        //             singleMail.setUseSignature(false);
        //             singleMail.setSaveAsActivity(false);
        //             singleMail.setReplyTo(emailReply);

        //             if(!filesByOp.IsEmpty()){
        //                 for(ContentVersion doc: filesByOp.get(op.Id)){
        //                     listFiles.add(doc.Id);
        //                 }
        
        //                 singleMail.setEntityAttachments(listFiles);
        //             }

        //             mailsToSend.add(singleMail);

        //             singleMail = new messaging.SingleEmailMessage ();
        //             client = '';
        //             emailReply = '';
        //         }    
        //     }      
            
        //     if(mailsToSend.isEmpty()){
        //         return;
        //     } else {
        //         Messaging.sendEmail(mailsToSend);
        //     }

        // }
        
        /*private static Map<Id, List<Corredores_Venta__c>> contactosCorredoresPorOportunidad(Set<Id> opportinities)
        {
            Map<Id, List<Corredores_Venta__c>> contactEmailByOp = new Map<Id, List<Corredores_Venta__c>>();

            List<Corredores_Venta__c> emailContact = new List<Corredores_Venta__c>();
            if(Schema.sObjectType.Corredores_Venta__c.isAccessible()){
                emailContact = [SELECT Id_Oportunidad__c, Email_contacto__c
                                FROM Corredores_Venta__c
                                WHERE Id_Oportunidad__c IN: opportinities];
            }

            if(emailContact.isEmpty()) { return new Map<Id, List<Corredores_Venta__c>>(); }
                
            List<Corredores_Venta__c> emailInfo;

            for(Corredores_Venta__c em: emailContact)
            {
                if(em.Id_Oportunidad__c == null) { continue; }

                emailInfo = contactEmailByOp.get(em.Id_Oportunidad__c);

                if(emailInfo == null){
                    emailInfo = new List<Corredores_Venta__c>();
                    contactEmailByOp.put(em.Id_Oportunidad__c, emailInfo);
                } 

                emailInfo.add(em);
            }

            if(contactEmailByOp.isEmpty()) {
                return new Map<Id, List<Corredores_Venta__c>>();
            } else {
                return contactEmailByOp;
            }
        }*/

        // public static Map<Id, List<ContentVersion>> archivosPorOportunidad(Set<Id> opportinities){
        //     Map<Id, List<ContentVersion>> filesByOp = new Map<Id, List<ContentVersion>>();

        //     List<ContentDocumentLink> files = [SELECT ContentDocumentId, LinkedEntityId  
        //                                                 FROM ContentDocumentLink WHERE LinkedEntityId IN ( SELECT Id FROM Opportunity WHERE ID IN: opportinities) 
        //                                                 AND LinkedEntity.Type='Opportunity'];

        //     if(files.isEmpty()) return new Map<Id, List<ContentVersion>>();
            
        //     Set<Id> documentId = new Set<Id>();

        //     for(ContentDocumentLink fl: files){
        //         documentId.add(fl.ContentDocumentId);
        //     }

        //     List<ContentVersion> versionFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: documentId];

        //     List<ContentVersion> fileInfo = new List<ContentVersion>();
        //     for(ContentDocumentLink fl: files){
        //         if(fl.LinkedEntityId == null) continue;

        //         for(ContentVersion vr: versionFile){
        //             if(vr.ContentDocumentId == fl.ContentDocumentId){
        //                 fileInfo.add(vr);
        //             }
        //         }

        //         if(!fileInfo.isEmpty()){
        //             filesByOp.put(fl.LinkedEntityId, fileInfo);
        //         } 
        //         fileInfo = new List<ContentVersion>();
        //     }

        //     if(filesByOp.isEmpty()){
        //         return new Map<Id, List<ContentVersion>>();
        //     } else {
        //         return filesByOp;
        //     }
        // } 
        
        /**
         * alertaSuscriptoresOppCerrada
         * Envía un correo a los suscriptores de las cotizacion relacionada a la oportunidad con estado 
         * "Cerrada" cuando la oportunidad pasa a etapa "Cerrada"
         */
        public static void alertaSuscriptoresOppCerrada(List<Opportunity> newOpps, List<Opportunity> oldOpps){
            Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();
            Id comercialRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_RENOVACION).getRecordTypeId();
           
            Set<String> oppList = new Set<String>();

            for(Opportunity itemNew : newOpps){
                for(Opportunity itemOld : oldOpps){
                    if(itemNew.Id == itemOld.Id && itemNew.StageName == 'Cerrada' && itemNew.recordTypeId == comercialNuevo  || itemNew.recordTypeId == comercialRenovacion
                       &&  itemNew.StageName != itemOld.StageName) oppList.add(itemNew.Id);
                }
            }

            Map<Id,Opportunity> oppListWQuote = new map<Id, Opportunity>([select id, Owner.FirstName, Owner.LastName,
                                                                         (select id, Email_Suscriptor__c from Quotes where Status = 'Tarificacion') 
                                                                        from Opportunity where Id IN: oppList]); 

            /*EmailTemplate emailTemplate = new EmailTemplate();
            if(Schema.sObjectType.EmailTemplate.isAccessible()){
            emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
                             FROM EmailTemplate WHERE DeveloperName = 'Notificacion_Suscriptor_Opp_Cerrada'];
            }*/
            
            //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address='sfvida@security.cl'];
            
            List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
            messaging.SingleEmailMessage singleMail;
            Set<String> listEmailNoRepeat;   
            List<String> listEmail;
            String body = '';
            String subject;

            for(Opportunity Opitem : newOpps){
                
                if(!oppList.contains(Opitem.Id)) continue;

                    listEmailNoRepeat = new Set<String>();
                    for(Quote qitem : oppListWQuote.get(Opitem.Id).quotes){
                        if(qitem.Email_Suscriptor__c != null) listEmailNoRepeat.add(qitem.Email_Suscriptor__c);
                    }
                    if(listEmailNoRepeat.isEmpty()) continue;    
                    
                    listEmail = new List<String>();
                    listEmail.addAll(listEmailNoRepeat);
                    
                    singleMail = new messaging.SingleEmailMessage();
                    //singleMail.setOrgWideEmailAddressId(owea.get(0).Id);
                    singleMail.setUseSignature(false);
                    singleMail.setSaveAsActivity(false);
                    singleMail.setReplyTo('example@example.com');
                    singleMail.setToAddresses(listEmail);

                    subject = 'Oportunidad ' + Opitem.Name + ' cerrada';
                    singleMail.setSubject(subject);

                    body = 'Estimado Suscriptor (a) ,te informamos que la oportunidad ' + Opitem.Name + ' ha sido ';
                    body += 'cerrada por ' + oppListWQuote.get(Opitem.Id).Owner.FirstName + ' ' + oppListWQuote.get(Opitem.Id).Owner.LastName  
                    + ', favor omitir tarificación.';
                    singleMail.setPlainTextBody(body);

                    mailsToSend.add(singleMail);

            } 
            if(mailsToSend.isEmpty()){
                return;
            } else {
                Messaging.sendEmail(mailsToSend);
            }
        }

        /**
         * alertaDeclinacionOpp
         * Se valida que la oportunidad tenga o no cotizacion en estado "Tarificación" 
         * al pasar a etapa "Cerrada" con estado de cierre "Declinada", mostrando una alerta si las tiene.
         */
        public static void alertaDeclinacionOpp(List<Opportunity> newOpps){
        Set<String> oppList = new Set<String>();

            for(Opportunity item : newOpps){
                if(item.Estado_cierre__c == 'Declinada') {oppList.add(item.Id);}
            }

            Map<Id,Opportunity> oppListWQuote = new map<Id, Opportunity>([select id, (select id, Email_Suscriptor__c from Quotes where Status = 'Tarificacion') 
                                                                        from Opportunity where Id IN: oppList]); 

            if(oppListWQuote.isEmpty()) return;      
                                               
            for(Opportunity Opitem : newOpps){
                
               if(!oppList.contains(Opitem.Id)) continue;
                    
               if(oppListWQuote.get(Opitem.id).quotes.size() > 0){
                  Opitem.addError('No puede declinar ya que existen presupuestos relacionados en estado de "Tarificación".');
              } 
            }  
        }  


        /**
         * notificacionesCierreProceso
         * Se enviara un email cuando una oprtunidad sea cerrada.
         * @date: 31-03-2021
         */
        public static void notificacionesCierreProceso(List<Opportunity> newOpps, List<Opportunity> oldOpps)
        {
            Set<String> idOwners = new Set<String>();
            Set<String> idAcc = new Set<String>();
            Set<String> idsOpp = new Set<String>();
            String nameTemplate = EMPTY;
            String idOpp = EMPTY;
            Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();
            Id comercialRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_RENOVACION).getRecordTypeId();
            Boolean esComercial = false;

            for(Opportunity item: newOpps)
            {
                for(Opportunity itemOld : oldOpps){
                    if(item.Id == itemOld.Id && item.StageName == CERRADA
                       &&  item.StageName != itemOld.StageName)
                    {
    
                    String rtId = item.RecordTypeId;
                    String estadoCierre = item.Estado_cierre__c;
    
                    if(rtId == comercialNuevo){
                        if(estadoCierre == 'Adjudicada' || estadoCierre == 'No adjudicada'){
                            switch on estadoCierre {
                                when 'Adjudicada' {
                                    nameTemplate = 'Notificaci_n_Cierre_Proceso_Comercial_Nuevo_Adjudicada';
                                }	
                                when 'No adjudicada' {
                                    nameTemplate = 'Notificacion_Cierre_Proceso_Comercial_Nuevo';
                                }
                            }
                            idOpp = item.Id;
                            idOwners.add(item.OwnerId);
                            idAcc.add(item.AccountId);
                            idsOpp.add(item.Id);
                            esComercial = true;
                        }
                    }
    
                    if(rtId == comercialRenovacion){
                        if(estadoCierre == 'Renovada' || estadoCierre == 'Caducada' || estadoCierre == 'Prorrogada'){
                            switch on estadoCierre {
                                when 'Renovada' {
                                    nameTemplate = 'Notificacion_Cierre_Proceso_Renovacion_Renovada';
                                }	
                                when 'Caducada' {
                                    nameTemplate = 'Notificacion_Cierre_Proceso_Renovacion_Caducada';
                                }
                                when 'Prorrogada' {
                                    nameTemplate = 'Notificacion_Cierre_Proceso_Renovacion_Prorrogada';
                                }
                            }
                            idOpp = item.Id;
                            idOwners.add(item.OwnerId);
                            idAcc.add(item.AccountId);
                            idsOpp.add(item.Id);
                            esComercial = true;
                        }
                    }
                  }
                }
            }
    
            if(idOwners.isEmpty()) { return; }
    
            // Propietario de la oportunidad
            List<User> dataOwners = new List<User>();
            if(Schema.sObjectType.User.isAccessible()){
                dataOwners = [SELECT Id, Email FROM User WHERE Id IN :(idOwners)];
            }
            
            if(dataOwners.isEmpty()) { return; }
            
            // Contactos Asociados a la Oportunidad
            List<Contact> dataContact = new List<Contact>();
            if(Schema.sObjectType.Contact.isAccessible()){
                dataContact = [SELECT Id, Email FROM Contact WHERE Email != null AND AccountId IN :(idAcc)];
            }
    
            EmailTemplate emailTemplate = new EmailTemplate();
            if(Schema.sObjectType.EmailTemplate.isAccessible()){
                emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body 
                                FROM EmailTemplate WHERE DeveloperName = :nameTemplate LIMIT 1];
            }
    
            /*List<OrgWideEmailAddress> orgEmail = new List<OrgWideEmailAddress>();
            if(Schema.sObjectType.OrgWideEmailAddress.isAccessible()){
                orgEmail = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'sfvida@security.cl'];
            }*/

            List<String> listJefaturas = new List<String>();
            List<User> dataUsers = new List<User>();
    
            if(Schema.sObjectType.User.isAccessible()){
                dataUsers = [SELECT Name, Profile.Name, Email FROM User WHERE Profile.Name IN ('Jefatura Comercial Colectivo', 'Jefatura Técnica Colectivo')];
            }
    
            if(dataUsers.isEmpty()){ return; }
    
            for(User item: dataUsers){
                if(String.isNotEmpty(item.Email)){
                    listJefaturas.add(item.Email);
                }
            }

            Set<String> setlistEmail = new Set<String>();
    
            for(User u: dataOwners){
                if(String.isNotEmpty(u.Email)){
                    setlistEmail.add(u.Email);
                }
            }
    
            if(!dataContact.isEmpty()) {
                for(Contact c: dataContact){
                    if(String.isNotEmpty(c.Email)){
                        setlistEmail.add(c.Email);
                    }
                }
            }
    
            for(String item: listJefaturas){
                setlistEmail.add(item);
            }

            if(setlistEmail.isEmpty()){ return; }
    
            List<String> stringlistEmail = new List<String>();
            stringlistEmail.addAll(setlistEmail);

            if(stringlistEmail.isEmpty()){ return; }
            
            /*List<String> idFilesList = new List<String>();
            ContentVersion doc = archivoOportunidad(idOpp);
            if(String.isNotEmpty(doc.Id)){
                idFilesList.add(doc.Id);
            }*/
            
            if(idsOpp.isEmpty()) { return; }
            // Contacto Corredores Asociados a la Oportunidad
            List<Corredores_Venta__c> dataCorredores = new List<Corredores_Venta__c>();
            if(Schema.sObjectType.Corredores_Venta__c.isAccessible()){
                dataCorredores = [SELECT Email_contacto__c FROM Corredores_Venta__c WHERE Id_Oportunidad__c IN :idsOpp]; 
            }

            List<String> emailCorredores = new List<String>();
            for (Corredores_Venta__c item : dataCorredores) {
                emailCorredores.add(item.Email_contacto__c);
            }
            
            Contact cnt = new Contact();
            cnt.LastName = 'sfvida';
            cnt.Email = 'sfvida@security.cl';
            Insert cnt;
            
            if(String.isEmpty(cnt.Id)){ return; }
    
            messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
            singleMail.setWhatId(idOpp);
            singleMail.setTemplateID(emailTemplate.Id);
            if (esComercial) {
                // Se envia al corredor
                singleMail.setToAddresses(emailCorredores);
                // con copia a usuario vida
                singleMail.setCcAddresses(stringlistEmail);
            } else {
                singleMail.setToAddresses(stringlistEmail);
            }
            singleMail.setTargetObjectId(cnt.Id);
            singleMail.setTreatTargetObjectAsRecipient(false);

            /*if(!orgEmail.isEmpty()){
                singleMail.setOrgWideEmailAddressId(orgEmail.get(0).Id);
            }*/

            singleMail.setUseSignature(false);
            singleMail.setSaveAsActivity(false);

            /*if(!idFilesList.isEmpty()){
                singleMail.setEntityAttachments(idFilesList);
            }*/
    
            List<Messaging.SingleEmailMessage> listSingleMail = new List<Messaging.SingleEmailMessage>();
            listSingleMail.add(singleMail);
    
            if(listSingleMail.isEmpty()){
                return;
            } else {
                Messaging.sendEmail(listSingleMail);
                Delete cnt;
            }
        }
    
        /**
         * archivoOportunidad
         * Retornara el ultimo archivo agregado a la oportunidad
         * @date: 31-03-2021
         */
        /*private static ContentVersion archivoOportunidad(String idOpp)
        {
            ContentVersion responseFile = new ContentVersion();
    
            List<ContentDocumentLink> files = new List<ContentDocumentLink>();
            if(Schema.sObjectType.ContentDocumentLink.isAccessible()){
                files = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink
                        WHERE LinkedEntityId = :idOpp AND LinkedEntity.Type = 'Opportunity'];
            }
    
            if(files.isEmpty()) { return responseFile; }
                
            Set<Id> idDoc = new Set<Id>();
            for(ContentDocumentLink f: files){
                idDoc.add(f.ContentDocumentId);
            }
    
            if(idDoc.isEmpty()) { return responseFile; }
    
            if(Schema.sObjectType.ContentVersion.isAccessible()){
                responseFile = [SELECT Id, ContentDocumentId, CreatedDate FROM ContentVersion
                                WHERE ContentDocumentId IN :idDoc ORDER BY CreatedDate DESC LIMIT 1];
            }
    
            return (String.isNotEmpty(responseFile.Id) ? responseFile : new ContentVersion());
        } */


                /**
         * validacionReserva
         * Valida que no exista una oportunidad en reserva con el mismo rut
         * @author: ChangeMeIn@UserSettingsUnder.SFDoc
         * @param: newOpps List<Opportunity: before insert opportunities
         * @return: void
         * @date: 08-06-2020
         */
        public static void seteoInicialTipoRenovacion(List<Opportunity> newOpps)
        {        
            if(newOpps.size() <1)
            {
                return;
            }

            Datetime dateNow = Datetime.now();
            Map<Id,Poliza__c> mapOpportunityPoliza = new Map<Id,Poliza__c>();

            Map<Id,String> oportunidadNumeroHolding = new Map<Id,String>();

            Set<Id> idsAccounts                     = new Set<Id>(); 
            Set<String> idsPolizas                  = new Set<String>(); 
            Set<String> idsPolizasCuentas           = new Set<String>();
            Set<String> numeroDePoliza              = new Set<String>();
            Set<String> numeroDePolizaConEspacios   = new Set<String>(); 

            for (Opportunity op: newOpps) 
            {
                idsAccounts.add(op.AccountId);
                String  aux = op.name.split(' ')[0];
                numeroDePoliza.add(aux);
                aux =  aux+' %';    
                numeroDePolizaConEspacios.add(aux);  // numeroDePoliza es una lista con los numeros de la poliza
            }
            system.debug('acaa : ' + numeroDePolizaConEspacios);
            system.debug('acaa : ' + numeroDePoliza);           
			
            Id id_colectivos =Schema.SObjectType.Poliza__c.getRecordTypeInfosByDeveloperName().get('Colectivos').getRecordTypeId();

            List<Poliza__c> polizasAgrupacion = [SELECT Name, Cuenta__c, Agrupacion_Comercial__c FROM Poliza__c WHERE RecordTypeId =:id_colectivos AND Estatus__c = 'ACTIVA' AND Agrupacion_Comercial__c LIKE:numeroDePolizaConEspacios limit 100];
            system.debug('listas : ' + polizasAgrupacion.size());                
            List<Poliza__c> polizas =[SELECT  Name,
                                                Cuenta__c,
                                                Fecha_Inicio_de_Vigencia_Original__c,
                                                Fecha_Termino_de_Poliza__c,
                                                Fecha_Inicio_de_Vigencia__c,
                                                Corredor__c
                                                FROM Poliza__c WHERE Name IN:numeroDePoliza];
            
            
            for (Opportunity op: newOpps) 
            {
                String  numero_poliza_op = op.name.split(' ')[0];

                for(Poliza__c poliza : polizas) 
                {
                    String polizasCuentaPoliza = '';
                
                    if (numero_poliza_op == poliza.Name)
                    {
                        for(Poliza__c p : polizasAgrupacion) 
                        {
                            String aux = p.Agrupacion_Comercial__c;
                            
                            if(!String.isBlank(aux))
                            {
                                aux = aux.split(' ')[0];
                            }

                            if( (poliza.Name == aux) && (p.name != poliza.Name))
                            {
                                if(String.isBlank(polizasCuentaPoliza))
                                {
                                    polizasCuentaPoliza = p.name;

                                }
                                else
                                {
                                    polizasCuentaPoliza = polizasCuentaPoliza + ' - ' + p.name;
                                }
                            }

                        }

                        op.Poliza_del_Holding__c = polizasCuentaPoliza;

                        if(poliza.Fecha_Inicio_de_Vigencia_Original__c != null)
                        {
                            Datetime fechaInicioVigencia  = poliza.Fecha_Inicio_de_Vigencia_Original__c;
                            Integer anioInicioVigencia    = fechaInicioVigencia.year();
                            Integer anioActual = dateNow.year();
                            op.AntiguedadYears__c  = anioActual - anioInicioVigencia;
                            
                            
                        }
                        
                        op.Fecha_Inicio_de_Poliza__c = poliza.Fecha_Inicio_de_Vigencia__c;
                        op.Fecha_de_termino_de_poliza__c = poliza.Fecha_Termino_de_Poliza__c;
                        op.Tipo_de_cuenta__c = 'Con Experiencia';
                        op.AseguradoraVigente__c = 'Vida Security';
                        
                        if(poliza.Corredor__c != null)
                        {
                            op.Corredor_actual__c =  poliza.Corredor__c  ; 
                        }
                            
                    } 
                }             
            }
        }

    /**
    * validacionProcesoReserva
    * @return: void
    * @date: 09-04-2021
    */
    public static void validacionProcesoReserva(List<Opportunity> newOpps)
    {
        Set<String> weekendDays = new Set<String>{'SAT', 'SUN'};
        Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();

        for(Opportunity item: newOpps){
            if(item.RecordTypeId == comercialNuevo && item.StageName == 'Solicitud Antecedentes' && item.Estado__c == 'Reserva'){
                if(item.FechaInicioVigencia__c != null){
                    Datetime inputDate = item.FechaInicioVigencia__c;
                    String dayOfWeek = inputDate.addDays(1).format('E');
                    if(weekendDays.contains(dayOfWeek.toUpperCase())){
                        item.addError('Debe seleccionar un día hábil para el campo Fecha de inicio Reserva');
                    }
                }
            }
        }
    }

    private static Map<String, List<String>> corredoresPorOportunidad(Set<Id> idOpp)
    {
        Map<String, List<String>> response = new Map<String, List<String>>();
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

    public static void tieneOportunidadEnProceso(List<Opportunity> newOpps)
    {
        List<Id> listAccId = new List<Id>();
        for(Opportunity item: newOpps){
            // Esta validacion no aplica si es creada automaricamente
            if(item.Opp_Automatica__c) {
                return;
            } else {
                listAccId.add(item.AccountId);
            }
        }
        
        List<Opportunity> listOpp = [SELECT AccountId, Id, Estado__c, StageName
                                    FROM Opportunity
                                    WHERE AccountId IN :listAccId AND StageName != 'Cerrada' AND RecordType.DeveloperName IN ('Comercial_Nuevo', 'Comercial_Renovacion')];
        if (!listOpp.isEmpty()) {
            for(Opportunity item: newOpps){
                item.addError('Esta Cuenta ya contiene una Oportunidad. Debe cerrar la que se encuentra disponible y vuelta a intentarlo.');
            }
        }
    }

    public static void tieneContactoCorredores(List<Opportunity> newOpps)
    {
        Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_NUEVO).getRecordTypeId();
        Id comercialRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(COMERCIAL_RENOVACION).getRecordTypeId();
        List<Id> idsOpp = new List<Id>();
        for(Opportunity item: newOpps){
            if(item.StageName == CERRADA && item.RecordTypeId == comercialNuevo){
                idsOpp.add(item.Id);
            }
            if(item.StageName == CERRADA && item.RecordTypeId == comercialRenovacion){
                idsOpp.add(item.Id);
            }
        }
        if (idsOpp.isEmpty()) { return; }

        List<Corredores_Venta__c> dataCorredores = new List<Corredores_Venta__c>();
        if(Schema.sObjectType.Corredores_Venta__c.isAccessible()){
            dataCorredores = [SELECT Email_contacto__c FROM Corredores_Venta__c WHERE Id_Oportunidad__c IN :idsOpp]; 
        }
        
        if (dataCorredores.isEmpty()) {
            for(Opportunity item: newOpps){
                item.addError('Al cerrar la Oportunidad, debe tener al menos un Contacto de Corredor.');
            }
        }
    }
}