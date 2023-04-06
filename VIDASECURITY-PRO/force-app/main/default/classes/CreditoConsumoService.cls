public with sharing class CreditoConsumoService {

    public static System.HttpRequest getCreditOfferRequest(String numPol, Integer rut){
        Integer linCod = 1;

        numPol = String.isEmpty(numPol) ? '' : numPol;
        
        if (rut == 0 || rut == null) 
            throw new IdcException('El rut del cliente es un campo requerido para consultar por un crédito');

        System.HttpRequest request = IDCApi.getOfertaCreditoRequest(linCod, numPol, rut);

        return request;
    }

    public static CreditoConsumo mapCreditOfferResponse(HttpResponse httpResponse){

        IDCResponse response = (IDCResponse)JSON.deserialize(httpResponse.getBody(), IDCResponse.class);

        CreditoConsumo creditoConsumo = new CreditoConsumo();
        creditoConsumo.montoMaximo = response.Nmonmax; //monto maximo credito
        creditoConsumo.numCuotas = response.Nplamax; //num cuotas maximo
        creditoConsumo.montoCuota = response.Ncuomax; //monto maximo cuota

        return creditoConsumo;
    }

    public static void updateAccountCreditInfo(Account account, CreditoConsumo creditoConsumo){
        account.Monto_Cuota_Credito_RV__c = creditoConsumo.montoCuota;
        account.Monto_Maximo_Credito_RV__c = creditoConsumo.montoMaximo;
        account.Numero_Cuotas_Credito_RV__c = creditoConsumo.numCuotas;
        upsert account;
    }
}