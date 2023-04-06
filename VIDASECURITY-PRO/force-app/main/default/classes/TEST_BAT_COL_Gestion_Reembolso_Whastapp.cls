/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-05-2022
 * @last modified by  : Juan Espinoza León
**/
@istest
public class TEST_BAT_COL_Gestion_Reembolso_Whastapp {
    @istest (seealldata=true)
    static void go() {


       List<MessagingSession> MessagingSe =[SELECT Id, Name, CreatedDate, StartTime, EndTime, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c FROM MessagingSession];

       // inpu.numR = '20128221';
       // inpu.remitt = 'AMBUL20214441122';
       // inpu.idMessaging = MessagingSe[0].Id;
       // inpu.token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFkbWluIiwibmJmIjoxNjQ5OTAyOTM2LCJleHAiOjE2NDk5MDQ3MzYsImlhdCI6MTY0OTkwMjkzNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo0OTIyMCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDkyMjAifQ.n_KyOv3_iSvji9CSoNk8xJ66V8M_TZ3mOD8arpoKw-E';
       // inpuList.add(inpu);

       Test.startTest();
       /*Test.setMock(HttpCalloutMock.class, new EBV_GestorDocumentalMock());
       output = EBV_GestorDocumental.EnviarDocumentos(inpuList);*/
       MessagingSe[0].Vass_Remesa__c = 'AMBUL20214441122';
       MessagingSe[0].Numero_Denuncio__c = '20128221';
       BAT_COL_Gestion_Reembolso_Whastapp  batch = new BAT_COL_Gestion_Reembolso_Whastapp (MessagingSe[0].Id);
       Id batchId = Database.executeBatch(batch);
       Test.stopTest();
    }


    @istest (seealldata=true)
    static void getDenuncio() {


       List<MessagingSession> MessagingSe =[SELECT Id, Name, CreatedDate, StartTime, EndTime, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c FROM MessagingSession];

       // inpu.numR = '20128221';
       // inpu.remitt = 'AMBUL20214441122';
       // inpu.idMessaging = MessagingSe[0].Id;
       // inpu.token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFkbWluIiwibmJmIjoxNjQ5OTAyOTM2LCJleHAiOjE2NDk5MDQ3MzYsImlhdCI6MTY0OTkwMjkzNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo0OTIyMCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDkyMjAifQ.n_KyOv3_iSvji9CSoNk8xJ66V8M_TZ3mOD8arpoKw-E';
       // inpuList.add(inpu);

       Test.startTest();
       /*Test.setMock(HttpCalloutMock.class, new EBV_GestorDocumentalMock());
       output = EBV_GestorDocumental.EnviarDocumentos(inpuList);*/
       MessagingSe[0].Vass_Remesa__c = 'AMBUL20214441122';
       MessagingSe[0].Numero_Denuncio__c = '20128221';

       BAT_COL_Gestion_Reembolso_Whastapp.GetDenuncio(MessagingSe[0].Id);

       Test.stopTest();
    }

}