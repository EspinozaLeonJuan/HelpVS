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
private class VSL_AsignacionDeOportunidad_PolizaTest {
    @testSetup 
    static void testsetup(){
        if(!TestVerificationService.ShouldExecute('VSL_AsignacionDeOportunidad_PolizaTest.testsetup')){return;}
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
        
        Id LinkRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').recordtypeid;
        
        Opportunity testOpportunity = new Opportunity(
            RecordTypeId = LinkRecordType,
            StageName = 'prueba',
            CloseDate = system.today()+5,
            Cuenta__c = idCuenta,
            AccountId = idCuenta,
            Name = 'Test Opportunity Triggers');
        insert testOpportunity;

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
        if(!TestVerificationService.ShouldExecute('TestAccountTriggerTest.testExecuteTrigger')){return;}
        /**********************************************************************************/
        List<Poliza__c> lPoliza = [
            SELECT Id
            FROM Poliza__c ];
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassFalse';
        update lPoliza;
        SwitchTest.sNameMetadata = 'testClassTrue';
        update lPoliza;
        Test.stopTest();
    }
}