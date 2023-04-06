@IsTest
public class SEC_CTRL_COVID_PDF_TEST {
    
    @isTest static void getData(){
        SEC_CTRL_COVID_PDF controller = setController();
    }
    
    private static SEC_CTRL_COVID_PDF setController(){
        Corredor__c corredor = new Corredor__c();
        corredor.Name = 'XXX';
        corredor.RUT__c = 'XXX';
        Insert corredor; 
        
        Account cuenta = new Account();
        cuenta.name = 'XXX';
        Insert cuenta;         
        
        Opportunity oportunidad = new Opportunity();
        oportunidad.CorredorPropuesta__c = corredor.Id;
        oportunidad.AccountId = cuenta.Id;
        oportunidad.Name = 'COVID TEST'; 
        oportunidad.StageName = 'Ingresar Negocio'; 
        oportunidad.CloseDate = System.today();
        Insert oportunidad;
        
        Quote presupuesto = new Quote();
        presupuesto.Name = 'XXX';
        presupuesto.OpportunityId = oportunidad.Id;
        presupuesto.Prima_neta_por_trabajador_Salud__c = 0;
        presupuesto.Total_N_titulares__c = 100;
        Insert presupuesto;
       
        ApexPages.StandardController sc = new ApexPages.StandardController(presupuesto);
        SEC_CTRL_COVID_PDF controller = new SEC_CTRL_COVID_PDF(sc);
        return controller;
    } 
       
}