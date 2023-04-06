global class DesBloqueoProcess implements Schedulable {
	
	global void execute(SchedulableContext sc) {
		// Debe ejecutarse todos los días
		//if (!HolidayUtils.isHoliday(Datetime.now()))
		DesBloqueoBatch.start();
	}
}