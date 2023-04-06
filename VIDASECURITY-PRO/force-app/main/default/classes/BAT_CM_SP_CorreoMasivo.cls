/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-22-2021   Juan Espinoza León   Initial Version
**/
global class BAT_CM_SP_CorreoMasivo  implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    
    public String IdLead {get; set;}
    
    public BAT_CM_SP_CorreoMasivo(string IdLD) {
        this.IdLead = IdLD;  
        system.debug('@@@@ this.IdLead: ' + this.IdLead);
    }


    global Database.QueryLocator start(Database.BatchableContext bc) { 
        String query =  'SELECT Id, Email, SP_Correo_Masivo__c FROM Lead WHERE Id = \'' + String.escapeSingleQuotes(this.IdLead) + '\'';

        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }
        
    global void execute(Database.BatchableContext bc, List<Lead> leads) {
        TriggerHandler.disable();

        Lead lead = leads[0];
        if (lead.Email != '')
        {
            lead.SP_Correo_Masivo__c = true;
            CLS_CM_CorreoSaludProtegida.enviarEmail(lead.Id);
            update lead;
        }        

        TriggerHandler.enable();
    }

    global void finish(Database.BatchableContext bc) {
         
        try {
         
        } catch (Exception e) {
            system.debug('@@@@ finish Exception: ' + e.getMessage());
        }
    }

    
       
}