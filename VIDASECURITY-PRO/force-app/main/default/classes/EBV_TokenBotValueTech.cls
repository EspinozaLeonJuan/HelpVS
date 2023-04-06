public class EBV_TokenBotValueTech {

    public class Input {
        @InvocableVariable()
        public String token;
    }
    public class tokenOutput {
        @InvocableVariable()
        public String tokenvalutech;
    }
    
    @InvocableMethod(label='Get Token Valuetech')
    public static List<tokenOutput> getToken(List<Input> Input){
        List<tokenOutput> OutPut = new List<tokenOutput>();   
        tokenOutput tokenn = new tokenOutput();
        String token;
        Set<String> tokenInput = new Set<String>();
        
        for(Input OrderInput :Input){
            tokenInput.add(OrderInput.token);
            token = OrderInput.token;
        }
        
        token = EBV_GetTokenValueTech.getToken();
        tokenn.tokenvalutech = token;
        
        OutPut.add(tokenn);        
        
        return Output;
    }
}