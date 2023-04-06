/**
* VASS
* @author           Jessica Gómez
* @email: 			jessica.gomez@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    08/11/2021     Jessica Gómez JMGR 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
public class PolizaAsignaFrecuenciaTest {
    static testMethod void testPolizaAsignaFrecuencia(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFrecuenciaTest.testPolizaAsignaFrecuencia')){return;}
        /**********************************************************************************/
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Test.startTest();
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
            .Set('Frecuencia_de_Pago__c', 'Mensual')
            .save();
        
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c, Frecuencia_de_Pago__c, RecordTypeId  
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        PolizaAsignaFrecuencia.execute(polizaIndividualEncontrada[0], recordTypePolizaIndv);
        Test.stopTest();
    }
    
     static testMethod void testPolizaAsignaFrecuenciaTri(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFrecuenciaTest.testPolizaAsignaFrecuencia')){return;}
        /**********************************************************************************/
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Test.startTest();
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
            .Set('Frecuencia_de_Pago__c', 'Trimestral')
            .save();
         
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT Frecuencia_de_Pago__c, cuenta__c, RecordTypeId 
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
         PolizaAsignaFrecuencia.execute(polizaIndividualEncontrada[0], recordTypePolizaIndv);
         Test.stopTest();
    }
    
    static testMethod void testPolizaAsignaFrecuenciaSem(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFrecuenciaTest.testPolizaAsignaFrecuencia')){return;}
        /**********************************************************************************/
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Test.startTest();
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
            .Set('Frecuencia_de_Pago__c', 'Semestral')
            .save();
		
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT Frecuencia_de_Pago__c, cuenta__c, RecordTypeId 
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        PolizaAsignaFrecuencia.execute(polizaIndividualEncontrada[0], recordTypePolizaIndv);
        
        Test.stopTest();
    }
    
    static testMethod void testPolizaAsignaFrecuenciaAnual(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFrecuenciaTest.testPolizaAsignaFrecuencia')){return;}
        /**********************************************************************************/
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Test.startTest();
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
            .Set('Frecuencia_de_Pago__c', 'Anual')
            .save();
		
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT Frecuencia_de_Pago__c, cuenta__c, RecordTypeId 
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        PolizaAsignaFrecuencia.execute(polizaIndividualEncontrada[0], recordTypePolizaIndv);
        Test.stopTest();
    }
    static testMethod void testPolizaAsignaFrecuenciaUnica(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaFrecuenciaTest.testPolizaAsignaFrecuencia')){return;}
        /**********************************************************************************/
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        	Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        Test.startTest();
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
            .Set('Frecuencia_de_Pago__c', 'Única')
            .save();
		
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT Frecuencia_de_Pago__c, cuenta__c, RecordTypeId 
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        PolizaAsignaFrecuencia.execute(polizaIndividualEncontrada[0], recordTypePolizaIndv);
        Test.stopTest();
    }
}