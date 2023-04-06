/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-23-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-09-2021   Juan Espinoza León   Initial Version
**/
global class CLS_LINK_Ranking Implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        Date fecha = System.today();
        Date fechaConsultaLinks = System.today();
        Parametros_Vida_Security__c parametros =  Parametros_Vida_Security__c.getOrgDefaults();
        
        if (Test.isRunningTest())
        {
        	parametros.Dias_Ranking_Links__c = '1';    
        }
        
        if(Integer.valueOf(parametros.Dias_Ranking_Links__c) > 0)
        {
            Integer value = Integer.valueOf(parametros.Dias_Ranking_Links__c) * -1;
            fechaConsultaLinks.addDays(value);
        }

        CLS_LINK_GestionRanking.GestionarLinks(fecha, fechaConsultaLinks);
    }
}