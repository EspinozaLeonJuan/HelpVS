@isTest
private class TEST_FechaUltimoReclamoClienteBatch {
    @TestSetup
    static void setup(){
        List<Account> accounts = new List<Account>();
        List<Case> cases = new List<Case>();
        List<Poliza__c> polizas = new List<Poliza__c>();
        List<Case> reclamos = new List<Case>();
        Id recordTypeReclamo = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
        Id recordTypeAtencion = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Atención').getRecordTypeId();
		Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Fabricate.ejecutivoDeCliente().setUsuario(ejecutivo).save();
        
        accounts.add(new Account(FirstName = 'FirstName 1', LastName = 'LastName 1', Rut__c = '8898070', DV__c = '0', Rut_contacto__pc = '8898070', DV_contacto__pc = '0'));
        accounts.add(new Account(FirstName = 'FirstName 2', LastName = 'LastName 2', Rut__c = '21973677', DV__c = '0', Rut_contacto__pc = '21973677', DV_contacto__pc = '0'));
        accounts.add(new Account(FirstName = 'FirstName 3', LastName = 'LastName 3', Rut__c = '24678676', DV__c = '3', Rut_contacto__pc = '24678676', DV_contacto__pc = '3'));
        accounts.add(new Account(FirstName = 'FirstName 4', LastName = 'LastName 4', Rut__c = '18995110', DV__c = '8', Rut_contacto__pc = '18995110', DV_contacto__pc = '8'));
        accounts.add(new Account(FirstName = 'FirstName 5', LastName = 'LastName 5', Rut__c = '14425150', DV__c = '4', Rut_contacto__pc = '14425150', DV_contacto__pc = '4', OwnerId = ejecutivo.getId()));
        insert accounts;

        for (Account a : accounts) {
            Case caso = new Case();
            caso.RecordTypeId = recordTypeAtencion;
            caso.AccountId = a.Id;
            caso.Tipo_de_Solicitante__c = 'Contratante';
            caso.Canal__c = 'Call Center';
            caso.Subject = 'Prueba';
            caso.Description = 'Prueba';
            caso.Negocio__c = 'Seguros Individuales';
            cases.add(caso);
            
            Poliza__c poliza = new Poliza__c();
            poliza.RecordTypeId = recordTypeIndividuales;
            poliza.Cuenta__c = a.Id;
            poliza.Estatus__c = 'ACTIVA';
            poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
            poliza.Codigo_de_Producto__c = '9750';
            poliza.Fecha_Inicio_de_Poliza__c = date.today();
            poliza.N_Poliza__c = Integer.valueOf(a.Rut__c);
            polizas.add(poliza);            
        }

        insert cases;
        insert polizas;
        
        for (Case c : cases) {
			Case caso = new Case();
            caso.ParentId = c.Id;
            caso.Tipo_de_Requerimiento__c = 'Reclamos';
            caso.Tipo_de_Solicitante__c = 'Contratante';
            caso.RecordTypeId = recordTypeReclamo;
            caso.AccountId = c.AccountId;
            caso.Subject = c.Subject;
            caso.Description = c.Description;
            caso.Producto__c = 'Accidentes Personales';
            caso.Tipo_Operacion__c = 'Cargos-Cobranza-Movimientos';
            caso.Detalle_Operacion__c = 'Cobranza no despachada o fuera de plazo';
           	caso.Negocio__c = c.Negocio__c;
            caso.Canal__c = c.Canal__c;
            reclamos.add(caso);
        }
		insert reclamos;    
    }

    static testmethod void test() {
        Test.startTest();
        FechaUltimoReclamoClienteBatch myBatchObject = new FechaUltimoReclamoClienteBatch(); 
		Id batchId = Database.executeBatch(myBatchObject);
        Test.stopTest();
    }
}