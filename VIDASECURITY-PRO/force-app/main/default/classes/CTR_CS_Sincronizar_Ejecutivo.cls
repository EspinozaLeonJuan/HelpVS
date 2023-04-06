public with sharing class CTR_CS_Sincronizar_Ejecutivo {

    public Id Id_Account {get; set;}
    public Boolean success {get; set;}
    public String Msg {get; set;}

 	public CTR_CS_Sincronizar_Ejecutivo(ApexPages.StandardController controller) { 
    	Account item_acc = (Account)controller.getRecord();
        this.Id_Account = item_acc.Id;
        this.success = false;
    }
    public void actualizar_account(){
        if ( this.Id_Account != null ) {
            try {
                Account new_acc = new Account( Id = this.Id_Account, Fecha_y_Hora_Sincronizaci_n__c = DateTime.now() , Sincronizar_Ejecutivo__c = TRUE );
                update new_acc;
                this.success = true;
                this.Msg = '';
                System.debug('@@@ Actualización exitosa CTR_CS_Sincronizar_Ejecutivo');
            } catch(DmlException e) { this.Msg = 'Ha ocurrido un error al sincronizar, por favor inténtelo de nuevo dentro de un minuto.'; this.success = false;
                System.debug('@@@ Error CTR_CS_Sincronizar_Ejecutivo : ' + e.getMessage());
            }
        }
    }  
}