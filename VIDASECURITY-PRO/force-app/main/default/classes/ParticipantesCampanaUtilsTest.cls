@isTest()
private class ParticipantesCampanaUtilsTest {

    static testmethod void testExecute(){
        
        List<Participantes_de_Campa_a__c> testRecords=new List<Participantes_de_Campa_a__c>();
        
        for(integer i=0;i<99;i++){
            Participantes_de_Campa_a__c record=new Participantes_de_Campa_a__c();
            record.name='TestName'+i;
            testRecords.add(record);
            
        }
        insert testRecords;
        
        String idsConcatenated='';
        List<Participantes_de_Campa_a__c> idRecords=new List<Participantes_de_Campa_a__c>();
        for(Participantes_de_Campa_a__c record :[SELECT id FROM Participantes_de_Campa_a__c] ){
            idsConcatenated=idsConcatenated+record.id+',';
        }
        
        PageReference pageRef = Page.ActualizarEstadoCierreView;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ids', idsConcatenated);
        
        Participantes_de_Campa_a__c participante= new Participantes_de_Campa_a__c();
        ApexPages.StandardController sc = new ApexPages.StandardController(participante);
        ParticipantesCampanaUtils controller=new ParticipantesCampanaUtils(sc);
        
        Test.startTest();
        	controller.participante.Estado_Cierre__c='Finalizado';
        	controller.passValueToController();
        	controller.ActualizarEstadoCierre();
        Test.stopTest();
        
        List<Participantes_de_Campa_a__c> recordsToEvaluate=[Select Id, Estado_Cierre__c FROM Participantes_de_Campa_a__c];
        
        Integer counter=0;
        for(Participantes_de_Campa_a__c recordToEvaluate:[Select Id, Estado_Cierre__c FROM Participantes_de_Campa_a__c]){
            if(recordToEvaluate.Estado_Cierre__c=='Finalizado'){
                counter++;
            }
        }
        
        
        system.assertEquals(99, counter);
    }
    
    
    
    
}