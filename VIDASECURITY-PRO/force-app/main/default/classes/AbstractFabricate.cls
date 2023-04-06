public abstract class  AbstractFabricate {

	public class AbstractFabricateException extends Exception {}

	protected Sobject instance {get; set;}
	public Exception error {get; set;}
	private Set<String> fields;

	public AbstractFabricate() {
		this.instance = default();
		this.fields = new Set<String>();
		this.error = null;
	}

	public abstract Sobject default();
/*
	public Sobject build(Map<String,Object> attributes) {
		if (attributes == null)
			return instance;
		for (String fieldName : attributes.keySet())
			instance.put(fieldName, attributes.get(fieldName));
		return instance;
	}


		public Sobject buildInsert(Map<String,Object> attributes) {
		this.instance = build(attributes);
		insert this.instance;
		return this.instance;
	}
*/

	public Sobject reload(String[] fieldNames) {
		return reload(fieldNames, 'Id = \'' + this.instance.Id + '\' LIMIT 1');
			}

	public Sobject reload(String[] fieldNames, String condition) {
		if (fieldNames != null) {
			for (String fieldName : fieldNames)
			if (!fields.contains(fieldName))
			this.fields.add(fieldName);
		}

		Schema.SObjectType sType = this.instance.getSObjectType();
		String soql = 'SELECT Id' + (fields.size() > 0 ? ', ' + String.join(new List<String>(fields), ', ') : '') +
		' FROM ' + ReflectionUtils.getDescribe(sType).getName();
		if (condition != null && !condition.startsWith(' LIMIT'))
		soql += ' WHERE ' + condition;
		Sobject[] sobjects = Database.query(soql);
		if (sobjects.isEmpty())
		return null;
		return sobjects[0];
	}

// Chaining model

	public AbstractFabricate load() {
		return load(null, null);
	}

	public AbstractFabricate load(String[] fields) {
		return load(fields, null, null);
	}

	public AbstractFabricate load(String field, Object value) {
		return load(null, field, value);
	}

	public AbstractFabricate load(String[] selectedFields, String field, Object value) {
		String condition = ' LIMIT 1';
		if (field != null)
			condition = field + ' = \'' + value + '\'' + condition;
		this.instance = reload(selectedFields, condition);
		if (this.instance == null)
			throw new AbstractFabricateException('No existen instancias con los criterios especificados');
		return this;
	}

	public Sobject get() {
		return this.instance;
	}

	/*
	public AbstractFabricate set(Schema.SobjectField field, Object value) {
		instance.put(field, value);
		return this;
	}
	*/

	public AbstractFabricate set(String field, Object value) {
		if (field != null && !fields.contains(field))
			fields.add(field);

		if (value instanceof AbstractFabricate)
		return setReference(field, (AbstractFabricate)value);

		instance.put(field, value);
		return this;
	}

	public AbstractFabricate setReference(String field, AbstractFabricate reference) {
		if (reference.get().get('Id') == null)
			reference.save();
		instance.put(field, reference.get().get('Id'));
		return this;
	}

	public AbstractFabricate save() {
		upsert this.instance;
		return this;
	}

	public AbstractFabricate duplicate() {
		instance = instance.clone(false, false, false, false);
		return this;
	}

	public Sobject reload() {
		return reload(null);
	}

	public AbstractFabricate inserts(Boolean catchError){
		if (!catchError){
			insert this.instance;
			return this;
		}
		try {
			insert this.instance;
		} catch (Exception e) {
			this.error = e;
		}
		return this;
	}

	public AbstractFabricate inserts() {
		return inserts(true);
	}

	public AbstractFabricate insertsNoCatch() {
		return inserts(false);
	}

	public AbstractFabricate updates(Boolean catchError) {
		if (!catchError){
			update this.instance;
			return this;
		}
		try {
			update this.instance;
		} catch (Exception e) {
			this.error = e;
		}
		return this;
	}

	public AbstractFabricate updates() {
		return updates(true);
	}

	public AbstractFabricate updatesNoCatch() {
		return updates(false);
	}

	public Object get(String field) {
		if (instance == null)
		throw new AbstractFabricateException('La instancia del fabricate es nula');
		return instance.get(field);
	}
	
	public Id getId() {
		return (Id)get('Id');
	}
	
}