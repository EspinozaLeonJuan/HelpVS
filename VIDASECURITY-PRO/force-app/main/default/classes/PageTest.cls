@IsTest
private class PageTest {
	
	static testMethod void addInfoStringTest() {
		PageReference fooPage = new PageReference('/');
		Test.setCurrentPage(fooPage);
		String message = 'Foo';
		Test.startTest();
		PageUtils.addInfo(message);
		Test.stopTest();
		PageUtils.addInfo(message);
		System.assert(!PageUtils.hasErrors());
		System.assert(ApexPages.hasMessages(), 'El mensaje no fue agregado.');
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary(), 'El mensaje agregado es incorrecto.');
	}

	static testMethod void addErrorStringTest() {
		PageReference fooPage = new PageReference('/');
		Test.setCurrentPage(fooPage);
		String message = 'Foo';
		Test.startTest();
		PageUtils.addError(message);
		Test.stopTest();
		System.assert(ApexPages.hasMessages(), 'El mensaje no fue agregado.');
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary(), 'El mensaje agregado es incorrecto.');
	}
	
	static testMethod void addErrorExceptionTest() {
		PageReference fooPage = new PageReference('/');
		Test.setCurrentPage(fooPage);
		String message = 'Foo';
		Test.startTest();
		try {
			throw new PageUtils.PageException(message);
		} catch (Exception e) {
			PageUtils.addError(e);
		}
		Test.stopTest();
		System.assert(ApexPages.hasMessages(), 'El mensaje no fue agregado.');
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary(), 'El mensaje agregado es incorrecto.');
	}

	@IsTest
	static void hasErrorsTest(){
		PageReference fooPage = new PageReference('/');
		Test.setCurrentPage(fooPage);
		String message = 'Foo';

		Test.startTest();
		PageUtils.addError(message);
		Boolean hasErrors = PageUtils.hasErrors();
		Test.stopTest();

		System.assert(hasErrors, 'No se registro el error');
		System.assert(ApexPages.hasMessages(), 'El mensaje no fue agregado.');
	}
}