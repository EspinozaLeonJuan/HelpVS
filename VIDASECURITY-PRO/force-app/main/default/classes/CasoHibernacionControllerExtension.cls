public with sharing class CasoHibernacionControllerExtension {

	public Case caso {get; set;}

	public CasoHibernacionControllerExtension(ApexPages.StandardController stdController) {
		if (!Test.isRunningTest())
			stdController.addFields(new String[] {'Dias_por_hibernar__c', 'Area_comercial__c', 'Aviso_informativo__c'});
		this.caso = (Case)stdController.getRecord();
	}

	// Preguntas:
	// - ¿Los dias para hibernar son días laborales?
	public System.Pagereference hibernarCaso(){
		if (String.isBlank(this.caso.Dias_por_hibernar__c)){
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'Debe ingresar una cantidad de días para hibernar el caso'));
			return null;
		}
		if (String.isBlank(this.caso.Area_comercial__c)){
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO, 'Debe especificar un área comercial para continuar.'));
			return null;
		}
		Date today = Date.today();
		Integer diasHibernacion = Integer.valueOf(this.caso.Dias_por_hibernar__c);
		this.caso.Fecha_termino_hibernacion__c = Datetime.newInstance(today.addDays(diasHibernacion), Time.newInstance(9, 0, 0, 0));
		this.caso.Fecha_aviso_informativo__c = getFechaAvisoInformativo(this.caso.Aviso_informativo__c);
		this.caso.Status = 'Hibernado';
		try {
			update caso;
		} catch (Exception ex){
			return null; // Retornamos a la misma página de creación de la hibernación en caso de error.
		}
		return volverADetalleCaso();
	}

	public System.Pagereference volverADetalleCaso(){
		return new System.Pagereference('/' + this.caso.Id);
	}

	/**
	 * @param  valorLista Valor de lista de selección de campo Aviso_informativo__c
	 * @return            Retorna la fecha de aviso calculada en función del valor de lista ingresado como texto.
	 */
	private Datetime getFechaAvisoInformativo(String valorLista){
		if (valorLista == null) return null;
		Datetime now = Datetime.now();
		Datetime terminoHibernacion = this.caso.Fecha_termino_hibernacion__c;
		Integer diasHibernacion = Integer.valueOf(this.caso.Dias_por_hibernar__c);
		if (valorLista == 'A la mitad del periodo' && diasHibernacion > 0)
			return now.addDays(diasHibernacion / 2);
		if (valorLista == 'Al término de la hibernación' && terminoHibernacion != null)
			return terminoHibernacion;
		Pattern patron = Pattern.compile('(\\d+) d[ií]as? antes');
		Matcher myMatcher = patron.matcher(valorLista);
		if (myMatcher.matches() && terminoHibernacion != null)
			return terminoHibernacion.addDays(Integer.valueOf(myMatcher.group(1)) * -1);
		return null;
	}
}