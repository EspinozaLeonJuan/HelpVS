/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 01-28-2022
 * @last modified by  : Juan Espinoza León
**/
global class BAT_CM_Validacion_Propuesta implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public String IdOportunidad {get; set;}

    public BAT_CM_Validacion_Propuesta(string idOpp)
    {
        this.IdOportunidad = idOpp;
        system.debug('@@@@ this.IdOportunidad: ' + this.IdOportunidad);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {

        String query =  'SELECT Id, OPOR_WS_Actualiza_Datos_Prospecto__c FROM Opportunity WHERE Id = \'' + String.escapeSingleQuotes(this.IdOportunidad) + '\'';

         system.debug('@@@@ query: ' + query);

         return Database.getQueryLocator(query);
     }

     global void execute(Database.BatchableContext bc, List<Opportunity> propuestas) {

        string usuario = [SELECT Id,  Name, RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c;
        EXT_WS_CM_Oncologico.validarPropuesta(usuario, propuestas[0].Id); // intento 2
    }

    global void finish(Database.BatchableContext bc) {

        system.debug('@@@@@ Ha finalizado trabajo actualizacion de propuesta...');
    }
}