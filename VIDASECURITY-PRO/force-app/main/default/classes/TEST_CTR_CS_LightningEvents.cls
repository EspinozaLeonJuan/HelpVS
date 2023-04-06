@istest(seeAllData=true)
public with sharing class TEST_CTR_CS_LightningEvents {
    public TEST_CTR_CS_LightningEvents() {

    }
    
    @isTest static void LoadEvent_Test_01()
    {
        Test.startTest();
        CTR_CS_LightningEvents controlador = new CTR_CS_LightningEvents();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        
        ApexPages.currentPage().getParameters().put('Id', Caso.Id);
        ApexPages.currentPage().getParameters().put('Option', 'ADJUNTO_VALUETECH');
       
        controlador.LoadEvent();
        Test.stopTest();
    }
    
    @isTest static void LoadEvent_Test_02()
    {
        Test.startTest();
        CTR_CS_LightningEvents controlador = new CTR_CS_LightningEvents();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        
        ApexPages.currentPage().getParameters().put('Id', Caso.Id);
        ApexPages.currentPage().getParameters().put('Option', 'ESCRITORIO_DIGITAL_RPA');
        ApexPages.currentPage().getParameters().put('IdRequerimiento', '50012');
       
        controlador.LoadEvent();
        Test.stopTest();
    }
}