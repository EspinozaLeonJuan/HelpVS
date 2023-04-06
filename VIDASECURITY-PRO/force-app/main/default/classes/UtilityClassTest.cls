/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      Clase de prueba para la clase DataFactoryService
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    13/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest (seealldata=false)
private class UtilityClassTest {

    @isTest static void testGetSObjectTypeName(){
        Account oAcc = new Account();
        String sName = UtilityClass.getSObjectTypeName(oAcc);
    }
    
    @isTest static void testGetTriggerSettings(){
        Map<String,TriggersSettings__mdt> mTriggerSett = UtilityClass.getTriggerSettings();
    }

    @isTest static void testGetType(){
        String sobjectname = 'Account'; 
        String fieldApiName = 'Name';
        String sType = UtilityClass.getType( sobjectname, fieldApiName);
    }

    @isTest static void testGetRecordTypeId(){
        String sobjectname = 'Account'; 
        String recordTypeLabel = 'Cuenta personal';
        String sType = UtilityClass.getRecordTypeId(sobjectName, recordTypeLabel);
    }
    
     @isTest static void validateScheduleName(){
    CronTrigger cronJob = [SELECT Id, CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType FROM CronTrigger WHERE CronJobDetail.JobType = '7' ORDER BY CreatedDate DESC LIMIT 1];
        if ( cronJob != null ) {
            Boolean value = UtilityClass.validateScheduleName(cronJob.CronJobDetail.Name);
        } 
         Boolean value2 = UtilityClass.validateScheduleName('test2');
    }
}