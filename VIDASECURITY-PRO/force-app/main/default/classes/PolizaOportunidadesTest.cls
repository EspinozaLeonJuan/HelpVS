@isTest(seealldata=false)
public class PolizaOportunidadesTest {
	@testSetup 
    Static void testsetup(){
        Id LinkRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').recordtypeid;
        
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278')
            					 .set('Codigo_Agente__c', '00001053').save();
        
        Id idContacto = (Id) contacto.get().get('Id');
        
        AccountGeneration cuentaOriginal = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .Set('Agente_Actual__c', idContacto)
            .save();
        
        Id idCuentaOriginal = (Id)cuentaOriginal.get().get('Id');
        
        Opportunity testOpportunity = new Opportunity(
            RecordTypeId = LinkRecordType,
            StageName = 'prueba',
            CloseDate = system.today()+5,
            Cuenta__c = idCuentaOriginal,
            AccountId = idCuentaOriginal,
            Name = 'Test Opportunity Triggers');
        insert testOpportunity;
        
    }
    
    static testMethod void testPolizaOportunidades(){
        if(!TestVerificationService.ShouldExecute('PolizaCampanaBienvenidaTest.testPolizaCampanaBienvenidaError')){return;}
        List<Account> idCuentaOriginal = [SELECT Id, IsPersonAccount, Rut__c FROM Account WHERE Name = 'Cuenta Corporativa'];
        List<String> recordTypes = new List<String>(); 
        
        CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        Id idCorredor = (Id) corredor.get().get('Id'); 
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        CategoriaPolizaGeneration categoriaPoliza = (CategoriaPolizaGeneration)Fabricate.categoriaPolizaTest().individual().save();
        Id idCategoriaPoliza = (Id)categoriaPoliza.get().get('Id');
        recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').recordtypeid);
        recordTypes.add(Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').recordtypeid);
        
        Test.startTest();
        PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuentaOriginal[0].id)
            .set('Cuenta__c', idCuentaOriginal[0].id)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypes[0])
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
            .set('Nombre_de_Producto__c', 'Cruz_Sanatorio')
            .save();
        
        List<Poliza__c>  lPoiza = [ 
            SELECT Id , Cuenta__c, Agente__c, Apellidos_Asegurado__c, RecordTypeId, Codigo_Agente__c, Codigo_de_Producto__c, Con_o_Sin_Ahorro__c,
                DV__c, CurrencyIsoCode, Edad_al_Momento_de_Contratar__c, Empresa_Origen__c, Es_Anulable__c, Estatus__c, Forma_de_Pago__c, Nombre_Asegurado__c,
                Corredor__c, Categoria_de_Poliza__c, Valor_Poliza__c, Nombre_de_Producto__c
            FROM Poliza__c  ];

        PolizaOportunidades.execute(lPoiza);
        Test.stopTest();
    }
}