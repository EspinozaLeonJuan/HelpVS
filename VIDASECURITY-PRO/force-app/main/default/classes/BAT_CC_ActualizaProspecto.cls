/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-03-2020   Juan Espinoza Leon   Initial Version
**/
global class BAT_CC_ActualizaProspecto implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {   
    
    public String IdLead {get; set;}
    public String IdContactCenter {get; set;}
   
    global BAT_CC_ActualizaProspecto(String idContact) {
        this.IdContactCenter = idContact;
    }


    global Database.QueryLocator start(Database.BatchableContext bc) {       
        String query = 'SELECT Id, ProspectoCargado__c, EsCliente__c, LeadId__c, IdSalesforce__c, Nombre__c FROM Contact_Center_Log__c WHERE Id = \'' + this.IdContactCenter + '\'' ;
        
        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {

        Contact_Center_Log__c cclog;

        for (SObject sObj : scope)
        {
            cclog = (Contact_Center_Log__c)sObj;
            this.IdLead = cclog.LeadId__c;
        }

        system.debug('@@@@ cclog: ' + cclog);
        List<Lead> prospectos = [SELECT Id, FirstName, LastName, RUT__c  FROM Lead WHERE Id =: this.IdLead];
        system.debug('@@@@ prospectos: ' + prospectos);
        if (prospectos.size()>0)
        {       
            system.debug('@@@@ RUT__c  --> '+prospectos[0].RUT__c);
            OBJ_WS_ConsultaPersona persona = new OBJ_WS_ConsultaPersona();
            if(!Test.isRunningTest())
            {
                persona = EXT_WS_ConsultaPersona.DatosPersona(prospectos[0].RUT__c);
            }
            else
            {
                persona.RUT = '15045517-0';
                persona.Nombres = 'Juan';
                persona.Apellido_Paterno = 'Espinoza';
                persona.Apellido_Materno = 'Leon';
            }    
            
            system.debug('@@@@ persona'+persona);
  			system.debug('@@@@ persona'+persona);

            if (persona != null)
            {                         
                prospectos[0].FirstName = persona.Nombres;
                prospectos[0].LastName =  persona.Apellido_Paterno + ' ' + persona.Apellido_Materno;

                system.debug('@@@@ prospectos[0] -->  '+prospectos[0]);
                update prospectos[0];

                cclog.Nombre__c = prospectos[0].FirstName +' '+ prospectos[0].LastName;
                cclog.ProspectoCargado__c = true;
                update cclog;

                system.debug('@@@@ cclog.IdSalesforce__c __> '+ cclog.IdSalesforce__c);
                Case caso = [SELECT Id, Nombre_no_Cliente__c FROM Case WHERE Id =: cclog.IdSalesforce__c];

                if (caso != null)
                {
                    caso.Nombre_no_Cliente__c = cclog.Nombre__c;
                    update caso;
                }
            }   
        }              
    }

    global void finish(Database.BatchableContext bc) {
     
        try {
         
        } catch (Exception e) {
            system.debug('@@@@ finish Exception: ' + e.getMessage());
        }
    }
}