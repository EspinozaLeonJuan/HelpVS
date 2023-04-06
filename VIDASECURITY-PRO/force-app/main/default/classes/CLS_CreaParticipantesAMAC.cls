/*******************************************************************************************
*  NOMBRE                : CLS_CreaParticipantesAMAC
*  TIPO                  : APEX CLASS
*  REQUERIMIENTO         : Campaña AMAC
* 
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 10/12/2018 - I. SALAZAR       - Creación Clase
*  1.0     - 22/02/2022 - A. Coillo        - Update Query ( Clase inactiva )
* *****************************************************************************************/
public class CLS_CreaParticipantesAMAC implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        executeFuture();
    }
    
    @future (callout=true)
    public static void executeFuture() {
        Date myDate = Date.today();
       
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña AMAC'].Id;
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('AMAC').getRecordTypeId();
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        
        Account[] cuentas = [SELECT Id, Name, OwnerId FROM Account WHERE Fecha_Ultimo_Cambio_Propietario__c IN (TODAY) AND (Estado_Agente__c = 'Desvinculado' OR Estado_Agente__c = 'Cambio de Cargo') AND OwnerId NOT IN ('005i0000000ij3TAAQ', '0050H00000A2r2tQAB', '005i0000001O3jzAAC', '005i0000002QaKSAA0', '005i0000001O3jGAAS', '005i0000004xhHpAAI') AND (Agente_Actual__r.Estado__c = 'Desvinculado' OR Agente_Actual__r.Estado__c = 'Cambio de Cargo' ) AND Agente_Actual__r.LastModifiedDate IN (TODAY) AND Participa_Campaign_Amac__c = false];
        //Account[] cuentas = [SELECT Id, Name, OwnerId FROM Account WHERE Fecha_Ultimo_Cambio_Propietario__c IN (TODAY) AND Estado_Agente__c = 'Desvinculado' AND OwnerId NOT IN ('005i0000000ij3TAAQ', '0050H00000A2r2tQAB', '005i0000001O3jzAAC', '005i0000002QaKSAA0', '005i0000001O3jGAAS', '005i0000004xhHpAAI') AND Agente_Actual__r.Estado__c = 'Desvinculado' AND Agente_Actual__r.LastModifiedDate IN (TODAY) AND Participa_Campaign_Amac__c = false];
        Account[] cuentas2 = new Account[]{};

        for (Account cuenta : cuentas) {
            if (!accountIds.contains(cuenta.Id)) {
                accountIds.add(cuenta.Id);
                Account cuenta1 = new Account(
                    Id = cuenta.Id,
                    Participa_Campaign_Amac__c = true
                );
                
                cuentas2.add(cuenta1);		
            }
        }        
            
        Participantes_de_Campa_a__c[] members = [SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Cuenta__c, Comentarios_PAT__c FROM Participantes_de_Campa_a__c WHERE Cuenta__c IN :accountIds AND RecordTypeId = :recordId FOR UPDATE];
        Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE Id IN :accountIds]);
        
        for (Participantes_de_Campa_a__c member : members) {
            currentMemberMap.put(String.valueOf(member.Cuenta__c) + '|' + 'Campaña AMAC', member);
        }
        
        for (Id accountId : accountIds) {
            Account account = accountMap.get(accountId);
            
            if (account == null || !account.isPersonAccount) continue;
            
            String key = String.valueOf(account.Id) + '|' + 'Campaña AMAC';
            
            if (currentMemberMap.containsKey(key)) {
                //Se actualiza participante de campaña
                system.debug('@@@@ se actualiza participante');
                Participantes_de_Campa_a__c participanteCurrent = currentMemberMap.get(key);
                Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                    OwnerId = account.OwnerId,
                    Id = participanteCurrent.Id);
                
                members.add(participante);
            } else {
                //Se crea participante de campaña
                system.debug('@@@@ se crea participante');
                Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                    Name = 'Campaña AMAC - ' + account.Name,
                    Campa_a_Vida_Security__c = idCampana,
                    OwnerId = account.OwnerId,
                    Contacto__c = account.PersonContactId,
                    Cuenta__c = account.Id,
                    RecordTypeId = recordId);
                
                members.add(participante);
            }
        }
        
        upsert members;

        List<Poliza_de_Participante_de_Campana__c> ppcs = new List<Poliza_de_Participante_de_Campana__c>();

        for (Participantes_de_Campa_a__c par : members) {
            Poliza__c[] polizas = [SELECT Id, Name FROM Poliza__c WHERE Cuenta__c = :par.Cuenta__c AND RecordTypeId = :recordTypeIndividuales AND Estatus__c = 'ACTIVA'];
            
            for (Poliza__c poliza : polizas) {
                String codigo = String.valueOf(idCampana) + String.valueOf(account.Id) + String.valueOf(poliza.Id);
                Poliza_de_Participante_de_Campana__c ppc = new Poliza_de_Participante_de_Campana__c(Codigo__c = codigo, Poliza__c = poliza.Id, Participante_de_Campana__c = par.Id);
                ppcs.add(ppc);
            }            
        }

        if (!ppcs.isEmpty())
            upsert ppcs Poliza_de_Participante_de_Campana__c.Codigo__c;  


        upsert cuentas2;     
    }
}