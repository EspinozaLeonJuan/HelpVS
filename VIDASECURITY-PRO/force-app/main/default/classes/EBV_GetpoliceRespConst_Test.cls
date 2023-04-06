@isTest
public class EBV_GetpoliceRespConst_Test {
    @isTest
	public static void getPoliTest() {

		Integer response;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GetpoliceRespConstMock());
		response = EBV_GetpoliceRespConst.getRemi('14595270');
		Test.stopTest();
		//System.assert(response != 'ERROR', 'This service call should return a string containing a token.');
    }

	@isTest
	public static void getPoli() {
		List<EBV_GetPolizas.rutInput> inpuList = new List<EBV_GetPolizas.rutInput>();
        List<EBV_GetPolizas.polizasOutput> output = new List<EBV_GetPolizas.polizasOutput>();
        EBV_GetPolizas.rutInput input = new EBV_GetPolizas.rutInput();
        
		Integer response;	
        input.rut = '14595270';
        inpuList.add(input);
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GetpoliceRespConstMock());
		output = EBV_GetPolizas.getPoliza(inpuList);
		Test.stopTest();
    }
}