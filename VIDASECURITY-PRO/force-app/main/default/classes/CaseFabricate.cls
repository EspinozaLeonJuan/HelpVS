@isTest
public class CaseFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Case(
			Subject = 'Foo',
			Status = 'Abierto',
			Canal__c = 'Asistencia Agente',
			Tipo_de_Contacto__c = 'Familiar',
			Linea_Negocio__c = 'Hipotecaria',
			Negocio__c = 'RRVV',
			Concepto__c = 'Concepto',
			Description = 'Descripción',
			Detalle_Solicitud__c = 'Detalle Solicitud',
			Nombre_Solicitante__c = 'Nombre',
			Telefono_Solicitante__c = '1234567890',
			RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consultas').getRecordTypeId()
		);
		// RUT_Solicitante__c = '13057161-1', // Sin especificar el rut de solicitante.
	}
	
	public CaseFabricate loadCase() {
		return (CaseFabricate)load(new String[] {'Subject', 'RecordType.Name', 'Instancia_del_Reclamo__c', 'Aprobado_Reclamo__c'}, 'Subject', 'Foo');
	} 

	public AbstractFabricate email2CaseColectivos(String nombre, String email) {
		return this.set('Origin', 'Servicios Colectivos')
							 .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Case.sObjectType, 'Consultas'))
							 .set('SuppliedEmail', email)
							 .set('SuppliedName', nombre);
	}
	
	public CaseFabricate reclamo() {
		return (CaseFabricate) this
		.set('Nombre_Solicitante__c', 'Will Smith')
		.set('RUT_Solicitante__c', '13057161-1')
		.set('Correo_electronico_Solicitante__c', 'foo@bar.cl')
		.set('RecordTypeId', ReflectionUtils.getRecordTypeId(Case.sObjectType, 'Reclamos'));
	}
	
	public CaseFabricate reclamo(String canal, String tipoOperacion, String detalleOperacion) {
		return (CaseFabricate) reclamo()
			.set('Canal__c', canal)
			.set('Tipo_Operacion__c', tipoOperacion)
			.set('Detalle_Operacion__c', detalleOperacion);
	}
			
	public CaseFabricate reclamoDDA() {
		return reclamo('DDA', 'Atención post venta', 'Atención descortés');
	}
	
	public CaseFabricate reclamoSucursal(String tipoOperacion, String detalleOperacion) {
		return reclamo('Sucursal', tipoOperacion, detalleOperacion);
	} 

	public CaseFabricate setCuenta(AccountFabricate cuenta) {
		return (CaseFabricate)set('AccountId', cuenta);
	}

	public CaseFabricate email2Case(String nombre, String email) {
		Group colaAsistenciaAgente = [select Id from Group where  Type = 'Queue' AND NAME = 'Asistencia Agente' LIMIT 1];
		return (CaseFabricate)set('RecordTypeId', ReflectionUtils.getRecordTypeId(Case.sObjectType, 'Atención'))
			.set('SuppliedEmail', email)
			.set('SuppliedName', nombre)
			.set('OwnerId', colaAsistenciaAgente.Id);
	}
}