/*******************************************************************************************
 *  NOMBRE                 : CLS_LlamadaWSonco
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - Gestiona llamadas a WS Vsecurity
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
public class CLS_LlamadaWSonco {
    
    //Método Obtener Ultimo Productoo y Tarifa Contratante
    @future(callout=true)
    public static void consultarDatosEquifaxOnco(string usuario, String rutPersona, String IdMC){
        
        string RutPersonaSinDV='';
        CampaignMember cm = new CampaignMember(); 
        String tipoCliente;
        Lead prospecto = null;
        String Resultado='';
        
        // Control errores
        boolean ERR_EQUIFAXWS = false;
        String ERR_MENSAJE_EQUIWS = '', ERR_LINEA_EQUIWS = '';
        
        boolean ERR_PRODONCOWS = false;  
        String ERR_MENSAJE_PRONCOWS = '', ERR_LINEA_PRONCOWS = '';        
        
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
                  	MCAPM_Carga_Primer_Nombre__c, WS_Tiene_Producto_Oncologico__c, MCAMP_Tipo_Cliente__c, MCAMP_Actualizar_Nuevo_Cliente__c,
                    MCAMP_Tipo_Producto__c
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
            
            OBJ_WS_ConsultaPersona objConsulta;

            if(!Test.isRunningTest())
            {
                objConsulta = EXT_WS_ConsultaPersona.DatosPersona(rutPersona);
            }
            else
            {
                objConsulta = new OBJ_WS_ConsultaPersona();
                objConsulta.RUT = '15045517-0';
                objConsulta.Nombres = 'Juan';
                objConsulta.Apellido_Paterno = 'Espinoza';
                objConsulta.Apellido_Materno = 'Leon';
                objConsulta.Fecha_Nacimiento = '1982-04-11';
            } 
            
            system.debug('@@@@ objConsulta.Nombres=> ' + objConsulta.Nombres);
            cm.MCAPM_Carga_Primer_Nombre__c = objConsulta.Nombres;
            
            system.debug('@@@@ objConsulta.Apellido_Paterno => ' + objConsulta.Apellido_Paterno);
            cm.MCAMP_Carga_Apellido_Paterno__c = objConsulta.Apellido_Paterno;
            
            system.debug('@@@@ objConsulta.Apellido_Materno => ' + objConsulta.Apellido_Materno);
            cm.MCAMP_Carga_Apellido_Materno__c = objConsulta.Apellido_Materno;
           
            system.debug('@@@@ objConsulta.Nombres=> ' + objConsulta.Nombres);
            cm.MCAPM_Carga_Primer_Nombre__c = objConsulta.Nombres;
            
            system.debug('@@@@ objConsulta.Apellido_Paterno => ' + objConsulta.Apellido_Paterno);
            cm.MCAMP_Carga_Apellido_Paterno__c = objConsulta.Apellido_Paterno;
            
            system.debug('@@@@ objConsulta.Apellido_Materno => ' + objConsulta.Apellido_Materno);
            cm.MCAMP_Carga_Apellido_Materno__c = objConsulta.Apellido_Materno;
            
            cm.MCAMP_Carga_Fecha_Nacimiento__c = Date.valueOf(objConsulta.Fecha_Nacimiento);  
                        

            if(prospecto != null){
                system.debug('@@@@ LEAD PARA ACTUALIZAR CON WS CONSULTA PERSONA => ' + prospecto);
                prospecto.FirstName = cm.MCAPM_Carga_Primer_Nombre__c;
                prospecto.LastName = cm.MCAMP_Carga_Apellido_Paterno__c;
                prospecto.PROSP_Carga_Apellido_Materno__c = cm.MCAMP_Carga_Apellido_Materno__c;
                prospecto.PROSPE_Carga_Fecha_Nacimiento__c = cm.MCAMP_Carga_Fecha_Nacimiento__c;
                
                //update prospecto;
                system.debug('@@@@ LEAD ACTUALIZADO WS CONSULTA PERSONA => ' + prospecto);
            }
           
            
            //Validación de consumo WS Equifax...
            cm.MCAMP_WS_Equifax_Consumido__c = true; 
            
            cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Consulta Persona: Procesado correctamente';
            
        }catch(system.CalloutException cout_equifax){            
            
            system.debug('@@@@ ERROR - CONSULTA DATOS WS CONSULTA PERSONA | TARIFICACION WS                                ');
            system.debug('@@@@ *******************************************************************************************');
            system.debug('@@@@ MENSAJE: ' + cout_equifax.getMessage());
            system.debug('@@@@ LINEA: ' + cout_equifax.getLineNumber());
            
            ERR_EQUIFAXWS = true;
            ERR_MENSAJE_EQUIWS = cout_equifax.getMessage();
            ERR_LINEA_EQUIWS = String.ValueOf(cout_equifax.getLineNumber());      
            
            cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Consulta Persona: Imposible procesar llamada a Consulta Persona.';                        
            
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
                EXT_WS_Oncologico.WsProductoOncologicoSoap cnx1 = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
                EXT_WS_Oncologico.ArrayOfProductoOncologico pOnco = new EXT_WS_Oncologico.ArrayOfProductoOncologico(); 
                EXT_WS_Oncologico.UsuarioValido resValidaUsu = new EXT_WS_Oncologico.UsuarioValido();            
                
                if(!Test.isRunningTest()){
                
                    pOnco = cnx1.GetUltimoProducto(usuario, integer.valueOf(cm.MCAMP_Tipo_Producto__c), tipoCliente);
                
                }else{
                
                    EXT_WS_Oncologico.ProductoOncologico prOnco = new EXT_WS_Oncologico.ProductoOncologico();
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
                    
                    List<EXT_WS_Oncologico.ProductoOncologico> lsprOnco = new List<EXT_WS_Oncologico.ProductoOncologico>();
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
                
                for(EXT_WS_Oncologico.ProductoOncologico p : pOnco.ProductoOncologico){
                        cm.MCAMP_Plan__c = p.CodPlan;
                        cm.MCAMP_Revision__c = p.RevPlan;
                        cm.MCAMP_Ramo__c = p.CodRamoPlan;
                        cm.MCAMP_Codigo_Producto__c = p.CodProd;
                        cm.MCAMP_Tipo_Folio__c = p.TipoFolio;
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

                    cm.MCAMP_Es_Asegurable__c = USU_Asegurable;
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidacionUsuarioPorFecNac: Procesado correctamente';

                    EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element res2 = new EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element();
                    string codCobert = '';
                    if( cm.MCAMP_Tipo_Producto__c == '19' ){
                        codCobert = 'CSON';
                    }

                    if( cm.MCAMP_Tipo_Producto__c == '66' ){
                        codCobert = 'CAMA';
                    }

                    if (!Test.isRunningTest()) {

                        system.debug('@@@@ USUARIO           => ' + usuario);
                        system.debug('@@@@ RAMO              => ' + cm.MCAMP_Ramo__c);
                        system.debug('@@@@ COD PRODUCTO      => ' + cm.MCAMP_Codigo_Producto__c);
                        system.debug('@@@@ PLAN              => ' + cm.MCAMP_Plan__c);
                        system.debug('@@@@ REVISION          => ' + cm.MCAMP_Revision__c);
                        system.debug('@@@@ COD COBERTURA     => ' + codCobert);
                        system.debug('@@@@ RUT               => ' + RutPersonaSinDV);
                        system.debug('@@@@ FECHA NACIMIENTO  => ' + fnac);
                        res2.ValidaAseguradoOncoResult = cnx1.ValidaAseguradoOnco(usuario, cm.MCAMP_Ramo__c, cm.MCAMP_Codigo_Producto__c, cm.MCAMP_Plan__c, cm.MCAMP_Revision__c, codCobert, Integer.valueOf(RutPersonaSinDV), fnac);

                    } else {

                        res2.ValidaAseguradoOncoResult = 'S';

                    }

                    system.debug('@@@@ RETORNO VALIDACION PRODUCTO ONCOLOGICO =>' + res2.ValidaAseguradoOncoResult);
                    if (res2.ValidaAseguradoOncoResult == null){
                        cm.WS_Tiene_Producto_Oncologico__c = false; 
                    }else{
                        cm.WS_Tiene_Producto_Oncologico__c = res2.ValidaAseguradoOncoResult == 'N';
                    }
                    
                    // Validación llamada a método ValidaCliente (APEG)...
                    if( res2.ValidaAseguradoOncoResult == 'S' && cm.MCAMP_Tipo_Producto__c == '66' ){

                        integer CodigoValidacionClienteAPEG = cnx1.ValidaCliente(usuario,Integer.valueOf(RutPersonaSinDV),cm.MCAMP_Carga_Dv__c);
                        system.debug('@@@@ CÓDIGO VALIDACIÓN CLIENTE APEG => ' + CodigoValidacionClienteAPEG);
                        if( CodigoValidacionClienteAPEG == 0 ){
                            cm.MCAMP_Es_Asegurable__c = 'N';
                        }
                        if( CodigoValidacionClienteAPEG == 1 ){
                            cm.MCAMP_Es_Asegurable__c = 'S';
                        }

                        cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidaCliente: Procesado correctamente';            

                    }                    

                    if (cm.WS_Tiene_Producto_Oncologico__c) {
                        cm.MCAMP_Es_Asegurable__c = 'N';
                    }
                    system.debug('@@@@ RETORNO ES ASEGURADO =>' + cm.MCAMP_Es_Asegurable__c);

                    if (Test.isRunningTest()) {
                        cm.MCAMP_Es_Asegurable__c = 'S';
                    }

                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidaAseguradoOnco: Procesado correctamente';

                    if(cm.MCAMP_Es_Asegurable__c == 'S'){
                        //Creación instancia de respuesta para Tarificación de Contratante...
                        EXT_WS_Oncologico.Tarificacion resTarMC = new EXT_WS_Oncologico.Tarificacion();  
                        
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
                        cm.MCAMP_Tipo_de_Cambio_UF__c = restarMC.ValorUF;
                        
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
               
                system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA WS  CONSULTA PERSONA | TARIFICACION WS                                ');
                system.debug('@@@@ *******************************************************************************************');
                system.debug('@@@@ MENSAJE: ' + cout_wsprodonco.getMessage());
                system.debug('@@@@ LINEA: ' + cout_wsprodonco.getLineNumber()); 
                
                ERR_PRODONCOWS = false;  
                ERR_MENSAJE_PRONCOWS = cout_wsprodonco.getMessage();
                ERR_LINEA_PRONCOWS = String.valueOf(cout_wsprodonco.getLineNumber());
                
                cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - Producto Oncológico: Imposible procesar llamada a WS Producto oncológico.';
                
            }finally{
                
                if(cm.MCAMP_Actualizar_Nuevo_Cliente__c){
                    cm.MCAMP_Actualizar_Nuevo_Cliente__c = false;
                }
                
                cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nProceso carga/integración del registro finalizado';
                update cm;
                
                if(ERR_EQUIFAXWS){
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {'juespinoza@security.cl'};
                        mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                    mail.setReplyTo('juespinoza@security.cl');
                    mail.setsubject('@@@@ TELEVENTA ONCO - WS EQUIFAX');
                    mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Consulta Persona, mayor detalle en el siguiente mensaje:<br><br>' + ERR_MENSAJE_EQUIWS + '<br><br>Línea: ' + ERR_LINEA_EQUIWS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                }
                
                if(ERR_PRODONCOWS){
                    
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[] {'juespinoza@security.cl'};
                        mail.setToAddresses(toAddresses);
                    mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                    mail.setReplyTo('juespinoza@security.cl');
                    mail.setsubject('@@@@ TELEVENTA ONCO - WS PRODUCTO ONCOLÓGICO');
                    mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Producto Oncológico, mayor detalle en el siguiente mensaje:<br><br>' + 
                                     ERR_MENSAJE_PRONCOWS + '<br><br>Línea: ' + ERR_LINEA_PRONCOWS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
                }                
                
            }   
            
        }
        
    }
   
    //Método Obtener Regiones, Ciudades y Comunas desde WS para actualizar DB
    /*
    @future(callout=true)
    public static void cargaRegionesCiudadesComunasSF(){
        
        try{
            String usuario = '1-1';
            CLS_WSprodonco.WsProductoOncologicoSoap cnx = new CLS_WSprodonco.WsProductoOncologicoSoap();
            
            //Estructura de Regiones...
            CLS_WSprodonco.ArrayOfRegion ARR_Regiones = new CLS_WSprodonco.ArrayOfRegion();
            List<CLS_WSprodonco.Region> regiones = new List<CLS_WSprodonco.Region>();
            
            if(!Test.isRunningTest()){
            	
                ARR_Regiones = cnx.ObtenerListadoRegion(usuario);
                
            }else{
                                
                CLS_WSprodonco.Region reg1 = new CLS_WSprodonco.Region();
                reg1.Codigo = '013';
                reg1.Descripcion = 'REGION METROPOLITANA DE SANTIAGO';
                
                List<CLS_WSprodonco.Region> lsregiones = new List<CLS_WSprodonco.Region>();
                lsregiones.add(reg1);
                
                ARR_Regiones.Region = lsregiones;
                
            }
            
            //Estructura de Ciudades...
            CLS_WSprodonco.ArrayOfCiudad ARR_Ciudades = new CLS_WSprodonco.ArrayOfCiudad();
            List<CLS_WSprodonco.Ciudad> ciudades = new List<CLS_WSprodonco.Ciudad>();
            
            if(!Test.isRunningTest()){
            
                ARR_Ciudades = cnx.ObtenerListadoCiudad(usuario, ''); 
                
            }else{
                
                CLS_WSprodonco.Ciudad ciu1 = new CLS_WSprodonco.Ciudad();
                ciu1.CodigoCiudad = '605';
                ciu1.CodigoCiudadTel = '2';
                ciu1.CodigoRegion = '013';
                ciu1.CodigoSucursal = '000014';
                ciu1.DescCiudad = 'SANTIAGO';
                
                List<CLS_WSprodonco.Ciudad> lsciudades = new List<CLS_WSprodonco.Ciudad>();
                lsciudades.add(ciu1);
                
                ARR_Ciudades.Ciudad = lsciudades;
                
            }
            
            //Estructura de Comunas...
            CLS_WSprodonco.ArrayOfComuna ARR_Comunas = new CLS_WSprodonco.ArrayOfComuna();
            List<CLS_WSprodonco.Comuna> comunas = new List<CLS_WSprodonco.Comuna>();
            ARR_Comunas = cnx.ObtenerListadoComuna(usuario, '');             
            
            regiones = ARR_Regiones.Region;
            if (regiones==null)
            {
               regiones= new List<CLS_WSprodonco.Region>();
            }
            if(Test.isRunningTest())
            {
              CLS_WSprodonco.Region reg= new CLS_WSprodonco.Region();
                reg.Descripcion='p';
                reg.Descripcion='c';
               regiones.add(reg);
            }
            List<Region__c> regionesSF = new List<Region__c>();
            for(CLS_WSprodonco.Region r : regiones){
                Region__c rSF = new Region__c();
                rSF.Name = r.Descripcion;
                rSF.REGI_C_digo__c = r.Codigo;
                regionesSF.add(rSF);
            }
            system.debug('@@@@ REGIONES WS => ' + regionesSF);
            if(regionesSF.size() > 0){
                if (!Test.isRunningTest())
                {
                	upsert regionesSF REGI_C_digo__c;    
                }
            } 
            
            ciudades = ARR_Ciudades.Ciudad;
            List<Ciudad__c> ciudadesSF = new List<Ciudad__c>();
            if (ciudades==null)
            {
                 ciudades= new List<CLS_WSprodonco.Ciudad>();
            }
            for(CLS_WSprodonco.Ciudad ci : ciudades){
                Ciudad__c ciSF = new Ciudad__c();
                ciSF.Name = ci.DescCiudad;
                ciSF.CIUD_C_digo__c = ci.CodigoCiudad;
                ciSF.CIUD_Codigo_Region__c = ci.CodigoRegion;
                ciSF.CIUD_Codigo_Sucursal__c = ci.CodigoSucursal;
                ciSF.CIUD_Codigo_Telefono__c = ci.CodigoCiudadTel;
                
                for(Region__c reg : regionesSF){
                    if(reg.REGI_C_digo__c == ci.CodigoRegion){
                        ciSF.CIUD_Region__c = reg.Id;
                    }
                }

                ciudadesSF.add(ciSF);
            }
            system.debug('@@@@ CIUDADES WS => ' + ciudadesSF);
            if(ciudadesSF.size() > 0){
                for(Ciudad__c ciu : ciudadesSF){
                    system.debug('@@@@ CIUDAD => ' + ciu.Name + ', REGION => ' + ciu.CIUD_Region__c);
                }
                //upsert ciudadesSF CIUD_C_digo__c;
                Database.upsert(ciudadesSF, Ciudad__c.CIUD_C_digo__c, false);
            }
            
            comunas = ARR_Comunas.Comuna;
            if (comunas==null)
            {
               comunas= new List< CLS_WSprodonco.Comuna>();
            }
            List<Comuna__c> comunasSF = new List<Comuna__c>();
            for(CLS_WSprodonco.Comuna co : comunas){
                Comuna__c coSF = new Comuna__c();
				coSF.Name = co.DescComuna;
                coSF.COMU_Codigo_Comuna__c = co.CodComuna;
                coSF.COMU_C_digo_Ciudad__c = co.CodCiudad;
                coSF.COMU_C_digo_Regi_n__c = co.CodEstado;
                
                for(Ciudad__c ciud : ciudadesSF){
                    if(ciud.CIUD_C_digo__c == co.CodCiudad){
                        coSF.COMU_Ciudad__c = ciud.Id;
                    }
                }
                
                for(Region__c regi : regionesSF){
                    if(regi.REGI_C_digo__c == co.CodEstado){
                        coSF.COMU_Region__c = regi.Id;
                    }   					
                }                

                comunasSF.add(coSF);
            }
            system.debug('@@@@ COMUNAS WS => ' + comunasSF);
            if(comunasSF.size() > 0){
                for(Comuna__c com : comunasSF){
                    system.debug('@@@@ COMUNA => ' + com.Name);
                }
                //upsert ciudadesSF CIUD_C_digo__c;
                Database.upsert(comunasSF, Comuna__c.COMU_Codigo_Comuna__c, false);
            }
            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR - GENERAR LISTA REGIONES, CIUDADES o COMUNAS WS                                    ');
            system.debug('@@@@ *********************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA: ' + ex.getLineNumber());            
        }
    }*/
    
    //Método Obtener Lista Regiones WS
    /*
    @future(callout=true)
    public static void generarListaRegiones(string usuario){
        
        try{
            CLS_WSprodonco.WsProductoOncologicoSoap cnx = new CLS_WSprodonco.WsProductoOncologicoSoap();
            CLS_WSprodonco.ArrayOfRegion ARR_Regiones = new CLS_WSprodonco.ArrayOfRegion();
            List<CLS_WSprodonco.Region> regiones = new List<CLS_WSprodonco.Region>();
            List<Region__c> regionesSF = new List<Region__c>();
            if(!Test.isRunningTest()){
                ARR_Regiones = cnx.ObtenerListadoRegion(usuario);
                regiones = ARR_Regiones.Region;                
                for(CLS_WSprodonco.Region r : regiones){
                    Region__c rSF = new Region__c();
                    rSF.Name = r.Descripcion;
                    rSF.REGI_C_digo__c = r.Codigo;
                    regionesSF.add(rSF);
                }
            }else{
                Region__c r1 = new Region__c();
                r1.Name = '';
                r1.REGI_C_digo__c = '';
                
                Region__c r2 = new Region__c();
                r2.Name = '';
                r2.REGI_C_digo__c = '';
                
                Region__c r3 = new Region__c();
                r3.Name = '';
                r3.REGI_C_digo__c = '';
                
                regionesSF.add(r1);
                regionesSF.add(r2);
                regionesSF.add(r3);
            }
            system.debug('@@@@ REGIONES WS => ' + regionesSF);
            if(regionesSF.size() > 0){
                Database.upsert(regionesSF);
            }

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR - GENERAR LISTA REGIONES WS                                    ');
            system.debug('@@@@ *********************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA: ' + ex.getLineNumber());            
        }
    }*/
    
    //Método Obtener Lista Regiones WS
    /*
    @future(callout=true)
    public static void generarListaCiudades(string usuario,string region){
        
        try{
            if(region != '' && region != '000'){
                CLS_WSprodonco.WsProductoOncologicoSoap cnx = new CLS_WSprodonco.WsProductoOncologicoSoap();
                CLS_WSprodonco.ArrayOfCiudad ARR_Ciudades = new CLS_WSprodonco.ArrayOfCiudad();
                List<CLS_WSprodonco.Ciudad> ciudades = new List<CLS_WSprodonco.Ciudad>();
                if( !Test.isRunningTest() ){
                    ARR_Ciudades = cnx.ObtenerListadoCiudad(usuario, region);
                    ciudades = ARR_Ciudades.Ciudad;
                }else{
                    CLS_WSprodonco.Ciudad c1 = new CLS_WSprodonco.Ciudad();
                    c1.CodigoCiudad = '511';
                    c1.CodigoRegion = '013';
                    c1.CodigoSucursal = '00006';
                    c1.DescCiudad = 'Ciudad 1';
                    ciudades.add(c1);
                }
                List<Ciudad__c> ciudadesSF = new List<Ciudad__c>();
                
                if(ciudades==null)
                {
                    ciudades = new List<CLS_WSprodonco.Ciudad>();
                }
                
                for(CLS_WSprodonco.Ciudad c : ciudades){
                    Ciudad__c cSF = new Ciudad__c();
                    cSF.Name = c.DescCiudad;
                    cSF.CIUD_C_digo__c = c.CodigoCiudad;
                    cSF.CIUD_Codigo_Region__c = c.CodigoRegion;
                    cSF.CIUD_Codigo_Sucursal__c = c.CodigoSucursal;
                    cSF.CIUD_Codigo_Telefono__c = c.CodigoCiudadTel;
                    ciudadesSF.add(cSF);
                }
                
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR - GENERAR LISTA REGIONES WS                                    ');
            system.debug('@@@@ *********************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA: ' + ex.getLineNumber());            
        }
    }*/   
    
    //Clase RESPjson para descomponer respuestas JSON WS
    public class RESPjson{
        
        public string Codigo;
        public string Descripcion;
        
        public RESPjson(string Codigo, string Descripcion){
            
            this.Codigo = Codigo;
            this.Descripcion = Descripcion;
            
        }
        
        public RESPjson(){}
    }
    
    //Método Actulizar Datos Propuesta WS (SF a Backoffice Oncológico)
    @future(callout=true)
    public static void actualizarPropuestaOnco(String usuario, String nPropuesta){
       
        system.debug('@@@@ ENTRADA actualizarPropuestaOnco nPropuesta:' + nPropuesta);
        
        try{
            if(nPropuesta != '' && nPropuesta != null){
                
                // Recuperar datos de propuesta SF (Oportunidad)...
                Opportunity pro = new Opportunity();
                 
                pro = [SELECT Id, IsDeleted, AccountId, RecordTypeId, Name, Description, StageName, Amount, 
                       		  Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, 
                              ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, 
                              CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                              LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, LastViewedDate, LastReferencedDate, 
                              HasOpenActivity, HasOverdueTask, DB_Competitor__c, Codigo_Periodo_Pago__c, 
                              OPOR_Codigo_Banco__c, OPOR_Codigo_Canal__c, OPOR_Codigo_Moneda__c, OPOR_Codigo_Plan__c, 
                              OPOR_Codigo_Producto__c, OPOR_Codigo_Ramo__c, OPOR_Codigo_Sucursal__c, OPOR_Codigo_Tarjeta__c, 
                              OPOR_Estado_Propuesta__c, OPOR_Fecha_Vencimiento__c, OPOR_Folio_SF_Propuesta__c, OPOR_ID_Campa_a_SF__c, 
                              OPOR_Id_Poliza_Asociada__c, OPOR_N_Cuenta__c, OPOR_N_Propuesta__c, OPOR_Porcentaje_Riesgo__c, 
                              OPOR_Revision_Plan__c, OPOR_Tipo_Folio__c, OPOR_Tipo_Forma_Pago__c, OPOR_Usuario__c, 
                              rrpu__Alert_Message__c, OPOR_Comentario_Actualizaci_n_Propuesta__c, OPOR_Motivo_de_Rechazo_o_Perdida__c 
                       FROM Opportunity
                       WHERE Id =: nPropuesta];                
                
                // Generando instancias de objetos WS
                EXT_WS_Oncologico_Ope.WsProductoOncologicoOperSoap cnx = new EXT_WS_Oncologico_Ope.WsProductoOncologicoOperSoap();                
                EXT_WS_Oncologico_Ope.DatosProspecto datProsp = new EXT_WS_Oncologico_Ope.DatosProspecto();
                EXT_WS_Oncologico_Ope.Propuesta ws_prop = new EXT_WS_Oncologico_Ope.Propuesta();
                EXT_WS_Oncologico_Ope.FormaPago ws_fpago = new EXT_WS_Oncologico_Ope.FormaPago();
                List<EXT_WS_Oncologico_Ope.Persona> ws_lpersona = new List<EXT_WS_Oncologico_Ope.Persona>();
                List<EXT_WS_Oncologico_Ope.ContratantePropuesta> ws_lcontra = new List<EXT_WS_Oncologico_Ope.ContratantePropuesta>();
                List<EXT_WS_Oncologico_Ope.Beneficiario> ws_lbene = new List<EXT_WS_Oncologico_Ope.Beneficiario>();
                List<EXT_WS_Oncologico_Ope.Asegurado> ws_laseg = new List<EXT_WS_Oncologico_Ope.Asegurado>();
                List<EXT_WS_Oncologico_Ope.Cobertura> ws_lcobertura = new List<EXT_WS_Oncologico_Ope.Cobertura>();
                List<EXT_WS_Oncologico_Ope.Intermediario> ws_linter = new List<EXT_WS_Oncologico_Ope.Intermediario>();                
                EXT_WS_Oncologico_Ope.ArrayOfPersona ws_arrPerson = new EXT_WS_Oncologico_Ope.ArrayOfPersona();
                EXT_WS_Oncologico_Ope.ArrayOfContratantePropuesta ws_arrcontra = new EXT_WS_Oncologico_Ope.ArrayOfContratantePropuesta();
                EXT_WS_Oncologico_Ope.ArrayOfBeneficiario ws_arrBene = new EXT_WS_Oncologico_Ope.ArrayOfBeneficiario();
                EXT_WS_Oncologico_Ope.ArrayOfAsegurado ws_arrAseg = new EXT_WS_Oncologico_Ope.ArrayOfAsegurado();
                EXT_WS_Oncologico_Ope.ArrayOfCobertura ws_arrCobertura= new EXT_WS_Oncologico_Ope.ArrayOfCobertura();
                EXT_WS_Oncologico_Ope.ArrayOfIntermediario ws_arrInter = new EXT_WS_Oncologico_Ope.ArrayOfIntermediario();
                
                // Asociación Datos Propuesta....
                ws_prop.CodCanal = Integer.valueOf(pro.OPOR_Codigo_Canal__c);
                ws_prop.CodMoneda = pro.OPOR_Codigo_Moneda__c;
                ws_prop.CodPeriodoPago = pro.Codigo_Periodo_Pago__c;
                ws_prop.CodPlan = pro.OPOR_Codigo_Plan__c;
                ws_prop.CodProd = pro.OPOR_Codigo_Producto__c;
                ws_prop.CodRamo = pro.OPOR_Codigo_Ramo__c;
                ws_prop.CodSucursal = pro.OPOR_Codigo_Sucursal__c;
                ws_prop.EstadoPropuesta = pro.OPOR_Estado_Propuesta__c;
                ws_prop.IdCampania = pro.OPOR_ID_Campa_a_SF__c;
                ws_prop.IdExterno = pro.OPOR_Folio_SF_Propuesta__c;
                ws_prop.NumPropuesta = Integer.valueOf(pro.OPOR_N_Propuesta__c);
                ws_prop.Origen = pro.LeadSource;
                ws_prop.PorcRiesgo = pro.OPOR_Porcentaje_Riesgo__c;
                ws_prop.RevPlan = pro.OPOR_Revision_Plan__c;
                ws_prop.TipoFolio = Integer.valueOf(pro.OPOR_Tipo_Folio__c);
                ws_prop.Usuario = pro.OPOR_Usuario__c;
                
                //Datos forma pago..
                ws_fpago.CodBanco = pro.OPOR_Codigo_Banco__c;
                ws_fpago.CodTarjeta = pro.OPOR_Codigo_Tarjeta__c;
                ws_fpago.FechaVencimiento = pro.OPOR_Fecha_Vencimiento__c;
                if(pro.OPOR_Id_Poliza_Asociada__c != null){
                	ws_fpago.IdPolizaAsoc = Integer.valueOf(pro.OPOR_Id_Poliza_Asociada__c);
                }
                ws_fpago.NumeroCuenta = pro.OPOR_N_Cuenta__c;
                ws_fpago.Propuesta = Integer.valueOf(pro.OPOR_N_Propuesta__c);
                ws_fpago.TipoFolio = Integer.valueOf(pro.OPOR_Tipo_Folio__c);
                ws_fpago.TipoFormaPago = pro.OPOR_Tipo_Forma_Pago__c;
				
                // Recuperando Registros de Contratante asociado a Propuesta en SF
                Contratante__c Contratante= [SELECT Id, name,
                                                        CONTRA_Codigo_Region__c, 
                                                        CONTRA_Codigo_Comuna__c,
                                                        CONTRA_Codigo_Ciudad__c ,
                                             			CONTRA_Apellido_Materno__c,
                                             			CONTRA_Apellido_Paterno__c,
                                                        CONTRA_Propuesta__c ,
                                                        CONTRA_Rut__c,
                                                        CONTRA_Dv__c,
                                                        CONTRA_Email_1__c,
                                                        CONTRA_Email_2__c,
                                                        CONTRA_Telefono_1__c,
                                                        CONTRA_Telefono_2__c,
                                                        CONTRA_Direccion__c,
                                                        CONTRA_Fecha_de_Nacimiento__c
                                             FROM Contratante__c
                                             WHERE CONTRA_Propuesta__c=:pro.Id Limit 1];                
                
                system.debug('@@@@ Contratante PROPUESTA => ' + Contratante);
				
                // Instancia nueva objeto contratante WS
                EXT_WS_Oncologico_Ope.ContratantePropuesta ws_Contratante = new EXT_WS_Oncologico_Ope.ContratantePropuesta();
                
                // Asociación datos contratante
                ws_Contratante.Propuesta = Integer.valueOf(pro.OPOR_N_Propuesta__c);
                ws_Contratante.Rut = Integer.valueOf(Contratante.CONTRA_Rut__c);
                ws_Contratante.TipoFolio = Integer.valueOf(pro.OPOR_Tipo_Folio__c);
                
                // Agregar elemento contratante a lista contrantes WS
                ws_lcontra.add(ws_Contratante);
                
                // Recuperando lista de personas en SF
               	List<Persona__c> ListaPersonas = [SELECT id,
                                               			 name,
                                              			 PERSO_Rut__c,
                                              			 PERSO_Dv__c,
                                              			 PERSO_Apellido_Materno__c,
                                              			 PERSO_Apellido_Paterno__c,
                                              			 PERSO_Fecha_de_Nacimiento__c,
                                                  		 PERSO_Mail__c
                                                  FROM Persona__c 
                                                  WHERE PERSO_ID_SF_Propuesta__c =: pro.Id ];
                
                // Recorrer lista de personas asociadas a Propuesta SF..
				for(Persona__c a: ListaPersonas)
                {
                    
                    // Instancia nueva persona WService
                    EXT_WS_Oncologico_Ope.Persona ws_Persona = new EXT_WS_Oncologico_Ope.Persona();
                    
                    // Asociación datos personas SF combinados con datos de contacto contratante SF
                    ws_Persona.Rut = Integer.valueOf(a.PERSO_Rut__c);
                    ws_Persona.Dv =  a.PERSO_Dv__c;
                    ws_Persona.ApellidoMaterno = a.PERSO_Apellido_Materno__c;
                    ws_Persona.ApellidoPaterno = a.PERSO_Apellido_Paterno__c;
                    ws_Persona.Direccion = Contratante.CONTRA_Direccion__c;
                    ws_Persona.TelefonoFijo = Contratante.CONTRA_Telefono_1__c;
                    ws_Persona.TelefonoMovil = Contratante.CONTRA_Telefono_2__c;
                    ws_Persona.FechaNacimiento = a.PERSO_Fecha_de_Nacimiento__c;
                    ws_Persona.Mail = a.PERSO_Mail__c;
                    ws_Persona.Nombres = a.Name;
                    ws_Persona.CodCiudad = Contratante.CONTRA_Codigo_Ciudad__c;
                    ws_Persona.CodComuna = Contratante.CONTRA_Codigo_Comuna__c;
                    ws_Persona.CodRegion = Contratante.CONTRA_Codigo_Region__c;
                    
                    // Agregar elemento Persona a Lista Personas WS
                    ws_lpersona.add(ws_Persona);
                    
                }
                
                // Seguimiento lista personas ws
                system.debug('@@@@ Personas WS PROPUESTA => ' + ws_lpersona);

                // Recuperar lista de coberturas de Propuesta en SF
                List<Cobertura2__c> ListaCoberturas = [SELECT Id,
                                                       		  name,
                                                       		  COB_Capital_Asegurado__c,
                                                       		  COB_Codigo_Cobertura__c,
                                                       		  COB_Dv__c,
                                                       		  COB_Fecha_de_Nacimiento__c,
                                                       		  COB_Impuestos__c,
                                                       		  COB_Impuestos_Local__c,
                                                     		  COB_Prima_Neta__c,
                                                     		  COB_Prima_Neta_Local__c,
                                                     		  COB_Propuesta__c,
                                                     		  COB_Rut__c,
                                                     		  COB_Tasa_Cambio__c,
                                                     		  COB_Tasa_Prima__c,
                                                     		  COB_Tipo_de_Folio__c	
                                                     	FROM Cobertura2__c 
                                                       	WHERE COB_Propuesta__c=:pro.Id];
                
                
                // Recorrer coberturas en SF
                for(Cobertura2__c cobertura : ListaCoberturas)
                {
                    
                    // Instancia objeto cobertura WS
                    EXT_WS_Oncologico_Ope.Cobertura  ws_Cobertura = new EXT_WS_Oncologico_Ope.Cobertura();
                	
                    // Asociación datos de cobertura
                    ws_Cobertura.CapitalAsegurado=cobertura.COB_Capital_Asegurado__c;
                    ws_Cobertura.CodCobert=cobertura.COB_Codigo_Cobertura__c;
                    ws_Cobertura.Impuestos=cobertura.COB_Impuestos__c;
                    ws_Cobertura.ImpuestosLocal=cobertura.COB_Impuestos_Local__c;
                    ws_Cobertura.PrimaNeta=cobertura.COB_Prima_Neta__c;
                    ws_Cobertura.PrimaNetaLocal=cobertura.COB_Prima_Neta_Local__c;
                    ws_Cobertura.Propuesta=Integer.valueOf( pro.OPOR_N_Propuesta__c );
                    ws_Cobertura.Rut=Integer.valueOf( cobertura.COB_Rut__c );
                	ws_Cobertura.TasaCambio=  cobertura.COB_Tasa_Cambio__c ;
                    ws_Cobertura.TasaPrima= cobertura.COB_Tasa_Prima__c ;
                    ws_Cobertura.TipoFolio= Integer.valueOf(cobertura.COB_Tipo_de_Folio__c) ;
                    
                    // Agregando elemento cobertura a lista coberturas WS
                    ws_lcobertura.add(ws_Cobertura);
                    
                }
                
                // Seguimiento lista coberturas ws
                system.debug('@@@@ Coberturas WS PROPUESTA => ' + ws_lcobertura);                
            
                // Asignación lista de objetos ws a arreglos ws
				ws_arrPerson.Persona = ws_lpersona;                
                ws_arrcontra.ContratantePropuesta = ws_lcontra;
                ws_arrBene.Beneficiario = ws_lBene;
                ws_arrAseg.Asegurado = ws_lAseg;
                ws_arrCobertura.Cobertura = ws_lcobertura;
                ws_arrInter.Intermediario = ws_lInter;
                
                //Asociar objetos y arreglos a Datos Prospecto...
                datProsp.Propuesta = ws_prop;
                datProsp.FormPago = ws_fpago;
                datProsp.LsPersona = ws_arrPerson;
                datProsp.LsContratante = ws_arrcontra;
                datProsp.LsBeneficiario = ws_arrBene;
                datProsp.LsAsegurado = ws_arrAseg;
                datProsp.LsCobertura = ws_arrCobertura;
                datProsp.LsIntermediario = ws_arrInter;
                    
                system.debug('@@@@ WS ACTUALIZA DATOS PROPUESTA => ' + datProsp);
                String respuesta;
                
                // Llamada a Método Web (WS) para actualizar datos prospecto
                if( !Test.isRunningTest() ){
                	respuesta = cnx.ActualizaDatosPropuesta(usuario, datProsp);
                }else{
                    respuesta = '{"Codigo":200,"Descripcion":"La póliza se ha activado correctamente."}';
                }
                system.debug('@@@@ RESPUESTA WS ACTUALIZA DATOS PROPUESTA => ' + respuesta);
                                
                //{"Codigo":200,"Descripcion":"La póliza se ha activado correctamente."}
                RESPjson respFINAL=null;                   
                respFINAL = (RESPjson)JSON.deserialize(respuesta,RESPjson.class);              
				
                system.debug('@@@@ RESPUESTA FORMATEADA => ' + respFINAL);                
                
                if(respFINAL.Codigo != '200'){
                    
                    pro.StageName = 'Venta - Pendiente Validar';
                	pro.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'NO SE PUDO ACTIVAR PÓLIZA...';
                    
                }else{
                    if (pro.StageName=='Venta - Aprobada'){
                    	pro.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'PÓLIZA ACTIVA...';  
                        pro.OPOR_WS_Actualiza_Datos_Prospecto__c = true;
                    }else{
                        pro.OPOR_Comentario_Actualizaci_n_Propuesta__c = '';
                    }
                    
                }
                update pro;

            }
        }
        catch(Exception ex){

            system.debug('@@@@ ERROR - ACTUALIZAR PROPUESTA SF A BACKOFFICE ONCO WS                 ');
            system.debug('@@@@ *********************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA:   ' + ex.getLineNumber()); 
     
        }        
        
    }
    
}