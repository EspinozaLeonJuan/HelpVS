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
* @version   1.0    15/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class PolizaAsignaAgente {

    public static string getCorredor( Poliza__c polizaNew, Set<String> codigos ){
		if( polizaNew.Codigo_Agente__c != null && !codigos.contains( polizaNew.Codigo_Agente__c ) ){
			return polizaNew.Codigo_Agente__c;
		}
		return '';
	}

	public static void execute( Poliza__c polizaNew, Map<String, Contact> agenteMap ){
		Contact agente = new Contact();
		if( agenteMap.containsKey( polizaNew.Codigo_Agente__c ) ){
			agente = agenteMap.get( polizaNew.Codigo_Agente__c );
		}else{
			return;
		}
		
		if( polizaNew.Agente_Actual__c != agente.Id){
			polizaNew.Agente_Actual__c = agente.Id;
		}
	}
}