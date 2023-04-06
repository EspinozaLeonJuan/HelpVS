/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-15-2022
 * @last modified by  : Juan Espinoza León
**/

@isTest
public with sharing class TEST_CLS_CS_Colaboraciones_Reclamo {

    private static  String RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Colaboracion Caso').getRecordTypeId();

    @isTest static void getColaboracionesCaso()
    {
        List<Task> tareas = new List<Task>();

        List<String> ursName = new List<String>();
        ursName.add('UR - Producción RRVV');
        ursName.add('UR - Beneficios');
        ursName.add('UR - Cobranza');
        ursName.add('UR - Producción Individuales');

        List<Group> Queues = [SELECT Id, Name FROM Group WHERE  Type = 'Queue' AND Name IN : ursName];

        String[] UrIds = new String[4];

        Integer i = 0;
        for (Group q : Queues)
        {
            UrIds[i] = q.Id;
            i++;
        }

        Datetime fechaTime = Datetime.newInstance(2022, 06, 15, 23, 59, 0);
        Date fecha = fechaTime.dateGMT();
        //Datetime.(Integer.valueOf(sFecha[0]), Integer.valueOf(sFecha[1]), Integer.valueOf(sFecha[2]), 23,59,0);

        List<User> users = [SELECT Id, Cola_UR_Id__c FROM User WHERE Cola_UR_Id__c IN : URIds AND IsActive = true];

        Map<String, String> mapUsers = new Map<String, String>();

        for (User u : users)
        {
            mapUsers.put(u.Cola_UR_Id__c, u.Id);
        }

        Account cuenta = Factory.cuenta.buildInsert();
        Case casoA = Factory.buildCasoSF('Atención', cuenta);
        insert casoA;

        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        caso.ParentId = casoA.Id;
        insert caso;

        for(String vId : UrIds)
        {
            Task nuevaTask = new Task();
            nuevaTask.WhatId = caso.Id;
            nuevaTask.Subject = 'Colaboración caso Reclamo';
            nuevaTask.RecordTypeId = RecordTypeId;
            nuevaTask.OwnerId = mapUsers.get(vId);//INVALID_OPERATION, Queue not associated with this SObject type
            nuevaTask.Status = 'No iniciada';
            nuevaTask.Priority = 'Normal';
            nuevaTask.caso_numero__c  = caso.CaseNumber;
            nuevaTask.ActivityDate = fecha;
            nuevaTask.Description = 'Descripcion';
            nuevaTask.Detalle_Operacion__c = caso.Subject;
            nuevaTask.Id_Ejecutiva_Caso__c = caso.OwnerId;
            tareas.add(nuevaTask);
        }

        insert tareas;

        Test.startTest();
        CLS_CS_Colaboraciones_Reclamo.getColaboracionesCaso(caso.Id);
        Test.stopTest();
    }

    @isTest static void get_List_BandejasUR()
    {
        Test.startTest();

        CLS_CS_Colaboraciones_Reclamo.get_List_BandejasUR();

        Test.stopTest();
    }


    @isTest static void get_pickList_Priority()
    {
        Test.startTest();

        CLS_CS_Colaboraciones_Reclamo.get_pickList_Priority();

        Test.stopTest();
    }

    @isTest static void create_Colaboracion_Reclamo()
    {
        List<Task> tareas = new List<Task>();

        List<String> ursName = new List<String>();
        ursName.add('UR - Producción RRVV');
        ursName.add('UR - Beneficios');
        ursName.add('UR - Cobranza');
        ursName.add('UR - Producción Individuales');

        List<Group> Queues = [SELECT Id, Name FROM Group WHERE  Type = 'Queue' AND Name IN : ursName];

        String[] UrIds = new String[4];

        Integer i = 0;
        for (Group q : Queues)
        {
            UrIds[i] = q.Id;
            i++;
        }

        Datetime fechaTime = Datetime.newInstance(2022, 06, 15, 23, 59, 0);

        Account cuenta = Factory.cuenta.buildInsert();
        Case casoA = Factory.buildCasoSF('Atención', cuenta);
        insert casoA;

        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        caso.ParentId = casoA.Id;
        insert caso;

        Test.startTest();
        CLS_CS_Colaboraciones_Reclamo.create_Colaboracion_Reclamo(caso.Id, UrIds, 'Descripcion', '2022-06-15', 'Normal');
        Test.stopTest();
    }

    @isTest static void get_Colaboracion_Reclamo_TaskComments()
    {
        List<Task> tareas = new List<Task>();

        List<String> ursName = new List<String>();
        ursName.add('UR - Producción RRVV');
        ursName.add('UR - Beneficios');
        ursName.add('UR - Cobranza');
        ursName.add('UR - Producción Individuales');

        List<Group> Queues = [SELECT Id, Name FROM Group WHERE  Type = 'Queue' AND Name IN : ursName];

        String[] UrIds = new String[4];

        Integer i = 0;
        for (Group q : Queues)
        {
            UrIds[i] = q.Id;
            i++;
        }

        Datetime fechaTime = Datetime.newInstance(2022, 06, 15, 23, 59, 0);
        Date fecha = fechaTime.dateGMT();
        //Datetime.(Integer.valueOf(sFecha[0]), Integer.valueOf(sFecha[1]), Integer.valueOf(sFecha[2]), 23,59,0);

        List<User> users = [SELECT Id, Cola_UR_Id__c FROM User WHERE Cola_UR_Id__c IN : URIds AND IsActive = true];

        Map<String, String> mapUsers = new Map<String, String>();

        for (User u : users)
        {
            mapUsers.put(u.Cola_UR_Id__c, u.Id);
        }

        Account cuenta = Factory.cuenta.buildInsert();
        Case casoA = Factory.buildCasoSF('Atención', cuenta);
        insert casoA;

        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        caso.ParentId = casoA.Id;
        insert caso;

        for(String vId : UrIds)
        {
            Task nuevaTask = new Task();
            nuevaTask.WhatId = caso.Id;
            nuevaTask.Subject = 'Colaboración caso Reclamo';
            nuevaTask.RecordTypeId = RecordTypeId;
            nuevaTask.OwnerId = mapUsers.get(vId);//INVALID_OPERATION, Queue not associated with this SObject type
            nuevaTask.Status = 'No iniciada';
            nuevaTask.Priority = 'Normal';
            nuevaTask.caso_numero__c  = caso.CaseNumber;
            nuevaTask.ActivityDate = fecha;
            nuevaTask.Description = 'Descripcion';
            nuevaTask.Detalle_Operacion__c = caso.Subject;
            nuevaTask.Id_Ejecutiva_Caso__c = caso.OwnerId;
            tareas.add(nuevaTask);
        }

        insert tareas;

        Test.startTest();

        CLS_CS_Colaboraciones_Reclamo.get_Colaboracion_Reclamo(tareas[0].Id);
        CLS_CS_Colaboraciones_Reclamo.create_TaskComment(tareas[0].Id,'Detalle', 'CEJ_CM');
        CLS_CS_Colaboraciones_Reclamo.get_TaskComments(tareas[0].Id);

        Test.stopTest();
    }
}