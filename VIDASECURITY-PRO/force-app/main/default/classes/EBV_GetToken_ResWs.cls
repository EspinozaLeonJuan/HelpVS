public class EBV_GetToken_ResWs {

	public String access_token {get;set;} 
	public Integer expires_in {get;set;} 
	public Integer refresh_expires_in {get;set;} 
	public String refresh_token {get;set;} 
	public String token_type {get;set;} 
	public Integer not_before_policy {get;set;} // in json: not-before-policy
	public String session_state {get;set;} 
	public String scope {get;set;} 

	public EBV_GetToken_ResWs(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'access_token') {
						access_token = parser.getText();
					} else if (text == 'expires_in') {
						expires_in = parser.getIntegerValue();
					} else if (text == 'refresh_expires_in') {
						refresh_expires_in = parser.getIntegerValue();
					} else if (text == 'refresh_token') {
						refresh_token = parser.getText();
					} else if (text == 'token_type') {
						token_type = parser.getText();
					} else if (text == 'not-before-policy') {
						not_before_policy = parser.getIntegerValue();
					} else if (text == 'session_state') {
						session_state = parser.getText();
					} else if (text == 'scope') {
						scope = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'EBV_GetToken_ResWs consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static EBV_GetToken_ResWs parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new EBV_GetToken_ResWs(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
    
    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

}