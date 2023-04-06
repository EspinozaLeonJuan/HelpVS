/*******************************************************************************************
 *  NOMBRE                 : PolizaCampanaBienvenida
 *  TIPO                   : CLASE APEX
 *  REQUERIMIENTO          : Asigna Producto masiva
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 14/10/2021 - J. GÓMEZ       - Se asignan productos de forma masiva
 * *****************************************************************************************/
public class PolizaAsignaProducto {
    
    public static void execute(Poliza__c polizaNew, Id recordTypeMasivos, Id recordTypePf, Set<String> codigosMasivos, Set<String> codigosPF) {
        if( polizaNew.Codigo_de_Producto__c != null && codigosPF.contains( polizaNew.Codigo_de_Producto__c )) {
            polizaNew.RecordTypeId = recordTypePf;         
        } 
        if( polizaNew.Codigo_de_Producto__c != null && codigosMasivos.contains( polizaNew.Codigo_de_Producto__c )) {
            polizaNew.RecordTypeId = recordTypeMasivos;
        }
        return;
	}
}