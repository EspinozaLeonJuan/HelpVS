@istest
public class TEST_CTR_VVC_GestionCarga {
    
    @istest static void importCSVFile_01()
    {
        Test.startTest();
        CTR_VVC_GestionCarga carga = new  CTR_VVC_GestionCarga();
        string x = 'Rut,Monto,Fecha Vale Vista,Empresa,Tipo\n'+
                  '13005866-3,17400,28-04-2019,VIDA,PENDIENTE\n'+
                  '8100357-2,22500,20-12-2018,VIDA,CADUCADO';

        carga.csvFileBody = Blob.valueOf(x);

        carga.importCSVFile();
        Test.stopTest();
    }

    @istest static void importCSVFile_02()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();

        string x = 'Rut,Monto,Fecha Vale Vista,Empresa,Tipo\n'+
                  '13005-3,17400,28-04-2019,VIDA,PENDIENTE\n'+
                  '8100357-2,2wqwq,20-12-2018,VIDA,CADUCADO';

        con.csvFileBody = Blob.valueOf(x);

        con.importCSVFile();
        Test.stopTest();
    }

    @istest static void CreateNewUpload()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();
     
        con.CreateNewUpload();
        Test.stopTest();
    }

    @istest static void RefreshTotalCarga()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();
        Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
        insert carga;

        con.RefreshTotalCarga(carga.Id, 120, 110, 10);
        Test.stopTest();
    }

    @istest static void ProcessUpload()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();
        Registro_Vale_Vista__c vvcObj = new Registro_Vale_Vista__c() ;
        vvcObj.RUT__c =  '13005866-3';
        vvcObj.Monto__c = 17400;
        vvcObj.Fecha_Vale_Vista__c = date.newInstance(2019, 4, 28);
        vvcObj.Empresa__c = 'VIDA';
        vvcObj.Tipo__c = 'CADUCADO';
        con.vvclist.add(vvcObj);

        con.ProcessUpload();
        Test.stopTest();
    }

    @istest static void CancelUpload()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();
        con.CancelUpload();
        Test.stopTest();
    }
    
    @istest static void ToHistorial()
    {
        Test.startTest();
        CTR_VVC_GestionCarga con = new  CTR_VVC_GestionCarga();
        con.ToHistorial();
        Test.stopTest();
    }
    

}