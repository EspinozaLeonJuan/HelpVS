public with sharing class TriggerSettings {

	//public static Trigger_Setting__c[] settings;

	public static final Profile[] profiles = [SELECT Id, Name FROM Profile];
	public static Map<String,Profile> mapProfiles = new Map<String,Profile>();

	static {
		getMapPerfiles();
	}


	public static Map<String,Profile> getMapPerfiles(){
		if (mapProfiles.size() > 0)
		return mapProfiles;
		for (Profile p : profiles)
		mapProfiles.put(p.Name, p);
		return mapProfiles;
	}

	public static void restore() {
		EnabledHeap.pop();
	}

	private static Boolean isEnabled(Id setupOwnerId, Type klass) {
		Map<Id, Map<Type, Boolean>> enabledMap = EnabledHeap.current();
		return enabledMap.containsKey(setupOwnerId) && enabledMap.get(setupOwnerId).containsKey(klass) && enabledMap.get(setupOwnerId).get(klass);
	}

	public static Boolean isEnabled(Type klass) {
		Map<Id, Map<Type, Boolean>> enabledMap = EnabledHeap.current();
		Id[] setupOwnerIds = new Id[]{UserInfo.getUserId(), UserInfo.getProfileId(), Userinfo.getOrganizationId()};
		for (Id setupOwnerId : setupOwnerIds){
			if (enabledMap.containsKey(setupOwnerId) && enabledMap.get(setupOwnerId).containsKey(klass))
				return enabledMap.get(setupOwnerId).get(klass);
			if (enabledMap.containsKey(setupOwnerId) && enabledMap.get(setupOwnerId).containsKey(null))
				return enabledMap.get(setupOwnerId).get(null);
		}
		return false;
	}

	public static Boolean isEnabled() {
		return isEnabled(null);
	}

	public static void enable(Id scopeId, Type klass, Boolean enabled) {
		Map<Id, Map<Type, Boolean>> enabledMap = EnabledHeap.current();
		if (scopeId == null)
		scopeId = UserInfo.getOrganizationId();
		Map<Type, Boolean> triggerMap = enabledMap.get(scopeId);
		if (!enabled && triggerMap == null)
		return; // No necesitamos crear el mapa para desabilitar este scope.
		if (triggerMap == null) {
			triggerMap = new Map<Type, Boolean>();
			enabledMap.put(scopeId, triggerMap);
		}
		triggerMap.put(klass, enabled);
	}

	public static Integer stackDeep(){
		return EnabledHeap.enabledStack.size();
	}

	public static void enable(Type klass, Boolean enabled) {
		enable(null, klass, enabled);
	}

	public static void enable(Type klass) {
		enable(klass, true);
	}

	public static void enable() {
		enable(null, true);
	}

	public static void disable(Type klass) {
		Id[] setupOwnerIds = new Id[]{UserInfo.getUserId(), UserInfo.getProfileId(), Userinfo.getOrganizationId()};
		for (Id scopeId : setupOwnerIds)
			enable(scopeId, klass, false);	// Desabilitamos la clase para todos los scopes.
	}

	public static void disable() {
		disable(false);	// Por defecto deshabilitamos permanentemente los triggers. Revisar.
	}

	public static void disable(Boolean temporal) {
		Map<Id, Map<Type, Boolean>> enabledMap = EnabledHeap.current();
		if (enabledMap != null && !temporal)
			enabledMap.clear();	// Se limpia permanentemente la instancia activa.
		else {
						enabledMap = new Map<Id, Map<Type, Boolean>>();	// Se reemplaza la instancia que se recuperará con restore.
		EnabledHeap.push(enabledMap);
		}
	}

		/**
	* Deshabilita todos los handlers temporalmente excepto los especificados. Luego se puede utilizar restore para recuperar la instancia anterior.
	*/
	public static void enableOnly(Type[] handlers) {
		if (handlers == null) {
			EnabledHeap.init();		// Mete un nuevo mapa inicializado al heap
			return;
		}
			disable(true);
		for (Type handler : handlers)
			enable(handler);
	}
}