global class PartnerAPI {
	
	global static Session login(String environment, String username, String password, String token) {
		Session.SessionEnvironment env = environment == 'sandbox' ? Session.SessionEnvironment.SANDBOX : Session.SessionEnvironment.PRODUCTION;
		Session session = new Session(env, username, password, token);
		session.login();
		return session;
	}
	
	global static Session login(String username, String password, String token) {
		Organization organization = [SELECT IsSandbox FROM Organization LIMIT 1];
		return login(organization.isSandbox ? 'sandbox' : 'production', username, password, token);
	}
}