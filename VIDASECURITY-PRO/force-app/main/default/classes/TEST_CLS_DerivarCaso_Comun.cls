/*******************************************************************************************
 *  NOMBRE                 : TEST_CLS_DerivarCaso_Comun
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
public class TEST_CLS_DerivarCaso_Comun {
     @isTest static void RequerimientoEscritorioDigital()
    {
        Test.startTest();
        String Solicitud =  'ED - Endoso Aumento de Prima en Exceso'; 
        String ID = '';
        String UsuarioID = '';
		String response = CLS_DerivarCaso_Comun.RequerimientoEscritorioDigital(ID, UsuarioID);
        Test.stopTest();        
    }

    @isTest static void ValidaPropietarioCaso_01()
    {
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '16790926';
        a.DV_contacto__pc = '4';
        insert a;

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
        caso1.OwnerId = [select id from user where Name = 'Manuel Eduardo Poblete López'].Id;
        update caso1;
        CLS_DerivarCaso_Comun.ValidaPropietarioCaso(caso1);    
       
        Test.stopTest();
    }
    
    @isTest static void ValidaPropietarioCaso_02()
    {
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '16790926';
        a.DV_contacto__pc = '4';
        insert a;

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
        caso1.OwnerId = '00G0H0000063lQV';
        update caso1;
        CLS_DerivarCaso_Comun.ValidaPropietarioCaso(caso1);    
       
        Test.stopTest();
    }
    
    
    @isTest static void RequerimientoED_nulo()
    {
        Test.startTest();
        Boolean valido = CLS_DerivarCaso_Comun.DerivacionPermitida('00G0H0000063lQV');
        Test.stopTest();        
    }
}