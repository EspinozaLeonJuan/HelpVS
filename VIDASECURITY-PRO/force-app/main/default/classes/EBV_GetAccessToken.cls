public with sharing class EBV_GetAccessToken {
    
    public static String getToken(){
        
        String token;
        HttpRequest req = new HttpRequest();
		req.setMethod('POST');
		req.setHeader('Content-Type','application/x-www-form-urlencoded');
		req.setEndpoint('https://sso.security.cl/auth/realms/VS-Clients/protocol/openid-connect/token');

		String CLIENT_ID = 'vs-valuetech';
		//String USERNAME = '17119809-7';
		//String PASSWORD = 'vida2021';
        String grant_type = 'client_credentials';
        String client_secret = 'a32d14c0-93ca-4f59-84fc-9e0955a5a30d';

		req.setBody('client_id='+CLIENT_ID +'&grant_type='+grant_type +'&client_secret='+client_secret);

		Http http = new Http();
        
        try{
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            EBV_GetToken_ResWs r = EBV_GetToken_ResWs.parse(res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());
            token = r.access_token;
            
        }catch(Exception e){
            System.debug(e.getMessage());
            return 'ERROR';
        }
        
        return token;
    }
       
}