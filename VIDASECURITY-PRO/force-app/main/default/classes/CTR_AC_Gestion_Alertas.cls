/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-18-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   07-13-2021   Juan Espinoza León   Initial Version
**/
public with sharing class CTR_AC_Gestion_Alertas {
    public  Boolean Protocolo_Atencion { get; set;}

    public  Boolean Evalua_RRVV { get; set;}

    public  Boolean Postergacion_Credito { get; set;}

    public  Boolean Pago_Presencial { get; set;}

    public  Boolean Tiene_Reclamo { get; set;}

    public CTR_AC_Gestion_Alertas(ApexPages.StandardController controller){
        this.Protocolo_Atencion = true;
        this.Evalua_RRVV = false;
        this.Pago_Presencial = false;
        this.Tiene_Reclamo = false;

        String RecordTypeId_Atencion = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SObjectType = 'Case'].Id;

        if (!Test.isRunningTest()) {
            controller.addFields(new String[]{'Id', 'Postergacion_de_Credito__c', 'Cantidad_Polizas_RV_Activas__c', 'Edad_cliente__c', 'Pago_Presencial_RRVV__c'});
        }

        Account cuenta = (Account)controller.getRecord();

        //Protocolo de Atencion
        List<Case> cases_atencion = [SELECT Id FROM Case WHERE RecordTypeId =: RecordTypeId_Atencion AND Canal__c = 'Call Center' AND CreatedDate = LAST_N_DAYS:30 AND AccountId =: cuenta.Id];

        if (cases_atencion.size() > 0)
        {
            this.Protocolo_Atencion = false;
        }

        if (cuenta.Pago_Presencial_RRVV__c == true)
        {
            this.Pago_Presencial = true;
        }

        //Alerta Rentas Vitalicias - Evalua RRVV Credito
        if (cuenta.Cantidad_Polizas_RV_Activas__c > 0 && cuenta.Edad_cliente__c < 78)
        {
            this.Evalua_RRVV = true;
        }

        //Alerta postergacion de credito
        this.Postergacion_Credito = cuenta.Postergacion_de_Credito__c;

        String RecordTypeId_Reclamos = [SELECT Id FROM RecordType WHERE Name = 'Reclamos' AND SObjectType = 'Case'].Id;

        List<Case> cases_reclamos = [SELECT Id FROM Case WHERE RecordTypeId =: RecordTypeId_Reclamos AND Status NOT IN ('Basura','Cerrado (Correo Duplicado)','Cerrado (Correo Masivo)','Cerrado') AND AccountId =: cuenta.Id];

        if (cases_reclamos.size() > 0)
        {
            this.Tiene_Reclamo = true;
        }
    }
}