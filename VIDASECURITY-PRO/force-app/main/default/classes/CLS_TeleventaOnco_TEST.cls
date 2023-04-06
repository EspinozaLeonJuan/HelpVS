/*******************************************************************************************
 *  NOMBRE                 : CLS_TeleventaOnco_TEST
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 23/10/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@isTest(SeeAllData=true)
private class CLS_TeleventaOnco_TEST {

    // Métodos Test Llamadas WS Onco Backoffice
    static testMethod void Escenarios_LlamadaWSonco_A(){
        
        try{
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());

            Account cta = new Account();
            /*
            cta.FirstName = 'Juan';
            cta.LastName = 'Juanito';
            cta.PersonEmail = 'hola@hola.cl';
            cta.PersonMobilePhone = '56934565544';
            cta.PersonHomePhone = '56227778899';
            cta.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            cta.Rut__c = '10355641';
            cta.DV__c = '4';*/
            String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE RecordTypeId =: rtype LIMIT 1];
            //insert cta;

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
            cam.CAMP_Producto__c = '19';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
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
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;
            
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
            
            String rutPersona = '10355641-4';           
        
            CLS_LlamadaWSonco.consultarDatosEquifaxOnco('12-9', rutPersona, mc.Id);            
            CLS_LlamadaWSonco.actualizarPropuestaOnco( '12-9', o.Id );
            
            CLS_LlamadaWSonco.RESPjson r = new CLS_LlamadaWSonco.RESPjson('200','Prueba');
            CLS_LlamadaWSonco.RESPjson r1 = new CLS_LlamadaWSonco.RESPjson();
            r1.Codigo = '200';
            r1.Descripcion = 'Prueba';
            
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }        
        
    } // Cliente vigente (Cuenta)
    
    static testMethod void Escenarios_LlamadaWSonco_B(){

        try{
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());

            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '10355641-4';
            insert can;

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
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
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
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;

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

            String rutPersona = '10355641-4';
          
            CLS_LlamadaWSonco.consultarDatosEquifaxOnco('12-9', rutPersona, mc.Id);
            CLS_LlamadaWSonco.actualizarPropuestaOnco( '12-9', o.Id );

            CLS_LlamadaWSonco.RESPjson r = new CLS_LlamadaWSonco.RESPjson('200','Prueba');
            CLS_LlamadaWSonco.RESPjson r1 = new CLS_LlamadaWSonco.RESPjson();
            r1.Codigo = '200';
            r1.Descripcion = 'Prueba';

            Test.stopTest();

        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }

    } // Cliente nuevo (Prospecto)

    static testMethod void Escenarios_LlamadaWSonco_C(){

        try{
            Test.startTest();

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
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';

            Insert mc;


            Test.stopTest();

        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }

    } // Cliente nuevo (Sin Registro)

    // Métodos Test WS SF para recepción propuesta
    static testMethod void Escenarios_WSpropuestaoncoSF_A(){
        
        try{
            
            Test.startTest();

            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '10355641-4';
            insert can;            
            
            Campaign cam = new Campaign();
            cam.Name = 'CAMPAÑA ONCO TEST';
            cam.Status = 'Planificada';
            cam.IsActive = false;
            cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
            cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            cam.StartDate = Date.today();
            cam.EndDate = Date.today() + 5;
            cam.Type = 'Televenta - Oncológico';
            cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            cam.CAMPA_Script_Televenta__c = 'Hola!!';
            
            Insert cam;
            
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
            o.OPOR_Usuario__c = '12-9';
            o.LeadSource = 'TEST';
            o.OPOR_Codigo_Sucursal__c = '000016';
            o.OPOR_Codigo_Canal__c = '20';
            o.OPOR_Estado_Propuesta__c = 'ING';
            o.Codigo_Periodo_Pago__c = 'M';
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;
            
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
            o.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
            
            //Insert o;
            
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
            
            //Insert per;
            
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
            
            //Insert ase;
            
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
            
            //Insert cob;
            
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
            
            //Insert ben;
            
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
            
            //Insert con;
            
            String rutPersona = '10355641-4';        
            
            CLS_WSPropuestasOncologico.DatosProspecto dpro = new CLS_WSPropuestasOncologico.DatosProspecto();
            CLS_WSPropuestasOncologico.Propuesta pro = new CLS_WSPropuestasOncologico.Propuesta();
            CLS_WSPropuestasOncologico.FormaPago fpa = new CLS_WSPropuestasOncologico.FormaPago();
            List<CLS_WSPropuestasOncologico.ArrPersona> arrper = new List<CLS_WSPropuestasOncologico.ArrPersona>();
            List<CLS_WSPropuestasOncologico.ArrContratante> arrcon = new List<CLS_WSPropuestasOncologico.ArrContratante>();
            List<CLS_WSPropuestasOncologico.ArrBeneficiario> arrben = new List<CLS_WSPropuestasOncologico.ArrBeneficiario>();
            List<CLS_WSPropuestasOncologico.ArrAsegurado> arrase = new List<CLS_WSPropuestasOncologico.ArrAsegurado>();
            List<CLS_WSPropuestasOncologico.ArrCobertura> arrcob = new List<CLS_WSPropuestasOncologico.ArrCobertura>();           
            List<CLS_WSPropuestasOncologico.Persona> lper = new List<CLS_WSPropuestasOncologico.Persona>();
            List<CLS_WSPropuestasOncologico.ContratantePropuesta> lcon = new List<CLS_WSPropuestasOncologico.ContratantePropuesta>();
            List<CLS_WSPropuestasOncologico.Beneficiario> lben = new List<CLS_WSPropuestasOncologico.Beneficiario>();
            List<CLS_WSPropuestasOncologico.Asegurado> lase = new List<CLS_WSPropuestasOncologico.Asegurado>();
            List<CLS_WSPropuestasOncologico.Cobertura> lcob = new List<CLS_WSPropuestasOncologico.Cobertura>();
            List<CLS_WSPropuestasOncologico.Intermediario> lint = new List<CLS_WSPropuestasOncologico.Intermediario>(); 
            
            // Asociación Datos Propuestas
            pro.CodCanal = Integer.valueOf(o.OPOR_Codigo_Canal__c);
            pro.CodMoneda = o.OPOR_Codigo_Moneda__c; 
            pro.CodPeriodoPago = o.Codigo_Periodo_Pago__c;
            pro.CodPlan = o.OPOR_Codigo_Plan__c;
            pro.CodProd = o.OPOR_Codigo_Producto__c;
            pro.CodRamo = o.OPOR_Codigo_Ramo__c;
            pro.CodSucursal = o.OPOR_Codigo_Sucursal__c;
            pro.EstadoPropuesta = o.OPOR_Estado_Propuesta__c;
            pro.IdCampania = o.OPOR_ID_Campa_a_SF__c;
            pro.NumPropuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            pro.PorcRiesgo = o.OPOR_Porcentaje_Riesgo__c;
            pro.RevPlan = o.OPOR_Revision_Plan__c;
            pro.TipoFolio = Integer.ValueOf(o.OPOR_Tipo_Folio__c);
            pro.Usuario = o.OPOR_Usuario__c;
            
            // Asociación Datos Forma de Pago
            fpa.CodBanco = o.OPOR_Codigo_Banco__c;
            fpa.CodTarjeta = o.OPOR_Codigo_Tarjeta__c;
            fpa.FechaVencimiento = o.OPOR_Fecha_Vencimiento__c;
            fpa.IdPolizaAsoc = Integer.ValueOf(o.OPOR_Id_Poliza_Asociada__c);
            fpa.NumeroCuenta = o.OPOR_N_Cuenta__c;
            fpa.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            fpa.TipoFolio = Integer.valueOf(o.OPOR_Tipo_Folio__c);
            fpa.TipoFormaPago = o.OPOR_Tipo_Forma_Pago__c;
            
            CLS_WSPropuestasOncologico.Persona perso = new CLS_WSPropuestasOncologico.Persona();
            perso.Rut = Integer.ValueOf(con.CONTRA_Rut__c);
            perso.Dv = con.CONTRA_Dv__c;
            perso.Nombres = 'Hector';
            perso.ApellidoPaterno = 'Norambuena';
            perso.ApellidoMaterno = 'Orellana';
            perso.Mail = 'hno@no.cl';
            perso.TelefonoFijo = '56227896655';
            perso.TelefonoMovil = '56227896655';
            perso.Direccion = 'Augusto Leguia 70';
            perso.CodComuna = '014';
            perso.CodCiudad = '511';
            perso.CodRegion = '511';
            perso.FechaNacimiento = Date.today();
            
            lper.add(perso);            
            CLS_WSPropuestasOncologico.ArrPersona arrperso = new CLS_WSPropuestasOncologico.ArrPersona();
            arrperso.Persona = lper;
            arrper.add(arrperso);

            CLS_WSPropuestasOncologico.ContratantePropuesta conpro = new CLS_WSPropuestasOncologico.ContratantePropuesta();
            conpro.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            conpro.Rut = perso.Rut;
            conpro.TipoFolio = Integer.valueOf(o.OPOR_Tipo_Folio__c);
            
            lcon.add(conpro);
            CLS_WSPropuestasOncologico.ArrContratante arrcontra = new CLS_WSPropuestasOncologico.ArrContratante();
            arrcontra.ContratantePropuesta = lcon;
            arrcon.add(arrcontra);
            
            CLS_WSPropuestasOncologico.Beneficiario benef = new CLS_WSPropuestasOncologico.Beneficiario();
            benef.CodRelacion = ase.ASEG_Codigo_Relacion__c;
            benef.Participacion = 0;
            benef.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            benef.Rut = perso.Rut;
            benef.TipoFolio = Integer.valueOf(o.OPOR_Tipo_Folio__c);
            
            lben.add(benef);
            CLS_WSPropuestasOncologico.ArrBeneficiario arrbenef = new CLS_WSPropuestasOncologico.ArrBeneficiario();
            arrbenef.Beneficiario = lben;
            arrben.add(arrbenef);
            
            CLS_WSPropuestasOncologico.Cobertura cober = new CLS_WSPropuestasOncologico.Cobertura();
            cober.CapitalAsegurado = 0;
            cober.CodCobert = cob.COB_Codigo_Cobertura__c;
            cober.Impuestos = 0;
            cober.ImpuestosLocal = 0;
            cober.PrimaNeta = 0;
            cober.PrimaNetaLocal = 0;
            cober.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            cober.Rut = perso.Rut;
            cober.TasaCambio = 0;
            cober.TasaPrima = 0;
            cober.TipoFolio = Integer.valueOf(o.OPOR_Tipo_Folio__c);
            
            lcob.add(cober);
            CLS_WSPropuestasOncologico.ArrCobertura arrcober = new CLS_WSPropuestasOncologico.ArrCobertura();
            arrcober.Cobertura = lcob;
            arrcob.add(arrcober);
            
            CLS_WSPropuestasOncologico.Asegurado asegu = new CLS_WSPropuestasOncologico.Asegurado();
            asegu.CodRelacion = ase.ASEG_Codigo_Relacion__c;
            asegu.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            asegu.Rut = perso.Rut;
            asegu.TipoFolio = Integer.ValueOf(o.OPOR_Tipo_Folio__c);            
            
            lase.add(asegu);
            CLS_WSPropuestasOncologico.ArrAsegurado arrasegu = new CLS_WSPropuestasOncologico.ArrAsegurado();
            arrasegu.Asegurado = lase;
            arrase.add(arrasegu); 
            
            CLS_WSPropuestasOncologico.Intermediario inter = new CLS_WSPropuestasOncologico.Intermediario();
            inter.CodIntermediario = 'INT01';
            inter.Participacion = 0;
            inter.Propuesta = Integer.valueOf(o.OPOR_N_Propuesta__c);
            inter.TipoFolio = Integer.valueOf(o.OPOR_Tipo_Folio__c);
            
            lint.add(inter);           

            // Objeto
            dpro.Propuesta = pro;
            dpro.FormPago = fpa;
            dpro.LsPersona = arrper;
            dpro.LsContratante = arrcon;
            dpro.LsBeneficiario = arrben;
            dpro.LsCobertura = arrcob;
            dpro.LsAsegurado = arrase;
            dpro.LsIntermediario = lint;            
            
            String respuesta = CLS_WSPropuestasOncologico.RegistraDatosProspecto(o.OPOR_Usuario__c, dpro);
            
            Test.stopTest(); 
            
        }catch(Exception ex){
            
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST LLAMADA WSONCO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        
        }
                
    }    
    
    // Métodos Test Trigger Actualización Propuesta Onco
    static testMethod void Escenarios_TRG_GestionaPropuesta_A(){
        
        try{
            
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
            
            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '10355641-4';
            insert can;
            
            Campaign cam = new Campaign();
            cam.Name = 'CAMPAÑA ONCO TEST';
            cam.Status = 'En curso';
            cam.IsActive = true;
            cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
            cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            cam.StartDate = Date.today();
            cam.EndDate = Date.today() + 5;
            cam.Type = 'Televenta - Oncológico';
            cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4';
            cam.CAMPA_Script_Televenta__c = 'Hola!!';
            cam.CAMP_Producto__c = '19';

            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
            Insert mc;
                        
            Task ts = new Task();
            ts.RecordTypeId = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Ventas Oncológico'].Id;
            ts.TASK_ID_Campana__c = cam.Id;
            ts.TASK_ID_Miembro_Campana__c = mc.Id;
            ts.Status = 'Completada';
            ts.ActivityDate = Date.today();
            ts.TASK_Campana__c = cam.Id;
            ts.WhoId = can.Id;
            ts.TASK_Producto_Oferta__c = '19';
            
            Insert ts;
            
            ts.TASK_Id_Unico_Actividad__c = String.valueOf(mc.Id) + String.valueOf(cam.Id) + String.valueOf(ts.Id);
            
            Update ts;

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
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;
            
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
            
            // Rechazo
            o.StageName = 'Venta - Rechaza Calidad';
            o.OPOR_Motivo_de_Rechazo_o_Perdida__c = 'Entrega información errónea';
            update o;
        
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST RECHAZO PROPUESTA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }         
        
    }     
    
    static testMethod void Escenarios_TRG_GestionaPropuesta_B(){
        
        try{
            
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());

            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '10355641-4';
            insert can;
            
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
            cam.CAMP_Producto__c = '19';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
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
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;
            
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

            system.debug('@@@@ MODIFICANDO TELEFONO CONTRATATE => ' + con);
            // Modificación datos contratante
            //con.CONTRA_Telefono_1__c = '56228889988';

            //update con;
            
            // Aprobación
            o.StageName = ' Venta - Aprobada';
            update o;
        
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST APROBAR PROPUESTA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }          
        
    }   
    
    static testMethod void Escenarios_TRG_GestionaPropuesta_C(){
        
        try{
            
            Test.startTest();
            Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
            
            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '10355641-4';
            insert can;            
            
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
            cam.CAMP_Producto__c = '19';
            
            Insert cam;
            
            CampaignMember mc = new CampaignMember();
            mc.CampaignId = cam.Id;
            mc.MCAMP_Carga_RUT__c = '10355641';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
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
            o.OPOR_ID_Campa_a_SF__c = cam.Id;
            o.CampaignId = cam.Id;
            
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
            
            // Borrar
            Delete o;
        
            Test.stopTest();
            
        }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST BORRAR PROPUESTA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }          
        
    }     
    
}