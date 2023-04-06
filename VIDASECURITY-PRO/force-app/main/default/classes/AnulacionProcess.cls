global class AnulacionProcess implements Schedulable {
	

	global AnulacionProcess(){
	}

	global void execute(SchedulableContext sc) {
		List<String> errors = new List<String>();
		try {
			System.debug('Anulación Process Begins');
			AnulacionService.marcarPolizasAnulables();
			System.debug('Anulación Process ends');	
		} catch (Exception e) {
			errors.add(e.getTypeName() + ' - ' + e.getMessage() + '\n' + e.getStackTraceString());
		}
		CobranzaService.notifyProcessResult('Anulación Póliza', errors);
	}
}