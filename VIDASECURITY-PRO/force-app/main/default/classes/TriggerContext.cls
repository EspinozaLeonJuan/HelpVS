public class TriggerContext {

	public Boolean isInsert {get; set;}
	public Boolean isUpdate {get; set;}
	public Boolean isDelete {get; set;}
	public Boolean isUndelete {get; set;}
	public Boolean isBefore {get; set;}
	public Boolean isAfter {get; set;}
	public List<Sobject> newList {get; set;}
	public List<Sobject> oldList {get; set;}
	public Map<Id, Sobject> newMap {get; set;}
	public Map<Id, Sobject> oldMap {get; set;}


	// Estas asignaciones soprendentemente ocupan muchos milisegundos alrededor de 50 en total.
	public TriggerContext() {
		this.isInsert = Trigger.isInsert;
		this.isUpdate = Trigger.isUpdate;
		this.isDelete = Trigger.isDelete;
		this.isUndelete = Trigger.isUndelete;
		this.isBefore = Trigger.isBefore;
		this.isAfter = Trigger.isAfter;
		this.newList = Trigger.new;
		this.oldList = Trigger.old;
		this.newMap = Trigger.newMap;
		this.oldMap = Trigger.oldMap;
	}

}