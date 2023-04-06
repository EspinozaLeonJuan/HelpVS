@isTest
private class FactoryTest {
	static testMethod void factoryContact() {
		Contact c1 = Factory.contacto.buildInsert();
		Contact c2 = Factory.contacto.get();
		Contact c3 = Factory.contacto.reload();
		Contact c4 = Factory.contacto.reload(new String[]{});
		Contact c5 = Factory.contacto.reload(c4, new String[]{});
		System.assertEquals(c1.Id, c2.Id);
		System.assertEquals(c2.Id, c3.Id);
	}

	static testMethod void factoryAccount(){
		Account a1 = Factory.cuenta.buildInsert();
		Account a2 = Factory.cuenta.get();
		Account a3 = Factory.cuenta.reload();
		Account a4 = Factory.cuenta.reload(new String[]{});
		Account a5 = Factory.cuenta.reload(a4, new String[]{});
		System.assertEquals(a1.Id, a2.Id);
		System.assertEquals(a2.Id, a3.Id);
	}

	static testMethod void factoryPoliza(){
		Account acc1 = Factory.cuenta.buildInsert();
		Poliza__c a1 = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => acc1.Id });
		Poliza__c a2 = Factory.poliza.get();
		Poliza__c a3 = Factory.poliza.reload();
		Poliza__c a4 = Factory.poliza.reload(new String[]{});
		Poliza__c a5 = Factory.poliza.reload(a4, new String[]{});
		System.assertEquals(a1.Id, a2.Id);
		System.assertEquals(a2.Id, a3.Id);
	}

	static testMethod void reloadSobjects() {
		Account a1 = Factory.cuenta.buildInsert();
		Account a2 = Factory.cuenta.buildInsert(new Map<String,Object>{'Rut__c' => '16355278', 'DV__c' => '7'});
		List<Account> accounts = [SELECT Id FROM Account];
		List<Account> accountReload = (List<Account>)Factory.reloadSObjects(accounts, new String[]{'Name'});
		System.assertNotEquals(accountReload.size(), 0);
	}

	static testMethod void reloadSobjectWithSetField() {
		Account a1 = Factory.cuenta.buildInsert();
		Account aReloaded = (Account)Factory.reloadSObject(a1, new Set<String>{'Name'});
		System.assertEquals(a1.Id, aReloaded.Id);
	}
    
    //FactoryEscritorio
    static testMethod void buildCaso_Detalle_ED()
    {
        Account cuenta = Factory.crearAccountAnonimo();
        FactoryEscritorio.buildCaso_Detalle_ED('Solicitudes',cuenta);
    }
    
    static testMethod void buildCasoED()
    {
        Account cuenta = Factory.crearAccountAnonimo();
        FactoryEscritorio.buildCasoED('Solicitudes',cuenta);        
    }

	static testMethod void buildSolicitud()
	{
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = FactoryEscritorio.buildCasoED('Solicitudes',cuenta);  
        FactoryEscritorio.buildSolicitud(caso);       
    }
    
    static testMethod void buildCaso_sinCuenta()
	{        
        Case caso = FactoryEscritorio.buildCaso_sinCuenta('Solicitudes');  
    }
    
    static testMethod void buildCaso_sinDetalle()
	{
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = FactoryEscritorio.buildCaso_sinDetalle('Solicitudes',cuenta);  
    }
    
    static testMethod void  buildCasoSF()
    {
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = Factory.buildCasoSF('Solicitudes',cuenta);  
    }
    
    static testMethod void buildCampanaEPA()
    {
        Campana_Vida_Security__c camp = Factory.buildCampanaEPA();
    }
    
    static testMethod void  buildContact() 
    {
         Account cuenta = Factory.crearAccountAnonimo();
		 Contact cont = Factory.buildContact(cuenta);
    }
    
    static testMethod void buildUser()
    {
        User user = Factory.buildUser();
    }
    
    static testMethod void crearDatosTotalpack()
    {
        User user = Factory.buildUser();
        Factory.crearDatosTotalpack(user);
    }
    
    static testMethod void buildCasoED2()
    {
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = FactoryEscritorio.buildCasoED2('Solicitudes',cuenta);         
    }
    
   /* static testMethod void buildUsuarioBackup()
    {
        Usuario_Backup__c usuario = FactoryEscritorio.buildUsuarioBackup();        
    }
    
    static testMethod void buildUsuariosBackup()
    {
        List<Usuario_Backup__c> usuarios = FactoryEscritorio.buildUsuariosBackup();
    }*/
    
    static testMethod void CasosHijoSolicitudes()
    {
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
    }
    
    static testMethod void CasosHijoConsultas()
    {
        List<Case> casos = FactoryEscritorio.CasosHijoConsultas();
    }
    
    static testMethod void CasosHijoReclamos()
    {
        List<Case> casos = FactoryEscritorio.CasosHijoReclamos();
    }
   /*        
    static testMethod void buildAccount_Test()
    {
        Test.startTest();
        Factory.buildAccount('empresa');   
        Test.stopTest();
    }*/
    
    static testMethod void crearAccountAnonimoVentas_Test()
    {
        Test.startTest();
        Factory.crearAccountAnonimoVentas();   
        Test.stopTest();
    }
    
    static testMethod void buildProspectoSF_Test()
    {
        Test.startTest();
        Factory.buildProspectoSF();   
        Test.stopTest();
    }
    
    static testMethod void crearAccountSF_Test()
    {
        Test.startTest();
        Factory.crearAccountSF();   
        Test.stopTest();
    }
    
    static testMethod void buildTask_TareaUR_Test()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        Factory.buildTask_TareaUR(caso.Id);   
        Test.stopTest();
    }
    
    static testMethod void buildTask_Test()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Factory.buildTask(caso.Id);   
        Test.stopTest();
    }
    
    static testMethod void buildEvent_Test()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        Factory.buildEvent(caso.Id);   
        Test.stopTest();
    }
    
    static testMethod void buildContactSF_Test()
    {
        Test.startTest();
        Factory.buildContactSF();   
        Test.stopTest();
    }
   
    static testMethod void buildContactSF_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Factory.buildContactSF(cuenta);   
        Test.stopTest();
    }     
    
    static testMethod void buildTask_Colaboracion_Test()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        Factory.buildTask_Colaboracion(caso.Id);   
        Test.stopTest();
    }
    
    static testMethod void buildUsuarioBackup_Test()
    {
        Test.startTest();
        Factory.buildUsuarioBackup();   
        Test.stopTest();
    }
       
}