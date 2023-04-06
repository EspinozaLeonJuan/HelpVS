@RestResource(urlMapping='/Cases/*')
global with sharing class API_VS_Case {

    private static String RecordTypeId_Atencion = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;

    private static String RecordTypeId_Solicitudes = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes'  AND SobjectType = 'Case'].Id;

    private static String RecordTypeId_Consultas = [SELECT Id FROM RecordType WHERE Name = 'Consultas'  AND SobjectType = 'Case'].Id;

    private static String RecordTypeId_Reclamos = [SELECT Id FROM RecordType WHERE Name = 'Reclamos'  AND SobjectType = 'Case'].Id;

    public API_VS_Case() {

    }

    @HttpPost
    global static API_VS_Case_Response createCase()
    {
        RestRequest request = RestContext.request;

        system.debug('@@@@ request --> '+request.requestbody.tostring());

        Case mapping = (Case)JSON.deserialize(request.requestbody.tostring(), Case.class);

        mapping.OwnerId = '0050H00000Cu67sQAB';
        //Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped();
        API_VS_Case_Response response = null;
        //system.debug('@@@@ parameters --> '+params);ç
        system.debug('@@@@ mapping --> '+mapping);

        if (mapping.AccountId == null && String.isNotBlank(mapping.Rut_Cliente__c))
        {
            String rutC = '', dvC = '';

            try
            {
                rutC = mapping.Rut_Cliente__c.split('-')[0];
                dvC = mapping.Rut_Cliente__c.split('-')[1];
            }
            catch (Exception ex) {
            }

            if (String.isNotBlank(rutC))
            {
                Account account = [SELECT Id FROM Account WHERE RUT__c =: rutC];

                if (account != null)
                {
                    Contact contact = [SELECT Id FROM Contact WHERE AccountId =: account.Id];

                    mapping.AccountId = account.Id;
                    mapping.ContactId = contact.Id;
                }
            }
        }

        if (mapping.Tipo_de_Requerimiento__c == 'Solicitudes' || mapping.Tipo_de_Requerimiento__c == 'Consultas' || mapping.Tipo_de_Requerimiento__c == 'Reclamos')
        {
            String[] atencionResponse = CreateCase_Atencion(mapping);
            mapping.ParentId = atencionResponse[0];

            if (mapping.Tipo_de_Requerimiento__c == 'Solicitudes' )
            {
                mapping.RecordTypeId = RecordTypeId_Solicitudes;
            }
            else if (mapping.Tipo_de_Requerimiento__c == 'Consultas')
            {
                mapping.RecordTypeId = RecordTypeId_Consultas;
            }
            else if (mapping.Tipo_de_Requerimiento__c == 'Reclamos')
            {
                mapping.RecordTypeId = RecordTypeId_Reclamos;
            }

            insert mapping;

            mapping = [SELECT Id, CaseNumber, ParentId FROM Case WHERE Id = :mapping.Id];

            response = new API_VS_Case_Response(mapping.ParentId, atencionResponse[1], mapping.Id, mapping.CaseNumber);
        }
        else {
            String[] atencionResponse = CreateCase_Atencion(mapping);
            response = new API_VS_Case_Response(atencionResponse[0], atencionResponse[1]);
        }

        return response;
    }

    @HttpGet
    global static Case getCase() {
        RestRequest request = RestContext.request;

        String parametro = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Case> casos = [SELECT Id FROM Case WHERE CaseNumber =: parametro];

        String caseId = '';

        if (casos.size() == 0)
        {
            caseId = parametro;
        }
        else
        {
            caseId = casos[0].Id;
        }

        DescribeSObjectResult describeCase = Case.getSObjectType().getDescribe();

        List<String> fieldNames = new List<String>(describeCase.fields.getMap().keySet());

        String query =  'SELECT ' + String.join(fieldNames, ',' ) + ' FROM Case WHERE Id = \''+ caseId +'\'';

        system.debug('@@@@ query '+query);

        List<Case> records = Database.query(query);

        if (records.size() > 0)
        {
            return records[0];
        }

        return null;
    }

    private static String[] CreateCase_Atencion(Case mapping)
    {
        Case caso = new Case();
        //case.ParentId  null,
        caso.SuppliedName  = mapping.SuppliedName;
        caso.SuppliedEmail  = mapping.SuppliedEmail;
        caso.SuppliedPhone  = mapping.SuppliedPhone;
        caso.SuppliedCompany  = mapping.SuppliedCompany;
        caso.RUT_Cliente__c  = mapping.RUT_Cliente__c;
        caso.SuppliedName  = mapping.SuppliedName;
        caso.RecordTypeId = RecordTypeId_Atencion;
        caso.Status = mapping.Status;
        caso.Origin= mapping.Origin;
        caso.Subject= mapping.Subject;
        caso.Priority= mapping.Priority;
        caso.Description= mapping.Description;
        caso.CurrencyIsoCode= mapping.CurrencyIsoCode;
        caso.OwnerId= mapping.OwnerId;
        caso.Canal__c= mapping.Canal__c;
        caso.Negocio__c= mapping.Negocio__c;
        caso.Tipo_de_Solicitante__c= mapping.Tipo_de_Solicitante__c;
        caso.AccountId = mapping.AccountId;
        caso.ContactId = mapping.ContactId;

        insert caso;

        caso = [SELECT Id, CaseNumber FROM Case WHERE Id = :caso.Id];
        String[] outResponse = new String[2];

        outResponse[0] = caso.Id;
        outResponse[1] = caso.CaseNumber;

        return outResponse;
    }

    @HttpPatch
    global static Case updateCase()
    {
        RestRequest request = RestContext.request;

        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        system.debug('@@@@ caseId -->  '+caseId);

        system.debug('@@@@ request --> '+request.requestbody.tostring());

        Case mapping = (Case)JSON.deserialize(request.requestbody.tostring(), Case.class);

        system.debug('@@@@ mapping -->  '+mapping);

        mapping.Id = caseId;

        update mapping;

        return mapping;
    }
}