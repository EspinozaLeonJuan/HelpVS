/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 06-17-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   06-11-2021   Juan Espinoza León   Initial Version
**/
public class CLS_INV_SP_ActualizaProspecto_Poliza {
    @InvocableMethod 
    public static void ActualizaDatos (List<String> RUTs)
    {
        try 
        {
            String RecordTypeId_Lead = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Salud Protegida'].Id;

            Lead lead = [SELECT Id, PROSP_Carga_RUT__c, NPOL_Numero__c, NPOL_Intermediario__c, NPOL_RUT_Contratante__c, NPOL_Contratante__c, NPOL_Fecha_Inicio_de_Vigencia__c, NPOL_Forma_de_Pago__c
            FROM Lead WHERE PROSP_Carga_RUT__c =: RUTs[0] AND RecordTypeId =: RecordTypeId_Lead];//AND Status = 'Contrata'];

            String RecordTypeId_Poliza = [SELECT Id FROM RecordType WHERE Name = 'Individuales' AND SObjectType = 'Poliza__c'].Id;

            Poliza__c poliza = [SELECT Id, Name, Intermediario__c, Rut_Contratante__c, Cuenta__r.Name, Fecha_Inicio_de_Vigencia__c, Forma_de_Pago__c, Fecha_Inicio_de_Poliza__c 
                                FROM Poliza__c WHERE RecordTypeId =: RecordTypeId_Poliza AND Rut_Asegurado__c =: lead.PROSP_Carga_RUT__c AND Codigo_de_Producto__c = '7400'];

            lead.NPOL_Numero__c = poliza.Name;
            lead.NPOL_Intermediario__c = poliza.Intermediario__c;
            lead.NPOL_RUT_Contratante__c = poliza.Rut_Contratante__c;
            lead.NPOL_Contratante__c = poliza.Cuenta__r.Name;
            //lead.NPOL_Fecha_Inicio_de_Vigencia__c = poliza.Fecha_Inicio_de_Vigencia__c;
            lead.NPOL_Fecha_Inicio_de_Vigencia__c = poliza.Fecha_Inicio_de_Poliza__c;
            lead.NPOL_Forma_de_Pago__c = poliza.Forma_de_Pago__c;

            update lead;   
            
        } catch (Exception ex) {
            system.debug('@@@@ ERROR --> '+ex);
            system.debug('@@@@ line --> '+ex.getLineNumber());
        }
             
    }
}