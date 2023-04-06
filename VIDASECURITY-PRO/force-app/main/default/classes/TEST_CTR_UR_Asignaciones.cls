@istest(seeAllData=true)
public with sharing class TEST_CTR_UR_Asignaciones {
    public TEST_CTR_UR_Asignaciones() {

    }
    
    @isTest static void getAsignacionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.getAsignacionesUR();
        Test.stopTest();
    }
    
    
    @isTest static void IniciaListadoAsignaciones_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        asignacion_UR__c asignacion = new asignacion_UR__c();
        insert asignacion;
        String ID = [SELECT  Id FROM asignacion_UR__c LIMIT 1].Id;
        ApexPages.currentPage().getParameters().put('Id', ID);
        controlador.IniciaListadoAsignaciones();
        Test.stopTest();
    }

	@isTest static void GuardaAsignacion_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.AsignacionUR = new asignacion_UR__c();
        controlador.GuardaAsignacion();
        Test.stopTest();
    }
    
    @isTest static void LimpiaAsignacion_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.LimpiaAsignacion();
        Test.stopTest();
    }
    
    @isTest static void CasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.CasosUR();
        Test.stopTest();
    }
    
    /*@isTest static void EliminarAsignacion_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.EliminarAsignacion();
        Test.stopTest();
    }*/
    
     @isTest static void BandejaUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Asignaciones controlador = new CTR_UR_Asignaciones();
        controlador.BandejaUR();
        Test.stopTest();
    }
    
    //
    //
    ////
    //
    //
    
    
    
    
    
}