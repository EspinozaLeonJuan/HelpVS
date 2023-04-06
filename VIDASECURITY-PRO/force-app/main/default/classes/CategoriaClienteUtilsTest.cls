@isTest (seealldata=false)
private class CategoriaClienteUtilsTest {
 	@isTest static void asignarCategoriaDeCliente(){
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
	    Id cuentaId = (Id)cuenta.get().get('Id');
        Account cuent = [SELECT Id FROM Account WHERE Id =: cuentaId];
        
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        
        
        PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(cuentaId)
            .set('Cuenta__c', cuentaId)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '6900')
            .set('Con_o_Sin_Ahorro__c', 'Sin Ahorro')
            .set('DV__c', 'K')
            .set('CurrencyIsoCode', 'CLF')
            .set('Edad_al_Momento_de_Contratar__c', 36)
            .set('Empresa_Origen__c', 'Vida Security')
            .set('Es_Anulable__c', false)
            .set('Estatus__c', 'ACTIVA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Valor_Poliza__c', 60)
            .set('Prima_Total__c', 4)
            .save();
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c, RecordTypeId  , Estatus__c , Prima_Total__c, Categoria_de_Poliza__c, Con_o_Sin_Ahorro__c, Frecuencia_de_Pago__c, Valor_Poliza__c, Rut_Corredor__c, Corredor__c, Codigo_Agente__c, RUT_Empresa__c, Codigo_de_Producto__c
            FROM Poliza__c 
            WHERE cuenta__c =: cuentaId 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        set<String> cuentasIds = new set<String>();
        cuentasIds.add(cuentaId);
        
        
        List<String> sName = CategoriaClienteUtils.asignarCategoriaDeCliente(cuentasIds);
    }
}