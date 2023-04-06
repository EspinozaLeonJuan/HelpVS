public class FactoryEscritorio {  
    static string rutCuenta = '88888888';
    static string dvCuenta = '8';
    static string mailCuenta = 'mail@cuenta.cl';
    
     public static Case buildCaso(String recordTypeName, Account cuenta) {
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
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }

	public static Case buildCaso_sinDetalle(String recordTypeName, Account cuenta) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente';
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = '';
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }
    
    public static Case buildCaso_Detalle_ED(String recordTypeName, Account cuenta) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente';
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Solicitud Cuota Murtoria';
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }
    
    public static Case buildCasoED(String recordTypeName, Account cuenta) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente';
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Detalle de Solicitud';
        //caso.Id_Requerimiento_EscritorioDigital__c = '69';
        //
        //List<Case> casos =  [SELECT Id FROM Case LIMIT 1];
        caso.Id = '5000H00000x7H2W';//casos[0].Id;
        caso.ParentId = '5000H00000x7H2W';
            
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }
    
    public static Case buildCasoED2(String recordTypeName, Account cuenta) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente';
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Solicitud Cuota Mortuoria';
        caso.Id_Requerimiento_EscritorioDigital__c = '69';
        //
        //List<Case> casos =  [SELECT Id FROM Case LIMIT 1];
        caso.Id = '5000H00000x7H2W';//casos[0].Id;
            
            
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }
    public static List<Usuario_Backup__c> buildUsuariosBackup()
    {
        List<Usuario_backup__c> users =  [SELECT Id, Name FROM Usuario_backup__c];
        
        // List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
                
        /*if (lrecords.size() > 0)
        {*/
        //Usuario_Backup__c usuario = users[0];
        return users;        
    }
    
    public static Usuario_Backup__c buildUsuarioBackup()
    {
        List<Usuario_backup__c> users =  [SELECT Id, Name FROM Usuario_backup__c LIMIT 10];
        
        // List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
                

        //Usuario_Backup__c usuario = users[0];
        return users[0];        
    }
    

    public static Case buildCaso_sinCuenta(String recordTypeName) {
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente';
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = '';      	
        caso.Origin = 'Contacto Vida';
        caso.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        return caso;
    }

    
     public static Solicitud__c buildSolicitud(Case caso){
        Solicitud__c solicitud = new Solicitud__c();
        solicitud.Codigo_Solicitud__c = 'SOL001';
        solicitud.Detalle_Solicitud__c = 'Detalle de Solicitud';
        solicitud.EstadoRequerimiento__c = 'NUEVO';
        solicitud.IdRequerimiento__c = 690;
        solicitud.Name = 'Solicitud';
        solicitud.Nombre_Titular__c = 'Nombre';
        solicitud.RUT_Titular__c = '88888888-8';
        solicitud.Solicitante__c = 'Solicitante';
        solicitud.TipoRequerimiento__c = 'Tipo';
        Solicitud.Caso__c = caso.Id;
        return solicitud;       
    }
    
   /* public static List<Case> CasosHijo()
    {
        List<Case> lista =  [SELECT Id From Case where ParentId =:'500i000000w62WX'];
        return lista;
    }*/
    
     public static List<Case> CasosHijoSolicitudes()
    {
        List<Case> lista =  new List<Case>();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso1 = buildCasoED('Solicitudes',cuenta);
        lista.add(caso1);
        Case caso2 = buildCasoED('Solicitudes',cuenta);
        lista.add(caso2);
        return lista;
    }
    
    public static List<Case> CasosHijoConsultas()
    {
        List<Case> lista =  new List<Case>();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso1 = buildCasoED('Consultas',cuenta);
        lista.add(caso1);
        Case caso2 = buildCasoED('Consultas',cuenta);
        lista.add(caso2);
        return lista;
    }
    
    public static List<Case> CasosHijoReclamos()
    {
        List<Case> lista =  new List<Case>();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso1 = buildCasoED('Reclamos',cuenta);
        lista.add(caso1);
        Case caso2 = buildCasoED('Reclamos',cuenta);
        lista.add(caso2);
        return lista;
    }
    
    /*
this.Solicitud.Name = 'ED-'+ IdRequerimiento;
        this.Solicitud.Detalle_Solicitud__c =  Escritorio.getSolicitud(this.CodigoSolicitud);
        this.Solicitud.TipoRequerimiento__c =  this.TipoRequerimiento;
        this.Solicitud.EstadoRequerimiento__c = 'NUEVO';
        this.Solicitud.IdRequerimiento__c = IdRequerimiento;
        this.Solicitud.Solicitante__c = Escritorio.getSolicitante(this.TipoRequerimiento);
        this.Solicitud.Codigo_Solicitud__c = this.CodigoSolicitud;
*/
    
     /*public static Solicitud__c buildSolicitud(){
        Solicitud__c solicitud = new Solicitud__c();
        solicitud.Codigo_Solicitud__c = 'SOL001';
        solicitud.Detalle_Solicitud__c = 'Detalle de Solicitud';
        solicitud.EstadoRequerimiento__c = 'NUEVO';
        solicitud.IdRequerimiento__c = 690;
        solicitud.Name = 'Solicitud';
        solicitud.Nombre_Titular__c = 'Nombre';
        solicitud.RUT_Titular__c = '88888888-8';
        solicitud.Solicitante__c = 'Solicitante';
        solicitud.TipoRequerimiento__c = 'Tipo';
        return solicitud;       
    }*/
}