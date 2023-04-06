@isTest
public class IngresaMotivoAnulacionEnPolizaTest {
	static {
		TriggerHandler.enable(IngresaMotivoAnulacionEnPoliza.class);
    }
    
    static TestMethod void test() {
        Test.startTest();
        
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Rescates / Traspasos';
        insert campaign;
        
        Id recordIdIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Id recordIdTraspaso = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Traspasos Out').getRecordTypeId();
        Id recordIdRescate = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Rescates').getRecordTypeId();
        
        Account a1 = new Account();
        a1.FirstName = 'Cccc';
        a1.LastName = 'Cccc';
        a1.Rut__c = '15315161';
        a1.Rut__pc = '15315161';
        a1.Rut_contacto__pc = '15315161';
        a1.DV__c = 'K';
        a1.DV_contacto__pc = 'K';
        insert a1;
        
        Poliza__c poliza1 = new Poliza__c();
        poliza1.RecordTypeId = recordIdIndividuales;
        poliza1.Cuenta__c = a1.Id;
        poliza1.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza1.Frecuencia_de_Pago__c = 'M';
        poliza1.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza1.Estatus__c = 'ANULADA';
        poliza1.Prima_Minima__c =  0.864000;
        poliza1.Valor_Poliza__c = 0;
        Poliza__c poliza2 = new Poliza__c();
        poliza2.RecordTypeId = recordIdIndividuales;
        poliza2.Cuenta__c = a1.Id;
        poliza2.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza2.Frecuencia_de_Pago__c = 'M';
        poliza2.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza2.Estatus__c = 'ANULADA';
        poliza2.Prima_Minima__c =  0.864000;
        poliza2.Valor_Poliza__c = 0;        
        insert new Poliza__c[]{poliza1, poliza2};
        
        Participantes_de_Campa_a__c par1 = new Participantes_de_Campa_a__c();
        par1.Name = 'Poliza traspaso test 1';
		par1.Campa_a_Vida_Security__c = campaign.Id;
		par1.Contacto__c = a1.PersonContactId;
		par1.Estado_Cierre__c= 'Abierto';
		par1.Nombre_de_Contacto__c = a1.Name;
		par1.Poliza__c = poliza1.Id;
		par1.Cuenta__c = a1.Id;
		par1.RecordTypeId = recordIdTraspaso;
        par1.Estado_de_Gesti_n__c = 'Pensión/Fallec./Venc.';       
        Participantes_de_Campa_a__c par2 = new Participantes_de_Campa_a__c();
        par2.Name = 'Poliza rescates test 1';
		par2.Campa_a_Vida_Security__c = campaign.Id;
		par2.Contacto__c = a1.PersonContactId;
		par2.Estado_Cierre__c= 'Abierto';
		par2.Nombre_de_Contacto__c = a1.Name;
		par2.Poliza__c = poliza2.Id;
		par2.Cuenta__c = a1.Id;
		par2.RecordTypeId = recordIdRescate;
        par2.Estado_de_Gesti_n__c = 'Asesoría del Agente';
        insert new Participantes_de_Campa_a__c[]{par1, par2};
        
        Poliza__c pol1 = [SELECT Id, Tipo_de_anulacion__c, Motivo_de_anulacion__c FROM Poliza__c WHERE Id =: poliza1.Id LIMIT 1];
        Poliza__c pol2 = [SELECT Id, Tipo_de_anulacion__c, Motivo_de_anulacion__c FROM Poliza__c WHERE Id =: poliza2.Id LIMIT 1];
        
        System.assertEquals(pol1.Tipo_de_anulacion__c, 'Traspaso Total');
        System.assertEquals(pol1.Motivo_de_anulacion__c, par1.Estado_de_Gesti_n__c);
        System.assertEquals(pol2.Tipo_de_anulacion__c, 'Rescate Total');
        System.assertEquals(pol2.Motivo_de_anulacion__c, par2.Estado_de_Gesti_n__c);
        
        Test.stopTest();
    }
}