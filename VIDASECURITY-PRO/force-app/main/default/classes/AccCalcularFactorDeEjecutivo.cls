/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class AccCalcularFactorDeEjecutivo {
    
    public static List<Id> getNewEjecutivoIds( Account oNewCuenta, Account oOldCuenta, Set<Id> ejecutivoClienteIds, List<Id> ejecutivoIds ) {
        if( ejecutivoClienteIds.contains(oNewCuenta.OwnerId) && oNewCuenta.OwnerId != null && !ejecutivoIds.contains(oNewCuenta.OwnerId) && 
          ( oOldCuenta == null || oOldCuenta.OwnerId != oNewCuenta.OwnerId || oOldCuenta.Categoria_del_Cliente__c != oNewCuenta.Categoria_del_Cliente__c)) {
            ejecutivoIds.add( oNewCuenta.OwnerId );
        }
        return ejecutivoIds;
    }

    public static List<Id> getOldEjecutivoIds( Account oNewCuenta, Account oOldCuenta, Set<Id> ejecutivoClienteIds, List<Id> ejecutivoIds ) {
        
        if( ejecutivoClienteIds.contains(oOldCuenta.OwnerId) && oOldCuenta.OwnerId != null && !ejecutivoIds.contains(oOldCuenta.OwnerId) && 
          ( oNewCuenta == null || oNewCuenta.OwnerId != oOldCuenta.OwnerId || oNewCuenta.Categoria_del_Cliente__c != oOldCuenta.Categoria_del_Cliente__c)) {
            ejecutivoIds.add( oOldCuenta.OwnerId );
        }
        return ejecutivoIds;
    }

    public static void execute( List<Id> ejecutivoIds ) {
        CalcularFactorDeEjecutivoUtils.calcular(ejecutivoIds);
    }
}