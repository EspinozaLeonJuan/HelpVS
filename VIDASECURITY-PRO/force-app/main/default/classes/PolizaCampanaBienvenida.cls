/*******************************************************************************************
 *  NOMBRE                 : PolizaCampanaBienvenida
 *  TIPO                   : CLASE APEX
 *  REQUERIMIENTO          : Campana Bienvenida masiva
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 14/10/2021 - J. GÓMEZ       - Se crean campañas de bienvenida de forma masiva
 * *****************************************************************************************/
public class PolizaCampanaBienvenida {
	public static void execute(List<Poliza__c> lstPoliza, Map<Id, Poliza__c> newMap) {
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Date hoy = Date.today();
        // Campañas
        Map<String, Campana_Vida_Security__c> campaignMap = new Map<String, Campana_Vida_Security__c>();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>();
        Set<String> CodigosProducto = new Set<String>{'1100','1160','1800','9640' ,'9660' ,'9740','9750'}; 
        for( Poliza__c poliza : lstPoliza ){
            if( poliza.Cuenta__c == null ) {
                poliza.Cuenta__c.addError('La cuenta es obligatoria.');
                continue;
            }
            // Sanatorio alemán no genera campaña bienvenida
            if( string.isNotBlank(poliza.Nombre_de_Producto__c) && 
                (poliza.Nombre_de_Producto__c.containsIgnoreCase('Cruz Sanatorio') || poliza.Nombre_de_Producto__c.containsIgnoreCase('Sanatorio Alem'))){
                continue;
            }
            if((poliza.Estatus__c == 'ANULADA')||(poliza.RecordTypeId != recordTypeIndividuales)||(poliza.Fecha_Inicio_de_Poliza__c == null)||(!CodigosProducto.contains(poliza.Codigo_de_Producto__c))){
                continue;
            }
            Integer fechaPoliza = integer.valueOf(DateTime.newInstance(poliza.Fecha_Inicio_de_Poliza__c.addMonths(6), Time.newInstance(0, 0, 0, 0)).format('yyyyMM'));
            Integer fechahoy = integer.valueOf(DateTime.newInstance(hoy, Time.newInstance(0, 0, 0, 0)).format('yyyyMM'));
            if( fechaPoliza < fechaHoy ){
                continue;
            }
            String campaignName = 'Mantención_6_Meses_' + DateTime.newInstance(poliza.Fecha_Inicio_de_Poliza__c.addMonths(6), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
            if(!campaignMap.containsKey(campaignName)){
                Date inicio = poliza.Fecha_Inicio_de_Poliza__c.addMonths(6).toStartOfMonth();
                Date fin = poliza.Fecha_Inicio_de_Poliza__c.addMonths(7).toStartOfMonth().addDays(-1);
                campaignMap.put(campaignName, new Campana_Vida_Security__c(Name = campaignName, Descripcion__c = 'Campaña de Mantención 6 Meses', Tipo_de_Campa_a__c = 'Mantención 6 Meses', Fecha_Inicio_de_Campa_a__c = inicio, Fecha_de_Termino_de_Campa_a__c = fin));
            }
            if(!accountIds.contains(poliza.Cuenta__c)){
                accountIds.add(poliza.Cuenta__c);
                if (!polizaIds.contains(poliza.Id)){
                    polizaIds.add(poliza.Id);
                }
            }
        }
        if(!campaignMap.isEmpty()){
            upsert campaignMap.values() Campana_Vida_Security__c.Name;
        }
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE Id IN :accountIds]);
        Participantes_de_Campa_a__c[] members = [SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c FROM Participantes_de_Campa_a__c WHERE Contacto__r.AccountId IN :accountIds AND Poliza__c IN :polizaIds AND RecordType.Name = 'Mantención 6 Meses' FOR UPDATE];
        Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();
        for( Participantes_de_Campa_a__c member : members ){
            currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c), member);
        }
        // Participantes de Campaña
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Mantención 6 Meses').getRecordTypeId();
        
        for( Id polizaId : polizaIds ){
            Poliza__c poliza = new Poliza__c();
            poliza = newMap.get(polizaId);
            Account account = accountMap.get(poliza.Cuenta__c);
            if( account == null || !account.isPersonAccount ){
                continue;
            } 
            String campaignName = 'Mantención_6_Meses_' + DateTime.newInstance(poliza.Fecha_Inicio_de_Poliza__c.addMonths(6), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
            Campana_Vida_Security__c campana = campaignMap.get(campaignName);
            if( campana == null ){
                poliza.addError('La Campaña Vida Security ' + campaignName + ' no existe.');
                continue;
            }
            String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
            if( currentMemberMap.containsKey(key) ){
                continue;
            }
            Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                Name = 'MANTENCIÓN 6 MESES: ' + DateTime.newInstance(poliza.Fecha_Inicio_de_Poliza__c.addMonths(6), Time.newInstance(0, 0, 0, 0)).format('MMyyyy')+ ' ' + account.Name,
                Campa_a_Vida_Security__c = campana.Id,
                Contacto__c = account.PersonContactId,
                Contactado__c = 'No',
                Estado_Cierre__c= 'Abierto',
                Nombre_de_Contacto__c = account.Name,
                Poliza__c = poliza.Id,
                OwnerId = account.OwnerId,
                Cuenta__c = account.Id,
                RecordTypeId = recordId);
            currentMemberMap.put(key, participante);
            members.add(participante);
        }
        upsert members;
        // Pólizas de participantes de campaña
        List<Poliza_de_Participante_de_Campana__c> ppcs = new List<Poliza_de_Participante_de_Campana__c>();
        for( Id polizaId : polizaIds ){
            Poliza__c poliza = new Poliza__c();
            poliza = newMap.get(polizaId);
            Account account = accountMap.get(poliza.Cuenta__c);
            if( account == null || !account.IsPersonAccount ){
                continue;
            }
            String campaignName = 'Mantención_6_Meses_' + DateTime.newInstance(poliza.Fecha_Inicio_de_Poliza__c.addMonths(6), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
            Campana_Vida_Security__c campana = campaignMap.get(campaignName);
            if( campana == null ){
                continue;
            }
            String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
            Participantes_de_Campa_a__c participante = currentMemberMap.get(key);
            String codigo = String.valueOf(campana.Id) + String.valueOf(account.PersonContactId) + String.valueOf(poliza.Id);
            Poliza_de_Participante_de_Campana__c ppc = new Poliza_de_Participante_de_Campana__c(Codigo__c = codigo, Poliza__c = poliza.Id, Participante_de_Campana__c = participante.Id);
            ppcs.add(ppc);
        }
        if(!ppcs.isEmpty()){
            upsert ppcs Poliza_de_Participante_de_Campana__c.Codigo__c;
        }
    }
}