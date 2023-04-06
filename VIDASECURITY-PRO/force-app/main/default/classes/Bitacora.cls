public abstract class Bitacora {
	
	public enum Evento {Aviso_de_Bloqueo, Recordatorio_de_Bloqueo, Compromiso_de_Pago, Bloqueo_de_Beneficios, Desbloqueo_de_Beneficios,Anulacion_Poliza_Corredor,Anulacion_Poliza_Cliente}
	public enum Estado {Correcto, Error}
	
	private Estado estado {get; set;}
	private Evento evento {get; set;}
	private String glosa {get; set;}
	private String glosaPredeterminada {get;set;}
	private String eventLabel {get; set;}
	
	public static Map<Bitacora.Evento, Evento_de_Notificacion__mdt> eventMap;
	public static Map<String, Bitacora.Evento> enumMap; 
	static {
		eventMap = new Map<Bitacora.Evento, Evento_de_Notificacion__mdt>();
		enumMap = new Map<String, Bitacora.Evento>();
		
		Map<String, Evento_de_Notificacion__mdt> notificationMap = new Map<String, Evento_de_Notificacion__mdt>();
		Evento_de_Notificacion__mdt[] events = [SELECT DeveloperName, MasterLabel, Glosa__c, Tipo_de_Evento__c FROM Evento_de_Notificacion__mdt];
		for (Evento_de_Notificacion__mdt event : events) {
			notificationMap.put(event.DeveloperName, event);
		}
		for (Bitacora.Evento event : Bitacora.Evento.values()) {
			enumMap.put(event.name(), event);
			String eventName = event.name();
			Evento_de_Notificacion__mdt notification = notificationMap.get(eventName);
			System.assertNotEquals(null, notification, 'No se ha creado el registro de metadatos para el evento de notificación ' + eventName + ', los eventos creados son: ' + notificationMap.keySet());
			eventMap.put(event, notification);
		}
	}
	
	public Bitacora(Bitacora.Evento evento) {
		this.evento = evento;
		this.glosaPredeterminada = eventMap.get(evento).Glosa__c;
		this.eventLabel = eventMap.get(evento).MasterLabel;
		this.glosa = null;
		this.estado = Bitacora.Estado.Correcto;
	}
	
	public Bitacora(String evento) {
		this(enumMap.get(evento));
	}
	
	public void addError(String glosa) {
		PageUtils.addError(glosa);
		this.addGlosa(glosa);
		this.estado = Bitacora.Estado.Error;
	}

	public void addSuccess(String glosa) {
		if (this.estado != Bitacora.Estado.Correcto)
			throw new CobranzaException('No es posible agregar una glosa exitosa si la Bitacora presenta Error');
		this.addGlosa(glosa);		
		this.estado = Bitacora.Estado.Correcto;
	}

	public void addGlosa(String glosa){
		if (this.glosa == null)
			this.glosa = glosa;
		else
			this.glosa += '\n' + glosa;
	}
	
	public virtual Bitacora__c getSObject() {
		return new Bitacora__c(Evento__c = this.eventLabel, Glosa__c = this.glosa == null ? glosaPredeterminada : this.glosa , Estado__c = this.estado.name());
	}
	
	public void addError(Database.Error[] errors) {
			for (Database.Error error : errors){
				String glosa = error.statuscode.name() + ' - ' + error.getFields() + ' - ' + error.getMessage();
				this.addError(glosa);
			}
	}
	
	public Boolean hasError() {
		return this.estado == Bitacora.Estado.Error;
	}
	
	public void setResultado(Database.SaveResult result) {
		if (!result.isSuccess())
			addError(result.getErrors());
	}
}