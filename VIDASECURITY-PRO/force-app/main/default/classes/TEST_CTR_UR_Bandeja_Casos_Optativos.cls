/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
@istest(seeAllData=true)
public  class TEST_CTR_UR_Bandeja_Casos_Optativos {
    public TEST_CTR_UR_Bandeja_Casos_Optativos() {

    }
    
    @isTest static void FirstPage_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.FirstPage();
        Test.stopTest();
    }
    
    @isTest static void previous_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.Page = 10;
        controlador.previous();
        Test.stopTest();
    }
    
    @isTest static void next_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.Page = 10;
        controlador.next();
        Test.stopTest();
    }
    
    @isTest static void LastPage_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.Page = 10;
        controlador.totalRecs = 100;
        //OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        controlador.LastPage();
        Test.stopTest();
    }
    
    @isTest static void getprev_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.getprev();
        Test.stopTest();
    }
    
    @isTest static void getnxt_Test()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.getnxt();
        Test.stopTest();
    }
    
    @isTest static void getListarEstados_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.getListarEstados(); 
        Test.stopTest();
    }
    
      @isTest static void getListarEstados_Test_02()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();  
        controlador.getListarEstados(); 
        Test.stopTest();
    }
    
      @isTest static void getListarEstados_Test_03()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();   
        controlador.getListarEstados(); 
        Test.stopTest();
    }
    
     @isTest static void getListarTipos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.getListarTipos();
        Test.stopTest();
    }
    
    @isTest static void getListarOrigenes_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.getListarOrigenes();
        Test.stopTest();
    }
    
     @isTest static void verCasoUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.verCasoUR();
        Test.stopTest();
    }
    
     @isTest static void getCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.FechaInicio = Date.today().addDays(-30);
        controlador.FechaTermino = Date.today();
        controlador.getCasosUR();
        Test.stopTest();
    }
    
     @isTest static void limpiaBusquedaCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.limpiaBusquedaCasos();
        Test.stopTest();
    }
    
     /* @isTest static void CargaUsuario_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.CargaUsuario();
        Test.stopTest();
    }*/

	@isTest static void CargaBandejaCasos_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.CargaBandejaCasos();
        Test.stopTest();
    }
        
     @isTest static void GetTime_Test_01()
    {
        Test.startTest();
        Time t = Time.newInstance(1, 2, 3, 4);
        CTR_UR_Bandeja_Casos_Optativos.GetTime(t);
        Test.stopTest();
    }
    
    @isTest static void busquedaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.busquedaCasosUR();
        Test.stopTest();
    }
    
    @isTest static void CargaUsuario_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.CargaUsuario();
        Test.stopTest();
    }
    
    @isTest static void inicio_Test_01()
    {
        Test.startTest();
        CTR_UR_Bandeja_Casos_Optativos controlador = new CTR_UR_Bandeja_Casos_Optativos();
        controlador.inicio();
        Test.stopTest();
    }
}