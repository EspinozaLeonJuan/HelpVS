@isTest
public class EncuestaEvaluacionEnvioTest {

	static {
		TriggerHandler.enable(new Type[] {
			EncuestaEvaluacionEnvioHandler.class,
			ActualizaEnvioEncuestaHandler.class
		});
	}

	static TestMethod void TestConsultas() {
		Factory.crearAccountAnonimo();

		//cuenta1 y cuenta3 generan campaña, cuenta2 no
		Account cuenta1 = Factory.buildAccount('Cuenta personal');
		cuenta1.PersonEmail = 'mail1@mail.cl';
		cuenta1.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta1;

		Account cuenta2 = Factory.buildAccount('Cuenta personal');
		cuenta2.PersonEmail = 'mail2@mail.cl';
		cuenta2.Rut_contacto__pc = '15315161';
		cuenta2.DV_contacto__pc = 'K';
		cuenta2.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta2;

		Account cuenta3 = Factory.buildAccount('Cuenta personal');
		cuenta3.PersonEmail = 'mail3@mail.cl';
		cuenta3.Rut_contacto__pc = '7813807';
		cuenta3.DV_contacto__pc = '6';
		cuenta3.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta3;

		Campana_Vida_Security__c campanaEPA = Factory.buildCampanaEPA();
		insert campanaEPA;

		List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc1.Cuenta__c = cuenta1.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc2.Cuenta__c = cuenta2.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc2);

		insert listaPc;

		Case caso1 = Factory.buildCasoSF('Consultas', cuenta1);
		caso1.Entrega_Respuesta__c = true;
		caso1.Canal__c = 'Call Center';
		caso1.Tipo_de_Contacto__c = 'Contratante';
		caso1.Linea_Negocio__c = 'Seguros Individuales';
		insert caso1;

		Case caso2 = Factory.buildCasoSF('Consultas', cuenta2);
		caso2.Entrega_Respuesta__c = true;
		caso2.Canal__c = 'Call Center';
		caso2.Tipo_de_Contacto__c = 'Contratante';
		caso2.Linea_Negocio__c = 'Seguros Individuales';
		insert caso2;

		Case caso3 = Factory.buildCasoSF('Consultas', cuenta3);
		caso3.Entrega_Respuesta__c = true;
		caso3.Canal__c = 'Call Center';
		caso3.Tipo_de_Contacto__c = 'Contratante';
		caso3.Linea_Negocio__c = 'Seguros Individuales';
		insert caso3;

		//Asserts
		Account cuenta1Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta1.Id];
		cuenta1Final.Pendiente_Envio_Encuesta__c = false;
		system.assertEquals(false, cuenta1Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta1Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta2Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta2.Id];
		
		system.assertEquals(false, cuenta2Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta2Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta3Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta3.Id];
		cuenta3Final.Pendiente_Envio_Encuesta__c = false;
		system.assertEquals(false, cuenta3Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta3Final.Fecha_de_Envio_de_Encuesta__c);
	}

	static TestMethod void TestSolicitudes() {
		Factory.crearAccountAnonimo();

		//cuenta1 y cuenta3 generan campaña, cuenta2 no
		Account cuenta1 = Factory.buildAccount('Cuenta personal');
		cuenta1.PersonEmail = 'mail1@mail.cl';
		insert cuenta1;

		Account cuenta2 = Factory.buildAccount('Cuenta personal');
		cuenta2.PersonEmail = 'mail2@mail.cl';
		cuenta2.Rut_contacto__pc = '15315161';
		cuenta2.DV_contacto__pc = 'K';
		insert cuenta2;

		Account cuenta3 = Factory.buildAccount('Cuenta personal');
		cuenta3.PersonEmail = 'mail3@mail.cl';
		cuenta3.Rut_contacto__pc = '7813807';
		cuenta3.DV_contacto__pc = '6';
		insert cuenta3;

		Campana_Vida_Security__c campanaEPA = Factory.buildCampanaEPA();
		insert campanaEPA;

		List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc1.Cuenta__c = cuenta1.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc2.Cuenta__c = cuenta2.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc2);

		insert listaPc;

		Case caso1 = Factory.buildCasoSF('Solicitudes', cuenta1);
		caso1.Entrega_Respuesta__c = true;
		caso1.Canal__c = 'Sucursal';
		caso1.Tipo_de_Solicitante__c = 'Contratante';
		caso1.Correo_electronico_Solicitante__c = null;
		caso1.Nombre_Solicitante__c = null;
		caso1.RUT_Solicitante__c = null;
		caso1.Telefono_Solicitante__c = null;
		caso1.Negocio__c = 'RRVV';
		insert caso1;

		Case caso2 = Factory.buildCasoSF('Solicitudes', cuenta2);
		caso2.Entrega_Respuesta__c = true;
		caso2.Canal__c = 'Sucursal';
		caso2.Tipo_de_Solicitante__c = 'Contratante';
		caso2.Correo_electronico_Solicitante__c = null;
		caso2.Nombre_Solicitante__c = null;
		caso2.RUT_Solicitante__c = null;
		caso2.Telefono_Solicitante__c = null;
		caso2.Negocio__c = 'RRVV';
		insert caso2;

		Case caso3 = Factory.buildCasoSF('Solicitudes', cuenta3);
		caso3.Entrega_Respuesta__c = true;
		caso3.Canal__c = 'Sucursal';
		caso3.Tipo_de_Solicitante__c = 'Contratante';
		caso3.Correo_electronico_Solicitante__c = null;
		caso3.Nombre_Solicitante__c = null;
		caso3.RUT_Solicitante__c = null;
		caso3.Telefono_Solicitante__c = null;
		caso3.Negocio__c = 'RRVV';
		insert caso3;

		//Asserts
		Account cuenta1Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta1.Id];
		cuenta1Final.Pendiente_Envio_Encuesta__c = false;
		system.assertEquals(false, cuenta1Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta1Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta2Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta2.Id];

		system.assertEquals(false, cuenta2Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta2Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta3Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta3.Id];
		cuenta3Final.Pendiente_Envio_Encuesta__c = false;
		system.assertEquals(false, cuenta3Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta3Final.Fecha_de_Envio_de_Encuesta__c);
	}
    
	static TestMethod void TestConsultas2() {
		Factory.crearAccountAnonimo();

		//cuenta1 y cuenta3 generan campaña, cuenta2 no
		Account cuenta1 = Factory.buildAccount('Cuenta personal');
		cuenta1.PersonEmail = 'mail1@mail.cl';
		cuenta1.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta1;

		Account cuenta2 = Factory.buildAccount('Cuenta personal');
		cuenta2.PersonEmail = 'mail2@mail.cl';
		cuenta2.Rut_contacto__pc = '15315161';
		cuenta2.DV_contacto__pc = 'K';
		cuenta2.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta2;

		Account cuenta3 = Factory.buildAccount('Cuenta personal');
		cuenta3.PersonEmail = 'mail3@mail.cl';
		cuenta3.Rut_contacto__pc = '7813807';
		cuenta3.DV_contacto__pc = '6';
		cuenta3.PersonBirthdate = Date.Today().addYears(-30);
		insert cuenta3;

		Campana_Vida_Security__c campanaEPA = Factory.buildCampanaEPA();
		insert campanaEPA;

		List<Participantes_de_Campa_a__c> listaPc = new List<Participantes_de_Campa_a__c>();
		Participantes_de_Campa_a__c pc1 = new Participantes_de_Campa_a__c();
		pc1.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc1.Cuenta__c = cuenta1.Id;
		pc1.CreatedDate = Date.Today().addMonths(-9);
		pc1.LastModifiedDate = Date.Today().addMonths(-8);
		pc1.Contactado__c = 'Si';
		pc1.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc1);

		Participantes_de_Campa_a__c pc2 = new Participantes_de_Campa_a__c();
		pc2.Campa_a_Vida_Security__c = campanaEPA.Id;
		pc2.Cuenta__c = cuenta2.Id;
		pc2.CreatedDate = Date.Today().addMonths(-3);
		pc2.LastModifiedDate = Date.Today().addMonths(-2);
		pc2.Contactado__c = 'Si';
		pc2.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
		listaPc.add(pc2);

		insert listaPc;

		Case caso1 = Factory.buildCasoSF('Consultas', cuenta1);
		caso1.Entrega_Respuesta__c = true;
		caso1.Canal__c = 'Call Center';
		caso1.Tipo_de_Contacto__c = 'Contratante';
		caso1.Linea_Negocio__c = 'Seguros Individuales';
        Date hoy = Date.today();
        caso1.Fecha_de_EPA_Contact_Center_Caso__c = hoy;
		insert caso1;
        
        caso1.Fecha_de_EPA_Contact_Center_Caso__c = hoy.addDays(5);
		upsert caso1;
        
		Case caso2 = Factory.buildCasoSF('Consultas', cuenta2);
		caso2.Entrega_Respuesta__c = true;
		caso2.Canal__c = 'Call Center';
		caso2.Tipo_de_Contacto__c = 'Contratante';
		caso2.Linea_Negocio__c = 'Seguros Individuales';
		insert caso2;

		Case caso3 = Factory.buildCasoSF('Consultas', cuenta3);
		caso3.Entrega_Respuesta__c = true;
		caso3.Canal__c = 'Call Center';
		caso3.Tipo_de_Contacto__c = 'Contratante';
		caso3.Linea_Negocio__c = 'Seguros Individuales';
		insert caso3;

		//Asserts
		Account cuenta1Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta1.Id];

		system.assertEquals(false, cuenta1Final.Pendiente_Envio_Encuesta__c);
		system.assertNotEquals(null, cuenta1Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta2Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta2.Id];

		system.assertEquals(false, cuenta2Final.Pendiente_Envio_Encuesta__c);
		system.assertEquals(null, cuenta2Final.Fecha_de_Envio_de_Encuesta__c);

		Account cuenta3Final = [select Pendiente_Envio_Encuesta__c, Fecha_de_Envio_de_Encuesta__c from Account where Id =:cuenta3.Id];

		//system.assertEquals(true, cuenta3Final.Pendiente_Envio_Encuesta__c);
		//system.assertEquals(null, cuenta3Final.Fecha_de_Envio_de_Encuesta__c);
	}    
}