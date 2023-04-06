public with sharing class HolidayUtils {
	
	public class HolidayException extends Exception {}


	private static Date SOME_SUNDAY = Date.newInstance(1900, 1, 7);
	private static final Holiday[] holidays = [SELECT RecurrenceDayOfMonth, RecurrenceMonthOfYear, RecurrenceType, IsRecurrence, ActivityDate, RecurrenceDayOfWeekMask FROM Holiday];

	private static final BusinessHours diasLaborables = [SELECT Id FROM BusinessHours WHERE IsDefault=true];

	public static Integer dayOfWeek(Date myDate) {
		if (myDate == null)
		throw new HolidayException('No es posible calcular el día de la semana para una fecha no especificada.');
		return Math.mod(SOME_SUNDAY.daysBetween(myDate), 7);
	}

	public static Boolean isHoliday(Datetime d) {
		return isHoliday(d.date());
	}

	public static Boolean isHoliday(Date d) {
		if (d == null)
			throw new HolidayException('No es posible determinar el feriado para una fecha no especificada');
		DateTime dt = DateTime.newInstance(d, Time.newInstance(0, 0, 0, 0));
		Integer dayOfWeekMask = Integer.valueOf(Math.pow(2, dayOfWeek(d)));
		for (Holiday holiday : holidays) {
			if (!holiday.IsRecurrence && d.isSameDay(holiday.ActivityDate))
				return true;
			if (holiday.IsRecurrence && holiday.RecurrenceType == 'RecursWeekly' && (dayOfWeekMask & holiday.RecurrenceDayOfWeekMask) == dayOfWeekMask)
				return true;
			if (holiday.IsRecurrence && holiday.RecurrenceType == 'RecursYearly' && dt.format('MMMM') == holiday.RecurrenceMonthOfYear && d.day() == holiday.RecurrenceDayOfMonth)
				return true;
		}
		return false;
	}

	public static Date getNextBusinessDay(Date d) {
		Date next = d.addDays(1);
		if (isHoliday(next))
			return getNextBusinessDay(next);
		return next;
	}

	public static Boolean isNextBusinessDayNextPeriod(Date d) {
		Date today = d;
		Date next = getNextBusinessDay(today);
		return next.month() != today.month();
	}

	public static Boolean isNextBusinessDayNextPeriod() {
		return isNextBusinessDayNextPeriod(Date.today());
	}
	
	/**
	* IMPORTANTE: El límite de cálculo para este método son 60 años.
	* Si se hace recursivo baja a 2 años 8 meses.
	*/
	public static Integer bussinessDaysBetweenDates(Date startDate, Date endDate) {
		if (startDate == null || endDate == null || endDate < startDate)
			return 0;
			Integer days = 0;
		while (startDate <= endDate) {
			if (!isHoliday(startDate))
				days++;
			startDate = startDate.addDays(1);
		}
				return days;
	}
	
	/**
	* IMPORTANTE: El límite de cálculo para este método son 2 años 8 meses. Después lanza un NullPointerException
	*/
	public static Integer bussinessDaysBetweenDatesWithBussinessHours(Date startDate, Date endDate) {
		if (startDate == null || endDate == null || endDate < startDate)
			return 0;
		Integer days = 0;
		while (startDate <= endDate) {
			Datetime fechaAChequear = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day());
			if (!isHoliday(startDate) && BusinessHours.isWithin(diasLaborables.id, fechaAChequear))
				days++;
			startDate = startDate.addDays(1);
		}
		return days;
	}

	public static Date addBussinessDays(Date startDate, Integer days) {
		Date fecha = startDate.addDays(1);
		for (Integer i = 0; i < days ; i++) {
			fecha = getNextDayWorkWithBussinessHours(fecha);	
			if(i!=(days-1))
				fecha = fecha.addDays(1);
		}
		return fecha;

	}

	public static Date getNextDayWork(Date startDate) {
		Date fecha = startDate;
		Integer dow = dayOfWeek(fecha.addDays(1));
		if (!isHoliday(fecha.addDays(1)) && dow != 0 && dow != 6)
			return fecha.addDays(1);
		else 
			return getNextDayWork(getNextBusinessDay(fecha));
	}

	public static Date getNextDayWorkWithBussinessHours(Date startDate) {
		//Se pone un horario de las 11 am para comprobar si el día es hábil
		if (BusinessHours.isWithin(diasLaborables.id, Datetime.newInstance(startDate, Time.newInstance(11,0,0,0))))
			return startDate;
		return getNextDayWorkWithBussinessHours(startDate.addDays(1));
	}
	
	private static Date getFirstBusinessDayOfMonthFromFirstDay(Date firstDay) {
		if (firstDay == null)
			return null;
				if (!isHoliDay(firstDay))
			return firstDay;
		return getFirstBusinessDayOfMonthFromFirstDay(firstDay.addDays(1));
	}
	
	public static Date getFirstBusinessDayOfMonth(Date source) {
		if (source == null)
			return null;
		return getFirstBusinessDayOfMonthFromFirstDay(source.toStartOfMonth());
	}
	
	public static Boolean isFirstBusinessDayOfMonth(Date source) {
		return source != null && source.isSameDay(getFirstBusinessDayOfMonth(source));
	}

}