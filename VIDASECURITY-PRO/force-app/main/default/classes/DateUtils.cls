public without sharing class DateUtils {

	public static final Map<Integer,String> monthsMap = new Map<Integer,String>{
		1 => 'Enero',
		2 => 'Febrero',
		3 => 'Marzo',
		4 => 'Abril',
		5 => 'Mayo',
		6 => 'Junio',
		7 => 'Julio',
		8 => 'Agosto',
		9 => 'Septiembre',
		10 => 'Octubre',
		11 => 'Noviembre',
		12 => 'Diciembre'
	};

	public static final Map<String, Integer> monthsReverseMap = new Map<String, Integer>{
		'Enero' => 1,
		'Febrero' => 2,
		'Marzo' => 3,
		'Abril' => 4,
		'Mayo' => 5,
		'Junio' => 6,
		'Julio' => 7,
		'Agosto' => 8,
		'Septiembre' => 9,
		'Octubre' => 10,
		'Noviembre' => 11,
		'Diciembre' => 12
	};


	public static Integer daysBetweenExcludingWeekends(Datetime startDate, Datetime endDate) {
		Integer i = 0;
		while (startDate < endDate) {
			Integer dayOfWeek = HolidayUtils.dayOfWeek(startDate.date());
			if (dayOfWeek != 5 && dayOfWeek != 6) {
				i++;
			}
			startDate = startDate.addDays(1);
		}
		return i;
	}

	public static String getPeriod(DateTime dt){
		if (dt == null)
			return null;
		return formatDate(dt.date(), 'yyyyMM');
	}

	public static String getPeriodDescription(String period){
		System.assertNotEquals(period, null, 'El periodo pasado como parametro al utilitario DateUtils.getPeriodDescription no debe ser nulo.');
		System.assertEquals(period.length(), 6, 'El periodo pasado como parametro al utilitario DateUtils.getPeriodDescription debe tener 6 caracteres con el formato YYYYMM.');
		String year = period.substring(0, 4);
		String month = period.substring(4);
		return monthsMap.get(Integer.valueOf(month)) + ' ' + year;
	}

	public static String formatDate(Date d, String format) {
		DateTime nowTime = DateTime.newInstance(d, DateTime.now().time());
		return nowTime.format(format);
	}

	public static String formatDate(Date dateV){
		return formatDate(dateV, 'dd-MM-yyyy');
	}

	public static String formatDateYearFirst(Date dateV){
		return formatDate(dateV, 'yyyy-MM-dd');
	}

	public static String formatPeriod(DateTime dt){
		if (dt == null)
		return null;
		return formatDate(dt.date(), 'yyyyMM');
	}

	public static String formatPeriod(Date d){
		if (d == null)
		return null;
		return formatDate(d, 'yyyyMM');
	}

	public static Date parse(String source, String format) {
		if (source == null || source.trim() == '') return null;
		System.assertNotEquals(null, format, 'El formato no puede ser nulo.');
		source = source.trim();
		format = format.trim();
		System.assertEquals(source.length(), format.length(), 'El largo de la fecha y el formato no coinciden. FECHA: ' + source + ' FORMATO: ' + format);
		String y='',m = '',d = '';
		for (Integer i =0; i < source.length(); i++) {
			if (format.substring(i, i+1).equals('d'))
			d += source.substring(i, i+1);
			if (format.substring(i, i+1).equals('M'))
			m += source.substring(i, i+1);
			if (format.substring(i, i+1).equals('y'))
			y += source.substring(i, i+1);
		}
		if (String.isBlank(d))
		d = '1';
		Integer day = Integer.valueOf(d);
		Integer month = Integer.valueOf(m);
		Integer year = Integer.valueOf(y);
		if (year < 1800 || year > 2500)
		return null;
		return Date.newInstance(year, month, day);
	}

	public static String replaceLast(String source, String toReplace, String replacement) {
		Integer pos = source.lastIndexOf(toReplace);
		if (pos > -1)
		return source.substring(0, pos) + replacement + source.substring(pos + toReplace.length(), source.length());
		return source;
	}

	public static String format(Integer year, Integer month, Integer day, String f) {
		if (f == null)
		return String.valueOf(year*10000 + month*100 + day);
		if (f.contains('y')) {
			String c = String.valueOf(Math.mod(year, 10));
			return format(year/10, month, day, replaceLast(f, 'y', c));
		}
		if (f.contains('M')) {
			String c = String.valueOf(Math.mod(month, 10));
			return format(year, month/10, day, replaceLast(f, 'M', c));
		}
		if (f.contains('d')) {
			String c = String.valueOf(Math.mod(day, 10));
			return format(year, month, day/10, replaceLast(f, 'd', c));
		}
		return f;
	}


	public static String format(Date source, String format) {
		if (source == null)
		source = Date.today();
		System.assertNotEquals(null, source, 'La fecha no puede ser nula');
		return format(source.year(), source.month(), source.day(), format);
	}

	public static String format(Date d) {
		return format(d, null);
	}

	public static Decimal calculateTimeBetweenInHours(Datetime datetime1, Datetime datetime2){
		Long time1 = datetime1.getTime();
		Long time2 = datetime2.getTime();
		Long milliseconds = time1 - time2;
		return milliseconds / 3600000.0d;
	}

	public static Datetime toDatetime(Date d){
		Datetime now = Datetime.now();
		Time timeNow = now.time();
		return Datetime.newInstance(d, timeNow);
	}

	public static Integer getWeek(Date value) {
		if (value == null)
		return null;
		if (value.month() > 1)
		return Integer.valueOf(Math.ceil(value.toStartOfWeek().addDays(-1).dayOfYear()/7.0)) + 1;
		return Integer.valueOf(Math.ceil(value.addDays(7).toStartOfWeek().addDays(-1).dayOfYear()/7.0));
	}

	public static String getMonth(Date value) {
		if (value == null)
		return null;
		return monthsMap.get(value.month());
	}

	public static Date getInicioDeSemana(Integer semana, Integer ano) {
		Integer dias = (semana - 1)*7;
		Date fecha = Date.newInstance(ano, 1, 1);
		if (semana == 1)
		return fecha;
		fecha = fecha.addDays(dias);
		return fecha.toStartOfWeek();
	}

	public static Date getFinalDeSemana(Integer semana, Integer ano) {
		Date fecha = getInicioDeSemana(semana+1, ano).addDays(-1);
		if (fecha.year() == ano)
		return fecha;
		return Date.newInstance(ano+1, 12, 31);
	}

	public static Date getInicioDeMes(String mes, Integer ano) {
		Integer nmes = monthsReverseMap.get(mes);
		if (nmes == null)
		return null;
		return Date.newInstance(ano, nmes, 1);
	}

	public static Date getFinalDeMes(String mes, Integer ano) {
		Date inicio = getInicioDeMes(mes, ano);
		if (inicio == null)
		return null;
		return inicio.addMonths(1).addDays(-1);
	}

	public static String getTrimester(Date d){
		Integer month = d.month();
		Decimal factor = month / 3.0d;
		return String.valueOf(Math.ceil(factor));
	}

	public static Date getInicioTrimestre(String trimestre, Decimal anio){
		Integer trimestreInt = Integer.valueOf(trimestre);
		Integer primerMes = (trimestreInt * 3) - 2;
		return Date.newInstance(Integer.valueOf(anio), primerMes, 1);
	}

	public static Date getFinTrimestre(String trimestre, Decimal anio){
		Integer trimestreInt = Integer.valueOf(trimestre);
		Integer ultimoMes = trimestreInt * 3;
		return Date.newInstance(Integer.valueOf(anio), ultimoMes, 1).addMonths(1).addDays(-1);
	}
}