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
* @version   1.0    20/10/2021     Jessica Gómez JMGR	       Class Created
***********************************************************************************************************************/
public class AccountBeforeUpdateTriggerHandler extends TriggerHandlerBase{
    /**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##AccountBeforeUpdateTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('AccountBeforeUpdateTriggerHandler','mainEntry') ){
			process((List<Account>)tp.newList, (Map<Id, Account>)tp.oldMap);
		}
	}
    /**
	* @description: 
	*/
	private void process(List<Account> lstNewAccounts, Map<Id, Account> mapOldAccounts ) {
		//List's
		List<Contact> contactos = new List <Contact>();
		List<Account> cuentas = new List <Account>();
		List<Id> categoriaIds = new List<Id>();
		List<Id> ciudadIds = new List<Id>();
		List<Account> accountsCategoria = new List<Account>();
    List<Account_Error_Log__c> records_log = new list<Account_Error_Log__c>();
		Ciudad_de_Sucursal__c[] ciudadSucursales;
		Relacion_de_Categoria__c[] relaciones;
		List<Id> sucursalIds = new List<Id>();
		Ejecutivo_de_Cliente__c sinAsignar = null;
		Ejecutivo_de_Cliente__c[] ejecutivosCliente;
		Ejecutivo_de_Cliente__c[] noAsignados; 
		//Set's
		Set<String> rutsContacto = new Set<String>();
		Set<Id> idsEmpresas = new Set<Id>();
		Set<String> rutsEmpresas = new Set<String>();
		Set<Id> idsEjecutivos = new Set<Id>();
		Set<String> rutsEjecutivos = new Set<String>();
		Set<String> rutsAdmins = new Set<String>();
		Set<Id> idsAdmins = new Set<Id>();
		Set<Id> ownerIdsAgent = new Set<Id>();
    Set<Id> invalid_rut = new Set<Id>();
		//Map's
		Map<String, Contact> mapContactos = new Map<String, Contact>();
		Map<String, Account> mapCuentas = new Map<String, Account>();
		Map<Id, Contact> mapContactosCuentaAnonima = new Map <Id, Contact>();
		Map<String, Contact> mapEjecutivos = new Map<String, Contact>();
		Map<String, Contact> mapAdmins = new Map<String, Contact>();
		Map<Id, Relacion_de_Categoria__c> categoriaMap = new Map<Id, Relacion_de_Categoria__c>();
		Map<String, Account> mapCuentasEmpresa = new Map<String, Account>();
		Map<Id, Ejecutivo_de_Cliente__c> ejecutivoClienteMap = new Map<Id, Ejecutivo_de_Cliente__c>();
		Map<Id, Ciudad_de_Sucursal__c> ciudadSucursalMap = new Map<Id, Ciudad_de_Sucursal__c>();
		Map<Id, Map<Id, Relacion_de_Categoria__c>> relacionMap = new Map<Id, Map<Id, Relacion_de_Categoria__c>>();
		//Id's
		Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
		Id recordTypeCuentaEmpresa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		//Primer Ciclo Account
		for( Account a : lstNewAccounts ){
			Account accOld = mapOldAccounts.get(a.Id);
			//Rut de Contacto
			rutsContacto = AccountTriggerHelper.getRutsContacto( a, accOld, rutsContacto );
			//Map Cuenta
			mapCuentas = AccountTriggerHelper.getMapCuentas( a, accOld, mapCuentas );
			//AccAsignaEmpresaAAsegurado.getCuenta
			Account acc = AccAsignaEmpresaAAsegurado.getCuenta(a, accOld, idsEmpresas);
			//rutsEmpresa 
			rutsEmpresas = AccountTriggerHelper.getRutsEmpresas( acc, rutsEmpresas, recordTypeCuentaPersonal );
			//idsEmpresa
			idsEmpresas = AccountTriggerHelper.getIdsEmpresas( acc, idsEmpresas );
			//Obtener Id Ejecutivo
			idsEjecutivos = AccountTriggerHelper.getIdsEjecutivos( a, accOld, idsEjecutivos, recordTypeCuentaEmpresa );
			//Obtener Ruts ejecutivos por vencer 
			rutsEjecutivos = AccountTriggerHelper.getRutsEjecutivos( a, accOld, rutsEjecutivos, recordTypeCuentaEmpresa );
			//Obtener Id's Admin
			idsAdmins = AccountTriggerHelper.getIdsAdmins( a, accOld, idsAdmins, recordTypeCuentaEmpresa );
			//Obtener Ruts admin
			rutsAdmins = AccountTriggerHelper.getRutsAdmins( a, accOld, rutsAdmins, recordTypeCuentaEmpresa );
			//Obtener categoria ciudad
			ciudadIds = AccountTriggerHelper.getCiudadIds( a, accOld, ciudadIds );
			//Account Categoria
			accountsCategoria = AccountTriggerHelper.getAccountsCategoria( a, accOld, accountsCategoria, ciudadIds );
			//Categoria ID
			categoriaIds = AccountTriggerHelper.getCategoriaIds( a, accOld, categoriaIds );
			//Obtener OwnerID de agentes para asignar ejecutivo
			ownerIdsAgent = AccountTriggerHelper.getOwnerIdsAgent( a, accOld, ownerIdsAgent );
		}
		//Queries
		List<Account> cuentaAnonima = [select id from Account where Rut__c = '99999998' limit 1];
		contactos = [select Id, AccountId, rut_contacto__c from Contact where rut_contacto__c IN :rutsContacto];
		cuentas = [select Id, rut__c from Account where rut__c IN :rutsContacto];
		List<Account> empresas = [Select Id, Rut__c From Account WHere Rut__c IN :rutsEmpresas and RecordType.Name = 'Cuenta Corporativa'];
		List<Contact> contacts = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsEjecutivos];
		Map<Id, Contact> mapContactosById = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsEjecutivos]);
		Map<Id, Account> mapCuentasById = new Map<ID, Account>([Select Id, Rut__c From Account Where Id IN :idsEmpresas and RecordType.Name = 'Cuenta Corporativa']);
		List<Contact> contcs = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsAdmins];
		Map<Id, Contact> mapContactosByIdAdmin = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsAdmins]);
		User userCliente = [SELECT Id FROM User WHERE Username LIKE 'sfvida@security.cl%' LIMIT 1];
		if(!ownerIdsAgent.isEmpty()){
			Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id IN :ownerIdsAgent]);
			ejecutivosCliente = [SELECT Id, Codigo__c, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Usuario__c IN :ownerIdsAgent AND Codigo__c <> '0'];
			noAsignados = [SELECT Id, Codigo__c, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Codigo__c = '0' LIMIT 1];
			if(noAsignados.isEmpty()){
				sinAsignar = new Ejecutivo_de_Cliente__c(Codigo__c = '0', Name = 'SIN EJECUTIVO', Usuario__c = userCliente.Id);
				insert sinAsignar;
			}else{
				sinAsignar = noAsignados[0];
			}
		}
		Map<Id, Categoria_de_Cliente__c> categoriaClienteMap = new Map<Id, Categoria_de_Cliente__c>([SELECT Id, Name FROM Categoria_de_Cliente__c]);
		Map<Id, Ciudad__c> ciudadMap = new Map<Id, Ciudad__c>([SELECT Id, Name FROM Ciudad__c]);
		if (!ciudadIds.isEmpty()) {
			ciudadSucursales = [SELECT Id, Ciudad__c, Sucursal__c, Ciudad__r.Name, Sucursal__r.Name FROM Ciudad_de_Sucursal__c];
			for( Ciudad_de_sucursal__c ciudadSucursal : ciudadSucursales ) {
				ciudadSucursalMap.put(ciudadSucursal.Ciudad__c, ciudadSucursal);
				sucursalIds.add(ciudadSucursal.Sucursal__c);
			}
			relaciones = [
				SELECT Id, Categoria_de_Cliente__c, Categoria_de_Ejecutivo__c, Sucursal__c 
				FROM Relacion_de_Categoria__c 
				WHERE Categoria_de_Cliente__c IN :categoriaIds 
				AND Sucursal__c IN :sucursalIds 
				AND Sucursal__c <> NULL 
				AND Categoria_de_Cliente__c <> NULL];
		}
		//Primer Ciclo Contacto
		for( Contact c : contactos ){
			// mapa de contacto
			Contact contacto = AccCrearCuentaConContactoExistente.getMapContact(c, null, mapContactos);
			if( contacto != null ){
				mapContactos.put(contacto.rut_contacto__c, contacto);
			} 
		}
		//ciclo ejecutivo cliente
		if(!ownerIdsAgent.isEmpty()){
			for( Ejecutivo_de_Cliente__c ejecutivo : ejecutivosCliente ) {
				ejecutivoClienteMap.put(ejecutivo.Usuario__c, ejecutivo);
			}
		}
		//ciclos relacion categoria
		if(!ciudadIds.isEmpty()) {
			for( Relacion_de_Categoria__c relacion : relaciones) {
				if( !relacionMap.containsKey( relacion.Sucursal__c ) ){
					categoriaMap = new Map<Id, Relacion_de_Categoria__c>();
					categoriaMap.put( relacion.Categoria_de_Cliente__c, relacion );
					relacionMap.put( relacion.Sucursal__c, categoriaMap );
				}else{
					categoriaMap = relacionMap.get( relacion.Sucursal__c );
					categoriaMap.put( relacion.Categoria_de_Cliente__c, relacion );
				}
			}
		}
		//Segundo Ciclo Contacto 
		for (Contact contacto : contacts) {
			//Obtiene valor de contacto para agregarlo al mapa
			Contact c = AccAsignaEjecutivoComercialACuenta.getMapEjecutivo(contacto, mapEjecutivos); 
			if(c != null){
				mapEjecutivos.put(c.Rut__c.toUpperCase(), c);
			}
		}
		//Tercer Ciclo Contacto 
		for (Contact contacto : contcs) {
			Contact c = AccAsignaAdminProdACuenta.getMapAdmin(contacto, mapAdmins); 
			if (c != null)
				mapAdmins.put(c.Rut__c.toUpperCase(), c);
		}
		//Ciclo Cuentas Empresa
		for (Account cuenta : empresas) {
			Account accOld = mapOldAccounts.get(cuenta.Id);
			Account cuentaEmpresa = AccAsignaEmpresaAAsegurado.getCuentaEmpresa(cuenta, accOld, mapCuentasEmpresa);
			if (cuentaEmpresa != null)
				mapCuentasEmpresa.put(cuentaEmpresa.Rut__c.toUpperCase(), cuentaEmpresa);
		}
		//Segundo Ciclo cuenta
		for (Account a : lstNewAccounts) {
			Account accOld = mapOldAccounts.get(a.Id);
			//Map Contacto Cuenta Anonima
			Contact contactoCuenta = AccCrearCuentaConContactoExistente.getmapContactAccAnonymous(a.IsPersonAccount, a, accOld,mapCuentas,mapContactos,cuentaAnonima ) ;
			if(contactoCuenta != null) {
				mapContactosCuentaAnonima.put(contactoCuenta.Id, contactoCuenta);
			} 
			//Valida rut de la cuenta
			AccValidaRUTCuenta.validaRutCuenta(a, accOld, invalid_rut, records_log); 	
			//Actualizar cuenta 
			AccAsignaEmpresaAAsegurado.updateAccount(false, a, accOld, mapCuentasEmpresa, recordTypeCuentaPersonal, mapCuentasById); 
			//Actualizar cuenta en asigna Ejecutivo Comercial
			AccAsignaEjecutivoComercialACuenta.updateAccount(a, accOld, recordTypeCuentaPersonal,  mapContactosById, mapEjecutivos);
			//Actualizar cuenta en asigna a Admin 
			AccAsignaAdminProdACuenta.updateAccount(false, a, accOld, recordTypeCuentaEmpresa, mapContactosByIdAdmin, mapAdmins);
			//Asignar Ejecutivo cliente
			AccAsignaEjecutivoDeCliente.asignarEjecurivoCliente(a, accOld, ejecutivoClienteMap, sinAsignar);
			if( !ciudadIds.isEmpty() ){
				AccAsignarRelacionDeCategoria.asignarRelacion(a, accOld, categoriaClienteMap, ciudadSucursalMap, ciudadMap, relacionMap);
			}
		}
    // RUT INVALIDO
    Set<Id> ids_invalidos = new Set<Id>();
    List<Account_Error_Log__c> logs_2 = new list<Account_Error_Log__c>();
    for( Account_Error_Log__c logs : [SELECT Id, Cuenta__c, Cuenta__r.Id FROM Account_Error_Log__c WHERE Cuenta__c IN:invalid_rut AND Type__c ='RUT inválido' ] ){
      ids_invalidos.add(logs.Cuenta__r.Id);
    } 
    for( Account_Error_Log__c logs_1 : records_log) {
      if ( !ids_invalidos.contains(logs_1.Cuenta__c) ) {
        logs_2.add(logs_1);
      }
    }
    if ( !logs_2.isEmpty() ) {
      try {
        insert logs_2;
      } catch(DmlException e) {
        System.debug('Error al inserter el registro: ' + e.getMessage());
      }
    }
		//Arma Lista
		List<Case> casosContacto = [select Id, Contact.Rut_Contacto__c, Contact.Id from Case where Contact.Id IN :mapContactosCuentaAnonima.keySet() FOR UPDATE];
		//Ciclo Caso
		for (Case ca : casosContacto) {
			ca.Reasignar_a_Rut__c = Integer.valueOf(ca.Contact.Rut_Contacto__c);
			ca.ContactId = null;
		}
		if (!casosContacto.isEmpty()){
			DatabaseUtils.updates(casosContacto);
		}
		//eliminación de contactos de cuenta anonima
		if (!mapContactosCuentaAnonima.isEmpty()){
			DatabaseUtils.deletes(mapContactosCuentaAnonima.values());
		}
	}
}