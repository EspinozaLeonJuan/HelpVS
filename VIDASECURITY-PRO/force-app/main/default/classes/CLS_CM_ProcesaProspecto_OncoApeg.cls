/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-21-2021   Juan Espinoza León   Initial Version
**/
public with sharing class CLS_CM_ProcesaProspecto_OncoApeg {
    public CLS_CM_ProcesaProspecto_OncoApeg() {

    }

    public class Retorno 
    {
        public CampaignMember campaignMember {get; set;}

        public Lead lead {get; set;}

        public Boolean ERR_WS {get; set;}

        public String ERR_MENSAJE_WS {get; set;}

        public String ERR_LINEA_WS {get; set;}

        public Retorno()
        {
            this.ERR_WS = false;
        }
    }

    public static Retorno ObtenerDatosProspecto(CampaignMember cm)
    {
        Retorno salida  = new Retorno();
        
        Lead lead = null;
        string rutPersona = cm.MCAMP_Carga_RUT__c + '-' + cm.MCAMP_Carga_Dv__c;

        try
        {
            if(cm.LeadId != null){
                system.debug('@@@@ ID LEAD CAMPAÑA => ' + cm.LeadId);
                
                lead = [SELECT Id, Firstname, Lastname, Email, Phone, PROSP_Carga_Apellido_Materno__c, PROSP_Carga_Email_2__c, PROSP_Carga_RUT__c,
                               PROSP_Carga_Tel_fono_2__c, PROSPE_Carga_Fecha_Nacimiento__c, PROSP_No_quiere_ser_contactado_Televenta__c
                        FROM Lead WHERE Id =: cm.LeadId];

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

                if(lead != null)
                {
                    system.debug('@@@@ LEAD PARA ACTUALIZAR CON EQUIFAX => ' + lead);
                    lead.FirstName = cm.MCAPM_Carga_Primer_Nombre__c;
                    lead.LastName = cm.MCAMP_Carga_Apellido_Paterno__c;
                    lead.PROSP_Carga_Apellido_Materno__c = cm.MCAMP_Carga_Apellido_Materno__c;
                    lead.PROSPE_Carga_Fecha_Nacimiento__c = cm.MCAMP_Carga_Fecha_Nacimiento__c;
                    system.debug('@@@@ LEAD ACTUALIZADO EQUIFAX => ' + lead);
                    system.debug('@@@@ LEAD ACTUALIZADO EQUIFAXID => ' + lead.Id);
                }
    
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = true; 
                
                cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Consulta Persona: Procesado correctamente';
                salida.lead = lead;
            }
            else {
                
                cm.MCAMP_Resultado_Carga_Integracion__c = 'Prospecto no encontrado.';                        
                //Validación de consumo WS Equifax...
                cm.MCAMP_WS_Equifax_Consumido__c = false;   
                salida.ERR_MENSAJE_WS = 'Prospecto no encontrado.';
                salida.lead = null;
            }           
        }
        catch(system.CalloutException ex){            
        
            system.debug('@@@@ ERROR - WS CONSULTA PERSONA ');
            system.debug('@@@@ *******************************************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA: ' + ex.getLineNumber());
            
            salida.ERR_WS = true;
            salida.ERR_MENSAJE_WS = ex.getMessage();
            salida.ERR_LINEA_WS = String.ValueOf(ex.getLineNumber());

            cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Equifax: Imposible procesar llamada a equifax.';                        
            
            //Validación de consumo WS Equifax...
            cm.MCAMP_WS_Equifax_Consumido__c = false;   
            salida.lead = null; 
        }
      
        salida.campaignMember = cm;          

        return salida;
    }

    public static Retorno ObtieneProducto(CampaignMember cm)
    {
        Retorno salida  = new Retorno();
        
        try 
        {
            String usuario = 'BHUERTA';

            String tipoCliente = 'S'; // Cliente nuevo o prospecto
    
            if(cm.MCAMP_Es_cliente__c == true)
            {
                tipoCliente = 'N'; // Cliente existente
            }

            //Llamada al Servicio Web para obtener datos para parificar...
            EXT_WS_Oncologico.WsProductoOncologicoSoap cnx1 = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
            EXT_WS_Oncologico.ArrayOfProductoOncologico pOnco = new EXT_WS_Oncologico.ArrayOfProductoOncologico(); 
            
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
            
        } 
        catch(system.CalloutException ex)
        {     
            system.debug('@@@@ ERROR - WS OBTIENE PRODUCTO ');
            system.debug('@@@@ *******************************************************************************************');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LINEA: ' + ex.getLineNumber());
            
            salida.ERR_WS = true;
            salida.ERR_MENSAJE_WS = ex.getMessage();
            salida.ERR_LINEA_WS = String.ValueOf(ex.getLineNumber());

            cm.MCAMP_Resultado_Carga_Integracion__c = 'WS - Equifax: Imposible procesar llamada a equifax.';                        
            
            //Validación de consumo WS Equifax...
            cm.MCAMP_WS_Equifax_Consumido__c = false;   
        }

        salida.campaignMember = cm;    
        //salida.lead = null;

        return salida;
    }

    public static Retorno ValidacionAsegurado(CampaignMember cm)
    {
        Retorno salida  = new Retorno();
        
        try
        {
            String usuario = 'BHUERTA';

            String tipoCliente = 'S'; // Cliente nuevo o prospecto
    
            if(cm.MCAMP_Es_cliente__c == true)
            {
                tipoCliente = 'N'; // Cliente existente
            }

            //Llamada al Servicio Web para obtener datos para parificar...
            EXT_WS_Oncologico.WsProductoOncologicoSoap cnx1 = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
            EXT_WS_Oncologico.UsuarioValido resValidaUsu = new EXT_WS_Oncologico.UsuarioValido();            
                
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
                
                if(!Test.isRunningTest())
                {
                    resValidaUsu = cnx1.ValidacionUsuarioPorFecNac(usuario, '7300', cm.MCAMP_Codigo_Producto__c, cm.MCAMP_Plan__c, cm.MCAMP_Revision__c, tipoCliente, '0001', fnac);
                }
                else{
                    resValidaUsu.Respuesta = 'S';
                }
                
                USU_Asegurable = resValidaUsu.Respuesta;
                
                system.debug('@@@@ RETORNO VALIDACION CONTRATANTE CARGADO:');
                system.debug('@@@@ ============================================================================================'); 
                system.debug('@@@@ ASEGURABLE => ' + USU_Asegurable);

                cm.MCAMP_Es_Asegurable__c = USU_Asegurable;
                
                cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - ValidacionUsuarioPorFecNac: Procesado correctamente';

                EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element res2 = new EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element();
                
                String codCobert = '';
                
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

                } else 
                {
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
                    system.debug('@@@@ VALOR UF => ' + resTarMC.ValorUF);
                    
                    cm.MCAMP_Prima_Neta_CLP__c = resTarMC.PrimaNetaPS;
                    cm.MCAMP_Prima_Neta_UF__c = resTarMC.PrimaNetaUF;
                    cm.MCAMP_Prima_IVA_CLP__c = resTarMC.PrimaIVAPS;
                    cm.MCAMP_Prima_IVA_UF__c = resTarMC.PrimaIVAUF;
                    cm.MCAMP_Tarifa_CLP__c = resTarMC.PrimaBrutaPS;
                    cm.MCAMP_Tarifa_UF__c = resTarMC.PrimaBrutaUF;
                    cm.MCAMP_Tasa_Riesgo__c = resTarMC.TasaRiesgo;
                    
                    if (restarMC.ValorUF == null)
                        restarMC.ValorUF = 0;

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
        }
        catch(system.CalloutException cout_wsprodonco){
        
            system.debug('@@@@ ERROR - CONSULTA DATOS PERSONA WS  CONSULTA PERSONA | OBTENCION TARIFAS                  ');
            system.debug('@@@@ *******************************************************************************************');
            system.debug('@@@@ MENSAJE: ' + cout_wsprodonco.getMessage());
            system.debug('@@@@ LINEA: ' + cout_wsprodonco.getLineNumber()); 
            
            salida.ERR_WS = false;  
            salida.ERR_MENSAJE_WS = cout_wsprodonco.getMessage();
            salida.ERR_LINEA_WS = String.valueOf(cout_wsprodonco.getLineNumber());
            
            cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nWS - Producto Oncológico: Imposible procesar llamada a WS Producto oncológico Tarificación.';
        }
        
        salida.campaignMember = cm;

        return salida;
    }
}