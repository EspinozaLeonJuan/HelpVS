global class SEC_ACEPTA_Services {
	
    public static Map<String, Object> doAceptaCommunication(String point, String body, String method){
		URL_API_Acepta__c servicio = URL_API_Acepta__c.getOrgDefaults();
        
        String endpoint = servicio.Endpoint__c;
        
        Http h = new Http();
        String url = endpoint + point;
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setHeader('Accept', 'application/json');
        req.setHeader('X-API-KEY', servicio.API_KEY__c);
        req.setHeader('Content-Type', 'application/json');
        if(body != null && body != ''){
	        req.setBody(body);
        }
        
        HttpResponse res = new HttpResponse();
        res = h.send(req);
       
        Map<String, Object> bodyResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());         
        return bodyResponse;
    }    
    
}