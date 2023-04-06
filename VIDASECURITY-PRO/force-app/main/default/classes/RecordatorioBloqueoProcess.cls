global class RecordatorioBloqueoProcess implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		if (!HolidayUtils.isHoliday(Datetime.now()) || Test.isRunningTest())
			RecordatorioBloqueoBatch.start();
	}
}