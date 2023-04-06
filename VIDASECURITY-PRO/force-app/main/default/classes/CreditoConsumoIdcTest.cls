@isTest
public with sharing class CreditoConsumoIdcTest {

    @TestSetup
	public static void init() {
        AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().personal();
        CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate();
        PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().rentasVitalicias().activa().mandatoria().setCorredor(corredor).setCuenta(cuenta).save();
    }
    //check credit

    @IsTest
	public static void testCreditoConsumoIDC(){

        AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().load(new String[] {'Rut__c','Rut__pc','Rut_contacto__pc','isPersonAccount','Monto_Cuota_Credito_RV__c','Monto_Maximo_Credito_RV__c','Numero_Cuotas_Credito_RV__c'});

        Test.startTest();
        ApexPages.StandardController standardController = new ApexPages.StandardController(cuenta.get());
		CreditoConsumoIdcController controller = new CreditoConsumoIdcController(standardController);
        
        // Invoke the continuation by calling the action method
        Continuation conti = (Continuation)controller.checkCreditAvailableInit();

        // Verify that the continuation has the proper requests
        Map<String, HttpRequest> requests = conti.getRequests();
        System.assert(requests.size() == 1);
        System.assert(requests.get(controller.requestLabel) != null);

        // Perform mock callout 
        // (i.e. skip the callout and call the callback method)
        HttpResponse response = new HttpResponse();
        String responseJson = '{"Codmsg": 0,"Mensaje": "","Ncuomax": 40108,"Nmonmax": 1286447,"Nplamax": 45,"Nvaluf": 28274,"Ntasanull": 1.55,"Pzabruuf": 6,"Totaldesc": 11191}';
        response.setBody(responseJson);   
        // Set the fake response for the continuation     
        Test.setContinuationResponse(controller.requestLabel, response);
        // Invoke callback method
        Object result = Test.invokeContinuationMethod(controller, conti);

        Test.stopTest();
        // result is the return value of the callback
        
        System.Pagereference page = standardController.view();
        page.setRedirect(true);

        // System.assertEquals(page, result);

        // Verify that the controller's result variable
        //   is set to the mock response.
        // System.assertEquals(responseJson, controller.result);
        System.assert(controller.creditoConsumo != null);
        System.assert(controller.creditoConsumo.getCreditAvailable());

        Account accountResult = [SELECT Id, Monto_Cuota_Credito_RV__c, Monto_Maximo_Credito_RV__c, Numero_Cuotas_Credito_RV__c FROM Account LIMIT 1];

        System.assertEquals(45, accountResult.Numero_Cuotas_Credito_RV__c);
        System.assertEquals(1286447, accountResult.Monto_Maximo_Credito_RV__c);
        System.assertEquals(40108, accountResult.Monto_Cuota_Credito_RV__c);
    }

    @IsTest
    public static void testCreditoConsumoIDCPendingCoverage(){
        Test.startTest();
        CreditoConsumo cred = new CreditoConsumo(0,0,0);
        // String result = HttpUtils.send('method','endpoint','body',new Map<String,String>());
        IDCResponse resp = new IDCResponse();
        resp.Nvaluf = 0;
        resp.Ntasanull = 0;
        resp.Pzabruuf = 0;
        resp.Totaldesc = 0;
        resp.Codmsg = 0;
        resp.Mensaje = '';

        Integer codmsg = resp.Codmsg;
        String msg = resp.Mensaje;
        Test.stopTest();
    }
    
    @isTest
    public static void testdoFormatting()
    {
        Test.startTest();
        CreditoConsumoIdcController.doFormatting(Decimal.valueOf('1000000'), 0, '.', ',');
    	Test.stopTest();    
    }
}