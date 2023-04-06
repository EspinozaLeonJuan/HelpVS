/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-08-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_OPP_NotificacionManualLink {

    @AuraEnabled
    public static Boolean SendEmail(String Id)
    {
        try
        {
            Opportunity op = [SELECT Id, StageName FROM Opportunity WHERE Id =: Id];

           // if (op.StageName == 'Asignación')
           // {
            CLS_LINK_Notificacion.envioCorreo(Id);
            return true;
            //}
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ ex);
        }

        return false;
    }

    @AuraEnabled
    public static Boolean SendEmail_Cliente(String Id)
    {
        try
        {
            Opportunity op = [SELECT Id, StageName FROM Opportunity WHERE Id =: Id];

           // if (op.StageName == 'Asignación')
            //{
            CLS_LINK_Notificacion.envioCorreo_Cliente(Id);
            return true;
            //}
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ ex);
        }

        return false;
    }
}