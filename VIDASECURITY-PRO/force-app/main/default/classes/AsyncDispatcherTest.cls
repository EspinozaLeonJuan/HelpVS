@IsTest()
private class AsyncDispatcherTest {

	private class AsyncDispatcherTestQueue implements Queueable {
		public void execute(QueueableContext context) {

		}
	}

	private class AsyncDispatcherTestFuture implements Futurable {
		public void execute(Boolean async) {

		}
	}


    private static final Log log = new Log(AsyncDispatcherTest.class);
/*
    static testMethod void futureCallTest(){
        Test.startTest();
        log.debug('Iniciando test!');
        insert new Log__c();
        Test.stopTest();
        log.debug('Finalizando test!');
        //System.assertEquals(AsyncDispatcher.countFutureCallAsyncCalled, 1);
        //System.assertEquals(AsyncDispatcher.countFutureCallSyncCalled, 0);
    }
    */

	static testMethod void queueTest() {
		AsyncDispatcher.execute(new AsyncDispatcherTestQueue());
	}

	static testMethod void futureTest() {
		AsyncDispatcher.execute(new AsyncDispatcherTestFuture());
			}


	static testMethod void batchTest() {
		AsyncDispatcher.execute(new AsyncDispatcherTestBatch());
			}


}