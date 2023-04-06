/**
* VASS
* @author           Javier Cubillos
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    29/11/2021     Javier Cubillos JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class PolizaAsignaProductoTriggerTest {
    @testSetup 
    static void testsetup(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaProductoTriggerTest.testsetup')){return;}
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
    }

    static testMethod void testExecuteTrigger(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaProductoTriggerTest.testExecuteTrigger')){return;}
        /**********************************************************************************/
        List<Poliza__c> lPoliza = [
            SELECT Id , Codigo_de_Producto__c
            FROM Poliza__c ];
        Test.startTest();
        lPoliza[0].Codigo_de_Producto__c = '6600';
        SwitchTest.sNameMetadata = 'testClassFalse';
        update lPoliza;
        lPoliza[0].Codigo_de_Producto__c = '1300';
        update lPoliza;
        Test.stopTest();
    }
}