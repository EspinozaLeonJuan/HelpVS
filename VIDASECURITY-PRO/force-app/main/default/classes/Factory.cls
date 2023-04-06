/**
 * @File Name          : Factory.cls
 * @Description        : 
 * @Author             : Juan Espinoza León
 * @Group              : 
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 9/16/2019, 1:20:11 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    8/20/2019, 5:18:37 PM   Juan Espinoza León     Initial Version
**/
public class Factory {
    
    static string rutCuenta = '88888888';
    static string dvCuenta = '8';
    static string mailCuenta = 'mail@cuenta.cl';
    
    public static Account buildAccount(String recordTypeName){
        Account cuenta = new Account();
        
        if (recordTypeName.contains('personal')){
            cuenta.FirstName = 'Nombre';
            cuenta.LastName = 'Cuenta';
            cuenta.Rut_contacto__pc = rutCuenta;
        	cuenta.DV_contacto__pc = dvCuenta;
        }
        else {
            cuenta.Name = 'Nombre de la Cuenta';
            cuenta.Rut__c = rutCuenta;
        	cuenta.DV__c = dvCuenta;
        }
        
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        
        return cuenta;
    }
    
    public static Account crearAccountAnonimo(){
        Account cuenta = new Account();
        cuenta.Name = 'Anonimo';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
        cuenta.Rut__c = '99999998';
        cuenta.DV__c = '0';
        insert cuenta;
        return cuenta;
    }
    
    public static Account crearAccountAnonimoVentas(){
        Account cuenta = new Account();
        cuenta.Name = 'Anonimo Ventas';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
        cuenta.Rut__c = '99999997';
        cuenta.DV__c = '2';
        insert cuenta;
        return cuenta;
    }
    
    public static void crearDatosTotalpack(User usu) {
        Area__c area = new Area__c();
        area.TP_Negocio__c = 'VS';
        area.TP_Pais__c = 'Chile';
        area.Name = 'Área Prueba';
        insert area;
        
        Sucursal__c suc = new Sucursal__c();
        suc.Codigo_Sucursal__c = '1';
        suc.Area__c = area.Id;
        suc.Name = 'Sucursal Prueba';
        suc.TP_Oficina__c = 1;
        insert suc;
        
        SucursalUsuario__c sucUsu = new SucursalUsuario__c();
        sucUsu.Sucursal__c = suc.Id;
        sucUsu.Usuario__c = usu.Id;
        insert SucUsu;
        
        TPSesion__c ses = new TPSesion__c();
        ses.Usuario__c = usu.Id;
        insert ses;
        
        TPAtencion__c ate = new TPAtencion__c();
        ate.Sesion_Totalpack__c = ses.ID;
        ate.Rut__c = 88888888;
        ate.DV__c = '8';
        
        Account cuenta = buildAccount('Cuenta personal');
        insert cuenta;
        Case caso = buildCasoSF('Consultas', cuenta);
        insert caso;
        
        ate.Caso__c = caso.Id;
        insert ate;
        
        //Caso antiguo por sección de seguimiento de casos
        Case casoAntiguo = buildCasoSF('Consultas', cuenta);
        casoAntiguo.Canal__c = 'Sucursal';
        casoAntiguo.CreatedDate = Date.today() - 5;
        insert casoAntiguo;
    }
    
    // migración casos vs a casos sf
    public static Case buildCasoSF(String recordTypeName, Account cuenta) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente'; 
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Detalle Solicitud';
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }
    
     public static Usuario_Backup__c buildUsuarioBackup() {
         Usuario_Backup__c uback = new Usuario_Backup__c();
         uback.Name = 'Usuario Backup';
         uback.Casos_BackOffice__c = 0;
         uback.Casos_En_Proceso__c = 0;
         uback.Casos_En_Revisi_n__c = 0;
         uback.Casos_Cerrados__c = 0;
         uback.Casos_Rechazado__c = 0;
         uback.Casos_Total__c = 0;
         uback.Tareas_Sin_Iniciar__c = 0;
         uback.Tareas_En_Curso__c = 0;
         uback.Tareas_Completada__c = 0;
         uback.Tareas_Rechazada__c = 0;
         uback.Tareas_Descartadas__c = 0;
         uback.Tareas_Total__c = 0;
         uback.Colaboraciones_Sin_Iniciar__c = 0;
         uback.Colaboraciones_En_Curso__c = 0;
         uback.Colaboraciones_Completada__c = 0;
         uback.Colaboraciones_Rechazada__c = 0;
         uback.Colaboraciones_Total__c = 0;        
         uback.Colaboraciones_Descartadas__c = 0;
         uback.UBAC_Area__c = 'Producción RRVV';
         insert uback;
         return uback;
    }

       // migración casos vs a casos sf
    public static Lead buildProspectoSF() {
        Lead Prospecto = new Lead();
        Prospecto.Rut__c = '88888888-8';
        Prospecto.FirstName = 'Nombre Prospecto';
        Prospecto.LastName = 'Apellido Prospecto';
        
        insert Prospecto;

        return Prospecto;
    }
    
    public static Account crearAccountSF(){
        Account cuenta = new Account();
        cuenta.Name = 'Cuenta Ventas';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
        cuenta.Rut__c = '88888888';
        cuenta.DV__c = '8';
        insert cuenta;
        return cuenta;
    }
    
    public static User buildUser() {
        // el username TIENE que ser UNICO entre todas las organizaciones de Salesforce (no solo la nuestra y nuestras sandboxes), por eso la parafernalia
        String orgId = UserInfo.getOrganizationId();
        String fechaString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String nombreUnico = orgId + fechaString + randomInt;
        
        Profile perfilEstandar = [SELECT Id FROM Profile WHERE Name = 'Usuario estándar' LIMIT 1];
        
        User usuario = new User(); 
        usuario.Username = nombreUnico + '@security' + orgId + '.cl';
        usuario.email = nombreUnico + '@security' + orgId + '.cl';
        usuario.FirstName = 'Nombre';
        usuario.LastName = 'Apellido';
        usuario.Alias = 'pru';
        usuario.CommunityNickname = nombreUnico;
        usuario.LocaleSidKey = 'en_US';
        usuario.TimeZoneSidKey = 'GMT';
        usuario.ProfileID = perfilEstandar.Id;
        usuario.LanguageLocaleKey = 'en_US';
        usuario.EmailEncodingKey = 'UTF-8';
        usuario.RUT_Usuario__c = string.valueOf(randomInt);
        
        return usuario;
    }
    
     public static Task buildTask_TareaUR(Id whatId){
        Task tarea = new Task();
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;
        tarea.RecordTypeId = RecordTypeId;
        tarea.Subject = 'Tarea UR';
        tarea.WhatId = whatId;
        
        return tarea;
    }

    public static Task buildTask(Id whatId){
        Task tarea = new Task();
        tarea.Subject = 'Llamada';
        tarea.WhatId = whatId;
        return tarea;
    }
    
    public static Event buildEvent(Id whatId){
        Event evento = new Event();
        evento.Subject = 'Reunión';
        evento.WhatId = whatId;
        return evento;
    }

    public static Task buildTask_Colaboracion(Id whatId){
        Task tarea = new Task();
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;
        tarea.RecordTypeId = RecordTypeId;
        tarea.Subject = 'Colaboración Reclamo';        
        tarea.Status = 'En Curso';
        tarea.WhatId = whatId;
        
        return tarea;
    }
    
    public static Contact buildContact(Account cuenta) {
        Contact contacto = new Contact();
        contacto.FirstName = 'NombreContacto';
        contacto.LastName = 'ApellidoContacto';
        contacto.AccountId = cuenta.Id;
        contacto.Account = cuenta;
        return contacto;
    }
    
    public static Contact buildContactSF(Account cuenta) {
        Contact contacto = new Contact();
        contacto.FirstName = 'NombreContacto';
        contacto.LastName = 'ApellidoContacto';
        contacto.AccountId = cuenta.Id;
        contacto.Account = cuenta;
        insert contacto;
        return contacto;
    }
    
     public static Contact buildContactSF() {
        Contact contacto = new Contact();
        contacto.FirstName = 'NombreContacto';
        contacto.LastName = 'ApellidoContacto';         
        insert contacto;
        return contacto;
    }
    
    public static Campana_Vida_Security__c buildCampanaEPA() {
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Campaña EPA';
        cam.Fecha_Inicio_de_Campa_a__c = Date.today();
        cam.Fecha_de_Termino_de_Campa_a__c = Date.today() + 2;
        return cam;
    }
    
    public final static Contacto contacto = new Contacto();
    public class Contacto {
        private Contact o {set; get;}
        public Contacto(){}
        public Contact default(){
            o = (Contact)Factory.buildSObject(Contact.sObjectType, new Map<String,Object> {
                'FirstName' => 'Nombre',
                    'LastName' => 'Apellido'
                    });
            return o;
        }
        public Contact build(Map<String,Object> attrs) {
            o = default();
            o = (Contact)Factory.buildSObject(o, attrs);
            return o;
        }
        public Contact buildInsert(){
            o = default();
            insert o;
            return o;
        }
        public Contact buildInsert(Map<String,Object> attrs){
            o = build(attrs);
            insert o;
            return o;
        }
        public Contact get(){
            return o;
        }
        public Contact reload(){
            o = (Contact)Factory.reloadSObject(get(), new String[] {});
            return o;
        }
        public Contact reload(String[] attrs){
            return (Contact)Factory.reloadSObject(get(), attrs);
        }
        public Contact reload(Contact p, String[] attrs) {
            return (Contact)Factory.reloadSObject(p, attrs);
        }
    }
    
    public final static Cuenta cuenta = new Cuenta();
    public class Cuenta {
        private Account o {set; get;}
        public Cuenta(){}
        public Account default(){
            o = (Account)Factory.buildSObject(Account.sObjectType, new Map<String,Object> {
                'Name' => 'Nombre de la Cuenta',
                    'RecordTypeId' => Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId(),
                    'Rut__c' => rutCuenta,
                    'DV__c' => dvCuenta
                    });
            return o;
        }
        public Account build(Map<String,Object> attrs) {
            o = default();
            o = (Account)Factory.buildSObject(o, attrs);
            return o;
        }
        public Account buildInsert(){
            o = default();
            insert o;
            return o;
        }
        public Account buildInsert(Map<String,Object> attrs){
            o = build(attrs);
            insert o;
            return o;
        }
        public Account get(){
            return o;
        }
        public Account reload(){
            o = (Account)Factory.reloadSObject(get(), new String[] {});
            return o;
        }
        public Account reload(String[] attrs){
            return (Account)Factory.reloadSObject(get(), attrs);
        }
        public Account reload(Account p, String[] attrs) {
            return (Account)Factory.reloadSObject(p, attrs);
        }
    }
    
    public final static Poliza poliza = new Poliza();
    public class Poliza {
        private Poliza__c o {set; get;}
        public Poliza(){}
        public Poliza__c default(){
            o = (Poliza__c)Factory.buildSObject(Poliza__c.sObjectType, new Map<String,Object> {
                'N_Poliza__c' => 171399,
                    'Estatus__c' => 'ACTIVA',
                    'Duracion_Poliza__c' => 'PERMANENTE',
                    'Moneda_Poliza__c' => 'UF',
                    'Regimen_Tributario__c' => '2015',
                    'Modalidad_APV__c' => 'Modalidad APV Vigente',
                    'Edad_al_Momento_de_Contratar__c' => 28,
                    'Rut_Asegurado__c' => '11111111',
                    'DV__c' => '1',
                    'Name' => '171399',
                    'RecordTypeId' => Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId()
                    });
            return o;
        }
        public Poliza__c build(Map<String,Object> attrs) {
            o = default();
            o = (Poliza__c)Factory.buildSObject(o, attrs);
            return o;
        }
        public Poliza__c buildInsert(Map<String,Object> attrs){
            o = build(attrs);
            insert o;
            return o;
        }
        public Poliza__c get(){
            return o;
        }
        public Poliza__c reload(){
            o = (Poliza__c)Factory.reloadSObject(get(), new String[] {});
            return o;
        }
        public Poliza__c reload(String[] attrs){
            return (Poliza__c)Factory.reloadSObject(get(), attrs);
        }
        public Poliza__c reload(Poliza__c p, String[] attrs) {
            return (Poliza__c)Factory.reloadSObject(p, attrs);
        }
    }
    
    private static SObject buildSObject(SObject sobjectObj, Map<String, Object> attributes){
        for (String fieldName : attributes.keySet())
            sobjectObj.put(fieldName, attributes.get(fieldName));
        return sobjectObj;
    }
    
    private static SObject buildSObject(Schema.SObjectType sType, Map<String, Object> attributes){
        SObject sobj = sType.newSObject();
        for (String fieldName : attributes.keySet())
            sobj.put(fieldName, attributes.get(fieldName));
        return sobj;
    }
    
    public static SObject reloadSObject(SObject sobj, Set<String> fieldNames) {
        Schema.SObjectType sType = sobj.getSObjectType();
        String[] arr = new String[]{};
            for (String fieldName : fieldNames)
            arr.add(fieldName);
        return reloadSObject(sobj, arr);
    }
    
    private static SObject reloadSObject(SObject sobj, String[] fieldNames) {
        Schema.SObjectType sType = sobj.getSObjectType();
        String soql = 'SELECT Id' + (fieldNames.size() > 0 ? ', ' + toStringList(fieldNames) : '') +
            ' FROM ' + sType.getDescribe().getName() + ' WHERE Id = \'' + sobj.Id + '\' LIMIT 1';
        return Database.query(soql);
    }
    
    public static List<SObject> reloadSObjects(List<SObject> objects, String[] fieldNames) {
        if (objects == null || objects.size() == 0)
            return new List<SObject>();
        String objectApiName = objects[0].getSObjectType().getDescribe().getName();
        String[] ids = new String[] {};
            for (SObject obj : objects)
            ids.add('\'' + obj.Id + '\'');
        String soql = 'SELECT Id' + (fieldNames.size() > 0 ? ', ' + toStringList(fieldNames) : '') +
            ' FROM ' + objectApiName +
            ' WHERE Id IN (' + toStringList(ids) + ')';
        return Database.query(soql);
    }
    
    private static String toStringList(String[] arr) {
        String stringList = '';
        for (Integer i = 0; i < arr.size(); i++){
            stringList += arr[i];
            if (i < (arr.size() - 1))
                stringList += ', ';
        }
        return stringList;
    }
}