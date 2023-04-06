public class CLS_CasoParticipanteController {
	public Participantes_de_Campa_a__c part { get; set; }
    public Flow.Interview.Flujo_Caso_Aumento_Prima myflow { get; set; }
    public String IdCasoHijo { get; set; }
    public String IdTest { get; set; }
    
    public PageReference cargaDatosParticipante() {
        try {
            String idPart = apexpages.currentpage().getparameters().get('Id');
            system.debug('@@@@ idPart ' + idPart);
            
            if (!Test.isRunningTest()) {
                part = [SELECT Id, Cuenta__c, Poliza__c, Prima_Total_Final__c, Frecuencia_de_Pago__c FROM Participantes_de_Campa_a__c WHERE Id = :idPart];
            } else {
                system.debug('@@@@ idtest' + this.IdTest);
                part = [SELECT Id, Cuenta__c, Poliza__c, Prima_Total_Final__c, Frecuencia_de_Pago__c FROM Participantes_de_Campa_a__c WHERE Id = :IdTest];
            }
            
            return null;
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public String getVarValue() {
        if (myflow == null) { 
            return null; 
        }
        else {
            IdCasoHijo = myflow.Id_Caso_Hijo;
            return '/' + (String)myflow.Id_Caso_Hijo;
        }
    }
    
	public PageReference ToDerivar()
    {  
        try {
            String id = (String)myflow.Id_Caso_Hijo;
            PageReference detalleCaso = new PageReference('/apex/SEC_VF_UR_derivacioncaso?id=' + id);
            detalleCaso.setRedirect(true);
            return detalleCaso;
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        } 
    }    
}