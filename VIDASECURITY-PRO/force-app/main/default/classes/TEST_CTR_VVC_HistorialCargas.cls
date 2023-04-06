@istest
public class TEST_CTR_VVC_HistorialCargas {

    @istest static void ListadoCargas()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.ListadoCargas();
        Test.stopTest();
    }

    @istest static void getcvvlist()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.FDate = new Task();
        con.FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
        con.FDate.Fecha_de_Cierre__c = Date.today();
        con.getcvvlist();
        Test.stopTest();
    }

   @istest static void NuevaCargaDatos()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.NuevaCargaDatos();
        Test.stopTest();
    }

   @istest static void ToDetalleCarga()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.ToDetalleCarga();
        Test.stopTest();
    }

    @istest static void ToConsultaHistorica()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.ToConsultaHistorica();
        Test.stopTest();
    }

    @istest static void FirstPage()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.FirstPage();
        Test.stopTest();
    }

    @istest static void previous()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 3;
        con.previous();
        Test.stopTest();
    }

   @istest static void next()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 1;
        con.next();
        Test.stopTest();
    }

    @istest static void LastPage()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.totalrecs = 100;
        con.Page = 2;        
        con.LastPage();
        Test.stopTest();
    }

    @istest static void getprev()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 1;
        con.OffsetSize = 1;
        con.getprev();
        Test.stopTest();
    }

    @istest static void getnxt()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 1;
        con.OffsetSize = 1;
        con.getnxt();
        Test.stopTest();
    }

    @istest static void search()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 1;
        con.FDate = new Task();
        con.FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
        con.FDate.Fecha_de_Cierre__c = Date.today();
        con.search();
        Test.stopTest();
    }

    @istest static void cleanSearch()
    {
        Test.startTest();
        CTR_VVC_HistorialCargas con = new  CTR_VVC_HistorialCargas();
        con.Page = 1;
        con.cleanSearch();
        Test.stopTest();
    }
}