/*******************************************************************************************
*  NOMBRE                : Alex Coillo alex.coillo@latitudde.com
*  TIPO                  : APEX CLASS
*  REQUERIMIENTO         : Campaña AMAC
* 
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 22/02/2022 - Alex Coillo       - Creación Clase
* *****************************************************************************************/


public class CreaParticipantesAMAC {
  public static Id getAccountIdAMAC(Account accountNew, Account accountOld, Set<Id> accountsIds ){
    
    Set<Id> idsOmitidos = new Set<Id>{'005i0000000ij3TAAQ', '0050H00000A2r2tQAB', '005i0000004xhHpAAI', '0050H00000B7a0LQAR'};
    
    if (accountOld != null && 
        ( accountOld.OwnerId != accountNew.OwnerId  || ( accountOld.Sincronizar_Ejecutivo__c == false && accountNew.Sincronizar_Ejecutivo__c == true ) || ( accountOld.Sincronizar_Ejecutivo__c == true && accountNew.Sincronizar_Ejecutivo__c == true && accountNew.ultima_actualizacion_amac__c != null && ( ( accountNew.ultima_actualizacion_amac__c.getTime() - accountOld.ultima_actualizacion_amac__c.getTime() ) > 60000 ) ) ) &&
        !accountsIds.contains(accountNew.Id ) && 
        (accountOld.Estado_Agente__c == 'Desvinculado' || accountOld.Estado_Agente__c == 'Cambio de Cargo') && 
        !idsOmitidos.contains(accountNew.OwnerId) && 
        accountOld.Participa_Campaign_Amac__c == false &&
        accountNew.IsPersonAccount == true ){
        return accountNew.Id;
    }
    return null;
  }

  public static void execute( Set<Id> accountsIds ){

    if (!accountsIds.isEmpty() && accountsIds != null) {

      Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña AMAC'].Id;
      Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('AMAC').getRecordTypeId();
      Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
      Account[] cuentas = [SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE id IN :accountsIds AND Participa_Campaign_Amac__c = false AND owner.isactive = true AND owner.Ejecutivo_de_Cliente__c = true ];
      Participantes_de_Campa_a__c[] members = new Participantes_de_Campa_a__c[]{};
      
      if (!cuentas.isEmpty()) {
        for (Account accountsUpdate : cuentas) {
          system.debug('@@@@ se crea participante');
          Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
            Name = 'Campaña AMAC - ' + accountsUpdate.Name,
            Campa_a_Vida_Security__c = idCampana,
            OwnerId = accountsUpdate.OwnerId,
            Contacto__c = accountsUpdate.PersonContactId,
            Cuenta__c = accountsUpdate.Id,
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
      {
        upsert ppcs Poliza_de_Participante_de_Campana__c.Codigo__c;
      }
      
    }
  }
}