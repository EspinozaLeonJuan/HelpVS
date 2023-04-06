/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-28-2022
 * @last modified by  : Juan Espinoza León
**/
public class EXT_WS_CM_Oncologico {
    public EXT_WS_CM_Oncologico() {

    }

    public class Response{

        public string Codigo;
        public string Descripcion;

        public Response(string Codigo, string Descripcion){

            this.Codigo = Codigo;
            this.Descripcion = Descripcion;

        }

        public Response(){}
    }

    private static Opportunity getOpportunity(String Id)
    {

        Opportunity oportunidad  = [SELECT Id, IsDeleted, AccountId, RecordTypeId, Name, Description, StageName, Amount, Probability, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, ForecastCategory, ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, LastViewedDate, LastReferencedDate,HasOpenActivity, HasOverdueTask, DB_Competitor__c, Codigo_Periodo_Pago__c, OPOR_Codigo_Banco__c, OPOR_Codigo_Canal__c, OPOR_Codigo_Moneda__c, OPOR_Codigo_Plan__c,OPOR_Codigo_Producto__c, OPOR_Codigo_Ramo__c, OPOR_Codigo_Sucursal__c, OPOR_Codigo_Tarjeta__c, OPOR_Estado_Propuesta__c, OPOR_Fecha_Vencimiento__c, OPOR_Folio_SF_Propuesta__c, OPOR_ID_Campa_a_SF__c,OPOR_Id_Poliza_Asociada__c, OPOR_N_Cuenta__c, OPOR_N_Propuesta__c, OPOR_Porcentaje_Riesgo__c, OPOR_Revision_Plan__c, OPOR_Tipo_Folio__c, OPOR_Tipo_Forma_Pago__c, OPOR_Usuario__c,rrpu__Alert_Message__c, OPOR_Comentario_Actualizaci_n_Propuesta__c, OPOR_Motivo_de_Rechazo_o_Perdida__c, Intentos_Consulta_WS_Oncologico__c FROM Opportunity WHERE Id =: Id];

        system.debug('@@@@  PROPUESTA => ' + oportunidad);

        return oportunidad;
    }

    private static Contratante__c getContratante(String Id)
    {
        Contratante__c contratante= [SELECT Id, name, CONTRA_Codigo_Region__c, CONTRA_Codigo_Comuna__c, CONTRA_Codigo_Ciudad__c, CONTRA_Apellido_Materno__c, CONTRA_Apellido_Paterno__c,  CONTRA_Propuesta__c, CONTRA_Rut__c, CONTRA_Dv__c, CONTRA_Email_1__c, CONTRA_Email_2__c, CONTRA_Telefono_1__c, CONTRA_Telefono_2__c, CONTRA_Direccion__c, CONTRA_Fecha_de_Nacimiento__c FROM Contratante__c  WHERE CONTRA_Propuesta__c =: Id Limit 1];

        system.debug('@@@@ Contratante PROPUESTA => ' + contratante);

        return contratante;
    }

    private static List<Cobertura2__c> getCoberturas(String Id)
    {
        List<Cobertura2__c> listaCoberturas = [SELECT Id, name, COB_Capital_Asegurado__c, COB_Codigo_Cobertura__c, COB_Dv__c, COB_Fecha_de_Nacimiento__c, COB_Impuestos__c, COB_Impuestos_Local__c, COB_Prima_Neta__c, COB_Prima_Neta_Local__c, COB_Propuesta__c,    COB_Rut__c, COB_Tasa_Cambio__c, COB_Tasa_Prima__c, COB_Tipo_de_Folio__c FROM Cobertura2__c WHERE COB_Propuesta__c =: Id];

        system.debug('@@@@ ListaCoberturas PROPUESTA => ' + listaCoberturas);

        return listaCoberturas;
    }

    private static List<Persona__c> getPersonas(String Id)
    {
        List<Persona__c> listaPersonas =  [SELECT id, name, PERSO_Rut__c, PERSO_Dv__c, PERSO_Apellido_Materno__c, PERSO_Apellido_Paterno__c, PERSO_Fecha_de_Nacimiento__c, PERSO_Mail__c FROM Persona__c WHERE PERSO_ID_SF_Propuesta__c =: Id ];

        system.debug('@@@@ listaPersonas PROPUESTA => ' + listaPersonas);

        return listaPersonas;
    }

    private static Response getResponse(String respuesta)
    {
        Response response = null;

        try
        {
            response = (Response)JSON.deserialize(respuesta, Response.class);
        }
        catch(Exception ex)
        {

        }

        return response;
    }


     //Método Actulizar Datos Propuesta WS (SF a Backoffice Oncológico)
     @future(callout=true)
     public static void actualizarPropuesta(String usuario, String idPropuesta){

        // system.debug('@@@@ ENTRADA actualizarPropuestaOnco nPropuesta:' + idPropuesta);

        // if (String.isNotBlank(idPropuesta))
        // {
        //     Opportunity propuesta  =  getOpportunity(idPropuesta);

        //     Contratante__c Contratante  =  getContratante(idPropuesta);

        //     List<Persona__c> ListaPersonas   =  getPersonas(idPropuesta);

        //     List<Cobertura2__c> ListaCoberturas =  getCoberturas(idPropuesta);

        //     try
        //     {
        //         EXT_WS_Oncologico_Ope.WsProductoOncologicoOperSoap cnx = new EXT_WS_Oncologico_Ope.WsProductoOncologicoOperSoap();
        //         EXT_WS_Oncologico_Ope.DatosProspecto datProsp = new EXT_WS_Oncologico_Ope.DatosProspecto();
        //         EXT_WS_Oncologico_Ope.Propuesta ws_prop = new EXT_WS_Oncologico_Ope.Propuesta();
        //         EXT_WS_Oncologico_Ope.FormaPago ws_fpago = new EXT_WS_Oncologico_Ope.FormaPago();
        //         List<EXT_WS_Oncologico_Ope.Persona> ws_lpersona = new List<EXT_WS_Oncologico_Ope.Persona>();
        //         List<EXT_WS_Oncologico_Ope.ContratantePropuesta> ws_lcontra = new List<EXT_WS_Oncologico_Ope.ContratantePropuesta>();
        //         List<EXT_WS_Oncologico_Ope.Beneficiario> ws_lbene = new List<EXT_WS_Oncologico_Ope.Beneficiario>();
        //         List<EXT_WS_Oncologico_Ope.Asegurado> ws_laseg = new List<EXT_WS_Oncologico_Ope.Asegurado>();
        //         List<EXT_WS_Oncologico_Ope.Cobertura> ws_lcobertura = new List<EXT_WS_Oncologico_Ope.Cobertura>();
        //         List<EXT_WS_Oncologico_Ope.Intermediario> ws_linter = new List<EXT_WS_Oncologico_Ope.Intermediario>();
        //         EXT_WS_Oncologico_Ope.ArrayOfPersona ws_arrPerson = new EXT_WS_Oncologico_Ope.ArrayOfPersona();
        //         EXT_WS_Oncologico_Ope.ArrayOfContratantePropuesta ws_arrcontra = new EXT_WS_Oncologico_Ope.ArrayOfContratantePropuesta();
        //         EXT_WS_Oncologico_Ope.ArrayOfBeneficiario ws_arrBene = new EXT_WS_Oncologico_Ope.ArrayOfBeneficiario();
        //         EXT_WS_Oncologico_Ope.ArrayOfAsegurado ws_arrAseg = new EXT_WS_Oncologico_Ope.ArrayOfAsegurado();
        //         EXT_WS_Oncologico_Ope.ArrayOfCobertura ws_arrCobertura= new EXT_WS_Oncologico_Ope.ArrayOfCobertura();
        //         EXT_WS_Oncologico_Ope.ArrayOfIntermediario ws_arrInter = new EXT_WS_Oncologico_Ope.ArrayOfIntermediario();

        //         // Asociación Datos Propuesta....
        //         ws_prop.CodCanal = Integer.valueOf(propuesta.OPOR_Codigo_Canal__c);
        //         ws_prop.CodMoneda = propuesta.OPOR_Codigo_Moneda__c;
        //         ws_prop.CodPeriodoPago = propuesta.Codigo_Periodo_Pago__c;
        //         ws_prop.CodPlan = propuesta.OPOR_Codigo_Plan__c;
        //         ws_prop.CodProd = propuesta.OPOR_Codigo_Producto__c;
        //         ws_prop.CodRamo = propuesta.OPOR_Codigo_Ramo__c;
        //         ws_prop.CodSucursal = propuesta.OPOR_Codigo_Sucursal__c;
        //         ws_prop.EstadoPropuesta = propuesta.OPOR_Estado_Propuesta__c;
        //         ws_prop.IdCampania = propuesta.OPOR_ID_Campa_a_SF__c;
        //         ws_prop.IdExterno = propuesta.OPOR_Folio_SF_Propuesta__c;
        //         ws_prop.NumPropuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
        //         ws_prop.Origen = propuesta.LeadSource;
        //         ws_prop.PorcRiesgo = propuesta.OPOR_Porcentaje_Riesgo__c;
        //         ws_prop.RevPlan = propuesta.OPOR_Revision_Plan__c;
        //         ws_prop.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);
        //         ws_prop.Usuario = propuesta.OPOR_Usuario__c;

        //         //Datos forma pago..
        //         ws_fpago.CodBanco = propuesta.OPOR_Codigo_Banco__c;
        //         ws_fpago.CodTarjeta = propuesta.OPOR_Codigo_Tarjeta__c;
        //         ws_fpago.FechaVencimiento = propuesta.OPOR_Fecha_Vencimiento__c;

        //         if(propuesta.OPOR_Id_Poliza_Asociada__c != null){
        //             ws_fpago.IdPolizaAsoc = Integer.valueOf(propuesta.OPOR_Id_Poliza_Asociada__c);
        //         }

        //         ws_fpago.NumeroCuenta = propuesta.OPOR_N_Cuenta__c;
        //         ws_fpago.Propuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
        //         ws_fpago.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);
        //         ws_fpago.TipoFormaPago = propuesta.OPOR_Tipo_Forma_Pago__c;


        //         EXT_WS_Oncologico_Ope.ContratantePropuesta ws_Contratante = new EXT_WS_Oncologico_Ope.ContratantePropuesta();

        //         // Asociación datos contratante
        //         ws_Contratante.Propuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
        //         ws_Contratante.Rut = Integer.valueOf(Contratante.CONTRA_Rut__c);
        //         ws_Contratante.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);

        //         // Agregar elemento contratante a lista contrantes WS
        //         ws_lcontra.add(ws_Contratante);


        //         for(Persona__c a: ListaPersonas)
        //         {

        //             // Instancia nueva persona WService
        //             EXT_WS_Oncologico_Ope.Persona ws_Persona = new EXT_WS_Oncologico_Ope.Persona();

        //             // Asociación datos personas SF combinados con datos de contacto contratante SF
        //             ws_Persona.Rut = Integer.valueOf(a.PERSO_Rut__c);
        //             ws_Persona.Dv =  a.PERSO_Dv__c;
        //             ws_Persona.ApellidoMaterno = a.PERSO_Apellido_Materno__c;
        //             ws_Persona.ApellidoPaterno = a.PERSO_Apellido_Paterno__c;
        //             ws_Persona.Direccion = Contratante.CONTRA_Direccion__c;
        //             ws_Persona.TelefonoFijo = Contratante.CONTRA_Telefono_1__c;
        //             ws_Persona.TelefonoMovil = Contratante.CONTRA_Telefono_2__c;
        //             ws_Persona.FechaNacimiento = a.PERSO_Fecha_de_Nacimiento__c;
        //             ws_Persona.Mail = a.PERSO_Mail__c;
        //             ws_Persona.Nombres = a.Name;
        //             ws_Persona.CodCiudad = Contratante.CONTRA_Codigo_Ciudad__c;
        //             ws_Persona.CodComuna = Contratante.CONTRA_Codigo_Comuna__c;
        //             ws_Persona.CodRegion = Contratante.CONTRA_Codigo_Region__c;

        //             // Agregar elemento Persona a Lista Personas WS
        //             ws_lpersona.add(ws_Persona);
        //         }

        //         system.debug('@@@@ Personas WS PROPUESTA => ' + ws_lpersona);

        //         for(Cobertura2__c cobertura : ListaCoberturas)
        //         {
        //             // Instancia objeto cobertura WS
        //             EXT_WS_Oncologico_Ope.Cobertura  ws_Cobertura = new EXT_WS_Oncologico_Ope.Cobertura();

        //             // Asociación datos de cobertura
        //             ws_Cobertura.CapitalAsegurado=cobertura.COB_Capital_Asegurado__c;
        //             ws_Cobertura.CodCobert=cobertura.COB_Codigo_Cobertura__c;
        //             ws_Cobertura.Impuestos=cobertura.COB_Impuestos__c;
        //             ws_Cobertura.ImpuestosLocal=cobertura.COB_Impuestos_Local__c;
        //             ws_Cobertura.PrimaNeta=cobertura.COB_Prima_Neta__c;
        //             ws_Cobertura.PrimaNetaLocal=cobertura.COB_Prima_Neta_Local__c;
        //             ws_Cobertura.Propuesta=Integer.valueOf( propuesta.OPOR_N_Propuesta__c );
        //             ws_Cobertura.Rut=Integer.valueOf( cobertura.COB_Rut__c );
        //             ws_Cobertura.TasaCambio=  cobertura.COB_Tasa_Cambio__c ;
        //             ws_Cobertura.TasaPrima= cobertura.COB_Tasa_Prima__c ;
        //             ws_Cobertura.TipoFolio= Integer.valueOf(cobertura.COB_Tipo_de_Folio__c) ;

        //             // Agregando elemento cobertura a lista coberturas WS
        //             ws_lcobertura.add(ws_Cobertura);

        //         }

        //         system.debug('@@@@ Coberturas WS PROPUESTA => ' + ws_lcobertura);

        //         // Asignación lista de objetos ws a arreglos ws
        //         ws_arrPerson.Persona = ws_lpersona;
        //         ws_arrcontra.ContratantePropuesta = ws_lcontra;
        //         ws_arrBene.Beneficiario = ws_lBene;
        //         ws_arrAseg.Asegurado = ws_lAseg;
        //         ws_arrCobertura.Cobertura = ws_lcobertura;
        //         ws_arrInter.Intermediario = ws_lInter;

        //         //Asociar objetos y arreglos a Datos Prospecto...
        //         datProsp.Propuesta = ws_prop;
        //         datProsp.FormPago = ws_fpago;
        //         datProsp.LsPersona = ws_arrPerson;
        //         datProsp.LsContratante = ws_arrcontra;
        //         datProsp.LsBeneficiario = ws_arrBene;
        //         datProsp.LsAsegurado = ws_arrAseg;
        //         datProsp.LsCobertura = ws_arrCobertura;
        //         datProsp.LsIntermediario = ws_arrInter;

        //         system.debug('@@@@ WS ACTUALIZA DATOS PROPUESTA => ' + datProsp);
        //         String respuesta;

        //         // Llamada a Método Web (WS) para actualizar datos prospecto
        //         if( !Test.isRunningTest() ){
        //             respuesta = cnx.ActualizaDatosPropuesta(usuario, datProsp);
        //         }else{
        //             respuesta = '{"Codigo":200,"Descripcion":"La póliza se ha activado correctamente."}';
        //         }

        //         system.debug('@@@@ RESPUESTA WS ACTUALIZA DATOS PROPUESTA => ' + respuesta);

        //         Response response = getResponse(respuesta);

        //         system.debug('@@@@ response => ' + response);

        //         propuesta.Intentos_Consulta_WS_Oncologico__c = propuesta.Intentos_Consulta_WS_Oncologico__c + 1;

        //         if (response != null)
        //         {
        //             system.debug('@@@@ RESPUESTA FORMATEADA => ' + response);

        //             if (response.Codigo == '200' || response.Codigo == '409')
        //             {
        //                 propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'PÓLIZA ACTIVA...';
        //                 propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = true;
        //             }
        //             else//400
        //             {
        //                 propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
        //                 propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = '';
        //               //  propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'PENDIENTE VALIDAR ACTIVACION';
        //             }
        //         }
        //         else //(ERROR WS TIME OUT)
        //         {
        //             propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
        //             propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = '';
        //         }

        //     }
        //     catch(Exception ex)
        //     {
        //         if (propuesta.Intentos_Consulta_WS_Oncologico__c == 1)
        //         {
        //             propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
        //             propuesta.StageName = 'Venta - Pendiente Validar';
        //             propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'NO SE PUDO ACTIVAR PÓLIZA,... INTENTE MAS TARDE';
        //         }


        //         system.debug('@@@@ ERROR - ACTUALIZAR PROPUESTA SF A BACKOFFICE ONCO WS                 ');
        //         system.debug('@@@@ *********************************************************************');
        //         system.debug('@@@@ MENSAJE: ' + ex.getMessage());
        //         system.debug('@@@@ LINEA:   ' + ex.getLineNumber());
        //     }

        //     update propuesta;
        // }

        validarPropuesta(usuario, idPropuesta);
     }

     public static void validarPropuesta(String usuario, String idPropuesta){

        system.debug('@@@@ ENTRADA actualizarPropuestaOnco nPropuesta:' + idPropuesta);

        if (String.isNotBlank(idPropuesta))
        {
            Opportunity propuesta  =  getOpportunity(idPropuesta);

            Contratante__c Contratante  =  getContratante(idPropuesta);

            List<Persona__c> ListaPersonas   =  getPersonas(idPropuesta);

            List<Cobertura2__c> ListaCoberturas =  getCoberturas(idPropuesta);

            try
            {
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
                ws_prop.CodCanal = Integer.valueOf(propuesta.OPOR_Codigo_Canal__c);
                ws_prop.CodMoneda = propuesta.OPOR_Codigo_Moneda__c;
                ws_prop.CodPeriodoPago = propuesta.Codigo_Periodo_Pago__c;
                ws_prop.CodPlan = propuesta.OPOR_Codigo_Plan__c;
                ws_prop.CodProd = propuesta.OPOR_Codigo_Producto__c;
                ws_prop.CodRamo = propuesta.OPOR_Codigo_Ramo__c;
                ws_prop.CodSucursal = propuesta.OPOR_Codigo_Sucursal__c;
                ws_prop.EstadoPropuesta = propuesta.OPOR_Estado_Propuesta__c;
                ws_prop.IdCampania = propuesta.OPOR_ID_Campa_a_SF__c;
                ws_prop.IdExterno = propuesta.OPOR_Folio_SF_Propuesta__c;
                ws_prop.NumPropuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
                ws_prop.Origen = propuesta.LeadSource;
                ws_prop.PorcRiesgo = propuesta.OPOR_Porcentaje_Riesgo__c;
                ws_prop.RevPlan = propuesta.OPOR_Revision_Plan__c;
                ws_prop.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);
                ws_prop.Usuario = propuesta.OPOR_Usuario__c;

                //Datos forma pago..
                ws_fpago.CodBanco = propuesta.OPOR_Codigo_Banco__c;
                ws_fpago.CodTarjeta = propuesta.OPOR_Codigo_Tarjeta__c;
                ws_fpago.FechaVencimiento = propuesta.OPOR_Fecha_Vencimiento__c;

                if(propuesta.OPOR_Id_Poliza_Asociada__c != null){
                    ws_fpago.IdPolizaAsoc = Integer.valueOf(propuesta.OPOR_Id_Poliza_Asociada__c);
                }

                ws_fpago.NumeroCuenta = propuesta.OPOR_N_Cuenta__c;
                ws_fpago.Propuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
                ws_fpago.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);
                ws_fpago.TipoFormaPago = propuesta.OPOR_Tipo_Forma_Pago__c;


                EXT_WS_Oncologico_Ope.ContratantePropuesta ws_Contratante = new EXT_WS_Oncologico_Ope.ContratantePropuesta();

                // Asociación datos contratante
                ws_Contratante.Propuesta = Integer.valueOf(propuesta.OPOR_N_Propuesta__c);
                ws_Contratante.Rut = Integer.valueOf(Contratante.CONTRA_Rut__c);
                ws_Contratante.TipoFolio = Integer.valueOf(propuesta.OPOR_Tipo_Folio__c);

                // Agregar elemento contratante a lista contrantes WS
                ws_lcontra.add(ws_Contratante);


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

                system.debug('@@@@ Personas WS PROPUESTA => ' + ws_lpersona);

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
                    ws_Cobertura.Propuesta=Integer.valueOf( propuesta.OPOR_N_Propuesta__c );
                    ws_Cobertura.Rut=Integer.valueOf( cobertura.COB_Rut__c );
                    ws_Cobertura.TasaCambio=  cobertura.COB_Tasa_Cambio__c ;
                    ws_Cobertura.TasaPrima= cobertura.COB_Tasa_Prima__c ;
                    ws_Cobertura.TipoFolio= Integer.valueOf(cobertura.COB_Tipo_de_Folio__c) ;

                    // Agregando elemento cobertura a lista coberturas WS
                    ws_lcobertura.add(ws_Cobertura);

                }

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

                Response response = getResponse(respuesta);

                system.debug('@@@@ response => ' + response);

                if (propuesta.Intentos_Consulta_WS_Oncologico__c == null)
                    propuesta.Intentos_Consulta_WS_Oncologico__c = 0;

                propuesta.Intentos_Consulta_WS_Oncologico__c = propuesta.Intentos_Consulta_WS_Oncologico__c + 1;

                if (response != null)
                {
                    system.debug('@@@@ RESPUESTA FORMATEADA => ' + response);

                    if (response.Codigo == '200' || response.Codigo == '409')
                    {
                        propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'PÓLIZA ACTIVA...';
                        propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = true;
                    }
                    else//400
                    {
                        propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
                        propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = '';
                      //  propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'PENDIENTE VALIDAR ACTIVACION';
                    }
                }
                else //(ERROR WS TIME OUT)
                {
                    propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
                    propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = '';
                }

            }
            catch(Exception ex)
            {
                if (propuesta.Intentos_Consulta_WS_Oncologico__c == 1)
                {
                    propuesta.OPOR_WS_Actualiza_Datos_Prospecto__c = false;
                    propuesta.StageName = 'Venta - Pendiente Validar';
                    propuesta.OPOR_Comentario_Actualizaci_n_Propuesta__c = 'NO SE PUDO ACTIVAR PÓLIZA,... INTENTE MAS TARDE';
                }


                system.debug('@@@@ ERROR - ACTUALIZAR PROPUESTA SF A BACKOFFICE ONCO WS                 ');
                system.debug('@@@@ *********************************************************************');
                system.debug('@@@@ MENSAJE: ' + ex.getMessage());
                system.debug('@@@@ LINEA:   ' + ex.getLineNumber());
            }

            update propuesta;
        }

     }

}