/**
***********************************************************************************************************************/
@isTest
private class PolizaColectivoTriggerPCTest {
    @isTest static void PolizaColectivoTriggerPCTest(){
        Test.startTest();
        Account acc_1 = new Account(name= 'acc_1',recordtypeId ='012i0000000UrxnAAC', Rut__c ='3781561', DV__c='6');
        insert acc_1;
        Poliza__c pol_1 = new Poliza__c(cuenta__c=acc_1.Id );
   		insert pol_1;
        Poliza__c pol_2 = new Poliza__c(cuenta__c=acc_1.Id );
   		insert pol_2;
        
        Poliza_Colectivo__c item = new Poliza_Colectivo__c(cuenta__c=acc_1.Id,poliza__c=pol_1.Id);
        system.debug('@@@ poliza colectivo 1 : ' + item ); // se crea correctamente
   		insert item;
        
        Poliza_Colectivo__c item2 = new Poliza_Colectivo__c(cuenta__c=acc_1.Id,poliza__c=pol_1.Id);
        system.debug('@@@ poliza colectivo 2 : ' + item2 ); // coincide con el item
   		insert item2; 
        
        Poliza_Colectivo__c item3 = new Poliza_Colectivo__c(cuenta__c=acc_1.Id,poliza__c=pol_2.Id);
        system.debug('@@@ poliza colectivo 3 : ' + item3 ); // se inserta correctamente
   		insert item3;
        
        Poliza_Colectivo__c item4 = new Poliza_Colectivo__c(id=item3.Id, cuenta__c=acc_1.Id,poliza__c=pol_1.Id);
        system.debug('@@@ poliza colectivo 4 : ' + item4 ); // coincide con el item
   		update item4;
        
        Test.stopTest();
    }
}