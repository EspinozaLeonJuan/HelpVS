@isTest
public class TEST_CLS_INV_ObtieneCliente {
	@isTest
    public static void ActualizaDatos ()
    {
        Test.startTest();
        Campana_Vida_Security__c cmp = new Campana_Vida_Security__c();
        cmp.Name = 'Test Campaign';
        insert cmp;
        Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c();
        Account cuenta = Factory.crearAccountAnonimo();        
        participante.Nombres_del_Cliente__c = cuenta.Name;        
        Poliza__c poliza = new Poliza__c();
        poliza.Name = '171399';
        poliza.Estatus__c = '171399';
        poliza.Duracion_Poliza__c = '171399';
        poliza.Moneda_Poliza__c = '171399';
        poliza.Regimen_Tributario__c = '171399';
        poliza.Modalidad_APV__c = '171399';
        poliza.Edad_al_Momento_de_Contratar__c = 28;
        poliza.Rut_Asegurado__c = '12345678';
        poliza.DV__c = '1';
        poliza.RecordTypeId = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();        
        poliza.Cuenta__c = cuenta.Id;
        
        insert poliza;
        
        Contact contacto = Factory.buildContact(cuenta);
        insert contacto;
        participante.Campa_a_Vida_Security__c = null;
        participante.P_liza_1_Recuperacion__c = poliza.Name;
        participante.Contacto__c = contacto.Id;
        participante.Campa_a_Vida_Security__c = cmp.Id;
        insert participante; 
        
        List<String> Ids = new List<String>();
        Ids.add(participante.Id);        
        CLS_INV_ObtieneCliente.ActualizaDatos(Ids);
        Test.stopTest();
    }
}