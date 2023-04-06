@istest public class TEST_CTR_VVC_ConsultaHistorica {
  
 @istest static void getvvclist()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.FDate = new Task();
        con.FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
        con.FDate.Fecha_de_Cierre__c = Date.today();
        con.LimitSize = 20;
        Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
        insert carga;
        con.IdCarga = carga.Id;
        con.OffsetSize = 100;
        con.getvvclist();
        Test.stopTest();
    }

    @istest static void getEstadosValeVista()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.getEstadosValeVista();
        Test.stopTest();
    }

    @istest static void getEstadosCarga()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.getEstadosCarga();
        Test.stopTest();
    }

    @istest static void getNotificaciones()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.getNotificaciones();
        Test.stopTest();
    }

    @istest static void EvaluaRutCliente()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.EvaluaRutCliente();
        Test.stopTest();
    }

    @istest static void EvaluaEstadoValeVista()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.EvaluaEstadoValeVista();
        Test.stopTest();
    }

    @istest static void EvaluaEstadoCarga()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.EvaluaEstadoCarga();
        Test.stopTest();
    }

    @istest static void EvaluaNotificacion()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.EvaluaNotificacion();
        Test.stopTest();
    }

    @istest static void LoadDetalleCarga()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
        insert carga;
        con.IdCarga = carga.Id;
        con.LoadDetalleCarga();
        Test.stopTest();
    }

    @istest static void ToHistorial()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.ToHistorial();
        Test.stopTest();
    }

    @istest static void FirstPage()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.FirstPage();
        Test.stopTest();
    }

    @istest static void previous()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 3;
        con.previous();
        Test.stopTest();
    }

   @istest static void next()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 1;
        con.next();
        Test.stopTest();
    }

    @istest static void LastPage()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.totalrecs = 100;
        con.Page = 2;        
        con.LastPage();
        Test.stopTest();
    }

    @istest static void getprev()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 1;
        con.OffsetSize = 1;
        con.getprev();
        Test.stopTest();
    }

    @istest static void getnxt()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 1;
        con.OffsetSize = 1;
        con.getnxt();
        Test.stopTest();
    }

    @istest static void search()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 1;
        con.FDate = new Task();
        con.FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
        con.FDate.Fecha_de_Cierre__c = Date.today();
        Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
        insert carga;
        con.IdCarga = carga.Id;
        con.search();
        Test.stopTest();
    }

    @istest static void cleanSearch()
    {
        Test.startTest();
        CTR_VVC_ConsultaHistorica con = new  CTR_VVC_ConsultaHistorica();
        con.Page = 1;
        con.cleanSearch();
        Test.stopTest();
    }
}