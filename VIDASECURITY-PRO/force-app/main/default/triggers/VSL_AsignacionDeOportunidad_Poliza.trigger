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
* @version   1.0    23/11/2021     Javier Tibamoza JATC 	       Class Updated
***********************************************************************************************************************/
trigger VSL_AsignacionDeOportunidad_Poliza on Poliza__c (after insert) {
    Map<String,Switch_new_functions__mdt> mSwitch = UtilityClass.getSwitchNewFunctions();
    if( !UtilityClass.validateSwitchNewFunctions('newTriggerFactory', mSwitch ) ) {
        if(Trigger.isInsert){
            if(Trigger.isAfter){
                        
                List<String> idCuentas = new List<String>();
                List<String> recordTypes = new List<String>();       
                List<Poliza__c> actualizarPolizas = new List<Poliza__c>();
                List<Opportunity> actualizarOportunidades = new List<Opportunity>();
                
                recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').recordtypeid);
                recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').recordtypeid);
                
                Id LinkRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').recordtypeid;
                List<Poliza__c> polizas = [select Id, Cuenta__c, VSL_Venta__c, Name from Poliza__c where Id IN :Trigger.New
                                           and RecordTypeId IN :recordTypes];
    
                if(polizas.isEmpty()) return;
    
                for(Poliza__c poliza : polizas){
                    idCuentas.add(poliza.Cuenta__c); 
                }
                
                List<Opportunity> oportunidades = [select id, AccountId, StageName, CloseDate from Opportunity where AccountId IN :idCuentas 
                                                   and StageName != 'Cerrada Perdida Link' and RecordTypeId =: LinkRecordType];
                            
                for(Poliza__c poliza : polizas){               
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
}