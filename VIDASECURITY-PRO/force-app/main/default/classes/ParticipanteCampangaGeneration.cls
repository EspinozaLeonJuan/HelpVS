@isTest
public class ParticipanteCampangaGeneration extends AbstractFabricate{
    
    public static final String COBRANZA_PARTICIPANTECAMP_RT_NAME = 'Cobranzas PV';

    public override Sobject default() {
		return new Participantes_de_Campa_a__c(
			Name = 'Poliza test' );
	}

    public ParticipanteCampangaGeneration generico(String name, Id idCampana, Id idPersonContact, String estado, String nombreContacto, Id idPoliza, Id idOwner, Id idCuenta, String prioridad) {
		return (ParticipanteCampangaGeneration)set('Name', name)
            .set('Campa_a_Vida_Security__c', idCampana)
            .set('Contacto__c', idPersonContact)
            .set('Estado_Cierre__c', estado)
            .set('Nombre_de_Contacto__c', nombreContacto)
            .set('Poliza__c', idPoliza)
            .set('OwnerId', idOwner)
            .set('Cuenta__c', idCuenta)
            .set('Prioridad_en_Campa_a__c', prioridad)
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Participantes_de_Campa_a__c.sObjectType, COBRANZA_PARTICIPANTECAMP_RT_NAME));
	}
}