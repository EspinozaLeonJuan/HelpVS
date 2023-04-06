@isTest
public class RevisionCartasReclamosHandlerTest {
    static {
		TriggerHandler.enable(RevisionCartasReclamosHandler.class);
	}
    
	static testMethod void TestContactoNuevo() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Servicios Colectivos';
        caso.Canal__c = 'Servicios Colectivos';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }
    
	static testMethod void TestReclamo() {
        Id recordTypeReclamo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		//caso.Origin = 'Servicios Colectivos';
		caso.Tipo_de_Solicitante__c = 'Contratante';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
        caso.RecordTypeId = recordTypeReclamo;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        caso.Instancia_del_Reclamo__c = 'Primera';
        //caso.Entrega_Respuesta__c = true;
		insert caso;
        Attachment attachment = new Attachment(Name = 'RESPUESTA', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment;
        
        caso.Status = 'Cerrado';
        caso.Entrega_Respuesta__c = true;
        update caso;
		Test.stopTest();
    }
    
	static testMethod void TestReclamoCartaCliente() {
        Id recordTypeReclamo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		//caso.Origin = 'Servicios Colectivos';
		caso.Tipo_de_Solicitante__c = 'Contratante';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
        caso.RecordTypeId = recordTypeReclamo;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        caso.Instancia_del_Reclamo__c = 'Primera';
        caso.Carta_Cliente__c = true;
		insert caso;
        Attachment attachment = new Attachment(Name = 'CARTACLIENTE', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment;       
        
        Attachment attachment2 = new Attachment(Name = 'RESPUESTA', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment2;
        
        caso.Status = 'Cerrado';
        caso.Entrega_Respuesta__c = true;
        update caso;
		Test.stopTest();
    }

	static testMethod void TestReclamoCartaCliente2() {
        Id recordTypeReclamo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		//caso.Origin = 'Servicios Colectivos';
		caso.Tipo_de_Solicitante__c = 'Contratante';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
        caso.RecordTypeId = recordTypeReclamo;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
        caso.Instancia_del_Reclamo__c = 'Primera';
        caso.Carta_Cliente__c = true;
		insert caso;
        
        Attachment attachment = new Attachment(Name = 'OTRO', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment;
        
        Attachment attachment2 = new Attachment(Name = 'CARTACLIENTE', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment2;   
        
        Attachment attachment3 = new Attachment(Name = 'RESPUESTA', body = blob.valueof('b'), parentId = caso.Id);
		insert attachment3;        
        

        //caso.Status = 'Cerrado';
        caso.Entrega_Respuesta__c = true;
        
        update caso;
		Test.stopTest();
    }
    
}