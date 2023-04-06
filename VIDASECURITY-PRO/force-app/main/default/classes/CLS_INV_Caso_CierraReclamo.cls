/*
 ************************************************************************************************************
 |  NOMBRE                 : CLS_INV_Caso_CierraReclamo                                                     |
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Actuaiza Colaboraciones UR cuando un Caso Reclamo es cerrado                   |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/09/16   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
public with sharing class CLS_INV_Caso_CierraReclamo {
    @InvocableMethod 
    public static void ActualizaColaboraciones(List<String> Ids) {
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;

        if (Ids.size() > 0)
        {
            Case Caso = [SELECT Id, Status FROM Case WHERE Id =: Ids[0]];

            List<Task> Colaboraciones = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Detalle_Solicitud__c, 
                    Detalle_Operacion__c, Responsable_Backup__c, Id_Ejecutiva_Caso__c, caso_numero__c FROM Task where WhatId =: Caso.Id 
                    AND RecordTypeId =: RecordTypeId  ORDER BY CreatedDate DESC];

            List<CLS_UR_Bandeja_Contador.CambioMasivoEstado> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoEstado>();

            List<Task_Comment__c> comentarios = new List<Task_Comment__c>();
            Task_Comment__c com;

            CLS_UR_Bandeja_Contador.CambioMasivoEstado value;
            for(Task q : Colaboraciones)
            {
                if (q.Status != 'Completada' && q.Status != 'Rechazada')
                {
                    com = new Task_Comment__c();
                    value = new CLS_UR_Bandeja_Contador.CambioMasivoEstado();
                    value.Id = q.Responsable_Backup__c;
                    value.EstadoActual = q.Status;
                    value.EstadoNuevo = 'Descartada';
                    q.Status = 'Descartada';//se podria implementar estado Descartada a futuro
                    lista.add(value);
                
                    com.Id_Ejecutiva_Caso__c = q.Id_Ejecutiva_Caso__c;
                    com.Task_ID__c = q.Id;
                    com.Id_Responsable_UR__c = q.Responsable_Backup__c;
                    com.Notificacion__c = 'CUR_CE';//Colaboracion - Cambio de Estado
                    com.CaseNumber__c = q.caso_numero__c;
                    com.Estado_Tarea__c = 'Descartada';
                    com.Detail__c = 'Colaboración de Reclamo Descartada al ser Cerrado o Rechazado el Caso.';
                    comentarios.add(com);
                }   
            }

            update Colaboraciones;

            for (Task_Comment__c comment : comentarios)
            {
                if (String.isNotBlank(comment.Id_Responsable_UR__c))
                {
                    Usuario_Backup__c uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: comment.Id_Responsable_UR__c];
                    comment.Responsable_UR__c = uresp.Name; 
                    comment.Email_Responsable_UR__c = uresp.UBAC_Email__c;
                }

                if (String.isNotBlank(comment.Id_Ejecutiva_Caso__c))
                {
                    User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: comment.Id_Ejecutiva_Caso__c];
                    comment.Solicitante_UR__c = ejecutiva.Name; 
                    comment.Email_Solicitante_UR__c = ejecutiva.Email; 
                }                 
            }

            insert comentarios;
            
            for(CLS_UR_Bandeja_Contador.CambioMasivoEstado q : lista)
            {
                CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(q.Id, q.EstadoNuevo, q.EstadoActual);                
            }

        }        
    } 
}