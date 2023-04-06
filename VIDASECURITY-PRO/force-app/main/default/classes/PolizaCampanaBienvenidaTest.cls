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
* @version   1.0    11/11/2021     Jessica Gómez JMGR 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
public class PolizaCampanaBienvenidaTest {

    static testMethod void testPolizaCampanaBienvenida(){
        if(!TestVerificationService.ShouldExecute('PolizaCampanaBienvenidaTest.testPolizaCampanaBienvenida')){return;}
        /**********************************************************************************/
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278')
            					 .set('Codigo_Agente__c', '00001053').save();
        Id idContacto = (Id) contacto.get().get('Id');
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .Set('Agente_Actual__c', idContacto)
            .save();
        Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
            CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        	Id idCorredor = (Id) corredor.get().get('Id'); 
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '1100')
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
            .set('Codigo_Agente__c', '00001053')
            .save();
        Test.startTest();
        List<Poliza__c> lstPoliza = [
            SELECT Id, Cuenta__c, Nombre_de_Producto__c, Estatus__c, Fecha_Inicio_de_Poliza__c, RecordTypeId, Codigo_de_Producto__c
            FROM Poliza__c 
            LIMIT 1];
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put(lstPoliza[0].Id , lstPoliza[0] );
        PolizaCampanaBienvenida.execute( lstPoliza, newMap );
		Test.stopTest();
    }
    static testMethod void testPolizaCampanaBienvenida1(){
        if(!TestVerificationService.ShouldExecute('PolizaCampanaBienvenidaTest.testPolizaCampanaBienvenida1')){return;}
        /**********************************************************************************/
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278')
            					 .set('Codigo_Agente__c', '00001053').save();
        Id idContacto = (Id) contacto.get().get('Id');
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .Set('Agente_Actual__c', idContacto)
            .save();
        Id idCuenta = (Id)cuenta.get().get('Id');
         	Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
            CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        	Id idCorredor = (Id) corredor.get().get('Id'); 
        	CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '6600')
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
            .set('Codigo_Agente__c', '00001053')
            .set('Nombre_de_Producto__c', 'Cruz Sanatorio')
            .save();
        Test.startTest();
        List<Poliza__c> lstPoliza = [
            SELECT Id, Cuenta__c, Nombre_de_Producto__c, Estatus__c, Fecha_Inicio_de_Poliza__c, RecordTypeId, Codigo_de_Producto__c
            FROM Poliza__c 
            LIMIT 1];
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put(lstPoliza[0].Id , lstPoliza[0] );
        PolizaCampanaBienvenida.execute( lstPoliza, newMap );
		Test.stopTest();
    }
    
    static testMethod void testPolizaCampanaBienvenida2(){
        if(!TestVerificationService.ShouldExecute('PolizaCampanaBienvenidaTest.testPolizaCampanaBienvenida2')){return;}
        /**********************************************************************************/
		Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true).set('RUT_Empresa__c','482123880').save();
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '1100')
            .set('Con_o_Sin_Ahorro__c', 'Sin Ahorro')
            .set('DV__c', 'K')
            .set('CurrencyIsoCode', 'CLF')
            .set('Edad_al_Momento_de_Contratar__c', 36)
            .set('Empresa_Origen__c', 'Vida Security')
            .set('Es_Anulable__c', false)
            .set('Estatus__c', 'ACTIVA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Inicio_de_Poliza__c', system.today())
            .save();	
        Test.startTest();
        List<Poliza__c> lstPoliza = [
            SELECT Id, Cuenta__c, Nombre_de_Producto__c, Estatus__c, Fecha_Inicio_de_Poliza__c, RecordTypeId, Codigo_de_Producto__c
            FROM Poliza__c 
            LIMIT 1];
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put(lstPoliza[0].Id , lstPoliza[0] );
        PolizaCampanaBienvenida.execute( lstPoliza, newMap );
		Test.stopTest();
    }
    
    static testMethod void testPolizaCampanaBienvenida3(){
        if(!TestVerificationService.ShouldExecute('PolizaCampanaBienvenidaTest.testPolizaCampanaBienvenida3')){return;}
        /**********************************************************************************/
		Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
            
        
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278')
            					 .set('Codigo_Agente__c', '00001053').save();
        Id idContacto = (Id) contacto.get().get('Id');
		AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .Set('Agente_Actual__c', idContacto)
            .save();
        Id idCuenta = (Id)cuenta.get().get('Id');
        PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '1100')
            .set('Con_o_Sin_Ahorro__c', 'Sin Ahorro')
            .set('DV__c', 'K')
            .set('CurrencyIsoCode', 'CLF')
            .set('Edad_al_Momento_de_Contratar__c', 36)
            .set('Empresa_Origen__c', 'Vida Security')
            .set('Es_Anulable__c', false)
            .set('Estatus__c', 'ACTIVA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Inicio_de_Poliza__c', system.today())
            .save();	
        Test.startTest();
        List<Poliza__c> lstPoliza = [
            SELECT Id, Cuenta__c, Nombre_de_Producto__c, Estatus__c, Fecha_Inicio_de_Poliza__c, RecordTypeId, Codigo_de_Producto__c
            FROM Poliza__c 
            LIMIT 1];
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put(lstPoliza[0].Id , lstPoliza[0] );
        PolizaCampanaBienvenida.execute( lstPoliza, newMap );
		Test.stopTest();
    }
}