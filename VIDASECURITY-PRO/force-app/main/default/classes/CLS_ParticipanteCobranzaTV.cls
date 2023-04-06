/*******************************************************************************************
 *  NOMBRE                 : CLS_ParticipanteCobranzaTV
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO COBRANZA TELEVENTA
 *  DESCRIPCION            : Clase para crear participantes
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 03/04/2019 - I.S              - Creación Clase
 * 	1.0     - 03/04/2019 - S.A              - Modificación de filtros
 *  1.1     - 26/11/2019 - F.M              - Creación de nuevos participantes
 *  1.2     - 20/01/2020 - F.M              - Corrección creación de nuevos participantes
 *  1.3     - 27/01/2020 - F.M              - Se quita update a participantes, para que no cambie el estado
 *  1.4		- 14/05/2020 - S.A              - Se quita condición de ciudad Santiago 
 * *****************************************************************************************/

public class CLS_ParticipanteCobranzaTV implements TriggerHandler.HandlerInterface {
    public void handle() {
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>();
        Set<String> TIPOPROD = new Set<String>{'Seguro de Salud','Seguro de Vida','57','Flexibles','APV','Patrimonial','Valor Garantizado'};
        Set<String> AHORRO = new Set<String>{'Con Ahorro', 'Sin Ahorro'};
        Date lastYear = Date.today().addMonths(-12);

        for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
            system.debug('@@@@ CAMPAÑA TV');
            
            if (string.isBlank(poliza.Con_o_Sin_Ahorro__c) || string.isBlank(poliza.Frecuencia_de_Pago__c))
                continue;
            
            if (poliza.Con_o_Sin_Ahorro__c == 'Sin Ahorro')
                continue;
            
            if(poliza.RecordTypeId != recordTypeIndividuales)
                continue;

            if(poliza.Posee_Depositos_Esporadicos__c == true)
                continue;
            
            if(poliza.Frecuencia_de_Pago__c == 'U')
                continue;
            
            if (!Test.isRunningTest()) {
                if(!TIPOPROD.contains(poliza.Tipo_Producto__c))
                    continue;
            }
            
            if (poliza.N_Meses_Vigencia__c < 5)
                continue;
            
            if (!accountIds.contains(poliza.Cuenta__c)) {
                accountIds.add(poliza.Cuenta__c);
                if (!polizaIds.contains(poliza.Id))
                    polizaIds.add(poliza.Id);
            }
        }

        system.debug('@@@@ accountIds' + accountIds);
        system.debug('@@@@ polizaIds' + polizaIds);

        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;       
		system.debug('@@@@ lastYear ' + lastYear);
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId, Fecha_Ultimo_Rescate__c FROM Account WHERE Id IN :accountIds AND (Estado_Agente__c = 'Vigente' OR Estado_Agente__c = '') AND Owner.CommunityNickname = 'sfvida' AND ((Fecha_Ultimo_Rescate__c < :lastYear) OR Fecha_Ultimo_Rescate__c  = NULL) AND ((Fecha_Ultimo_Reclamo__c < :lastYear) OR Fecha_Ultimo_Reclamo__c = NULL) AND ((Fecha_Ultima_Reunion__c < LAST_N_MONTHS:6) OR Fecha_Ultima_Reunion__c= NULL)]);
        system.debug('@@@@ accountMap' + accountMap);
        //Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId, Fecha_Ultimo_Rescate__c FROM Account WHERE (Estado_Agente__c = 'Vigente' OR Estado_Agente__c = '') AND Owner.CommunityNickname = 'sfvida']);		
        
        Participantes_de_Campa_a__c[] members = [SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, CreatedDate, Comentario__c FROM Participantes_de_Campa_a__c WHERE Contacto__r.AccountId IN :accountIds AND Poliza__c IN :polizaIds AND RecordType.Name = 'Cobranzas Televenta'];//;AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice')];
        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};
        Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();
        system.debug('@@@@ members ' + members);
        for (Participantes_de_Campa_a__c member : members) {
            currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c) + '|COBRTV', member);
        }
        system.debug('@@@@ currentMemberMap ' + currentMemberMap);
        // Participantes de Campaña
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
        Id colaTeleventa = [SELECT Id FROM Group WHERE DeveloperName = 'Televenta' AND Type = 'Queue'].Id;
        String prioridad;
        String estadoCierre;
        String comentarioCierre = '';
        system.debug('@@@@ Comienza Ciclo');
        for (Id polizaId : polizaIds) {
            Poliza__c poliza = (Poliza__c) Trigger.newMap.get(polizaId);
            Account account = accountMap.get(poliza.Cuenta__c);
            
            Date hoy = Date.today(); 
            String periodo = String.valueOf(hoy.year()) + String.valueOf(hoy.month());
            prioridad = '';
            
            system.debug('@@@@ poliza ' + poliza);
            system.debug('@@@@ account ' + account);
            
            if (account == null || !account.isPersonAccount) continue;
            
            String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id) + '|COBRTV';
            
            system.debug('@@@@ANTES DE IF');
            
            if (poliza.Cantidad_de_Meses_Sin_Pago__c > 0) {
                
                system.debug('@@@@ Cantidad de Meses Sin Pago: ' + poliza.Cantidad_de_Meses_Sin_Pago__c);
                system.debug('@@@@ Con_o_Sin_Ahorro__c: ' + poliza.Con_o_Sin_Ahorro__c);
                system.debug('@@@@ Valor_Poliza__c: ' + poliza.Valor_Poliza__c);
                system.debug('@@@@ Prima_Minima__c: ' + poliza.Prima_Minima__c);
                system.debug('@@@@ Frecuencia_de_Pago__c: ' + poliza.Frecuencia_de_Pago__c);
                system.debug('@@@@ Valor_Poliza__c: ' + poliza.Valor_Poliza__c);
                
                if (poliza.Con_o_Sin_Ahorro__c == 'Con Ahorro') {
                    if (poliza.Valor_Poliza__c <= 2 * poliza.Prima_Minima__c && poliza.Cantidad_de_Meses_Sin_Pago__c >= 4 && poliza.N_Meses_Vigencia__c > 4) {
                        prioridad = '1';
                    } else if(poliza.Frecuencia_de_Pago__c == 'M') {
                        if(poliza.Cantidad_de_Meses_Sin_Pago__c >= 4 && poliza.Cantidad_de_Meses_Sin_Pago__c <= 12 && poliza.N_Meses_Vigencia__c > 4) {
                            prioridad = '2';
                        } else if (poliza.Cantidad_de_Meses_Sin_Pago__c >= 13) {
                            prioridad ='3';
                        } /*else {
                            continue;
                        }*/
                    } else if(poliza.Frecuencia_de_Pago__c == 'T') {
                        if(poliza.Cantidad_de_Meses_Sin_Pago__c >= 5 && poliza.Cantidad_de_Meses_Sin_Pago__c <=18){
                            prioridad = '2';                       
                        } else if (poliza.Cantidad_de_Meses_Sin_Pago__c >= 19) {
                            prioridad = '3';
                        } /*else {
                            continue;
                        }*/
                    } else if(poliza.Frecuencia_de_Pago__c == 'S') {
                        if(poliza.Cantidad_de_Meses_Sin_Pago__c >=8 && poliza.Cantidad_de_Meses_Sin_Pago__c <=24){
                            prioridad = '2';
                        } else if (poliza.Cantidad_de_Meses_Sin_Pago__c >= 25) {
                            prioridad = '3';
                        } /*else {
                            continue;
                        } */
                    } else if(poliza.Frecuencia_de_Pago__c == 'A') {
                        if(poliza.Cantidad_de_Meses_Sin_Pago__c >= 14 && poliza.Cantidad_de_Meses_Sin_Pago__c <=30){
                            prioridad = '2';
                        } else if (poliza.Cantidad_de_Meses_Sin_Pago__c >= 31) { 
                            prioridad = '3';
                        } /*else {
                            continue;
                        } */
                    }                
				} 
                system.debug('@@@@ prioridad: ' + prioridad);
            }
            
            Participantes_de_Campa_a__c participante = null;
            system.debug('@@@@ currentMemberMap2 ' + currentMemberMap);
            system.debug('@@@@ key ' + key);
            if (currentMemberMap.containsKey(key)) {
				Participantes_de_Campa_a__c p = currentMemberMap.get(key);
                if (p.Estado_Cierre__c == 'Finalizado' && p.Comentario__c == 'Finalizado recaudando normalmente') {
					system.debug('@@@@ Estado Finalizado y recaudando normalmente');
					if (poliza.Estatus__c == 'ACTIVA' && poliza.Cantidad_de_Meses_Sin_Pago__c > 0 && !string.isBlank(prioridad) ) {
						system.debug('@@@@ Cumple las condiciones para crear nuevamente el participante');
						participante = new Participantes_de_Campa_a__c(
							Name = 'Cobranzas Televenta: ' + account.Name + ' ' + poliza.Name + ' - ' + periodo,
							Campa_a_Vida_Security__c = idCampana,
							Contacto__c = account.PersonContactId,
							Estado_Cierre__c= 'Abierto',
							Nombre_de_Contacto__c = account.Name,
							Poliza__c = poliza.Id,
							OwnerId = colaTeleventa,
							Cuenta__c = account.Id,
							RecordTypeId = recordId,
							Prioridad_en_Campa_a__c = prioridad
						);
						system.debug('@@@@ Participante nuevamente' + participante);
						members2.add(participante);						
					}
				}
            }
            else if (poliza.Estatus__c == 'ACTIVA' && poliza.Cantidad_de_Meses_Sin_Pago__c > 0 && !string.isBlank(prioridad) ) {
                participante = new Participantes_de_Campa_a__c(
                    Name = 'Cobranzas Televenta: ' + account.Name + ' ' + poliza.Name + ' - ' + periodo,
                    Campa_a_Vida_Security__c = idCampana,
                    Contacto__c = account.PersonContactId,
                    Estado_Cierre__c= 'Abierto',
                    Nombre_de_Contacto__c = account.Name,
                    Poliza__c = poliza.Id,
                    OwnerId = colaTeleventa,
                    Cuenta__c = account.Id,
                    RecordTypeId = recordId,
                    Prioridad_en_Campa_a__c = prioridad
                );
                members2.add(participante);
            }
                
            currentMemberMap.put(key, participante);      		
        }
	
        if (!members2.isEmpty())
            upsert members2;
	}
}