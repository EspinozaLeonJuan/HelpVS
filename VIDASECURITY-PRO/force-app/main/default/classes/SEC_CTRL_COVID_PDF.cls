public class SEC_CTRL_COVID_PDF {

    public Quote presupuesto{set;get;}    
    public Opportunity oportunidad{set;get;}
    public Account cuenta{set;get;}
    public Corredor__c corredor{set;get;}    
    public string pol{set;get;}
    public string dateFormat{set;get;}
    
    public decimal impuestos{set;get;}
    
    public SEC_CTRL_COVID_PDF(ApexPages.StandardController controller){
        Quote opp = (Quote)controller.getRecord();
        pol = 'POL 320210063';
        dateFormat = Datetime.now().format('dd-MM-yyyy');
        getData(opp);
    }
    
    public void getData(Quote opp){
        presupuesto = [
            SELECT 
            Id
            , Name
            , OpportunityId 
            , Total_N_titulares__c
            , Prima_neta_por_trabajador_Vida__c 
            , Prima_bruta_Vida__c
            , Prima_neta_por_trabajador_Salud__c 
            , Prima_bruta_Salud__c
            , Prima_Total_Bruta__c 
            , Comision__c 
            FROM Quote
            WHERE Id =: opp.Id LIMIT 1
        ];        
         
        oportunidad = [
            SELECT Id, Name, AccountId, QuienFinanciaPrima__c, CorredorPropuesta__c FROM Opportunity
            WHERE Id =: presupuesto.OpportunityId LIMIT 1
        ];
        
        cuenta = [
            SELECT Id, Name, Rut__c, DV__c, Rubro__c FROM Account
            WHERE Id =: oportunidad.AccountId LIMIT 1
        ];
        
        corredor = [
            SELECT Id, Name FROM Corredor__c
            WHERE Id =: oportunidad.CorredorPropuesta__c LIMIT 1
        ];
        
        if(presupuesto != null){
        	Decimal toRound = presupuesto.Prima_neta_por_trabajador_Salud__c * presupuesto.Total_N_titulares__c * 0.19;
	        impuestos = toRound.setScale(4);            
        }else{
            impuestos = 0.0000;
        }

    }
}