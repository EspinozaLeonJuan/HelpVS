@isTest(seealldata=false)
public class PolizaAsignaFactorEjecutivoTest {

	static testMethod void testPolizaAsignaFactorEjecutivo(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFactorEjecutivoTest.testPolizaAsignaFactorEjecutivo')){return;}
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
            CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        	Id idCorredor = (Id) corredor.get().get('Id'); 
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        	CategoriaPolizaGeneration categoriaPoliza = (CategoriaPolizaGeneration)Fabricate.categoriaPolizaTest().individual().save();
        	Id idCategoriaPoliza = (Id)categoriaPoliza.get().get('Id');
        
        
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
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
            .set('Categoria_de_Poliza__c', idCategoriaPoliza)
            .set('Valor_Poliza__c', 100)
            .save();
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c, Estatus__c, Prima_Total__c, Valor_Poliza__c FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        polizaIndividualEncontradA[0].Valor_poliza__c = 10;
        polizaIndividualEncontrada[0].Prima_Total__c = 100;        
        update polizaIndividualEncontrada;
        Test.startTest();
        List<Id> polizaIds = new List<Id>{polizaIndividualEncontrada[0].Id};
        Map<Id,Poliza__c> newMap = new Map<Id,Poliza__c>();
        Map<Id,Poliza__c> oldMap = new Map<Id,Poliza__c>();
        newMap.put(polizaIndividualEncontrada[0].Id,polizaIndividualEncontrada[0]);
        PolizaAsignaFactorEjecutivo.process(polizaIds,newMap,oldMap);
        oldMap.put(polizaIndividualEncontrada[0].Id,polizaIndividualEncontrada[0]);
        PolizaAsignaFactorEjecutivo.process(polizaIds,newMap,oldMap);
        Test.stopTest();
    }
}