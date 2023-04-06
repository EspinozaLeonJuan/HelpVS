public class ConcatenaNombreProductoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		if (!ControlTest.ConcatenaNombreProducto && Test.isRunningTest())
			return;
    
		Set<Id> participanteIds = new Set<Id>();
		if (Trigger.new != null) {
			for (Poliza_de_Participante_de_Campana__c ppc : (Poliza_de_Participante_de_Campana__c[])Trigger.new) {
				if (!participanteIds.contains(ppc.Participante_de_Campana__c))
					participanteIds.add(ppc.Participante_de_Campana__c);
			}
		}
		
		if (Trigger.old != null) {
			for (Poliza_de_Participante_de_Campana__c ppc : (Poliza_de_Participante_de_Campana__c[])Trigger.old) {
				if (!participanteIds.contains(ppc.Participante_de_Campana__c))
					participanteIds.add(ppc.Participante_de_Campana__c);
			}
		}
        
		Poliza_de_Participante_de_Campana__c[] ppcs = [SELECT Nombre_de_Producto__c, Participante_de_Campana__c FROM Poliza_de_Participante_de_Campana__c WHERE Participante_de_Campana__c IN :participanteIds];
		Map<Id, Participantes_de_Campa_a__c> participanteMap = new Map<Id, Participantes_de_Campa_a__c>();
		for (Poliza_de_Participante_de_Campana__c ppc : ppcs) {
			Participantes_de_Campa_a__c participante = participanteMap.get(ppc.Participante_de_Campana__c);
			if (participante == null) {
				participante = new Participantes_de_Campa_a__c(Id = ppc.Participante_de_Campana__c, Nombres_de_Productos__c = ppc.Nombre_de_Producto__c == null ? '' : ppc.Nombre_de_Producto__c);
				participanteMap.put(ppc.Participante_de_Campana__c, participante);
			} else {
				participante.Nombres_de_Productos__c += '/' + (ppc.Nombre_de_Producto__c == null ? '' : ppc.Nombre_de_Producto__c);
			} 
		}
		update participanteMap.values();
	}
}