/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-27-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_LEAD_Gestion_ProspectoSaludPro {
    @AuraEnabled
    public static Boolean RefreshData_Lead(String Id)
    {
        Boolean callOk = CLS_CM_DatosSaludProtegida.DatosSaludProtegida(Id);

        return callOk;
    }
}