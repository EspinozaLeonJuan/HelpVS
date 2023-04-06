/*******************************************************************************************
 *  NOMBRE                 : CLS_WSPropuestasOncologico
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Gestiona Ventas (Oportunidades) como WS
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 24/04/2018 - H.NORAMBUENA     - Creación Clase
 *  1.1     - 13/09/2018 - H.NORAMBUENA     - Ajuste búsqueda propuesta rechazada y generación
 * 											- nueva propuesta (Línea 99 a Línea 116)
 *  1.2     - 06/10/2018 - H.NORAMBUENA     - Ajuste ID Externo objetos relacionados propuesta
 * 											- se concatena ID Salesforce (006) único:
 * 											- Persona (Línea 154)
 * 											- Asegurado (Línea 210)
 * 											- Cobertura (Línea 267)
 * 											- Beneficiario (Línea 322)
 * 											- Intermediario (Línea 357)
 *											- Contratante (Línea 413)
 *  1.3     - 18/12/2018 - H.NORAMBUENA     - Validación Cliente Nuevo o Existente
 *  1.4     - 22/08/2019 - I.SALAZAR        - Validacion Asegurados
 * *****************************************************************************************/
global class CLS_WSPropuestasOncologico{

    //MÉTODOS WEB (APEX)
    //****************************************************************************************************     
    webservice static String RegistraDatosProspecto(String usuario, DatosProspecto datProsp){
        
        String RegistraDatosProspectoResult = 'Respuesta = ';
        try{

            /******************************************************************************************
             * DEBUG ESTRUCTURAS WSOPERACIONONCOLOGICO....
             *****************************************************************************************/
            System.debug('@@@@ ESTRUCTURA PROPUESTA       => ' + datProsp.Propuesta);            
			System.debug('@@@@ ESTRUCTURA FPAGO           => ' + datProsp.FormPago);			
            System.debug('@@@@ ESTRUCTURA PERSONA         => ' + datProsp.LsPersona);            
			System.debug('@@@@ ESTRUCTURA CONTRATANTE     => ' + datProsp.LsContratante);
			System.debug('@@@@ ESTRUCTURA BENEFICIARIOS   => ' + datProsp.LsBeneficiario);
			System.debug('@@@@ ESTRUCTURA ASEGURADOS      => ' + datProsp.LsAsegurado);
			System.debug('@@@@ ESTRUCTURA COBERTURA       => ' + datProsp.LsCobertura);
			System.debug('@@@@ ESTRUCTURA INTERMEDIARIO   => ' + datProsp.LsIntermediario);              
            
            CLS_Wsprodonco.WsProductoOncologicoSoap cnx = new CLS_WSprodonco.WsProductoOncologicoSoap();
            CLS_Wsprodonco.ArrayOfRelacionFamiliar ARR_relacion = new CLS_Wsprodonco.ArrayOfRelacionFamiliar();
            List<CLS_WSprodonco.RelacionFamiliar> relaciones = new List<CLS_WSprodonco.RelacionFamiliar>();
            
            if( !Test.isRunningTest() ){
            	ARR_relacion = cnx.ObtenerRelacionFamiliar(datProsp.Propuesta.Usuario, datProsp.Propuesta.CodRamo, datProsp.Propuesta.CodProd, datProsp.Propuesta.CodPlan, datProsp.Propuesta.RevPlan);
                relaciones = ARR_relacion.RelacionFamiliar; 
            }else{
                CLS_WSprodonco.RelacionFamiliar r1 = new CLS_WSprodonco.RelacionFamiliar();
                r1.CodRelacion = '00100';
                r1.DescRelacion = 'AMIGO';
                relaciones.add(r1);
            }
                      
            //relaciones = ARR_relacion.RelacionFamiliar;            
            System.debug('@@@@ RELACIONES FAMILIAR => ' + relaciones);  
            //Actualizacion Estrcutura Regiones, Ciudades, Comunas
           // CLS_LlamadaWSonco.cargaRegionesCiudadesComunasSF();
            
            Propuesta pro = new Propuesta();
            FormaPago fpa = new FormaPago();
            List<ArrPersona> a_per = new List<ArrPersona>();
            List<ArrContratante> a_contr = new List<ArrContratante>();
            List<ArrBeneficiario> a_ben = new List<ArrBeneficiario>();
        	List<ArrAsegurado> a_aseg = new List<ArrAsegurado>();
        	List<ArrCobertura> a_cob = new List<ArrCobertura>();
			List<ArrIntermediario> a_inter = new List<ArrIntermediario>();

			//Instancias objetos SF
			Opportunity o = new Opportunity();
			List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
            List<Contratante__c> LST_ContratanteCreadoActualizado = new List<Contratante__c>();
            List<Asegurado__c> LST_AseguradosCreadosActualizados = new List<Asegurado__c>();
            List<Cobertura2__c> LST_CoberturaCreadaActualiza = new List<Cobertura2__c>();
            List<Beneficiario2__c> LST_BeneficiariosCreadosActualizados = new List<Beneficiario2__c>();
            List<Intermediario__c> LST_IntermediariosCreadosActualizados = new List<Intermediario__c>();
            
            String RUT_Asegurado = '';

            //Validación y creación Propuesta (Venta - Oportunidad)
            if(datProsp.Propuesta != null){                
                //Propuesa enviado mediante objeto datProsp...
                pro = datProsp.Propuesta;
                
                //Forma pago enviada mediante objeto datProsp...
                fpa = datProsp.FormPago;

                o.Type = 'Propuesta';
                o.OPOR_N_Propuesta__c = String.valueOf(pro.NumPropuesta);
                o.OPOR_Tipo_Folio__c = String.valueOf(pro.TipoFolio);
                o.OPOR_Codigo_Ramo__c = pro.CodRamo;
                o.OPOR_Codigo_Plan__c = pro.CodPlan;
                o.OPOR_Codigo_Producto__c = pro.CodProd;
                o.OPOR_Revision_Plan__c = pro.RevPlan;
                o.OPOR_Codigo_Moneda__c = pro.CodMoneda;
                o.OPOR_Porcentaje_Riesgo__c = pro.PorcRiesgo;
                o.OPOR_Usuario__c = pro.Usuario;
                o.LeadSource = pro.Origen;
                o.OPOR_Codigo_Sucursal__c = pro.CodSucursal;
                o.OPOR_Codigo_Canal__c = String.valueOf(pro.CodCanal);
                o.OPOR_Estado_Propuesta__c = pro.EstadoPropuesta;
                o.Codigo_Periodo_Pago__c = pro.CodPeriodoPago; //Corregir Nombre API Campo
                //public String IdExterno; revisar campo en SF
                o.OPOR_ID_Campa_a_SF__c = pro.IdCampania;
                
                String IdTipoRegistro = '';//[SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Venta - Oncológico'].Id;//debe variar en caso de SP9
                
                Campaign  campagna = [SELECT Id, Name, Type FROM Campaign WHERE Id =: pro.IdCampania];

                if (campagna.Type == 'Salud Protegida')
                {
                    IdTipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Oportunidad - Salud Protegida'].Id;
                }
                else if (campagna.Type == 'Televenta - APEG' || campagna.Type == 'Televenta - Oncológico')
                {
                    IdTipoRegistro = [SELECT Id, Name, SobjectType FROM RecordType WHERE Name = 'Venta - Oncológico'].Id;
                }

                o.CampaignId = campagna.Id;

                o.RecordTypeId = IdTipoRegistro;
                o.StageName = 'Venta - Pendiente Validar';                
                o.CloseDate = Date.today();
                //o.AccountId = [SELECT Id FROM Account WHERE Rut__c =: pro.RutContratante].Id;				
                o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c; 
                
                //Asociando datos forma de pago
                o.OPOR_Codigo_Banco__c = fpa.CodBanco;
                o.OPOR_Codigo_Tarjeta__c = fpa.CodTarjeta;
                o.OPOR_N_Cuenta__c = fpa.NumeroCuenta;
                o.OPOR_Id_Poliza_Asociada__c = String.valueOf(fpa.IdPolizaAsoc);
                o.OPOR_Tipo_Forma_Pago__c = fpa.TipoFormaPago;
                o.OPOR_Fecha_Vencimiento__c = Date.valueOf(fpa.FechaVencimiento);
                
                o.OPOR_Tipo_Cliente__c = 'Nuevo';

                List<Opportunity> OP_RECHAZADAS = new List<Opportunity>();
                OP_RECHAZADAS = [SELECT Id, StageName FROM Opportunity WHERE OPOR_N_Propuesta__c =: o.OPOR_N_Propuesta__c AND StageName = 'Venta - Rechaza Calidad'];               
                
                if(OP_RECHAZADAS.size() > 0)
                {        
                    insert o;
                    
                }else{                                          
                    if (!Test.isRunningTest())
                    {
                        upsert o;  
                    }
                }
                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; PropuestaSF = [' + o.Id + ']';                
            }else{
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; PropuestaSF = [Sin Datos de Propuesta para Crear]';
            }            
            
            //Validación y Creación Lista de Personas...
            if(datProsp.LsPersona.size() > 0){
				
                system.debug('@@@@ LISTA PERSONA => ' + datProsp.LsPersona[0].Persona);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                
                for(Persona per : datProsp.LsPersona[0].Persona){
					
                    system.debug('@@@@ PERSONA NUEVA => ' + per);
                    
                    //Instancia nuevo objeto persona..
                    Persona__c OBJpersona = new Persona__c();
                    
                    OBJpersona.Name = per.Nombres;
                    OBJpersona.PERSO_N_Propuesta__c = o.OPOR_N_Propuesta__c;
                    OBJpersona.PERSO_Apellido_Paterno__c = per.ApellidoPaterno;
                    OBJpersona.PERSO_Apellido_Materno__c = per.ApellidoMaterno;
                    OBJpersona.PERSO_Rut__c = per.Rut;
                    OBJpersona.PERSO_Dv__c = per.Dv;
                    OBJpersona.PERSO_Mail__c = per.Mail;
                    OBJpersona.PERSO_Telefono_Fijo__c = per.TelefonoFijo;
                    OBJpersona.PERSO_Telefono_Movil__c = per.TelefonoMovil;
                    OBJpersona.PERSO_Direccion__c = per.Direccion;
                    OBJpersona.PERSO_Codigo_Comuna__c = per.CodComuna;
                    OBJpersona.PERSO_Codigo_Ciudad__c = per.CodCiudad;
                    OBJpersona.PERSO_Codigo_Region__c = per.CodRegion;
                    OBJpersona.PERSO_Fecha_de_Nacimiento__c = Date.valueOf(per.FechaNacimiento);
                    OBJpersona.PERSO_ID_Persona_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(per.Rut) + '-' + o.Id;
                    OBJpersona.PERSO_ID_SF_Propuesta__c = o.Id;

                    //Nueva persona agregada a lista...
                    LST_PersonasCreadasActualizadas.add(OBJpersona);                   
                }                                               
          
                Persona__c pcom = new Persona__c();
                pcom = LST_PersonasCreadasActualizadas[0];
                integer cantPerRep = 0;
                integer posBorrar = -1;
                for(Persona__c p1 : LST_PersonasCreadasActualizadas){
                    if( pcom.PERSO_ID_Persona_Propuesta__c == p1.PERSO_ID_Persona_Propuesta__c ){
                        pcom = p1;
                        cantPerRep++;
                    }
                    if( cantPerRep > 1 ){
                        //LST_PersonasCreadasActualizadas.Remove(p1);
                        posBorrar = LST_PersonasCreadasActualizadas.indexOf(p1);
                        break;
                    }
                }
                if(posBorrar > -1){
                    LST_PersonasCreadasActualizadas.remove(posBorrar);
                }
                
                if (!Test.isRunningTest())
                {
                	upsert LST_PersonasCreadasActualizadas PERSO_ID_Persona_Propuesta__c;
                }
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; PersonasSF = [' + LST_PersonasCreadasActualizadas + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; PersonasSF = [Sin Datos de Personas para Crear]';                
            }                                  
            
            //Validación y Creación de Asegurados...
            if(datProsp.LsAsegurado.size() > 0){
				
                system.debug('@@@@ LISTA ASEGURADOS => ' + datProsp.LsAsegurado[0].Asegurado);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                double rutAnterior = 0;

                for(Asegurado ase : datProsp.LsAsegurado[0].Asegurado){
					
					if (rutAnterior == ase.Rut)
						break;
					
                    system.debug('@@@@ ASEGURADO NUEVO => ' + ase);
                    
                    //Instancia nuevo objeto persona..
                    Asegurado__c OBJasegurado = new Asegurado__c();
					
                    //Asociar persona al asegurado...
                    for(Persona__c p : LST_PersonasCreadasActualizadas){
                        
                        if( p.PERSO_Rut__c == ase.Rut ){
                            OBJasegurado.ASEG_Persona__c = p.Id;
                            OBJasegurado.Name = p.Name + ' ' + p.PERSO_Apellido_Paterno__c + ' ' + p.PERSO_Apellido_Materno__c;
                            OBJasegurado.ASEG_Dv__c = p.PERSO_Dv__c;
                            OBJasegurado.ASEG_Telefono_1__c = p.PERSO_Telefono_Fijo__c;
                            OBJasegurado.ASEG_Telefono_2__c = p.PERSO_Telefono_Movil__c;
                            OBJasegurado.ASEG_Email_1__c = p.PERSO_Mail__c;
                            OBJasegurado.ASEG_Email_2__c = p.PERSO_Mail__c;
                            OBJasegurado.ASEG_Fecha_de_Nacimiento__c = p.PERSO_Fecha_de_Nacimiento__c;
                            OBJasegurado.ASEG_Apellido_Paterno__c = p.PERSO_Apellido_Paterno__c;
                            OBJasegurado.ASEG_Apellido_Materno__c = p.PERSO_Apellido_Materno__c;
                            OBJasegurado.ASEG_Codigo_Ciudad__c = p.PERSO_Codigo_Ciudad__c;
                            OBJasegurado.ASEG_Codigo_Comuna__c = p.PERSO_Codigo_Comuna__c;
                            OBJasegurado.ASEG_Codigo_Region__c = p.PERSO_Codigo_Region__c;
                            OBJasegurado.ASEG_Direccion__c = p.PERSO_Direccion__c;
                            break;
                        }
                    }
                    OBJasegurado.ASEG_Propuesta__c = o.Id;
                    OBJasegurado.ASEG_Rut__c = ase.Rut;
                    OBJasegurado.ASEG_Codigo_Relacion__c = ase.CodRelacion;
                    OBJasegurado.ASEG_Tipo_de_Folio__c = String.valueOf(ase.TipoFolio);
                    OBJasegurado.ASEG_ID_Asegurado_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(ase.Rut) + '-' + o.Id;

                    RUT_Asegurado = String.ValueOf(OBJasegurado.ASEG_Rut__c);

                    //Nueva persona agregada a lista...
                    LST_AseguradosCreadosActualizados.add(OBJasegurado);
                    rutAnterior = ase.Rut;
                    //Llamada WS para actualización de datos...
                    List<Id> LST_IdAsegurados = new List<Id>();
                    for(Asegurado__c a : LST_AseguradosCreadosActualizados){
                        LST_IdAsegurados.add(a.Id);
                    }
                    
                }
                if (!Test.isRunningTest())
                {
                	upsert LST_AseguradosCreadosActualizados ASEG_ID_Asegurado_Propuesta__c;
                }
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; AseguradosSF = [' + LST_AseguradosCreadosActualizados + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; AseguradosSF = [Sin Datos de Asegurados para Crear]';                
            }  
            
            //Validación y Creación de Coberturas Asegurados...
            if(datProsp.LsCobertura.size() > 0){
				
                system.debug('@@@@ LISTA COBERTURAS => ' + datProsp.LsCobertura[0].Cobertura);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                
                for(Cobertura cob : datProsp.LsCobertura[0].Cobertura){
					
                    system.debug('@@@@ COBERTURA NUEVA => ' + cob);
                    
                    //Instancia nuevo objeto cobertura..
                    Cobertura2__c OBJcobertura = new Cobertura2__c();
					
                    //Asociar cobertura al asegurado...
                    for(Asegurado__c a : LST_AseguradosCreadosActualizados){
                        if( a.ASEG_Rut__c == cob.Rut){
                            OBJcobertura.COB_Asegurado__c = a.Id;
                            OBJcobertura.COB_Dv__c = a.ASEG_Dv__c;
                            break;
                        }
                    }
                    
                    OBJcobertura.COB_Propuesta__c = o.Id;
                    OBJcobertura.COB_Tipo_de_Folio__c = String.valueOf(cob.TipoFolio);
                    OBJcobertura.COB_Rut__c = cob.Rut;
                    OBJcobertura.COB_Codigo_Cobertura__c = cob.CodCobert;
                    OBJcobertura.Name = cob.CodCobert;
                    OBJcobertura.COB_Tasa_Cambio__c = cob.TasaCambio;
                    OBJcobertura.COB_Tasa_Prima__c = cob.TasaPrima;
                    OBJcobertura.COB_Capital_Asegurado__c = cob.CapitalAsegurado;
                    OBJcobertura.COB_Prima_Neta__c = cob.PrimaNeta;
                    OBJcobertura.COB_Impuestos__c = cob.Impuestos;
                    OBJcobertura.COB_Prima_Neta_Local__c = cob.PrimaNetaLocal;
                    OBJcobertura.COB_Impuestos_Local__c = cob.ImpuestosLocal;
                    OBJcobertura.COB_ID_Cobertura_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(cob.Rut) + '-' + cob.CodCobert + '-' + o.Id;
				

                    //Nueva cobertura agregada a lista...
                    LST_CoberturaCreadaActualiza.add(OBJcobertura);
                    
                }
                if (!Test.isRunningTest())
                {
                	upsert LST_CoberturaCreadaActualiza COB_ID_Cobertura_Propuesta__c;
                }
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; CoberturaSF = [' + LST_CoberturaCreadaActualiza + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; CoberturaSF = [Sin Datos de Coberturas para Crear]';                
            }
            
            //Validación y Creación de Beneficiarios...
            if(datProsp.LsBeneficiario.size() > 0){
				
                system.debug('@@@@ LISTA BENEFICIARIOS => ' + datProsp.LsBeneficiario[0].Beneficiario);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                
                for(Beneficiario bene : datProsp.LsBeneficiario[0].Beneficiario){
					
                    system.debug('@@@@ BENEFICIARIO NUEVO => ' + bene);
                    
                    //Instancia nuevo objeto beneficiario..
                    Beneficiario2__c OBJbeneficiario = new Beneficiario2__c();
					
                    //Asociar persona al beneficiario...
                    for(Persona__c p : LST_PersonasCreadasActualizadas){
                        if( p.PERSO_Rut__c == bene.Rut ){
                            OBJbeneficiario.BEN_Persona__c = p.Id;
                            OBJbeneficiario.Name = p.Name + ' ' + p.PERSO_Apellido_Paterno__c + ' ' + p.PERSO_Apellido_Materno__c;
							OBJbeneficiario.BEN_Dv__c = p.PERSO_Dv__c;
							OBJbeneficiario.BEN_Fecha_de_Nacimiento__c = p.PERSO_Fecha_de_Nacimiento__c;
							OBJbeneficiario.BEN_Apellido_Paterno__c = p.PERSO_Apellido_Paterno__c;
							OBJbeneficiario.BEN_Apellido_Materno__c = p.PERSO_Apellido_Materno__c;
							OBJbeneficiario.BEN_Email_1__c = p.PERSO_Mail__c;
							OBJbeneficiario.BEN_Email_2__c = p.PERSO_Mail__c;
                            OBJbeneficiario.BEN_Tel_fono_1__c = p.PERSO_Telefono_Fijo__c;
                            OBJbeneficiario.BEN_Tel_fono_2__c = p.PERSO_Telefono_Movil__c;
                            OBJbeneficiario.BEN_C_digo_Regi_n__c = p.PERSO_Codigo_Region__c;
                            OBJbeneficiario.BEN_C_digo_Ciudad__c = p.PERSO_Codigo_Ciudad__c;
                            OBJbeneficiario.BEN_C_digo_Comuna__c = p.PERSO_Codigo_Comuna__c;
                            break;
                        }
                    }
                    OBJbeneficiario.BEN_Propuesta__c = o.Id;
                    OBJbeneficiario.BEN_Rut__c = bene.Rut;
                    OBJbeneficiario.BEN_Codigo_Relacion__c = bene.CodRelacion;
                    OBJbeneficiario.BEN_Tipo_de_Folio__c = String.valueOf(bene.TipoFolio);
                    OBJbeneficiario.BEN_Participacion__c = bene.Participacion;
                    OBJbeneficiario.BEN_ID_Beneficiario_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + String.valueOf(bene.Rut) + '-' + o.Id;

                    //Nueva persona agregada a lista...
                    LST_BeneficiariosCreadosActualizados.add(OBJbeneficiario);
                    
                }
                if (!Test.isRunningTest())
                {
                	upsert LST_BeneficiariosCreadosActualizados BEN_ID_Beneficiario_Propuesta__c;
                }
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; BeneficiariosSF = [' + LST_BeneficiariosCreadosActualizados + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; BeneficiariosSF = [Sin Datos de Beneficiarios para Crear]';                
            } 
            
            //Validación y Creación de Intermediarios...
            if(datProsp.LsIntermediario.size() > 0){
				
                system.debug('@@@@ LISTA INTERMEDIARIOS => ' + datProsp.LsIntermediario);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                
                for(Intermediario inte : datProsp.LsIntermediario){
					
                    system.debug('@@@@ INTERMEDIARIO NUEVO => ' + inte);
                    
                    //Instancia nuevo objeto intermediario..
                    Intermediario__c OBJintermediario = new Intermediario__c();
					
                    OBJintermediario.INTER_Propuesta__c = o.Id;
                    OBJintermediario.INTER_Tipo_Folio__c = inte.TipoFolio;
                    OBJintermediario.INTER_Codigo_Intermediario__c = inte.CodIntermediario;
                    OBJintermediario.INTER_Participacion__c = inte.Participacion;
                    OBJintermediario.INTER_ID_Intermediario_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + inte.CodIntermediario + '-' + o.Id;

                    //Nueva persona agregada a lista...
                    LST_IntermediariosCreadosActualizados.add(OBJintermediario);
                    
                }
                if (!Test.isRunningTest())
                {
                	upsert LST_IntermediariosCreadosActualizados INTER_ID_Intermediario_Propuesta__c;
                }
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; IntermediariosSF = [' + LST_IntermediariosCreadosActualizados + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; IntermediariosSF = [Sin Datos de Intermediarios para Crear]';                
            }              
            
            //Validación y Creación de Contratante...
            if(datProsp.LsContratante.size() > 0){
				
                system.debug('@@@@ LISTA CONTRATANTE => ' + datProsp.LsContratante[0].ContratantePropuesta);
                
                //List<Persona__c> LST_PersonasCreadasActualizadas = new List<Persona__c>();
                
                for(ContratantePropuesta con : datProsp.LsContratante[0].ContratantePropuesta){
					
                    system.debug('@@@@ CONTRATANTE NUEVO => ' + con);
                    
                    //Instancia nuevo objeto persona..
                    Contratante__c OBJcontratante = new Contratante__c();
					
                    //Asociar persona al asegurado...
                    for(Persona__c p : LST_PersonasCreadasActualizadas){
                        if( p.PERSO_Rut__c == con.Rut ){
                            OBJcontratante.CONTRA_Persona__c = p.Id;
                            OBJcontratante.Name = p.Name + ' ' + p.PERSO_Apellido_Paterno__c + ' ' + p.PERSO_Apellido_Materno__c;
                            OBJcontratante.CONTRA_Dv__c = p.PERSO_Dv__c;
                            OBJcontratante.CONTRA_Telefono_1__c = p.PERSO_Telefono_Fijo__c;
                            OBJcontratante.CONTRA_Telefono_2__c = p.PERSO_Telefono_Movil__c;
                            OBJcontratante.CONTRA_Email_1__c = p.PERSO_Mail__c;
                            OBJcontratante.CONTRA_Email_2__c = p.PERSO_Mail__c;
                            OBJcontratante.CONTRA_Fecha_de_Nacimiento__c = p.PERSO_Fecha_de_Nacimiento__c; 
                            OBJcontratante.CONTRA_Apellido_Paterno__c = p.PERSO_Apellido_Paterno__c;
                            OBJcontratante.CONTRA_Apellido_Materno__c = p.PERSO_Apellido_Materno__c;
                            OBJcontratante.CONTRA_Direccion__c = p.PERSO_Direccion__c;
                            OBJcontratante.CONTRA_Codigo_Ciudad__c = p.PERSO_Codigo_Ciudad__c;
                            OBJcontratante.CONTRA_Codigo_Comuna__c=  p.PERSO_Codigo_Comuna__c;
                            OBJcontratante.CONTRA_Codigo_Region__c = p.PERSO_Codigo_Region__c;
                            
                            
                            
                            break;
                      
                        }
                    }
                    OBJcontratante.CONTRA_Propuesta__c = o.Id;
                    OBJcontratante.CONTRA_Rut__c = con.Rut;
                    OBJcontratante.CONTRA_Tipo_Folio__c = con.TipoFolio;
                    OBJcontratante.CONTRA_ID_Contratante_Propuesta__c = o.OPOR_N_Propuesta__c + '-' + con.Rut + '-' + o.Id;

                    if (con.TipoFolio == 20)
                    {
                        o.OPOR_Tipo_Cliente__c = 'Nuevo';
                        //consulto por RUT que contrato poliza, a quien corresponde dentro del miembro de campaña
                        CampaignMember cmp = [SELECT MCAMP_Carga_Tipo_Cotizacion__c,MCAMP_Carga_Tercero_Dv__c,MCAMP_Carga_Tercero_RUT__c,MCAMP_Carga_Contratante_RUT__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Contratante_Dv__c FROM  CampaignMember 
                        WHERE CampaignId =: o.CampaignId AND  MCAMP_Carga_RUT__c =: RUT_Asegurado];

                        //es actualizado el rut del contratante, esto por retorno desde predigitador
                        if (cmp.MCAMP_Carga_Tipo_Cotizacion__c == 'C')//si contrato el contratante original, el valor de contra_rut__c, toma este valor
                        {
                            OBJcontratante.CONTRA_Rut__c = Decimal.valueOf(cmp.MCAMP_Carga_Contratante_RUT__c);
                        }
                        if (cmp.MCAMP_Carga_Tipo_Cotizacion__c == 'T')//si contrato otro contratante, el valor de contra_rut__c, toma este valor
                        {
                            OBJcontratante.CONTRA_Rut__c = Decimal.valueOf(cmp.MCAMP_Carga_Tercero_RUT__c); 
                        }
                        else if (cmp.MCAMP_Carga_Tipo_Cotizacion__c == 'A')//si contrato el asegurado, el valor de contra_rut__c, toma este valor
                        { 
                            OBJcontratante.Contra_Rut__c = Decimal.valueOf(cmp.MCAMP_Carga_RUT__c); 
                        }
                    }
                    else 
                    {
                        String tipoClientePropuesta = [SELECT 
                                                              MCAMP_Tipo_Cliente__c 
                                                        FROM 
                                                                CampaignMember 
                                                        WHERE 
                                                                CampaignId =: o.CampaignId AND
                                                                MCAMP_Carga_RUT__c =: String.ValueOf(OBJcontratante.CONTRA_Rut__c)].MCAMP_Tipo_Cliente__c;

                        o.OPOR_Tipo_Cliente__c = tipoClientePropuesta;
                    }

                    //Nueva persona agregada a lista...
                    LST_ContratanteCreadoActualizado.add(OBJcontratante);
                                       
                    update o;
                    
                }
                if (!Test.isRunningTest())
                {
               		upsert LST_ContratanteCreadoActualizado CONTRA_ID_Contratante_Propuesta__c;
                }

                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; ContratanteSF = [' + LST_ContratanteCreadoActualizado + ']';                
            }else{                
                RegistraDatosProspectoResult = RegistraDatosProspectoResult + '; ContratanteSF = [Sin Datos de Contatante para Crear]';                
            }              
            
            //Actualización datos dirección...
            for(Contratante__c contra : LST_ContratanteCreadoActualizado){
                
                if(contra.CONTRA_Codigo_Region__c != null){
                    /*
                    Region__c regContra = new Region__c();
                    regContra.REGI_C_digo__c = contra.CONTRA_Codigo_Region__c;
                    contra.CONTRA_Region__c = regContra.REGI_C_digo__c;
					*/
                    system.debug('@@@@ CONTRATANTE REGION QRY => select id from Region__c where REGI_C_digo__c ='+ contra.CONTRA_Codigo_Region__c);

                    contra.CONTRA_Region__c = [select id from Region__c where REGI_C_digo__c =: contra.CONTRA_Codigo_Region__c].Id;
                    system.debug('@@@@ CONTRATANTE REGION => ' +   contra.CONTRA_Region__c);
                }
                
                if(contra.CONTRA_Codigo_Ciudad__c != null){
                    /*
                    Ciudad__c ciuContra = new Ciudad__c();
                    ciuContra.CIUD_C_digo__c = contra.CONTRA_Codigo_Ciudad__c;
                    contra.CONTRA_Ciudad__c = ciuContra.CIUD_C_digo__c;
					*/
                    contra.CONTRA_Ciudad__c = [select id from Ciudad__c where CIUD_C_digo__c =: contra.CONTRA_Codigo_Ciudad__c and CIUD_Codigo_Region__c =: contra.CONTRA_Codigo_Region__c].Id;
                    system.debug('@@@@ CONTRATANTE CIUDAD => ' +   contra.CONTRA_Ciudad__c);
                }
                
                if(contra.CONTRA_Codigo_Comuna__c != null){
                    /*
                    Comuna__c comContra = new Comuna__c();
                    comContra.COMU_Codigo_Comuna__c = contra.CONTRA_Codigo_Comuna__c;
                    contra.CONTRA_Comuna__c = comContra.COMU_Codigo_Comuna__c;
					*/
                    contra.CONTRA_Comuna__c = [select id from Comuna__c where COMU_Codigo_Comuna__c=: contra.CONTRA_Codigo_Comuna__c  and COMU_C_digo_Ciudad__c  =: contra.CONTRA_Codigo_Ciudad__c  and COMU_C_digo_Regi_n__c=: contra.CONTRA_Codigo_Region__c].Id;
                                               
                    system.debug('@@@@ CONTRATANTE COMUNA => ' +   contra.CONTRA_Comuna__c);
                    
                }   
               
                	update contra;              
                 
            }
            

            
			//Actualización relación asegurado...
            for(Asegurado__c aseg : LST_AseguradosCreadosActualizados){
                
                for(CLS_WSprodonco.RelacionFamiliar r : relaciones){
                    if(aseg.ASEG_Codigo_Relacion__c == r.CodRelacion){
                        aseg.ASEG_Relacion__c = r.DescRelacion;
                    }
                }
                
                if (!Test.isRunningTest())
                {
                	update aseg;
                }
            } 
            
			//Actualización relación beneficiario...
            for(Beneficiario2__c bene : LST_BeneficiariosCreadosActualizados){
                
                for(CLS_WSprodonco.RelacionFamiliar r : relaciones){
                    if(bene.BEN_Codigo_Relacion__c == r.CodRelacion){
                        bene.BEN_Relacion__c = r.DescRelacion;
                    }
                }
                if (!Test.isRunningTest())
                {
                	update bene;
                }
            }             
            
            /******************************************************************************************
             * DEBUG ESTRUCTURAS EN SALESFORCE....
             *****************************************************************************************/
            System.debug('@@@@ ESTRUCTURA PROPUESTA       => ' + pro);            
			System.debug('@@@@ ESTRUCTURA FPAGO           => ' + fpa);			
            System.debug('@@@@ ESTRUCTURA PERSONA         => ' + a_per);            
			System.debug('@@@@ ESTRUCTURA CONTRATANTE     => ' + a_contr);
			System.debug('@@@@ ESTRUCTURA BENEFICIARIOS   => ' + a_ben);
			System.debug('@@@@ ESTRUCTURA ASEGURADOS      => ' + a_aseg);
			System.debug('@@@@ ESTRUCTURA COBERTURA       => ' + a_cob);
			System.debug('@@@@ ESTRUCTURA INTERMEDIARIO   => ' + a_inter);            
            
            return RegistraDatosProspectoResult;
        }
        catch(System.Exception ex){
            
            system.debug('@@@@ ERROR - Método Web RegistraDatosProspecto                                            ');
            system.debug('@@@@ ===========================================================================');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage());
            system.debug('@@@@ LÍNEA  : ' + ex.getLineNumber());
            system.debug('@@@@ ===========================================================================');
            RegistraDatosProspectoResult = '@@@@ ERROR - Método Web RegistraDatosProspecto => MENSAJE: ' + ex.getMessage() + 
                                           '; LINEA: ' + ex.getLineNumber() + 
                                           '; CAUSA: ' + ex.getCause();
            return RegistraDatosProspectoResult;            
            
        }
        
    }
    
    //OBJETOS SOLICITUDES y RESPUESTAS...
    //**************************************************************************************************** 
    
    //Solicitud para crear Persona
    global class crearPersonaRequest{
        webservice String Rut;
        webservice String Dv;
        webservice String Nombres;
        webservice String ApellidoPaterno;
        webservice String ApellidoMaterno;
        webservice String Mail;
        webservice String TelefonoFijo;
        webservice String TelefonoMovil;
        webservice String Direccion;
        webservice String CodComuna;
        webservice String CodCiudad;
        webservice String CodRegion;
        webservice Date FechaNacimiento;
    }
    //Respuesta para crear Persona
    global class crearPersonaResponse{
        webservice String IdSfPersona; // Largo 18
        webservice String Mensaje;            
    }
    
    //Solicitud para actualiza Persona
    global class actualizaPersonaRequest{
        webservice String Rut;
        webservice String Dv;
        webservice String Nombres;
        webservice String ApellidoPaterno;
        webservice String ApellidoMaterno;
        webservice String Mail;
        webservice String TelefonoFijo;
        webservice String TelefonoMovil;
        webservice String Direccion;
        webservice String CodComuna;
        webservice String CodCiudad;
        webservice String CodRegion;
        webservice Date FechaNacimiento;
    }
    //Respuesta para actualiza Persona
    global class actualizaPersonaResponse{
        webservice String IdSfPersona; // Largo 18
        webservice String Mensaje;            
    }    
    
    //Solicitud para crear Propuesta
    global class crearPropuestaRequest{
        webservice Integer NumPropuesta;
        webservice Integer TipoFolio;
        webservice String CodRamo;
        webservice String CodPlan;
        webservice String CodProd;
        webservice String RevPlan;
        webservice String CodMoneda;
        webservice Double PorcRiesgo;
        webservice String Usuario;
        webservice String Origen;
        webservice String CodSucursal;
        webservice Integer CodCanal;
        webservice String EstadoPropuesta;
        webservice String CodPeriodoPago;
        webservice String IdExterno;
        webservice String IdCampania;
        webservice String RutContratante;
        webservice Date FechaPropuesta;
    }
    //Respuesta para crear Propuesta
    global class crearPropuestaResponse{
        webservice String IdSfPropuesta; // Largo 18
        webservice String EtapaOportunidad; // Venta - Pendiente Validar
                                            // Venta - Rechaza Calidad
                                            // Venta - Aprobada
                                            // Venta - Perdida
        webservice String Tipo; // Venta
                                // Propuesta
        webservice String IdSfCampana; // Largo 18  
        webservice String IdSfTipoRegistro; // Largo 18 (Permite saber si una Oportunidad - Venta Oncológica u otro proceso de venta)
        webservice String Mensaje;         
    }
    
    //Solicitud para actualizar Propuesta
    global class actualizaPropuestaRequest{
        webservice Integer NumPropuesta;
        webservice Integer TipoFolio;
        webservice String CodRamo;
        webservice String CodPlan;
        webservice String CodProd;
        webservice String RevPlan;
        webservice String CodMoneda;
        webservice Double PorcRiesgo;
        webservice String Usuario;
        webservice String Origen;
        webservice String CodSucursal;
        webservice Integer CodCanal;
        webservice String EstadoPropuesta;
        webservice String CodPeriodoPago;
        webservice String IdExterno;
        webservice String IdCampania;
        webservice String RutContratante;
        webservice Date FechaPropuesta;
    }
    //Respuesta para crear Propuesta
    global class actualizaPropuestaResponse{
        webservice String IdSfPropuesta; // Largo 18
        webservice String EtapaOportunidad; // Venta - Pendiente Validar
                                            // Venta - Rechaza Calidad
                                            // Venta - Aprobada
                                            // Venta - Perdida
        webservice String Tipo; // Venta
                                // Propuesta
        webservice String IdSfCampana; // Largo 18  
        webservice String IdSfTipoRegistro; // Largo 18 (Permite saber si una Oportunidad - Venta Oncológica u otro proceso de venta)
        webservice String Mensaje;         
    }    
    
    //Solicitud para crear Contratante Propuesta
    global class crearContratantePropuestaRequest{
        webservice String Rut;
        webservice Integer Propuesta;
        webservice Integer TipoFolio; 
    }    
    //Respuesta para crear Contratante Propuesta
    global class crearContratantePropuestaResponse{
        
    }
    
    //Solicitud para crear Intermediario Propuesta
    global class crearIntermediarioRequest{
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice String CodIntermediario;
        webservice Double Participacion;          
    }
    //Respuesta para crear Intermediario Propuesta
    global class crearIntermediarioResponse{
        
    }
    
    //Solicitud para crear Formas de Pago
    global class crearFormaPagoRequest{
        webservice Integer Propuesta;
        webservice Integer TipoFolio;
        webservice String TipoFormaPago;
        webservice String CodBanco;
        webservice String CodTarjeta;
        webservice String NumeroCuenta;
        webservice DateTime FechaVencimiento;
        webservice Integer IdPolizaAsoc;         
    }
    //Respuesta para crear Forma de Pago
    global class crearFormaPagoResponse{
        
    }
    
    //Solicitud para crear Cobertura
    global class crearCoberturaRequest{
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice String Rut;
        webservice String CodCobert;
        webservice Double TasaCambio;
        webservice Double TasaPrima;
        webservice Double CapitalAsegurado;
        webservice Double PrimaNeta;
        webservice Double Impuestos;
        webservice Double PrimaNetaLocal;
        webservice Double ImpuestosLocal;         
    } 
    //Respuesta para crear Cobertura
    global class crearCoberturaResponse{
        
    }

    //Solicitud para crear Beneficiario
    global class crearBeneficiarioRequest{
        webservice String Rut;
        webservice Integer Propuesta;
        webservice Integer TipoFolio;
        webservice String CodRelacion;
        webservice Double Participacion;          
    }
    //Respuesta para crear Beneficiario
    global class crearBeneficiarioResponse{
        
    }
    
    //Solicitud para crear Asegurado
    global class crearAseguradoRequest{
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice String Rut;
        webservice String CodRelacion;         
    }
    //Respuesta para crear Asegurado
    global class crearAseguradoResponse{
        
    }
 
    
    //OBJETOS PERSONALIZADOS...
    //****************************************************************************************************
    
    //Objeto Datos Prospecto (Agrupa todas las estructuras)
    global class DatosProspecto {
        webservice Propuesta Propuesta;
        webservice FormaPago FormPago;
        webservice List<ArrPersona> LsPersona;
        webservice List<ArrContratante> LsContratante;
        webservice List<ArrBeneficiario> LsBeneficiario;
        webservice List<ArrAsegurado> LsAsegurado;
        webservice List<ArrCobertura> LsCobertura;
        webservice List<Intermediario> LsIntermediario;
    }
    
    //Objeto Arreglo Personas
    global class ArrPersona{
        webservice List<Persona> Persona;
    }
    
    //Objeto Arrgelo Contratantes
    global class ArrContratante{
        webservice List<ContratantePropuesta> ContratantePropuesta;
    } 
    
    //Objeto Arrego Beneficiarios
    global class ArrBeneficiario{
        webservice List<Beneficiario> Beneficiario;
    }   
    
    //Objeto Arreglo Asegurados
    global class ArrAsegurado{
        webservice List<Asegurado> Asegurado;
    }   
    
    //Objeto Arreglo Cobertura
    global class ArrCobertura{
        webservice List<Cobertura> Cobertura;
    }   
    
    //Objeto Arreglo Intermediario
    global class ArrIntermediario{
        webservice List<Intermediario> Intermediario;
    }
    
    //Objeto Propuesta (Oportunidad)
    global class Propuesta {
        webservice Integer NumPropuesta;
        webservice Integer TipoFolio;
        webservice String CodRamo;
        webservice String CodPlan;
        webservice String CodProd;
        webservice String RevPlan;
        webservice String CodMoneda;
        webservice Double PorcRiesgo;
        webservice String Usuario;
        webservice String Origen;
        webservice String CodSucursal;
        webservice Integer CodCanal;
        webservice String EstadoPropuesta;
        webservice String CodPeriodoPago;
        webservice String IdExterno;
        webservice String IdCampania;
    }  
    
    //Objeto FormaPago
    global class FormaPago {
        webservice Integer Propuesta;
        webservice Integer TipoFolio;
        webservice String TipoFormaPago;
        webservice String CodBanco;
        webservice String CodTarjeta;
        webservice String NumeroCuenta;
        webservice DateTime FechaVencimiento;
        webservice Integer IdPolizaAsoc;
    }
    
    //Objeto Persona (Persona)
    global class Persona {
        webservice Integer Rut;
        webservice String Dv;
        webservice String Nombres;
        webservice String ApellidoPaterno;
        webservice String ApellidoMaterno;
        webservice String Mail;
        webservice String TelefonoFijo;
        webservice String TelefonoMovil;
        webservice String Direccion;
        webservice String CodComuna;
        webservice String CodCiudad;
        webservice String CodRegion;
        webservice DateTime FechaNacimiento;
    }

    //Objeto Contratante (Cuenta Persona)
    global class ContratantePropuesta {
        webservice Integer Rut;
        webservice Integer Propuesta;
        webservice Integer TipoFolio;
    }

    //Objeto Beneficiario
    global class Beneficiario {
        webservice Integer Rut;
        webservice Integer Propuesta;
        webservice Integer TipoFolio;
        webservice String CodRelacion;
        webservice Double Participacion;
    }  
    
    //Objeto Asegurado
    global class Asegurado {
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice Integer Rut;
        webservice String CodRelacion;
    }
    
    //Objeto Cobertura
    global class Cobertura {
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice Integer Rut;
        webservice String CodCobert;
        webservice Double TasaCambio;
        webservice Double TasaPrima;
        webservice Double CapitalAsegurado;
        webservice Double PrimaNeta;
        webservice Double Impuestos;
        webservice Double PrimaNetaLocal;
        webservice Double ImpuestosLocal;
    }    
    
    //Objeto Intermediario (Ejecutivo VS)
    global class Intermediario {
        webservice Integer TipoFolio;
        webservice Integer Propuesta;
        webservice String CodIntermediario;
        webservice Double Participacion;
    }

}