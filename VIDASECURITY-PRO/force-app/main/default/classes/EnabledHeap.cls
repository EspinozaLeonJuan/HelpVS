public without sharing class EnabledHeap {

	public class EnabledHeapException extends Exception {}

	public final static List<Map<Id, Map<Type, Boolean>>> enabledStack = new List<Map<Id, Map<Type, Boolean>>>();

	static {
		init();
	}

	public static void init(){
		Trigger_Setting__c[] settings = [SELECT Id, SetupOwnerId__c, Habilitado__c, Name, Perfil_Id__c FROM Trigger_Setting__c];
		Map<Id, Map<Type, Boolean>> enabledMap = new Map<Id, Map<Type, Boolean>>();
		for (Trigger_Setting__c setting : settings) {
			Map<Type, Boolean> triggerMap = enabledMap.get(setting.SetupOwnerId__c);
			if (triggerMap == null) {
				triggerMap = new Map<Type, Boolean>();
				enabledMap.put(setting.SetupOwnerId__c, triggerMap);
			}
			Type klass = setting.Name == null || setting.Name == 'All' ? null : Type.forName(setting.Name);
			triggerMap.put(klass, setting.Habilitado__c);
		}
		enabledStack.add(enabledMap);
	}

	public static Map<Id, Map<Type, Boolean>> current() {
		if (enabledStack.isEmpty())
		throw new EnabledHeapException('No hay settings en el heap');
		return enabledStack.get(enabledStack.size() - 1);
	}

	public static Map<Id, Map<Type, Boolean>> pop() {
		if (enabledStack.isEmpty())
		throw new EnabledHeapException('No hay settings en el heap');
		return enabledStack.remove(enabledStack.size() - 1);
	}

	public static void push(Map<Id, Map<Type, Boolean>> enabledMap) {
		enabledStack.add(enabledMap);
	}
}