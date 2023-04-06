public class SolicitarAprobacionDeReclamoController {
    
    public Case caso {get; set;}
    
    public SolicitarAprobacionDeReclamoController(ApexPages.StandardController controller) {
        if (!Test.isRunningTest())
            controller.addFields(new String[] {'Subject', 'RecordTypeId', 'Instancia_del_Reclamo__c', 'Aprobado_Reclamo__c', 'CaseNumber'});
        this.caso = (Case)controller.getRecord();
    }
    
    public System.PageReference addError(String message) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
        return null;
    }
    
    public void validar(Boolean condition, String message) {
        if (condition)
            addError(message);
    }
    
    public System.PageReference init() {
        validar(caso.RecordTypeId != Schema.SobjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId(), 'No puede solicitar la aprobación de este caso puesto que no es un reclamo. Asegúrese que el tipo de registro del caso sea "Reclamos".');
        validar(String.isBlank(caso.Instancia_del_Reclamo__c), 'No puede solicitar la aprobación de este reclamo puesto que no tiene instancia de reclamo asignada.');
        validar(caso.Instancia_del_Reclamo__c == 'Primera', 'No puede solicitar la aprobación de un reclamo en primera instancia.');
        validar(caso.Aprobado_Reclamo__c, 'Este reclamo ya se encuentra aprobado.');
        String name = 'Respuesta%';
		Attachment[] attachments = [SELECT Id FROM Attachment WHERE ParentId = :caso.Id AND Name LIKE :name];
        
        //Consulta si el usuario está en Classic
        if(UserInfo.getUiThemeDisplayed() == 'Theme3')
        {                            
            validar(attachments.isEmpty(), 'Para poder solicitar la aprobación de este reclamo, primero debe adjuntar la carta de respuesta al cliente. Considere que el nombre del archivo debe comenzar con el texto Respuesta');           
        }
        //Consulta si el usuario está en Lightning y no tiene "Attachments"
        else if(UserInfo.getUiThemeDisplayed() == 'Theme4d' && attachments.isEmpty())
        {	
           ContentDocumentLink[] ContentDocumentList = [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :caso.Id AND ContentDocument.Title LIKE :name];
            validar(ContentDocumentList.isEmpty(), 'Para poder solicitar la aprobación de este reclamo, primero debe adjuntar la carta de respuesta al cliente. Considere que el nombre del archivo debe comenzar con el texto Respuesta');           
         }

        if (ApexPages.hasMessages())
            return null;
            
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Solicitando la Aprobación para el Reclamo: ' + (caso.Subject == null ? caso.CaseNumber : caso.Subject));
        req1.setObjectId(caso.Id);
        req1.setProcessDefinitionNameOrId('Proceso_Reclamo_Repetitivo');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = null;
        try {
            result = Approval.process(req1);
        } catch (Exception e) {
            return addError(e.getMessage());
                    }
        if (!result.isSuccess())
            for (Database.Error error:result.getErrors())
            return addError('Ocurrió un problema al solicitar la aprobación de este reclamo, por favor comuníquese con el administrador del sistema. ERROR: ' + error.getMessage());
                                                return new System.PageReference('/'+caso.Id);
            }
}