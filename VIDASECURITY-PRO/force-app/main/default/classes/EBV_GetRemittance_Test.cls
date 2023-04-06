@isTest
public class EBV_GetRemittance_Test {
    @isTest
	public static void getremi() {
		List<EBV_GetRemittance.Input> inpuList = new List<EBV_GetRemittance.Input>();
        List<EBV_GetRemittance.remittanceOutput> output = new List<EBV_GetRemittance.remittanceOutput>();
        EBV_GetRemittance.Input input = new EBV_GetRemittance.Input();
        
		Integer response;	
        input.rut = '14595270';
        inpuList.add(input);
        String police = '282758';
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GetpoliceRespConstMock());
		output = EBV_GetRemittance.getReme(inpuList);
		Test.stopTest();
    }

}