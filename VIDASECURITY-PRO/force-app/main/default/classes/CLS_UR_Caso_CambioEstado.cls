/**
 * @File Name          : CLS_UR_Caso_CambioEstado.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 03-11-2022
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    7/2/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class CLS_UR_Caso_CambioEstado {


    public static void Actualiza_EscritorioDigital(Integer idRequerimiento,  String estado, String rutUsuario)
    {
        String Response = '';

        try
        {
            if (estado == 'Cerrado')
            {
                Response = CambioEstadoEscritorioDigital(idRequerimiento, 'FINALIZADO', rutUsuario);
            }
            else if (estado == 'Rechazado')
            {
                Response = CambioEstadoEscritorioDigital(idRequerimiento, 'RECHAZADO', rutUsuario);
            }
            else if (estado == 'En Revisión')
            {
                Response = CambioEstadoEscritorioDigital(idRequerimiento, 'PENDIENTE', rutUsuario);
            }
        }
        catch (Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }
    }

    public static void Actualiza_EscritorioDigital(Case caso,  String estado)
    {
        String Response = '';

        try
        {
            if (String.isBlank(caso.Id_Requerimiento_EscritorioDigital__c) == false)
            {
                List<User> lusers = [SELECT RUT_Usuario__c FROM User WHERE Id = :UserInfo.getUserId()];

                String rutUsuario = '';

                if (lusers.size() > 0)
                {
                    rutUsuario = lusers[0].RUT_Usuario__c;
                }

                Integer idReq = Integer.valueOf(caso.Id_Requerimiento_EscritorioDigital__c);

                if (estado == 'Cerrado')
                {
                    Response = CambioEstadoEscritorioDigital(idReq, 'FINALIZADO', rutUsuario);
                }
                else if (estado == 'Rechazado')
                {
                    Response = CambioEstadoEscritorioDigital(idReq, 'RECHAZADO', rutUsuario);
                }
                else if (estado == 'En Revisión')
                {
                    Response = CambioEstadoEscritorioDigital(idReq, 'PENDIENTE', rutUsuario);
                }
/*                if (Response != '' && Response != 'CAMBIO_ESTADO_OK' && Response != 'PENDIENTE_DOCUMENTOS_VALUETECH' &&
                    Response != 'REQUERIMIENTO_NO_CARGADO_VALUETECH' && Response != 'REQUERIMIENTO_ESTADO_RECHAZADO' &&
                    Response != 'REQUERIMIENTO_ESTADO_FINALIZADO')
                {
                }
*/
            }
        }
        catch (Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }
    }

    private static String CambioEstadoEscritorioDigital(Integer IdReq, string estadoED, String rutUsuario)
    {
        String Response = '';
        try
        {
            if (rutUsuario != '')
            {
                CLS_EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(IdReq, estadoED, rutUsuario);

                if (Test.isRunningTest())
                {
                    Respuesta.Response = 'REQUERIMIENTO_ESTADO_NUEVO';
                }

                if (Respuesta.Response == 'REQUERIMIENTO_ESTADO_NUEVO' || Respuesta.Response == 'REQUERIMIENTO_ESTADO_PENDIENTE' )
                {
                    Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdReq), 'INGRESADO', rutUsuario);

                    if (Respuesta.Response == 'CAMBIO_ESTADO_OK')
                    {
                        Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdReq), estadoED, rutUsuario);
                    }
                }

                Response = Respuesta.Response;
            }
            else
            {
                Response = 'RUT_USUARIO_NO_REGISTRADO';//Error, RUT de Usuario no registrado   1
            }
        }catch(Exception ex){
            System.debug('@@@@|CambioEstadoCaso ED -->'+ex);
            Response = 'EXCEPCION'; //3
        }

         return Response;
    }

    public static  void ActualizaEstadoTareasUR(String idCaso)
    {
        try
        {
            String TaskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

            List<Task> listatareasCasos = [SELECT Id, Subject, WhatId, Status, ActivityDate, Priority, Responsable_Backup__c, Id_Solicitante_UR__c, caso_numero__c FROM Task WHERE WhatId =: idCaso
                                                    AND RecordTypeId =: TaskRecordTypeId];

            List<CLS_UR_Bandeja_Contador.CambioMasivoEstado> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoEstado>();

            CLS_UR_Bandeja_Contador.CambioMasivoEstado data;

            List<Task_Comment__c> comentarios = new List<Task_Comment__c>();

            Task_Comment__c com;

            for (Task tarea : listatareasCasos) {

                system.debug('@@@@ tarea  '+ tarea);
                if (tarea.Status == 'No Iniciada' || tarea.Status == 'En Curso')
                {
                    com = new Task_Comment__c();
                    data = new CLS_UR_Bandeja_Contador.CambioMasivoEstado();
                    data.EstadoActual = tarea.Status;
                    //TODO: revisar una vez concluidad etapa de tareas
                    tarea.Status = 'Descartada';
                    tarea.TASK_Agregar_Comentario_Tarea__c = 'Tarea Descartada al ser Cerrado o Rechazado el Caso por parte de la Unidad Resolutora de origen';
                    system.debug('@@@@ tarea 02 '+ tarea);
                    update tarea;

                    data.EstadoNuevo = 'Descartada';
                    data.Id = tarea.Responsable_Backup__c;
                    lista.add(data);

                    com.Id_Solicitante_UR__c = tarea.Id_Solicitante_UR__c;
                    com.Task_ID__c = tarea.Id;
                    com.Id_Responsable_UR__c = tarea.Responsable_Backup__c;
                    com.Notificacion__c = 'TUR_CE';//Tarea UR - Cambio de Estado
                    com.CaseNumber__c = tarea.caso_numero__c;
                    com.Estado_Tarea__c = 'Descartada';
                    com.Detail__c = 'Tarea UR Descartada al ser Cerrado o Rechazado el Caso por parte de la Unidad Resolutora de origen';
                    comentarios.add(com);
                }
            }

            for (Task_Comment__c comment : comentarios)
            {
                if (String.isNotBlank(comment.Id_Responsable_UR__c))
                {
                    Usuario_Backup__c uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: comment.Id_Responsable_UR__c];
                    comment.Responsable_UR__c = uresp.Name;
                    comment.Email_Responsable_UR__c = uresp.UBAC_Email__c;
                }

                if (String.isNotBlank(comment.Id_Solicitante_UR__c))
                {
                    Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: comment.Id_Solicitante_UR__c];
                    comment.Solicitante_UR__c = usol.Name;
                    comment.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                }
            }

            insert comentarios;

            for (CLS_UR_Bandeja_Contador.CambioMasivoEstado value : lista) {

                CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(value.Id, value.EstadoNuevo, value.EstadoActual);
            }
        }
        catch(system.Exception ex)
        {
            system.debug('@@@@ ERROR TMP => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }
    }

    public static void ActualizaCasoAtencion(String idAtencion, Boolean casoVenta)
    {
        Case atencion;

        if (!Test.isRunningTest())
        {
            atencion = [Select Id, CaseNumber, Canal__c, Origin, SuppliedEmail, Status, Entrega_Respuesta__c, Casos_Hijos_cerrados__c from Case
                                where Id=: idAtencion];
        }
        else
        {
            atencion = new Case();
            atencion.Origin = 'Recepción Pagos';
            atencion.Canal__c = 'Recepción Pagos';
            atencion.SuppliedEmail = 'juespinoza@security.cl';
        }

        system.debug('@@@@ CasoAtencion 1 --> '+ atencion);

        Set<String> ORIGENES = new Set<String>{'Cobranzas Vida','Recepción Pagos','Producción Individuales'};

        if (casoVenta == true ||
            (
                //ORIGENES.contains(atencion.Origin) && ORIGENES.contains(atencion.Canal__c)  && String.isNotBlank(atencion.SuppliedEmail) == false)
                ORIGENES.contains(atencion.Origin) && ORIGENES.contains(atencion.Canal__c)  && String.isNotBlank(atencion.SuppliedEmail))
            )
        {
            atencion.Casos_Hijos_cerrados__c = true;
            atencion.Status = 'Cerrado';
            atencion.Entrega_Respuesta__c = true;

            system.debug('@@@@ CasoAtencion 2  --> '+ atencion);

            if (!Test.isRunningTest())
            {
                update atencion;
                system.debug('@@@@ Caso Atencion --> '+ atencion);
            }
        }
    }
}