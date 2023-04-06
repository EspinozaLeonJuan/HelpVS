/*******************************************************************************************
 *  NOMBRE                 : CLS_ParticipanteCobranzaPV
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO COBRANZA POSTVENTA
 *  DESCRIPCION            : Clase que es llamada a través de PolizaTrigger
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 24/01/2019 - I.S/S.A          - Creación Clase
 *  1.1     - 12/03/2019 - I.S              - Modificación de filtros
 *  1.2		- 02/07/2019 - I.S				- Modificación de filtros solicitados por CARO.
 *  1.3		- 02/02/2020 - I.S				- Creación Nuevos Participantes
 * *****************************************************************************************/
public class CLS_ParticipanteCobranzaPV implements TriggerHandler.HandlerInterface {
    public void handle(){
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>();
        for(Poliza__c poliza : (Poliza__c[])Trigger.new){
            
            if(poliza.Cuenta__c == null){
                poliza.Cuenta__c.addError('La cuenta es obligatoria.');
                continue;
            }
            
            if(string.isBlank(poliza.Con_o_Sin_Ahorro__c) || string.isBlank(poliza.Frecuencia_de_Pago__c))
                continue;
            
            if(poliza.RecordTypeId != recordTypeIndividuales)
                continue;
            
            if(poliza.Frecuencia_de_Pago__c == 'U')
                continue;
            
            if(poliza.N_Meses_Vigencia__c < 3)
                continue;
            
            if(!accountIds.contains(poliza.Cuenta__c)){
                accountIds.add(poliza.Cuenta__c);
                if(!polizaIds.contains(poliza.Id))
                    polizaIds.add(poliza.Id);
            }            
        }
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas PV'].Id;
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE Id IN :accountIds AND Owner.Ejecutivo_de_Cliente__c = true]);
        
        Participantes_de_Campa_a__c[] members = [SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, Prioridad_en_Campa_a__c, CreatedDate
                                                 FROM Participantes_de_Campa_a__c 
                                                 WHERE Contacto__r.AccountId IN :accountIds AND 
                                                 	   Poliza__c IN :polizaIds AND 
                                                       RecordType.Name = 'Cobranzas PV' 
                                                 ORDER BY CreatedDate];
        
        Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();       
        for(Participantes_de_Campa_a__c member : members)
            currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c), member);
        
        Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};
        
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();

        for(Id polizaId : polizaIds){
           	
            Poliza__c poliza = (Poliza__c) Trigger.newMap.get(polizaId);
            Account account = accountMap.get(poliza.Cuenta__c);
            Date hoy = Date.today(); 
            String periodo = String.valueOf(hoy.year()) + String.valueOf(hoy.month());
            Decimal cantMesesSinPago = poliza.Cantidad_de_Meses_Sin_Pago__c;
            String frecuenciaDePago = poliza.Frecuencia_de_Pago__c;
            String prioridad = '';
         
            if(account == null || !account.isPersonAccount)
                continue;
            
            String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
            
            //CIERRE PARTICIPANTE POR ANULACION DE POLIZA
            if(poliza.Estatus__c == 'ANULADA' && currentMemberMap.containsKey(key)){
                Participantes_de_Campa_a__c p = currentMemberMap.get(key);
                if(p.Estado_Cierre__c != 'Finalizado' || p.Estado_Cierre__c != 'Finalizado (Cierre Administrativo)'){
                    p.Estado_Cierre__c = 'Finalizado';
                    p.Comentario__c = 'Se cierra por anulación de Póliza';
                    members2.add(p);
                }
                continue;
            }
            ////////////////////////////////////////////////////////////
                       
            if(cantMesesSinPago > 0){
                if(poliza.Con_o_Sin_Ahorro__c == 'Con Ahorro'){
                    if(poliza.Valor_Poliza__c <= 2*poliza.Prima_Minima__c && !String.isBlank(poliza.Cantidad_de_meses_suspendido__c)){
                        prioridad = '1';
                    }else if(frecuenciaDePago == 'M'){
                        if(cantMesesSinPago >= 3 && cantMesesSinPago <= 12){
                            prioridad = '2';
                        }else if(cantMesesSinPago >= 13){
                            prioridad ='3';
                        }                       
                    }else if(frecuenciaDePago == 'T'){
                        if(cantMesesSinPago >= 5 && cantMesesSinPago <= 18){
                            prioridad = '2';                       
                        }else if(cantMesesSinPago >= 19){
                            prioridad = '3';
                        } 
                    }else if(frecuenciaDePago == 'S'){
                        if(cantMesesSinPago >= 8 && cantMesesSinPago <= 24){
                            prioridad = '2';
                        }else if(cantMesesSinPago >= 25){
                            prioridad = '3';
                        }
                    }else if(frecuenciaDePago == 'A'){
                        if(cantMesesSinPago >= 14 && cantMesesSinPago <= 30){
                            prioridad = '2';
                        }else if(cantMesesSinPago >= 31){ 
                            prioridad = '3';
                        }
                    }                 
                }else{
                    if(frecuenciaDePago == 'M'){
                        if(cantMesesSinPago > 1){
                            prioridad = '1';
                        }
                    }else if(frecuenciaDePago == 'T'){
                        if(cantMesesSinPago > 3){
                            prioridad = '1';
                        }
                    }else if(frecuenciaDePago == 'S'){
                        if(cantMesesSinPago > 6){
                            prioridad = '1';
                        }
                    }else if(frecuenciaDePago == 'A'){
                        if(cantMesesSinPago > 12){
                            prioridad = '1';
                        }           
                    }          
                }
            }
            
            if(currentMemberMap.containsKey(key) && poliza.Estatus__c == 'ACTIVA'){
                Participantes_de_Campa_a__c p = currentMemberMap.get(key);
                if(p.Estado_Cierre__c == 'Finalizado' || p.Estado_Cierre__c == 'Finalizado (Cierre Administrativo)'){
					if(!string.isBlank(prioridad)){
                        Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                            Name = 'Cobranzas PV: ' + account.Name + ' ' + poliza.Name + ' - ' + periodo,
                            Campa_a_Vida_Security__c = idCampana,
                            Contacto__c = account.PersonContactId,
                            Estado_Cierre__c= 'Abierto',
                            Nombre_de_Contacto__c = account.Name,
                            Poliza__c = poliza.Id,
                            OwnerId = account.OwnerId,
                            Cuenta__c = account.Id,
                            RecordTypeId = recordId,
                            Prioridad_en_Campa_a__c = prioridad
                        );
						members2.add(participante);//participante nuevo, ya participo previamente
                        currentMemberMap.put(key, participante);
					}
                }else if(p.Estado_Cierre__c != 'Finalizado' && p.Estado_Cierre__c != 'Finalizado (Cierre Administrativo)'){
                    if(!string.isBlank(prioridad) && p.Prioridad_en_Campa_a__c != prioridad){
                    	p.Prioridad_en_Campa_a__c = prioridad;
                    	members2.add(p);//actualiza prioridad de participante ya participando
                    }
                    //CIERRE PARTICIPANTE RECAUDANDO NORMALMENTE
                    else if(string.isBlank(prioridad)){
                    	p.Estado_Cierre__c = 'Finalizado';
                    	p.Comentario__c = 'Finalizado recaudando normalmente';
                        members2.add(p);//cierra participante participando porque ya no tiene prioridad
                     }
                    ////////////////////////////////////////////////////////////
                }                
            }
            else if(poliza.Estatus__c == 'ACTIVA' && !string.isBlank(prioridad)){
                Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                    Name = 'Cobranzas PV: ' + account.Name + ' ' + poliza.Name,
                    Campa_a_Vida_Security__c = idCampana,
                    Contacto__c = account.PersonContactId,
                    Estado_Cierre__c= 'Abierto',
                    Nombre_de_Contacto__c = account.Name,
                    Poliza__c = poliza.Id,
                    OwnerId = account.OwnerId,
                    Cuenta__c = account.Id,
                    RecordTypeId = recordId,
                    Prioridad_en_Campa_a__c = prioridad
                );
                members2.add(participante);//nuevo participante, participando por primera vez
                currentMemberMap.put(key, participante);
            }     		
        }

        if(!members2.isEmpty())
            upsert members2;
    }
}