@isTest
private class ChangeStatusCampaignTest {
    @isTest static void testChangeStatus() {
        List<Participantes_de_Campa_a__c> updateParticipantesTest = ChangeStatusCampaign.ChangeStatus('2015-07-16', '2022-02-04', 'Finalizado (Cierre Administrativo)','a020H000017TN1iQAG');   
    }   
}