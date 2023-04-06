@istest
public class TEST_CLS_CM_ProcesaProspecto_OncoApeg {

      @IsTest static void execute_text()
     {      
        Test.startTest();    
        
        Lead lead = new Lead(); 
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '0';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'A';
        lead.LastName = 'B';	
        lead.Email = 'a@ibm.com';
        insert lead;
 
        CampaignMember cm = new CampaignMember();
        cm.LeadId = lead.Id; 
        cm.MCAMP_Es_cliente__c = true;
                
        CLS_CM_ProcesaProspecto_OncoApeg.Retorno retorno = new CLS_CM_ProcesaProspecto_OncoApeg.Retorno();
        retorno.campaignMember = cm;
        retorno.lead = lead;
        retorno.ERR_WS = true;
        retorno.ERR_LINEA_WS = '123';
        retorno.ERR_MENSAJE_WS = 'error';
        
        CLS_CM_ProcesaProspecto_OncoApeg.Retorno retorno_datos = CLS_CM_ProcesaProspecto_OncoApeg.ObtenerDatosProspecto(cm);
        CLS_CM_ProcesaProspecto_OncoApeg.Retorno retorno_obtiene = CLS_CM_ProcesaProspecto_OncoApeg.ObtieneProducto(cm);
        CLS_CM_ProcesaProspecto_OncoApeg.Retorno retorno_valida = CLS_CM_ProcesaProspecto_OncoApeg.ValidacionAsegurado(cm);
            
        test.stopTest();
    }
}