/*******************************************************************************************
 *  NOMBRE                 : PolizaCampanaBienvenida
 *  TIPO                   : CLASE APEX
 *  REQUERIMIENTO          : Asignacion de oportunidad masiva
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 14/10/2021 - J. GÓMEZ        - Se asignan oportunidades de forma masiva
 *  1.2     - 14/10/2021 - Javier Tibamoza - Elimine el implement del HandlerInterface y el método handler
 * *****************************************************************************************/
public class PolizaOportunidades {
	public static void execute(List<Poliza__c> lstPoliza) { 
        List<String> idCuentas = new List<String>();
        List<String> recordTypes = new List<String>();       
        List<Poliza__c> polizas = new  List<Poliza__c>();
        List<Poliza__c> actualizarPolizas = new List<Poliza__c>();
        List<Opportunity> actualizarOportunidades = new List<Opportunity>();
        recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').recordtypeid);
        recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').recordtypeid);
        Id LinkRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').recordtypeid;
                
        if(!lstPoliza.isEmpty()) {
            for(Poliza__c poliza : [SELECT Id, Cuenta__c, VSL_Venta__c, Name FROM Poliza__c WHERE Id IN: lstPoliza and RecordTypeId IN :recordTypes]){
                polizas.add(poliza);                           
                idCuentas.add(poliza.Cuenta__c); 
            }
            
            List<Opportunity> oportunidades = [
                SELECT id, AccountId, StageName, CloseDate 
                FROM Opportunity 
                WHERE AccountId IN: idCuentas 
                AND StageName != 'Cerrada Perdida Link' 
                AND RecordTypeId =: LinkRecordType];
            
            for( Poliza__c poliza : polizas ){               
                for(Opportunity oportunidad : oportunidades){                
                    if(poliza.Cuenta__c == oportunidad.AccountId){
                        poliza.VSL_Venta__c = oportunidad.Id; 
                        System.debug(poliza);
                        actualizarPolizas.add(poliza);
                        if(oportunidad.StageName != 'Cerrada Ganada Link'){
                            oportunidad.StageName = 'Cerrada Ganada Link';
                            oportunidad.CloseDate = system.today();
                            actualizarOportunidades.add(oportunidad); 
                        }     
                        break;                                            
                    }                   
                }            
            }                
            if(actualizarPolizas.size() > 0){
                update actualizarPolizas;  
            }
            if(actualizarOportunidades.size() > 0){
                update actualizarOportunidades;
            } 
       } 
    }
}