/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_DerivarCaso
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
@istest
public class TEST_CTR_DerivarCaso {   

  
    @istest static void derivarCasos_Consultas()
    {
        Test.startTest();
        CTR_DerivarCaso Con = new CTR_DerivarCaso();
        Con.Prueba = 'Consultas';
        Con.derivarCasos();            
            
        Test.stopTest();
    }
    
    @istest static void derivarCasos_Reclamos()
    {
        Test.startTest();
        CTR_DerivarCaso Con = new CTR_DerivarCaso();
        Con.Prueba = 'Reclamos';
        Con.derivarCasos();            
            
        Test.stopTest();
    }
    
    @istest static void derivarCasos_Solicitudes()
    {
        Test.startTest();
        CTR_DerivarCaso Con = new CTR_DerivarCaso();
        Con.Prueba = 'Solicitudes';
         Account cuenta = Factory.crearAccountAnonimo();
        Case caso2 = Factory.buildCasoSF('Solicitudes',cuenta);
        insert caso2;
        
        ApexPages.currentPage().getParameters().put('Id', caso2.Id);
        Con.derivarCasos();            
            
        Test.stopTest();
    }
    
    
    /*@istest static void derivarCasos_Solicitudes()
    {
        Test.startTest();
        CTR_DerivarCaso Con = new CTR_DerivarCaso();
        Con.Prueba = 'Solicitudes';
        Con.derivarCasos();            
            
        Test.stopTest();
    }*/
     @istest static void derivarCasos_Solicitudes_Especial()
    {
        Test.startTest();
        CTR_DerivarCaso Con = new CTR_DerivarCaso();
        Con.Prueba = 'Especial';
        Con.derivarCasos();            
            
        Test.stopTest();
    }
    
    @istest static void EscenarioDerivaCasoSolicitudUnico()
    {
        try{
            Test.startTest();
            
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
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';
          
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            insert caso2;            

            system.debug('@@@@ CASO SOLICITUD TEST => ' + caso2);
            
			PageReference pag = Page.SEC_VF_UR_derivacioncaso;
    		Test.setCurrentPage(pag);      
        
            pag.getParameters().put('id',caso2.Id);
            system.debug('PAGINA => ' + pag);
           
            CTR_DerivarCaso clsDU = new CTR_DerivarCaso();
            clsDU.derivarCasos();            
            
            Test.stopTest();
        }catch(system.Exception ex){
            system.debug('@@@@ TEST DERIVA 1 => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
        }
    }
    
    @istest static void EscenarioDerivaCasoConsultaUnico()
    {
        try{
            Test.startTest();
            
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
            caso2.Detalle_Solicitud__c = 'Solicitud nuevo FUN';
            //caso2.Account = a;
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';
          
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consultas' AND SobjectType = 'Case'].Id;
            insert caso2;            

            system.debug('@@@@ CASO SOLICITUD TEST => ' + caso2);
            
			PageReference pag = Page.SEC_VF_UR_derivacioncaso;
    		Test.setCurrentPage(pag);      
        
            pag.getParameters().put('id',caso2.Id);
            system.debug('PAGINA => ' + pag);
           
            CTR_DerivarCaso clsDU = new CTR_DerivarCaso();
            clsDU.derivarCasos();            
            
            Test.stopTest();
        }catch(system.Exception ex){
            system.debug('@@@@ TEST DERIVA 1 => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
        }
    }  
    
    @istest static void EscenarioDerivaCasoReclamoUnico()
    {
        try{
            Test.startTest();
            
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
            caso2.Detalle_Solicitud__c = 'Solicitud nuevo FUN';            
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';            
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Reclamos' AND SobjectType = 'Case'].Id;
            insert caso2;            

            system.debug('@@@@ CASO SOLICITUD TEST => ' + caso2);
            
			PageReference pag = Page.SEC_VF_UR_derivacioncaso;
    		Test.setCurrentPage(pag);      
        
            pag.getParameters().put('id',caso2.Id);
            system.debug('PAGINA => ' + pag);
            
            CTR_DerivarCaso clsDU = new CTR_DerivarCaso();
            
            clsDU.derivarCasos();            
            
            Test.stopTest();
        }catch(system.Exception ex){
            system.debug('@@@@ TEST DERIVA 1 => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
        }
    }    
    
    @istest static void EscenarioDerivaCasosMasivos()
    {
        try{
            Test.startTest();
            
            Account a = new Account();
            a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            a.FirstName = 'H1';
            a.LastName = 'H2';
            a.PersonEmail = 'test@msystem.cl';
            a.Rut_contacto__pc = '16790926';
            a.DV_contacto__pc = '4';
            insert a;
            
            system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);
            
            Case caso1 = new Case();
            caso1.Tipo_de_Solicitante__c = 'Contratante';
            caso1.Canal__c = 'Asistencia Agente';
            caso1.Negocio__c = 'RRVV';
            caso1.AccountId = a.Id;
            caso1.ContactId = a.PersonContactId;
            caso1.Tipo_de_Cliente__c = 'Cliente Normal';
            caso1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;
            insert caso1;
            
            system.debug('@@@@ CASO ATENCION TEST MASIVO => ' + caso1);
            
            Case caso2 = new Case();
            caso2.ParentId = caso1.Id;
            caso2.Tipo_de_Solicitante__c = 'Contratante';
            caso2.Canal__c = 'Asistencia Agente';
            caso2.Negocio__c = 'RRVV';
			caso2.CASO_Categoria__c = 'Endoso RRVV';
            caso2.Detalle_Solicitud__c = 'Solicitud periodo garantizado';            
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';           
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            insert caso2;            

            system.debug('@@@@ CASO SOLICITUD TEST MASIVO => ' + caso2);
            
            Case caso3 = new Case();
            caso3.ParentId = caso1.Id;
            caso3.Tipo_de_Solicitante__c = 'Contratante';
            caso3.Canal__c = 'Asistencia Agente';
            caso3.Negocio__c = 'RRVV';
			caso3.CASO_Categoria__c = 'Endoso RRVV';
            caso3.Detalle_Solicitud__c = 'Solicitud periodo garantizado';            
            caso3.AccountId = a.Id;
            caso3.ContactId = a.PersonContactId;
            caso3.Tipo_de_Cliente__c = 'Cliente Normal';        
            caso3.Tipo_de_Requerimiento__c = 'Consultas';
            caso3.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Consultas' AND SobjectType = 'Case'].Id;
            insert caso3;            

            system.debug('@@@@ CASO CONSULTAS TEST MASIVO => ' + caso3);

            Case caso4 = new Case();
            caso4.ParentId = caso1.Id;
            caso4.Tipo_de_Solicitante__c = 'Contratante';
            caso4.Canal__c = 'Asistencia Agente';
            caso4.Negocio__c = 'RRVV';
			caso4.CASO_Categoria__c = 'Endoso RRVV';
            caso4.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
            //caso2.Account = a;
            caso4.AccountId = a.Id;
            caso4.ContactId = a.PersonContactId;
            caso4.Tipo_de_Cliente__c = 'Cliente Normal';
            /*
            caso2.Correo_electronico_Solicitante__c = 'h@h.cl';
            caso2.Nombre_Solicitante__c = 'Nombre';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Nombre_Solicitante__c = 'HH';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Telefono_Solicitante__c = '1234567890';*/
            caso4.Tipo_de_Requerimiento__c = 'Reclamos';
            caso4.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Reclamos' AND SobjectType = 'Case'].Id;
            insert caso4;            

            system.debug('@@@@ CASO RECLAMOS TEST MASIVO => ' + caso4);            
            
			PageReference pag = Page.SEC_VF_UR_derivacionmasivacasos;
    		Test.setCurrentPage(pag);      
            
            List<Case> lsCasos = new List<Case>();
            lsCasos.add(caso1);
            lsCasos.add(caso2);
            lsCasos.add(caso3);
            lsCasos.add(caso4);  
            
            system.debug('@@@@ LISTA CASOS MASIVOS => ' + lsCasos);
            
			ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(lsCasos);
            ssc.setSelected(lsCasos);
            CLS_DerivacionSelectivaCasos clsDU = new CLS_DerivacionSelectivaCasos(ssc);
            clsDU.cargaCasosHijosDerivar();            
            
            Test.stopTest();
        }catch(system.Exception ex){
            system.debug('@@@@ TEST DERIVA CASOS MASIVOS => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
        }
    }

    @istest static void EscenarioCierreAtencionEvaluaHijos()
    {
        try{
            Test.startTest();
            
            Account a = new Account();
            a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            a.FirstName = 'H1';
            a.LastName = 'H2';
            a.PersonEmail = 'test@msystem.cl';
            a.Rut_contacto__pc = '16790926';
            a.DV_contacto__pc = '4';
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
            
            system.debug('@@@@ CASO ATENCION TEST MASIVO => ' + caso1);
            
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
            /*
            caso2.Correo_electronico_Solicitante__c = 'h@h.cl';
            caso2.Nombre_Solicitante__c = 'Nombre';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Nombre_Solicitante__c = 'HH';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Telefono_Solicitante__c = '1234567890';*/
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            caso2.Status = 'Cerrado';
            insert caso2;            

            system.debug('@@@@ CASO SOLICITUD TEST MASIVO => ' + caso2);
            
            Case caso3 = new Case();
            caso3.ParentId = caso1.Id;
            caso3.Tipo_de_Solicitante__c = 'Contratante';
            caso3.Canal__c = 'Asistencia Agente';
            caso3.Negocio__c = 'RRVV';
			caso3.CASO_Categoria__c = 'Endoso RRVV';
            caso3.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
            //caso2.Account = a;
            caso3.AccountId = a.Id;
            caso3.ContactId = a.PersonContactId;
            caso3.Tipo_de_Cliente__c = 'Cliente Normal';
            /*
            caso2.Correo_electronico_Solicitante__c = 'h@h.cl';
            caso2.Nombre_Solicitante__c = 'Nombre';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Nombre_Solicitante__c = 'HH';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Telefono_Solicitante__c = '1234567890';*/
            caso3.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso3.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            caso3.Status = 'Cerrado';
            insert caso3;            

            system.debug('@@@@ CASO CONSULTAS TEST MASIVO => ' + caso3);

            Case caso4 = new Case();
            caso4.ParentId = caso1.Id;
            caso4.Tipo_de_Solicitante__c = 'Contratante';
            caso4.Canal__c = 'Asistencia Agente';
            caso4.Negocio__c = 'RRVV';
			caso4.CASO_Categoria__c = 'Endoso RRVV';
            caso4.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
            //caso2.Account = a;
            caso4.AccountId = a.Id;
            caso4.ContactId = a.PersonContactId;
            caso4.Tipo_de_Cliente__c = 'Cliente Normal';
            /*
            caso2.Correo_electronico_Solicitante__c = 'h@h.cl';
            caso2.Nombre_Solicitante__c = 'Nombre';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Nombre_Solicitante__c = 'HH';
            caso2.RUT_Solicitante__c = a.Rut__c;
            caso2.Telefono_Solicitante__c = '1234567890';*/
            caso4.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso4.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            caso4.Status = 'Nuevo';
            insert caso4;            

            system.debug('@@@@ CASO RECLAMOS TEST MASIVO => ' + caso4);            

            CaseComment comentario = new CaseComment();
            comentario.CommentBody = 'TEST';
            comentario.ParentId = caso2.Id;
            insert comentario;
            
            caso1.OwnerId = [select id from user where Name = 'Manuel Eduardo Poblete López'].Id;
            update caso1;
            
            caso1.Status = 'Cerrado';
            update caso1;
            
            Test.stopTest();
        }catch(system.Exception ex){
            system.debug('@@@@ TEST DERIVA CASOS MASIVOS => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
        }
    }    
}