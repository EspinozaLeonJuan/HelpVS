/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 02-10-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-10-2021   Juan Espinoza León   Initial Version
**/
@istest
public with sharing class TEST_CTR_LINK_NotificacionManual {
    @isTest static void SendEmail()
    {
        Test.startTest();
       
        String recordTypeLink = [SELECT Id FROM RecordType WHERE Name = 'Venta - Link'].Id;

        Opportunity op = new Opportunity(
            Name = 'Opportunity ',
            StageName = 'Asignación',
            Fecha_Entrevista__c = System.today(),
            Direccion__c = 'RAMON CARNICER 1924',
            Renta__c = 1200000,
            RecordTypeId = recordTypeLink,
            Telefono_activo__c = '942332571',
            agente_asignado__c = true,
            Observacion__c = 'SE GENERA OBSERVACION',
            Link_Auditado__c = true,
            CloseDate = System.today(),
            Codigo_de_Link__c = 123
        );

        insert op;

        ApexPages.StandardController standard = new ApexPages.StandardController(op);
        CTR_LINK_NotificacionManual controlador = new CTR_LINK_NotificacionManual(standard);

        ApexPages.currentPage().getParameters().put('Id', op.Id);
       
        controlador.sendEmail();
        Test.stopTest();
    }
}