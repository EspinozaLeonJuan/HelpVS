/*******************************************************************************************
 *  NOMBRE                 : CLS_OncologicoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
private class CLS_OncoCETest {
    
    static testMethod void productosActualesContratante(){
        
        try{                                   
            
            Test.startTest();
            
            //Generación cuenta..
            Account cuenta = new Account();
            cuenta.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            cuenta.FirstName = 'Juan Antonio';
            cuenta.LastName = 'González';
            cuenta.Rut_contacto__pc = '15154056';
            cuenta.DV_contacto__pc = '2';
            cuenta.PersonEmail = 'juan.antonio.gonzalez@gmail.demo';
            cuenta.PersonBirthdate = Date.valueOf('1982-11-04');
            cuenta.Phone = '224567895';
            cuenta.PersonHomePhone = '224567895';
            cuenta.Email_Comercial__c = 'juan.antonio.gonzalez@gmail.demo';
            insert cuenta;
            system.debug('@@@@ CUENTA CREADA => ' + cuenta);
            
            //Generación cuenta..
            Account cuenta2 = new Account();
            cuenta2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            cuenta2.FirstName = 'Juan Antonio';
            cuenta2.LastName = 'González';
            cuenta2.Rut_contacto__pc = '9188219';
            cuenta2.DV_contacto__pc = '1';
            cuenta2.PersonEmail = 'juan.antonio.gonzalez@gmail.demo';
            cuenta2.PersonBirthdate = Date.valueOf('1982-11-04');
            cuenta2.Phone = '224567895';
            cuenta2.PersonHomePhone = '224567895';
            cuenta2.Email_Comercial__c = 'juan.antonio.gonzalez@gmail.demo';
            insert cuenta2;
            system.debug('@@@@ CUENTA CREADA => ' + cuenta2);            
            
            //Generación Póliza asociada...
            Poliza__c poliza = new Poliza__c();
            poliza.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Individuales'].Id;
            poliza.Name = '123456';
            poliza.N_Poliza__c = 123456;
            poliza.Cuenta__c = cuenta.Id;
            poliza.Estatus__c = 'ACTIVA';
            poliza.Nombre_de_Producto__c = 'APV MAX 3.0';
            poliza.Prima_Total__c = 10.0;
            poliza.Moneda_Poliza__c = 'UF';
            poliza.Forma_de_Pago__c = 'TARJETA DE CREDITO';
            insert poliza;
            system.debug('@@@@ POLIZA CREADA => ' + poliza);            
            
    		PageReference pag = Page.SEC_VF_ONCO_ProductosActualesContratante;
            Test.setCurrentPage(pag);
            pag.getParameters().put('rutContratante',cuenta.Rut_contacto__pc);
            pag.getParameters().put('PolizaMandatoria',poliza.Name);
            system.debug('PAGINA => ' + pag);
            //ApexPages.Standardcontroller sc = New ApexPages.Standardcontroller(min);     
            CLS_ProductosContratante ctr  = new CLS_ProductosContratante(); 
            ctr.cargaProductos();
            
    		PageReference pag2 = Page.SEC_VF_ONCO_ProductosActualesContratante;
            Test.setCurrentPage(pag2);
            pag2.getParameters().put('rutContratante',cuenta.Rut_contacto__pc);
            pag2.getParameters().put('PolizaMandatoria','');
            system.debug('PAGINA => ' + pag2);
            //ApexPages.Standardcontroller sc = New ApexPages.Standardcontroller(min);     
            CLS_ProductosContratante ctr2  = new CLS_ProductosContratante(); 
            ctr2.cargaProductos(); 
            
    	/* 	PageReference pag3 = Page.SEC_VF_ONCO_ProductosActualesContratante;
            Test.setCurrentPage(pag3);
            pag3.getParameters().put('rutContratante',cuenta2.Rut_contacto__pc);
            pag3.getParameters().put('PolizaMandatoria','');
            system.debug('PAGINA => ' + pag3);
            //ApexPages.Standardcontroller sc = New ApexPages.Standardcontroller(min);     
            CLS_ProductosContratante ctr3  = new CLS_ProductosContratante(); 
            ctr3.cargaProductos();              
            */
            Test.stopTest();
        
        }catch(Exception ex){
            system.debug('@@@@ ERROR METODO TEST VENTANA PRODUCTOS ACTUALES CONTRATANTE:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
        
        
    }
        
    static testMethod void actualizaDatosContacto(){
        try{
            
            Test.startTest();
        
            //Instancias objetos SF
			Opportunity o = new Opportunity();
			String IdTipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Venta - Oncológico'].Id;
                
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
            //o.OPOR_ID_Campa_a_SF__c = pro.IdCampania;
            o.CampaignId = null;
                
            o.StageName = 'Venta - Pendiente Validar';                
            o.CloseDate = Date.today();
            //o.AccountId = [SELECT Id FROM Account WHERE Rut__c =: pro.RutContratante].Id;				
            o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c;
            
            insert o;  
            
            
            o.OPOR_Usuario__c = 'carlosespinoza';
            o.LeadSource = '2';
            o.OPOR_Codigo_Sucursal__c = 'IQUIQUE';
            update o;  
            
            //Instancia nuevo objeto persona..
            Persona__c OBJpersona = new Persona__c();
        
            OBJpersona.Name = 'Carlos';
            OBJpersona.PERSO_N_Propuesta__c = o.OPOR_N_Propuesta__c;
            OBJpersona.PERSO_Apellido_Paterno__c = 'Espinoza';
            OBJpersona.PERSO_Apellido_Materno__c = 'Pezzopane';
            OBJpersona.PERSO_Rut__c = 1;
            OBJpersona.PERSO_Dv__c = '9';
            OBJpersona.PERSO_Mail__c = 'cespinoza@microsystem.cl';
            OBJpersona.PERSO_Telefono_Fijo__c = '2211111222';
            OBJpersona.PERSO_Telefono_Movil__c = '980021212';
            OBJpersona.PERSO_Direccion__c = '';
            OBJpersona.PERSO_Codigo_Comuna__c = '602';
            OBJpersona.PERSO_Codigo_Ciudad__c = '602';
            OBJpersona.PERSO_Codigo_Region__c = '011';
            OBJpersona.PERSO_Fecha_de_Nacimiento__c = Date.valueOf('2018-07-10');
            OBJpersona.PERSO_ID_Persona_Propuesta__c = o.OPOR_N_Propuesta__c + '-1';
			insert OBJpersona;
            
            Asegurado__c OBJasegurado = new Asegurado__c();
            OBJasegurado.ASEG_Persona__c = OBJpersona.Id;
            OBJasegurado.Name = OBJpersona.Name;
            OBJasegurado.ASEG_Dv__c = OBJpersona.PERSO_Dv__c;
            OBJasegurado.ASEG_Telefono_1__c = OBJpersona.PERSO_Telefono_Fijo__c;
            OBJasegurado.ASEG_Telefono_2__c = OBJpersona.PERSO_Telefono_Movil__c;
            OBJasegurado.ASEG_Email_1__c = OBJpersona.PERSO_Mail__c;
            OBJasegurado.ASEG_Email_2__c = OBJpersona.PERSO_Mail__c;
            OBJasegurado.ASEG_Fecha_de_Nacimiento__c = OBJpersona.PERSO_Fecha_de_Nacimiento__c;
            OBJasegurado.ASEG_Apellido_Paterno__c = OBJpersona.PERSO_Apellido_Paterno__c;
            OBJasegurado.ASEG_Apellido_Materno__c = OBJpersona.PERSO_Apellido_Materno__c;
            OBJasegurado.ASEG_Codigo_Ciudad__c = OBJpersona.PERSO_Codigo_Ciudad__c;
            OBJasegurado.ASEG_Codigo_Comuna__c = OBJpersona.PERSO_Codigo_Comuna__c;
            OBJasegurado.ASEG_Codigo_Region__c = OBJpersona.PERSO_Codigo_Region__c;
            OBJasegurado.ASEG_Direccion__c = OBJpersona.PERSO_Direccion__c;
            OBJasegurado.ASEG_ID_Asegurado_Propuesta__c = OBJpersona.PERSO_ID_Persona_Propuesta__c;
            OBJasegurado.ASEG_Propuesta__c = o.Id;
            insert OBJasegurado;
            
            //Instancia nuevo objeto beneficiario..
            Beneficiario2__c OBJbeneficiario = new Beneficiario2__c();
					
            OBJbeneficiario.BEN_Persona__c = OBJpersona.Id;
            OBJbeneficiario.Name = OBJpersona.Name;
            OBJbeneficiario.BEN_Dv__c = OBJpersona.PERSO_Dv__c;
            OBJbeneficiario.BEN_Fecha_de_Nacimiento__c = OBJpersona.PERSO_Fecha_de_Nacimiento__c;
            OBJbeneficiario.BEN_Apellido_Paterno__c = OBJpersona.PERSO_Apellido_Paterno__c;
            OBJbeneficiario.BEN_Apellido_Materno__c = OBJpersona.PERSO_Apellido_Materno__c;
            OBJbeneficiario.BEN_Email_1__c = OBJpersona.PERSO_Mail__c;
            OBJbeneficiario.BEN_Email_2__c = OBJpersona.PERSO_Mail__c;
            OBJbeneficiario.BEN_Tel_fono_1__c = OBJpersona.PERSO_Telefono_Fijo__c;
            OBJbeneficiario.BEN_Tel_fono_2__c = OBJpersona.PERSO_Telefono_Movil__c;
            OBJbeneficiario.BEN_C_digo_Regi_n__c = OBJpersona.PERSO_Codigo_Region__c;
            OBJbeneficiario.BEN_C_digo_Ciudad__c = OBJpersona.PERSO_Codigo_Ciudad__c;
            OBJbeneficiario.BEN_C_digo_Comuna__c = OBJpersona.PERSO_Codigo_Comuna__c;
            OBJbeneficiario.BEN_ID_Beneficiario_Propuesta__c = OBJpersona.PERSO_ID_Persona_Propuesta__c;
            OBJbeneficiario.BEN_Propuesta__c = o.Id;
            insert OBJbeneficiario;
            
            //Instancia nuevo objeto persona..
            Contratante__c OBJcontratante = new Contratante__c();
            
            OBJcontratante.CONTRA_Persona__c = OBJpersona.Id;
            OBJcontratante.Name = OBJpersona.Name;
            OBJcontratante.CONTRA_Dv__c = OBJpersona.PERSO_Dv__c;
            OBJcontratante.CONTRA_Telefono_1__c = OBJpersona.PERSO_Telefono_Fijo__c;
            OBJcontratante.CONTRA_Telefono_2__c = OBJpersona.PERSO_Telefono_Movil__c;
            OBJcontratante.CONTRA_Email_1__c = OBJpersona.PERSO_Mail__c;
            OBJcontratante.CONTRA_Email_2__c = OBJpersona.PERSO_Mail__c;
            OBJcontratante.CONTRA_Fecha_de_Nacimiento__c = OBJpersona.PERSO_Fecha_de_Nacimiento__c; 
            OBJcontratante.CONTRA_Apellido_Paterno__c = OBJpersona.PERSO_Apellido_Paterno__c;
            OBJcontratante.CONTRA_Apellido_Materno__c = OBJpersona.PERSO_Apellido_Materno__c;
            OBJcontratante.CONTRA_Direccion__c = OBJpersona.PERSO_Direccion__c;
            OBJcontratante.CONTRA_Codigo_Ciudad__c = OBJpersona.PERSO_Codigo_Ciudad__c;
            OBJcontratante.CONTRA_Codigo_Comuna__c=  OBJpersona.PERSO_Codigo_Comuna__c;
            OBJcontratante.CONTRA_Codigo_Region__c = OBJpersona.PERSO_Codigo_Region__c;
            OBJcontratante.CONTRA_Propuesta__c = o.Id;
            OBJcontratante.CONTRA_Rut__c = 1;
            OBJcontratante.CONTRA_Tipo_Folio__c = 1;
            OBJcontratante.CONTRA_ID_Contratante_Propuesta__c = OBJpersona.PERSO_ID_Persona_Propuesta__c;
            insert OBJcontratante;
            
            OBJcontratante.CONTRA_Codigo_Ciudad__c = '615';
            OBJcontratante.CONTRA_Codigo_Comuna__c=  '615';
            OBJcontratante.CONTRA_Codigo_Region__c = '013';
            update OBJcontratante;
            
            delete o;
            
            Test.stopTest();
        
            
        }catch(Exception ex){
            system.debug('@@@@ ERROR METODO TEST ACTUALIZA DATOS CONTACTO:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }
    
    static testMethod void digitador(){
     try{
         	 Test.startTest();
         	 CLS_DigitadorController  ctr  = new CLS_DigitadorController(); 
         	 ctr.cargaDatosContratantePreDigitador();
             
             String rutUsuario = '';
             String dvUsuario = '';
             String idCanal = '';
             String rutCliente = '';
             String idCampana = '';
             String tipoFolio = '';
             String poliza = '';
             String idExterno = '';
             String totalInic = '';
             String preimpreso = '';
             String direccion = '';
             String mail = '';
             String fono = '';
             String celular = '';
             String codComuna = '';
             String codRegion = '';
             String codCiudad = '';
             String tipoCliente = '';
             String persistencia = '';
             
         	 CLS_DigitadorController.ParametroDigitador2  paramD  = new CLS_DigitadorController.ParametroDigitador2(rutUsuario, dvUsuario, idCanal, rutCliente, idCampana, tipoFolio,
        				    poliza, idExterno, totalInic, preimpreso, direccion, mail, fono,
                            celular, codComuna, codRegion, codCiudad, tipoCliente, persistencia);           
            
              Test.stopTest();
         }
    catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST Digitador Controller:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
    
    static testMethod void actualizaPantalla(){
     try{
         	  Test.startTest();
         	  CLS_ActualizaPantalla  ctr  = new CLS_ActualizaPantalla(); 
         	  ctr.actualizaPropuesta('1');
              Test.stopTest();
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST CAMPAÑA ACTIVA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
  
    static testMethod void audioTeleventa(){
     try{
         	  Test.startTest();
         	  CLS_AudioTeleventaController  ctr  = new CLS_AudioTeleventaController(); 
         	  Test.stopTest();
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST CAMPAÑA ACTIVA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
   
    static testMethod void BatchMCTeleventaOnco(){
         try
         {
             Test.startTest();
             Database.BatchableContext trabajo;
             List<sObject> MCprocesar = new List<sObject>();
             CampaignMember mc = new CampaignMember();
             mc.MCAMP_Campana_Activa__c = true;    
             
             Campaign cam = new Campaign();
             cam.CAMPA_COD_Campa_a__c  = '121212'; 
             
 			 mc.Campaign = cam;
             mc.MCAMP_Carga_RUT__c = '1';
             mc.MCAPM_Carga_Primer_Nombre__c = 'Carlos';
             mc.MCAMP_Carga_Apellido_Paterno__c = 'Espinoza';
             mc.MCAMP_Carga_Apellido_Materno__c = '';
             mc.MCAMP_Carga_Email_1__c = 'cespinoza@microsystem.cl';
             mc.MCAMP_Carga_Email_2__c = '';
             mc.MCAMP_Carga_Tel_fono_1__c = '';
             mc.MCAMP_Carga_Tel_fono_2__c = '';
             mc.MCAMP_Carga_Poliza_Mandatoria__c = '';
             mc.MCAMP_Carga_Fecha_Nacimiento__c = Date.today();            
             MCprocesar.add(mc);   
             CLS_ProcesoBatchMCTeleventaOncologico p = new  CLS_ProcesoBatchMCTeleventaOncologico('00v3D000002QWoLQAW');
             p.start(trabajo);
             p.execute(trabajo, MCprocesar);
              
             Test.stopTest();
         }
         catch(Exception ex){
                Test.stopTest();
                system.debug('@@@@ ERROR METODO BatchMCTeleventaOnco :');
                system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
         }
    } 
}