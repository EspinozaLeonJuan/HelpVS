@isTest(seealldata = false)
public class PolizaParticipanteCobranzaPVTest {

    static testMethod void testPolizaAsignaPesoCuenta(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testPolizaAsignaPesoCuenta')){return;}
         ContactFabricate contacto = (ContactFabricate)Fabricate.contacto()
            .set('RUT__c','16355278')
            .set('Codigo_Agente__c', '00001053')
            .save();
        
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
        
        CorredorFabricate corredor = (CorredorFabricate)Fabricate.corredor().corredor().save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        CategoriaPolizaGeneration categoriaPoliza = (CategoriaPolizaGeneration)Fabricate.categoriaPolizaTest().individual().save();
        
        List<Account> idCuentaOriginal = [SELECT Id, OwnerId, IsPersonAccount, Rut__c, Name FROM Account];
        Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuenta.get().get('Id');        
        Id idCorredor = (Id) corredor.get().get('Id');         	
        id idCampana = (id)campana.get().get('id');        	
        Id idCategoriaPoliza = (Id)categoriaPoliza.get().get('Id');
        date fechaActual = Date.newInstance(2021, 08, 14);        
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        Date myDate = date.newinstance(2021, 05, 20);
       
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
            .set('Estatus__c', 'ANULADA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Corredor__c', idCorredor)
            .set('Categoria_de_Poliza__c', idCategoriaPoliza)
            .set('Valor_Poliza__c', 100)
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','A')
            .save();
        
        List<Poliza__c> polizaIndividualEncontrada = [
            SELECT RUT__c, cuenta__c, Estatus__c, Prima_Total__c,Fecha_Ultimo_Pago__c, Valor_Poliza__c,Con_o_Sin_Ahorro__c, Cantidad_de_Meses_Sin_Pago__c  
            FROM Poliza__c 
            WHERE cuenta__c =: idCuentaOriginal 
            AND RecordTypeId = :recordTypePolizaIndv];
       List<Participantes_de_Campa_a__c> members =	[SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, Prioridad_en_Campa_a__c, CreatedDate FROM Participantes_de_Campa_a__c] ;
        
		for(Participantes_de_Campa_a__c member : members){
           currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c), member);
        }
        
        polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
        polizaIndividualEncontrada[0].Estatus__C = 'ACTIVA';
        polizaIndividualEncontrada[0].Con_o_Sin_Ahorro__c = '';
        
        Update polizaIndividualEncontrada;        
        Test.stopTest();        
    }    
//*****************************************************************************************************//
    
    static testMethod void testpolizaCueantaPersonal(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testpolizaCueantaPersonal')){return;}
        
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true).set('RUT_Empresa__c','482123880').save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2021, 11, 20);
        
        Test.startTest();       
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '1100')
            .set('Con_o_Sin_Ahorro__c', 'Con Ahorro')
            .set('DV__c', 'K')
            .set('CurrencyIsoCode', 'CLF')
            .set('Edad_al_Momento_de_Contratar__c', 36)
            .set('Empresa_Origen__c', 'Vida Security')
            .set('Es_Anulable__c', false)
            .set('Estatus__c', 'ACTIVA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 5000)
            .save();
        
        List<Account> idCuentaOriginal = [SELECT Id, OwnerId,PersonContactId, IsPersonAccount, Rut__c, Name FROM Account];
        system.debug('listCuenta'+ idCuentaOriginal);
        List<Poliza__c> polizaIndividualEncontrada = [SELECT RUT__c, cuenta__c, Estatus__c, Prima_Total__c, Valor_Poliza__c, Name FROM Poliza__c WHERE cuenta__c =: idCuenta AND RecordTypeId = :recordTypePolizaIndv];
      
        Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
                                                    Name = 'ejempolo campana',
                                                    Campa_a_Vida_Security__c = idCampana,
                                                    Contacto__c = idContacto,
                                                    Estado_Cierre__c= 'Finalizado',
                                                    RecordTypeId = recordId,
                                                    Prioridad_en_Campa_a__c = '1',
         											Poliza__c = polizaIndividualEncontrada[0].Id);
        insert participante;
        system.debug('insert paarti'+ participante);
               
       List<Participantes_de_Campa_a__c> members =	[SELECT Contacto__c,Prima_Minima__c, Name, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, Prioridad_en_Campa_a__c, CreatedDate, OwnerId FROM Participantes_de_Campa_a__c WHERE Contacto__c = :idContacto] ;
        system.debug('lista paarti'+ members);
        
        polizaIndividualEncontrada[0].Estatus__C = 'ACTIVA';
        
        Update polizaIndividualEncontrada;
        //*****************************************//
        polizaIndividualEncontrada[0].Prima_Minima__c = 100;
        Update polizaIndividualEncontrada;
        
        members[0].Name = 'test campa';
        Update  members;
        
		Test.stopTest();
    }
    
//*****************************************************************************************************//

 static testMethod void testpolizaCueantaMesesPagoConAhorro(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testpolizaCueantaPersonal')){return;}
        
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true).set('RUT_Empresa__c','482123880').save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2005, 11, 20);
        
              
		PolizaGeneration poliza = (PolizaGeneration)Fabricate.polizaTest().individual(idCuenta)
            .set('Cuenta__c', idCuenta)
            .set('Agente__c', 'GIOVANNA CARLA')
            .set('Apellidos_Asegurado__c', 'MENESES BRAVO')
            .set('RecordTypeId', recordTypePolizaIndv)
            .set('Codigo_Agente__c', '22525')
            .set('Codigo_de_Producto__c', '1100')
            .set('Con_o_Sin_Ahorro__c', 'Con Ahorro')
            .set('DV__c', 'K')
            .set('CurrencyIsoCode', 'CLF')
            .set('Edad_al_Momento_de_Contratar__c', 36)
            .set('Empresa_Origen__c', 'Vida Security')
            .set('Es_Anulable__c', false)
            .set('Estatus__c', 'ACTIVA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'KARLA STEPHANIE')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 2000)
            .save();
        
        List<Account> idCuentaOriginal = [SELECT Id, OwnerId, IsPersonAccount, Rut__c, Name FROM Account];
        List<Poliza__c> polizaIndividualEncontrada = [SELECT RUT__c,Fecha_Ultimo_Pago__c,Frecuencia_de_Pago__c, cuenta__c, Estatus__c, Prima_Total__c, Valor_Poliza__c, Name FROM Poliza__c WHERE cuenta__c =: idCuenta AND RecordTypeId = :recordTypePolizaIndv];
        Test.startTest(); 
        polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
        Update polizaIndividualEncontrada;
     //*******Frecuencia_de_Pago__c T***************//
     	myDate = date.newinstance(2020, 11, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'T';
        Update polizaIndividualEncontrada;
     
     	myDate = date.newinstance(2015, 11, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	Update polizaIndividualEncontrada;
     //*******Frecuencia_de_Pago__c S***************//
        myDate = date.newinstance(2020, 05, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'S';
        Update polizaIndividualEncontrada;
     
     	myDate = date.newinstance(2015, 11, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	Update polizaIndividualEncontrada;
     //*******Frecuencia_de_Pago__c A ***************//
     	myDate = date.newinstance(2020, 05, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'A';
        Update polizaIndividualEncontrada;
     
     	myDate = date.newinstance(2015, 11, 20);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	Update polizaIndividualEncontrada;
  
		Test.stopTest();
    }
//*****************************************************************************************************//

     static testMethod void testpolizaCueantaMesesPagoSinAhorro(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testpolizaCueantaPersonal')){return;}
        
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true).set('RUT_Empresa__c','482123880').save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2005, 11, 20);
        
        Test.startTest();       
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
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 2000)
            .save();
        
        List<Account> idCuentaOriginal = [SELECT Id, OwnerId, IsPersonAccount, Rut__c, Name FROM Account];
        List<Poliza__c> polizaIndividualEncontrada = [SELECT RUT__c,Fecha_Ultimo_Pago__c,Frecuencia_de_Pago__c, cuenta__c, Estatus__c, Prima_Total__c, Valor_Poliza__c, Name FROM Poliza__c WHERE cuenta__c =: idCuenta AND RecordTypeId = :recordTypePolizaIndv];

        polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
        Update polizaIndividualEncontrada;
         
     //*******Frecuencia_de_Pago__c M SIN AHORRO***************//
     	myDate = date.newinstance(2021, 09, 10);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
        Update polizaIndividualEncontrada;
     //*******Frecuencia_de_Pago__c T SIN AHORRO***************//
     	myDate = date.newinstance(2020, 07, 10);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'T';
        Update polizaIndividualEncontrada;
     
     //*******Frecuencia_de_Pago__c S SIN AHORRO***************//
        myDate = date.newinstance(2020, 04, 10);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'S';
        Update polizaIndividualEncontrada;
     
     //*******Frecuencia_de_Pago__c A SIN AHORRO***************//
     	myDate = date.newinstance(2018, 10, 10);
		polizaIndividualEncontrada[0].Fecha_Ultimo_Pago__c = myDate;
     	polizaIndividualEncontrada[0].Frecuencia_de_Pago__c = 'A';
        Update polizaIndividualEncontrada;
     
		Test.stopTest();
    }
    //*****************************************************************************************************//
    static testMethod void testUpdateMembers2(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testUpdateMembers2')){return;}
        //*****************************************************************************************************//
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Id idEjecutivo = (Id)ejecutivo.get().get('Id');
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', idEjecutivo ).set('Omitir_Validaciones_AMAC__c',true).save();
        //AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id idPersonContact = (Id)cuentaPersonal.get().get('PersonContactId');
        String nombreContacto = (String)cuentaPersonal.get().get('Name');
        //Id idCorp = (Id)cuentaCorp.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2005, 11, 20);

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
            .set('Estatus__c', 'ANULADA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'EMPRESA TALES')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 2000)
            .save();
        
        Id idPoliza = (Id)poliza.get().get('Id');

        Account oAccPerson = [ 
            SELECT Id, isPersonAccount , OwnerId, PersonContactId
            FROM Account 
            WHERE isPersonAccount = true 
            LIMIT 1];

        ParticipanteCampangaGeneration participanteCampanga1 = (ParticipanteCampangaGeneration)Fabricate.participanteCampagna()
            .generico('Poliza test 1', idCampana, oAccPerson.PersonContactId, 'ACTIVA', nombreContacto, idPoliza, idEjecutivo, oAccPerson.Id, '1')
            .save();
        //*****************************************************************************************************//
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>{ idPoliza };
        Map<Id, Account> accMap = new Map<Id,Account>();
        
        accMap.put( oAccPerson.Id, oAccPerson );
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put( (Id)poliza.get().get('Id'), (Poliza__c)poliza.get() );

        List<Participantes_de_Campa_a__c> members = [
            SELECT Id, Contacto__c, Poliza__c, Estado_Cierre__c, Comentario__c, Prioridad_en_Campa_a__c
            FROM Participantes_de_Campa_a__c];

        Test.startTest();
        PolizaParticipanteCobranzaPV.updateMembers2( recordTypeIndividuales, recordId, idCampana, accountIds, polizaIds, accMap, members, newMap );
        Test.stopTest();
    }

    static testMethod void testUpdateMembers2OK(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testUpdateMembers2')){return;}
        //*****************************************************************************************************//
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Id idEjecutivo = (Id)ejecutivo.get().get('Id');
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', idEjecutivo ).set('Omitir_Validaciones_AMAC__c',true).save();
        //AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id idPersonContact = (Id)cuentaPersonal.get().get('PersonContactId');
        String nombreContacto = (String)cuentaPersonal.get().get('Name');
        //Id idCorp = (Id)cuentaCorp.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2005, 11, 20);

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
            .set('Estatus__c', 'ANULADA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'EMPRESA TALES')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 2000)
            .save();
        
        Id idPoliza = (Id)poliza.get().get('Id');

        ParticipanteCampangaGeneration participanteCampanga1 = (ParticipanteCampangaGeneration)Fabricate.participanteCampagna()
            .generico('Poliza test 1', idCampana, idPersonContact, 'ACTIVA', nombreContacto, idPoliza, idEjecutivo, idCuenta, '1')
            .save();
        //*****************************************************************************************************//
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>{ idPoliza };
        Map<Id, Account> accMap = new Map<Id,Account>();
        accMap.put( idCuenta, (Account)cuentaPersonal.get() );
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put( (Id)poliza.get().get('Id'), (Poliza__c)poliza.get() );

        List<Participantes_de_Campa_a__c> members = [
            SELECT Id, Contacto__c, Poliza__c, Estado_Cierre__c, Comentario__c, Prioridad_en_Campa_a__c
            FROM Participantes_de_Campa_a__c];

        Test.startTest();
        PolizaParticipanteCobranzaPV.updateMembers2( recordTypeIndividuales, recordId, idCampana, accountIds, polizaIds, accMap, members, newMap );
        Test.stopTest();
    }

    static testMethod void testUpdateMembers2Error(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testUpdateMembers2')){return;}
        //*****************************************************************************************************//
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c', '00001053').save();
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Id idEjecutivo = (Id)ejecutivo.get().get('Id');
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', idEjecutivo ).set('Omitir_Validaciones_AMAC__c',true).save();
        //AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        CampanaVidaSecurityFabricate campana = (CampanaVidaSecurityFabricate)Fabricate.campanaVidaSecurity().cobranza().save();
        
        
        Id idContacto = (Id) contacto.get().get('Id');
        Id idCuenta = (Id)cuentaPersonal.get().get('Id');
        Id idPersonContact = (Id)cuentaPersonal.get().get('PersonContactId');
        String nombreContacto = (String)cuentaPersonal.get().get('Name');
        //Id idCorp = (Id)cuentaCorp.get().get('Id');
        Id recordTypePolizaIndv = ReflectionUtils.getRecordTypeId(Schema.Poliza__c.sObjectType, 'Individuales');
        id idCampana = (id)campana.get().get('id');  
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        date fechaActual = Date.newInstance(2021, 08, 14);
        Date myDate = date.newinstance(2005, 11, 20);

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
            .set('Estatus__c', 'ANULADA')
            .Set('Forma_de_Pago__c', 'POR EMPLEADOR/DESCUENTO POR PLANILLA')
        	.set('Nombre_Asegurado__c', 'EMPRESA TALES')
            .set('Codigo_Agente__c', '00001053')
            .set('Fecha_Ultimo_Pago__c', fechaActual)
            .Set('Frecuencia_de_Pago__c','M')
            .set('Fecha_de_inicio_de_suspensi_n__c',fechaActual)
            .set('Cantidad_de_meses_suspendido__c', '5')
            .Set('Valor_Poliza__c', 5000)
            .set('Prima_Minima__c', 2000)
            .save();
        
        Id idPoliza = (Id)poliza.get().get('Id');

        ParticipanteCampangaGeneration participanteCampanga1 = (ParticipanteCampangaGeneration)Fabricate.participanteCampagna()
            .generico('Poliza test 1', idCampana, idPersonContact, 'ACTIVA', nombreContacto, idPoliza, idEjecutivo, idCuenta, '1')
            .save();
        //*****************************************************************************************************//
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        Set<Id> accountIds = new Set<Id>();
        Set<Id> polizaIds = new Set<Id>{ idPoliza };
        Map<Id, Account> accMap = new Map<Id,Account>();
        Account oAccPerson = [ 
            SELECT Id, isPersonAccount , OwnerId
            FROM Account 
            WHERE isPersonAccount = true 
            LIMIT 1];
        accMap.put( oAccPerson.Id, oAccPerson );
        Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
        newMap.put( (Id)poliza.get().get('Id'), (Poliza__c)poliza.get() );

        List<Participantes_de_Campa_a__c> members = [
            SELECT Id, Contacto__c, Poliza__c, Estado_Cierre__c, Comentario__c, Prioridad_en_Campa_a__c
            FROM Participantes_de_Campa_a__c];

        Test.startTest();
        PolizaParticipanteCobranzaPV.updateMembers2( recordTypeIndividuales, recordId, idCampana, accountIds, polizaIds, accMap, members, newMap );
        Test.stopTest();
    }

    static testMethod void testGetPrioridad(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testGetPrioridad')){return;}
        Decimal cantMesesSinPago = 1;
        String frecuenciaDePago = '';
        String conSinAhorro = 'Con Ahorro';
        Decimal valorPoliza = 3;
        Decimal primaMinima = 2;
        String cantidadMesesSuspendido = '2';
        String prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        valorPoliza = 1000;
        primaMinima = 100;
        cantidadMesesSuspendido = '';
        frecuenciaDePago = 'M';
        cantMesesSinPago = 3;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        cantMesesSinPago = 14;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago = 'T';
        cantMesesSinPago = 5;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        cantMesesSinPago = 19;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago = 'S';
        cantMesesSinPago = 8;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        cantMesesSinPago = 25;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago = 'A';
        cantMesesSinPago = 14;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        cantMesesSinPago = 31;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        conSinAhorro = 'Sin Ahorro';
        frecuenciaDePago = 'M';
        cantMesesSinPago = 2;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago ='T';
        cantMesesSinPago = 4;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago = 'S';
        cantMesesSinPago = 7;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
        frecuenciaDePago = 'A';
        cantMesesSinPago = 13;
        prioridad = PolizaParticipanteCobranzaPV.getPrioridad( cantMesesSinPago, frecuenciaDePago, conSinAhorro, valorPoliza, primaMinima, cantidadMesesSuspendido );
    }

    static testMethod void testArmParticipanteCampana(){
        if(!TestVerificationService.ShouldExecute('PolizaAsignaPesoCuentaTest.testArmParticipanteCampana')){return;}
        String sOpc = '1';
        String accName = '';
        String polizaName= '';
        String periodo= '';
        Id idCampana= null;
        Id personContactId= null; 
        Id polizaId= null;
        Id ownerId= null;
        Id accId= null;
        Id recordId= null;
        String prioridad = '';
        Participantes_de_Campa_a__c participante = PolizaParticipanteCobranzaPV.armParticipanteCampana(  sOpc,  accName, polizaName, periodo, idCampana, personContactId, polizaId, ownerId, accId, recordId, prioridad );
    }
}