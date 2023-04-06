@IsTest
public with sharing class TEST_API_VS_Case {

    @isTest static void execute()
    {
        Test.startTest();

        Account acc = new Account();
        acc.FirstName = 'A';
        acc.LastName = 'B';
        acc.RUT__c = '1';
        acc.DV__c= '9';
        insert acc;

        Poliza__c p = new Poliza__c();
        p.N_Poliza__c = 1;
        p.Name = '1';
        p.Cuenta__c = acc.Id;
        insert p;

        String json = '{'+
            '"Tipo_de_Requerimiento__c": "Solicitudes",'+
            '"Status": "Nuevo",'+
            '"Origin": "WEB",'+
            '"Canal__c": "WEB",'+
            '"Priority": "Media",'+
            '"CurrencyIsoCode": "CLF",'+
            '"Atencion_Presencial__c": true,'+
            '"Tipo_de_Solicitante__c": "Contratante",'+
            '"Cliente_Compania__c": true,'+
            '"Cerrado_por_Usuario_de_Autoservicio__c": false,'+
            '"Solicita_envio_a_otra_direccion__c": false,'+
            '"Visible_en_el_Portal_de_Autoservicio__c": false,'+
            '"Negocio__c": "Seguros Individuales",'+
            '"CASO_Categoria__c": "Siniestros/Rescates",'+
            '"Detalle_Solicitud__c": "ED - Solicitud de Rescate Parcial",'+
            '"Subject": "ED - Solicitud de Rescate Parcial",'+
            '"Detalle_de_Rescate__c": "Rescate Parcial",'+
            '"Tipo_de_Moneda__c": "Monto en CLP",'+
            '"Description": "",'+
          //  '"Pago_de_Rescate__c": "Forma de Pago: Depósito Bancario\r\nMonto rescate:null\r\nTipo de Cuenta: Cuenta corriente\r\nBanco: BANCO DE CHILE\r\nNÃºmero de cuenta: 76543210",'+
             '"Monto_Rescate__c" : 4500000,'+
             '"SuppliedName": "A B",'+
             '"SuppliedEmail": "juanespinozaleon@ibm.com",'+
             '"SuppliedPhone": "+56995879999",'+
             '"Correo_electronico_alternativo__c": "juespinoza@security.cl",'+
             '"Telefono_de_Contacto__c": "+56995879999",'+
             '"Nombre_Completo_Razon_Social__c": "A B",'+
             '"RUT_Cliente__c":"1-9",'+
            '"CASO_Poliza_Asoc__c": 12028945,'+
            '"CASO_N_Poliza__r": {'+
                '"N_Poliza__c": 1'+
            '},'+
            '"CASO_Poliza_Producto__c": "CRUZ MCS",'+
            '"Derivacion_Automatica__c": true'+
          '}';

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();
            req.requestURI = '';
            req.httpMethod = 'POST';
            req.requestBody= Blob.valueOf(json);
            RestContext.request = req;

            RestContext.response= res;

            API_VS_CASE_Response respnse = API_VS_Case.createCase();



            RestRequest req2 = new RestRequest();
//            RestResponse res = new RestResponse();

            req2.httpMethod = 'GET';
            req2.requestURI = '/services/apexrest/Cases/Case/'+respnse.Id;
            RestContext.request = req2;
          // RestContext.response= res;
            API_VS_Case.getCase();

            String json2 = '{'+
              '"Status": "Cancelado"'+
          '}';
            RestRequest req3 = new RestRequest();
            req3.httpMethod = 'PATCH';
            req3.requestURI = '/services/apexrest/Cases/updateCase/'+respnse.Id;
            req3.requestBody= Blob.valueOf(json2);
            RestContext.request = req3;

            API_VS_Case.updateCase();
            Test.stopTest();
    }


}