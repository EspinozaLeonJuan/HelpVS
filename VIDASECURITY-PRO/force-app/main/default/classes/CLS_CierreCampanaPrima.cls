public class CLS_CierreCampanaPrima implements Schedulable {
	
    public void execute(SchedulableContext sc) {
        Participantes_de_Campa_a__c[]  members = [SELECT Id, Poliza__c, Fecha_ltimo_Pago__c, CreatedDate, Comentario__c, Estado_Cierre__c FROM Participantes_de_Campa_a__c WHERE Mandato_Final__c IN ('PAT', 'PAC', 'PAC Otros', 'Mandato Empleador') AND Estado_Cierre__c NOT IN ('Finalizado') FOR UPDATE];

        for (Participantes_de_Campa_a__c member : members) {
            if (member.Fecha_ltimo_Pago__c != null) {
                if (member.Fecha_ltimo_Pago__c >= member.CreatedDate) {
                    member.Comentario__c = 'Finalizado recaudando normalmente.';
                    member.Estado_de_Gesti_n_Primera_Prima__c = 'Recauda Normalmente';
                    member.Estado_Cierre__c = 'Finalizado';
                } else {
                    member.Comentario__c = '';
                }
            } else {
                member.Comentario__c = '';
            }            
        }
        
        upsert members;
        
    }
}