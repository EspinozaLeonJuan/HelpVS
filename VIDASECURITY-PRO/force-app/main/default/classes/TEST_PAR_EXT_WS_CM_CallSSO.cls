@IsTest 
public class TEST_PAR_EXT_WS_CM_CallSSO {
     @isTest static void go()
     {
         Test.startTest();
         PAR_EXT_WS_CM_CallSSO clase = new PAR_EXT_WS_CM_CallSSO();
         clase.access_token = '22342432dsfsdf';
         clase.expires_in  = 0;
         clase.refresh_expires_in = 0;
         clase.refresh_token  = 'Y';
         clase.token_type  = 'T';
         clase.session_state  ='ok';
         clase.scope = 'Sites-Clients';      
         Test.stopTest();
     }
}