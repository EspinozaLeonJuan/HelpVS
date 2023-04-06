public class Query {
	
	public List<Id> ids {get; set;}
	public Schema.SobjectType stype {get; set;}
	public List<String> fields {get; set;}
	
	public Query(Schema.SobjectType stype) {
		this.stype = stype;
		this.ids = new List<Id>();
		this.fields = new List<String>();
	}
	
	public Sobject[] getRecords() {
		String query = 'SELECT ' + String.join(fields, ', ') + ' FROM ' + stype.getDescribe().getName() + ' WHERE Id IN :ids';
		return Database.query(query);
	}
	
	public Map<Id, Sobject> getRecordMap() {
		return new Map<Id, Sobject>(getRecords());
	}
	
	public void addField(String field) {
		if (String.isNotBlank(field) && !fields.contains(field))
			this.fields.add(field);
	}
	
	public void addId(Id newId) {
		if (newId != null && !ids.contains(newId))
			this.ids.add(newId);
	}
	
	}