/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-28-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-28-2020   Juan Espinoza León   Initial Version
**/
public  class CLS_TV_GestionCarga {
    public CLS_TV_GestionCarga() {

    }

    public static void RefreshCargaTeleventa(String Id, Integer totalCarga, Integer totalError, Integer totalOk, Integer totalMC)
    {
        try
        {
            Carga_Televenta__c carga = [SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c  FROM Carga_Televenta__c WHERE Id=: Id];
        
            if (totalCarga != null) carga.Total_Registros_Carga__c = totalCarga;
            if (totalOk != null) carga.Total_Registros_Ok__c = totalOk;
            if (totalError != null) carga.Total_Registros_Error__c = totalError;
            if (totalMC != null) carga.Total_Prospectos_Ok__c = totalMC;

            update carga;
        }
        catch (Exception e)
        {
            system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
        }

    }
}