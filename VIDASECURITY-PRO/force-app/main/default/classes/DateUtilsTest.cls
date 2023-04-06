@isTest
private class DateUtilsTest{

	static testMethod void itShouldToDatetime(){
		Date d = Date.newInstance(2017, 7, 5);
		Datetime dt = DateUtils.toDatetime(d);
	}

	static testMethod void itShouldCalculateTimeBetweenInHours(){
		DateTime d1 = DateTime.newInstance(2017, 2, 1);
		DateTime d2 = DateTime.newInstance(2017, 2, 20);
		Decimal time1 = DateUtils.calculateTimeBetweenInHours(d2, d1);
		System.assertEquals(456.0, time1);
	}

	static testMethod void itShouldFormatDate(){
		Date d = Date.newInstance(2017, 7, 5);
		String formatedDate = DateUtils.format(d);
		String formatedDate2 = DateUtils.format(d, 'yyyy-MM-dd');
		System.assertEquals('20170705', formatedDate);
		System.assertEquals('2017-07-05', formatedDate2);
	}

	static testMethod void itShouldGetPeriod(){
		Datetime dt = Datetime.newInstance(2017, 1, 2);
		String period = DateUtils.getPeriod(dt);
		System.assertEquals('201701', period);
	}

	static testMethod void itShouldDaysBetweenExcludingWeekends(){
		DateTime d1 = DateTime.newInstance(2017, 2, 1);
		DateTime d2 = DateTime.newInstance(2017, 2, 20);
		Integer days = DateUtils.daysBetweenExcludingWeekends(d1, d2);
		System.assertEquals(13, days);
	}

	static testMethod void itShouldParseDate() {
		Date d = DateUtils.parse('20160301', 'yyyyMMdd');
		System.assertEquals(d.year(), 2016);
		System.assertEquals(d.month(), 3);
		System.assertEquals(d.day(), 1);
	}

	static testMethod void itShouldGetPeriodDescription(){
		String description = DateUtils.getPeriodDescription('201603');
		System.assertEquals(description, 'Marzo 2016');
	}

	static testMethod void itShouldFormatDateWithDefaultFormat(){
		Date d = Date.newInstance(2016, 3, 1);
		String dateFormated = DateUtils.formatDate(d);
		System.assertEquals(dateFormated, '01-03-2016');
	}

	static testMethod void itShouldFormatDateYearFirst(){
		Date d = Date.newInstance(2016, 3, 1);
		String dateFormated = DateUtils.formatDateYearFirst(d);
		System.assertEquals(dateFormated, '2016-03-01');
	}

	static testMethod void getMonthTest() {
		Date value = Date.newInstance(2016,1,1);
		System.assertEquals('Enero', DateUtils.getMonth(value), 'La fecha no coincide');
		System.assertEquals(null, DateUtils.getMonth(null), 'La fecha no coincide');
	}

	static testMethod void getWeek() {
		Date value = Date.newInstance(2016, 12, 8);
		System.assertEquals(5, value.toStartOfWeek().day(), 'EL día no coincide');
		value = Date.newInstance(2017, 1, 1);
		System.assertEquals(1, DateUtils.getWeek(value), 'El número de la semana no coincide');
		value = Date.newInstance(2017, 1, 4);
		System.assertEquals(2, DateUtils.getWeek(value), 'El número de la semana no coincide');
		value = Date.newInstance(2017, 1, 30);
		System.assertEquals(6, DateUtils.getWeek(value), 'El número de la semana no coincide');
		value = Date.newInstance(2017, 2, 6);
		System.assertEquals(7, DateUtils.getWeek(value), 'El número de la semana no coincide');
		value = Date.newInstance(2016, 12, 31);
		System.assertEquals(53, DateUtils.getWeek(value), 'El número de la semana no coincide');
		System.assertEquals(null, DateUtils.getWeek(null), 'El número de la semana no coincide');
	}

	static testMethod void getInicioDeSemanaTest() {
		Date inicio = DateUtils.getInicioDeSemana(1, 2017);
		System.assertEquals(1, inicio.day(), 'El dia de inicio es incorrecto');
		System.assertEquals(1, inicio.month(), 'El mes de inicio es incorrecto');
		System.assertEquals(2017, inicio.year(), 'El año de inicio es incorrecto');

		inicio = DateUtils.getInicioDeSemana(2, 2017);
		System.assertEquals(2, inicio.day(), 'El dia de inicio es incorrecto');
		System.assertEquals(1, inicio.month(), 'El mes de inicio es incorrecto');
		System.assertEquals(2017, inicio.year(), 'El año de inicio es incorrecto');


		inicio = DateUtils.getInicioDeSemana(3, 2017);
		System.assertEquals(9, inicio.day(), 'El dia de inicio es incorrecto');
		System.assertEquals(1, inicio.month(), 'El mes de inicio es incorrecto');
		System.assertEquals(2017, inicio.year(), 'El año de inicio es incorrecto');
	}

	static testMethod void getFinalDeSemanaTest() {
		Date fin = DateUtils.getFinalDeSemana(1, 2017);
		System.assertEquals(1, fin.day(), 'El dia de fin es incorrecto');
		System.assertEquals(1, fin.month(), 'El mes de fin es incorrecto');
		System.assertEquals(2017, fin.year(), 'El año de fin es incorrecto');

		fin = DateUtils.getFinalDeSemana(2, 2017);
		System.assertEquals(8, fin.day(), 'El dia de fin es incorrecto');
		System.assertEquals(1, fin.month(), 'El mes de fin es incorrecto');
		System.assertEquals(2017, fin.year(), 'El año de fin es incorrecto');


		fin = DateUtils.getFinalDeSemana(3, 2017);
		System.assertEquals(15, fin.day(), 'El dia de fin es incorrecto');
		System.assertEquals(1, fin.month(), 'El mes de fin es incorrecto');
		System.assertEquals(2017, fin.year(), 'El año de fin es incorrecto');
	}


	static testMethod void getInicioDeMesTest() {
		Date fecha = DateUtils.getInicioDeMes('Agosto', 2017);
		System.assertEquals(1, fecha.day(), 'El dia de fin es incorrecto');
		System.assertEquals(8, fecha.month(), 'El mes de fin es incorrecto');
		System.assertEquals(2017, fecha.year(), 'El año de fin es incorrecto');
		System.assertEquals(null, DateUtils.getInicioDeMes('asa', 2004));
	}


	static testMethod void getFinalDeMesTest() {
		Date fecha = DateUtils.getFinalDeMes('Agosto', 2017);
		System.assertEquals(31, fecha.day(), 'El dia de fin es incorrecto');
		System.assertEquals(8, fecha.month(), 'El mes de fin es incorrecto');
		System.assertEquals(2017, fecha.year(), 'El año de fin es incorrecto');
		System.assertEquals(null, DateUtils.getFinalDeMes('asa', 2004));
	}

	static testMethod void formatPeriodTest() {
		String period = DateUtils.formatPeriod(Datetime.newInstance(2017,1,1,0,0,0));
		System.assertEquals('201701', period);
		period = DateUtils.formatPeriod((Datetime)null);
		System.assertEquals(null, period);

		period = DateUtils.formatPeriod(Date.newInstance(2017,1,1));
		System.assertEquals('201701', period);
		period = DateUtils.formatPeriod((Date)null);
		System.assertEquals(null, period);
	}

	static testMethod void itShouldTestTrimester(){
		System.assertEquals('1', DateUtils.getTrimester(Date.newInstance(2017, 1, 1)));
		System.assertEquals('1', DateUtils.getTrimester(Date.newInstance(2017, 1, 31)));
		System.assertEquals('1', DateUtils.getTrimester(Date.newInstance(2017, 2, 1)));
		System.assertEquals('1', DateUtils.getTrimester(Date.newInstance(2017, 3, 20)));

		System.assertEquals('2', DateUtils.getTrimester(Date.newInstance(2017, 4, 30)));
		System.assertEquals('2', DateUtils.getTrimester(Date.newInstance(2017, 5, 1)));
		System.assertEquals('2', DateUtils.getTrimester(Date.newInstance(2017, 6, 20)));

		System.assertEquals('3', DateUtils.getTrimester(Date.newInstance(2017, 7, 30)));
		System.assertEquals('3', DateUtils.getTrimester(Date.newInstance(2017, 8, 1)));
		System.assertEquals('3', DateUtils.getTrimester(Date.newInstance(2017, 9, 20)));

		System.assertEquals('4', DateUtils.getTrimester(Date.newInstance(2017, 10, 30)));
		System.assertEquals('4', DateUtils.getTrimester(Date.newInstance(2017, 11, 1)));
		System.assertEquals('4', DateUtils.getTrimester(Date.newInstance(2017, 12, 20)));
	}

	static testMethod void itShouldTestFechaInicioFechaFinTrimestre(){
		System.assertEquals(Date.newInstance(2017, 1, 1), DateUtils.getInicioTrimestre('1', 2017));
		System.assertEquals(Date.newInstance(2017, 3, 31), DateUtils.getFinTrimestre('1', 2017));

		System.assertEquals(Date.newInstance(2017, 4, 1), DateUtils.getInicioTrimestre('2', 2017));
		System.assertEquals(Date.newInstance(2017, 6, 30), DateUtils.getFinTrimestre('2', 2017));

		System.assertEquals(Date.newInstance(2017, 7, 1), DateUtils.getInicioTrimestre('3', 2017));
		System.assertEquals(Date.newInstance(2017, 9, 30), DateUtils.getFinTrimestre('3', 2017));

		System.assertEquals(Date.newInstance(2017, 10, 1), DateUtils.getInicioTrimestre('4', 2017));
		System.assertEquals(Date.newInstance(2017, 12, 31), DateUtils.getFinTrimestre('4', 2017));
	}
}