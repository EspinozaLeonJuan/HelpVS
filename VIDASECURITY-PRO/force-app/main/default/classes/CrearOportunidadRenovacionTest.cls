/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2022
 * @last modified by  : felipe.pena@vasslatam.com
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-09-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@istest
public class CrearOportunidadRenovacionTest {
    
    @istest
    public  static void oppRenovacionTest() {

        Id role_id = [SELECT Id FROM UserRole WHERE developerName='Ejecutivo_Comercial_Renovacion'].Id;
         
        User usuario =  new User(
			FirstName = 'Rocky',
			LastName = 'Balboa',
			Alias = 'rocky',
			Email = 'rocky@balboa.cl',
			Username = 'ejecutivo.generico@vidasecurity.cl.fabricate',
			CommunityNickname = 'rocky10',
			TimeZoneSidKey = 'America/Santiago',
			LanguageLocaleKey = 'es',
			LocaleSidKey = 'es_CL',
			EmailEncodingKey = 'UTF-8',
			Country = 'Chile',
			IsActive = true,
			ProfileId = UserInfo.getProfileId(),
			RUT_Usuario__c = '22222222-2',
            UserRoleId     = role_id
		);
        
        insert usuario;     

        System.runAs(usuario){
            
            Id role_suscpriptor = [SELECT Id FROM UserRole WHERE developerName='Suscriptor_de_Renovacion'].Id;
            
            User usuario2 =  new User(
                FirstName = 'Rocky2',
                LastName = 'Balboa2',
                Alias = 'rocky2',
                Email = 'rocky2@balboa.cl',
                Username = 'ejecutivo2.generico@vidasecurity.cl.fabricate',
                CommunityNickname = 'rocky102',
                TimeZoneSidKey = 'America/Santiago',
                LanguageLocaleKey = 'es',
                LocaleSidKey = 'es_CL',
                EmailEncodingKey = 'UTF-8',
                Country = 'Chile',
                IsActive = true,
                ProfileId = [SELECT Id FROM Profile WHERE Name =: ComercialConstants.profileEjecutivoTecnico].Id,
                RUT_Usuario__c = '26170903-2',
                UserRoleId     = role_suscpriptor
		    );


            insert usuario2;   

            Date hoy = Date.today();
            Date hoy60 = hoy.addDays(60);
        
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();

            Account cuenta =  new Account();
            cuenta.Name                                        = 'cuenta 1';
            cuenta.Rut__c                                      = '26170903';
            cuenta.DV__c                                       = '1';
            cuenta.Holding__c                                  = true;
            cuenta.Numero_de_Holding__c                        = '123';
            cuenta.RecordTypeId                                = RecordTypeIdAccount;
            cuenta.Fecha_de_Vigencia_Holding__c                = DateTime.now();
            cuenta.Ejecutivo_comercial_renovacion__c           = usuario.id;
            cuenta.Suscriptor_de_renovacion__c                 = usuario2.id;

            insert cuenta;

            Account cuenta2 =  new Account();
            cuenta2.Name                                        = 'cuenta_2';
            cuenta2.Rut__c                                      = '11633869';
            cuenta2.DV__c                                       = '6';
            cuenta2.Holding__c                                  = true;
            cuenta2.Numero_de_Holding__c                        = '1234';
            cuenta2.RecordTypeId                                = RecordTypeIdAccount;
            cuenta2.Fecha_de_Vigencia_Holding__c                = DateTime.now();
            cuenta2.Ejecutivo_comercial_renovacion__c           = usuario.id;
            cuenta2.Suscriptor_de_renovacion__c                 = usuario2.id;

            insert cuenta2;
            
            Corredor__c co = new Corredor__c();
            co.Name        = 'Pruebas';
            co.Rut__c      = '200448685';
            co.Cuenta__c   = cuenta.Id;
            
            insert co;

            Corredor__c co2 = new Corredor__c();
            co2.Name        = 'Pruebas2';
            co2.Rut__c      = '228874884';
            co2.Cuenta__c   = cuenta2.Id;
            
            insert co2;

            Id recordTypeIndColectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();
            
            Poliza__c poliza                                = new Poliza__c();
            poliza.Cuenta__c                                = cuenta.Id;
            poliza.Name                                     = '123';
            poliza.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza.RecordTypeId                             = recordTypeIndColectivos;
            poliza.Corredor__c                              = co.id;
            poliza.Estatus__c                               = 'ACTIVA';
            poliza.Agrupacion_Comercial__c                  = '123 (cuenta)';
            
            insert poliza;

            Poliza__c poliza2                                = new Poliza__c();
            poliza2.Cuenta__c                                = cuenta2.Id;
            poliza2.Name                                     = '1234';
            poliza2.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza2.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza2.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza2.RecordTypeId                             = recordTypeIndColectivos;
            poliza2.Corredor__c                              = co2.id;
            poliza2.Estatus__c                               = 'ACTIVA';
            poliza2.Agrupacion_Comercial__c                  = '1234 (cuenta)';
            
            insert poliza2;

            Poliza__c poliza3                               = new Poliza__c();
            poliza3.Cuenta__c                                = cuenta2.Id;
            poliza3.Name                                     = '1235';
            poliza3.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza3.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza3.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza3.RecordTypeId                             = recordTypeIndColectivos;
            poliza3.Corredor__c                              = co2.id;
            poliza3.Estatus__c                               = 'ACTIVA';
            poliza3.Agrupacion_Comercial__c                  = '1235 (cuenta)';
            
            insert poliza3;                       

            Test.startTest();
                CrearOportunidadRenovacion.creaOppRenovacion();
            Test.stopTest();
        }
    }
    
    @istest
    public  static void creaOppRenovacionTest() {

        Id role_id = [SELECT Id FROM UserRole WHERE developerName='Ejecutivo_Comercial_Renovacion'].Id;
         
        User usuario =  new User(
			FirstName = 'Rocky',
			LastName = 'Balboa',
			Alias = 'rocky2',
			Email = 'rocky2@balboa.cl',
			Username = 'ejecutivo2.generico@vidasecurity.cl.fabricate',
			CommunityNickname = 'rocky12',
			TimeZoneSidKey = 'America/Santiago',
			LanguageLocaleKey = 'es',
			LocaleSidKey = 'es_CL',
			EmailEncodingKey = 'UTF-8',
			Country = 'Chile',
			IsActive = true,
			ProfileId = UserInfo.getProfileId(),
			RUT_Usuario__c = '22222222-1',
            UserRoleId     = role_id
		);
        
        insert usuario;     

        System.runAs(usuario){
            
            Id role_suscpriptor = [SELECT Id FROM UserRole WHERE developerName='Suscriptor_de_Renovacion'].Id;
            
            User usuario2 =  new User(
                FirstName = 'Rocky3',
                LastName = 'Balboa3',
                Alias = 'rocky3',
                Email = 'rocky3@balboa.cl',
                Username = 'ejecutivo3.generico@vidasecurity.cl.fabricate',
                CommunityNickname = 'rocky103',
                TimeZoneSidKey = 'America/Santiago',
                LanguageLocaleKey = 'es',
                LocaleSidKey = 'es_CL',
                EmailEncodingKey = 'UTF-8',
                Country = 'Chile',
                IsActive = true,
                ProfileId = [SELECT Id FROM Profile WHERE Name =: ComercialConstants.profileEjecutivoTecnico].Id,
                RUT_Usuario__c = '16170903-2',
                UserRoleId     = role_suscpriptor
		    );


            insert usuario2;   

            Date hoy = Date.today();
            Date hoy60 = hoy.addDays(60);
        
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();

            Account cuenta =  new Account();
            cuenta.Name                                        = 'cuenta 2';
            cuenta.Rut__c                                      = '16170903';
            cuenta.DV__c                                       = '1';
            cuenta.Holding__c                                  = true;
            cuenta.Numero_de_Holding__c                        = '123';
            cuenta.RecordTypeId                                = RecordTypeIdAccount;
            cuenta.Fecha_de_Vigencia_Holding__c                = DateTime.now();
            cuenta.Ejecutivo_comercial_renovacion__c           = usuario.id;
            cuenta.Suscriptor_de_renovacion__c                 = usuario2.id;

            insert cuenta;

            Account cuenta2 =  new Account();
            cuenta2.Name                                        = 'cuenta_3';
            cuenta2.Rut__c                                      = '31633869';
            cuenta2.DV__c                                       = '6';
            cuenta2.Holding__c                                  = true;
            cuenta2.Numero_de_Holding__c                        = '1234';
            cuenta2.RecordTypeId                                = RecordTypeIdAccount;
            cuenta2.Fecha_de_Vigencia_Holding__c                = DateTime.now();
            cuenta2.Ejecutivo_comercial_renovacion__c           = usuario.id;
            cuenta2.Suscriptor_de_renovacion__c                 = usuario2.id;

            insert cuenta2;
            
            Corredor__c co = new Corredor__c();
            co.Name        = 'Pruebas';
            co.Rut__c      = '100448685';
            co.Cuenta__c   = cuenta.Id;
            
            insert co;

            Corredor__c co2 = new Corredor__c();
            co2.Name        = 'Pruebas2';
            co2.Rut__c      = '128874884';
            co2.Cuenta__c   = cuenta2.Id;
            
            insert co2;

            Id recordTypeIndColectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();
            
            Poliza__c poliza                                = new Poliza__c();
            poliza.Cuenta__c                                = cuenta.Id;
            poliza.Name                                     = '123';
            poliza.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza.RecordTypeId                             = recordTypeIndColectivos;
            poliza.Corredor__c                              = co.id;
            poliza.Estatus__c                               = 'ACTIVA';
            poliza.Agrupacion_Comercial__c                  = '123 (cuenta)';
            
            insert poliza;

            Poliza__c poliza2                                = new Poliza__c();
            poliza2.Cuenta__c                                = cuenta2.Id;
            poliza2.Name                                     = '1234';
            poliza2.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza2.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza2.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza2.RecordTypeId                             = recordTypeIndColectivos;
            poliza2.Corredor__c                              = co2.id;
            poliza2.Estatus__c                               = 'ACTIVA';
            poliza2.Agrupacion_Comercial__c                  = '1234 (cuenta)';
            
            insert poliza2;

            Poliza__c poliza3                               = new Poliza__c();
            poliza3.Cuenta__c                                = cuenta2.Id;
            poliza3.Name                                     = '1235';
            poliza3.Fecha_Inicio_de_Poliza__c                = hoy;
            poliza3.Fecha_Termino_de_Poliza__c               = hoy60;
            poliza3.Fecha_Inicio_de_Vigencia_Original__c     = hoy;
            poliza3.RecordTypeId                             = recordTypeIndColectivos;
            poliza3.Corredor__c                              = co2.id;
            poliza3.Estatus__c                               = 'ACTIVA';
            poliza3.Agrupacion_Comercial__c                  = '1235 (cuenta)';
            
            insert poliza3;
            
            ID IdrecordTypeRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Comercial_Renovacion').getRecordTypeId();
            Opportunity op = new Opportunity(
                Name = 'abcd',
                CloseDate = Date.today() + 1,
                StageName = 'Ingresar Negocio',
                RecordTypeId = IdrecordTypeRenovacion,
                AccountId = cuenta.Id
            );
            
            insert op;                       

            Test.startTest();
                CrearOportunidadRenovacion.creaOppRenovacion();
            Test.stopTest();
        }
    }    
    
}