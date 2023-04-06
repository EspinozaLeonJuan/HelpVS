/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_ValidarDocs {
    public class Input{
        @InvocableVariable(required=True)
        public String idMessage;
    }

    public class Output{
        @InvocableVariable(required=true)
        public boolean OutputBol;
    }

    @InvocableMethod(label='Reembolso_ValidarDocs ')
    public static List<Output> ValidarDoc(List<Input> intro){

        List<Output> contOut= new List<Output>();
        Output contad = new Output();

        boolean valido = false;
        String idMessage = intro[0].idMessage;

        List<ContentDocumentLink> contDocumentList = [SELECT Id, ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.LatestPublishedVersion.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: idMessage];

        system.debug('@@@@ size --> '+contDocumentList.size());

        if(contDocumentList.size() > 0){
           valido = true;
        }

        MessagingSession ms = [SELECT Id, Documentos_asociados__c, Etapa_Reembolso__c  FROM MessagingSession WHERE Id =: idMessage];

        ms.Documentos_asociados__c = contDocumentList.size();
        ms.Etapa_Reembolso__c = 5;

        update ms;

        contad.OutputBol = valido;
        contOut.add(contad);

        return contOut;
    }
}