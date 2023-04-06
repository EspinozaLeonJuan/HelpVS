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
* @version   1.0    27/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public with sharing class UtilityClass {
	/**
	* @description Gets the type name of the SObject.
	* @param SObject The SObject for which the name to be obtained.
	* @return String - The type name.
	*/
	public static String getSObjectTypeName(SObject so) {
		return so.getSObjectType().getDescribe().getName();
	}
    /**
	* @description Get Metadata TriggersSettings__mdt
	* @return Map<String,TriggersSettings__mdt>
	*/
	public static Map<String,TriggersSettings__mdt> getTriggerSettings() {
		return TriggersSettings__mdt.getAll();
	}
	/**
    * @description Get Type of the Field
    * @param String The Object Name
    * @param String The Field Name
    */
    public static String getType(String sobjectname, String fieldApiName){
        return Schema.getGlobalDescribe().get(sobjectname).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getType().name().toupperCase();
    }
	/**
    * @description Get Id of the sObject and recordTypeLabe
    * @param String sobjectName
    * @param String recordTypeLabe
    */
    public static String getRecordTypeId(String sobjectName, String recordTypeLabel){
        return Schema.getGlobalDescribe().get(sobjectName).getDescribe().getRecordTypeInfosByName().get(recordTypeLabel).getRecordTypeId();
    }
	/**
	* @description Get Metadata Switch_new_functions__mdt
	* @return Map<String,Switch_new_functions__mdt>
	*/
	public static Map<String,Switch_new_functions__mdt> getSwitchNewFunctions() { return Switch_new_functions__mdt.getAll(); }
	/**
	* @description Validate Metadata Switch_new_functions__mdt
	* @return Map<String,Switch_new_functions__mdt>
	*/
	public static Boolean validateSwitchNewFunctions(String sName, Map<String,Switch_new_functions__mdt> mSwitch ) {
		sName = ( Test.isRunningTest() ? SwitchTest.sNameMetadata : sName );
		if( mSwitch.containsKey( sName ) ){ return mSwitch.get( sName ).Activate__c; } return false;
	}
	/**
	* @description Validate Schedule Name
	* @return Boolean
	*/
	public static Boolean validateScheduleName(String jobName) {
        Map<Id,CronTrigger> mCron = new Map<Id,CronTrigger>([SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.JobType = '7' ORDER BY CreatedDate  DESC LIMIT 10]);
        if ( jobName != null && !mCron.isEmpty() ){
          for( String skey : mCron.keyset() ){
              CronTrigger oCronTrigger = mCron.get(skey);
              if ( oCronTrigger != null && jobName != null && oCronTrigger.CronJobDetailId != null ) {
                try {
                  if( jobName.contains( oCronTrigger.CronJobDetail.Name ) ){
                    return true;
                  }
                } catch(Exception e) {
                    System.debug('An exception occurred: ' + e.getMessage());
                    return true; 
                }
              }
          }
        } else { return true; } return false;
    }
}