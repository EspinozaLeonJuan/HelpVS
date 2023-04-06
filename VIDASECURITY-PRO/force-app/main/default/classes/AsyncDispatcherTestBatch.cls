@IsTest()
global class AsyncDispatcherTestBatch implements Database.Batchable<sObject>{
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator('SELECT Id, Name FROM Account LIMIT 1');
	}
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		Account[] accounts = (Account[])scope;
		for (Account account : accounts)
		account.Name = 'batch';
		update accounts;
    	}
	global void finish(Database.BatchableContext BC){
	}
}