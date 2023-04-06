@IsTest
public class WSAccessLoginMock extends WSMock {

	public WSAccessLoginMock() {
		responseElement = new WSAccess.LoginResponse_element();
		WSAccess.LoginResponse_element response = (WSAccess.LoginResponse_element)responseElement;
		response.LoginResult = new WSAccess.DatoAcceso();
		response.LoginResult.AccesoValido = true;
		response.LoginResult.IdPersistencia = 123456;
	}
}