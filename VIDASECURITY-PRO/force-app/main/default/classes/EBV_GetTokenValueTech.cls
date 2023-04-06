public class EBV_GetTokenValueTech {

    public static String getToken() {
        String token;
        String usernam = 'vsintapp';
        String pass = 'bWPJbB@08OZM';
        String body = '{UserName:"'+usernam+'",Password:"'+pass+'"}';
        
        HttpRequest req = new HttpRequest();
        
        req.setMethod('POST');
        
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('ClientId', 'vt-vidasecurity');
        
        req.setEndpoint('https://kta.vidasecurity.cl/vwnetx_VidaSecurity_WSReembolso/api/login/authenticate');
	
        req.setBody(body);
        
        
        Http http = new Http();
        try{
            req.setTimeout(20000);
            HTTPResponse res = http.send(req);
            
            System.debug('este es el body '+res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());
            String r = EBV_GetTokenValueTech_RES.parse(res.getBody());
            token = r;
        }
        catch(Exception e){
            System.debug(e.getMessage());
            return 'ERROR';
        }

        return token;
    }
    
    
      
}