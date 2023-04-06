@isTest(SeeAllData = false)
private class DecimalOutputTextControllerTest {
	
	static testMethod void formatingNumberWith4Decimals() {
		DecimalOutputTextController dotc = new DecimalOutputTextController();
		dotc.valueNotFormatted = 102.0203000;
		dotc.numberDecimalValue = 4;
		dotc.isTrailingZeros = true;
		System.assertEquals(dotc.valueFormatted, '102,0203');
	}
	
	static testMethod void formatingNullValue() {
		DecimalOutputTextController dotc = new DecimalOutputTextController();
		dotc.valueNotFormatted = null;
		dotc.numberDecimalValue = null;
		dotc.isTrailingZeros = true;
		System.assertEquals(dotc.valueFormatted, '--');
	}
	
}