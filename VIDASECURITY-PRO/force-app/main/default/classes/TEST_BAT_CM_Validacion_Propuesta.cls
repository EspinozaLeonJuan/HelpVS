/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-15-2021
 * @last modified by  : Juan Espinoza León
**/
@isTest 
public class TEST_BAT_CM_Validacion_Propuesta {
    public TEST_BAT_CM_Validacion_Propuesta() {

    }


    @isTest static void Execute(){

        String Opportunity_RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Oncológico').getRecordTypeId();

        Opportunity o = new Opportunity();
        o.RecordTypeId = Opportunity_RecordTypeId;
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
        o.OPOR_ID_Campa_a_SF__c = '01';
        
        o.StageName = 'Venta - Aprobada';                
        o.CloseDate = Date.today();			
        o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c; 
        
        //Asociando datos forma de pago
        o.OPOR_Codigo_Banco__c = null;
        o.OPOR_Codigo_Tarjeta__c = null;
        o.OPOR_N_Cuenta__c = null;
        o.OPOR_Id_Poliza_Asociada__c = '500000';
        o.OPOR_Tipo_Forma_Pago__c = 'P';
        o.OPOR_Fecha_Vencimiento__c = Date.today();
        o.StageName = 'Venta - Aprobada';
        o.OPOR_WS_Actualiza_Datos_Prospecto__c = true;
        
        Insert o;
        
        Persona__c per = new Persona__c();
        per.Name = 'J';
        per.PERSO_Apellido_Paterno__c = 'E';
        per.PERSO_Apellido_Materno__c = 'L';
        per.PERSO_Rut__c = 2;
        per.PERSO_Dv__c = '7';
        per.PERSO_Fecha_de_Nacimiento__c = date.today();
        per.PERSO_ID_SF_Propuesta__c = o.Id;
        per.PERSO_N_Propuesta__c = o.OPOR_N_Propuesta__c;
        per.PERSO_Mail__c = 'jel@ibm.com';
        per.PERSO_Telefono_Fijo__c = '56227896655';
        per.PERSO_Telefono_Movil__c = '56227896655';
        per.PERSO_ID_Persona_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(per.PERSO_Rut__c) + '-' + o.Id;
        per.PERSO_Codigo_Region__c = '014';
        per.PERSO_Codigo_Ciudad__c = '511';
        per.PERSO_Codigo_Comuna__c = '511';
        
        Insert per;
        
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
        
        Contratante__c con = new Contratante__c();
        con.Name = 'J E L';
        con.CONTRA_Apellido_Paterno__c = 'E';
        con.CONTRA_Apellido_Materno__c = 'L';
        con.CONTRA_Rut__c = 2;
        con.CONTRA_Dv__c = '7';
        con.CONTRA_Direccion__c = 'Augusto Leguia 70';
        con.CONTRA_Fecha_de_Nacimiento__c = date.today();
        con.CONTRA_Email_1__c = 'jel@ibm.com';
        con.CONTRA_Email_2__c = 'jel@ibm.com';
        con.CONTRA_Telefono_1__c = '56227896655';
        con.CONTRA_Telefono_2__c = '56227896655';
        con.CONTRA_Tipo_Folio__c = 19;
        con.CONTRA_ID_Contratante_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + con.CONTRA_Dv__c + '-' + o.Id;
        con.CONTRA_Propuesta__c = o.Id;
        con.CONTRA_Persona__c = per.Id;
        con.CONTRA_Codigo_Region__c = '014';
        con.CONTRA_Codigo_Ciudad__c = '511';
        con.CONTRA_Codigo_Comuna__c = '511';            
        
        Insert con;
        
        Test.startTest();

        BAT_CM_Validacion_Propuesta j_MConco = new BAT_CM_Validacion_Propuesta(o.Id);     
        //BAT_TV_GestionCargaCampagna j_MConco = new BAT_TV_GestionCargaCampagna(this.Carga.Campagna__c);     
        Id IdJobs = Database.executeBatch(j_MConco, 1); 
        System.debug('@@@@ IdJobs => ' + IdJobs);

        test.stopTest();
    }
}