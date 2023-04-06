/*******************************************************************************************
 *  NOMBRE                 : CLS_WSprodoncoOperTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 11/07/2018 - CARLOS ESPINOZA     		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_LlamadaWSoncoTest {
    
    static testMethod void LlamadaWSonco_DatosCorrectos(){
        try{
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
            //Test.setMock(WebServiceMock.class, new CLS_WSprodoncoEquifaxMockImpl());
            
            string usuario = 'cespinoza';
            String rutPersona = '102992202';
            //String IdMC = '00v3D000002QWvqQAG';
            String IdMC = '00vi0000001hwlkAAA';           
            String region = '013';
            
            
            String RecordTypeId =[select id from RecordType where name='Venta - Oncológico' limit 1].Id;
            String nPropuesta = [select OPOR_N_Propuesta__c from Opportunity where recordTypeId=:RecordTypeId order by OPOR_Fecha_Vencimiento__c desc limit 1].OPOR_N_Propuesta__c;    
            
            Campaign cam = new Campaign();
            cam.Name = 'CAMPAÑA ONCO TEST';
            cam.Status = 'En curso';
            cam.IsActive = true;
            cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
            cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            cam.StartDate = Date.today();
            cam.EndDate = Date.today() + 5;
            cam.Type = 'Televenta - Oncológico';
            cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            cam.CAMPA_Script_Televenta__c = 'Hola!!';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            
            Insert mc;
            
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
            con.CONTRA_ID_Contratante_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + con.CONTRA_Dv__c + '-' + o.Id;
            con.CONTRA_Propuesta__c = o.Id;
            con.CONTRA_Persona__c = per.Id;
            con.CONTRA_Codigo_Region__c = '014';
            con.CONTRA_Codigo_Ciudad__c = '511';
            con.CONTRA_Codigo_Comuna__c = '511';            
            
            Insert con;
            
            rutPersona = '10355641-4';
            
            CLS_LlamadaWSonco.consultarDatosEquifaxOnco(usuario, rutPersona, mc.Id);            
            CLS_LlamadaWSonco.actualizarPropuestaOnco( usuario, o.Id );
            
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }
    
    static testMethod void LlamadaWSonco_DatosIncorrectos(){
        try{
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
            //Test.setMock(WebServiceMock.class, new CLS_WSprodoncoEquifaxMockImpl());
            
            string usuario = 'cespinoza';
            String rutPersona = '102992202';
            //String IdMC = '00v3D000002QWvqQAG';
            String IdMC = '00vi0000001hwlkAAA';           
            String region = '013';
            
            
            String RecordTypeId =[select id from RecordType where name='Venta - Oncológico' limit 1].Id;
            String nPropuesta = [select OPOR_N_Propuesta__c from Opportunity where recordTypeId=:RecordTypeId order by OPOR_Fecha_Vencimiento__c desc limit 1].OPOR_N_Propuesta__c;    
            
            Campaign cam = new Campaign();
            cam.Name = 'CAMPAÑA ONCO TEST';
            cam.Status = 'En curso';
            cam.IsActive = true;
            cam.CAMPA_COD_Campa_a__c = 'CAMP#-10901';
            cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            cam.StartDate = Date.today();
            cam.EndDate = Date.today() + 5;
            cam.Type = 'Televenta - Oncológico';
            cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            cam.CAMPA_Script_Televenta__c = 'Hola!!';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '23704706';
            mc.MCAMP_Carga_Dv__c = '0';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            
            Insert mc;
            
            Opportunity o = new Opportunity();
            String IdTipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Venta - Oncológico'].Id;
            
            o.RecordTypeId = IdTipoRegistro;
            o.Type = 'Propuesta';
            o.OPOR_N_Propuesta__c = '9999998';
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
            con.CONTRA_ID_Contratante_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + con.CONTRA_Dv__c + '-' + o.Id;
            con.CONTRA_Propuesta__c = o.Id;
            con.CONTRA_Persona__c = per.Id;
            con.CONTRA_Codigo_Region__c = '014';
            con.CONTRA_Codigo_Ciudad__c = '511';
            con.CONTRA_Codigo_Comuna__c = '511';            
            
            Insert con;
            
            rutPersona = '10355641-4';
            
            CLS_LlamadaWSonco.consultarDatosEquifaxOnco(usuario, rutPersona, mc.Id);            
            CLS_LlamadaWSonco.actualizarPropuestaOnco( usuario, o.Id );
            
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }    
    
    
}