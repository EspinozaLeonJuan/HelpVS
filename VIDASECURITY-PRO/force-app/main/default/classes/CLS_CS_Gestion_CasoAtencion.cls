/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 11-24-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CS_Gestion_CasoAtencion {
    public CLS_CS_Gestion_CasoAtencion() {

    }

    @AuraEnabled
    public static Boolean SaveStatusCase(String Id, String Status)
    {

        try
        {
            Case caso = [SELECT Id, Status, Sub_estado__c, Entrega_Respuesta__c FROM Case WHERE Id =: Id];

            caso.Status = Status;

            if (Status == 'Cerrado')
            {
                caso.Entrega_Respuesta__c = true;
            }
            else
            {
                caso.Entrega_Respuesta__c= false;
            }

            update caso;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }


    /**
    * @description Metodo sobrecargado para modificar estado de casos de atencion del area de televentas
    * @author Juan Espinoza León | 11-24-2021
    * @param Id
    * @param Status
    * @param SubEstado
    * @return Boolean
    **/
    @AuraEnabled
    public static Boolean SaveStatusCase(String Id, String Status, String SubEstado)
    {

        try
        {
            Case caso = [SELECT Id, Status, Sub_estado__c, Entrega_Respuesta__c FROM Case WHERE Id =: Id];

            caso.Status = Status;
            caso.Sub_estado__c = Subestado;

            if (Status == 'Cerrado')
            {
                caso.Entrega_Respuesta__c = true;
            }
            else
            {
                caso.Entrega_Respuesta__c= false;
            }

            update caso;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }

    @AuraEnabled
    public static Boolean PoseeHijos_EnProceso(String Id)
    {

        try
        {
            List<Case> cHijos = [SELECT Id, Status FROM Case WHERE (Status = 'Nuevo' OR Status = 'En Proceso' OR Status = 'Back Office' OR Status = 'En Revisión') AND ParentId =: Id];

            if (cHijos.size() > 0)
            {
                return true;
            }

            return false;
        }
        catch(Exception ex)
        {
            return false;
        }
    }
}