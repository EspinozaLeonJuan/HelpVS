@IsTest
public with sharing class AddRelationshipKeyToNotificacionTest {
    @IsTest
    public static void testAddRelationShipKeyToNotificacionCorredor(){
        AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
        CorredorFabricate corredor = Corredor.fabricate();
        ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
        String tipoNotificacion = 'Aviso de Bloqueo';

        Test.startTest();
        ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion(tipoNotificacion).save();
        Test.stopTest();

        //corredor-contacto-tipoNotificacion
        String llaveExpected = String.valueOf(corredor.getId()) + '-' + String.valueOf(contacto.getId()) + '-' + String.valueOf(tipoNotificacion);

        List<Lista_de_Distribucion__c> results = [SELECT Id, Llave_Relacion_Notificacion__c FROM Lista_de_Distribucion__c WHERE Id =: listaDistribucion.getId()];
        System.assert(results.size() > 0);
        System.assertEquals(llaveExpected, results[0].Llave_Relacion_Notificacion__c);
    }

    @IsTest
    public static void testAddRelationShipKeyToNotificacionCuenta(){
        AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
        CorredorFabricate corredor = Corredor.fabricate();
        ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
        String tipoNotificacion = 'Anulación Póliza';

        Test.startTest();
        ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCuenta().setCuenta(cuenta).setContacto(contacto).setTipoDeNotificacion(tipoNotificacion).save();
        Test.stopTest();

        //cuenta-contacto-tipoNotificacion
        String llaveExpected = String.valueOf(cuenta.getId()) + '-' + String.valueOf(contacto.getId()) + '-' + String.valueOf(tipoNotificacion);

        List<Lista_de_Distribucion__c> results = [SELECT Id, Llave_Relacion_Notificacion__c FROM Lista_de_Distribucion__c WHERE Id =: listaDistribucion.getId()];
        System.assert(results.size() > 0);
        System.assertEquals(llaveExpected, results[0].Llave_Relacion_Notificacion__c);
    }
   
}