public class NotificaCarteraAsignadaController {
	
	public Id ownerId {get; set;}
	public Account[] accounts {get {
		if (this.accounts == null)
			this.accounts = [SELECT Id, Fecha_Ultimo_Cambio_Propietario__c, Name, Rut_con_dv__c, Categoria_del_Cliente__r.Name, Ciudad_Particular_B__r.Name, PersonHomePhone, PersonMobilePhone, PersonEmail FROM Account WHERE OwnerId = :ownerId AND Fecha_Ultimo_Cambio_Propietario__c IN (TODAY, YESTERDAY) ORDER BY Categoria_del_Cliente__r.Name, Name];
		return this.accounts;
	} set;}
	
	public NotificaCarteraAsignadaController() {
	}
	
	
}