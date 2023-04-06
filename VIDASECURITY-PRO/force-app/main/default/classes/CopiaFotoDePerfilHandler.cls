public with sharing class CopiaFotoDePerfilHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		List<Id> userIds = new List<Id>();
		for (User user : (User[])Trigger.new) {
			User old = (User)(Trigger.isUpdate ? Trigger.oldMap.get(user.Id) : null);
			if (user.FullPhotoUrl != null && !user.FullPhotoUrl.endsWith('/005/F') && (old == null || user.FullPhotoUrl != old.FullPhotoUrl))
				userIds.add(user.Id);
		}
		if (!userIds.isEmpty())
			CopiaFotoDePerfilProcess.execute(userIds);
	}
   
}