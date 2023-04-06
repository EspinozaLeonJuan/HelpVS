/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-01-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@istest
public with sharing class TEST_CTR_CM_LeadFields {
    public TEST_CTR_CM_LeadFields() {

    }


    @isTest static void getFields()
    {      
        Test.startTest();
         Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;
        
        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.PROSP_Carga_RUT__C = '15045517';
        lead.DV__C = '0';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'Juan';
        lead.LastName = 'Espinoza';		
        insert lead;
        
        CTR_CM_LeadFields Con = new CTR_CM_LeadFields();
        ApexPages.currentPage().getParameters().put('Id', lead.Id);
        Con.getFields();
        test.stopTest();
    }
    
     @isTest static void iniciaLeadFields()
    {      
        Test.startTest();           
        CTR_CM_LeadFields Con = new CTR_CM_LeadFields(); 
        Con.iniciaLeadFields();
        test.stopTest();
    }
    
      @isTest static void refreshLeadFields()
    {      
        Test.startTest();           
        CTR_CM_LeadFields Con = new CTR_CM_LeadFields(); 
         Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;
        
        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.PROSP_Carga_RUT__C = '15045517';
        lead.DV__C = '0';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'Juan';
        lead.LastName = 'Espinoza';		
        insert lead;
		Con.Id = lead.Id;
        Con.iniciaLeadFields();
        test.stopTest();
    }
}