public with sharing class CasoHibernacion {

	public static void chequearFechaHibernacion() {
		Date today = Date.today();
		List<Case> casosActualizar = new List<Case>();
		List<Case> casosHibernando = [Select Id, Status, Fecha_termino_hibernacion__c
		                              from Case
		                              Where Status = 'Hibernado' and Fecha_termino_hibernacion__c <= today];

		for (Case caso : casosHibernando) {
			caso.Status = 'En Proceso';
			casosActualizar.add(caso);
		}

		if (!casosActualizar.isEmpty())
			update casosActualizar;
	}
}