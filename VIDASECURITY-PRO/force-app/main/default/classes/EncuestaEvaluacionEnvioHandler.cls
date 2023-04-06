public class EncuestaEvaluacionEnvioHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
    // En este trigger se evalúan ambos EPA (Sucursal y Call Center)

    //Constantes y útiles
    List<Account> cuentas = new List<Account>(); //contenedor de cuentas para update final
    Datetime fechaCorteEnvioEncuesta6Meses = Datetime.now().addMonths(- 6); // 6 meses atrás desde hoy
    List<RecordType> rtEPAPV_9Meses_Bienvenida = new List<RecordType> ([select id from RecordType where SobjectType = 'Participantes_de_Campa_a__c' and DeveloperName in('EPA', 'X9_Meses_Vigencia', 'Bienvenida') and IsActive = true]); //RecordTypes de las campañas consideradas en filtros
    List<RecordType> listRt = new List<RecordType> ([select id, DeveloperName from RecordType where SobjectType = 'Case' and DeveloperName in('Consultas', 'Solicitudes', 'Reclamos') and IsActive = true limit 3]); //RecordTypes de casos para filtros
    List<Id> ListCuentasTrigger = new List<Id>(); //lista con cuentas de casos que entraron al trigger, para filtros

    //Bloque de determinación de RecordTypes de casos (Asignación a Sets) para filtros
    Set<Id> setRtConsulta = new Set<Id> ();
    Set<Id> setRtSolicitudReclamo = new Set<Id> ();
    for (RecordType r : listRt) {
        if (r.DeveloperName == 'Consultas') {
            setRtConsulta.add(r.Id);
        }
        else {
            setRtSolicitudReclamo.add(r.Id);
        }
    }

    //Contenedores de datos para loops
    for (Case c : (Case[])Trigger.new){
        ListCuentasTrigger.add(c.AccountId);
    }

    Map<Id, Account> mapCuentas = new Map<Id, Account>([select Id, Rut_Contacto__pc, Rut__c, PersonEmail, Edad__c, Fecha_de_Envio_de_Encuesta__c from Account where Id in :ListCuentasTrigger FOR UPDATE]);

    //Ultimos participantes de campaña
    Map<Id, Participantes_de_Campa_a__c> mapCuentas_PCampanaEPA = new Map<Id, Participantes_de_Campa_a__c>(); //<IdCuenta, Part. Campaña>
    Map<Id, AggregateResult> mapPC_EPA_aggr = new Map<Id, AggregateResult>([select max(Id) Id, max(LastModifiedDate), Cuenta__c from Participantes_de_Campa_a__c where RecordTypeId in :rtEPAPV_9Meses_Bienvenida and Cuenta__c in :ListCuentasTrigger group by Cuenta__c]);
    Map<Id, Participantes_de_Campa_a__c> mapPC_EPA = new Map<Id, Participantes_de_Campa_a__c>([select Id, LastModifiedDate, Contactado__c from Participantes_de_Campa_a__c where RecordTypeId in :rtEPAPV_9Meses_Bienvenida and Cuenta__c in :ListCuentasTrigger]);

    for (AggregateResult ar : mapPC_EPA_aggr.values()){
        Id cuenta = (Id)ar.get('Cuenta__c');
        Id ultCampana = (Id)ar.get('Id');
        mapCuentas_PCampanaEPA.put(cuenta, mapPC_EPA.get(ultCampana));
    }

    //fin contenedores de loops

    for (Case c : (Case[])Trigger.new) {

        System.debug('EntResp:' + c.Entrega_Respuesta__c
                    + '; Canal:' + c.Canal__c
                    + '; TSolicitante:' + c.Tipo_de_Solicitante__c
                    + '; RType:' + c.RecordTypeId
                    + '; Negocio:' + c.Negocio__c
                    + '; LineaNegocio: ' + c.Linea_Negocio__c);

        // EPA Call Center
        if (c.Entrega_Respuesta__c == true && c.Canal__c == 'Call Center' && ((c.Tipo_de_Contacto__c == 'Contratante' && setRtConsulta.contains(c.RecordTypeId) && (c.Linea_Negocio__c == 'Seguros Individuales' || c.Linea_Negocio__c == 'PF')) || (c.Tipo_de_Solicitante__c == 'Contratante' && setRtSolicitudReclamo.contains(c.RecordTypeId) && c.Negocio__c == 'Seguros Individuales'))) {

            System.debug('EPA CALL; c.accId: ' + c.AccountId);

            Account a = mapCuentas.get(c.AccountId);


            if (a != null && ((a.Rut_Contacto__pc != '99999998' || a.Rut__c != '99999998') && a.PersonEmail != '' && a.Edad__c >= 28 && a.Edad__c <= 65 && (a.Fecha_de_Envio_de_Encuesta__c < fechaCorteEnvioEncuesta6Meses || a.Fecha_de_Envio_de_Encuesta__c == null))) {
                System.Debug('EPA CALL; Rut_Contacto__pc:' + a.Rut_Contacto__pc
                        + '; Rut__c:' + a.Rut__c
                        + '; PersonEmail:' + a.PersonEmail
                        + '; Edad__c:' + a.Edad__c
                        + '; Fecha_de_Envio_de_Encuesta__c:' + a.Fecha_de_Envio_de_Encuesta__c);

                System.debug('EPA CALL; no es anónimo, tiene mail, tiene edad correcta, envío encuesta cumple condición umbral envío');

                Participantes_de_Campa_a__c ultimaCampana = mapCuentas_PCampanaEPA.get(c.AccountId);

                if (ultimaCampana != null) {
                    if (ultimaCampana.LastModifiedDate < fechaCorteEnvioEncuesta6Meses && ultimaCampana.Contactado__c == 'Si') {
                        System.debug('EPA CALL; OK!');
                        a.Pendiente_Envio_Encuesta__c = true;
                        cuentas.add(a);
                    }
                }
                else
                {
                    System.debug('EPA CALL; OK sin campañas');
                    a.Pendiente_Envio_Encuesta__c = true;
                    cuentas.add(a);
                }
            }
        }

        // EPA Sucursal
        else if (c.Entrega_Respuesta__c == true && c.Canal__c == 'Sucursal' && c.Atencion_Presencial__c == true && c.Tipo_de_Solicitante__c == 'Contratante' && setRtSolicitudReclamo.contains(c.RecordTypeId) && (c.Negocio__c == 'Seguros Individuales' || c.Linea_Negocio__c == 'PF' || c.Negocio__c == 'RRVV')) {
            System.debug('EPA SUCURSAL; c.accId: ' + c.AccountId);

            Account a = mapCuentas.get(c.AccountId);


            if (a != null && ((a.Rut_Contacto__pc != '99999998' || a.Rut__c != '99999998') && a.PersonEmail != '' && (a.Fecha_de_Envio_de_Encuesta__c < fechaCorteEnvioEncuesta6Meses || a.Fecha_de_Envio_de_Encuesta__c == null))) {
                System.debug('EPA SUCURSAL; Rut_Contacto__pc:' + a.Rut_Contacto__pc
                        + '; Rut__c:' + a.Rut__c
                        + '; PersonEmail:' + a.PersonEmail
                        + '; Fecha_de_Envio_de_Encuesta__c:' + a.Fecha_de_Envio_de_Encuesta__c);

                System.debug('EPA SUCURSAL; no es anónimo, tiene mail, envío encuesta cumple condición umbral envío');

                Participantes_de_Campa_a__c ultimaCampana = mapCuentas_PCampanaEPA.get(c.AccountId);

                if (ultimaCampana != null) {
                    if (ultimaCampana.LastModifiedDate < fechaCorteEnvioEncuesta6Meses && ultimaCampana.Contactado__c == 'Si') {
                        System.debug('EPA SUCURSAL; OK!');
                        a.Pendiente_Envio_Encuesta__c = true;
                        cuentas.add(a);
                    }
                }
                else
                {
                    System.debug('EPA SUCURSAL; OK sin campañas');
                    a.Pendiente_Envio_Encuesta__c = true;
                    cuentas.add(a);
                }
            }
        }
    }

    update(cuentas);
	}
}