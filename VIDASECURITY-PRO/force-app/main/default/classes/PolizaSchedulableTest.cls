/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-26-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
private class PolizaSchedulableTest {
    @isTest static void polizaSchTest() {
		Test.startTest();
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
	    Id cuentaId = (Id)cuenta.get().get('Id');
        Account cuent = [SELECT Id FROM Account WHERE Id =: cuentaId];
	    Set<Account> cuentas = new Set<Account>{cuent};
        Set<Id> cuentasId = new Set<Id>{cuentaId};
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        Id idCorredor = (Id) corredor.get().get('Id'); 
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
       
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
            .set('Corredor__c', idCorredor)
            .set('Rut_Corredor__c', '77508900')
            .save();
         List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c, RecordTypeId  , Estatus__c , Prima_Total__c, Categoria_de_Poliza__c, Con_o_Sin_Ahorro__c, Frecuencia_de_Pago__c, Valor_Poliza__c, Rut_Corredor__c, Corredor__c, Codigo_Agente__c, RUT_Empresa__c, Codigo_de_Producto__c
            FROM Poliza__c 
            WHERE cuenta__c =: cuentaId 
            AND RecordTypeId = :recordTypePolizaIndv];
        Map<Id, Poliza__c> newMap = new  Map<Id, Poliza__c>();          
        Map<Id, Poliza__c> oldMap = new  Map<Id, Poliza__c>();
        List<Id> polizaIds = new List<Id>();
        for(Poliza__c oh : polizaIndividualEncontrada)
        {
            newMap.put(oh.Id, oh);
            polizaIds.add(oh.Id);
        }
        List<Account> cuentaList = [
            SELECT Id
            FROM Account 
            WHERE Id =: cuentaId ];
        Map<Id, Account> accMap = new Map<Id, Account>(); 
        for(Account acc : cuentaList){
            accMap.put(acc.Id, acc);
        }
        PolizaQueueable queue = new PolizaQueueable('LOGIC', polizaIndividualEncontrada, oldMap,  newMap); 
		PolizaSchedulable scheduleJob = new PolizaSchedulable(queue, false, 'LOGIC', polizaIndividualEncontrada,  oldMap, newMap);
        PolizaQueueable queue1 = new PolizaQueueable('AfterUpdate', polizaIndividualEncontrada, oldMap,  newMap); 
		PolizaQueueable queue2 = new PolizaQueueable('AfterInsert', polizaIndividualEncontrada, oldMap,  newMap); 
		PolizaQueueable queue3 = new PolizaQueueable('BeforeInsert', polizaIndividualEncontrada, oldMap,  newMap); 
		PolizaQueueable queue4 = new PolizaQueueable('BeforeUpdate', polizaIndividualEncontrada, oldMap,  newMap); 
		PolizaSchedulable scheduleJob1 = new PolizaSchedulable(queue, false, 'AfterUpdate', polizaIndividualEncontrada,  oldMap, newMap);
        PolizaSchedulable scheduleJob2 = new PolizaSchedulable(queue, false, 'AfterInsert', polizaIndividualEncontrada,  oldMap, newMap);
        PolizaSchedulable scheduleJob3 = new PolizaSchedulable(queue, false, 'BeforeInsert', polizaIndividualEncontrada,  oldMap, newMap);
        PolizaSchedulable scheduleJob4 = new PolizaSchedulable(queue, false, 'BeforeUpdate', polizaIndividualEncontrada,  oldMap, newMap);
        
        scheduleJob.execute(null);
        scheduleJob1.execute(null);
        scheduleJob2.execute(null);
        scheduleJob3.execute(null);
        scheduleJob4.execute(null);
		Test.stopTest();

	}

}