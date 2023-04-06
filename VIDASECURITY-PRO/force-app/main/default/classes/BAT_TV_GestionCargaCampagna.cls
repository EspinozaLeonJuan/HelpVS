/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-24-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-24-2020   Juan Espinoza León   Initial Version
**/
global class BAT_TV_GestionCargaCampagna implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {  
    
    public String IdCampagna {get; set;}
   
    
    public BAT_TV_GestionCargaCampagna(string idCmp) {
        this.IdCampagna = idCmp;  
         system.debug('@@@@ this.IdCampagna: ' + this.IdCampagna);
        
    }

    global Database.QueryLocator start(Database.BatchableContext bc) { 
        String query =  'SELECT Id, IsDeleted, CampaignId, LeadId, ContactId, Status, HasResponded, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, FirstRespondedDate, RecordTypeId, Salutation, '+
        'Name, FirstName, LastName, Title, Street, City, State, PostalCode, Country, Email, Phone, Fax, MobilePhone, Description, DoNotCall, HasOptedOutOfEmail, HasOptedOutOfFax, LeadSource, CompanyOrAccount, '+
        'Type, LeadOrContactId, LeadOrContactOwnerId, Agente__c, Causa_No_Contacto__c, Cerrado__c, Cerrado_por__c, Comentarios__c, Correo_Electronico__c, Enviar_Ley__c, Fecha_de_Activacion__c, Nombre_Empleador__c, '+
        'Numero_de_Poliza__c, Poliza__c, Producto__c, RUT_Empleador__c, Razon_Social_Empleador__c, Recibio_Ley__c, Sucursal__c, Supervisor__c, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, '+
        'MCAMP_Carga_Apellido_Materno__c, MCAMP_Carga_Apellido_Paterno__c, MCAMP_Carga_Dv__c, MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, '+
        'MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c, MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Es_Asegurable__c, '+
        'MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Plan__c, MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, '+
        'MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, MCAMP_Tasa_Riesgo__c, MCAMP_Tipo_Folio__c, MCAMP_WS_Equifax_Consumido__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, '+
        'MCAPM_Carga_Primer_Nombre__c, WS_Tiene_Producto_Oncologico__c, MCAMP_Tipo_Cliente__c, MCAMP_Actualizar_Nuevo_Cliente__c, MCAMP_Resultado_Carga_Integracion__c, MCAMP_Tipo_Producto__c '+
        'FROM CampaignMember WHERE CampaignId = \'' + String.escapeSingleQuotes(this.IdCampagna) + '\' and MCAMP_Actualizar_Nuevo_Cliente__c = true';

        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<CampaignMember> miembros) {

        // Control errores
        boolean ERR_EQUIFAXWS = false;
        String ERR_MENSAJE_EQUIWS = '', ERR_LINEA_EQUIWS = '';
        
        boolean ERR_PRODONCOWS = false;  
        String ERR_MENSAJE_PRONCOWS = '', ERR_LINEA_PRONCOWS = '';

        string usuario = 'BHUERTA';
       
        CLS_TV_GeneracionTareasCampagna genTa = new CLS_TV_GeneracionTareasCampagna(this.IdCampagna);

        for (CampaignMember cm : miembros) {
            Lead prospecto = null;
            string rutPersona = cm.MCAMP_Carga_RUT__c + '-' + cm.MCAMP_Carga_Dv__c;
            
            try
            {
                if(cm.LeadId != null){
                    system.debug('@@@@ ID LEAD CAMPAÑA => ' + cm.LeadId);
                    
                    prospecto = [SELECT Id, Firstname, Lastname, Email, Phone, PROSP_Carga_Apellido_Materno__c, PROSP_Carga_Email_2__c, PROSP_Carga_RUT__c,
                                                PROSP_Carga_Tel_fono_2__c, PROSPE_Carga_Fecha_Nacimiento__c, PROSP_No_quiere_ser_contactado_Televenta__c
                                        FROM Lead
                                        WHERE Id =: cm.LeadId];
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
                
                cm.MCAMP_Carga_Fecha_Nacimiento__c = Date.valueOf(objConsulta.Fecha_Nacimiento);   

                if(prospecto != null)
                {
                    system.debug('@@@@ LEAD PARA ACTUALIZAR CON EQUIFAX => ' + prospecto);
                    prospecto.FirstName = cm.MCAPM_Carga_Primer_Nombre__c;
                    prospecto.LastName = cm.MCAMP_Carga_Apellido_Paterno__c;
                    prospecto.PROSP_Carga_Apellido_Materno__c = cm.MCAMP_Carga_Apellido_Materno__c;
                    prospecto.PROSPE_Carga_Fecha_Nacimiento__c = cm.MCAMP_Carga_Fecha_Nacimiento__c;
                    system.debug('@@@@ LEAD ACTUALIZADO EQUIFAX => ' + prospecto);
                }
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = true; 
                
                cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Consulta Persona: Procesado correctamente';
            }
            catch(system.CalloutException cout_equifax){            
            
                system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA WS CONSULTA PERSONA| TARIFICACION WS                                ');
                system.debug('@@@@ *******************************************************************************************');
                system.debug('@@@@ MENSAJE: ' + cout_equifax.getMessage());
                system.debug('@@@@ LINEA: ' + cout_equifax.getLineNumber());
                
                ERR_EQUIFAXWS = true;
                ERR_MENSAJE_EQUIWS = cout_equifax.getMessage();
                ERR_LINEA_EQUIWS = String.ValueOf(cout_equifax.getLineNumber());

                cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Equifax: Imposible procesar llamada a equifax.';                        
                
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = false;    
                
                
            }finally
            { 
                String tipoCliente = '';
                if(cm.MCAMP_Es_cliente__c == true)
                {
                    tipoCliente = 'N'; // Cliente existente
                }
                else
                {
                    tipoCliente = 'S'; // Cliente nuevo o prospecto
                }            
                    
                try
                {
                    //Llamada al Servicio Web para obtener datos para parificar...
                    EXT_WS_Oncologico.WsProductoOncologicoSoap cnx1 = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
                    EXT_WS_Oncologico.ArrayOfProductoOncologico pOnco = new EXT_WS_Oncologico.ArrayOfProductoOncologico(); 
                    EXT_WS_Oncologico.UsuarioValido resValidaUsu = new EXT_WS_Oncologico.UsuarioValido();            
                    
                    if(!Test.isRunningTest())
                    {
                        pOnco = cnx1.GetUltimoProducto(usuario, integer.valueOf(cm.MCAMP_Tipo_Producto__c), tipoCliente);
                    }
                    else
                    {
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
                            system.debug('@@@@ RUT               => ' + cm.MCAMP_Carga_RUT__c);
                            system.debug('@@@@ FECHA NACIMIENTO  => ' + fnac);
                            res2.ValidaAseguradoOncoResult = cnx1.ValidaAseguradoOnco(usuario, cm.MCAMP_Ramo__c, cm.MCAMP_Codigo_Producto__c, cm.MCAMP_Plan__c, cm.MCAMP_Revision__c, codCobert, Integer.valueOf(cm.MCAMP_Carga_RUT__c), fnac);

                        } else {

                            res2.ValidaAseguradoOncoResult = 'S';

                        }

                        system.debug('@@@@ RETORNO VALIDACION PRODUCTO ONCOLOGICO =>' + res2.ValidaAseguradoOncoResult);
                        if (res2.ValidaAseguradoOncoResult == null)
                        {
                            cm.WS_Tiene_Producto_Oncologico__c = false; 
                        }else{
                            cm.WS_Tiene_Producto_Oncologico__c = res2.ValidaAseguradoOncoResult == 'N';
                        }
                        
                        // Validación llamada a método ValidaCliente (APEG)...
                        if( res2.ValidaAseguradoOncoResult == 'S' && cm.MCAMP_Tipo_Producto__c == '66' ){
    
                            integer CodigoValidacionClienteAPEG = cnx1.ValidaCliente(usuario,Integer.valueOf(cm.MCAMP_Carga_RUT__c),cm.MCAMP_Carga_Dv__c);
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

                    if (prospecto != null)
                    {
                        update prospecto;
                    }
                        
                }
                catch(system.CalloutException cout_wsprodonco){
                
                    system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA WS  CONSULTA PERSONA | TARIFICACION WS                                ');
                    system.debug('@@@@ *******************************************************************************************');
                    system.debug('@@@@ MENSAJE: ' + cout_wsprodonco.getMessage());
                    system.debug('@@@@ LINEA: ' + cout_wsprodonco.getLineNumber()); 
                    
                    ERR_PRODONCOWS = false;  
                    ERR_MENSAJE_PRONCOWS = cout_wsprodonco.getMessage();
                    ERR_LINEA_PRONCOWS = String.valueOf(cout_wsprodonco.getLineNumber());
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - Producto Oncológico: Imposible procesar llamada a WS Producto oncológico.';
                    
                }
                finally{
                    if (cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c && cm.MCAMP_WS_Equifax_Consumido__c)
                    {
                        cm.MCAMP_Actualizar_Nuevo_Cliente__c = false;
                    }
                    else {
                        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
                    }
                    
                    cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nProceso carga/integración del registro finalizado';
                    
                    if (!ERR_EQUIFAXWS && !ERR_PRODONCOWS)
                    {

                        if(cm.MCAMP_Ejecutivo_Televenta__c != null && String.isBlank(cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c)  &&
                            cm.MCAMP_Es_Asegurable__c == 'S' && cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c == true ){
                            Task t = genTa.generaTarea(cm);
                            if(t != null){
                                cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = t.Id;
                            }
                        }
                    }

                    update cm;
                    
                    if (Test.isRunningTest()) {
                        ERR_EQUIFAXWS = true;
                        ERR_PRODONCOWS = true;
                    }
                      
                    if(ERR_EQUIFAXWS){
                
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        String[] toAddresses = new String[] {'juespinoza@security.cl'};
                            mail.setToAddresses(toAddresses);
                        mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                        mail.setReplyTo('juespinoza@security.cl');
                        mail.setsubject('@@@@ TELEVENTA ONCO - WS EQUIFAX');
                        mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Consulta Persona, mayor detalle en el siguiente mensaje:<br><br>' + ERR_MENSAJE_EQUIWS + '<br><br>Línea: ' + ERR_LINEA_EQUIWS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                      
                        if (!Test.isRunningTest()) {
                        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    	}
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
                        
                        if (!Test.isRunningTest()) {
                        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    	}                        
                    }   
                }   

            }
        }
    }

    global void finish(Database.BatchableContext bc) {
        system.debug('@@@@@ Ha finalizado trabajo actualizacion miembros de campaña...');
    }

}