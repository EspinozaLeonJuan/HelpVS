/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-20-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class MOCK_CLS_COL_Response_Poliza_VS  implements HttpCalloutMock{

    public HTTPResponse respond(HttpRequest req){
        HTTPResponse res = new HTTPResponse();

        res.setHeader('Content-Type', 'application/json');
        String body ='{'+
        '     \"httpCode\":200,'+
        '     \"httpMessage\":\"OK - Success\",'+
        '     \"moreInformation\":\"200 - Transaccion Correcta.\",'+
        '     \"internal_id\":\"-\",'+
        '     \"policies\":[{\"renewalId\":11073816,'+
        '     \"policyNumber\":281946,'+
        '     \"insuranceCoRut\":99301000,'+
        '     \"insuranceCoDv\":\"6\",'+
        '     \"tradeGroup\":{\"number\":450648,'+
        '     \"name\":\"BANCO  SECURITY (1 DESGRAVAMEN) \"},'+
        '     \"contractor\":{\"rut\":97053000,'+
        '     \"dv\":\"2\",'+
        '     \"name\":\"BANCO SECURITY .\"},'+
        '     \"company\":{\"rut\":97053000,'+
        '     \"dv\":\"2\",'+
        '     \"name\":\"BANCO SECURITY . \",'+
        '     \"businessActivity\":\"FINANCIERA\"},'+
        '     \"broker\":{\"rut\":77371990,'+
        '     \"dv\":\"K\",'+
        '     \"name\":\". CORREDORES DE SEGUROS  SECURITY LTDA\"},'+
        '     \"status\":\"VIGENTE\",'+
        '     \"firstTerm\":\"2013-06-01T00:00:00\",'+
        '     \"startDate\":\"2021-06-01T00:00:00\",'+
        '     \"endDate\":\"2022-05-31T00:00:00\",'+
        '     \"renewal\":6,'+
        '     \"productDescription\":\"DESGRAVAMEN MASIVO CONSUMOS\",'+
        '     \"numberOfHolders\":36177,'+
        '     \"numberOfBeneficiaries\":0,'+
        '     \"hasBlockedBenefits\":\"NO\",'+
        '     \"hasDebt\":\"SI\",'+
        '     \"hasHealthBenefits\":\"NO\",'+
        '     \"hasPendingRequirements\":\"NO\",'+
        '     \"insuredStatus\":null}]'+
    '}';

        res.setBody(body);
        res.setStatusCode(200);
        return res;
    }

}