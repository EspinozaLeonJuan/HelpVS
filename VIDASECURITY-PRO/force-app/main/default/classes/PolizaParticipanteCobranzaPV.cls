/*******************************************************************************************
 *  NOMBRE                 : PolizaCampanaBienvenida
 *  TIPO                   : CLASE APEX
 *  REQUERIMIENTO          : Campana Bienvenida masiva
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 14/10/2021 - J. GÓMEZ       - Creación inicial de la clase.
 * *****************************************************************************************/
public class PolizaParticipanteCobranzaPV {
    public static Id getPolizaId(Poliza__c polizaNew, Set<Id> polizaIds,Id recordTypeIndividuales ){
        if(!((string.isBlank(polizaNew.Con_o_Sin_Ahorro__c)) || (string.isBlank(polizaNew.Frecuencia_de_Pago__c)) || (polizaNew.RecordTypeId != recordTypeIndividuales)  || (polizaNew.Frecuencia_de_Pago__c == 'U')  || (polizaNew.N_Meses_Vigencia__c < 3))) {
            if(!polizaIds.contains(polizaNew.Id))
                return polizaNew.Id;            
        }
        return null;
    }
    
    public static Id getAccountId(Poliza__c polizaNew, Set<Id> accountIds, Id recordTypeIndividuales ) {
		if(!((string.isBlank(polizaNew.Con_o_Sin_Ahorro__c)) || (string.isBlank(polizaNew.Frecuencia_de_Pago__c)) || (polizaNew.RecordTypeId != recordTypeIndividuales)  || (polizaNew.Frecuencia_de_Pago__c == 'U')  || (polizaNew.N_Meses_Vigencia__c < 3))) {
            if(!accountIds.contains(polizaNew.Cuenta__c))
                return polizaNew.Cuenta__c; 
        }
        return null;
	}
    
    public static void updateMembers2( Id recordTypeIndividuales, Id recordId, Id idCampana, Set<Id> accountIds, Set<Id> polizaIds, Map<Id, Account> accMap, Participantes_de_Campa_a__c[] members, Map<Id, Poliza__c> newMap ) {
        try{       
            Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();       
            for( Participantes_de_Campa_a__c member : members ){
                currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c), member);
            }
            
            Participantes_de_Campa_a__c[] members2 = new Participantes_de_Campa_a__c[]{};
                
            for( Id polizaId : polizaIds ){
                Poliza__c poliza = (Poliza__c)newMap.get(polizaId);
                Account account = accMap.get(poliza.Cuenta__c);
                Date hoy = Date.today(); 
                String periodo = String.valueOf(hoy.year()) + String.valueOf(hoy.month());
                Decimal cantMesesSinPago = poliza.Cantidad_de_Meses_Sin_Pago__c;
                String frecuenciaDePago = poliza.Frecuencia_de_Pago__c;
                String prioridad = '';
                System.debug('##account: ' + account + ' ##account.isPersonAccount: ' + account.isPersonAccount );
                if( account == null || !account.isPersonAccount ){
                    continue;
                }
                String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
                //CIERRE PARTICIPANTE POR ANULACION DE POLIZA
                if( poliza.Estatus__c == 'ANULADA' && currentMemberMap.containsKey(key) ){
                    Participantes_de_Campa_a__c p = currentMemberMap.get(key);
                    if( p.Estado_Cierre__c != 'Finalizado' || p.Estado_Cierre__c != 'Finalizado (Cierre Administrativo)' ){
                        p.Estado_Cierre__c = 'Finalizado';
                        p.Comentario__c = 'Se cierra por anulación de Póliza';
                        members2.add(p);
                    }
                    continue;
                }
                //PRIORIDAD
                prioridad = getPrioridad( cantMesesSinPago, frecuenciaDePago, poliza.Con_o_Sin_Ahorro__c, poliza.Valor_Poliza__c, poliza.Prima_Minima__c, poliza.Cantidad_de_meses_suspendido__c );
                //Asigna Participantes_de_Campa_a__c a currentMemberMap y members2
                if( currentMemberMap.containsKey(key) && poliza.Estatus__c == 'ACTIVA' ){
                    Participantes_de_Campa_a__c p = currentMemberMap.get(key);
                    if(p.Estado_Cierre__c == 'Finalizado' || p.Estado_Cierre__c == 'Finalizado (Cierre Administrativo)'){
                        if(!string.isBlank(prioridad)){
                            //Participante nuevo, ya participo previamente
                            Participantes_de_Campa_a__c participante = armParticipanteCampana( '1', account.Name, poliza.Name, periodo, idCampana, account.PersonContactId, poliza.Id, account.OwnerId, account.Id, recordId, prioridad );
                            members2.add( participante );
                            currentMemberMap.put(key, participante);
                        }
                    }else if( p.Estado_Cierre__c != 'Finalizado' && p.Estado_Cierre__c != 'Finalizado (Cierre Administrativo)'){
                        if(!string.isBlank(prioridad) && p.Prioridad_en_Campa_a__c != prioridad){
                            p.Prioridad_en_Campa_a__c = prioridad;
                            members2.add(p);//Actualiza prioridad de participante ya participando
                        }else if(string.isBlank(prioridad)){//CIERRE PARTICIPANTE RECAUDANDO NORMALMENTE
                            p.Estado_Cierre__c = 'Finalizado';
                            p.Comentario__c = 'Finalizado recaudando normalmente';
                            members2.add(p);//Cierra participante participando porque ya no tiene prioridad
                        }
                    }                
                }
                else if(poliza.Estatus__c == 'ACTIVA' && !string.isBlank(prioridad)){
                    Participantes_de_Campa_a__c participante = armParticipanteCampana( '2', account.Name, poliza.Name, '',idCampana, account.PersonContactId, poliza.Id, account.OwnerId, account.Id, recordId, prioridad );
                    //Nuevo participante, participando por primera vez
                    members2.add( participante );
                    currentMemberMap.put(key, participante);
                }     		
            }
            if(!members2.isEmpty()){
                upsert members2;
            }
        }catch( Exception e ) {
            system.debug('@@@@ -> :' + e.getMessage());
        }
	}
    /** 
     * @description: 
    */
    public static String getPrioridad( Decimal cantMesesSinPago, String frecuenciaDePago,String conSinAhorro, Decimal valorPoliza, Decimal primaMinima, String cantidadMesesSuspendido ){
        String prioridad = '';
        if( cantMesesSinPago > 0 ){
            if( conSinAhorro == 'Con Ahorro'){
                if( valorPoliza <= 2*primaMinima && !String.isBlank(cantidadMesesSuspendido)){
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
        return prioridad;
    }
    /** 
     * @description: 
    */
    public static Participantes_de_Campa_a__c armParticipanteCampana( String sOpc, String accName, String polizaName, String periodo,Id idCampana, Id personContactId, Id polizaId, Id ownerId, Id accId, Id recordId, String prioridad ){
        Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
            Name = 'Cobranzas PV: ' + accName + ' ' + polizaName + ( sOpc == '1' ? ' - ' + periodo : '' ),
            Campa_a_Vida_Security__c = idCampana,
            Contacto__c = personContactId,
            Estado_Cierre__c= 'Abierto',
            Nombre_de_Contacto__c = accName,
            Poliza__c = polizaId,
            OwnerId = ownerId,
            Cuenta__c = accId,
            RecordTypeId = recordId,
            Prioridad_en_Campa_a__c = prioridad );
        return participante;
    }
}