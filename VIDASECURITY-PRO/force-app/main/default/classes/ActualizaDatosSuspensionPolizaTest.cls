@isTest
public class ActualizaDatosSuspensionPolizaTest {
    static {
        TriggerHandler.enable(ActualizaDatosSuspensionPolizaHandler.class);
    }
    
    static testMethod void Test(){
        String recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Solicitudes' LIMIT 1].Id;
        Test.startTest();
        
        Account a = Factory.buildAccount('Cuenta personal');
        insert a;
        
        Poliza__c p = new Poliza__c();
        p.Name = '12345678';
        p.Cantidad_de_meses_suspendido__c = '';
        p.Fecha_de_inicio_de_suspensi_n__c = null;
        p.Cuenta__c = a.Id;
        insert p;
        
        Date hoy = Date.today();
        Case c = new Case();
        c.RecordTypeId = recordTypeId;
        c.CASO_N_Poliza__c = p.Id;
        c.Cantidad_de_meses_suspendido__c = '3';
        c.Fecha_de_inicio_de_suspensi_n__c = hoy;
        c.Negocio__c = 'Seguros Individuales';
        c.CASO_Categoria__c = 'Cobranza';
        c.Detalle_Solicitud__c = 'Solicitud de suspensión de prima';
        c.Correo_electronico_Solicitante__c = 'test@test.com';
        c.Nombre_Solicitante__c = 'Test Test';
        c.RUT_Solicitante__c = '888777999';
        c.Telefono_Solicitante__c = '+598099111222';
        insert c;
        
        Poliza__c poliza = [SELECT Cantidad_de_meses_suspendido__c, Fecha_de_inicio_de_suspensi_n__c FROM Poliza__c WHERE Id =:p.Id];
        System.assertEquals('3',poliza.Cantidad_de_meses_suspendido__c);
        System.assertEquals(hoy, poliza.Fecha_de_inicio_de_suspensi_n__c);
                
        Test.stopTest();
    }
}