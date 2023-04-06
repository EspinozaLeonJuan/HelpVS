public with sharing class CreditoConsumoIdcController {

    public Account cuenta { get; set;}
    public Boolean hasPolizaToCheckCredit {get; set;}
    public Poliza__c polizaRV { get; set;}

    public CreditoConsumo creditoConsumo { get; set;}

    public String Monto_Maximo_Credito {get; set;}
    
    public String Monto_Cuota_Credito {get; set;}
    
    //Continuation variables
    public String requestLabel;
    
    public CreditoConsumoIdcController(ApexPages.StandardController controller) {
        System.debug('--- CreditoConsumoIdcController.constructor BEGIN');
        if (!Test.isRunningTest())
            controller.addFields(new String[] {'Rut__c','Rut__pc','Rut_contacto__pc','isPersonAccount','Monto_Cuota_Credito_RV__c','Monto_Maximo_Credito_RV__c','Numero_Cuotas_Credito_RV__c'});
        this.cuenta = (Account)controller.getRecord();
        this.Monto_Maximo_Credito = '$ '+ doFormatting(this.cuenta.Monto_Maximo_Credito_RV__c, 0, '.',',');
        this.Monto_Cuota_Credito = '$ '+ doFormatting(this.cuenta.Monto_Cuota_Credito_RV__c, 0, '.',',');
    }
    
    public static String doFormatting(Decimal val, integer dec, String tSep, String dSep) {
        if (val == null)
            return '';
        
        String s, tmp;
        Integer i = 4 + dec;
     
        // If the number of decimals is zero (0)... prevents the first 1000s seperator from being set at the 4th.
        if(dec==0){
            i--;
        }
     
        s = val.setScale(dec).toPlainString().replace(tSep, dSep);
        while(s.length() > i) {
            tmp = s.substring(0, s.length() - i) + tSep + s.substring(s.length() - i);
            s = tmp;
            i += 4;
        }
     
        // If the number is negative and has a number non-decimal digits divisible by 3, it prevents putting a comma before the 1st digit (ex -300,000.00  comes out -,300,000.00)
        if (s.substring(0,1) == '-') {
            if (s.substring(1,2) == tSep) {
                s = '-' + s.substring(2);
            }
        }
     
        return s;
    }

    private void getPolizaRV(){
        System.debug('--- CreditoConsumoIdcController.getPolmivboofo agplbñlbvcizaRV BEGIN');
        Id rentasVitaliciasRecordTypeId = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Rentas Vitalicias').getRecordTypeId();

        List<Poliza__c> polizas = [
            SELECT Id, Name 
            FROM Poliza__c 
            WHERE Estatus__c = 'Activa' 
            AND p_liza_mandatoria__c = true
            AND RecordTypeId =: rentasVitaliciasRecordTypeId
            AND Cuenta__c =: this.cuenta.Id];

        this.hasPolizaToCheckCredit = !polizas.isEmpty();

        if (this.hasPolizaToCheckCredit)
            this.polizaRV = polizas[0];

    }

    public Object checkCreditAvailableInit(){
        System.debug('--- CreditoConsumoIdcController.checkCreditAvailableInit BEGIN');
        try {
            this.getPolizaRV();

            // if (!this.hasPolizaToCheckCredit)
            //     return null;

            //isPersonAccount y determinar cual es el rut correcto
            //System.debug(this.cuenta.Rut__c);
            Integer rut = this.cuenta.isPersonAccount ? Integer.valueOf(this.cuenta.Rut_contacto__pc) : Integer.valueOf(this.cuenta.Rut__c);
            String numPol =  this.hasPolizaToCheckCredit ? this.polizaRV.Name : null ;// '2016426';
            // Integer rut = Integer.valueOf(this.cuenta.Rut__c); //6763290;
            System.HttpRequest request = CreditoConsumoService.getCreditOfferRequest(numPol, rut);
            
            Continuation cont = getContinuation(request); 
            return cont;
            
        } catch (Exception e) {
            System.debug(e);
            PageUtils.addError(e);
            return redirectoToStd();
        }
    }

    private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- CreditoConsumoIdcController.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(40);
        ctx.continuation.continuationMethod = 'checkCreditAvailableCallback';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);

        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }

    public Object checkCreditAvailableCallback(){
        System.debug('--- CreditoConsumoIdcController.checkCreditAvailableCallback BEGIN');
        
        try { 
            HttpResponse response = System.Continuation.getResponse(this.requestLabel);
            if (!Test.isRunningTest() && response.getStatusCode() != 200)
                throw new IdcException('No se ha obtenido respuesta válida desde Sistema IDC. Código de respuesta servicio: ' + response.getStatusCode());
                
            if (String.isEmpty(response.getBody())){
                // throw new IdcException('No se ha obtenido respuesta desde sistema IDC.');
                this.creditoConsumo = new CreditoConsumo(null, null, null);
                
            }
            else{
                this.creditoConsumo = CreditoConsumoService.mapCreditOfferResponse(response);
            }   

            CreditoConsumoService.updateAccountCreditInfo(this.cuenta, this.creditoConsumo);
            System.debug(this.cuenta);
            
            
        } catch (Exception e) {
            System.debug(e);
            return PageUtils.addError(e);
        }
        System.debug('--- CreditoConsumoIdcController.checkCreditAvailableCallback END');
        return redirectoToStd();
    }

    public System.Pagereference redirectoToStd(){
        System.Pagereference page = new ApexPages.StandardController(this.cuenta).view();
        page.setRedirect(true);
         //System.Pagereference page = new Pagereference('/' + this.cuenta.Id);
        return page;
    }
}