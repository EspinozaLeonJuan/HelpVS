@isTest
public class TEST_CLS_CasoParticipanteController {
    @isTest static void cargaDatosParticipante() {
        Test.startTest();
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Aumento Prima 2019';
        insert cam;
        
   		Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
    
        CLS_CasoParticipanteController Con = new CLS_CasoParticipanteController();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(p.Id));
   
        Con.IdTest = p.Id;
        Con.cargaDatosParticipante();
        
        Test.stopTest();
    }
    
    @isTest static void getVarValue() {
        Test.startTest();
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Aumento Prima 2019';
        insert cam;
        
   		Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        //p.Contacto__c = contact.Id;s
        system.debug('@@@@ - part ' + p);
        
        CLS_CasoParticipanteController Con = new CLS_CasoParticipanteController();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(p.Id));
    
  
        Con.IdTest = p.Id;
        Con.getVarValue();
        
        Test.stopTest();
    }  
    
	@isTest static void getVarValue2() {
        Test.startTest();
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Aumento Prima 2019';
        insert cam;
        
   		Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        //p.Contacto__c = contact.Id;s
        system.debug('@@@@ - part ' + p);
        
        CLS_CasoParticipanteController Con = new CLS_CasoParticipanteController();
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(p.Id));
    
  
        Con.IdTest = p.Id;
        Con.part = p;
        Con.getVarValue();
        
        Test.stopTest();
    }
    
    @isTest static void toDerivar() { 
        Test.startTest();
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Aumento Prima 2019';
        insert cam;
        
   		Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        
			Account a = new Account();
            a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            a.FirstName = 'H1';
            a.LastName = 'H2';
            a.PersonEmail = 'test@msystem.cl';
            a.Rut_contacto__pc = '17702700';
            a.DV_contacto__pc = '6';
            insert a;
            
            system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);
            
            Case caso1 = new Case();
            caso1.Tipo_de_Solicitante__c = 'Contratante';
            caso1.Canal__c = 'Asistencia Agente';
            caso1.Negocio__c = 'RRVV';
            //caso1.Account = a;
            caso1.AccountId = a.Id;
            caso1.ContactId = a.PersonContactId;
            caso1.Tipo_de_Cliente__c = 'Cliente Normal';
            caso1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;
            insert caso1;
            
            system.debug('@@@@ CASO ATENCION TEST => ' + caso1);
            
            Case caso2 = new Case();
            caso2.ParentId = caso1.Id;
            caso2.Tipo_de_Solicitante__c = 'Contratante';
            caso2.Canal__c = 'Asistencia Agente';
            caso2.Negocio__c = 'RRVV';
			caso2.CASO_Categoria__c = 'Endoso RRVV';
            caso2.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
            //caso2.Account = a;
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';
            
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            insert caso2;
        
        //p.Contacto__c = contact.Id;s
        system.debug('@@@@ - part ' + p);
        
        CLS_CasoParticipanteController Con = new CLS_CasoParticipanteController();
        Con.IdCasoHijo = caso2.Id;
        
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(p.Id));
        
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('Id_Participante', p.Id);
        inputs.put('Id_Caso_Hijo', caso2.Id);     
        
    	Flow.Interview myFlow = Flow.Interview.createInterview('Flujo_Caso_Aumento_Prima', inputs);
		
        Con.IdTest = p.Id;
        Con.part = p;
        Con.ToDerivar();
        
        Test.stopTest();
    }
}