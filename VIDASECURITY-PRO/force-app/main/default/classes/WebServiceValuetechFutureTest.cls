@isTest
private class WebServiceValuetechFutureTest {
    @isTest static void test1() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // System.runAs() allows mixed DML operations in test context
       //   WebServiceValuetechFuture.WebServiceValuetechFuture(token, upload.Id, upload.Archivador, content, xmlIndex, upload.Extension, upload.fileName, upload.CodigoAdjunto, upload.Documento);
        String Token = ''; 
    String IdTransaccion = 'a1d8H000000DCN0QAO'; 
    String Archivador = ''; 
    String Content = ''; 
    String XmlIndex = ''; 
    String Extension = ''; 
    String fileName = '';
    String CodigoAdjunto = '';
    String Documento = '';
        
        System.runAs(thisUser) {
            // startTest/stopTest block to run future method synchronously
            Test.startTest();        
            WebServiceValuetechFuture.WebServiceValuetechFuture(Token, IdTransaccion, Archivador, Content, XmlIndex, Extension, fileName, CodigoAdjunto, Documento);
            Test.stopTest();
        }
        // The future method will run after Test.stopTest();
    }
}