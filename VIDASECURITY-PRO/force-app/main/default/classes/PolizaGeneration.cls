@isTest
public class PolizaGeneration extends AbstractFabricate{
    public static final String POLIZAS_INDIV_RT_NAME = 'Individuales';
    public override Sobject default() {
        return new Poliza__c(
            Name = '5016169' );
    }
    public PolizaGeneration individual(Id idCuenta) {
        return (PolizaGeneration) this
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Poliza__c.sObjectType, POLIZAS_INDIV_RT_NAME))
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
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE');
    }

}