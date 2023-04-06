global class AvisoBloqueoProcess implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		if (!HolidayUtils.isHoliday(Datetime.now()) || Test.isRunningTest())
			AvisoBloqueoBatch.start();
	}
}