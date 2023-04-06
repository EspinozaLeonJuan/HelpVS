/**
 * Quote Trigger Handler para Comercial
 * @author: ChangeMeIn@UserSettingsUnder.SFDoc
 * @date: 08-05-2020
 */
public without sharing class QuoteTriggerHandler {

    /**
     * inicializarCotizacionomercial
     * - Le asigna un Id con el formato [AÑO]-OP[Numero correlativo]-COT[Cantidad de cotis de la op]
     * - Asigna las fechas para los SLA
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: before insert quotes
     * @return: void
     * @date: 08-05-2020
     */
    public static void inicializarCotizacionComercial(List<Quote> newQts) {
       

        Date diasPrepAntecedentes = Date.today();
        Date diasTarificacion = HolidayUtils.addBussinessDays(diasPrepAntecedentes, ComercialConstants.diasTarificacion);
        
        Datetime fechaTarificacion;
        //Consulta Horario Laboral
        if(System.now().hour() >= 15 && System.now().minute() > 0){  //Si se crea fuera de horario laboral  -- qt.createdDate
            Date nextDiaHabil = HolidayUtils.addBussinessDays(diasTarificacion, 1);
            fechaTarificacion = Datetime.newInstance(nextDiaHabil.year(), nextDiaHabil.month(), nextDiaHabil.day(), 15, 0, 0);
        }else {
            fechaTarificacion = DateTime.newInstance(diasTarificacion.year(), diasTarificacion.month(), diasTarificacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());  
        }

        System.debug('fechaTarificacion4' + fechaTarificacion);
        Date diasPrepCotizacion = HolidayUtils.addBussinessDays(fechaTarificacion.date(), ComercialConstants.diasPrepCotizacion);
        Datetime fechaPrepAntecedentes = DateTime.newInstance(diasPrepAntecedentes.year(), diasPrepAntecedentes.month(), diasPrepAntecedentes.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());
        Datetime fechaPrepCotizacion = DateTime.newInstance(diasPrepCotizacion.year(), diasPrepCotizacion.month(), diasPrepCotizacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());   

        Map<Id, Id> suscriptoresdeRenovacion = getSuscriptoresdeRenovacion(newQts);
        // Ordenamos las quotes por cada cotizacion
        Map<Id, List<Quote>> quotesByOpp = new Map<Id, List<Quote>>();
        List<Quote> qts;
        for (Quote qt: newQts) {
            if (qt.OpportunityId == null) continue;

            // Quotes para Id
            qts = quotesByOpp.get(qt.OpportunityId);
            if (qts == null) {
                qts = new List<Quote>();
                quotesByOpp.put(qt.OpportunityId, qts);
            }
            qts.add(qt);

            System.debug('fechaTarificacion' + fechaTarificacion);
            // Asignamos las fechas para los SLAs
            qt.FechaPrepAntecedentes__c = fechaPrepAntecedentes;
            //qt.FechaTarificacion__c = fechaTarificacion;
            //qt.FechaPrepCotizacion__c = fechaPrepCotizacion;
            
            //cambio dicho 
            qt.FechaCumpAntecedentes__c = Datetime.now();

            //Agrega suscriptor del primer presupuesto vinculada a la oportunidad
            if (suscriptoresdeRenovacion.containsKey(qt.OpportunityId)) {
                qt.Suscriptor__c = suscriptoresdeRenovacion.get(qt.OpportunityId);
                System.debug(qt.Suscriptor__c);
            }

        }
        if (quotesByOpp.isEmpty()) return;

        // Le asignamos un +1 a su Id
        Map<Id, Opportunity> oppsInfo = new Map<Id, Opportunity>([
            SELECT Id, IdOportunidadComercial__c, UltimoIdCotizacion__c, Codigo_Comercial__c
            FROM Opportunity WHERE Id in :quotesByOpp.keySet()
        ]);
        Opportunity opInfo;
        Integer existentQuotes;
        for (Id opId: quotesByOpp.keySet()) {
            opInfo = oppsInfo.get(opId);
            existentQuotes = opInfo.UltimoIdCotizacion__c == null ? 0 : opInfo.UltimoIdCotizacion__c.intValue();
            for (Quote qt: quotesByOpp.get(opId)) {
                if(!qt.Es_Clone__c){
                    existentQuotes += 1;
                    qt.IdCotizacionComercial__c = opInfo.Codigo_Comercial__c + '-COT' + existentQuotes;
                } else {
                    qt.IdCotizacionComercial__c = opInfo.Codigo_Comercial__c + '-COT' + existentQuotes + '- 1';
                }
                
            }
            opInfo.UltimoIdCotizacion__c = existentQuotes;
        }


        // Actualizar contador de la oportunidad
        update oppsInfo.values();
    }


    /**
     * modificarValoresOportunidad
     * Modifica los montos y contadores de la oportunidad
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: before update quotes
     * @return: void
     * @date: 17-06-2020
     */
    public static void modificarValoresOportunidad(List<Quote> newQts, List<Quote> oldQts) {
        Boolean stageUpdate = false;
        for(Quote qt: newQts){
            for (Quote qtt: oldQts) {
                if(qt.Id == qtt.Id && qt.Status != qtt.Status && qt.Status == 'Cerrada'){
                    stageUpdate = true;
                }
            }
        }

        if (!stageUpdate) return;

        Set<Id> idOp = new Set<Id>();

        for (Quote qt: newQts) {
            idOp.add(qt.OpportunityId);
        }

        if (idOp.isEmpty()) return;

        List<Opportunity> opportunities = [SELECT Id, Estado__c, StageName, Ranking_cotizacion_cerrada__c, Cotizacion_de_cierre__c,
                                Cierre_UFA_totales__c, Total_participantes_en_el_proceso__c
                                FROM Opportunity WHERE Id IN: idOp];

        Boolean isUpdate = false;
        for (Quote qt: newQts) {
            if (qt.OpportunityId == null) continue;
            for(Opportunity op: opportunities){
                if(qt.OpportunityId == op.Id){
                    op.Ranking_cotizacion_cerrada__c = qt.Ranking_propuesta__c;
                    op.Cotizacion_de_cierre__c = qt.IdCotizacionComercial__c;
                    op.Cierre_UFA_totales__c = qt.Precio_total_productos__c;
                    op.Total_participantes_en_el_proceso__c = qt.Total_N_titulares__c;
                    op.Id_cotizacion_cerrada__c = qt.Id;
                    isUpdate = true;
                }
            }
        }

        if(!isUpdate) return;
        update opportunities;
    }

    /**
     * validacionPropuestaComercial
     * Valida la existencia de la propuesta comercial, si existe y esta en el estado 'Preparar Cotización'
     * mueve el estado a 'Negociación'
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts Map<Id, Quote>: before update quotes (new state)
     * @param: oldQts Map<Id, Quote>: before update quotes (old state)
     * @return: void
     * @date: 18-06-2020
     */
    /*public static void validacionPropuestaComercial(Map<Id, Quote> newQts, Map<Id, Quote> oldQts) {

        String mensajeError = 'Debe cargar la propuesta comercial para pasar a Negociación';

        // Filtrar quotes para la validacion y obtener Id de propuestas comerciales
        List<Quote> qts = new List<Quote>();
        Set<Id> idPrps = new Set<Id>();
        for (Quote q: newQts.values()) {
            if (q.Status == ComercialConstants.qtStatusNegociacion && q.IdPropuestaComercial__c == null) {
                q.addError(mensajeError);
            }
            else if ((q.Status == ComercialConstants.qtStatusNegociacion || q.Status == ComercialConstants.qtStatusPrepCotizacion) &&
            q.idPropuestaComercial__c != null) {
                qts.add(q);
                idPrps.add(q.IdPropuestaComercial__c);
            }
        }
        if (qts.isEmpty()) return;

        // Obtenemos los documentos para verificar que esten cargados
        Map<Id, ContentDocument> docs = new Map<Id, ContentDocument>([
            SELECT Id FROM ContentDocument WHERE Id in :idPrps
        ]);

        // Verificamos los documentos y movemos el estado si corresponde
        ContentDocument doc;
        Quote oldQ;
        List<String> quoteStatuses = ComercialConstants.quoteStatusOrdered;
        Integer idxStatusOld;
        Integer idxStatusNew;
        Integer idxStatusNegociacion = quoteStatuses.indexOf(ComercialConstants.qtStatusNegociacion);
        for (Quote q: qts) {
            doc = docs.get(q.IdPropuestaComercial__c);
            oldQ = oldQts.get(q.Id);
            idxStatusNew = quoteStatuses.indexOf(q.Status);
            idxStatusOld = quoteStatuses.indexOf(oldQ.Status);

            if (doc == null) {
                q.IdPropuestaComercial__c = null; // El doc no existe, quitamos el id
                // Si esta tratando de pasar de negociacion, damos error
                if (idxStatusNew >= idxStatusNegociacion && idxStatusNew != idxStatusOld) {
                    q.addError(mensajeError);
                }
            }
            else if (doc != null && q.Status == ComercialConstants.qtStatusPrepCotizacion) {
                q.Status = ComercialConstants.qtStatusNegociacion;
            }
        }
    }*/


    /**
     * registraCumplimientoSLA
     * Registra el cumplimiento de los SLA al cambiar de etapa, este metodo DEBE mantenerse al final
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts Map<Id, Quote>: before update quotes (new state)
     * @param: oldQts Map<Id, Quote>: before update quotes (old state)
     * @return: void
     * @date: 18-06-2020
     */
    public static void registraCumplimientoSLA(Map<Id, Quote> newQts, Map<Id, Quote> oldQts) {
        /**
         * TODO:
         * 1. Filtrar cotis con cambio de etapa X
         * 2. Verificar que etapa hoy esta entre la ventana de SLA X
         * 3. Verificar etapas cumplidas
         * 4. Marcar etapas cumplidas y no cumplidas
         * 5. Actualizar cotis
         */


        Date diasTarificacion;
        Date diasPrepCotizacion;

        List<String> slaStatuses = ComercialConstants.slaStatuses;
        List<String> quoteStatuses = ComercialConstants.quoteStatusOrdered;
        Datetime now = Datetime.now();
        Quote oldQ;
        Integer idxOldStatus;
        Integer idxNewStatus;
        for (Quote q: newQts.values()) {
            oldQ = oldQts.get(q.Id);
            idxOldStatus = quoteStatuses.indexOf(oldQ.Status);
            idxNewStatus = quoteStatuses.indexOf(q.Status);

            // Filtrar cotis sin cambio de etapa, las que no corresponden y las vueltas atras
            if (q.status == oldQ.Status || !slaStatuses.contains(oldQ.Status) ) continue;

            if (oldQ.Status == ComercialConstants.qtStatusPrepAntecedentes && q.Status == ComercialConstants.qtStatusTarificacion
            ) {
                
                //Se sacan los días hábiles
                /*diasTarificacion = HolidayUtils.addBussinessDays(Date.today(), ComercialConstants.diasTarificacion);
                diasPrepCotizacion = HolidayUtils.addBussinessDays(diasTarificacion, ComercialConstants.diasPrepCotizacion); 
                //Se le asignan los días hábiles
                q.FechaTarificacion__c = DateTime.newInstance(diasTarificacion.year(), diasTarificacion.month(), diasTarificacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());  
                q.FechaPrepCotizacion__c = DateTime.newInstance(diasPrepCotizacion.year(), diasPrepCotizacion.month(), diasPrepCotizacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());*/
            }
            
            else if (oldQ.Status == ComercialConstants.qtStatusTarificacion && q.Status == ComercialConstants.qtStatusPrepCotizacion &&
            q.FechaCumpTarificacion__c == null) {
                q.FechaCumpTarificacion__c = now;
                //Se sacan los días hábiles
                diasPrepCotizacion = HolidayUtils.addBussinessDays(q.FechaCumpTarificacion__c.date(), ComercialConstants.diasPrepCotizacion);               
                //Se le asignan los días hábiles
                q.FechaPrepCotizacion__c = DateTime.newInstance(diasPrepCotizacion.year(), diasPrepCotizacion.month(), diasPrepCotizacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());
            }
            else if (oldQ.Status == ComercialConstants.qtStatusPrepCotizacion && q.Status == ComercialConstants.qtStatusNegociacion &&
            q.FechaCumpCotizacion__c == null) {
                q.FechaCumpCotizacion__c = now;
            } 
            //si se retrocede a etapa de preparación de antecedentes, realizar un recalculo de las fechas SLA
            else if (q.Status == ComercialConstants.qtStatusPrepAntecedentes && oldQ.Status == ComercialConstants.qtStatusTarificacion) {
                q.FechaCumpTarificacion__c = null;
                q.FechaCumpCotizacion__c = null;
                q.FechaCumpAntecedentes__c = Datetime.now();

                Date diasPrepAntecedentes = Date.today();
                diasTarificacion = HolidayUtils.addBussinessDays(diasPrepAntecedentes, ComercialConstants.diasTarificacion);
                
                Datetime fechaTarificacion;
                //Consulta Horario Laboral
                if(System.now().hour() >= 15 && System.now().minute() > 0){  //Si se crea fuera de horario laboral  -- qt.createdDate
                    Date nextDiaHabil = HolidayUtils.addBussinessDays(diasTarificacion, 1);
                    fechaTarificacion = Datetime.newInstance(nextDiaHabil.year(), nextDiaHabil.month(), nextDiaHabil.day(), 15, 0, 0);
                }else {
                    q.FechaTarificacion__c = DateTime.newInstance(diasTarificacion.year(), diasTarificacion.month(), diasTarificacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());  
                }
        
                diasPrepCotizacion = HolidayUtils.addBussinessDays(q.FechaTarificacion__c .date(), ComercialConstants.diasPrepCotizacion);
                q.FechaPrepAntecedentes__c = DateTime.newInstance(diasPrepAntecedentes.year(), diasPrepAntecedentes.month(), diasPrepAntecedentes.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());
                q.FechaPrepCotizacion__c = DateTime.newInstance(diasPrepCotizacion.year(), diasPrepCotizacion.month(), diasPrepCotizacion.day(), DateTime.Now().hour(), Datetime.now().minute(), Datetime.now().second());   
            }
            else {
                continue;
            }
        }
    }


    /**
     * registraCumplimientoRenovacionSLA
     * Registra el cumplimiento de los SLA al cambiar de etapa, este metodo DEBE mantenerse al final
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts Map<Id, Quote>: before update quotes (new state)
     * @param: oldQts Map<Id, Quote>: before update quotes (old state)
     * @return: void
     * @date: 06-03-2021
     */
    public static void registraCumplimientoRenovacionSLA(List<Quote> newQts)
    {
        Boolean esRenovacion = false;
        Id presupuestoRenovacion = getRecordTypeId('Cotizacion_Comercial_Renovacion', 'Quote');
        System.debug('newQts: ' + newQts);
        for (Quote item: newQts) {
            if(presupuestoRenovacion == item.RecordTypeId){
                esRenovacion = true;
            }
        }

        if(!esRenovacion){ return; }

        /*Set<String> businessDays = new Set<String>();
        businessDays.add('SUN');
        businessDays.add('SAT');

        Integer contDays = 0;
        DateTime myDateTime; 
        String dayOfWeek; 
        Datetime now = Datetime.now();*/

        for (Quote item: newQts) {
            /*if (item.Status == 'Preparar Antecedentes')
            {
                myDateTime = now;
                dayOfWeek = myDateTime.addDays(1).format('E');
                if(businessDays.contains(dayOfWeek.toUpperCase())){
                    contDays = 2;
                }
          
                Integer horaCierre = Integer.valueOf(item.FechaTarificacion__c.format('HH:mm:ss').replace(':', '')); 
                Integer diaSiguiente = (horaCierre > 150000) ? 1 : 0;*/
                item.FechaTarificacion__c = null;
                item.FechaPrepAntecedentes__c = null;
                item.FechaPrepCotizacion__c = null;
               /* contDays = 0;
            }*/
        }
    }

    private static Id getRecordTypeId(String devName, String objName){
        return [SELECT Id FROM RecordType WHERE DeveloperName = :devName AND SobjectType = :objName LIMIT 1].Id;
    }


    /**
     * emailCambioSuscriptor
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: after update quotes
     * @param: oldQts List<Quote>: after update quotes
     * @return: void
     * @date: 22-03-2020
     */
    /*public static void emailCambioSuscriptor(List<Quote> newQts, List<Quote> oldQts)
    {
        Boolean cambioSuscriptor = false;
        Set<Id> suscriptorId = new Set<Id>();
        Set<Id> propietarioId = new Set<Id>();
        String idQuote;

        for(Quote quoteNew: newQts){
            for(Quote quoteOld: oldQts){
                if(quoteOld.Suscriptor__c != quoteNew.Suscriptor__c){
                    cambioSuscriptor = true;
                    suscriptorId.add(quoteNew.Suscriptor__c);
                    propietarioId.add(quoteNew.OwnerId);
                    idQuote = quoteNew.Id;
                }
            }
        }
        
        if(!cambioSuscriptor || suscriptorId.isEmpty() || propietarioId.isEmpty()){ return; }

        List<User> dataUser = new List<User>();
        List<User> dataOwner = new List<User>();
        if(Schema.sObjectType.User.isAccessible()){
            dataUser = [SELECT Id, Email FROM User WHERE Id IN :(suscriptorId)];
            dataOwner = [SELECT Id, Email FROM User WHERE Id IN :(propietarioId)];
        }
        
        if(dataUser.isEmpty()){ return; }
        if(dataOwner.isEmpty()){ return; }

        EmailTemplate emailTemplate = new EmailTemplate();
        if(Schema.sObjectType.EmailTemplate.isAccessible()){
            emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
                            FROM EmailTemplate
                            WHERE DeveloperName = 'Notificacion_Cambio_Suscriptor'];
        }

        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage singleMail = new Messaging.SingleEmailMessage();
        List<String> listEmail = new List<String>();
        String contactEmail;

        for(User u: dataUser){
            listEmail.add(u.Email);
            contactEmail = u.Email;
        }

        for(User u: dataOwner){
            listEmail.add(u.Email);
        }

        if(listEmail.isEmpty() && String.isEmpty(idQuote)){ return; }

        Contact tmpContact = new Contact();
        tmpContact.LastName = 'tmpContact';
        tmpContact.Email = contactEmail;
        Insert tmpContact;
        
        if(String.isEmpty(tmpContact.Id)){ return; }

        singleMail.setWhatId(idQuote);
        singleMail.setTemplateID(emailTemplate.Id);
        singleMail.setToAddresses(listEmail);
        singleMail.setTargetObjectId(tmpContact.Id);
        singleMail.setUseSignature(false);
        singleMail.setSaveAsActivity(false);
        mailsToSend.add(singleMail);

        if(mailsToSend.isEmpty()){
            return;
        } else {
            Messaging.sendEmail(mailsToSend);
            Delete tmpContact;
        }
    }*/

    /**
     * notificacionesPresupuesto
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: after update quotes
     * @param: oldQts List<Quote>: after update quotes
     * @return: void
     * @date: 22-03-2020
     */
    /*public static void notificacionesPresupuesto(List<Quote> newQts, List<Quote> oldQts)
    {
        String newStage;
        String oldStage;
        String idQuote;
        Datetime oldFechaCumpAntecedentes;
        Datetime oldFechaCumpTarificacion;
        Datetime oldFechaCumpCotizacion;
        Datetime newFechaCumpAntecedentes;
        Datetime newFechaCumpTarificacion;
        Datetime newFechaCumpCotizacion;
        Set<Id> suscriptorId = new Set<Id>();

        for(Quote n: newQts){
            newStage = n.Status;
            suscriptorId.add(n.Suscriptor__c);
            idQuote = n.Id;
            newFechaCumpAntecedentes = n.FechaCumpAntecedentes__c;
            newFechaCumpTarificacion = n.FechaCumpTarificacion__c;
            newFechaCumpCotizacion   = n.FechaCumpCotizacion__c;
        }

        for(Quote o: oldQts){
            oldStage = o.Status;
            oldFechaCumpAntecedentes = o.FechaCumpAntecedentes__c;
            oldFechaCumpTarificacion = o.FechaCumpTarificacion__c;
            oldFechaCumpCotizacion = o.FechaCumpCotizacion__c;
        }

        if(String.isEmpty(newStage) || String.isEmpty(oldStage) ){ return; }

        List<User> dataUser = new List<User>();
        if(Schema.sObjectType.User.isAccessible()){
            dataUser = [SELECT Id, Email FROM User WHERE Id IN :(suscriptorId)];
        }

        if(dataUser.isEmpty()){ return; }

        String templateName;
        Boolean stageChange = (oldStage != newStage);
        Boolean changeFechaCumpAntecedentes = (oldFechaCumpAntecedentes != newFechaCumpAntecedentes);
        Boolean changeFechaCumpTarificacion = (oldFechaCumpTarificacion != newFechaCumpTarificacion);
        Boolean changeFechaCumpCotizacion = (oldFechaCumpCotizacion != newFechaCumpCotizacion);

        if(stageChange){
            templateName = 'Notificacion_Cambio_de_etapa_en_presupuesto'; 
        } else if(changeFechaCumpAntecedentes || changeFechaCumpTarificacion || changeFechaCumpCotizacion){
            templateName = 'Notificacion_Cambios_en_SLA';
        }

        if(String.isEmpty(templateName)){ return; }

        EmailTemplate emailTemplate = new EmailTemplate();
        if(Schema.sObjectType.EmailTemplate.isAccessible()){
            emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body
                            FROM EmailTemplate
                            WHERE DeveloperName = :templateName];
        }

        List<String> listEmail = new List<String>();
        String contactEmail;

        for(User u: dataUser){
            listEmail.add(u.Email);
            contactEmail = u.Email;
        }

        if(listEmail.isEmpty() && String.isEmpty(idQuote)){ return; }

        Contact tmpContact = new Contact();
        tmpContact.LastName = 'tmpContact';
        tmpContact.Email = contactEmail;
        Insert tmpContact;
        
        if(String.isEmpty(tmpContact.Id)){ return; }

        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setWhatId(idQuote);
        email.setTemplateID(emailTemplate.Id);
        email.setToAddresses(listEmail);
        email.setTargetObjectId(tmpContact.Id);
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        emailToSend.add(email);

        if(emailToSend.isEmpty()){
            return;
        } else {
            Messaging.sendEmail(emailToSend);
            Delete tmpContact;
        }
    }*/

    /**
     * emailCotizacionCreada
     * - Se envía el email a los corredores y dueño de la oportunidad cuando se crea una cotización
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: before insert quotes
     * @return: void
     * @date: 23-06-2020
     */
    // public static void emailCotizacionCreada(List<Quote> newQts) {
    //     Set<Id> idOpp = new Set<Id>();
    //     for(Quote qt: newQts){
    //         idOpp.add(qt.OpportunityId);
    //     }

    //     if(idOpp.isEmpty()) return;

    //     List<Opportunity> dataAccount = [SELECT Id, Account.NP_Nombre_Cliente_Completo__c, Account.Email_Comercial__c, Account.Id
    //                                         FROM Opportunity WHERE Id IN: (idOpp)];

    //     if(dataAccount.isEmpty()) return;

    //     Set<Id> idAccounts = new Set<Id>();

    //     for (Opportunity ac: dataAccount){
    //         idAccounts.add(ac.Account.Id);
    //     }

    //     List<Contact> dataContact = [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN:idAccounts];

    //     Map<Id, List<Corredores_Venta__c>> contactEmailByOp = OpportunityTriggerHandler.contactosCorredoresPorOportunidad(idOpp);

    //     if(contactEmailByOp.isEmpty()) return;

    //     EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body
    //                                     FROM EmailTemplate
    //                                     WHERE DeveloperName = 'Corre_cotizacion_creada_comercial'];

    //     List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();

    //     messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
    //     List<String> listEmail = new List<String>();
    //     String client;
    //     String nameCompany;
    //     String emailReply;
    //     String contact;
    //     String quote;
    //     String idQuote;
    //     List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: idOpp];

    //     for (Opportunity op: opportunities) {
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

    //             for(Quote qt: newQts){
    //                 if(qt.OpportunityId == op.Id){
    //                     quote = qt.IdCotizacionComercial__c;
    //                     idQuote = qt.Id;
    //                     nameCompany = qt.Nombre_empresa__c;
    //                 }
    //             }
    //             singleMail.setTargetObjectId(contact);
    //             singleMail.setWhatId(idQuote);
    //             singleMail.setTemplateID(emailTemplate.Id);
    //             singleMail.setUseSignature(false);
    //             singleMail.setSaveAsActivity(false);
    //             singleMail.setReplyTo(emailReply);

    //             mailsToSend.add(singleMail);

    //             singleMail = new messaging.SingleEmailMessage ();
    //             client = '';
    //             emailReply = '';
    //             nameCompany = '';
    //             quote = '';
    //             idQuote = '';
    //         }
    //     }

    //     if(mailsToSend.isEmpty()){
    //         return;
    //     } else {
    //         Messaging.sendEmail(mailsToSend);
    //     }
    // }

    // /**
    //  * emailCotizacionNegociacion
    //  * - Se envía el email a los corredores y dueño de la oportunidad cuando se
    //  * @author: ChangeMeIn@UserSettingsUnder.SFDoc
    //  * @param: newQts List<Quote>: after update quotes
    //  * @return: void
    //  * @date: 24-06-2020
    //  */
    // public static void emailCotizacionNegociacion(List<Quote> newQts, List<Quote> oldQts) {
    //     Boolean stageUpdate = false;
    //     for(Quote qt: newQts){
    //         for (Quote qtt: oldQts) {
    //             if(qt.Id == qtt.Id && qt.Status != qtt.Status && qt.Status == 'Negociacion'){
    //                 stageUpdate = true;
    //             }
    //         }
    //     }

    //     if (!stageUpdate) return;

    //     Set<Id> idOpp = new Set<Id>();
    //     Set<Id> idDocumentsQuote = new Set<Id>();
    //     Id idQT;
    //     for(Quote qt: newQts){
    //         idOpp.add(qt.OpportunityId);
    //         if(idQT == null){
    //             idDocumentsQuote.add(qt.IdPropuestaComercial__c);
    //         } else if(idQT != qt.Id){
    //             idDocumentsQuote.add(qt.IdPropuestaComercial__c);
    //         }
    //         idQT = qt.Id;
    //     }

    //     if(idOpp.isEmpty()) return;

    //     Map<Id, ContentVersion> fileByQuote = new Map<Id, ContentVersion>();
    //     if(!idDocumentsQuote.isEmpty()){
    //         fileByQuote = archivosPorQuote(idDocumentsQuote);
    //     }

    //     List<Opportunity> dataAccount = [SELECT Id, Account.NP_Nombre_Cliente_Completo__c, Account.Email_Comercial__c, Account.Id
    //                                         FROM Opportunity WHERE Id IN: (idOpp)];

    //     if(dataAccount.isEmpty()) return;

    //     Set<Id> idAccounts = new Set<Id>();

    //     for (Opportunity ac: dataAccount){
    //         idAccounts.add(ac.Account.Id);
    //     }

    //     List<Contact> dataContact = [SELECT Id, AccountId, Email FROM Contact WHERE AccountId IN:idAccounts];

    //     Map<Id, List<Corredores_Venta__c>> contactEmailByOp = OpportunityTriggerHandler.contactosCorredoresPorOportunidad(idOpp);

    //     if(contactEmailByOp.isEmpty()) return;

    //     EmailTemplate emailTemplate = [SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body
    //                                     FROM EmailTemplate
    //                                     WHERE DeveloperName = 'Correo_cotizacion_negociacion_comercial'];

    //     List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();

    //     messaging.SingleEmailMessage singleMail = new messaging.SingleEmailMessage();
    //     List<String> listEmail = new List<String>();
    //     String client;
    //     String nameCompany;
    //     String emailReply;
    //     String contact;
    //     String quote;
    //     String idQuote;
    //     List<String> listEmailCopy = new List<String>();
    //     List<String> listFile = new List<String>();
    //     List<Opportunity> opportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id IN: idOpp];

    //     for (Opportunity op: opportunities) {
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

    //             for(Quote qt: newQts){
    //                 if(qt.OpportunityId == op.Id){
    //                     quote = qt.IdCotizacionComercial__c;
    //                     idQuote = qt.Id;
    //                     nameCompany = qt.Nombre_empresa__c;
    //                     if(!String.isBlank(qt.Email_Suscriptor__c)){
    //                         listEmailCopy.add(qt.Email_Suscriptor__c);
    //                     }
    //                 }
    //             }
    //             singleMail.setTargetObjectId(contact);
    //             singleMail.setWhatId(idQuote);
    //             singleMail.setTemplateID(emailTemplate.Id);
    //             singleMail.setUseSignature(false);
    //             singleMail.setSaveAsActivity(false);
    //             singleMail.setReplyTo(emailReply);
    //             if(!listEmailCopy.isEmpty()){
    //                 singleMail.setCcAddresses(listEmailCopy);
    //             }

    //             if(fileByQuote != null){
    //                 if(fileByQuote.keySet().contains(idQuote)){
    //                     listFile.add(fileByQuote.get(idQuote).Id);
    //                 }
    //                 singleMail.setEntityAttachments(listFile);
    //             }

    //             mailsToSend.add(singleMail);

    //             singleMail = new messaging.SingleEmailMessage ();
    //             client = '';
    //             emailReply = '';
    //             nameCompany = '';
    //             quote = '';
    //             idQuote = '';
    //             listEmailCopy = new List<String>();
    //             listEmail = new List<String>();
    //             listFile = new List<String>();
    //         }
    //     }

    //     if(mailsToSend.isEmpty()){
    //         return;
    //     } else {
    //         Messaging.sendEmail(mailsToSend);
    //     }
    // }

    // public static Map<Id, ContentVersion> archivosPorQuote(Set<Id> idDocumentsQuote ){
    //     Map<Id, ContentVersion>filesByQuote = new Map<Id, ContentVersion>();

    //     List<ContentDocumentLink> files = [SELECT ContentDocumentId, LinkedEntityId
    //                                                 FROM ContentDocumentLink WHERE ContentDocumentId IN: idDocumentsQuote];

    //     if(files.isEmpty()) return new Map<Id, ContentVersion>();

    //     Set<Id> documentId = new Set<Id>();

    //     for(ContentDocumentLink fl: files){
    //         documentId.add(fl.ContentDocumentId);
    //     }

    //     List<ContentVersion> versionFile = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: documentId];

    //     ContentVersion fileInfo = new ContentVersion();
    //     for(ContentDocumentLink fl: files){
    //         if(fl.LinkedEntityId == null) continue;


    //         for(ContentVersion vr: versionFile){
    //             if(vr.ContentDocumentId == fl.ContentDocumentId && fileInfo.Id != vr.Id){
    //                 fileInfo.Id = vr.Id;
    //             }
    //         }

    //         if(fileInfo != null){
    //             filesByQuote.put(fl.LinkedEntityId, fileInfo);
    //         }
    //         fileInfo = new ContentVersion();
    //     }

    //     if(filesByQuote.isEmpty()){
    //         return new Map<Id, ContentVersion>();
    //     } else {
    //         return filesByQuote;
    //     }
    // }

    /*public static void creacionPresupuestoSegunOpp(List<Quote> newQts)
    {
        Set<Id> idOpp = new Set<Id>();

        for(Quote q: newQts){
            idOpp.add(q.OpportunityId);
        }
        System.debug('newQts: ' + newQts);
        System.debug('idOpp: ' + idOpp);
        List<Opportunity> dataOpp = new List<Opportunity>();
        if(Schema.sObjectType.Opportunity.isAccessible()){
            dataOpp = [SELECT Id, RecordTypeId FROM Opportunity WHERE Id IN :(idOpp)];
        }
        System.debug('dataOpp: ' + dataOpp);
        if(dataOpp.isEmpty()){ return; }

        Id comercialNuevo = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Comercial Nuevo').getRecordTypeId();
        Id comercialRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Comercial Renovación').getRecordTypeId();
        Id presupuestoComercial = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Presupuesto Comercial').getRecordTypeId();
        Id presupuestoRenovacion = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Presupuesto Renovación').getRecordTypeId();

        Id rtOpp = dataOpp.get(0).RecordTypeId;
        Boolean nuevoOpp = (rtOpp == comercialNuevo);
        Boolean renovacionOpp = (rtOpp == comercialRenovacion);

        System.debug('comercialNuevo: ' + comercialNuevo);
        System.debug('comercialRenovacion: ' + comercialRenovacion);
        System.debug('presupuestoComercial: ' + presupuestoComercial);
        System.debug('presupuestoRenovacion: ' + presupuestoRenovacion);

        System.debug('rtOpp: ' + rtOpp);
        System.debug('nuevoOpp: ' + nuevoOpp);
        System.debug('renovacionOpp: ' + renovacionOpp);


        for(Quote q: newQts)
        {
            if(nuevoOpp){
                if(presupuestoComercial != q.RecordTypeId){
                    q.addError('El tipo de registro es incorrecto, el presupuesto debe ser del tipo: Presupuesto Comercial.');
                }
            }
            
            if(renovacionOpp){
                if(presupuestoRenovacion != q.RecordTypeId){
                    q.addError('El tipo de registro es incorrecto, el presupuesto debe ser del tipo: Presupuesto Renovación.');
                }
            }
        }

    }*/

      /**
     * modificarValoresOportunidad
     * Modifica los montos y contadores de la oportunidad
     * @author: ChangeMeIn@UserSettingsUnder.SFDoc
     * @param: newQts List<Quote>: before update quotes
     * @return: void
     * @date: 17-06-2020
     */
    public static Map<Id, Id> getSuscriptoresdeRenovacion(List<Quote> newQts){
        Map<Id, Id> map_oppt = new Map<Id, Id>();
        Id recordTypeId = getRecordTypeId('Cotizacion_Comercial_Renovacion', 'Quote');

        for (Quote qt : newQts){
            // obtener tipo cotizacion y oportunidad
            if (qt.RecordTypeId == recordTypeId && !map_oppt.containsKey(qt.OpportunityId)){
                map_oppt.put(qt.OpportunityId, qt.OpportunityId);
            }
        }

        if (map_oppt.isEmpty()) {
            return new Map<Id, Id>();
        }

        List<Quote> listSus = [SELECT Id, OpportunityId, Suscriptor__c, CreatedDate, RecordType.DeveloperName
                               FROM Quote
                               WHERE OpportunityId IN:map_oppt.values() AND Suscriptor__c != null
                               ORDER BY CreatedDate ASC];

        if (listSus.isEmpty()) {
            return new Map<Id, Id>();
        }
        
        Map<Id,Id> suscriptoresOppt = new Map<Id,Id>();
        for (Quote item : listSus) {
            if (!suscriptoresOppt.containsKey(item.OpportunityId)) {
                suscriptoresOppt.put(item.OpportunityId, item.Suscriptor__c);
            }
        }
        
        return suscriptoresOppt;
    }
}