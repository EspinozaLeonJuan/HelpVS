/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-01-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CS_Colaboraciones_Reclamo {
    public CLS_CS_Colaboraciones_Reclamo() {

    }

    private static  String RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Colaboracion Caso').getRecordTypeId();

    public with sharing class Wrapper {
        @auraEnabled public string Name {get;set;}
        @auraEnabled public string Id {get;set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<Task> getColaboracionesCaso(String Id) {

        system.debug('@@@@ Caso  --> '+Id );

        return [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Detalle_Solicitud__c,
        Detalle_Operacion__c, Responsable_Backup__c, Responsable_Backup__r.Name FROM Task WHERE WhatId =: Id AND RecordTypeId =: RecordTypeId  ORDER BY CreatedDate ASC];
    }


    @AuraEnabled(cacheable=true)
    public static List <Wrapper>  get_List_BandejasUR() {

        List<CLS_BAK_Gestion_Caso.Nodo> lista = CLS_BAK_Gestion_Caso.getListBandejaUR();

        List <Wrapper> retorno = new List <Wrapper> ();

        for (CLS_BAK_Gestion_Caso.Nodo nd : lista)
        {
            Wrapper wr = new Wrapper();
            wr.Id = nd.Id;
            wr.Name =nd.Name;
            retorno.add(wr);
        }

        return  retorno;
    }



    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Priority() {
        Task task = new Task();
        return CLS_UTL_Lightning.get_pickList_without_dependency(task, 'Priority');
    }

    @AuraEnabled
    public static List<Task> create_Colaboracion_Reclamo(String Id, String[] UR_Ids, String Descripcion, String FechaVencimiento, String Prioridad)
    {
        try
        {
            List<Task> tareas = new List<Task>();

            String[] sFecha = FechaVencimiento.split('-');
            Datetime fechaTime = Datetime.newInstance(Integer.valueOf(sFecha[0]), Integer.valueOf(sFecha[1]), Integer.valueOf(sFecha[2]), 23, 59, 0);
            Date fecha = fechaTime.dateGMT();
            //Datetime.(Integer.valueOf(sFecha[0]), Integer.valueOf(sFecha[1]), Integer.valueOf(sFecha[2]), 23,59,0);

            List<User> users = [SELECT Id, Cola_UR_Id__c FROM User WHERE Cola_UR_Id__c IN : UR_Ids AND IsActive = true];

            Map<String, String> mapUsers = new Map<String, String>();

            for (User u : users)
            {
                mapUsers.put(u.Cola_UR_Id__c, u.Id);
            }

            Case caso = [SELECT Id, CaseNumber, Subject, OwnerId FROM Case WHERE Id =: Id];

            for(String vId : UR_Ids)
            {
                Task nuevaTask = new Task();
                nuevaTask.WhatId = Id;
                nuevaTask.Subject = 'Colaboración caso Reclamo';
                nuevaTask.RecordTypeId = RecordTypeId;
                nuevaTask.OwnerId = mapUsers.get(vId);//INVALID_OPERATION, Queue not associated with this SObject type
                nuevaTask.Status = 'No iniciada';
                nuevaTask.Priority = Prioridad;
                nuevaTask.caso_numero__c  = caso.CaseNumber;
                nuevaTask.ActivityDate = fecha;
                nuevaTask.Description = Descripcion;
                nuevaTask.Detalle_Operacion__c = caso.Subject;
                nuevaTask.Id_Ejecutiva_Caso__c = caso.OwnerId;
                tareas.add(nuevaTask);
            }

            insert tareas;

            List<String> idsTasks = new List<String>();
            for(Task t : tareas)
            {
                idsTasks.add(t.Id);
            }

            tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Detalle_Solicitud__c,
            Detalle_Operacion__c, Responsable_Backup__c FROM Task WHERE Id =: idsTasks ORDER BY CreatedDate ASC];

            return tareas;

        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ex);
            return null;
        }

    }
    public class Wrapper_Response {
        @auraEnabled public String Task_Id {get;set;}
        @auraEnabled public String Task_Subject {get;set;}
        @auraEnabled public String Task_Status {get;set;}
        @auraEnabled public Datetime Task_CreatedDate {get;set;}
        @auraEnabled public Datetime Task_ActivityDate {get;set;}
        @auraEnabled public String Task_Priority {get;set;}
        @auraEnabled public String Task_OwnerName {get;set;}
        @auraEnabled public String Task_Description {get;set;}
        @auraEnabled public String Task_Responsable_Backup {get;set;}
        @auraEnabled public String Task_Detalle_Operacion {get;set;}
        @auraEnabled public String Task_Id_Ejecutiva_Caso {get;set;}

        @auraEnabled public String Case_Id {get;set;}
        @auraEnabled public String Case_CaseNumber {get;set;}
        @auraEnabled public String Case_RUT {get;set;}
        @auraEnabled public String Case_Subject {get;set;}
        @auraEnabled public String Case_AccountId {get;set;}
        @auraEnabled public String Case_ContactId {get;set;}
        @auraEnabled public String Case_Origin {get;set;}
        @auraEnabled public String Case_Description {get;set;}
        @auraEnabled public String Case_Status {get;set;}
        @auraEnabled public Date Case_Fecha_Cierre_Tope {get;set;}
        @auraEnabled public String Case_Negocio {get;set;}
        @auraEnabled public String Case_Concepto {get;set;}
        @auraEnabled public String Case_Producto {get;set;}
        @auraEnabled public String Case_Categoria {get;set;}
        @auraEnabled public String Case_Detalle_de_Rescate {get;set;}
        @auraEnabled public String Case_Tipo_Operacion {get;set;}
        @auraEnabled public String Case_Detalle_Operacion {get;set;}
        @auraEnabled public String Case_Canal {get;set;}
        @auraEnabled public String Case_Nombre_Completo_Razon_Social {get;set;}
        @auraEnabled public String Case_Detalle_Solicitud {get;set;}
        @auraEnabled public String Case_CASO_N_Poliza {get;set;}
        @auraEnabled public String Case_Parent_OwnerId {get;set;}
        @auraEnabled public String Case_Parent_OwnerName {get;set;}
    }

    @AuraEnabled
    public static Wrapper_Response get_Colaboracion_Reclamo(String Id)
    {
        Task task = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, TASK_Agregar_Comentario_Tarea__c, Responsable_Backup__c, Detalle_Operacion__c,Id_Ejecutiva_Caso__c FROM Task WHERE Id =: Id];

        Case Kase = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin, Description, Status, RecordTypeId, createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c, CASO_Poliza_Asoc__c,
        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate, Nombre_Completo_Razon_Social__c, Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, Parent.Owner.Name  FROM Case WHERE Id =: task.WhatId];

        Wrapper_Response wrapper = new Wrapper_Response();
        wrapper.Task_Id = task.Id;
        wrapper.Task_Subject = task.Subject;
        wrapper.Task_Status = task.Status;
        wrapper.Task_CreatedDate = task.CreatedDate;
        wrapper.Task_ActivityDate = task.ActivityDate;
        wrapper.Task_Priority = task.Priority;
        wrapper.Task_OwnerName = task.Owner.Name;
        wrapper.Task_Description = task.Description;

        if (String.isNotBlank(task.Responsable_Backup__c))
        {
            Usuario_Backup__c uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: task.Responsable_Backup__c];
            wrapper.Task_Responsable_Backup =  uback.Name;
        }
        else
        {
            wrapper.Task_Responsable_Backup = 'Responsable no asignado';
        }

        wrapper.Task_Detalle_Operacion = task.Detalle_Operacion__c;
        wrapper.Task_Id_Ejecutiva_Caso = task.Id_Ejecutiva_Caso__c;
        wrapper.Case_Id = Kase.Id;
        wrapper.Case_CaseNumber = Kase.CaseNumber;
        wrapper.Case_RUT = Kase.RUT__c;
        wrapper.Case_Subject = Kase.Subject;
        wrapper.Case_AccountId = Kase.AccountId;
        wrapper.Case_ContactId = Kase.ContactId;
        wrapper.Case_Origin = Kase.Origin;
        wrapper.Case_Description = Kase.Description;
        wrapper.Case_Status = Kase.Status;
        wrapper.Case_Fecha_Cierre_Tope  = Kase.Fecha_Cierre_Tope__c;
        wrapper.Case_Negocio = Kase.Negocio__c;
        wrapper.Case_Concepto = Kase.Concepto__c;
        wrapper.Case_Producto = Kase.Producto__c;
        wrapper.Case_Categoria = Kase.CASO_Categoria__c;
        wrapper.Case_Detalle_de_Rescate = Kase.Detalle_de_Rescate__c;
        wrapper.Case_Tipo_Operacion = Kase.Tipo_Operacion__c;
        wrapper.Case_Detalle_Operacion = Kase.Detalle_Operacion__c;
        wrapper.Case_Canal = Kase.Canal__c;
        wrapper.Case_Nombre_Completo_Razon_Social = Kase.Nombre_Completo_Razon_Social__c;
        wrapper.Case_Detalle_Solicitud = Kase.Detalle_Solicitud__c;
        wrapper.Case_CASO_N_Poliza = Kase.CASO_Poliza_Asoc__c;
        wrapper.Case_Parent_OwnerId = Kase.Parent.OwnerId;
        wrapper.Case_Parent_OwnerName = Kase.Parent.Owner.Name;

        return wrapper;
    }

    @AuraEnabled(cacheable=false)
    public static List <Task_Comment__c>  get_TaskComments(String Id) {
        List<Task_Comment__c> taskComments = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedBy.Name, Responsable_UR__c, Id_Responsable_UR__c, Ejecutiva_Caso__c, Id_Ejecutiva_Caso__c
        FROM Task_Comment__c WHERE Task_ID__c =: Id ORDER BY CreatedDate DESC];

        return taskComments;
    }

    @AuraEnabled
    public static List<Task_Comment__c>  create_TaskComment(String Id, String Detalle, String Notificacion) {//

        try
        {
            system.debug('@@@@ 229 Id '+ Id);

            Task task  = [SELECT Id_Ejecutiva_Caso__c, Id, caso_numero__c, Responsable_Backup__c FROM Task WHERE Id =: Id];

            User ejecutiva = null;

            system.debug('@@@@ task.Id_Ejecutiva_Caso__c '+ task.Id_Ejecutiva_Caso__c);
            if (String.isnotBlank(task.Id_Ejecutiva_Caso__c))
            {
                ejecutiva = [SELECT Id, Name, Email FROM User WHERE ID=: task.Id_Ejecutiva_Caso__c];
            }

            Usuario_Backup__c uback =  null;

            if (String.isnotBlank(task.Responsable_Backup__c))
            {
                uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: task.Responsable_Backup__c];
            }

            Task_Comment__c taskComment = new Task_Comment__c();

            if (uback != null)
            {
                taskComment.Responsable_UR__c = uback.Name;
                taskComment.Id_Responsable_UR__c = uback.Id;
                taskComment.Email_Responsable_UR__c = uback.UBAC_Email__c;
            }

            taskComment.Task_ID__c = task.Id;
            taskComment.Detail__c = Detalle;
            taskComment.Notificacion__c = Notificacion;
            taskComment.CaseNumber__c = task.caso_numero__c;

            if (ejecutiva != null)
            {
                taskComment.Ejecutiva_Caso__c = ejecutiva.Name;
                taskComment.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                taskComment.Email_Ejecutiva_Caso__c = ejecutiva.Email;
            }

            insert taskComment;

            String idTC = taskComment.Id;

            List<String> idsTC = new List<String>();
            idsTC.add(idTC);

            List<Task_Comment__c> comments = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedBy.Name, Responsable_UR__c, Id_Responsable_UR__c, Ejecutiva_Caso__c, Id_Ejecutiva_Caso__c
            FROM Task_Comment__c WHERE Id IN : idsTC ORDER BY CreatedDate DESC];

            return comments;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ex);
            system.debug('@@@@ ex  line '+ex.getLineNumber());
            return null;
        }
    }

}