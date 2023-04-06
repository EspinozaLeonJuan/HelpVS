@RestResource(urlMapping='/log/*')
global class LogWebService {

	@HttpPost
	global static String doPost(String message, String stackTrace) {
		try {
			message = EncodingUtil.base64Decode(message).toString();
			stackTrace = EncodingUtil.base64Decode(stackTrace).toString();
		} catch (exception e) {}
		Log log = new Log(LogWebService.class, true);
		log.error(message, stackTrace);
		log.commitLogs();
		RestResponse res = RestContext.response;
		res.addHeader('ContentType', 'application/json');
		return '{"status": "success"}';
	}
}