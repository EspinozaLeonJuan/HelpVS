/*******************************************************************************************
 *  NOMBRE                 : CLS_CotizadorController
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Gestiona VF Cotizador Express Oncológico
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 *  1.1     - 01/03/2019 - VIDA             - Nuevos Teléfonos en carga
 *  1.2     - 15/05/2019 - I.SALAZAR        - APEG
 * *****************************************************************************************/        
global class CLS_CotizadorController {

    public String TipoProducto {get; set;}

    public String idTarea {get; set;}
    public Task TAREA_Contratante {get; set;}
    public Account CUENTA_Contratante {get; set;}
    public CampaignMember MC_CLIENTE {get; set;}
    public ParametroDigitador PD_Digitador {get;  set;}
    public String cargaCliente {get; set;}
    
    public static String IDCANAL {get; set;}
    public static String URL_parametros {get; set;}
    public static Boolean activaBotonPD {get; set;}
    
    public static String UsuaroTvta {get; set;}
    public static String tipoCliente {get; set;}

    public static List<Region__c> LST_RegionesSF {public get; public set;}
    public static List<SelectOption> LST_Regiones {public get; public set;}
    public static List<SelectOption> LST_Ciudades {public get; public set;}
    public static Boolean VER_CAMPOCIUDAD {public get; public set;}
    public static List<SelectOption> LST_Comunas {public get; public set;}
    public static Boolean VER_CAMPOCOMUNA {public get; public set;}
    public static List<SelectOption> LST_Tarjetas {public get; public set;}
    public static String COD_TarjetaSeleccionada {public get; public set;}
       
    public static String COD_RegionSeleccionada {get; set;}
    public static String COD_CiudadSeleccionada {get; set;}
    public static String COD_ComunaSeleccionada {get; set;}
    public static String DireccionCliente {get; set;}
    public static Double TOTAL_UF {get; set;}
    public static Double TOTAL_CLP {get; set;}
    public static string Paso {get; set;}
    public static String Region {get; set;}
    public static String Ciudad {get; set;}
    public static String Comuna {get; set;}
    
	//Se agrega campo para concatenar teléfonos
    public static String TelefonosCliente { get; set; }
    public static String TelefonoCliente { get; set; }    

    public with sharing class ParametroDigitador{
        
        public string rutUsuario { get { return rutUsuario; } set { rutUsuario = value; } }
        public string dvUsuario { get { return dvUsuario; } set { dvUsuario = value; } }
        public string idCanal { get { return idCanal; } set { idCanal = value; } }
        public string rutCliente { get { return rutCliente; } set { rutCliente = value; } }
        public string idCampana { get { return idCampana; } set { idCampana = value; } }
        public string tipoFolio { get { return tipoFolio; } set { tipoFolio = value; } }
        public string poliza { get { return poliza; } set { poliza = value; } }
        public string idExterno { get { return idExterno; } set { idExterno = value; } }
        public string totalInic { get { return totalInic; } set { totalInic = value; } }
        public string preimpreso { get { return preimpreso; } set { preimpreso = value; } }
        public string direccion { get { return direccion; } set { direccion = value; } }
        public string mail { get { return mail; } set { mail = value; } }
        public string fono { get { return fono; } set { fono = value; } }
        public string celular { get { return celular; } set { celular = value; } }
        public string codComuna { get { return codComuna; } set { codComuna = value; } }
        public string codRegion { get { return codRegion; } set { codRegion = value; } }
        public string codCiudad { get { return codCiudad; } set { codCiudad = value; } }
        public string tipoCliente { get { return tipoCliente; } set { tipoCliente = value; } }
        public string persistencia { get { return persistencia; } set { persistencia = value; } }
        
        public ParametroDigitador(string rutUsuario,string dvUsuario,string idCanal,string rutCliente,string idCampana,string tipoFolio,
        				   string poliza,string idExterno,string totalInic,string preimpreso,string direccion,string mail,string fono,
                           string celular,string codComuna,string codRegion,string codCiudad,string tipoCliente,string persistencia){            
            this.rutUsuario = rutUsuario;
            this.dvUsuario = dvUsuario;
            this.idCanal = idCanal;
            this.rutCliente = rutCliente;
            this.idCampana = idCampana;
            this.tipoFolio = tipoFolio;
            this.poliza = poliza;
            this.idExterno = idExterno;
            this.totalInic = totalInic;
            this.preimpreso = preimpreso;
            this.direccion = direccion;
            this.mail = mail;
            this.fono = fono;
            this.celular = celular;
            this.codComuna = codComuna;
            this.codRegion = codRegion;
            this.codCiudad = codCiudad;
            this.tipoCliente = tipoCliente;
            this.persistencia = persistencia;
        }
        
        public ParametroDigitador(){
           
        }
        
    }

    /* TRABAJO COTIZADOR EXPRESS
     * *******************************************************************************************************/    
    //Método para cargar información del cliente o prospecto en cotizador...
    public PageReference cargaDatosContratanteCotizadorExpress(){ 
        
        try{
            //Recuperación ID tarea para asociar en cotizador...
            String idTarea = apexpages.currentpage().getparameters().get('Id');
         	String recordTypeOnco = [select id from recordtype where name='Ventas Oncológico'].id;
            system.debug('@@@@@ ID TAREA  => ' + idTarea);
            system.debug('@@@@@ recordTypeOnco  => ' + recordTypeOnco);
            
            
            TAREA_Contratante = new Task();
             if (!Test.isRunningTest())
             {
            	TAREA_Contratante = [SELECT 
                                 		Id,
                                        WhatId,
                                        WhoId,
                                        TASK_Campana__c,
                                 		TASK_ID_Miembro_Campana__c,
                                 		RecordTypeId,
                                        TASK_RUT_Ejecutivo_Televenta__c,
                                     	Status,
                                     	TASK_Sub_Estado__c,
                                        TASK_Producto_Oferta__c
                                 FROM 
                                 		Task
                                 WHERE 
                                 		Id =: idTarea AND RecordTypeId =: recordTypeOnco];
        	}

            TipoProducto = '';
            
            system.debug('@@@@@ TAREA CAPTURADA => ' + TAREA_Contratante);
            if(TAREA_Contratante != null){            
              
                
                //Instanciación objeto Miembro de Campaña para recuperar datos de Cliente Llamada...
                MC_CLIENTE = new CampaignMember();
                if (!Test.isRunningTest()){
                    MC_CLIENTE = [SELECT Id, CampaignId, ContactId, Email, FirstName, LastName, LeadId, MCAMP_Abierto_Email_N1_Producto_Onco__c,
                                     MCAMP_Campana_Activa__c, MCAMP_Carga_Apellido_Materno__c, MCAMP_Carga_Apellido_Paterno__c,
                                     MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c,
                                     MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c,
                                     MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Es_Asegurable__c,
                                     MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Plan__c,
                                     MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, MCAMP_Ramo__c,
                                     MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, MCAMP_Tasa_Riesgo__c,
                                     MCAMP_Tipo_Folio__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, MCAPM_Carga_Primer_Nombre__c, MobilePhone,
                                     Name, Phone, RecordTypeId, Status, Type, MCAMP_Tipo_Cliente__c, MCAMP_Tipo_Producto__c, MCAMP_Carga_Tel_fono_3__c, MCAMP_Carga_Tel_fono_4__c, 
                                     MCAMP_Carga_Tel_fono_5__c, MCAMP_Carga_Tel_fono_6__c, MCAMP_Carga_Tel_fono_7__c, MCAMP_Carga_Tel_fono_8__c, MCAMP_Carga_Dv__c
                                  FROM
                                         CampaignMember
                                  WHERE
                                         Id =: TAREA_Contratante.TASK_ID_Miembro_Campana__c];

                    //Generar Lista Reguiones
                    UsuaroTvta = TAREA_Contratante.TASK_RUT_Ejecutivo_Televenta__c;
                    UsuaroTvta = UsuaroTvta.substring(0, UsuaroTvta.length()-2);
                }

                TipoProducto = MC_CLIENTE.MCAMP_Tipo_Producto__c;

				// Asociando tipo de cliente NUEVO o EXISTENTE                
                cargaCliente = MC_CLIENTE.MCAMP_Tipo_Cliente__c;
                
                //CLS_LlamadaWSonco.generarListaRegiones(UsuaroTvta);                
                //LST_RegionesSF = new List<Region__c>();  
                if(MC_CLIENTE.MCAMP_Es_cliente__c == true){
                	tipoCliente = 'N';
                }else{
                    tipoCliente = 'S';
                }
                LST_RegionesSF = [SELECT    Id,
                                            Name,
                                            REGI_C_digo__c
                                  FROM
                                            Region__c];
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ LISTA REGIONES => ' + LST_RegionesSF));
                
                LST_Regiones = new List<SelectOption>();
                LST_Ciudades = new List<SelectOption>();
                LST_Comunas = new List<SelectOption>();
                LST_Tarjetas = new List<SelectOption>();
                VER_CAMPOCIUDAD = false;
                VER_CAMPOCOMUNA = false;  
                activaBotonPD = false;
                
                if(TAREA_Contratante.WhatId != null && TAREA_Contratante.TASK_ID_Miembro_Campana__c != null){
                    
                    //Recuperar información cuenta de cliente...
                    CUENTA_Contratante = new Account();
                    Account a = new Account();
                    CUENTA_Contratante = [SELECT Id,
                                                 Rut__c,
                                                 Firstname,
                                                 Lastname,
                                                 PersonBirthdate,
                                                 PersonHomePhone,
                                          		 PersonMobilePhone,
                                                 Estado_Civil__pc,
                                                 Direccion_Particular__pc,
                                                 Region_Particular__pc,
                                                 Ciudad_Particular__pc,
                                                 Comuna_Particular__pc,
                                                 isPersonAccount
                                          FROM Account
                                          WHERE Id =: TAREA_Contratante.WhatId];
					
                    DireccionCliente = CUENTA_Contratante.Direccion_Particular__pc;
					TelefonosCliente = '';
                    TelefonoCliente = MC_CLIENTE.MCAMP_Carga_Tel_fono_1__c;
                    
                    if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_1__c))
                        TelefonosCliente = MC_CLIENTE.MCAMP_Carga_Tel_fono_1__c;
                        
                    if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_2__c))
                        TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_2__c;
                        
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_3__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_3__c;
                                
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_4__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_4__c;
        
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_5__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_5__c;
        
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_6__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_6__c;
        
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_7__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_7__c;
        
                   if (String.isNotBlank(MC_CLIENTE.MCAMP_Carga_Tel_fono_8__c))
                                TelefonosCliente = TelefonosCliente + ' - ' + MC_CLIENTE.MCAMP_Carga_Tel_fono_8__c;
                    
                    //Recuperar información de cuenta...
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ CLIENTE CAMPAMÑA TELEVENTA ONCOLÓGICO CAPTURADO => ' + 
                                                                                        MC_CLIENTE));                    
                    
                }else{
                    if(TAREA_Contratante.WhoId != null && TAREA_Contratante.TASK_ID_Miembro_Campana__c != null){
                        
                        String TipoObjeto = ''; // 003 Contacto o 00Q Leads
                        
                        TipoObjeto = String.valueOf(TAREA_Contratante.WhoId).substring(0,3);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO COTIZADOR => ' + 
                                                                   							TipoObjeto));                        
                        system.debug('@@@@ TIPO OBJETO CAPTURADO COTIZADOR => ' + TipoObjeto);
                        
                        if(TipoObjeto == '00Q'){
                        	//Recuperar información de prospecto...
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO => ' + 
                                                                       							TipoObjeto + ' (LEAD)'));
                            
						
                        }else{
                        	//Recuperar información de contacto...
                        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO => ' + 
                                                                       							TipoObjeto + ' (CONTACT)'));

                        }
                    }else{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No ha sido posible recuperar la información del cliente, ' +
                                                                   							  'intenta más tarde... en caso de persistir el error ' +
                                                                   							  'comunica a tu Administrador de Sistema'));                        
                    }                    
                }
                getRegion();
                getCiudad();
                getComuna();
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No ha sido posible recuperar la información del cliente, ' +
                                                                                      'intenta más tarde... en caso de persistir el error comunica a ' +
                                                                                      'tu Administrador de Sistema'));
            }
            return null;
        }catch(Exception ex){
            system.debug('@@@@ EXCEPTION => ' + ex.getMessage() + 'LINEA => ' +  ex.getLineNumber() );
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'@@@@ ERROR: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()  ));
            return null;
        }
    }       
    
    //Método carga Campo Selección Región...
    public static List<SelectOption> getCargaRegiones(){
        try{            
            LST_Regiones.add(new SelectOption('','--Ninguno--'));
            for(Region__c r : LST_RegionesSF){
                LST_Regiones.add(new SelectOption(r.REGI_C_digo__c,r.Name));
            }
            return LST_Regiones;
        }catch(Exception ex){
            system.debug('@@@@ ERROR REGIONES => ' + ex.getMessage() + 'LINEA => ' +  ex.getLineNumber() );
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'@@@@ ERROR: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()  ));
            return null;
        }
    }

    /* TRABAJO CONEXIÓN PREDIGITADOR 
     * *******************************************************************************************************/
    public PageReference AbrirPreDigita(){   
        
        try{
            
            system.debug('Entre');
            
            String rutUsuario;
            if(!Test.isRunningTest()){
            	rutUsuario = [SELECT RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c; 
                rutUsuario = rutUsuario.substring(0,rutUsuario.length()-2);
            }else{
            	rutUsuario = '12345123-2';
                rutUsuario = rutUsuario.substring(0,rutUsuario.length()-2);
            }            
            String dvUsuario = rutUsuario.substring(rutUsuario.length()-1);
            String idCanal = '20';          
            String rutCliente = MC_CLIENTE.MCAMP_Carga_RUT__c;
            String idCampana = MC_CLIENTE.CampaignId;
            //String tipoFolio = '19';
            
            String tipoFolio = MC_CLIENTE.MCAMP_Tipo_Folio__c; 
            
            if (!String.isNotBlank(tipoFolio)) {
                tipoFolio = '19';
            }
            system.debug('@@@@ tipoFolio ' + tipoFolio);
            
            String poliza = MC_CLIENTE.MCAMP_Carga_Poliza_Mandatoria__c;
            String idExterno = '';
            
            String totalInic;
            if(!Test.isRunningTest()){
	            totalInic = String.valueOf(TOTAL_UF);
            }else{
                totalInic = '10.5';
            }
            String regValores = 'd';
            totalInic = totalInic.replace('.', regValores);
            system.debug('@@@@ VALOR TRANSFERIDO => ' + totalInic);
            
            String preimpreso = '1';
            String direccion = '';
            String fono = '';
            
            direccion = DireccionCliente;
            
            if(MC_CLIENTE.MCAMP_Es_cliente__c == true && direccion=='' ){
            	direccion = CUENTA_Contratante.Direccion_Particular__pc;
            }
            
            //else{
            //  direccion = DireccionCliente;
            //}
            String mail = MC_CLIENTE.MCAMP_Carga_Email_1__c;
            if (!Test.isRunningTest())
            	fono = TelefonoCliente.replaceAll( '\\s+', '');
            else
                fono = MC_CLIENTE.MCAMP_Carga_Tel_fono_1__c;
            String celular = MC_CLIENTE.MCAMP_Carga_Tel_fono_2__c;
            
            String codRegion = COD_RegionSeleccionada;
            String codComuna = COD_ComunaSeleccionada;
            String codCiudad = COD_CiudadSeleccionada;
                                   
            String tipoCliente = '';
            if(MC_CLIENTE.MCAMP_Es_cliente__c == true){
                tipoCliente = 'N';
            }else{
                tipoCliente = 'S';
            }
            tipoCliente = 'S';
            
          	String persistencia = String.valueOf(persistenciaId());
          	
            
            if (poliza == '' || poliza == null)
                poliza = '';
            if (direccion == '' || direccion == null)
                direccion = 'Los mañios #334455';
            if (celular == '' || celular == null)
                celular = '0';
            if (codRegion == '' || codRegion == null)
                codRegion = '013';
            if (codComuna == '' || codComuna == null)
                codComuna = '613';
            if (codCiudad == '' || codCiudad == null)
                codCiudad = '605';
                
            PageReference pageRef= new PageReference('/apex/SEC_VF_ONCO_DigitadorOncologico');
    
            pageRef.getParameters().put('idCanal', idCanal);
            pageRef.getParameters().put('rutUsuario', rutUsuario);
            pageRef.getParameters().put('dvUsuario', dvUsuario);
            pageRef.getParameters().put('rutCliente', rutCliente);
            pageRef.getParameters().put('idCampana', idCampana);
            pageRef.getParameters().put('tipoFolio', tipoFolio);
            pageRef.getParameters().put('poliza', poliza);
            pageRef.getParameters().put('idExterno', idExterno);
            pageRef.getParameters().put('totalInic', totalInic);
            pageRef.getParameters().put('preimpreso',preimpreso);
            pageRef.getParameters().put('direccion', direccion);
            pageRef.getParameters().put('mail', mail);
            pageRef.getParameters().put('fono', fono);
            pageRef.getParameters().put('celular', celular);
            pageRef.getParameters().put('codComuna', codComuna);
            pageRef.getParameters().put('codRegion', codRegion);
            pageRef.getParameters().put('codCiudad', codCiudad);
            pageRef.getParameters().put('tipoCliente', tipoCliente);
            pageRef.getParameters().put('persistencia', persistencia);
                   
            pageRef.setRedirect(true);      
            return pageRef;
            
        }catch(Exception ex){
            system.debug('@@@@ ERROR ABRIR PRE-DIGITADOR => ' + ex + '; LÍNEA => ' + ex.getLineNumber());   
            return null;
        }
        
   	}

    public String getRegion(){

        List<CLS_Region>  citylist = new List<CLS_Region> ();
        List<Region__c> ListaRegiones = new List<Region__c>();
        ListaRegiones = [select REGI_C_digo__c ,Name from Region__c ];

        for (Integer j=0;j<ListaRegiones.size();j++){
            citylist.add(new CLS_Region(ListaRegiones[j].REGI_C_digo__c, ListaRegiones[j].Name ) );
        }
        system.debug('@@@@ Region  => ' + citylist);
        String respuesta = JSON.serialize(citylist);
        Region = respuesta.replace('\'', ' ');
        return Region;

    }

    public String getCiudad(){

        List<CLS_Ciudad>  citylist = new List<CLS_Ciudad>();
        List<Ciudad__c> ListaRegiones = new List<Ciudad__c>();
        ListaRegiones = [select CIUD_C_digo__c, CIUD_Codigo_Region__c, Name from Ciudad__c ORDER BY Name ASC];

        for (Integer j=0;j<ListaRegiones.size();j++)
        {
            citylist.add(new CLS_Ciudad(ListaRegiones[j].CIUD_C_digo__c,
                                                                        ListaRegiones[j].Name,
                                                                        ListaRegiones[j].CIUD_Codigo_Region__c));
        }

        String respuesta=JSON.serialize(citylist);
        system.debug('@@@@ Ciudad  => ' + citylist);
        Ciudad = respuesta.replace('\'', ' ');
        return Ciudad;
    }

    public String getComuna(){

        List<CLS_Comuna>  citylist = new List<CLS_Comuna>();
        List<Comuna__c> ListaRegiones = new List<Comuna__c>();
        ListaRegiones = [select Name,COMU_Codigo_Comuna__c,COMU_C_digo_Ciudad__c,COMU_C_digo_Regi_n__c from Comuna__c ORDER BY Name ASC];

        for (Integer j=0;j<ListaRegiones.size();j++)
        {
            citylist.add(new CLS_Comuna(ListaRegiones[j].COMU_Codigo_Comuna__c,
                                                                        ListaRegiones[j].Name,
                                                                        ListaRegiones[j].COMU_C_digo_Regi_n__c,
                                                                        ListaRegiones[j].COMU_C_digo_Ciudad__c));
        }

        String respuesta=JSON.serialize(citylist);
        system.debug('@@@@ Comuna  => ' + citylist);
        Comuna = respuesta.replace('\'', ' ');
        return Comuna;

    }

    public PageReference cargaDatosContratantePreDigitador(){
        try{
            String rutUsuario = apexpages.currentpage().getparameters().get('rutUsuario');
            String dvUsuario = apexpages.currentpage().getparameters().get('dvUsuario');
            String idCanal = apexpages.currentpage().getparameters().get('idCanal');          
            String rutCliente = apexpages.currentpage().getparameters().get('rutCliente');
            String idCampana = apexpages.currentpage().getparameters().get('idCampana');
            String tipoFolio = apexpages.currentpage().getparameters().get('tipoFolio');
            String poliza = apexpages.currentpage().getparameters().get('poliza');
            String idExterno = apexpages.currentpage().getparameters().get('idExterno');
            String totalInic = apexpages.currentpage().getparameters().get('totalInic');
            String preimpreso = apexpages.currentpage().getparameters().get('preimpreso');
            String direccion = apexpages.currentpage().getparameters().get('direccion');
            String mail = apexpages.currentpage().getparameters().get('mail');
            String fono = apexpages.currentpage().getparameters().get('fono');
            String celular = apexpages.currentpage().getparameters().get('celular');
            String codComuna = apexpages.currentpage().getparameters().get('codComuna');
            String codRegion = apexpages.currentpage().getparameters().get('codRegion');
            String codCiudad = apexpages.currentpage().getparameters().get('codCiudad');                                   
            String tipoCliente = apexpages.currentpage().getparameters().get('tipoCliente');
            String persistencia = apexpages.currentpage().getparameters().get('persistencia');   
            
            PD_Digitador = new ParametroDigitador( rutUsuario, dvUsuario, idCanal, rutCliente, idCampana, tipoFolio,
        				    poliza, idExterno, totalInic, preimpreso, direccion, mail, fono,
                            celular, codComuna, codRegion, codCiudad, tipoCliente, persistencia);
                
            system.debug('@@@@ PD_Digitador => ' + PD_Digitador);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ INFORMACION => Esperando acceso a Pre-Digitador' ));

            return null;
        }catch(Exception ex){
              system.debug('@@@@ PD_Digitador => ' +  ex.getMessage());
            return null;
        }
    }
    
    public class CLS_Region {
        public String Codigo   {get; set;}
        public String Nombre  {get; set;}
        
        public CLS_Region(String intCodigo,String intNombre)
        {
            Codigo=intCodigo;
            Nombre=intNombre;
            
         }
        
    }
    public class CLS_Ciudad {
        public String Codigo   {get; set;}
        public String Nombre  {get; set;}
        public String CodigoRegion {get;set;}
         
        public CLS_Ciudad(String intCodigo,String intNombre ,string intCodigoRegion )
        {
            Codigo=intCodigo;
            Nombre=intNombre;
            CodigoRegion=intCodigoRegion;
          
         }
        
    }
    public class CLS_Comuna{
        
         public String Codigo   {get; set;}
        public String Nombre  {get; set;}
        public String CodigoRegion {get;set;}
        public String CodigoCiudad {get;set;}
         
        public CLS_Comuna(String intCodigo,String intNombre ,string intCodigoRegion,string intCodigoCiudad )
        {
            Codigo=intCodigo;
            Nombre=intNombre;
            CodigoRegion=intCodigoRegion;
            CodigoCiudad=intCodigoCiudad;
        }
    }
    
    public static Integer persistenciaId() {

        String IdOrg = UserInfo.getOrganizationId();

        System.Pagereference currentPage = System.currentPageReference();
        String browser = 'browser';
        String ip = '1.1.1.1';
        String url = 'Salesforce';
        String referer = 'Salesforce';
        if (currentPage != null) {
            browser = currentPage.getHeaders().get('User-Agent');
            url = currentPage.getUrl();
            referer = currentPage.getHeaders().get('Referer');
            ip = currentPage.getHeaders().get('X-Salesforce-SIP');
        }
        WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
        service.timeout_x = 120000;
        WSAccess.AppInfo appInfo = new WSAccess.AppInfo();
        appInfo.Cup = 'PR10-D011-Intranet_Internet';
        appInfo.Option = 0;

        WSAccess.UserInfo userInfo = new WSAccess.UserInfo();
        userInfo.UserName = 'SalesForce';
        userInfo.Password = 'S4l3sForce';
        userInfo.UserOS = 'UsuarioOS';
        userInfo.Ip = ip == null ? '' : ip;
        userInfo.Rut = 76749930;
        userInfo.Dv = '2';
        userInfo.PersistCode = 0;

        WSAccess.WebInfo webInfo = new WSAccess.WebInfo();
        webInfo.Browser = browser == null ? '' : browser;
        webInfo.Environment = 'PROD';
        webInfo.GeoLatitude = 0;
        webInfo.GeoLongitude = 0;
        webInfo.InfoMovile = '-';
        webInfo.IsMobile = false;
        webInfo.Method = 'POST';
        webInfo.Parameters = '';
        webInfo.Os = 'SO';
        webInfo.SessionId = '12345678';
        webInfo.Url = url == null ? '' : url;
        webInfo.UrlReferrer = referer == null ? '' : referer;

        WSAccess.AccessInfo accessInfo = new WSAccess.AccessInfo();
        accessInfo.AppInfo = appInfo;
        accessInfo.UserInfo = userInfo;
        accessInfo.WebInfo = webInfo;
        System.debug('@@@@ Obtencion Persistencia paso');
        WSAccess.DatoAcceso datoAcceso = null;
        Integer retries = 5;
        for (Integer i = 0; i < retries; i++) {
            try {
                datoAcceso = service.Login(accessInfo);
                System.debug('@@@@ Acceso: ' + datoAcceso);
                System.debug('@@@@ Acceso Válido: ' + datoAcceso.AccesoValido);
                if (datoAcceso != null) {
                    System.debug('@@@@ datoAcceso.IdPersistencia: ' + datoAcceso.IdPersistencia);
                    // Valida ambiente de producción o alguna sandbox
                    if( IdOrg.equals('00Di0000000XoSJEA0') ) {
                        return datoAcceso.IdPersistencia;
                    }else {
                        return datoAcceso.IdPersistencia;
                    }
                }
            } catch (Exception ex) {
                System.debug('@@@@ Exception: ' + ex);
            }


        }
        return 0;

    }
 
    
}