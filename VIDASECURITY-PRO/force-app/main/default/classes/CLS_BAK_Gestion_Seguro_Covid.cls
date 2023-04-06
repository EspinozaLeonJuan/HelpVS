/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-31-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_BAK_Gestion_Seguro_Covid {

    public class Wrapper_Contact
    {
        @auraEnabled public String RutEmpresa {get;set;}
        @auraEnabled public String NombreContacto {get;set;}
        @auraEnabled public String ApellidoContacto {get;set;}
        @auraEnabled public String RutContacto {get;set;}
        @auraEnabled public String TipoContacto {get;set;}
        @auraEnabled public String EmailContacto {get;set;}
        @auraEnabled public String RutEmpresaCorredora {get;set;}
    }

    public class OBJ_Contacto
    {
        public String Key { get; set;}

        public String RutEmpresa { get; set;}

        public String EmailContacto { get; set;}

        public String RutContacto { get; set;}

        public String TipoContacto { get; set;}

        public String NombreContacto { get; set;}

        public String ApellidoContacto { get; set;}

        public String RutEmpresaCorredora { get; set;}

        public Contact Contacto { get; set;}
    }

    public class Wrapper_Empresa
    {
        @auraEnabled public String RutEmpresa {get;set;}

        @auraEnabled public String NombreEmpresa {get;set;}

        @auraEnabled public Boolean ExisteEmpresa {get;set;}

    }

    private static String  Account_RecordTypeId_Empresarial  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
    private static String  Account_RecordTypeId_Personal  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();

    private static String  Contact_RecordTypeId_Contratante  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contratante').getRecordTypeId();
    private static String  Contact_RecordTypeId_Corredor  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Corredor').getRecordTypeId();

    private static void actualizaContactos_Empresarial( Map<String, Account> mapAccounts, List<String> idsAccounts, Map<String, Corredor__c> mapCorredoras, Map<String, OBJ_Contacto> mapResult_Contratantes,Map<String, OBJ_Contacto> mapResult_Corredores, List<String> emailsListContratantes, List<String> emailsListCorredores)
    {
        try
        {
             //desactiva todos los contactos contrantantes y corredores que han sido usado en el seguro covid segun rut de empresa
            List<Contact> list_Contratantes_Update = [SELECT Id, Activo_Seguro_COVID__c  FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Contratante AND AccountId IN :  idsAccounts AND Activo_Seguro_COVID__c = true];

            for (Contact c : list_Contratantes_Update)
            {
                c.Activo_Seguro_COVID__c = false;
            //    c.Fecha_Notificacion_Seguro_COVID__c = null;
            //    c.Notificacion_Seguro_COVID__c = false;
            }

            update list_Contratantes_Update;

            system.debug('@@@@@ list_Contratantes_Update '+list_Contratantes_Update.size());


            List<Contact> list_Corredores_Update = [SELECT Id, Activo_Seguro_COVID__c FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Corredor AND AccountId IN :  idsAccounts AND Activo_Seguro_COVID__c = true];

            for (Contact c : list_Corredores_Update)
            {
                c.Activo_Seguro_COVID__c = false;
            //    c.Fecha_Notificacion_Seguro_COVID__c = null;
            //    c.Notificacion_Seguro_COVID__c = false;
            }

            update list_Corredores_Update;

            system.debug('@@@@@ list_Corredores_Update '+list_Corredores_Update.size());

            //////////

            List<Contact> list_Contratantes_Accounts = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c , Account.RUT_con_DV__c FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Contratante AND AccountId IN: idsAccounts AND Email IN :  emailsListContratantes AND Es_Seguro_COVID__c = true];

            //obtiene todos los contactos contrantantes y corredores que han sido usado en el seguro covid segun el correo ingresado
            system.debug('@@@@@ list_Contratantes_Accounts '+list_Contratantes_Accounts.size());

            List<Contact> list_Corredores_Accounts = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c,  Account.RUT_con_DV__c FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Corredor  AND AccountId IN: idsAccounts AND Email IN :  emailsListCorredores AND Es_Seguro_COVID__c = true];


            OBJ_Contacto objeto;

            system.debug('@@@@@ list_Corredores_Accounts '+list_Corredores_Accounts.size());

            for (Contact contacto: list_Contratantes_Accounts)
            {
                    String key = contacto.Account.Rut_con_DV__c +'#'+contacto.Email.toLowerCase();
                    system.debug('@@@@ 183. Key '+key);
                    objeto = mapResult_Contratantes.get(key);
                    if (objeto != null)
                    {
                        objeto.Contacto = contacto;
                        mapResult_Contratantes.put(objeto.Key, objeto);//dato csv con informacion de contacto asociada
                    }
            }

            for (Contact contacto: list_Corredores_Accounts)
            {
                String key = contacto.Account.Rut_con_DV__c +'#'+contacto.Email.toLowerCase();
                system.debug('@@@@ 196. Key '+key);
                objeto = mapResult_Corredores.get(key);
                if (objeto != null)
                {
                    objeto.Contacto = contacto;
                    mapResult_Corredores.put(objeto.Key, objeto);//dato csv con informacion de contacto asociada
                }
            }

           system.debug('@@@@@ mapResult_Contratantes '+mapResult_Contratantes.size());//contratantes existentes cargados para actualizar
           system.debug('@@@@@ mapResult_Corredores '+mapResult_Corredores.size());//corredores existentes cargados para actualizar

           Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Insert = new Map<String, OBJ_Contacto>();
           Map<String, OBJ_Contacto> mapResult_Corredores_ST_Insert= new Map<String, OBJ_Contacto>();

           Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Update = new Map<String, OBJ_Contacto>();
           Map<String, OBJ_Contacto> mapResult_Corredores_ST_Update = new Map<String, OBJ_Contacto>();

           for (String key: mapResult_Contratantes.keyset()){
                 objeto = mapResult_Contratantes.get(key);
                 if (objeto.Contacto == null)//dato cargado es nuevo
                 {
                    mapResult_Contratantes_ST_Insert.put(objeto.key, objeto);
                 }
                 else//dato cargado existe
                 {
                    mapResult_Contratantes_ST_Update.put(objeto.key, objeto);
                 }
           }

           for (String key: mapResult_Corredores.keyset()){
                objeto = mapResult_Corredores.get(key);
                if (objeto.Contacto == null)//dato cargado es nuevo
                {
                    mapResult_Corredores_ST_Insert.put(objeto.key, objeto);
                }
                else//dato cargado existe
                {
                    mapResult_Corredores_ST_Update.put(objeto.key, objeto);
                }
            }

            system.debug('@@@@@ mapResult_Contratantes_ST_Insert '+mapResult_Contratantes_ST_Insert.size());//contratantes existentes cargados para actualizar  -- si correo no esta anonimo agregar
            system.debug('@@@@@ mapResult_Contratantes_ST_Update '+mapResult_Contratantes_ST_Update.size());//corredores existentes cargados para actualizar
            system.debug('@@@@@ mapResult_Corredores_ST_Insert '+mapResult_Corredores_ST_Insert.size());//contratantes existentes cargados para actualizar   -- si correo no esta anonimo agregar
            system.debug('@@@@@ mapResult_Corredores_ST_Update '+mapResult_Corredores_ST_Update.size());//corredores existentes cargados para actualizar

            ////////////
            Account tAnon =  mapAccounts.get('99999998-0');

            List<Contact> list_Contratantes_Anomimos = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c , Account.RUT_con_DV__c FROM Contact WHERE AccountId =: tAnon.Id AND RecordTypeId =: Contact_RecordTypeId_Contratante AND Email IN :  emailsListContratantes AND Es_Seguro_COVID__c = true];

            List<Contact> list_Corredores_Anonimos = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c,  Account.RUT_con_DV__c FROM Contact WHERE AccountId =: tAnon.Id AND RecordTypeId =: Contact_RecordTypeId_Corredor AND Email IN :  emailsListCorredores AND Es_Seguro_COVID__c = true];

            Map<String, Contact> mapResult_Contratantes_Anonimos = new Map<String, Contact>();

            for (Contact contact : list_Contratantes_Anomimos)
            {
                mapResult_Contratantes_Anonimos.put(contact.Email, contact);
            }

            Map<String, Contact> mapResult_Corredores_Anonimos = new Map<String, Contact>();

            for (Contact contact : list_Corredores_Anonimos)
            {
                mapResult_Corredores_Anonimos.put(contact.Email, contact);
            }

            ////////////

            List<Contact> contacts_forUpdate = new List<Contact>();
            List<Contact> contacts_forInsert = new List<Contact>();

            Map<String, Contact> nuevosContratantes_Anom = new Map<String, Contact>();

            for (String key: mapResult_Contratantes_ST_Insert.keyset())
            {
                objeto = mapResult_Contratantes_ST_Insert.get(key);
                system.debug('@@@@ c objeto.RutEmpresa --> "'+objeto.RutEmpresa+'"');
                Account c = mapAccounts.get(objeto.RutEmpresa);
                system.debug('@@@@ c value --> '+c);
                if (c != null)
                {//si empresa encontrada
                    Contact contacto = new Contact();
                    contacto.FirstName = objeto.NombreContacto;
                    contacto.LastName = objeto.ApellidoContacto;
                    contacto.Email = objeto.EmailContacto;
                    contacto.Rut__c = objeto.RutContacto;
                    contacto.AccountId = c.Id;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        contacto.Empresa_Corredora__c = co.Id;
                    }
                    contacto.Es_Seguro_COVID__c = true;
                    contacto.Activo_Seguro_COVID__c = true;
                    contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                    contacts_forInsert.add(contacto);

                    if (mapResult_Contratantes_Anonimos.containsKey(objeto.EmailContacto) == false && nuevosContratantes_Anom.containsKey(objeto.EmailContacto) == false)
                    {
                        c = mapAccounts.get('99999998-0');
                        contacto = new Contact();
                        contacto.FirstName = objeto.NombreContacto;
                        contacto.LastName = objeto.ApellidoContacto;
                        contacto.Email = objeto.EmailContacto;
                        contacto.Rut__c = objeto.RutContacto;
                        contacto.AccountId = c.Id;
                        contacto.Es_Seguro_COVID__c = true;
                        contacto.Activo_Seguro_COVID__c = false;
                        contacto.Es_Anonimo__c = true;
                        contacto.RecordTypeId = Contact_RecordTypeId_Contratante;
                        nuevosContratantes_Anom.put(objeto.EmailContacto, contacto);
                    }
                }
            }

            for (String key: mapResult_Contratantes_ST_Update.keyset()){
                objeto = mapResult_Contratantes_ST_Update.get(key);
                if (objeto.Contacto != null)
                {
                    objeto.Contacto.FirstName = objeto.NombreContacto;
                    objeto.Contacto.LastName = objeto.ApellidoContacto;
                    objeto.Contacto.Rut__c = objeto.RutContacto;
                    objeto.Contacto.Empresa_Corredora__c = null;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        objeto.Contacto.Empresa_Corredora__c = co.Id;
                    }
                    objeto.Contacto.Activo_Seguro_COVID__c = true;
                    objeto.Contacto.Fecha_Notificacion_Seguro_COVID__c = null;
                    objeto.Contacto.Notificacion_Seguro_COVID__c = false;
                    contacts_forUpdate.add(objeto.Contacto);
                }
            }

            Map<String, Contact> nuevosCorredores_Anom = new Map<String, Contact>();

            for (String key: mapResult_Corredores_ST_Insert.keyset()){
                objeto = mapResult_Corredores_ST_Insert.get(key);
                system.debug('@@@@ c objeto.RutEmpresa --> "'+objeto.RutEmpresa+'"');

                Account c = mapAccounts.get(objeto.RutEmpresa);
                system.debug('@@@@ c value --> '+c);
                if (c != null)
                {//si empresa encontrada
                    Contact contacto = new Contact();
                    contacto.FirstName = objeto.NombreContacto;
                    contacto.LastName = objeto.ApellidoContacto;
                    contacto.Email = objeto.EmailContacto;
                    contacto.Rut__c = objeto.RutContacto;
                    contacto.AccountId = c.Id;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        contacto.Empresa_Corredora__c = co.Id;
                    }
                    contacto.Es_Seguro_COVID__c = true;
                    contacto.Activo_Seguro_COVID__c = true;
                    contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                    contacts_forInsert.add(contacto);

                    if (mapResult_Corredores_Anonimos.containsKey(objeto.EmailContacto) == false && nuevosCorredores_Anom.containsKey(objeto.EmailContacto) == false)
                    {
                        c = mapAccounts.get('99999998-0');
                        contacto = new Contact();
                        contacto.FirstName = objeto.NombreContacto;
                        contacto.LastName = objeto.ApellidoContacto;
                        contacto.Email = objeto.EmailContacto;
                        contacto.Rut__c = objeto.RutContacto;
                        contacto.AccountId = c.Id;
                        contacto.Es_Seguro_COVID__c = true;
                        contacto.Activo_Seguro_COVID__c = false;
                        contacto.Es_Anonimo__c = true;
                        contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                        nuevosCorredores_Anom.put(objeto.EmailContacto, contacto);
                    }
                }
            }

            for (String key: mapResult_Corredores_ST_Update.keyset()){
                objeto = mapResult_Corredores_ST_Update.get(key);
                if (objeto.Contacto != null)
                {
                    objeto.Contacto.FirstName = objeto.NombreContacto;
                    objeto.Contacto.LastName = objeto.ApellidoContacto;
                    objeto.Contacto.Rut__c = objeto.RutContacto;
                    objeto.Contacto.Empresa_Corredora__c = null;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        objeto.Contacto.Empresa_Corredora__c = co.Id;
                    }
                    objeto.Contacto.Activo_Seguro_COVID__c = true;
                    objeto.Contacto.Fecha_Notificacion_Seguro_COVID__c = null;
                    objeto.Contacto.Notificacion_Seguro_COVID__c = false;
                    contacts_forUpdate.add(objeto.Contacto);
                }
            }


            Contact anomContact = null;

            for (String key: nuevosContratantes_Anom.keyset()){
                anomContact = nuevosContratantes_Anom.get(key);
                contacts_forInsert.add(anomContact);
            }

            for (String key: nuevosCorredores_Anom.keyset()){
                anomContact = nuevosCorredores_Anom.get(key);
                contacts_forInsert.add(anomContact);
            }

            system.debug('@@@@@ contacts_forUpdate '+contacts_forUpdate.size());
            system.debug('@@@@@ contacts_forInsert '+contacts_forInsert.size());

            update contacts_forUpdate;
            insert contacts_forInsert;
        }
        catch(Exception ex)
        {
            system.debug('@@@@@ EX '+ex);
            system.debug('@@@@@ EX line '+ex.getLineNumber());
        }
    }

    private static void actualizaContactos_Personal(Map<String, Account> mapAccounts, List<String> rutsAccounts, Map<String, Corredor__c> mapCorredoras, Map<String, OBJ_Contacto> mapResult_Contratantes, Map<String, OBJ_Contacto> mapResult_Corredores, List<String> emailsListContratantes, List<String> emailsListCorredores )
    {
        try
        {
            Account anomCol = [SELECT Id, Name, RUT__c, DV__c, RUT_con_DV__c FROM Account WHERE RUT__c = '99999994'];//99999994-8
            //desactiva todos los contactos contrantantes y corredores que han sido usado en el seguro covid segun rut de empresa
            List<Contact> list_Contratantes_Update = [SELECT Id, Activo_Seguro_COVID__c  FROM Contact WHERE AccountId =: anomCol.Id AND RecordTypeId =: Contact_RecordTypeId_Contratante AND RUT_Cuenta_Personal__c IN :  rutsAccounts AND Activo_Seguro_COVID__c = true];

            for (Contact c : list_Contratantes_Update)
            {
                c.Activo_Seguro_COVID__c = false;
            }

            update list_Contratantes_Update;

            system.debug('@@@@@ list_Contratantes_Update '+list_Contratantes_Update.size());


            List<Contact> list_Corredores_Update = [SELECT Id, Activo_Seguro_COVID__c FROM Contact WHERE AccountId =: anomCol.Id AND RecordTypeId =: Contact_RecordTypeId_Corredor AND RUT_Cuenta_Personal__c IN :  rutsAccounts AND Activo_Seguro_COVID__c = true];

            for (Contact c : list_Corredores_Update)
            {
                c.Activo_Seguro_COVID__c = false;
            }

            update list_Corredores_Update;

            system.debug('@@@@@ list_Corredores_Update '+list_Corredores_Update.size());


            List<Contact> list_Contratantes_Accounts = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c , Account.RUT_con_DV__c, RUT_Cuenta_Personal__c, Nombre_Cuenta_Personal__c, Id_Cuenta_Personal__c FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Contratante AND  AccountId =: anomCol.Id AND Email IN :  emailsListContratantes AND RUT_Cuenta_Personal__c IN :  rutsAccounts AND Es_Seguro_COVID__c = true];

            //obtiene todos los contactos contrantantes y corredores que han sido usado en el seguro covid segun el correo ingresado
            system.debug('@@@@@ list_Contratantes_Accounts '+list_Contratantes_Accounts.size());

            List<Contact> list_Corredores_Accounts = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c,  Account.RUT_con_DV__c, RUT_Cuenta_Personal__c, Nombre_Cuenta_Personal__c, Id_Cuenta_Personal__c  FROM Contact WHERE RecordTypeId =: Contact_RecordTypeId_Corredor  AND  AccountId =: anomCol.Id AND Email IN :  emailsListCorredores AND RUT_Cuenta_Personal__c IN :  rutsAccounts AND Es_Seguro_COVID__c = true];

            OBJ_Contacto objeto;

            system.debug('@@@@@ list_Corredores_Accounts '+list_Corredores_Accounts.size());

            for (Contact contacto: list_Contratantes_Accounts)
            {
                    String key = contacto.RUT_Cuenta_Personal__c +'#'+contacto.Email.toLowerCase();
                    system.debug('@@@@ 183. Key '+key);
                    objeto = mapResult_Contratantes.get(key);
                    if (objeto != null)
                    {
                        objeto.Contacto = contacto;
                        mapResult_Contratantes.put(objeto.Key, objeto);//dato csv con informacion de contacto asociada
                    }
            }

            for (Contact contacto: list_Corredores_Accounts)
            {
                String key = contacto.RUT_Cuenta_Personal__c+'#'+contacto.Email.toLowerCase();
                system.debug('@@@@ 196. Key '+key);
                objeto = mapResult_Corredores.get(key);
                if (objeto != null)
                {
                    objeto.Contacto = contacto;
                    mapResult_Corredores.put(objeto.Key, objeto);//dato csv con informacion de contacto asociada
                }
            }

            system.debug('@@@@@ mapResult_Contratantes '+mapResult_Contratantes.size());//contratantes existentes cargados para actualizar
            system.debug('@@@@@ mapResult_Corredores '+mapResult_Corredores.size());//corredores existentes cargados para actualizar

            Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Insert = new Map<String, OBJ_Contacto>();
            Map<String, OBJ_Contacto> mapResult_Corredores_ST_Insert= new Map<String, OBJ_Contacto>();

            Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Update = new Map<String, OBJ_Contacto>();
            Map<String, OBJ_Contacto> mapResult_Corredores_ST_Update = new Map<String, OBJ_Contacto>();

            for (String key: mapResult_Contratantes.keyset()){
                objeto = mapResult_Contratantes.get(key);
                if (objeto.Contacto == null)//dato cargado es nuevo
                {
                   mapResult_Contratantes_ST_Insert.put(objeto.key, objeto);
                }
                else//dato cargado existe
                {
                   mapResult_Contratantes_ST_Update.put(objeto.key, objeto);
                }
          }

          for (String key: mapResult_Corredores.keyset()){
               objeto = mapResult_Corredores.get(key);
               if (objeto.Contacto == null)//dato cargado es nuevo
               {
                   mapResult_Corredores_ST_Insert.put(objeto.key, objeto);
               }
               else//dato cargado existe
               {
                   mapResult_Corredores_ST_Update.put(objeto.key, objeto);
               }
           }

           system.debug('@@@@@ mapResult_Contratantes_ST_Insert '+mapResult_Contratantes_ST_Insert.size());//contratantes existentes cargados para actualizar  -- si correo no esta anonimo agregar
           system.debug('@@@@@ mapResult_Contratantes_ST_Update '+mapResult_Contratantes_ST_Update.size());//corredores existentes cargados para actualizar
           system.debug('@@@@@ mapResult_Corredores_ST_Insert '+mapResult_Corredores_ST_Insert.size());//contratantes existentes cargados para actualizar   -- si correo no esta anonimo agregar
           system.debug('@@@@@ mapResult_Corredores_ST_Update '+mapResult_Corredores_ST_Update.size());//corredores existentes cargados para actualizar

           Account tAnon = [SELECT Id, RUT__c, DV__c, RUT_con_DV__c FROM Account WHERE RUT_con_DV__c = '99999998-0'];

           List<Contact> list_Contratantes_Anomimos = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c , Account.RUT_con_DV__c FROM Contact WHERE AccountId =: tAnon.Id AND RecordTypeId =: Contact_RecordTypeId_Contratante AND Email IN :  emailsListContratantes AND Es_Seguro_COVID__c = true];

           List<Contact> list_Corredores_Anonimos = [SELECT Id, Email, FirstName, LastName, Rut__c, Empresa_Corredora__c, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, AccountId, Account.RUT__c, Account.DV__c,  Account.RUT_con_DV__c FROM Contact WHERE AccountId =: tAnon.Id AND RecordTypeId =: Contact_RecordTypeId_Corredor AND Email IN :  emailsListCorredores AND Es_Seguro_COVID__c = true];

           Map<String, Contact> mapResult_Contratantes_Anonimos = new Map<String, Contact>();

           for (Contact contact : list_Contratantes_Anomimos)
           {
               mapResult_Contratantes_Anonimos.put(contact.Email, contact);
           }

           Map<String, Contact> mapResult_Corredores_Anonimos = new Map<String, Contact>();

           for (Contact contact : list_Corredores_Anonimos)
           {
               mapResult_Corredores_Anonimos.put(contact.Email, contact);
           }

           List<Contact> contacts_forUpdate = new List<Contact>();
           List<Contact> contacts_forInsert = new List<Contact>();

           Map<String, Contact> nuevosContratantes_Anom = new Map<String, Contact>();

            for (String key: mapResult_Contratantes_ST_Insert.keyset())
            {
                objeto = mapResult_Contratantes_ST_Insert.get(key);
                system.debug('@@@@ c objeto.RutEmpresa --> "'+objeto.RutEmpresa+'"');
                Account c = mapAccounts.get(objeto.RutEmpresa);
                system.debug('@@@@ c value --> '+c);
                if (c != null)
                {//si empresa encontrada
                    Contact contacto = new Contact();
                    contacto.FirstName = objeto.NombreContacto;
                    contacto.LastName = objeto.ApellidoContacto;
                    contacto.Email = objeto.EmailContacto;
                    contacto.Rut__c = objeto.RutContacto;
                    contacto.AccountId = anomCol.Id;
                    contacto.Nombre_Cuenta_Personal__c = c.Name;
                    contacto.Id_Cuenta_Personal__c = c.Id;
                    contacto.RUT_Cuenta_Personal__c =  c.RUT_con_DV__c;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        contacto.Empresa_Corredora__c = co.Id;
                    }
                    contacto.Es_Seguro_COVID__c = true;
                    contacto.Activo_Seguro_COVID__c = true;
                    contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                    contacts_forInsert.add(contacto);

                    if (mapResult_Contratantes_Anonimos.containsKey(objeto.EmailContacto) == false && nuevosContratantes_Anom.containsKey(objeto.EmailContacto) == false)
                    {
                        c = tAnon;
                        contacto = new Contact();
                        contacto.FirstName = objeto.NombreContacto;
                        contacto.LastName = objeto.ApellidoContacto;
                        contacto.Email = objeto.EmailContacto;
                        contacto.Rut__c = objeto.RutContacto;
                        contacto.AccountId = c.Id;
                        contacto.Es_Seguro_COVID__c = true;
                        contacto.Activo_Seguro_COVID__c = false;
                        contacto.Es_Anonimo__c = true;
                        contacto.RecordTypeId = Contact_RecordTypeId_Contratante;
                        nuevosContratantes_Anom.put(objeto.EmailContacto, contacto);
                    }
                }
            }

            for (String key: mapResult_Contratantes_ST_Update.keyset()){
                objeto = mapResult_Contratantes_ST_Update.get(key);
                if (objeto.Contacto != null)
                {
                    objeto.Contacto.FirstName = objeto.NombreContacto;
                    objeto.Contacto.LastName = objeto.ApellidoContacto;
                    objeto.Contacto.Rut__c = objeto.RutContacto;
                    objeto.Contacto.Empresa_Corredora__c = null;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        objeto.Contacto.Empresa_Corredora__c = co.Id;
                    }
                    objeto.Contacto.Activo_Seguro_COVID__c = true;
                    objeto.Contacto.Fecha_Notificacion_Seguro_COVID__c = null;
                    objeto.Contacto.Notificacion_Seguro_COVID__c = false;
                    contacts_forUpdate.add(objeto.Contacto);
                }
            }

            Map<String, Contact> nuevosCorredores_Anom = new Map<String, Contact>();

            for (String key: mapResult_Corredores_ST_Insert.keyset()){
                objeto = mapResult_Corredores_ST_Insert.get(key);
                system.debug('@@@@ c objeto.RutEmpresa --> "'+objeto.RutEmpresa+'"');

                Account c = mapAccounts.get(objeto.RutEmpresa);
                system.debug('@@@@ c value --> '+c);
                if (c != null)
                {//si empresa encontrada
                    Contact contacto = new Contact();
                    contacto.FirstName = objeto.NombreContacto;
                    contacto.LastName = objeto.ApellidoContacto;
                    contacto.Email = objeto.EmailContacto;
                    contacto.Rut__c = objeto.RutContacto;
                    contacto.AccountId = anomCol.Id;
                    contacto.Nombre_Cuenta_Personal__c = c.Name;
                    contacto.RUT_Cuenta_Personal__c =  c.RUT_con_DV__c;
                    contacto.Id_Cuenta_Personal__c = c.Id;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        contacto.Empresa_Corredora__c = co.Id;
                    }
                    contacto.Es_Seguro_COVID__c = true;
                    contacto.Activo_Seguro_COVID__c = true;
                    contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                    contacts_forInsert.add(contacto);

                    if (mapResult_Corredores_Anonimos.containsKey(objeto.EmailContacto) == false && nuevosCorredores_Anom.containsKey(objeto.EmailContacto) == false)
                    {
                        c = tAnon;
                        contacto = new Contact();
                        contacto.FirstName = objeto.NombreContacto;
                        contacto.LastName = objeto.ApellidoContacto;
                        contacto.Email = objeto.EmailContacto;
                        contacto.Rut__c = objeto.RutContacto;
                        contacto.AccountId = c.Id;
                        contacto.Es_Seguro_COVID__c = true;
                        contacto.Activo_Seguro_COVID__c = false;
                        contacto.Es_Anonimo__c = true;
                        contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                        nuevosCorredores_Anom.put(objeto.EmailContacto, contacto);
                    }
                }
            }

            for (String key: mapResult_Corredores_ST_Update.keyset()){
                objeto = mapResult_Corredores_ST_Update.get(key);
                if (objeto.Contacto != null)
                {
                    objeto.Contacto.FirstName = objeto.NombreContacto;
                    objeto.Contacto.LastName = objeto.ApellidoContacto;
                    objeto.Contacto.Rut__c = objeto.RutContacto;
                    objeto.Contacto.Empresa_Corredora__c = null;
                    if (String.isNotBlank(objeto.RutEmpresaCorredora))
                    {
                        Corredor__c co = mapCorredoras.get(objeto.RutEmpresaCorredora.split('-')[0]);
                        objeto.Contacto.Empresa_Corredora__c = co.Id;
                    }
                    objeto.Contacto.Activo_Seguro_COVID__c = true;
                    objeto.Contacto.Fecha_Notificacion_Seguro_COVID__c = null;
                    objeto.Contacto.Notificacion_Seguro_COVID__c = false;
                    contacts_forUpdate.add(objeto.Contacto);
                }
            }

            Contact anomContact = null;

            for (String key: nuevosContratantes_Anom.keyset()){
                anomContact = nuevosContratantes_Anom.get(key);
                contacts_forInsert.add(anomContact);
            }

            for (String key: nuevosCorredores_Anom.keyset()){
                anomContact = nuevosCorredores_Anom.get(key);
                contacts_forInsert.add(anomContact);
            }

            system.debug('@@@@@ contacts_forUpdate '+contacts_forUpdate.size());
            system.debug('@@@@@ contacts_forInsert '+contacts_forInsert.size());

            update contacts_forUpdate;
            insert contacts_forInsert;

        }
        catch(Exception ex)
        {
            system.debug('@@@@@ EX '+ex);
            system.debug('@@@@@ EX line '+ex.getLineNumber());
        }
    }


    public static Boolean actualizaContactos(List<Wrapper_Contact> wContacts)
    {
        try
        {
            List<String> corredorasRUT = new  List<String>();
            List<String> empresasRUT = new  List<String>();

            for (Wrapper_Contact wContact : wContacts)
            {
                //eliminar duplicados
                empresasRUT.add(wContact.RutEmpresa);

                if (String.isNotBlank(wContact.RutEmpresaCorredora))
                {
                    corredorasRUT.add(wContact.RutEmpresaCorredora.split('-')[0]);//solo digito verificador
                }
                //eliminar duplicados
            }

            empresasRUT.add('99999998-0');
            system.debug('@@@@@ empresasRUT '+empresasRUT.size());
            system.debug('@@@@@ corredorasRUT '+corredorasRUT.size());

            //solo considera cuentas empresariales

            List<Account> listAccounts_Empresarial = [SELECT Id, Name, RUT__c, DV__c, RUT_con_DV__c FROM Account WHERE RUT_con_DV__c IN : empresasRUT AND RecordTypeId =: Account_RecordTypeId_Empresarial];

            system.debug('@@@@@ listAccounts_Empresarial '+listAccounts_Empresarial.size());

            List<String> idsAccounts_Empresarial = new List<String>();
            Map<String, Account> mapAccounts_Empresarial = new  Map<String, Account>();

            for (Account account : listAccounts_Empresarial)
            {
                idsAccounts_Empresarial.add(account.Id);
                mapAccounts_Empresarial.put(account.RUT_con_DV__c, account);
                system.debug('@@@@@ mapAccounts_Empresarial.add '+account.RUT_con_DV__c);
            }

            system.debug('@@@@@ mapAccounts_Empresarial '+mapAccounts_Empresarial.size());
            system.debug('@@@@@ idsAccounts_Empresarial '+idsAccounts_Empresarial.size());

            //solo considera cuentas personales
            List<Account> listAccounts_Personal = [SELECT Id, Name, RUT__c, DV__c, RUT_con_DV__c FROM Account WHERE RUT_con_DV__c IN : empresasRUT AND RecordTypeId =: Account_RecordTypeId_Personal];

            system.debug('@@@@@ listAccounts_Personal '+listAccounts_Personal.size());

            List<String> rutsAccounts_Personal = new List<String>();
            Map<String, Account> mapAccounts_Personal = new  Map<String, Account>();

            for (Account account : listAccounts_Personal)
            {
                rutsAccounts_Personal.add(account.RUT_con_DV__c);
                mapAccounts_Personal.put(account.RUT_con_DV__c, account);
                system.debug('@@@@@ mapAccounts_Personal.add '+account.RUT_con_DV__c);
            }

            system.debug('@@@@@ mapAccounts_Personal '+ mapAccounts_Personal.size());
            system.debug('@@@@@ rutsAccounts_Personal '+rutsAccounts_Personal.size());

            //empresas corredoras
            List<Corredor__c> listCorredoras = [SELECT Id, RUT__c, DV__c FROM Corredor__c WHERE RUT__c IN : corredorasRUT];

            Map<String, Corredor__c> mapCorredoras = new  Map<String, Corredor__c>();

            for (Corredor__c corredora : listCorredoras)
            {
                mapCorredoras.put(corredora.RUT__c, corredora);
            }

            system.debug('@@@@@ mapCorredoras '+mapCorredoras.size());

            Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Personal = new Map<String, OBJ_Contacto>();
            Map<String, OBJ_Contacto> mapResult_Corredores_ST_Personal = new Map<String, OBJ_Contacto>();

            Map<String, OBJ_Contacto> mapResult_Contratantes_ST_Empresarial = new Map<String, OBJ_Contacto>();
            Map<String, OBJ_Contacto> mapResult_Corredores_ST_Empresarial = new Map<String, OBJ_Contacto>();

            List<String> emailsListCorredores_Empresarial  = new List<String>();
            List<String> emailsListContratantes_Empresarial = new List<String>();

            List<String> emailsListCorredores_Personal  = new List<String>();
            List<String> emailsListContratantes_Personal = new List<String>();

            OBJ_Contacto objeto;

            for (Wrapper_Contact wContact : wContacts)
            {
                objeto = new OBJ_Contacto();
                objeto.Key = wContact.RutEmpresa+'#'+wContact.EmailContacto.toLowerCase();
                system.debug('@@@@ 74. objeto.Key  '+objeto.Key );
                //74. objeto.Key
                objeto.RutEmpresa = wContact.RutEmpresa;
                objeto.EmailContacto = wContact.EmailContacto;
                objeto.NombreContacto = wContact.NombreContacto;
                objeto.ApellidoContacto = wContact.ApellidoContacto;
                objeto.RutContacto = wContact.RutContacto;
                objeto.TipoContacto = wContact.TipoContacto;
                objeto.Contacto = null;
                objeto.RutEmpresaCorredora = wContact.RutEmpresaCorredora;

                if (wContact.TipoContacto == 'Contratante')
                {
                    if (mapAccounts_Empresarial.get(wContact.RutEmpresa) != null)
                    {
                        emailsListContratantes_Empresarial.add(wContact.EmailContacto.toLowerCase());
                        mapResult_Contratantes_ST_Empresarial.put(objeto.Key, objeto);
                    }
                    else  if (mapAccounts_Personal.get(wContact.RutEmpresa) != null)
                    {
                        emailsListContratantes_Personal.add(wContact.EmailContacto.toLowerCase());
                        mapResult_Contratantes_ST_Personal.put(objeto.Key, objeto);
                    }
                }
                else if (wContact.TipoContacto == 'Corredor')
                {
                    if (mapAccounts_Empresarial.get(wContact.RutEmpresa) != null)
                    {
                        emailsListCorredores_Empresarial.add(wContact.EmailContacto.toLowerCase());
                        mapResult_Corredores_ST_Empresarial.put(objeto.Key, objeto);
                    }
                    else  if (mapAccounts_Personal.get(wContact.RutEmpresa) != null)
                    {
                        emailsListCorredores_Personal.add(wContact.EmailContacto.toLowerCase());
                        mapResult_Corredores_ST_Personal.put(objeto.Key, objeto);
                    }
                }
            }

            system.debug('@@@@@ mapResult_Contratantes_ST_Empresarial '+mapResult_Contratantes_ST_Empresarial.size());
            system.debug('@@@@@ mapResult_Corredores_ST_Empresarial '+mapResult_Corredores_ST_Empresarial.size());
            system.debug('@@@@@ mapResult_Contratantes_ST_Personal '+mapResult_Contratantes_ST_Personal.size());
            system.debug('@@@@@ mapResult_Corredores_ST_Personal '+mapResult_Corredores_ST_Personal.size());


            system.debug('@@@@@ emailsListCorredores_Empresarial '+emailsListCorredores_Empresarial.size());
            system.debug('@@@@@ emailsListContratantes_Empresarial '+emailsListContratantes_Empresarial.size());
            system.debug('@@@@@ emailsListCorredores_Personal '+emailsListCorredores_Personal.size());
            system.debug('@@@@@ mapResult_Contratantes_ST_Personal '+mapResult_Contratantes_ST_Personal.size());

           if (idsAccounts_Empresarial.size() > 0)
           {
                actualizaContactos_Empresarial(mapAccounts_Empresarial, idsAccounts_Empresarial, mapCorredoras, mapResult_Contratantes_ST_Empresarial,  mapResult_Corredores_ST_Empresarial, emailsListContratantes_Empresarial, emailsListCorredores_Empresarial);
           }


           if (rutsAccounts_Personal.size() > 0)
           {
            actualizaContactos_Personal(mapAccounts_Personal, rutsAccounts_Personal, mapCorredoras, mapResult_Contratantes_ST_Personal,  mapResult_Corredores_ST_Personal, emailsListContratantes_Personal, emailsListCorredores_Personal);
           }

           return true;

        }
        catch(Exception ex)
        {
            system.debug('@@@@@ EX '+ex);
            system.debug('@@@@@ EX line '+ex.getLineNumber());

            return false;
        }
    }

    public static Map<String, Account> retornaCuentasEnvioCorreo(List<String> empresasRUT)
    {
        system.debug('@@@@ empresasRUT.size() '+empresasRUT.size());

        List<Account> cuentasList = [SELECT Id,  Name,  RUT__c, DV__c, RUT_con_DV__c, RecordTypeId FROM Account WHERE RUT_con_DV__c IN : empresasRUT];// AND  RecordTypeId =: Account_RecordTypeId_Empresarial];//(RecordTypeId =: Account_RecordTypeId_Empresarial OR RecordTypeId =: Account_RecordTypeId_Personal)];

        system.debug('@@@@ cuentasList.size() '+cuentasList.size());

        Map<String, Account> cuentasMap = new Map<String, Account> ();

        for (Account cuenta : cuentasList)
        {
            cuentasMap.put(cuenta.RUT_con_DV__c, cuenta);
        }

        system.debug('@@@@ cuentasMap.size() '+cuentasMap.size());

        return cuentasMap;
    }


    public static Integer ejecutaEnvioMasivo(List<Wrapper_Empresa> wEmpresas)
    {
        try
        {
            List<String> RUTs_cuentas = new List<String>();

            for (Wrapper_Empresa cuenta: wEmpresas)
            {
                RUTs_cuentas.add(cuenta.RutEmpresa.trim());
            }

            List<Account> cuentas_empresariales =   [SELECT Id FROM Account WHERE RUT_con_DV__c IN : RUTs_cuentas AND  RecordTypeId =: Account_RecordTypeId_Empresarial];

            List<Account> cuentas_personales =   [SELECT Id, RUT_con_DV__c FROM Account WHERE RUT_con_DV__c IN : RUTs_cuentas AND  RecordTypeId =: Account_RecordTypeId_Personal];

            List<String> ids_cuentas_empresariales = new List<String>();

            for (Account cuenta: cuentas_empresariales)
            {
                ids_cuentas_empresariales.add(cuenta.Id);
            }

            List<String> ruts_cuentas_personales = new List<String>();

            for (Account cuenta: cuentas_personales)
            {
                ruts_cuentas_personales.add(cuenta.RUT_con_DV__c);
            }

            List<Contact> contactForSendMail_Empresariales = [SELECT Id, Email, Name, Rut__c, AccountId, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, Account.Name, Account.RUT_con_DV__c,RUT_Cuenta_Personal__c, Nombre_Cuenta_Personal__c, Id_Cuenta_Personal__c FROM Contact WHERE AccountId IN: ids_cuentas_empresariales AND Es_Seguro_COVID__c = true AND Activo_Seguro_COVID__c = true AND Notificacion_Seguro_COVID__c = false];

            Account anomCol = [SELECT Id, Name, RUT__c, DV__c, RUT_con_DV__c FROM Account WHERE RUT__c = '99999994'];//99999994-8
            //desactiva todos los contactos contrantantes y corredores que han sido usado en el seguro covid segun rut de empresa

            List<Contact> contactForSendMail_Personales = [SELECT Id, Email, Name, Rut__c, AccountId, Es_Seguro_COVID__c, Activo_Seguro_COVID__c, Fecha_Notificacion_Seguro_COVID__c, Notificacion_Seguro_COVID__c, Account.Name, Account.RUT_con_DV__c, RUT_Cuenta_Personal__c, Nombre_Cuenta_Personal__c, Id_Cuenta_Personal__c FROM Contact WHERE AccountId =: anomCol.Id AND RUT_Cuenta_Personal__c IN: ruts_cuentas_personales AND Es_Seguro_COVID__c = true AND Activo_Seguro_COVID__c = true AND Notificacion_Seguro_COVID__c = false];

            List<Contact> contactos_for_Mail = new List<Contact>();
            contactos_for_Mail.addAll(contactForSendMail_Empresariales);
            contactos_for_Mail.addAll(contactForSendMail_Personales);

            return sendMails(contactos_for_Mail);

        }
        catch(Exception ex)
        {
            system.debug('@@@@@ EX '+ex);
            system.debug('@@@@@ EX line '+ex.getLineNumber());

            return 0;
        }
    }


    private static Integer sendMails(List<Contact> contactForSendMail)
    {
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'seguroscovid@security.cl'];

        String IdEmail = '';

        if (owea.size() > 0 )
        {
            IdEmail = owea.get(0).Id;
        }

        //TriggerHandler.disable();

        List<Document> documents = [SELECT id, name, body, contenttype, developername, type FROM Document WHERE folder.developername = 'Comunicado_Seguro_COVID'];

        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Comunicado_Seguro_COVID' LIMIT 1];
        Messaging.SingleEmailMessage message = null;


        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();

        for(Document doc : documents){
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType(doc.contentType);
            attach.setFileName(doc.developerName+'.'+doc.type);
            attach.setInline(false);
            attach.Body = doc.Body;
            attachments.add(attach);
        }


        String[] bbcAddresses = new String[]{};  //tmp
        bbcAddresses.add('javier.burgos@security.cl');

        Contact[] result = new Contact[]{};

        for (Contact contacto: contactForSendMail)
        {
            message = new Messaging.SingleEmailMessage();

            message.setOrgWideEmailAddressId(IdEmail);//origen
            message.setTargetObjectId(contacto.Id);

            if (String.isNotBlank(contacto.Id_Cuenta_Personal__c))
            {
                message.setWhatId(contacto.Id_Cuenta_Personal__c);
            } else
            {
                message.setWhatId(contacto.AccountId);
            }

            message.setTemplateId(template.Id);
            message.setSaveAsActivity(true);
            message.setBccAddresses(bbcAddresses);
            message.setFileAttachments(attachments);
            messages.add(message);
            result.add(contacto);
        }

        Messaging.reserveSingleEmailCapacity(messages.size());

        Messaging.SendEmailResult[] emailResults =  Messaging.sendEmail(messages, false);

        Integer successesEmail = 0;

        Integer cont = 0;
        for (Messaging.SendEmailResult emailResult : emailResults) {
            Boolean exito = emailResult.isSuccess();
            system.debug('@@@@ emailResult '+emailResult);

            if (exito) {
                result[cont].Notificacion_Seguro_COVID__c = true;
                result[cont].Fecha_Notificacion_Seguro_COVID__c = Datetime.Now();
                successesEmail++;
            }
            else {
                result[cont].Notificacion_Seguro_COVID__c = false;
                result[cont].Fecha_Notificacion_Seguro_COVID__c = Datetime.Now();//guarda intento
            }

            cont++;
        }

        Database.update(result, false);
        //   TriggerHandler.enable();
        return successesEmail;
    }
}