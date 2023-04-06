global class CopiaFotoDePerfilProcess implements Schedulable {
	
	public Integer daysAgo {get; set;}
	
	global CopiaFotoDePerfilProcess() {
		this.daysAgo = 1;
	}
	
	@Future(Callout=true)
	global static void execute(Id[] userIds) {
		User[] users = [SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl FROM User WHERE ID IN :userIds];
		CopiaFotoDePerfilBatch batch = new CopiaFotoDePerfilBatch(null);
		batch.execute(null, users);
	}
	
	global void execute(SchedulableContext sc) {
		CopiaFotoDePerfilBatch.start(daysAgo);
	}
}