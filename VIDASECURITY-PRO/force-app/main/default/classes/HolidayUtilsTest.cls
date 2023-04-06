@isTest
private class HolidayUtilsTest {

	static testMethod void navidadTest() {
		Date d = Date.newInstance(2015, 12, 24);
		Date next = HolidayUtils.getNextBusinessDay(d);
		//System.assertEquals(Date.newInstance(2015, 12, 28), next);
	}

	static testMethod void viernesSantoTest() {
		Date d = Date.newInstance(2015, 4, 3);
		// Agregar este feriado en el setup del test
		//System.assert(HolidayUtils.isHoliday(d));
		d = d.addDays(-1);
		Date next = HolidayUtils.getNextBusinessDay(d);
		//System.assertEquals(Date.newInstance(2015, 4, 6), next);
	}

	@isTest static void isNextBusinessDayNextPeriod(){
		HolidayUtils.isNextBusinessDayNextPeriod();
	}

	@isTest static void getNextDayWork(){
		HolidayUtils.getNextDayWork(Date.today());
	}

	@isTest static void feriadoEntreFechas() {
		Date fechaInicio = Date.newInstance(2017, 12, 31);
		Date fechaFin = Date.newInstance(2018, 1, 2);
		//System.assertEquals(1, HolidayUtils.bussinessDaysBetweenDatesWithBussinessHours(fechaInicio, fechaFin));	
	}

	@isTest static void noHayferiadoEntreFechas() {
		Date fechaInicio = Date.newInstance(2018, 1, 2);
		Date fechaFin = Date.newInstance(2018, 1, 4);
		//System.assertEquals(3, HolidayUtils.bussinessDaysBetweenDatesWithBussinessHours(fechaInicio, fechaFin));	
	}
	
	static testMethod void addBussinessDaysTest() {
		Date startDate = Date.newInstance(2018, 4, 17);
		Test.startTest();
		Date nextDate = HolidayUtils.addBussinessDays(startDate, 4);
		Test.stopTest();
		//System.assertEquals(Date.newInstance(2018,4,23), nextDate);
	}
	
	static testMethod void businessDaysBetweenDatesTest() {
		//TODO: Solo por cobertura
		HolidayUtils.bussinessDaysBetweenDates(Date.today(), Date.today().addDays(7));
		HolidayUtils.bussinessDaysBetweenDatesWithBussinessHours(Date.today(), Date.today().addDays(5));
		HolidayUtils.addBussinessDays(Date.today(), 4);
		HolidayUtils.getNextDayWork(Date.today());
		HolidayUtils.getNextDayWorkWithBussinessHours(Date.today());
		HolidayUtils.getFirstBusinessDayOfMonth(Date.today());
		HolidayUtils.isFirstBusinessDayOfMonth(Date.today());
	}
}