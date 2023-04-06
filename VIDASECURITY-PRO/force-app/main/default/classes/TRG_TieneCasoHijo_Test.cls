@istest
public class TRG_TieneCasoHijo_Test {

    static string rutCuenta = '88888888';
    static string dvCuenta = '8';
    static string mailCuenta = 'mail@cuenta.cl';
  
    
    private static Account crearAccountAnonimo(){
        Account cuenta = new Account();
        cuenta.Name = 'Anonimo';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
        cuenta.Rut__c = '99999998';
        cuenta.DV__c = '0';
        insert cuenta;
        return cuenta;
    }
    
    private static Case buildCaso(String recordTypeName, Account cuenta, Id parentId) {
        Case caso = new Case();
        caso.Canal__c = 'Sucursal';
        caso.Tipo_de_Contacto__c = 'Contratante';        
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Detalle Solicitud';
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.Tipo_de_Requerimiento__c = recordTypeName;
        //caso.ParentId = '5000H000016Yi68';//caso atencion PRO con solicitudes
        //caso.ParentId = '500f0000007FWXmAAO'; //caso atencion QA con solicitudes, consulta, reclamo
        //caso.ParentId = [SELECT Id FROM CASE LIMIT 1].Id;
        caso.ParentId = parentId;
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
       
        return caso;
    }
    
    @istest static void CreaCaso_Solicitudes()
    {        
        Account cuenta = Factory.cuenta.buildInsert();
        
        Test.startTest();
        
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;   
        
        Case caso1 = buildCaso('Solicitudes', cuenta, caso.Id);    
        insert caso1;
        
        Case caso2 = buildCaso('Consultas', cuenta, caso.Id);    
        insert caso2;
        
        Case caso3 = buildCaso('Reclamos', cuenta, caso.Id);    
        insert caso3;
       
    /*    caso.Comments = 'comentarios';
        update caso;
        
        delete caso;*/
        
        delete caso1;
        delete caso2;
        delete caso3;
        
        Test.stopTest();
    }
    
   
}