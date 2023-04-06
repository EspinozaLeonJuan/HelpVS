@istest
public class TEST_CLS_CM_CierreParticipantesCampagna {
    public TEST_CLS_CM_CierreParticipantesCampagna() {

    }
    
    @isTest static void Cierre_PC_Televentas_Vigentes()
    {
        Test.startTest();
               Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(5);
        insert poliza;
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
      /*  
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        p.Poliza__c = poliza.Id;
        p.Estado_Cierre__c = 'Abierto';
        p.Mandato_Final__c = 'PAT';
        insert p;
        system.debug('@@@@ p ' + p);
        Participantes_de_Campa_a__c p1 = new Participantes_de_Campa_a__c();
        p1.Name = 'Prueba de participante';
        
        p1.Campa_a_Vida_Security__c = cam.Id;
        p1.Contacto__c = contact.Id;
        p1.Poliza__c = poliza.Id;
        p1.Estado_Cierre__c = 'En proceso';
        p1.Mandato_Final__c = 'PAT';
        p1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
        insert p1;*/
        
        
        List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = cam.Id;
		pc1.Cuenta__c = account.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = cam.Id;
		pc2.Cuenta__c = account.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
		listaPc.add(pc2);
        
        insert listaPc;
      //system.debug('@@@@ p1 ' + p1);
        Participantes_de_Campa_a__c[] members = [SELECT Id, RecordType.Name, Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, CreatedDate, Fecha_ltimo_Pago__c, Comentario__c FROM Participantes_de_Campa_a__c];
                                                 //WHERE RecordType.Name = 'Cobranzas Televenta' AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice') FOR UPDATE];//;AND Estado_Cierre__c IN ('Abierto', 'En proceso', 'Backoffice')];
        
        
        system.debug('@@@@ members1 ' + members);
          CLS_CM_CierreParticipantesCampagna j = new CLS_CM_CierreParticipantesCampagna();
        j.Cierre_PC_Televentas_Vigentes();
        //String sch = '0 0 23 * * ?'; 
        //system.schedule('Prueba Job Cierra Participantes ', sch, j); 
        Test.stopTest(); 
     	
    }
    
    @isTest static void Cierre_PC_Televentas_Anuladas()
    {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(5);
        poliza.Estatus__c = 'ANULADA';
        insert poliza;
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
       
        
        List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = cam.Id;
		pc1.Cuenta__c = account.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
        pc1.Poliza__c = poliza.Id;
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = cam.Id;
		pc2.Cuenta__c = account.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
        pc2.Poliza__c = poliza.Id;
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas Televenta').getRecordTypeId();
		listaPc.add(pc2);
        
        insert listaPc;
        
      
        CLS_CM_CierreParticipantesCampagna j = new CLS_CM_CierreParticipantesCampagna();
        j.Cierre_PC_Televentas_Anuladas();
        //String sch = '0 0 23 * * ?'; 
        //system.schedule('Prueba Job Cierra Participantes ', sch, j); 
        Test.stopTest(); 
     	
    }
    
    @isTest static void Cierre_PC_PostVenta_Vigentes()
    {
        Test.startTest();
       
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(5);
        insert poliza;
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = cam.Id;
		pc1.Cuenta__c = account.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
        pc1.Poliza__c = poliza.Id;
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = cam.Id;
		pc2.Cuenta__c = account.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
        pc2.Poliza__c = poliza.Id;
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
		listaPc.add(pc2);
        
        insert listaPc;
        
      
          CLS_CM_CierreParticipantesCampagna j = new CLS_CM_CierreParticipantesCampagna();
        j.Cierre_PC_PostVenta_Vigentes();
        //String sch = '0 0 23 * * ?'; 
        //system.schedule('Prueba Job Cierra Participantes ', sch, j); 
        Test.stopTest(); 
     	
    }
    
    @isTest static void Cierre_PC_PostVenta_Anuladas()
    {
        Test.startTest();
        
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(5);
        poliza.Estatus__c = 'ANULADA';
        insert poliza;
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = cam.Id;
		pc1.Cuenta__c = account.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
        pc1.Poliza__c = poliza.Id;
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = cam.Id;
		pc2.Cuenta__c = account.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
        pc2.Poliza__c = poliza.Id;
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
		listaPc.add(pc2);
        
        insert listaPc;
      
        CLS_CM_CierreParticipantesCampagna j = new CLS_CM_CierreParticipantesCampagna();
        j.Cierre_PC_PostVenta_Anuladas();
        //String sch = '0 0 23 * * ?'; 
        //system.schedule('Prueba Job Cierra Participantes ', sch, j); 
        Test.stopTest(); 
     	
    }
    
    
}