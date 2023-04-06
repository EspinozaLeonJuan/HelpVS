global class BloqueoProcess implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		Date today = Date.today();
		if (!HolidayUtils.isHoliday(today) && !HolidayUtils.isFirstBusinessDayOfMonth(today))
			BloqueoBatch.start();
	}
}