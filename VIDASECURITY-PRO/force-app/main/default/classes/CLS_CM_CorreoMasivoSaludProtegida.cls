/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-19-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   05-22-2021   Juan Espinoza León   Initial Version
**/
global class CLS_CM_CorreoMasivoSaludProtegida Implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Salud Protegida'].Id;
         system.debug('@@@@ RecordTypeId 2 '+ RecordTypeId);

        List<Lead> leads =[ SELECT Id, Email FROM Lead WHERE SP_Correo_Masivo__c = false  AND RecordTypeId =: RecordTypeId AND 
                           Lead.Sub_Estado__c != 'Contratante de póliza original' AND Lead.Sub_Estado__c != 'Asegurado' AND Lead.Sub_Estado__c != 'Molesto con la compañía' AND Lead.Sub_Estado__c != 'No Contesta, inubicable' AND Lead.Sub_Estado__c != 'No le interesa' AND Lead.Sub_Estado__c != 'No reúne condiciones' AND Lead.Sub_Estado__c != 'No tiene medio de pago' AND Lead.Sub_Estado__c != 'Persona falleció' AND Lead.Sub_Estado__c != 'Pide no volver a llamar' AND Lead.Sub_Estado__c != 'Teléfono Malo' AND Lead.Sub_Estado__c != 'Cierre de campaña automático' LIMIT 100];
		system.debug('@@@@ leads 1 '+ leads);
       
        if (leads.size() > 0)
        {
            for (Lead lead : leads)
            {               
                try
                {//actualiza informacion de prospecto y genera envio de correo correspondiente
                    BAT_CM_SP_CorreoMasivo j_MConco = new BAT_CM_SP_CorreoMasivo(lead.Id);
                    Id IdJobs = Database.executeBatch(j_MConco, 1);
                }
                catch(System.Exception ex){
                    System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
                }
            }
        }
    }

}