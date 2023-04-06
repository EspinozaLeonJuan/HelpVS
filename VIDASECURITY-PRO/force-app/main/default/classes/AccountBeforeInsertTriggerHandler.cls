/**
* VASS
* @author           Jessica Gómez
* @email: 			jessica.gomez@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     	-------------    
* @version   1.0    20/10/2021     Jessica Gómez JMGR		       	Class Created
* @version   1.1    06/12/2021     Javier Tibamoza  JATC	       	Se comentarea lineas 103, 132 a 144, 198 a 203, esto 
																	por lo que como es Insert no va a comparar con el OLD.
***********************************************************************************************************************/
public class AccountBeforeInsertTriggerHandler extends TriggerHandlerBase{
     /**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##AccountBeforeInsertTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('AccountBeforeInsertTriggerHandler','mainEntry') ){
			process((List<Account>)tp.newList);
		}
	}
	/**
	* @description: 
	*/
	private void process(List<Account> lstNewAccount) {
		//List's
		List<Contact> contactos = new List <Contact>();
		List<Account> cuentas = new List <Account>();
		List<Account> accountsAgent = new List<Account>();
		List<Id> categoriaIds = new List<Id>();
		List<Id> ciudadIds = new List<Id>();
		List<Account> accountsCategoria = new List<Account>();
    List<Account_Error_Log__c> records_log = new list<Account_Error_Log__c>();
		List<Id> sucursalIds = new List<Id>();
		Ejecutivo_de_Cliente__c sinAsignar = null;
		Ejecutivo_de_Cliente__c[] ejecutivosCliente;
		Ciudad_de_Sucursal__c[] ciudadSucursales;
		Relacion_de_Categoria__c[] relaciones;
		Ejecutivo_de_Cliente__c[] noAsignados ;
		//Set's
		Set<String> rutsContacto = new Set<String>();
		Set<Id> idsEmpresas = new Set<Id>();
		Set<String> rutsEmpresas = new Set<String>();
		Set<Id> idsEjecutivos = new Set<Id>();
		Set<String> rutsEjecutivos = new Set<String>();
		Set<String> rutsAdmins = new Set<String>();
		Set<Id> idsAdmins = new Set<Id>();
		Set<String> codigos = new Set<String>();
		Set<Id> ownerIds = new Set<Id>();
		Set<Id> agenteIds = new Set<Id>();
		Set<Id> ownerIdsAgent = new Set<Id>();
    Set<Id> invalid_rut = new Set<Id>();
		//Map's
		Map<String, Contact> mapContactos = new Map<String, Contact>();
		Map<String, Account> mapCuentas = new Map<String, Account>();
		Map<Id, Contact> mapContactosCuentaAnonima = new Map <Id, Contact>();
		Map<String, Contact> mapEjecutivos = new Map<String, Contact>();
		Map<String, Contact> mapAdmins = new Map<String, Contact>();
		Map<Id, Ciudad_de_Sucursal__c> ciudadSucursalMap = new Map<Id, Ciudad_de_Sucursal__c>();
		Map<String, Account> mapCuentasEmpresa = new Map<String, Account>();
		Map<String, Contact> agenteMap = new Map<String, Contact>();
		Map<Id, Ejecutivo_de_Cliente__c> ejecutivoClienteMap = new Map<Id, Ejecutivo_de_Cliente__c>();
		Map<Id, Map<Id, Relacion_de_Categoria__c>> relacionMap = new Map<Id, Map<Id, Relacion_de_Categoria__c>>();
		Map<Id, Relacion_de_Categoria__c> categoriaMap = new Map<Id, Relacion_de_Categoria__c>();
		//Id's
		Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
		Id recordTypeCuentaEmpresa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Id recordTypeContactAgente = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId();
		Id ownerId = null;
		Id ownerIdAgent = null;
		Id agenteId = null;
		Id categoriaId = null;
		Id ciudadId = null;
		//String's
		String codAgente = '';
		//Primer Ciclo Account
		for (Account a : lstNewAccount) {
			codAgente = '';
			ownerId = null;
			agenteId = null;
			ownerIdAgent = null;
			categoriaId = null;
			ciudadId = null;
			//Rut de Contacto
			rutsContacto = AccountTriggerHelper.getRutsContacto( a, null, rutsContacto );
			//Map Cuenta
			mapCuentas = AccountTriggerHelper.getMapCuentas( a, null, mapCuentas );
			//Add Id Empresa
			Account acc = AccAsignaEmpresaAAsegurado.getCuenta(a, null, idsEmpresas); 
			//rutsEmpresa 
			rutsEmpresas = AccountTriggerHelper.getRutsEmpresas( acc, rutsEmpresas, recordTypeCuentaPersonal );
			//idsEmpresa
			idsEmpresas = AccountTriggerHelper.getIdsEmpresas( acc, idsEmpresas );
			//Obtener Id Ejecutivo
			idsEjecutivos = AccountTriggerHelper.getIdsEjecutivos( a, null, idsEjecutivos, recordTypeCuentaEmpresa );
			//Obtener Ruts ejecutivos por vencer 
			rutsEjecutivos = AccountTriggerHelper.getRutsEjecutivos( a, null, rutsEjecutivos, recordTypeCuentaEmpresa );
			//Obtener Id's Admin
			idsAdmins = AccountTriggerHelper.getIdsAdmins( a, null, idsAdmins, recordTypeCuentaEmpresa );
			//Obtener Ruts admin
			rutsAdmins = AccountTriggerHelper.getRutsAdmins( a, null, rutsAdmins, recordTypeCuentaEmpresa );
			//Obtener OwnerID de agentes para asignar ejecutivo
			//ownerIdsAgent = AccountTriggerHelper.getOwnerIdsAgent( a, null,ownerIdsAgent );//JATC: No va a ingresar en Before Insert
			//Obtener Codigos Cuenta
			codigos = AccountTriggerHelper.getCodigos( a, ownerIdsAgent, codigos );
			//Obtener id agente y ownwer para fecha y lista accounts
			ownerIds = AccountTriggerHelper.getOwnerIds( a, ownerIdsAgent, ownerIds );
			//Obtiene AgentId's
			agenteIds = AccountTriggerHelper.getAgenteIds( a, agenteIds );
			//accountsAgent
			accountsAgent.add(AccAsignaFechaSinEjecutivo.getAccountListDates(a, null));
			//Obtener categoria ciudad
			ciudadIds = AccountTriggerHelper.getCiudadIds( a, null, ciudadIds );
			//accountsCategoria
			accountsCategoria.add(AccAsignarRelacionDeCategoria.getAccountEje( a, null, ciudadIds));
			//Categoria ID
			categoriaIds = AccountTriggerHelper.getCategoriaIds( a, null, categoriaIds );
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
		Contact[] agentes = [SELECT Id, Codigo_Agente__c FROM Contact WHERE Codigo_Agente__c IN :codigos AND Codigo_Agente__c != null AND RecordTypeId =: recordTypeContactAgente ];
		Map<Id, Contact> agenteMaps = new Map<Id, Contact>([SELECT Id, Estado__c FROM Contact WHERE Id IN :agenteIds]);
		Map<Id, User> ejecutivoMap = new Map<Id, User>([SELECT Id, Ejecutivo_de_Cliente__c, Username, IsActive FROM User WHERE Id IN :ownerIds]);
		/*//JATC: No va a ingresar en Before Insert
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
		}*/
		Map<Id, Categoria_de_Cliente__c> categoriaClienteMap = new Map<Id, Categoria_de_Cliente__c>([SELECT Id, Name FROM Categoria_de_Cliente__c]);
		Map<Id, Ciudad__c> ciudadMap = new Map<Id, Ciudad__c>([SELECT Id, Name FROM Ciudad__c]);
		if( !ciudadIds.isEmpty() ){
			ciudadSucursales = [SELECT Id, Ciudad__c, Sucursal__c, Ciudad__r.Name, Sucursal__r.Name FROM Ciudad_de_Sucursal__c];

			for( Ciudad_de_sucursal__c ciudadSucursal : ciudadSucursales ){
				ciudadSucursalMap.put( ciudadSucursal.Ciudad__c, ciudadSucursal );
				sucursalIds.add( ciudadSucursal.Sucursal__c );
			}
			
			relaciones = [
				 SELECT Id, Categoria_de_Cliente__c, Categoria_de_Ejecutivo__c, Sucursal__c 
				 FROM Relacion_de_Categoria__c 
				 WHERE Categoria_de_Cliente__c IN :categoriaIds 
				 AND Sucursal__c IN :sucursalIds 
				 AND Sucursal__c <> NULL 
				 AND Categoria_de_Cliente__c <> NULL];
		}
		//Ciclo Contacto
		for( Contact c : contactos ){
			// mapa de contacto
			Contact contacto = AccCrearCuentaConContactoExistente.getMapContact( c, null, mapContactos );
			if( contacto != null) {
				mapContactos.put(contacto.rut_contacto__c, contacto);
			}
		}
		//Ciclo Ejecutivos
		for( Contact contacto : contacts ){
			//Obtiene valor de contacto para agregarlo al mapa
			Contact c = AccAsignaEjecutivoComercialACuenta.getMapEjecutivo( contacto, mapEjecutivos ); 
			if( c != null ){
				mapEjecutivos.put( c.Rut__c.toUpperCase(), c );
			}
		}
		//Ciclo Admins
		for( Contact contacto : contcs ){
			Contact c = AccAsignaAdminProdACuenta.getMapAdmin(contacto, mapAdmins); 
			if (c != null){
				mapAdmins.put(c.Rut__c.toUpperCase(), c);
			}
		}
		//Ciclo Agentes
		for( Contact agente : agentes ) {
			agenteMap.put(agente.Codigo_Agente__c, agente);
		}
		//Ciclo Cuentas Empresa
		for( Account cuenta : empresas ){
			Account cuentaEmpresa = AccAsignaEmpresaAAsegurado.getCuentaEmpresa(cuenta, null, mapCuentasEmpresa);
			if (cuentaEmpresa != null){
				mapCuentasEmpresa.put(cuentaEmpresa.Rut__c.toUpperCase(), cuentaEmpresa);
			}
		}
		//ciclo ejecutivo cliente
		/*//JATC: No va a ingresar en Before Insert
		if(!ownerIdsAgent.isEmpty()){
			for( Ejecutivo_de_Cliente__c ejecutivo : ejecutivosCliente ){
				ejecutivoClienteMap.put(ejecutivo.Usuario__c, ejecutivo);
			}
		}*/
		//ciclos relacion categoria
		if (!ciudadIds.isEmpty()) {
			for( Relacion_de_Categoria__c relacion : relaciones ){
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
		//Segundo Ciclo cuenta
		for (Account a : lstNewAccount) {
			//Map Contacto Cuenta Anonima
			Contact contactoCuenta = AccCrearCuentaConContactoExistente.getmapContactAccAnonymous( a.IsPersonAccount, a, null,mapCuentas,mapContactos,cuentaAnonima ) ;
			if( contactoCuenta != null) {
				mapContactosCuentaAnonima.put(contactoCuenta.Id, contactoCuenta);
			} 
			//Valida rut de la cuenta
			AccValidaRUTCuenta.validaRutCuenta(a, null, invalid_rut, records_log); 	
			//Actualizar cuenta 
			AccAsignaEmpresaAAsegurado.updateAccount(true, a, null, mapCuentasEmpresa, recordTypeCuentaPersonal, mapCuentasById); 
			//Actualizar cuenta en asigna Ejecutivo Comercial
			AccAsignaEjecutivoComercialACuenta.updateAccount(a, null, recordTypeCuentaPersonal,  mapContactosById, mapEjecutivos);
			//Actualizar cuenta en asigna a Admin 
			AccAsignaAdminProdACuenta.updateAccount(true,a, null, recordTypeCuentaEmpresa, mapContactosByIdAdmin, mapAdmins);
			//Ingresar agente a cuenta
			AccAsignaAgenteActualACuenta.InsertAgent(a, agenteMap);
			//Asignar Ejecutivo cliente
			AccAsignaEjecutivoDeCliente.asignarEjecurivoCliente(a, null, ejecutivoClienteMap, sinAsignar);
			if( !ciudadIds.isEmpty() ){
				AccAsignarRelacionDeCategoria.asignarRelacion(a, null, categoriaClienteMap, ciudadSucursalMap, ciudadMap, relacionMap);
			}
		}
		//tercer ciclo cuenta 
		for (Account a : accountsAgent){
			AccAsignaFechaSinEjecutivo.insertDateAccount(a, null, agenteMaps, ejecutivoMap);
		}
		//Arma Lista
		List<Case> casosContacto = [select Id, Contact.Rut_Contacto__c, Contact.Id from Case where Contact.Id IN :mapContactosCuentaAnonima.keySet() FOR UPDATE];
		//Ciclo Caso
		for (Case ca : casosContacto) {
			ca.Reasignar_a_Rut__c = Integer.valueOf(ca.Contact.Rut_Contacto__c);
			ca.ContactId = null;
		}
		if( !casosContacto.isEmpty() ){
			DatabaseUtils.updates( casosContacto );
		}
		//eliminación de contactos de cuenta anonima
		if( !mapContactosCuentaAnonima.isEmpty() ){
			DatabaseUtils.deletes( mapContactosCuentaAnonima.values() );
		}
	}
}