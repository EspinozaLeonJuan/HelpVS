/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-06-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_OPP_GestionLinks {

    @AuraEnabled
    public static Boolean SaveMessageToAgente(String Id, String Titulo, String Mensaje)
    {
        try
        {
            Opportunity op = [SELECT Id, StageName, Nota_a_Agente__c, Titulo_Nota_a_Agente__c FROM Opportunity WHERE Id =: Id];
            op.Titulo_Nota_a_Agente__c = Titulo;
            op.Nota_a_Agente__c = Mensaje;
            update op;
            return true;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ ex);
        }

        return false;
    }


}