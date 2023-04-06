/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 04-16-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CM_BandejaTareas_Televenta {


    public class Wrapper {
        @auraEnabled public String CampaignId {get;set;}
        @auraEnabled public String CampaignName {get;set;}
        @auraEnabled public String LeadName {get;set;}
        @auraEnabled public String LeadRUT {get;set;}
        @auraEnabled public String LeadRUT_DV {get;set;}
        @auraEnabled public String LeadId {get;set;}
        @auraEnabled public String AccountId {get;set;}
        @auraEnabled public String RelationId {get;set;}

        @auraEnabled public String RutEjecutivoTV {get;set;}
        @auraEnabled public Date FechaReprogramacion {get;set;}

        @auraEnabled public Date ActivityDate {get;set;}
        @auraEnabled public String Status {get;set;}
        @auraEnabled public String SubStatus {get;set;}

        @auraEnabled public String Subject {get;set;}
        @auraEnabled public String Priority {get;set;}
        @auraEnabled public String OwnerName {get;set;}
        @auraEnabled public String OwnerId {get;set;}
        @auraEnabled public String TaskId {get;set;}

        @auraEnabled public Datetime LastModifiedDate {get;set;}
        @auraEnabled public Datetime CreatedDate {get;set;}
        @auraEnabled public Boolean IsReminderSet {get;set;}
        @auraEnabled public Datetime ReminderDateTime {get;set;}
    }


    public CLS_CM_BandejaTareas_Televenta() {

    }

    @AuraEnabled
    public static Boolean changeOwnerTasks(List<String> Ids, String newOwnerId)
    {
        try
        {
            User usuario = [SELECT Id, Name, RUT_Usuario__c FROM User WHERE Id =: newOwnerId];

            system.debug('@@@@  tasks --> '+Ids.size());

            List<Task> updTasks = [SELECT Id, OwnerId, Last_Assigned_Owner__c FROM Task WHERE Id IN : Ids];

            for(Task task: updTasks)
            {
                task.OwnerId = newOwnerId;
                task.Last_Assigned_Owner__c = newOwnerId;
                task.TASK_RUT_Ejecutivo_Televenta__c = usuario.RUT_Usuario__c;
            }

            update updTasks;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }


    @AuraEnabled
    public static Boolean changeStatusTasks(List<String> Ids, String Status, String SubStatus)
    {
        try
        {
            system.debug('@@@@  tasks --> '+Ids.size());

            List<Task> updTasks = [SELECT Id, Status, TASK_Sub_Estado__c FROM Task WHERE Id IN : Ids];

            for(Task task: updTasks)
            {
                task.Status = Status;
                task.TASK_Sub_Estado__c = SubStatus;
            }

            update updTasks;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }


    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_SubEstado(String Estado) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Task.TASK_Sub_Estado__c, Estado) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_CampagnasTeleventa() {

        String  Campaign_RecordTypeId  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Televenta Oncológico').getRecordTypeId();
        system.debug('Campaign_RecordTypeId  '+Campaign_RecordTypeId);

        List<Campaign> campagnas = [SELECT Id, Name FROM Campaign WHERE IsActive = true AND Status = 'En Curso' AND RecordTypeId =: Campaign_RecordTypeId  ORDER BY CreatedDate DESC];

        List <CLS_UTL_Lightning.customValueWrapper> lista = new List <CLS_UTL_Lightning.customValueWrapper>();
        CLS_UTL_Lightning.customValueWrapper data= new CLS_UTL_Lightning.customValueWrapper();
        data.custFldValue = '';
        data.custFldlabel = 'Todas las Campañas';

        lista.add(data);

        for (Campaign cmp : campagnas)
        {
            data = new CLS_UTL_Lightning.customValueWrapper();
            data.custFldlabel = cmp.Name;
            data.custFldValue = cmp.Id;

            lista.add(data);
        }

        return lista;
    }



    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getTasks_Filter(String RecordType, String CampaignId, String RutCliente, String Estado, String SubEstado, String AsignadoA, String NombreCliente, Date CreatedDate, Date LastModifiedDate, Date ReminderDateTime) {

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Task_RecordTypeId);

        String query = '';

        if (RecordType == 'Ventas Oncológico')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE RecordTypeId =\''+ Task_RecordTypeId+'\' AND TASK_Campana__c != null';
        }
        else if (RecordType == 'Tarea Televentas Links')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE RecordTypeId =\''+ Task_RecordTypeId+'\' AND (Subject = \'Realizar Llamada\') ';
        }

        system.debug('query---'+query);

        if (String.isNotBlank(CampaignId)) {
            query += ' AND TASK_Campana__c  = \''+CampaignId+'\' ';
            }

            if (String.isNotBlank(Estado)) {
                String key = '\'%' + Estado + '%\'';
                query += ' AND Status  LIKE '+key+ ' ';
            }

            if (String.isNotBlank(SubEstado)) {
                String key = '\'%' + SubEstado + '%\'';
                query += ' AND TASK_Sub_Estado__c  LIKE '+key+ ' ';
            }

            if (String.isNotBlank(AsignadoA)) {
                String key = '\'%' + AsignadoA + '%\'';
                query += ' AND Owner.Name  LIKE '+key+ ' ';
            }

            if (String.isNotBlank(NombreCliente)) {
                String key = '\'%' + NombreCliente + '%\'';
                query += ' AND (Account.Name  LIKE '+key+ ' OR Who.Name LIKE '+key+ ') ';
            }

        if (CreatedDate != null) {
            DateTime startDate = datetime.newInstance(CreatedDate.year(), CreatedDate.month(), CreatedDate.day(),0,0,0);

            DateTime endDate = datetime.newInstance(CreatedDate.year(), CreatedDate.month(), CreatedDate.day(),23,59,59);

            String key = ' AND CreatedDate >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND CreatedDate <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            query =  query + key ;
        }

        if (LastModifiedDate != null) {

            DateTime startDate = datetime.newInstance(LastModifiedDate.year(), LastModifiedDate.month(), LastModifiedDate.day(),0,0,0);

            DateTime endDate = datetime.newInstance(LastModifiedDate.year(), LastModifiedDate.month(), LastModifiedDate.day(),23,59,59);

            String key = ' AND LastModifiedDate >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND LastModifiedDate <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            query =  query + key ;
        }

        if (ReminderDateTime != null) {

            DateTime startDate = datetime.newInstance(ReminderDateTime.year(), ReminderDateTime.month(), ReminderDateTime.day(),0,0,0);

            DateTime endDate = datetime.newInstance(ReminderDateTime.year(), ReminderDateTime.month(), ReminderDateTime.day(),23,59,59);

            String key = ' AND ReminderDateTime >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND ReminderDateTime <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            query =  query + key ;
        }

        query += ' ORDER BY LastModifiedDate DESC LIMIT 2000';//2000 registros maximos

        List<Task> tasks = Database.query(query);

        List<Wrapper> listaOut = new List<Wrapper>();
        Wrapper data = null;

        List<String> leadsId = new  List<String>();

        system.debug('tasks.size ---'+tasks.size());
        for (Task task : tasks)
        {
            data = new Wrapper();
            data.CampaignId = task.TASK_Campana__c;
            data.CampaignName = task.TASK_Campana__r.Name;
            data.RutEjecutivoTV = task.TASK_RUT_Ejecutivo_Televenta__c;

            if (task.WhatId != null)
            {
                data.LeadName = task.Account.Name;
                data.LeadRUT = task.Account.RUT__c;
                data.LeadRUT_DV = task.Account.Rut_con_dv__c;
                data.LeadId = '';
                data.AccountId = task.AccountId;
                data.RelationId = task.WhatId;
            }
            else
            {
                data.LeadName = '';
                data.LeadRUT = '';
                data.LeadId = task.WhoId;
                data.AccountId = '';
                data.RelationId = task.WhoId;
                leadsId.add(data.LeadId);
            }

            data.FechaReprogramacion = task.TASK_Fecha_de_Reprogramaci_n__c;
            data.ActivityDate = task.ActivityDate;
            data.Status = task.Status;
            data.SubStatus = task.TASK_Sub_Estado__c;
            data.Subject = task.Subject;
            data.Priority = task.Priority;
            data.OwnerName = task.Owner.Name;
            data.LastModifiedDate = task.LastModifiedDate;
            data.CreatedDate = task.CreatedDate;
            data.OwnerId = task.OwnerId;
            data.TaskId = task.Id;
            data.IsReminderSet = task.IsReminderSet;
            data.ReminderDateTime = task.ReminderDateTime;

            listaOut.add(data);
        }

        List<Wrapper> queryRUT = new List<Wrapper>();

        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, PROSP_Carga_RUT__c, Name FROM Lead WHERE Id IN :leadsId]);

        for(Wrapper wrp : listaOut)
        {
            if (String.isnotBlank(wrp.LeadId))
            {
                Lead lead = leadMap.get(wrp.LeadId);
                wrp.LeadName = lead.Name;
                wrp.LeadRUT = lead.PROSP_Carga_RUT__c.split('-')[0];
                wrp.LeadRUT_DV = lead.PROSP_Carga_RUT__c;
            }

            if (String.isNotBlank(RutCliente)  && (wrp.LeadRUT == RutCliente || wrp.LeadRUT_DV == RutCliente)) {
                queryRUT.add(wrp);
            }
        }

        if (String.isNotBlank(RutCliente) ) {
            return queryRUT;
        }

        return listaOut;
    }


    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getTasks_Filter_Owner(String RecordType, String OwnerId, String CampaignId, String RutCliente, String Estado, String SubEstado, String NombreCliente, Date CreatedDate, Date LastModifiedDate, Date ReminderDateTime) {

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Task_RecordTypeId);

        String query = '';

        if (RecordType == 'Ventas Oncológico')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE RecordTypeId =\''+ Task_RecordTypeId+'\' AND TASK_Campana__c != null AND OwnerId = \''+ OwnerId +'\' ';
        }
        else if (RecordType == 'Tarea Televentas Links')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE RecordTypeId =\''+ Task_RecordTypeId+'\' AND (Subject = \'Realizar Llamada\') AND OwnerId = \''+ OwnerId +'\' ';
        }

        system.debug('query---'+query);

        if (String.isNotBlank(CampaignId)) {
            query += ' AND TASK_Campana__c  = \''+CampaignId+'\' ';
            }

            if (String.isNotBlank(Estado)) {
                String key = '\'%' + Estado + '%\'';
                query += ' AND Status  LIKE '+key+ ' ';
            }

            if (String.isNotBlank(SubEstado)) {
                String key = '\'%' + SubEstado + '%\'';
                query += ' AND TASK_Sub_Estado__c  LIKE '+key+ ' ';
            }

            if (String.isNotBlank(NombreCliente)) {
                String key = '\'%' + NombreCliente + '%\'';
                query += ' AND (Account.Name  LIKE '+key+ ' OR Who.Name LIKE '+key+ ') ';
            }

        if (CreatedDate != null) {
            DateTime startDate = datetime.newInstance(CreatedDate.year(), CreatedDate.month(), CreatedDate.day(),0,0,0);

            DateTime endDate = datetime.newInstance(CreatedDate.year(), CreatedDate.month(), CreatedDate.day(),23,59,59);

            String key = ' AND CreatedDate >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND CreatedDate <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            query =  query + key ;
        }

        if (LastModifiedDate != null) {

            DateTime startDate = datetime.newInstance(LastModifiedDate.year(), LastModifiedDate.month(), LastModifiedDate.day(),0,0,0);

            DateTime endDate = datetime.newInstance(LastModifiedDate.year(), LastModifiedDate.month(), LastModifiedDate.day(),23,59,59);

            String key = ' AND LastModifiedDate >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND LastModifiedDate <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            query =  query + key ;
        }

        if (ReminderDateTime != null) {

            DateTime startDate = datetime.newInstance(ReminderDateTime.year(), ReminderDateTime.month(), ReminderDateTime.day(),0,0,0);

            DateTime endDate = datetime.newInstance(ReminderDateTime.year(), ReminderDateTime.month(), ReminderDateTime.day(),23,59,59);

            String key = ' AND ReminderDateTime >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND ReminderDateTime <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');

            query =  query + key ;
        }

        query += ' ORDER BY LastModifiedDate DESC LIMIT 2000';//2000 registros maximos

        List<Task> tasks = Database.query(query);

        List<Wrapper> listaOut = new List<Wrapper>();
        Wrapper data = null;

        List<String> leadsId = new  List<String>();

        system.debug('tasks.size ---'+tasks.size());
        for (Task task : tasks)
        {
            data = new Wrapper();
            data.CampaignId = task.TASK_Campana__c;
            data.CampaignName = task.TASK_Campana__r.Name;
            data.RutEjecutivoTV = task.TASK_RUT_Ejecutivo_Televenta__c;

            if (task.WhatId != null)
            {
                data.LeadName = task.Account.Name;
                data.LeadRUT = task.Account.RUT__c;
                data.LeadRUT_DV = task.Account.Rut_con_dv__c;
                data.LeadId = '';
                data.AccountId = task.AccountId;
                data.RelationId = task.WhatId;
            }
            else
            {
                data.LeadName = '';
                data.LeadRUT = '';
                data.LeadId = task.WhoId;
                data.AccountId = '';
                data.RelationId = task.WhoId;
                leadsId.add(data.LeadId);
            }

            data.FechaReprogramacion = task.TASK_Fecha_de_Reprogramaci_n__c;
            data.ActivityDate = task.ActivityDate;
            data.Status = task.Status;
            data.SubStatus = task.TASK_Sub_Estado__c;
            data.Subject = task.Subject;
            data.Priority = task.Priority;
            data.OwnerName = task.Owner.Name;
            data.LastModifiedDate = task.LastModifiedDate;
            data.CreatedDate = task.CreatedDate;
            data.OwnerId = task.OwnerId;
            data.TaskId = task.Id;
            data.IsReminderSet = task.IsReminderSet;
            data.ReminderDateTime = task.ReminderDateTime;

            listaOut.add(data);
        }

        List<Wrapper> queryRUT = new List<Wrapper>();

        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, PROSP_Carga_RUT__c, Name FROM Lead WHERE Id IN :leadsId]);

        for(Wrapper wrp : listaOut)
        {
            if (String.isnotBlank(wrp.LeadId))
            {
                Lead lead = leadMap.get(wrp.LeadId);
                wrp.LeadName = lead.Name;
                wrp.LeadRUT = lead.PROSP_Carga_RUT__c.split('-')[0];
                wrp.LeadRUT_DV = lead.PROSP_Carga_RUT__c;
            }

            if (String.isNotBlank(RutCliente)  && (wrp.LeadRUT == RutCliente || wrp.LeadRUT_DV == RutCliente)) {
                queryRUT.add(wrp);
            }
        }

        if (String.isNotBlank(RutCliente) ) {
            return queryRUT;
        }

        return listaOut;
    }



    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getTasksForIds(List<String> Ids) {

         List<Task> tasks = [SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE Id IN :Ids];


        List<Wrapper> listaOut = new List<Wrapper>();
        Wrapper data = null;

        List<String> leadsId = new  List<String>();

        for (Task task : tasks)
        {
            data = new Wrapper();
            data.CampaignId = task.TASK_Campana__c;
            data.CampaignName = task.TASK_Campana__r.Name;

            if (task.WhatId != null)
            {
                data.LeadName = task.Account.Name;
                data.LeadRUT = task.Account.RUT__c;
                data.LeadRUT_DV = task.Account.Rut_con_dv__c;
                data.LeadId = '';
                data.AccountId = task.AccountId;
                data.RelationId = task.WhatId;
            }
            else
            {
                data.LeadName = '';
                data.LeadRUT = '';
                data.LeadId = task.WhoId;
                data.AccountId = '';
                data.RelationId = task.WhoId;
                leadsId.add(data.LeadId);
            }

            data.FechaReprogramacion = task.TASK_Fecha_de_Reprogramaci_n__c;
            data.ActivityDate = task.ActivityDate;
            data.Status = task.Status;
            data.SubStatus = task.TASK_Sub_Estado__c;
            data.Subject = task.Subject;
            data.Priority = task.Priority;
            data.OwnerName = task.Owner.Name;
            data.LastModifiedDate = task.LastModifiedDate;
            data.CreatedDate = task.CreatedDate;
            data.OwnerId = task.OwnerId;
            data.TaskId = task.Id;
            data.IsReminderSet = task.IsReminderSet;
            data.ReminderDateTime = task.ReminderDateTime;

            listaOut.add(data);
        }

        List<Wrapper> queryRUT = new List<Wrapper>();

        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, PROSP_Carga_RUT__c, Name FROM Lead WHERE Id IN :leadsId]);

        for(Wrapper wrp : listaOut)
        {
            if (String.isnotBlank(wrp.LeadId))
            {
                Lead lead = leadMap.get(wrp.LeadId);
                wrp.LeadName = lead.Name;
                wrp.LeadRUT = lead.PROSP_Carga_RUT__c.split('-')[0];
                wrp.LeadRUT_DV = lead.PROSP_Carga_RUT__c;
            }
        }

        return listaOut;
    }


    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getTasks_Remembers_Owner(String RecordType, String OwnerId) {

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get(RecordType).getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Task_RecordTypeId);

        Date dToday = Date.today();

        DateTime startDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),0,0,0);

        DateTime endDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),23,59,59);

        String query = '';

        if (RecordType == 'Ventas Oncológico')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE (Status = \'Abierta\' OR  Status = \'En Curso\') AND RecordTypeId =\''+ Task_RecordTypeId+'\' AND TASK_Campana__c != null AND OwnerId = \''+ OwnerId +'\' AND ReminderDateTime >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND ReminderDateTime <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' ORDER BY ReminderDateTime ASC LIMIT 1000';
        }
        else if (RecordType == 'Tarea Televentas Links')
        {
            query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE (Subject = \'Realizar Llamada\') AND (Status = \'Abierta\' OR  Status = \'En Curso\') AND RecordTypeId =\''+ Task_RecordTypeId+'\' AND OwnerId = \''+ OwnerId +'\' AND ReminderDateTime >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND ReminderDateTime <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' ORDER BY ReminderDateTime ASC LIMIT 1000';
        }

        system.debug('query---'+query);

        List<Task> tasks = Database.query(query);

        List<Wrapper> listaOut = new List<Wrapper>();
        Wrapper data = null;

        List<String> leadsId = new  List<String>();

        system.debug('tasks.size ---'+tasks.size());
        for (Task task : tasks)
        {
            data = new Wrapper();
            data.CampaignId = task.TASK_Campana__c;
            data.CampaignName = task.TASK_Campana__r.Name;
            data.RutEjecutivoTV = task.TASK_RUT_Ejecutivo_Televenta__c;

            if (task.WhatId != null)
            {
                data.LeadName = task.Account.Name;
                data.LeadRUT = task.Account.RUT__c;
                data.LeadRUT_DV = task.Account.Rut_con_dv__c;
                data.LeadId = '';
                data.AccountId = task.AccountId;
                data.RelationId = task.WhatId;
            }
            else
            {
                data.LeadName = '';
                data.LeadRUT = '';
                data.LeadId = task.WhoId;
                data.AccountId = '';
                data.RelationId = task.WhoId;
                leadsId.add(data.LeadId);
            }

            data.FechaReprogramacion = task.TASK_Fecha_de_Reprogramaci_n__c;
            data.ActivityDate = task.ActivityDate;
            data.Status = task.Status;
            data.SubStatus = task.TASK_Sub_Estado__c;
            data.Subject = task.Subject;
            data.Priority = task.Priority;
            data.OwnerName = task.Owner.Name;
            data.LastModifiedDate = task.LastModifiedDate;
            data.CreatedDate = task.CreatedDate;
            data.OwnerId = task.OwnerId;
            data.TaskId = task.Id;
            data.IsReminderSet = task.IsReminderSet;
            data.ReminderDateTime = task.ReminderDateTime;

            listaOut.add(data);
        }

        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, PROSP_Carga_RUT__c, Name FROM Lead WHERE Id IN :leadsId]);

        for(Wrapper wrp : listaOut)
        {
            if (String.isnotBlank(wrp.LeadId))
            {
                Lead lead = leadMap.get(wrp.LeadId);
                wrp.LeadName = lead.Name;
                wrp.LeadRUT = lead.PROSP_Carga_RUT__c.split('-')[0];
                wrp.LeadRUT_DV = lead.PROSP_Carga_RUT__c;
            }
        }

        return listaOut;
    }

 }