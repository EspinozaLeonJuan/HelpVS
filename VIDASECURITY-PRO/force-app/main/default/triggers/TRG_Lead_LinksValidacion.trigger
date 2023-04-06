/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-25-2022
 * @last modified by  : Juan Espinoza León
**/
trigger TRG_Lead_LinksValidacion on Lead  (before update) {
     if(Trigger.isUpdate && Trigger.isBefore){

        String recordTypeId_Lead_Links =  Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').recordtypeid;

        String recordTypeId_Poliza_Individuales =  Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').recordtypeid;

        for(Lead lead :  Trigger.new){

            if (lead.RecordTypeId == recordTypeId_Lead_Links)
            {
                if(lead.Status == 'Habilitado'){
                    if (lead.Tipo_Base__c.toUppercase() != 'BASES BI')
                    {
                        List<Account> accounts = [SELECT Id FROM Account WHERE RUT__c =: lead.PROSP_Carga_RUT__c];

                        if (accounts.size() > 0)
                        {
                            Integer polizas_Vig = [SELECT COUNT() FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND RecordTypeId =: recordTypeId_Poliza_Individuales AND Cuenta__c =: accounts[0].Id];

                            system.debug('@@@@ polizas_Vig --> '+polizas_Vig);
                            if (polizas_Vig > 0)
                            {
                                lead.addError('Existe una Cuenta creada con anterioridad, la cual ya posee una poliza Individual en Estado Activa');
                            }
                        }
                    }
                }
            }

        }
    }
}