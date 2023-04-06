/**
 * @description       :
 * @author            : Juan Espinoza Leon
 * @group             :
 * @last modified on  : 08-08-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   10-03-2020   Juan Espinoza Leon   Initial Version
**/
@RestResource(urlMapping='/ContactCenter_CreaCaso/*')
global with sharing class API_ContactCenter_CreaCaso {

    public API_ContactCenter_CreaCaso() {

    }

    @HttpPost
    global static API_ContactCenter_Response doPost(String rut, String idLlamada,
                                                    String telefonoIn, String telefonoOut,
                                                    String idCaso, Integer opcion)
    {
        API_ContactCenter_Response response = new API_ContactCenter_Response();

        String LogId = '';

        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

        Boolean datosValidos = true;

        if (opcion == null)
        {
            datosValidos = false;
            response.Resultado = 'ER06';
            response.Excepcion = 'Debe ingresar una opción válida.';
        }

        if (opcion == 1)
        {
            LogId = CLS_CC_LogContactCenter.InsertLog(rut, opcion, idLlamada, telefonoIn, telefonoOut);

            if (datosValidos)
            {
                if (String.isBlank(rut))
                {
                    datosValidos = false;
                    response.Resultado = 'ER01';
                    response.Excepcion = 'Debe ingresar un RUT.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }

                if (String.isBlank(idLlamada))
                {
                    datosValidos = false;
                    response.Resultado = 'ER02';
                    response.Excepcion = 'Debe ingresar un Id de Llamada.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }

                if (String.isBlank(telefonoIn))
                {
                    datosValidos = false;
                    response.Resultado = 'ER03';
                    response.Excepcion = 'Debe ingresar un teléfono de entrada.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }
            }

            if (datosValidos)
            {
                String rutFormat = rut.subString(0, rut.length()-1);

                List<Account> cuentas = [SELECT Id, Name, Rut_con_dv__c, PersonEmail, PersonBirthdate From Account WHERE RUT__c =: rutFormat];

                if (cuentas.size() > 0)
                {
                    String[] resultadoPrioridad = Calcula_Prioridad(cuentas[0].Id);
                    response.Prioridad = Integer.ValueOf(resultadoPrioridad[0]);
                    String[] resultadoCaso = Crea_Caso_Atencion(cuentas[0].Id, resultadoPrioridad[1], response.Prioridad, idLlamada, telefonoIn);

                    if (resultadoCaso[0] != 'EX')
                    {
                        response.Resultado = 'OK';
                        response.IdCaso = resultadoCaso[1];
                        response.Excepcion = resultadoCaso[0];
                        response.Url = baseUrl+'/'+resultadoCaso[0];
                        CLS_CC_LogContactCenter.UpdateLog_Ok_Account(LogId, cuentas[0].Rut_con_dv__c, resultadoCaso[0], cuentas[0].Id, cuentas[0].Name, resultadoCaso[1]);///
                    }
                    else {
                        response.Resultado = 'ER12';
                        response.Excepcion = resultadoCaso[1];
                        CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                    }
                }
                else
                {
                    String run = rutFormat;
                    String dv = RUTUtils.getDigito(Integer.valueOf(run));

                    String vRUT = run+'-'+dv;

                    String[] prospecto = GetLead(vRUT);
                    system.debug('@@@@ prospecto --> ' + prospecto);
                    system.debug('@@@@ leadId --> ' + prospecto[0]);
                    response.Resultado = 'OK';
                    response.Prioridad = 0;

                    Boolean prospectoCargado = false;
                    if(prospecto[1] == 'T')
                    {
                        prospectoCargado = false;
                    }

                    system.debug('@@@@ id out -->'+ LogId);
                    system.debug('@@@@ rut out -->'+ vRUT);
                    system.debug('@@@@ idSalesforce out -->'+ '');
                    system.debug('@@@@ idProspecto out -->'+  prospecto[0]);
                    system.debug('@@@@ prospectoCargado out -->'+ prospectoCargado);

                    String[] resultadoCaso = Crea_Caso_Atencion(prospecto[0], idLlamada, telefonoIn);

                    if (resultadoCaso[0] != 'EX')
                    {
                        response.Resultado = 'OK';
                        response.IdCaso = resultadoCaso[1];
                        response.Excepcion = resultadoCaso[0];
                        response.Url = baseUrl+'/'+resultadoCaso[0];
                        CLS_CC_LogContactCenter.UpdateLog_Ok_Lead(LogId, vRUT, resultadoCaso[0], prospecto[0], prospectoCargado, resultadoCaso[1]);//
                    }
                    else {
                        response.Resultado = 'ER12';
                        response.Excepcion = resultadoCaso[1];
                        CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                    }

                    BAT_CC_ActualizaProspecto myBatchObject = new BAT_CC_ActualizaProspecto(LogId);
                    system.debug('@@@@@ myBatchObject  --> '+ myBatchObject);
                    Id batchId = Database.executeBatch(myBatchObject);
                    system.debug('@@@@@ batchId  --> '+ batchId);
                }
            }
        }
        else if (opcion == 2) // recuperacion de clave --deprecated
        {
            response.Resultado = 'NO';
            response.Excepcion = 'Opción no se encuentra disponible para su uso.';
        }
        else if (opcion == 3) //llamada desde Salesforce, guardar listado casos para llamar, marcar con flags call back
        {
            if (datosValidos)
            {
                if (String.isBlank(idCaso))
                {
                    datosValidos = false;
                    response.Resultado = 'ER04';
                    response.Excepcion = 'Debe ingresar un Id de Caso.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }

                if (String.isBlank(telefonoOut))
                {
                    datosValidos = false;
                    response.Resultado = 'ER05';
                    response.Excepcion = 'Debe ingresar un teléfono de salida.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }
            }

            if (datosValidos)
            {
                Case ctmp = [SELECT Id, CaseNumber FROM Case WHERE CaseNumber =: idCaso];
            	LogId = CLS_CC_LogContactCenter.InsertLog(rut, opcion, idLlamada, telefonoIn, telefonoOut, ctmp.Id, ctmp.CaseNumber);

                Case atencion = Carga_Caso_Atencion(ctmp.Id);

                if (atencion != null)
                {
                    try {
                        atencion.Retorno_Llamada__c = true;
                        atencion.Telefono_llamada_saliente__c = telefonoOut;
                        update atencion;
                     	//response.Excepcion = atencion.Id;
                        response.Url = baseUrl+'/'+atencion.Id;
                        response.Resultado = 'OK';
                    }
                    catch (Exception ex) {
                        response.Resultado = 'ER13';
                        response.Excepcion = ex.getMessage();
                    }
                }
                else
                {
                    response.Resultado = 'ER11';
                    response.Excepcion = 'Id de Caso ingresado no corresponde a un Caso existente.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }
            }
        }
        else if (opcion == 4) //informacion on click
        {
            response.Resultado = 'NO';
            response.Excepcion = 'Opción no se encuentra disponible para su uso.';
        }
        else if (opcion == 5) //para cambio de propietario de caso
        {
            if (datosValidos)
            {
                if (String.isBlank(telefonoOut))
                {
                    datosValidos = false;
                    response.Resultado = 'ER14';
                    response.Excepcion = 'Debe ingresar un Anexo de Ejecutivo.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }

                if (String.isBlank(idCaso))
                {
                    datosValidos = false;
                    response.Resultado = 'ER04';
                    response.Excepcion = 'Debe ingresar un Id de Caso.';
                    CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                }

                if (datosValidos)
                {
                    List<User> usuarios = [SELECT Id, Name FROM User WHERE Anexo_A__c =: telefonoOut OR Anexo_B__c =: telefonoOut];

                    if (usuarios.size() > 0)
                    {
                        Case ctmp = [SELECT Id, OwnerId FROM Case WHERE Id =: idCaso];

                        if (ctmp != null)
                        {
                            try {

                                ctmp.OwnerId = usuarios[0].Id;

                                update ctmp;
                                //response.Excepcion = atencion.Id;
                                response.Url = baseUrl+'/'+ctmp.Id;
                                response.Resultado = 'OK';
                            }
                            catch (Exception ex) {
                                response.Resultado = 'ER13';
                                response.Excepcion = ex.getMessage();
                            }
                        }
                        else
                        {
                            response.Resultado = 'ER11';
                            response.Excepcion = 'Id de Caso ingresado no corresponde a un Caso existente.';
                            CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                        }
                    }
                    else
                    {
                        response.Resultado = 'ER15';
                        response.Excepcion = 'Anexo ingresado no corresponde a ningún ejecutivo.';
                        CLS_CC_LogContactCenter.UpdateLog_Error(LogId, response.Resultado, response.Excepcion);
                    }



                }
            }


        }
        else if (opcion >= 6) //informacion on click
        {
            response.Resultado = 'NO';
            response.Excepcion = 'Opción no se encuentra disponible para su uso.';
        }

        system.debug('@@@@ Response --> '+response);
        return response;
    }

    public static String[] Calcula_Prioridad(String idCuenta)
    {
        String[] resultado = new String[2];

        Integer prioridad = 0, prioridadFin = 10;
        String negocio = '';

        List<Poliza__c> Polizas = [SELECT Id, Name, RecordType.Name, Categoria_de_Poliza__c FROM Poliza__c WHERE Cuenta__c =: idCuenta];

        for (Poliza__c poliza : Polizas)
        {
           // RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Id =: poliza.RecordTypeId];

           system.debug('@@@@ poliza.RecordType.Name '+poliza.RecordType.Name);
            if (poliza.RecordType.Name == 'Individuales')
            {
                if (String.isNotBlank(poliza.Categoria_de_Poliza__c))
                {
                    Categoria_de_Poliza__c categoria = [SELECT Id, Name FROM Categoria_de_Poliza__c WHERE Id =: poliza.Categoria_de_Poliza__c];

                    if (categoria.Name == 'A' || categoria.Name == 'B')
                    {
                        prioridad = 1;
                    }
                    else if (categoria.Name == 'C' || categoria.Name == 'D' || categoria.Name == 'D-')
                    {
                        prioridad = 2;
                    }
                }
                else {
                    prioridad = 2;//si no tiene categoria asociada, adopta prioridad mas baja (siendo 1 la mas alta)
                }
            }
            else if (poliza.RecordType.Name == 'Rentas Vitalicias')
            {
                prioridad = 3;
            }
            else if (poliza.RecordType.Name == 'PF')
            {
                prioridad = 4;
            }
            else if (poliza.RecordType.Name == 'Masivos')
            {
                prioridad = 5;
            }

            if (prioridad < prioridadFin)
            {
                prioridadFin = prioridad;
            }
        }
        system.debug('@@@@ prioridadFin '+prioridadFin);

        if (prioridadFin == 10)//no encontrado como poliza personal
        {
            List<Poliza_Colectivo__c> Polizas_Colectivo = [SELECT Id, Name FROM Poliza_Colectivo__c WHERE Cuenta__c =: idCuenta];

            if (Polizas_Colectivo.size() > 0)
            {
                //prioridad = 6;
                //prioridadFin = prioridad;
                prioridadFin = 6;
            }
        }

        if (prioridadFin == 10)//poliza no encontrada
        {
            negocio = 'Sin Linea de Negocio';
            prioridadFin = 0;
        }
        else if (prioridadFin == 1 || prioridadFin == 2)
        {
            negocio = 'Seguros Individuales';
        }
        else if (prioridadFin == 3)
        {
            negocio = 'RRVV';
        }
        else if (prioridadFin == 4)
        {
            negocio = 'Seguros Familiares';
        }
        else if (prioridadFin == 5)
        {
            negocio = 'Seguros Masivos';
        }
        else if (prioridadFin == 6)
        {
            negocio = 'Seguros Colectivos';
        }

        resultado[0] = String.valueOf(prioridadFin);
        resultado[1] = negocio;
        return resultado;
    }

    public static String Retorna_Negocio(String idCuenta)
    {
        String negocio = '';

        List<Poliza__c> Polizas = [SELECT Id, Name, RecordTypeId, Categoria_de_Poliza__c FROM Poliza__c WHERE Cuenta__c =: idCuenta];

        for (Poliza__c poliza : Polizas)
        {
            RecordType recordType = [SELECT Id, Name FROM RecordType WHERE Id =: poliza.RecordTypeId];

            if (recordType.Name == 'Individuales')
            {
                negocio = 'Seguros Individuales';
            }
            else if (recordType.Name == 'Rentas Vitalicias')
            {
                negocio = 'RRVV';
            }
            else if (recordType.Name == 'PF')
            {
                negocio = 'Seguros Familiares';
            }
            else if (recordType.Name == 'Masivos')
            {
                negocio = 'Seguros Masivos';
            }
            else if (recordType.Name == 'Colectivos')
            {
                negocio = 'Seguros Colectivos';
            }
            else {
                negocio = 'Sin Linea de Negocio';
            }
        }

        return negocio;
    }

    public static String[] Crea_Caso_Atencion(String idCuenta, String negocio, Integer prioridad, String idLLamada, String telefonoIn)
    {
        String[] resultado = new String[2];

        try {

            Case Atencion = Genera_Caso_Atencion_Cuenta(idCuenta, negocio);

            if (Atencion != null)
            {
                Atencion.Prioridad_Llamada__c = prioridad;
                Atencion.IdLlamada__c = idLLamada;
                Atencion.Telefono_llamada_entrante__c = telefonoIn;
                Atencion.Opcion_Llamada__c = 1;//Opcion llamada 1
            }

            if (!Test.isRunningTest())
            {
                insert Atencion;
            }

            resultado[0] = Atencion.Id;

            Case caseAtencion = [SELECT CaseNumber FROM Case WHERE Id =: Atencion.Id];

            resultado[1] = caseAtencion.CaseNumber;
        }
        catch (Exception ex) {
            system.debug('@@@@ Exception --> '+ex);
            resultado[0] = 'EX';
            resultado[1] = ex.getMessage();
        }

        return resultado;
    }

    public static String[] Crea_Caso_Atencion(String idProspecto, String idLLamada, String telefonoIn)
    {
        String[] resultado = new String[2];

        Integer prioridad = 0;

        try {

            Case Atencion = Genera_Caso_Atencion_Prospecto(idProspecto);

            if (Atencion != null)
            {
                Atencion.Prioridad_Llamada__c = prioridad;
                Atencion.IdLlamada__c = idLLamada;
                Atencion.Telefono_llamada_entrante__c = telefonoIn;
                Atencion.Opcion_Llamada__c = 1;//Opcion llamada 1
            }
			system.debug('@@@@ Atencion --> '+Atencion);
            if (!Test.isRunningTest())
            {
                insert Atencion;
            }

            resultado[0] = Atencion.Id;

            Case caseAtencion = [SELECT CaseNumber FROM Case WHERE Id =: Atencion.Id];

            resultado[1] = caseAtencion.CaseNumber;

        }
        catch (Exception ex) {
            system.debug('@@@@ Exception --> '+ ex+  ' <-- '+ ex.getLineNumber());
            resultado[0] = 'EX';
            resultado[1] = ex.getMessage();
        }

        return resultado;
    }

    private static Case Genera_Caso_Atencion_Cuenta(String idCuenta, String negocio)
    {
        try {

            Case atencion = new Case();

            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Atencion' AND IsActive = true].Id;

            Account cuenta = [SELECT Rut__c, Name, Id, DV__c, PersonEmail FROM Account WHERE Id =: idCuenta];

            atencion.Negocio__c  = negocio;
            atencion.AccountId = cuenta.Id;
            atencion.Tipo_de_Solicitante__c = 'Contratante';
            atencion.Canal__c = 'Call Center';
            atencion.Tipo_de_Cliente__c = 'Cliente Normal';
            atencion.Origin = 'Call Center';
            atencion.Priority = 'Media';
            atencion.RecordTypeId = IdTipoRegistro;
            atencion.OwnerId = UserInfo.getUserId();
            atencion.Id_Usuario_Creacion__c = atencion.OwnerId;
            atencion.Status = 'Nuevo';

            String tipoRegistroCorredor = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Corredor' AND IsActive = true].Id;
            String tipoRegistroAgente = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Agente' AND IsActive = true].Id;
            String tipoRegistroComercial = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contactos_Comercial' AND IsActive = true].Id;
            String tipoRegistroContratante = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contratante' AND IsActive = true].Id;

            List<Contact> contactos = [SELECT Id FROM Contact WHERE RecordTypeId !=: tipoRegistroCorredor AND  RecordTypeId !=: tipoRegistroAgente AND  RecordTypeId !=: tipoRegistroComercial
            AND  RecordTypeId !=: tipoRegistroContratante AND AccountId =: idCuenta];

            if (contactos.size() > 0)
            {
                atencion.ContactId = contactos[0].Id;
            }

            return atencion;
        }
        catch (Exception ex) {
            system.debug('@@@@ Exception --> '+ex+'  --> line -->'+ex.getLineNumber());
            return null;
        }
    }

    public static Case Genera_Caso_Atencion_Prospecto(String idProspecto)
    {
        try
        {
            String negocio = 'Sin Linea de Negocio';

            Case atencion = new Case();

            List<Account> cuentas = [Select a.Rut__c, a.Name, a.Id, a.DV__c From Account a where a.Rut__c =: '99999995' ];

            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Atencion' AND IsActive = true].Id;

            Lead prospecto = [SELECT Id, FirstName, LastName, RUT__c  FROM Lead WHERE Id =: idProspecto];

            if (cuentas.size() > 0)
            {
                Account cuenta = cuentas[0];
                atencion.RecordTypeId = IdTipoRegistro;
                atencion.AccountId = cuenta.Id;
                atencion.Tipo_de_Solicitante__c = 'Contratante';//***
                atencion.Canal__c = 'Call Center';//***
                atencion.OwnerId = UserInfo.getUserId();
                atencion.Tipo_de_Cliente__c = 'Cliente Normal';
                atencion.Origin = 'Sucursal';
                atencion.Priority = 'Media';
                atencion.RUT_no_Cliente__c = prospecto.RUT__c;
                atencion.Negocio__c  = negocio;
                atencion.Origin = 'Call Center';
                atencion.OwnerId = UserInfo.getUserId();
                atencion.Id_Usuario_Creacion__c = atencion.OwnerId;
                atencion.Lead__c = prospecto.Id;
                atencion.Status = 'Nuevo';
                atencion.Nombre_no_Cliente__c = prospecto.FirstName +' '+ prospecto.LastName;
            }

            String tipoRegistroCorredor = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Corredor' AND IsActive = true].Id;
            String tipoRegistroAgente = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Agente' AND IsActive = true].Id;
            String tipoRegistroComercial = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contactos_Comercial' AND IsActive = true].Id;
            String tipoRegistroContratante = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contratante' AND IsActive = true].Id;

            List<Contact> contactos = [SELECT Id FROM Contact WHERE RecordTypeId !=: tipoRegistroCorredor AND  RecordTypeId !=: tipoRegistroAgente AND  RecordTypeId !=: tipoRegistroComercial
            AND  RecordTypeId !=: tipoRegistroContratante AND AccountId =: idProspecto];

            if (contactos.size() > 0)
            {
                atencion.ContactId = contactos[0].Id;
            }

            return atencion;

        }
        catch (Exception ex) {
            system.debug('@@@@ Exception --> '+ex+'  --> line -->'+ex.getLineNumber());
            return null;
        }
    }

    private static Case Carga_Caso_Atencion(String idCaso)
    {
        Case caso = null;

        try
        {
            system.debug('@@@@ CargaDatosCaso Caso => ' + IdCaso);

            caso = [SELECT Negocio__c, AccountId, Tipo_de_Solicitante__c, Canal__c, Tipo_de_Cliente__c, Origin, Priority, RecordTypeId, OwnerId, Id_Usuario_Creacion__c, Status, ContactId,
                    Prioridad_Llamada__c, IdLlamada__c, Telefono_llamada_entrante__c, Telefono_llamada_saliente__c, Opcion_Llamada__c, Id, Retorno_Llamada__c
                    FROM Case WHERE Id =: IdCaso];

        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
        }

        return caso;
    }

    public static String[] GetLead(String rut)
    {
        String LeadId = '', nuevo = '';
        String RecordTypeIdLead = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Prospecto_Contact_Center' AND IsActive = true].Id;

        List<Lead> Prospectos = [SELECT Id, FirstName, LastName  FROM Lead WHERE RUT__c =: rut];

        if (Prospectos.size() == 0)
        {
            Lead lead = new Lead();
            lead.RUT__c = rut;
            lead.FirstName = 'Cliente';
            lead.LastName = 'Anónimo';
            lead.RecordTypeId = RecordTypeIdLead;
            insert lead;
            LeadId = lead.Id;
            nuevo = 'T';
        }
        else
        {
            LeadId  = Prospectos[0].Id;
            nuevo = 'F';
        }

        system.debug('@@@@ LeadId --> '+LeadId);

        String[] salida = new String[2];
        salida[0] = LeadId;
        salida[1] = nuevo;
        return salida;
    }

}