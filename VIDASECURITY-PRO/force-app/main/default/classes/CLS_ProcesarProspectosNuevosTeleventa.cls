global class CLS_ProcesarProspectosNuevosTeleventa implements Database.Batchable<sObject>,Database.AllowsCallouts {

    public String IDCampana;
    global String qr_LMCampana;
    
    global CLS_ProcesarProspectosNuevosTeleventa(String IDCampana){
        this.IDCampana = IDCampana;
        qr_LMCampana = 'Select Id, IsDeleted, CampaignId, LeadId, ContactId, Status, HasResponded, CreatedDate, CreatedById, ' +
                       'LastModifiedDate, LastModifiedById, SystemModstamp, FirstRespondedDate, RecordTypeId, Salutation, ' +
                       'Name, FirstName, LastName, Title, Street, City, State, PostalCode, Country, Email, Phone, Fax, ' +
                       'MobilePhone, Description, DoNotCall, HasOptedOutOfEmail, HasOptedOutOfFax, LeadSource, CompanyOrAccount, ' +
                       'Type, LeadOrContactId, LeadOrContactOwnerId, Agente__c, Causa_No_Contacto__c, Cerrado__c, Cerrado_por__c, ' +
                       'Comentarios__c, Correo_Electronico__c, Enviar_Ley__c, Fecha_de_Activacion__c, Nombre_Empleador__c, ' +
                       'Numero_de_Poliza__c, Poliza__c, Producto__c, RUT_Empleador__c, Razon_Social_Empleador__c, Recibio_Ley__c, ' +
                       'Sucursal__c, Supervisor__c, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, MCAMP_Carga_Apellido_Materno__c, ' +
                        'MCAMP_Carga_Apellido_Paterno__c, MCAMP_Carga_Dv__c, MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, ' +
                        'MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, ' +
                        'MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c, MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, ' +
                        'MCAMP_Es_Asegurable__c, MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, ' +
                        'MCAMP_Plan__c, MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, ' +
                        'MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, ' +
                        'MCAMP_Tasa_Riesgo__c, MCAMP_Tipo_Folio__c, MCAMP_WS_Equifax_Consumido__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, ' +
                        'MCAPM_Carga_Primer_Nombre__c, WS_Tiene_Producto_Oncologico__c, MCAMP_Tipo_Cliente__c, MCAMP_Actualizar_Nuevo_Cliente__c ' +       
                       'from CampaignMember where CampaignId = \'' + String.escapeSingleQuotes(IDCampana) + '\' and MCAMP_Actualizar_Nuevo_Cliente__c = true';
    }
    
    global Database.QueryLocator start(Database.BatchableContext trabajo){        
        if(Test.isRunningTest()){
            /*
            qr_LMCampana += ' and (CreatedById = \'' + String.escapeSingleQuotes(CreadorSND) + '\' or CreatedById = \'' + String.escapeSingleQuotes(CreadorPRO) + '\')';
            system.debug('@@@@@ QUERY TEST => ' + qr_LMCampana);
            */            
        }else{
            system.debug('@@@@ QUERY REAL => ' + qr_LMCampana);
        }
        return Database.getQueryLocator(qr_LMCampana);
    }
    
    global void execute(Database.BatchableContext trabajo,List<CampaignMember> MCprocesar){
        
        // Control errores
        boolean ERR_EQUIFAXWS = false;
        String ERR_MENSAJE_EQUIWS = '', ERR_LINEA_EQUIWS = '';
        
        boolean ERR_PRODONCOWS = false;  
        String ERR_MENSAJE_PRONCOWS = '', ERR_LINEA_PRONCOWS = '';
       
        system.debug('@@@@ TAMAÑO LISTA MCprocesar => ' + MCprocesar.size());
        for (CampaignMember mc : MCprocesar){
            
            //CampaignMember cm = (CampaignMember)sobjMC;
            
            //Recuperación RUT Usuario que esta ejecutando la carga de Miembros de Campañas
            //o asociando Miembros en Salesforce CRM...
            string usuario = [select Id,
                              Name,
                              RUT_Usuario__c
                              from 
                              User
                              where
                              Id =: UserInfo.getUserId()].RUT_Usuario__c;
            
            string rutPersona = mc.MCAMP_Carga_RUT__c + '-' + mc.MCAMP_Carga_Dv__c;
            system.debug('@@@@ RUT PERSONA A CONSULTA EQUIFAX => ' + rutPersona);
            
            if(usuario == null)
                usuario = '1-1';
            
            //Valida y actualiza datos con equifax
            //CLS_LlamadaWSonco.consultarDatosEquifaxOnco(usuario, rutPersona, cm.Id);
            String IdMC = mc.Id;
            string RutPersonaSinDV='';
            CampaignMember cm = new CampaignMember(); 
            String tipoCliente;
            Lead prospecto = null;
            String Resultado='';
            
            try{
                
                cm = [SELECT 
                      Id, IsDeleted, CampaignId, LeadId, ContactId, Status, HasResponded, CreatedDate, CreatedById, 
                      LastModifiedDate, LastModifiedById, SystemModstamp, FirstRespondedDate, RecordTypeId, Salutation, 
                      Name, FirstName, LastName, Title, Street, City, State, PostalCode, Country, Email, Phone, Fax, 
                      MobilePhone, Description, DoNotCall, HasOptedOutOfEmail, HasOptedOutOfFax, LeadSource, CompanyOrAccount, 
                      Type, LeadOrContactId, LeadOrContactOwnerId, Agente__c, Causa_No_Contacto__c, Cerrado__c, Cerrado_por__c, 
                      Comentarios__c, Correo_Electronico__c, Enviar_Ley__c, Fecha_de_Activacion__c, Nombre_Empleador__c, 
                      Numero_de_Poliza__c, Poliza__c, Producto__c, RUT_Empleador__c, Razon_Social_Empleador__c, Recibio_Ley__c, 
                      Sucursal__c, Supervisor__c, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, MCAMP_Carga_Apellido_Materno__c, 
                      MCAMP_Carga_Apellido_Paterno__c, MCAMP_Carga_Dv__c, MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, 
                      MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, 
                      MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c, MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, 
                      MCAMP_Es_Asegurable__c, MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, 
                      MCAMP_Plan__c, MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, 
                      MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, 
                      MCAMP_Tasa_Riesgo__c, MCAMP_Tipo_Folio__c, MCAMP_WS_Equifax_Consumido__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, 
                      MCAPM_Carga_Primer_Nombre__c, WS_Tiene_Producto_Oncologico__c, MCAMP_Tipo_Cliente__c, MCAMP_Actualizar_Nuevo_Cliente__c 
                      FROM 
                      CampaignMember
                      WHERE
                      Id =: IdMC];
                
                RutPersonaSinDV=cm.MCAMP_Carga_RUT__c;
                if(RutPersonaSinDV==null)
                {
                    RutPersonaSinDV='0';
                }
                
                if(cm.LeadId != null){
                    system.debug('@@@@ ID LEAD CAMPAÑA => ' + cm.LeadId);
                    
                    prospecto = [select 
                                 Id,
                                 Firstname,
                                 Lastname,
                                 Email,
                                 Phone,
                                 PROSP_Carga_Apellido_Materno__c,
                                 PROSP_Carga_Email_2__c,
                                 PROSP_Carga_RUT__c,
                                 PROSP_Carga_Tel_fono_2__c,
                                 PROSPE_Carga_Fecha_Nacimiento__c,
                                 PROSP_No_quiere_ser_contactado_Televenta__c
                                 from
                                 Lead
                                 where
                                 Id =: cm.LeadId];
                }            
                
                CLS_WSprodoncoEquifax.Equifax2Soap cnx = new CLS_WSprodoncoEquifax.Equifax2Soap();
                wsAxonaxisCl.DatosPersona res1 = new wsAxonaxisCl.DatosPersona();            
                //res1 = cnx.ConsultaPersona(rutPersona,usuario,'PREDIGITADORES');
                if (!Test.isRunningTest())
                {
                    res1 = cnx.ConsultaPersona(rutPersona,usuario,'PREDIGITADORES');
                }else{
                    res1 = new  wsAxonaxisCl.DatosPersona();  
                    res1.PersonaNatural = new wsAxonaxisCl.PersonaNatural_element();
                    res1.RUT ='10355641-4';
                    res1.PersonaNatural.Nombre = new wsAxonaxisCl.Nombre_element();
                    res1.PersonaNatural.Nombre.Nombres ='Hector';
                    res1.PersonaNatural.Nombre.ApellidoMaterno ='Norambuena';
                    res1.PersonaNatural.Nombre.ApellidoPaterno ='Orellana';
                    res1.PersonaNatural.FechaNacimiento = new wsAxonaxisCl.FechaNacimiento_element();
                    res1.PersonaNatural.FechaNacimiento.FechaNacimiento = Date.today();
                    res1.PersonaNatural.Actividad = new wsAxonaxisCl.Actividad_element();
                    res1.PersonaNatural.Actividad.Actividad='Consultor';
                }
                
                system.debug('@@@@ RES1 => ' + res1);            
                system.debug('@@@@ RES1 => ' + res1.PersonaNatural);
                system.debug('@@@@ RES1 => ' + res1.Domicilio);
                
                system.debug('@@@@ RES1 Nombres=> ' + res1.PersonaNatural.Nombre.Nombres);
                cm.MCAPM_Carga_Primer_Nombre__c = res1.PersonaNatural.Nombre.Nombres;
                
                system.debug('@@@@ RES1 APaterno=> ' + res1.PersonaNatural.Nombre.ApellidoPaterno);
                cm.MCAMP_Carga_Apellido_Paterno__c = res1.PersonaNatural.Nombre.ApellidoPaterno;
                
                system.debug('@@@@ RES1 AMaterno=> ' + res1.PersonaNatural.Nombre.ApellidoMaterno);
                cm.MCAMP_Carga_Apellido_Materno__c = res1.PersonaNatural.Nombre.ApellidoMaterno;
                
                cm.MCAMP_Carga_Fecha_Nacimiento__c = Date.valueOf(res1.PersonaNatural.FechaNacimiento.FechaNacimiento);            
                
                if(prospecto != null){
                    system.debug('@@@@ LEAD PARA ACTUALIZAR CON EQUIFAX => ' + prospecto);
                    prospecto.FirstName = cm.MCAPM_Carga_Primer_Nombre__c;
                    prospecto.LastName = cm.MCAMP_Carga_Apellido_Paterno__c;
                    prospecto.PROSP_Carga_Apellido_Materno__c = cm.MCAMP_Carga_Apellido_Materno__c;
                    prospecto.PROSPE_Carga_Fecha_Nacimiento__c = cm.MCAMP_Carga_Fecha_Nacimiento__c;
                    
                    //update prospecto;
                    system.debug('@@@@ LEAD ACTUALIZADO EQUIFAX => ' + prospecto);
                }
                
                
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = true; 
                
                cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Equifax: Procesado correctamente';
                
            }catch(system.CalloutException cout_equifax){            
                
                system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA EQUIFAX WS | TARIFICACION WS                                ');
                system.debug('@@@@ *******************************************************************************************');
                system.debug('@@@@ MENSAJE: ' + cout_equifax.getMessage());
                system.debug('@@@@ LINEA: ' + cout_equifax.getLineNumber());
                
                ERR_EQUIFAXWS = true;
                ERR_MENSAJE_EQUIWS = cout_equifax.getMessage();
                ERR_LINEA_EQUIWS = String.ValueOf(cout_equifax.getLineNumber());

                cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Equifax: Imposible procesar llamada a equifax.';                        
                
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = false;    
                
                
            }finally{                                   
                
                
                
                if(cm.MCAMP_Es_cliente__c == true){
                    tipoCliente = 'N'; // Cliente existente
                }else{
                    tipoCliente = 'S'; // Cliente nuevo o prospecto
                }            
                
                try{
                    
                    //Llamada al Servicio Web para obtener datos para parificar...
                    CLS_WSprodonco.WsProductoOncologicoSoap cnx1 = new CLS_WSprodonco.WsProductoOncologicoSoap();
                    CLS_WSprodonco.ArrayOfProductoOncologico pOnco = new CLS_WSprodonco.ArrayOfProductoOncologico(); 
                    CLS_WSprodonco.UsuarioValido resValidaUsu = new CLS_WSprodonco.UsuarioValido();            
                    
                    if(!Test.isRunningTest()){
                        
                        pOnco = cnx1.GetUltimoProducto(usuario, 19, tipoCliente);
                        
                    }else{
                        
                        CLS_WSprodonco.ProductoOncologico prOnco = new CLS_WSprodonco.ProductoOncologico();
                        prOnco.DescPlanProd = 'SEGURO ONCOLOGICO';
                        prOnco.CodPlan = '001';
                        prOnco.RevPlan = '001';
                        prOnco.CodRamoPlan = '7300';
                        prOnco.DescRamo = 'SEGURO ONCOLOGICO';
                        prOnco.CodProd = 'MD01';
                        prOnco.TipoFolio = '19';
                        prOnco.ContiguAlAseg = 'S';
                        prOnco.AceptaAsegAdic = 'S';
                        prOnco.AceptaBenefic = 'N';
                        prOnco.BenefAsegTit = 'S';
                        prOnco.AdjuntaArchivos = 'S';
                        prOnco.UsanMismaDireccion = 'S';
                        
                        List<CLS_WSprodonco.ProductoOncologico> lsprOnco = new List<CLS_WSprodonco.ProductoOncologico>();
                        lsprOnco.add(prOnco);
                        
                        pOnco.ProductoOncologico = lsprOnco;                    
                        
                    }
                    
                    system.debug('@@@@ RETORNO PRODUCTO ONCOLOGICO:');
                    system.debug('@@@@ ============================================================================================');                    
                    
                                        /*
                    if (pOnco==null)
                    {
                    pOnco= new CLS_WSprodonco.ArrayOfProductoOncologico(); 
                    
                    }
                    if(pOnco.ProductoOncologico==null)
                    {
                    pOnco.ProductoOncologico= new List<CLS_WSprodonco.ProductoOncologico>();
                    }
                    */
                    
                    for(CLS_WSprodonco.ProductoOncologico p : pOnco.ProductoOncologico){
                        cm.MCAMP_Plan__c = p.CodPlan;
                        cm.MCAMP_Revision__c = p.RevPlan;
                        cm.MCAMP_Ramo__c = p.CodRamoPlan;
                        cm.MCAMP_Codigo_Producto__c = p.CodProd;
                    }
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - GetÚltimoProducto: Procesado correctamente';
                    
                    String USU_Asegurable = '';
                    
                    //Valida que se envia fecha de nacimiento de contratante participante de la campaña...
                    if(cm.MCAMP_Carga_Fecha_Nacimiento__c != null){
                        Date d = cm.MCAMP_Carga_Fecha_Nacimiento__c;
                        system.debug('@@@@ FECHA => ' + d);
                        
                        String fecha = String.valueOf( d.year() );
                        if(d.month()<10){
                            fecha = fecha + '0' + String.valueOf( d.month() );
                        }else{
                            fecha = fecha + String.valueOf( d.month() );
                        }
                        if(d.day()<10){
                            fecha = fecha + '0' + String.valueOf( d.day() );
                        }else{
                            fecha = fecha + String.valueOf( d.day() );
                        }                  	
                        
                        Integer fnac = Integer.valueOf( fecha );
                        system.debug('@@@@ FNAC =>  ' + fnac);
                        
                        if(!Test.isRunningTest()){
                            
                            resValidaUsu = cnx1.ValidacionUsuarioPorFecNac(usuario, cm.MCAMP_Ramo__c, cm.MCAMP_Codigo_Producto__c, cm.MCAMP_Plan__c, cm.MCAMP_Revision__c, tipoCliente, '0001', fnac);
                            
                        }else{
                            
                            resValidaUsu.Respuesta = 'S';
                            
                        }
                        
                        USU_Asegurable = resValidaUsu.Respuesta;
                        
                        system.debug('@@@@ RETORNO VALIDACION CONTRATANTE CARGADO:');
                        system.debug('@@@@ ============================================================================================'); 
                        system.debug('@@@@ ASEGURABLE => ' + USU_Asegurable);
                        system.debug('@@@@ ASEGURABLE => ' + RutPersonaSinDV);
                        
                        
                        cm.MCAMP_Es_Asegurable__c = USU_Asegurable;
                        
                        cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidacionUsuarioPorFecNac: Procesado correctamente';
                        
                        CLS_WSprodonco.ValidaAseguradoOncoResponse_element res2 = new CLS_WSprodonco.ValidaAseguradoOncoResponse_element();
                        string codCobert = 'CSON'; 
                        
                        if(!Test.isRunningTest()){
                            
                            res2.ValidaAseguradoOncoResult = cnx1.ValidaAseguradoOnco(usuario, cm.MCAMP_Ramo__c,cm.MCAMP_Codigo_Producto__c,cm.MCAMP_Plan__c,cm.MCAMP_Revision__c,codCobert,Integer.valueOf(RutPersonaSinDV), fnac);
                            
                        }else{
                            
                            res2.ValidaAseguradoOncoResult = 'S';
                            
                        }
                        
                        system.debug('@@@@ RETORNO VALIDACION PRODUCTO ONCOLOGICO =>' + res2.ValidaAseguradoOncoResult);
                        if(res2.ValidaAseguradoOncoResult==null)
                            cm.WS_Tiene_Producto_Oncologico__c=false;  
                        else
                            cm.WS_Tiene_Producto_Oncologico__c=res2.ValidaAseguradoOncoResult=='N';
                        
                        if (cm.WS_Tiene_Producto_Oncologico__c){
                            cm.MCAMP_Es_Asegurable__c='N';
                        }
                        system.debug('@@@@ RETORNO ES ASEGURADO =>' + cm.MCAMP_Es_Asegurable__c);
                        
                        if (Test.isRunningTest()){
                            cm.MCAMP_Es_Asegurable__c = 'S';
                        }
                        
                        cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidaAseguradoOnco: Procesado correctamente';
                        
                        if(cm.MCAMP_Es_Asegurable__c == 'S'){
                            //Creación instancia de respuesta para Tarificación de Contratante...
                            CLS_WSprodonco.Tarificacion resTarMC = new CLS_WSprodonco.Tarificacion();  
                            
                            if(!Test.isRunningTest()){
                                
                                resTarMC = cnx1.GetTarificacionOncoFechaNacimiento(usuario, cm.MCAMP_Ramo__c, cm.MCAMP_Codigo_Producto__c, cm.MCAMP_Plan__c, cm.MCAMP_Revision__c, tipoCliente, '0001', fnac);
                                
                            }else{
                                
                                resTarMC.PrimaBrutaPS = 11662;
                                resTarMC.PrimaBrutaUF = 0.423;
                                resTarMC.PrimaIVAPS = 1862;
                                resTarMC.PrimaIVAUF = 0.0675;
                                resTarMC.PrimaNetaPS = 9800;
                                resTarMC.PrimaNetaUF = 0.3555;
                                resTarMC.TasaRiesgo = 0;
                                resTarMC.ValorUF = 28000;
                            }
                            
                            //Valores Tarifas Posible Contratante...
                            system.debug('@@@@ RETORNO VALOR TARIFAS CONTRATANTE CARGADO:');
                            system.debug('@@@@ ============================================================================================');                            
                            system.debug('@@@@ PRIMA BRUTA PS => ' + resTarMC.PrimaBrutaPS + ' ; PRIMA BRUTA UF => ' + resTarMC.PrimaBrutaUF);
                            system.debug('@@@@ PRIMA IVA PS => ' + resTarMC.PrimaIVAPS + ' ; PRIMA IVA UF => ' + resTarMC.PrimaIVAUF);
                            system.debug('@@@@ PRIMA NETA PS => ' + resTarMC.PrimaNetaPS + ' ; PRIMA NETA UF => ' + resTarMC.PrimaNetaUF);
                            system.debug('@@@@ TASA RIESGO => ' + resTarMC.TasaRiesgo);
                            
                            cm.MCAMP_Prima_Neta_CLP__c = resTarMC.PrimaNetaPS;
                            cm.MCAMP_Prima_Neta_UF__c = resTarMC.PrimaNetaUF;
                            cm.MCAMP_Prima_IVA_CLP__c = resTarMC.PrimaIVAPS;
                            cm.MCAMP_Prima_IVA_UF__c = resTarMC.PrimaIVAUF;
                            cm.MCAMP_Tarifa_CLP__c = resTarMC.PrimaBrutaPS;
                            cm.MCAMP_Tarifa_UF__c = resTarMC.PrimaBrutaUF;
                            cm.MCAMP_Tasa_Riesgo__c = resTarMC.TasaRiesgo;
                            
                            // Calculo tipo cambio
                            //cm.MCAMP_Tipo_de_Cambio_UF__c = resTarMC.PrimaBrutaPS / resTarMC.PrimaBrutaUF;
                            if (restarMC.ValorUF != null)
                            {
                                cm.MCAMP_Tipo_de_Cambio_UF__c = restarMC.ValorUF;
                            }
                            else {
                                cm.MCAMP_Tipo_de_Cambio_UF__c = 0;//si viene valor restarMC.ValorUF toma 0 como resultado
                            }
							
                            // Calculo valores email promocional
                            cm.MCAMP_Monto_Cobertura_Promocional__c = cm.MCAMP_Tipo_de_Cambio_UF__c * 1000;
                            Double tarBrutaProm = cm.MCAMP_Tarifa_CLP__c;
                            cm.MCAMP_Tarifa_Prima_Bruta_Promocional__c = tarBrutaProm.round();                            
                            
                            cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - GetTarificacionOncoFechaNacimiento: Procesado correctamente';
                        }
                        
                    }
                    
                    //Bandera para indicar que se ha consumido el WS para consultar Producto Oncológico y
                    //Tarifa para Contratante que participa en campaña.
                    cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c = true;
                    
                    //update cm;
                    if(prospecto != null){
                        update prospecto;
                    }
                    
                    //cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
                    
                }catch(system.CalloutException cout_wsprodonco){
                    
                    system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA EQUIFAX WS | TARIFICACION WS                                ');
                    system.debug('@@@@ *******************************************************************************************');
                    system.debug('@@@@ MENSAJE: ' + cout_wsprodonco.getMessage());
                    system.debug('@@@@ LINEA: ' + cout_wsprodonco.getLineNumber()); 
                    
                    ERR_PRODONCOWS = false;  
                    ERR_MENSAJE_PRONCOWS = cout_wsprodonco.getMessage();
                    ERR_LINEA_PRONCOWS = String.valueOf(cout_wsprodonco.getLineNumber());
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - Producto Oncológico: Imposible procesar llamada a WS Producto oncológico.';
                    
                }finally{
                    
                    if(cm.MCAMP_Actualizar_Nuevo_Cliente__c && cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c){
                        cm.MCAMP_Actualizar_Nuevo_Cliente__c = false;
                    }
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nProceso carga/integración del registro finalizado';
                    update cm;
                    
                    if(ERR_EQUIFAXWS){
   
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'isaac.salazar@security.cl','sebastian.acevedo@security.cl','pamunoz@security.cl'};
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                        mail.setReplyTo('isaac.salazar@security.cl');
                        mail.setsubject('@@@@ TELEVENTA ONCO - WS EQUIFAX');
                        mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Equifax, mayor detalle en el siguiente mensaje:<br><br>' + ERR_MENSAJE_EQUIWS + '<br><br>Línea: ' + ERR_LINEA_EQUIWS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                         
                        
                    }
                    
                    if(ERR_PRODONCOWS){
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'isaac.salazar@security.cl','sebastian.acevedo@security.cl','pamunoz@security.cl'};
                        mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                        mail.setReplyTo('isaac.salazar@security.cl');
                        mail.setsubject('@@@@ TELEVENTA ONCO - WS PRODUCTO ONCOLÓGICO');
                        mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Producto Oncológico, mayor detalle en el siguiente mensaje:<br><br>' + 
                                         ERR_MENSAJE_PRONCOWS + '<br><br>Línea: ' + ERR_LINEA_PRONCOWS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });                         
                        
                    }                    
                }                
            }            
        }

    }
    
    global void finish(Database.BatchableContext trabajo){
        system.debug('@@@@@ Ha finalizado trabajo gestor de consumos...');
    }     
    
}