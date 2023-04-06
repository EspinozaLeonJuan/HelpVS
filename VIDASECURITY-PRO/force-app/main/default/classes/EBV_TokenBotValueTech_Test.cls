@isTest
public class EBV_TokenBotValueTech_Test {
	@isTest
    Public static void GetToken(){
        List<EBV_TokenBotValueTech.Input> inpuList = new List<EBV_TokenBotValueTech.Input>();
        List<EBV_TokenBotValueTech.tokenOutput> output = new List<EBV_TokenBotValueTech.tokenOutput>();
        EBV_TokenBotValueTech.Input inpu = new EBV_TokenBotValueTech.Input();
        
        inpu.token = '';
        inpuList.add(inpu);
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GetTokenValueTechMock());
		output = EBV_TokenBotValueTech.getToken(inpuList);
		Test.stopTest();
    }
}