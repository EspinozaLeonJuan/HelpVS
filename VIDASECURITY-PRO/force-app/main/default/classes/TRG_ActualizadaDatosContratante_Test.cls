/*******************************************************************************************
 *  NOMBRE                 : TRG_ActualizadaDatosContratante_Test
 *  TIPO                   : APEX CLASS TEST
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/12/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@isTest
private class TRG_ActualizadaDatosContratante_Test {

    static testMethod void escenarioCambiaDatosContacto_A(){
        
        Test.startTest();
        
        Opportunity o = new Opportunity();
        String IdTipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Venta - Oncológico'].Id;
        
        o.RecordTypeId = IdTipoRegistro;
        o.Type = 'Propuesta';
        o.OPOR_N_Propuesta__c = '9999999';
        o.OPOR_Tipo_Folio__c = '19';
        o.OPOR_Codigo_Ramo__c = '7300';
        o.OPOR_Codigo_Plan__c = '001';
        o.OPOR_Codigo_Producto__c = 'MD01';
        o.OPOR_Revision_Plan__c = '001';
        o.OPOR_Codigo_Moneda__c = 'UF';
        o.OPOR_Porcentaje_Riesgo__c = 0;
        o.OPOR_Usuario__c = '12';
        o.LeadSource = 'TEST';
        o.OPOR_Codigo_Sucursal__c = '000016';
        o.OPOR_Codigo_Canal__c = '20';
        o.OPOR_Estado_Propuesta__c = 'ING';
        o.Codigo_Periodo_Pago__c = 'M';
        
        o.StageName = 'Venta - Pendiente Validar';                
        o.CloseDate = Date.today();         
        o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c; 
        
        //Asociando datos forma de pago
        o.OPOR_Codigo_Banco__c = null;
        o.OPOR_Codigo_Tarjeta__c = null;
        o.OPOR_N_Cuenta__c = null;
        o.OPOR_Id_Poliza_Asociada__c = '500000';
        o.OPOR_Tipo_Forma_Pago__c = 'P';
        o.OPOR_Fecha_Vencimiento__c = Date.today();
        o.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
        
        Insert o;
        
        Persona__c per = new Persona__c();
        per.Name = 'Héctor';
        per.PERSO_Apellido_Paterno__c = 'Norammbuena';
        per.PERSO_Apellido_Materno__c = 'Orellana';
        per.PERSO_Rut__c = 10355641;
        per.PERSO_Dv__c = '4';
        per.PERSO_Fecha_de_Nacimiento__c = date.today();
        per.PERSO_ID_SF_Propuesta__c = o.Id;
        per.PERSO_N_Propuesta__c = o.OPOR_N_Propuesta__c;
        per.PERSO_Mail__c = 'hno@no.cl';
        per.PERSO_Telefono_Fijo__c = '56227896655';
        per.PERSO_Telefono_Movil__c = '56227896655';
        per.PERSO_ID_Persona_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(per.PERSO_Rut__c) + '-' + o.Id;
        per.PERSO_Codigo_Region__c = '014';
        per.PERSO_Codigo_Ciudad__c = '511';
        per.PERSO_Codigo_Comuna__c = '511';
        
        Insert per;
        system.debug('@@@@ PERSONA CREADA => ' + per);
        
        Asegurado__c ase = new Asegurado__c();
        ase.ASEG_Persona__c = per.Id;
        ase.Name = per.Name + ' ' + per.PERSO_Apellido_Paterno__c + ' ' + per.PERSO_Apellido_Materno__c;
        ase.ASEG_Dv__c = per.PERSO_Dv__c;
        ase.ASEG_Telefono_1__c = per.PERSO_Telefono_Fijo__c;
        ase.ASEG_Telefono_2__c = per.PERSO_Telefono_Movil__c;
        ase.ASEG_Email_1__c = per.PERSO_Mail__c;
        ase.ASEG_Email_2__c = per.PERSO_Mail__c;
        ase.ASEG_Fecha_de_Nacimiento__c = per.PERSO_Fecha_de_Nacimiento__c;
        ase.ASEG_Apellido_Paterno__c = per.PERSO_Apellido_Paterno__c;
        ase.ASEG_Apellido_Materno__c = per.PERSO_Apellido_Materno__c;
        ase.ASEG_Codigo_Ciudad__c = per.PERSO_Codigo_Ciudad__c;
        ase.ASEG_Codigo_Comuna__c = per.PERSO_Codigo_Comuna__c;
        ase.ASEG_Codigo_Region__c = per.PERSO_Codigo_Region__c;
        ase.ASEG_Direccion__c = per.PERSO_Direccion__c;
        ase.ASEG_Propuesta__c = o.Id;
        ase.ASEG_Rut__c = per.PERSO_Rut__c;
        ase.ASEG_Codigo_Relacion__c = '0002';
        ase.ASEG_Tipo_de_Folio__c = '19';
        ase.ASEG_ID_Asegurado_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(per.PERSO_Rut__c) + '-' + o.Id; 
        ase.ASEG_Codigo_Region__c = '014';
        ase.ASEG_Codigo_Ciudad__c = '511';
        ase.ASEG_Codigo_Comuna__c = '511';         
        
        Insert ase;
        system.debug('@@@@ ASEGURADO CREADO => ' + ase);
        
        Cobertura2__c cob = new Cobertura2__c();
        cob.COB_Asegurado__c = ase.Id;
        cob.COB_Dv__c = ase.ASEG_Dv__c;
        cob.COB_Propuesta__c = o.Id;
        cob.COB_Tipo_de_Folio__c = '19';
        cob.COB_Rut__c = ase.ASEG_Rut__c;
        cob.COB_Codigo_Cobertura__c = 'CSON';
        cob.Name = 'CSON';
        cob.COB_Tasa_Cambio__c = 0;
        cob.COB_Tasa_Prima__c = 0;
        cob.COB_Capital_Asegurado__c = 0;
        cob.COB_Prima_Neta__c = 0;
        cob.COB_Impuestos__c = 0;
        cob.COB_Prima_Neta_Local__c = 0;
        cob.COB_Impuestos_Local__c = 0;
        cob.COB_ID_Cobertura_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + ase.ASEG_Rut__c + '- CSON -' + o.Id;    
        
        Insert cob;
        system.debug('@@@@ COBERTURA CREADA => ' + cob);
        
        Beneficiario2__c ben = new Beneficiario2__c();
        ben.BEN_Persona__c = per.Id;
        ben.Name = 'Hector Norambuena Orellana';
        ben.BEN_Dv__c = '4';
        ben.BEN_Fecha_de_Nacimiento__c = date.today();
        ben.BEN_Apellido_Paterno__c = 'Norambuena';
        ben.BEN_Apellido_Materno__c = 'Orellana';
        ben.BEN_Email_1__c = 'hno@no.cl';
        ben.BEN_Email_2__c = 'hno@no.cl';
        ben.BEN_Tel_fono_1__c = '56227896655';
        ben.BEN_Tel_fono_2__c = '56227896655';
        ben.BEN_C_digo_Regi_n__c = '014';
        ben.BEN_C_digo_Ciudad__c = '511';
        ben.BEN_C_digo_Comuna__c = '511'; 
        ben.BEN_Propuesta__c = o.Id;
        ben.BEN_Rut__c = 10355641;
        ben.BEN_Codigo_Relacion__c = '0002';
        ben.BEN_Tipo_de_Folio__c = '19';
        ben.BEN_Participacion__c = 0.5;
        ben.BEN_ID_Beneficiario_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(ben.BEN_Rut__c) + '-' + o.Id;        
        
        Insert ben;
        system.debug('@@@@ BENEFICIARIO CREADO => ' + ben);
        
        Contratante__c con = new Contratante__c();
        con.Name = 'Hector Norambuena Orellana';
        con.CONTRA_Apellido_Paterno__c = 'Norambuena';
        con.CONTRA_Apellido_Materno__c = 'Orellana';
        con.CONTRA_Rut__c = 10355641;
        con.CONTRA_Dv__c = '4';
        con.CONTRA_Direccion__c = 'Augusto Leguia 70';
        con.CONTRA_Fecha_de_Nacimiento__c = date.today();
        con.CONTRA_Email_1__c = 'hno@no.cl';
        con.CONTRA_Email_2__c = 'hno@no.cl';
        con.CONTRA_Telefono_1__c = '56227896655';
        con.CONTRA_Telefono_2__c = '56227896655';
        con.CONTRA_Tipo_Folio__c = 19;
        con.CONTRA_ID_Contratante_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(con.CONTRA_Rut__c) + '-' + o.Id;
        con.CONTRA_Propuesta__c = o.Id;
        con.CONTRA_Persona__c = per.Id;
        con.CONTRA_Codigo_Region__c = '014';
        con.CONTRA_Codigo_Ciudad__c = '511';
        con.CONTRA_Codigo_Comuna__c = '511';

		Insert con;
        system.debug('@@@@ CONTRATANTE CREADO => ' + con);

		con.CONTRA_Telefono_1__c = '56227896654';
		con.CONTRA_Telefono_2__c = '56227856655';
		con.CONTRA_Email_1__c = 'hno1@hno.cl';

		Update con;        
        
        Test.stopTest();
        
    }
    
}