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
public class PolizaAsignaEmpresaTest {
	 static testMethod void testPolizaAsignaEmpresa(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaEmpresaTest.testPolizaAsignaEmpresa')){return;}
        /**********************************************************************************/
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
            .set('Corredor__c', idCorredor)
            .set('Rut_Corredor__c', '77508900')
            .save();
       
         
         
         Account acc_asig_1 = new Account(name= 'acc_asig_1',ownerId='005i0000000ij3TAAQ', Rut__c ='16355278');
         
        insert acc_asig_1;
        
         Account acc_asig_2 = new Account(name= 'acc_asig_2',ownerId='005i0000000ij3TAAQ', Rut__c ='77508900');
         insert acc_asig_2;
         
         Poliza__c item = new Poliza__c(cuenta__c=acc_asig_1.Id, Rut_Empresa__c ='16355278');
   		insert item;
          Poliza__c item2 = new Poliza__c(id =item.Id ,cuenta__c=acc_asig_2.Id, Rut_Empresa__c = '77508900');
   		update item2;
         
         Set<Id> idsEmpresas = new Set<Id>();
         Id id_acc = PolizaAsignaEmpresa.getIdEmpresas( item2, item, false, idsEmpresas );
         
         Set<String> rutsEmpresas = new Set<String>();
         String id_acc_e = PolizaAsignaEmpresa.getRutEmpresas( item2, rutsEmpresas );
         
         Map<Id, Account> mapCuentasById = new Map<Id, Account>();
         mapCuentasById.put(acc_asig_2.Id, acc_asig_2);
         mapCuentasById.put(acc_asig_1.Id, acc_asig_1);
         
         Map<String, Account> mapEmpresas = new Map<String, Account>();
         mapEmpresas.put(String.valueOf(acc_asig_2.Id), acc_asig_2);
         mapEmpresas.put(String.valueOf(acc_asig_1.Id), acc_asig_1);
         
         PolizaAsignaEmpresa.execute( item2, item, false, mapCuentasById, mapEmpresas );
         
		Test.stopTest();
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c 
            FROM Poliza__c 
            WHERE cuenta__c =: idCuenta 
            AND RecordTypeId = :recordTypePolizaIndv];
        
        System.assertEquals(idCuenta, polizaIndividualEncontrada[0].cuenta__c);
    }
}