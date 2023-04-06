global class CasoHibernacionSchedulable implements Schedulable {
	global void execute(SchedulableContext sc) {
		CasoHibernacion.chequearFechaHibernacion();
	}
}