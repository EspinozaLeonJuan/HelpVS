/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 10-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-17-2021   Juan Espinoza León   Initial Version
**/
global class CLS_CM_CierreCampagnaSP Implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        Date fecha = System.today();

        String Campaign_RecordTypeId  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Salud Protegida').getRecordTypeId();

        List<Campaign> cmps = [SELECT EndDate, Id, IsActive, StartDate, Status, SystemModstamp, Type FROM Campaign WHERE Status = 'En curso' AND IsActive = true AND RecordTypeId =: Campaign_RecordTypeId AND EndDate <: fecha];
        
        system.debug('@@@@ cmps.size '+cmps.size());
        
        List<String> IdsCMPS = new List<String>();

        for (Campaign cmp : cmps)
        {
            IdsCMPS.add(cmp.Id);
            cmp.Status = 'Completada';
            cmp.IsActive = false;
        }
        
        List<CampaignMember> miembros = [SELECT Id, LeadId, Lead.Status, Lead.Sub_Estado__c FROM CampaignMember WHERE CampaignId IN : IdsCMPS AND Lead.Sub_Estado__c != 'Contratante de póliza original' 
                                         AND Lead.Sub_Estado__c != 'Asegurado' AND Lead.Sub_Estado__c != 'Molesto con la compañía' AND Lead.Sub_Estado__c != 'No Contesta, inubicable' 
                                         AND Lead.Sub_Estado__c != 'No le interesa' AND Lead.Sub_Estado__c != 'No reúne condiciones' AND Lead.Sub_Estado__c != 'No tiene medio de pago'
                                         AND Lead.Sub_Estado__c != 'Persona falleció' AND Lead.Sub_Estado__c != 'Pide no volver a llamar' AND Lead.Sub_Estado__c != 'Teléfono Malo'
                                        ];
        system.debug('@@@@ miembros '+miembros);
        
        List<String> IdsLeads = new List<String>();

        for (CampaignMember mb : miembros)
        {
            IdsLeads.add(mb.LeadId);
        }

        List<Lead> leads = [SELECT Id, Status, Sub_Estado__c, Cierre_Administrativo__c FROM Lead WHERE Id IN : IdsLeads];
        system.debug('@@@@ Lead.size '+leads.size());

        List<String> IdLeads = new List<String>();

        for (Lead ld : leads)
        {
            ld.Status = 'Cierre Administrativo';  
            ld.Sub_Estado__c = 'Cierre de campaña automático';
            ld.Cierre_Administrativo__c = true;
            IdLeads.add(ld.Id);
        }

        String Task_RecordTypeId_Task_Links  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();
        String Task_RecordTypeId_Task_Salud  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Salud Protegida').getRecordTypeId();
        String Task_RecordTypeId_Task_TV  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tareas Televenta').getRecordTypeId();


        List<Task> tasks = [SELECT Id, Status FROM Task WHERE  WhoId IN : IdLeads AND (RecordTypeId =: Task_RecordTypeId_Task_Links OR RecordTypeId =: Task_RecordTypeId_Task_Salud OR RecordTypeId =: Task_RecordTypeId_Task_TV) AND (Status = 'Abierta' OR Status = 'En curso')];

        for (Task t : tasks)
        {
            t.Status = 'Cierre Administrativo';  
        }

        system.debug('@@@@ Task.size '+tasks.size());
     
        if (tasks.size() > 0)
        {
            update tasks;
        }
        
        if (leads.size() > 0)
        {
            update leads;
        }
        
        if (cmps.size() > 0)
        {
            update cmps;
        }
      
    }
}