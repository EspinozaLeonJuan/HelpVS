/*******************************************************************************************
 *  NOMBRE                 : CLS_OncologicoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/07/2018 - G.PINTO          - Creación Clase
 * 
 * *****************************************************************************************/
@istest 
public class TRG_ModificarPropuestaTest {

    private static Opportunity createData()
    {
        String RecordTypeId_Campaign  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Salud Protegida').getRecordTypeId();

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
        cmp.RecordTypeId = RecordTypeId_Campaign;
        cmp.IsActive = true;
        cmp.Status = 'En curso';
        cmp.EndDate = Date.today().addDays(-1);
        cmp.Type = 'Salud Protegida';
        insert cmp;
        
        String RecordTypeId_Lead  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();
        
        Lead lead = new Lead(); 
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '9';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'A';
        lead.LastName = 'B';	
        lead.Sub_Estado__c = 'Llamar Contratante';
        lead.RecordTypeId = RecordTypeId_Lead;
        insert lead;
                
        List<CampaignMember> testCampMemb1 = new List<CampaignMember>();
        testCampMemb1.add(new CampaignMember(LeadId =lead.Id , CampaignId = cmp.Id, Status = 'Sent', MCAMP_Carga_RUT__c = '10355641' ));
        insert testCampMemb1;
        
        Opportunity o = new Opportunity();
        String IdTipoRegistro = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Oncológico').getRecordTypeId(); 
            
        o.RecordTypeId = IdTipoRegistro;
        o.Type = 'Propuesta';
        o.OPOR_N_Propuesta__c = '12099303';
        o.OPOR_Tipo_Folio__c = '1';
        o.OPOR_Codigo_Ramo__c = '1';
        o.OPOR_Codigo_Plan__c = '1';
        o.OPOR_Codigo_Producto__c = '2';
        o.OPOR_Revision_Plan__c = '55';
        o.OPOR_Codigo_Moneda__c = '12';
        o.OPOR_Porcentaje_Riesgo__c = 0;
        o.OPOR_Usuario__c = 'cespinoza';
        o.LeadSource = '1';
        o.OPOR_Codigo_Sucursal__c = 'SANTIAGO';
        o.OPOR_Codigo_Canal__c = '12';
        o.OPOR_Estado_Propuesta__c = 'Abierto';
        o.Codigo_Periodo_Pago__c = ''; //Corregir Nombre API Campo
        o.OPOR_ID_Campa_a_SF__c = cmp.Id;
        o.CampaignId = cmp.Id;
            
        o.StageName = 'Venta - Pendiente Validar';                
        o.CloseDate = Date.today();
        //o.AccountId = [SELECT Id FROM Account WHERE Rut__c =: pro.RutContratante].Id;				
        o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c;
        
        insert o;  
        
        Persona__c per = new Persona__c();
        per.Name = 'H';
        per.PERSO_Apellido_Paterno__c = 'N';
        per.PERSO_Apellido_Materno__c = 'O';
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
        con.Name = 'H N O';
        con.CONTRA_Apellido_Paterno__c = 'N';
        con.CONTRA_Apellido_Materno__c = 'O';
        con.CONTRA_Rut__c = 10355641;
        con.CONTRA_Dv__c = '4';
        con.CONTRA_Direccion__c = 'Augusto Leguia 70';
        con.CONTRA_Fecha_de_Nacimiento__c = date.today();
        con.CONTRA_Email_1__c = 'hno@no.cl';
        con.CONTRA_Email_2__c = 'hno@no.cl';
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

        return o;
    }
    
     static testMethod void TGR_ModificarPropuesta_rechazada(){
        Opportunity o = createData();

        Test.startTest();
	    
        o.OPOR_Motivo_de_Rechazo_o_Perdida__c = 'Entrega información errónea';
        o.StageName = 'Venta - Rechaza Calidad';  
        update o;
 
        Test.stopTest();  
    }
    
    static testMethod void TGR_ModificarPropuesta_aprobada(){
        Opportunity o = createData();

        Test.startTest();
        
        o.StageName = 'Venta - Aprobada'; 
        update o;

        Test.stopTest();  
    }
    
    static testMethod void TGR_ModificarPropuesta_eliminar(){
        Opportunity o = createData();

        Test.startTest();
        
        delete o;

        Test.stopTest();  
    }
}