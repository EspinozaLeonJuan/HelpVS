/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-06-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CM_Bandeja_Prospectos_Links {


    public class Wrapper {
        @auraEnabled public String CampaignId {get;set;}
        @auraEnabled public String CampaignName {get;set;}
        @auraEnabled public String LeadName {get;set;}
        @auraEnabled public String LeadRUT {get;set;}
        @auraEnabled public String LeadRUT_DV {get;set;}
        @auraEnabled public String LeadId {get;set;}
        @auraEnabled public String AccountId {get;set;}

        @auraEnabled public String NombreBase {get;set;}
        @auraEnabled public String TipoBase {get;set;}
        @auraEnabled public String TipoLink {get;set;}

        @auraEnabled public String OwnerId {get;set;}
        @auraEnabled public String OwnerName {get;set;}
        @auraEnabled public String Status {get;set;}
        @auraEnabled public String SubStatus {get;set;}

        @auraEnabled public Datetime Reprogramacion {get;set;}
        @auraEnabled public DateTime FechaEntrevista {get;set;}
        @auraEnabled public Datetime LastModifiedDate {get;set;}
        @auraEnabled public Datetime CreatedDate {get;set;}
    }

    public class WrapperTask {
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


    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getLeads_Filter(String CampaignId, String RutCliente, String Estado, String SubEstado, String AsignadoA, String NombreCliente, Date CreatedDate, Date LastModifiedDate,Date FechaEntrevista,Date Reprogramacion, String NombreBase, String TipoBase, String TipoLink)
    {
        List<Wrapper> listaOut = new List<Wrapper>();

        String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Lead_RecordTypeId);

        String query = '';

        if (String.isBlank(CampaignId))
        {
            query = 'SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE RecordTypeId =\''+ Lead_RecordTypeId+'\' AND ( Status = \'Abierto\' OR Status = \'En Proceso\' OR Status = \'Habilitado\' OR Status = \'No Calificado\' OR Status = \'No Interesado\') ';
        }
        else if (String.isNotBlank(CampaignId))
        {
            Set<Id> keys = new Set<Id>();

            List<CampaignMember> miembros = [SELECT Id, LeadId FROM CampaignMember WHERE CampaignId =: CampaignId AND LeadId != null];

            for (CampaignMember cm : miembros)
            {
                keys.add(cm.LeadId);
            }

            query = 'SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE RecordTypeId =\''+ Lead_RecordTypeId+'\' AND ( Status = \'Abierto\' OR Status = \'En Proceso\' OR Status = \'Habilitado\' OR Status = \'No Calificado\' OR Status = \'No Interesado\') AND Id IN: keys';
        }

        if (String.isNotBlank(RutCliente)) {
            String key = '\'%' + RutCliente + '%\'';
            query += ' AND RUT_DV__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(Estado)) {
            String key = '\'%' + Estado + '%\'';
            query += ' AND Status  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(SubEstado)) {
            String key = '\'%' + SubEstado + '%\'';
            query += ' AND Sub_Estado__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(AsignadoA)) {
            String key = '\'%' + AsignadoA + '%\'';
            query += ' AND Owner.Name  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(NombreCliente)) {
            String key = '\'%' + NombreCliente + '%\'';
            query += ' AND Name  LIKE '+key+ ' ';
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


        if (FechaEntrevista != null) {

            DateTime startDate = datetime.newInstance(FechaEntrevista.year(), FechaEntrevista.month(), FechaEntrevista.day(),0,0,0);

            DateTime endDate = datetime.newInstance(FechaEntrevista.year(), FechaEntrevista.month(), FechaEntrevista.day(),23,59,59);

            String key = ' AND Fecha_Entrevista__c >= '+ startDate.format('yyyy-MM-dd') +' AND Fecha_Entrevista__c <=' + endDate.format('yyyy-MM-dd');
            query =  query + key ;
        }
        if (Reprogramacion != null) {

            DateTime startDate = datetime.newInstance(Reprogramacion.year(), Reprogramacion.month(), Reprogramacion.day(),0,0,0);

            DateTime endDate = datetime.newInstance(Reprogramacion.year(), Reprogramacion.month(), Reprogramacion.day(),23,59,59);

            String key = ' AND Reprogramacion__c >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND Reprogramacion__c <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            query =  query + key ;
        }

        if (String.isNotBlank(NombreBase)) {
            String key = '\'%' + NombreBase + '%\'';
            query += ' AND Nombre_Base__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(TipoBase)) {
            String key = '\'%' + TipoBase + '%\'';
            query += ' AND Tipo_Base__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(TipoLink)) {
            String key = '\'%' + TipoLink + '%\'';
            query += ' AND Tipo_Link__c  LIKE '+key+ ' ';
        }

        query += ' ORDER BY LastModifiedDate DESC LIMIT 2000';//2000 registros maximos

        system.debug('@@@@ QUERY  -->  '+query);

        List<Lead> leads = Database.query(query);

        Wrapper data;


        for (Lead lead : leads)
        {
            data = new Wrapper();
            if (lead.CampaignMembers.size() > 0)
            {
                data.CampaignId = lead.CampaignMembers[0].CampaignId;
                data.CampaignName = lead.CampaignMembers[0].Campaign.Name;
            }
            data.LeadName = lead.Name;
            data.LeadRUT = lead.PROSP_Carga_RUT__c;
            data.LeadRUT_DV = lead.PROSP_Carga_RUT__c+'-'+lead.DV__c;
            data.NombreBase = lead.Nombre_Base__c;
            data.TipoBase = lead.Tipo_Base__c;
            data.TipoLink = lead.Tipo_Link__c;
            data.OwnerName = lead.Owner.Name;
            data.Status = lead.Status;
            data.SubStatus = lead.Sub_Estado__c;
            data.LeadId = lead.Id;
            if (lead.Fecha_Entrevista__c != null && lead.Hora_Entrevista__c  != null )
            {
                DateTime fechaEnt = datetime.newInstance(lead.Fecha_Entrevista__c.year(), lead.Fecha_Entrevista__c.month(), lead.Fecha_Entrevista__c.day(),
                lead.Hora_Entrevista__c.hour(), lead.Hora_Entrevista__c.minute(), lead.Hora_Entrevista__c.second());

                data.FechaEntrevista = fechaEnt;
            }
            data.Reprogramacion = lead.Reprogramacion__c;
            data.LastModifiedDate = lead.LastModifiedDate;
            data.CreatedDate = lead.CreatedDate;
            data.OwnerId = lead.OwnerId;

            listaOut.add(data);
        }

        system.debug('@@@@ listaOut.size()  -->  '+listaOut.size());

        return listaOut;
    }


    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_CampagnasLinks() {

        String  Campaign_RecordTypeId  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Links').getRecordTypeId();
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
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_SubEstado(String Estado) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Lead.Sub_Estado__c, Estado) ;
    }


    @AuraEnabled
    public static Boolean changeOwnerLeads(List<String> Ids, String newOwnerId)
    {
        try
        {
            //User usuario = [SELECT Id, Name, RUT_Usuario__c FROM User WHERE Id =: newOwnerId];

            system.debug('@@@@  tasks --> '+Ids.size());

            List<Lead> updLeads = [SELECT Id, OwnerId FROM Lead WHERE Id IN : Ids];

            for(Lead lead: updLeads)
            {
                lead.OwnerId = newOwnerId;
            }

            update updLeads;

            return true;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex --< '+ex);
            return false;
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getLeadForIds(List<String> Ids) {
        system.debug('@@@@Ids.size '+Ids.size());

        List<Lead> leads = [SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE Id IN :Ids];

        system.debug('@@@@leads.size '+leads.size());

        List<Wrapper> listaOut = new List<Wrapper>();
        Wrapper data = null;

        Integer cont = 1;
        for (Lead lead : leads)
        {
            data = new Wrapper();
            if (lead.CampaignMembers.size() > 0)
            {
                data.CampaignId = lead.CampaignMembers[0].CampaignId;
                data.CampaignName = lead.CampaignMembers[0].Campaign.Name;
            }
            data.LeadName = lead.Name;
            data.LeadRUT = lead.PROSP_Carga_RUT__c;
            data.LeadRUT_DV = lead.PROSP_Carga_RUT__c+'-'+lead.DV__c;
            data.NombreBase = lead.Nombre_Base__c;
            data.TipoBase = lead.Tipo_Base__c;
            data.TipoLink = lead.Tipo_Link__c;
            data.OwnerName = lead.Owner.Name;
            data.Status = lead.Status;
            data.SubStatus = lead.Sub_Estado__c;
            data.LeadId = lead.Id;

            data.FechaEntrevista = lead.Fecha_Entrevista__c;
          //  data.HoraEntrevista = lead.Hora_Entrevista__c;
          //concatenar fecha y hora
            data.Reprogramacion = lead.Reprogramacion__c;
            data.LastModifiedDate = lead.LastModifiedDate;
            data.CreatedDate = lead.CreatedDate;
            data.OwnerId = lead.OwnerId;

            listaOut.add(data);

            cont++;
        }

        system.debug('@@@@listaOut.size '+listaOut.size());


        return listaOut;
    }

    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getLeads_Filter_Owner(String OwnerId, String CampaignId, String RutCliente, String Estado, String SubEstado, String NombreCliente, Date CreatedDate, Date LastModifiedDate, Date FechaEntrevista, Date Reprogramacion, String NombreBase, String TipoBase, String TipoLink)
    {
        List<Wrapper> listaOut = new List<Wrapper>();

        String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Lead_RecordTypeId);


        String query = '';

        if (String.isBlank(CampaignId))
        {
            query = 'SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE RecordTypeId =\''+ Lead_RecordTypeId+'\' AND OwnerId = \''+ OwnerId +'\' AND ( Status = \'Abierto\' OR Status = \'En Proceso\' OR Status = \'Habilitado\' OR Status = \'No Calificado\' OR Status = \'No Interesado\') ';
        }
        else if (String.isNotBlank(CampaignId))
        {
            Set<Id> keys = new Set<Id>();

            List<CampaignMember> miembros = [SELECT Id, LeadId FROM CampaignMember WHERE CampaignId =: CampaignId AND LeadId != null];

            for (CampaignMember cm : miembros)
            {
                keys.add(cm.LeadId);
            }

            query = 'SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE RecordTypeId =\''+ Lead_RecordTypeId+'\' AND OwnerId = \''+ OwnerId +'\' AND ( Status = \'Abierto\' OR Status = \'En Proceso\' OR Status = \'Habilitado\' OR Status = \'No Calificado\' OR Status = \'No Interesado\') AND Id IN: keys';
        }

        if (String.isNotBlank(RutCliente)) {
            String key = '\'%' + RutCliente + '%\'';
            query += ' AND RUT_DV__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(Estado)) {
            String key = '\'%' + Estado + '%\'';
            query += ' AND Status  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(SubEstado)) {
            String key = '\'%' + SubEstado + '%\'';
            query += ' AND Sub_Estado__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(NombreCliente)) {
            String key = '\'%' + NombreCliente + '%\'';
            query += ' AND Name  LIKE '+key+ ' ';
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

        if (FechaEntrevista != null) {

            DateTime startDate = datetime.newInstance(FechaEntrevista.year(), FechaEntrevista.month(), FechaEntrevista.day(),0,0,0);

            DateTime endDate = datetime.newInstance(FechaEntrevista.year(), FechaEntrevista.month(), FechaEntrevista.day(),23,59,59);

            String key = ' AND Fecha_Entrevista__c >= '+ startDate.format('yyyy-MM-dd') +' AND Fecha_Entrevista__c <=' + endDate.format('yyyy-MM-dd');
            query =  query + key ;
        }

        if (Reprogramacion != null) {

            DateTime startDate = datetime.newInstance(Reprogramacion.year(), Reprogramacion.month(), Reprogramacion.day(),0,0,0);

            DateTime endDate = datetime.newInstance(Reprogramacion.year(), Reprogramacion.month(), Reprogramacion.day(),23,59,59);

            String key = ' AND Reprogramacion__c >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND Reprogramacion__c <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            query =  query + key ;
        }

        if (String.isNotBlank(NombreBase)) {
            String key = '\'%' + NombreBase + '%\'';
            query += ' AND Nombre_Base__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(TipoBase)) {
            String key = '\'%' + TipoBase + '%\'';
            query += ' AND Tipo_Base__c  LIKE '+key+ ' ';
        }

        if (String.isNotBlank(TipoLink)) {
            String key = '\'%' + TipoLink + '%\'';
            query += ' AND Tipo_Link__c  LIKE '+key+ ' ';
        }

        query += ' ORDER BY LastModifiedDate DESC LIMIT 2000';//2000 registros maximos

        system.debug('@@@@ QUERY  -->  '+query);

        List<Lead> leads = Database.query(query);

        Wrapper data;

        for (Lead lead : leads)
        {
            data = new Wrapper();
            if (lead.CampaignMembers.size() > 0)
            {
                data.CampaignId = lead.CampaignMembers[0].CampaignId;
                data.CampaignName = lead.CampaignMembers[0].Campaign.Name;
            }
            data.LeadName = lead.Name;
            data.LeadRUT = lead.PROSP_Carga_RUT__c;
            data.LeadRUT_DV = lead.PROSP_Carga_RUT__c+'-'+lead.DV__c;
            data.NombreBase = lead.Nombre_Base__c;
            data.TipoBase = lead.Tipo_Base__c;
            data.TipoLink = lead.Tipo_Link__c;
            data.OwnerName = lead.Owner.Name;
            data.Status = lead.Status;
            data.SubStatus = lead.Sub_Estado__c;
            data.LeadId = lead.Id;

            if (lead.Fecha_Entrevista__c != null && lead.Hora_Entrevista__c  != null)
            {
                DateTime fechaEnt = datetime.newInstance(lead.Fecha_Entrevista__c.year(), lead.Fecha_Entrevista__c.month(), lead.Fecha_Entrevista__c.day(),
                lead.Hora_Entrevista__c.hour(), lead.Hora_Entrevista__c.minute(), lead.Hora_Entrevista__c.second());

                data.FechaEntrevista = fechaEnt;
            }
            data.Reprogramacion = lead.Reprogramacion__c;
            data.LastModifiedDate = lead.LastModifiedDate;
            data.CreatedDate = lead.CreatedDate;
            data.OwnerId = lead.OwnerId;

            if (String.isBlank(CampaignId) || (String.isNotBlank(CampaignId) && lead.CampaignMembers.size() > 0))
            {
                listaOut.add(data);
            }
        }

        system.debug('@@@@ listaOut.size()  -->  '+listaOut.size());

        return listaOut;
    }


    @AuraEnabled(cacheable=true)
    public static List<Wrapper> getLeads_CallRemembers_Owner(String OwnerId) {
        List<Wrapper> listaOut = new List<Wrapper>();

        String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Lead_RecordTypeId);

        Date dToday = Date.today();

        DateTime startDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),0,0,0);

        DateTime endDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),23,59,59);

        String query = 'SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, PROSP_Carga_RUT__c, DV__c, RUT_DV__c, OwnerId,  Owner.Name, (SELECT Id, CampaignId, Campaign.Name FROM CampaignMembers LIMIT 1), LastModifiedDate, CreatedDate FROM Lead WHERE (Status = \'Abierto\'  OR Status = \'En Proceso\') AND RecordTypeId =\''+ Lead_RecordTypeId+'\' AND OwnerId = \''+ OwnerId +'\' AND Reprogramacion__c >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND Reprogramacion__c <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' ORDER BY Reprogramacion__c ASC LIMIT 1000';

        system.debug('@@@@ QUERY  -->  '+query);

        List<Lead> leads = Database.query(query);

        Wrapper data;

        for (Lead lead : leads)
        {
            data = new Wrapper();
            if (lead.CampaignMembers.size() > 0)
            {
                data.CampaignId = lead.CampaignMembers[0].CampaignId;
                data.CampaignName = lead.CampaignMembers[0].Campaign.Name;
            }
            data.LeadName = lead.Name;
            data.LeadRUT = lead.PROSP_Carga_RUT__c;
            data.LeadRUT_DV = lead.PROSP_Carga_RUT__c+'-'+lead.DV__c;
            data.NombreBase = lead.Nombre_Base__c;
            data.TipoBase = lead.Tipo_Base__c;
            data.TipoLink = lead.Tipo_Link__c;
            data.OwnerName = lead.Owner.Name;
            data.Status = lead.Status;
            data.SubStatus = lead.Sub_Estado__c;
            data.LeadId = lead.Id;
            if (lead.Fecha_Entrevista__c != null && lead.Hora_Entrevista__c  != null)
            {
                DateTime fechaEnt = datetime.newInstance(lead.Fecha_Entrevista__c.year(), lead.Fecha_Entrevista__c.month(), lead.Fecha_Entrevista__c.day(),
                lead.Hora_Entrevista__c.hour(), lead.Hora_Entrevista__c.minute(), lead.Hora_Entrevista__c.second());

               data.FechaEntrevista = fechaEnt;
            }
            data.Reprogramacion = lead.Reprogramacion__c;
            data.LastModifiedDate = lead.LastModifiedDate;
            data.CreatedDate = lead.CreatedDate;
            data.OwnerId = lead.OwnerId;

            listaout.add(data);
        }

        system.debug('@@@@ listaOut.size()  -->  '+listaOut.size());

        return listaOut;

    }

    @AuraEnabled(cacheable=true)
    public static List<WrapperTask> getLeads_CallTask_Remembers_Owner(String OwnerId) {

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Task_RecordTypeId);

        Date dToday = Date.today();

        DateTime startDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),0,0,0);

        DateTime endDate = datetime.newInstance(dToday.year(), dToday.month(), dToday.day(),23,59,59);

        String query = 'SELECT Id, RecordTypeId, WhoId, WhatId, WhoCount, WhatCount, Subject, ActivityDate, Status, Priority, OwnerId, Description, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId,  Rut__c, Rut_Cuenta__c,  TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, TASK_RUT_Ejecutivo_Televenta__c, TASK_Sub_Estado__c, Dias_Atraso__c, TASK_Id_Unico_Actividad__c, Fecha_Hora_Actividad__c, Tema_de_Actividad__c,  Rut_Ejecutivo_Televentas__c, Last_Assigned_Owner__c, Telefono__c, Account.Name, Account.RUT__c, Account.DV__c, Account.Rut_con_dv__c, Owner.Name, What.Name , TASK_Campana__r.Name FROM Task WHERE (Subject = \'Realizar Llamada\') AND (Status = \'Abierta\' OR  Status = \'En Curso\') AND RecordTypeId =\''+ Task_RecordTypeId+'\' AND OwnerId = \''+ OwnerId +'\' AND ReminderDateTime >= '+ startDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' AND ReminderDateTime <=' + endDate.formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +' ORDER BY ReminderDateTime ASC LIMIT 1000';

        system.debug('query---'+query);

        List<Task> tasks = Database.query(query);

        List<WrapperTask> listaOut = new List<WrapperTask>();
        WrapperTask data = null;

        List<String> leadsId = new  List<String>();

        system.debug('tasks.size ---'+tasks.size());
        for (Task task : tasks)
        {
            data = new WrapperTask();
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

        for(WrapperTask wrp : listaOut)
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

    @AuraEnabled
    public static Boolean changeStatusLeads(List<String> Ids, String Status, String SubStatus)
    {
        try
        {
            system.debug('@@@@  leads --> '+Ids.size());

            List<Lead> updLeads = [SELECT Id, Status, Sub_Estado__c FROM Lead WHERE Id IN : Ids];

            for(Lead lead: updLeads)
            {
                lead.Status = Status;
                lead.Sub_Estado__c = SubStatus;
            }

            update updLeads;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }

    @AuraEnabled
    public static Boolean cierreAdministrativoLeads(List<String> Ids)
    {
        try
        {
            system.debug('@@@@  leads --> '+Ids.size());

            List<Lead> updLeads = [SELECT Id, Status, Sub_Estado__c FROM Lead WHERE Id IN : Ids];

            for(Lead lead: updLeads)
            {
                lead.Status = 'Cierre Administrativo';
                lead.Sub_Estado__c = 'Cierre Administrativo';
            }

            update updLeads;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }


}