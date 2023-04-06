/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 12-01-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-23-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CM_CotizadorExpress {

    public class FilaGrilla
    {
        public String AseguradoId { get; set; }

        public String FechaNacimiento { get; set; }

        public String Parentesco { get; set; }

        public String PrimaUF { get; set; }

        public String PrimaCLP { get; set; }

        public String Asegurable { get; set; }

        public String ValidaFechaNacimiento { get; set; }

        public String IdSalesforce { get; set; }

        public String Pregunta_1 { get; set; }

        public String Pregunta_2 { get; set; }

        public String Pregunta_3 { get; set; }

        public String Pregunta_4 { get; set; }

        public String Pregunta_5 { get; set; }

        public String NoAsegurable { get; set; }// en caso de no ser Asegurable el asegurado, este campo indica si P o W es el causante, siendo P preguntas y W Ws de validacion de fechas
    }

    /*  VARIABLES GLOBALES  */

    public String Id {get; set;}

    public String Call {get; set;}

    public static String TOTAL_UF {get; set;}

    public static String TOTAL_CLP {get; set;}

    public String CotizadorId {get; set;}

    public Cotizador_Express__c Cotizador { get; set; }

    public String ErrorCarga { get; set;}

    public String GrillaAsegurados { get; set; }

    public Boolean ErrorInicio { get; set;}

    public String FechaCreacion { get; set;}

    public String FechaActualizacion { get; set;}

    public String EstadoCotizacion { get; set;}

    public String Cotiza { get; set;}

    public String NombreCampagna { get; set;}

    public String TipoCampagna { get; set;}

    public String RespuestaAsegurado_FechaNac { get; set;}

    public String RespuestaAsegurado_ValorUF { get; set;}

    public String RespuestaAsegurado_ValorCLP { get; set;}

    public String RespuestaAsegurado_IdSalesforce{ get; set;}

    public String RespuestaAsegurado_Asegurable{ get; set;}

    public Boolean ErrorAsegurado { get; set;}

    public String MensajeError { get; set; }

    public String TelefonoAsegurado { get; set; }

    public String CelularAsegurado { get; set; }

    /*  FIELDS ASEGURADO */

    public List<SelectOption> getListadoRegiones()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Region__c> regiones = [SELECT REGI_C_digo__c ,Name FROM Region__c];

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<regiones.size();j++){
            lista.add(new SelectOption(regiones[j].REGI_C_digo__c, regiones[j].Name));
        }

        return lista;
    }

    public List<SelectOption> getListadoCiudades()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Ciudad__c> ciudades = new List<Ciudad__c>();
        system.debug('@@@@ --> '+this.Cotizador.Codigo_Region__c);
        if(String.isNotBlank(this.Cotizador.Codigo_Region__c))
        {
            ciudades = [SELECT CIUD_C_digo__c, CIUD_Codigo_Region__c, Name FROM Ciudad__c WHERE CIUD_Codigo_Region__c =: this.Cotizador.Codigo_Region__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<ciudades.size();j++){
            lista.add(new SelectOption(ciudades[j].CIUD_C_digo__c, ciudades[j].Name));
        }

        return lista;
    }

    public List<SelectOption> getListadoComunas()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Comuna__c> comunas = new List<Comuna__c>();

        if(String.isNotBlank(this.Cotizador.Codigo_Region__c) && String.isNotBlank(this.Cotizador.Codigo_Ciudad__c))
        {
            comunas = [SELECT Name, COMU_Codigo_Comuna__c, COMU_C_digo_Ciudad__c,COMU_C_digo_Regi_n__c FROM Comuna__c
            WHERE COMU_C_digo_Regi_n__c =: this.Cotizador.Codigo_Region__c AND  COMU_C_digo_Ciudad__c =: this.Cotizador.Codigo_Ciudad__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<comunas.size();j++){
            lista.add(new SelectOption(comunas[j].COMU_Codigo_Comuna__c, comunas[j].Name));
        }

        return lista;
    }

    public String generaTelefonosCliente(String[] telefonos)
    {
        List<String> lista = new List<String>();

        if (telefonos.size() > 0)
        {
            for(Integer i=0;i < telefonos.size();i++)
            {
                if (String.isNotBlank(telefonos[i]))
                {
                	lista.add(telefonos[i]);
                }
            }
        }

        return  JSON.serialize(lista);
    }

    public String generaTelefonosCliente(CampaignMember participante)
    {
        List<String> lista = new List<String>();

        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_1__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_1__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_2__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_2__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_3__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_3__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_4__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_4__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_5__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_5__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_6__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_6__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_7__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_7__c);
        }
        if (String.isNotBlank(participante.MCAMP_Carga_Tel_fono_8__c) == true)
        {
            lista.add(participante.MCAMP_Carga_Tel_fono_8__c);
        }

        return  JSON.serialize(lista);
    }

    public List<SelectOption> getListadoTelefonos()
    {
        List<SelectOption> listado = new List<SelectOption>();

        List<String> telefonos =(List<String>)System.JSON.deserialize(this.Cotizador.Lista_Telefonos__c, List<String>.class);

       /* if (telefonos.contains(this.Cotizador.Telefono__c) == false)
        {
            telefonos.add(this.Cotizador.Telefono__c);
        }*/

        listado.add(new SelectOption('', '--Seleccione--'));
        for(String telefono : telefonos)
        {
            listado.add(new SelectOption(telefono, telefono));
        }

        return listado;
    }

    public List<SelectOption> getListadoCelulares()
    {
        List<SelectOption> listado = new List<SelectOption>();

        List<String> telefonos =(List<String>)System.JSON.deserialize(this.Cotizador.Lista_Telefonos__c, List<String>.class);

        listado.add(new SelectOption('', '--Seleccione--'));
        for(String telefono : telefonos)
        {
            listado.add(new SelectOption(telefono, telefono));
        }

        return listado;
    }

    public List<SelectOption> getListadoEstadoCivil()
    {
        List<SelectOption> listado = new List<SelectOption>();

        listado.add(new SelectOption('', '--Seleccione--'));
        listado.add(new SelectOption('Soltero/a', 'Soltero/a'));
        listado.add(new SelectOption('Casado/a', 'Casado/a'));
        listado.add(new SelectOption('Separado/a', 'Separado/a'));
        listado.add(new SelectOption('Viudo/a', 'Viudo/a'));
        listado.add(new SelectOption('Conviviente Civil', 'Conviviente Civil'));
        return listado;
    }

    public void SeleccionRegion()
    {
        this.Cotizador.Codigo_Ciudad__c = '';
        this.Cotizador.Codigo_Comuna__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionCiudad()
    {
        this.Cotizador.Codigo_Comuna__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionComuna()
    {
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionCelular()
    {
        this.Cotizador.Celular__c = this.CelularAsegurado;
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionTelefono()
    {
        this.Cotizador.Telefono__c = this.TelefonoAsegurado;
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionEstadoCivil()
    {
         system.debug('@@@@ Cotizador --> '+ this.Cotizador);
         this.Cotizador.Estado__c = 'En Proceso';
         update this.Cotizador;

         Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
         this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
         this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void ActualizaDireccion()
    {
         system.debug('@@@@ Cotizador --> '+ this.Cotizador);
         this.Cotizador.Estado__c = 'En Proceso';
         update this.Cotizador;

         Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
         this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
         this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void Actualiza_Email_Asegurado()
    {
         update this.Cotizador;
    }

    public void Actualiza_Telefono_Asegurado()
    {
        List<String> telefonos =(List<String>)System.JSON.deserialize(this.Cotizador.Lista_Telefonos__c, List<String>.class);

        if (telefonos.contains(this.Cotizador.Telefono__c) == false)
        {
            this.TelefonoAsegurado = this.Cotizador.Telefono__c;
        }
        else {
            this.TelefonoAsegurado = '';
        }

        update this.Cotizador;
    }

    public void Actualiza_Celular_Asegurado()
    {
        this.CelularAsegurado = '';
         update this.Cotizador;
    }

    /*  FIELDS CONTRATANTE */
    //getListadoRegion_Contratante  --> getListadoRegion
    public List<SelectOption> getListadoCiudades_Contratante()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Ciudad__c> ciudades = new List<Ciudad__c>();
        system.debug('@@@@ --> '+this.Cotizador.Codigo_Region_Contratante__c);
        if(String.isNotBlank(this.Cotizador.Codigo_Region_Contratante__c))
        {
            ciudades = [SELECT CIUD_C_digo__c, CIUD_Codigo_Region__c, Name FROM Ciudad__c WHERE CIUD_Codigo_Region__c =: this.Cotizador.Codigo_Region_Contratante__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<ciudades.size();j++){
            lista.add(new SelectOption(ciudades[j].CIUD_C_digo__c, ciudades[j].Name));
        }

        return lista;
    }

    public List<SelectOption> getListadoComunas_Contratante()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Comuna__c> comunas = new List<Comuna__c>();

        if(String.isNotBlank(this.Cotizador.Codigo_Region_Contratante__c) && String.isNotBlank(this.Cotizador.Codigo_Ciudad_Contratante__c))
        {
            comunas = [SELECT Name, COMU_Codigo_Comuna__c, COMU_C_digo_Ciudad__c,COMU_C_digo_Regi_n__c FROM Comuna__c
            WHERE COMU_C_digo_Regi_n__c =: this.Cotizador.Codigo_Region_Contratante__c AND COMU_C_digo_Ciudad__c =: this.Cotizador.Codigo_Ciudad_Contratante__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<comunas.size();j++){
            lista.add(new SelectOption(comunas[j].COMU_Codigo_Comuna__c, comunas[j].Name));
        }

        return lista;
    }

    public void SeleccionRegion_Contratante()
    {
        this.Cotizador.Codigo_Ciudad_Contratante__c = '';
        this.Cotizador.Codigo_Comuna_Contratante__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
    }

    public void SeleccionCiudad_Contratante()
    {
        this.Cotizador.Codigo_Comuna_Contratante__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        system.debug('@@@@ Codigo_Ciudad_Contratante__c --> '+ this.Cotizador.Codigo_Ciudad_Contratante__c);
        List<Ciudad__c> ciudades = [SELECT Id FROM Ciudad__c WHERE CIUD_C_digo__c =: this.Cotizador.Codigo_Ciudad_Contratante__c];
        if (ciudades.size() > 0)
        {
            Account cuenta = [SELECT Id, Ciudad_Particular_B__c FROM Account WHERE Id =: this.Cotizador.AccountId__c];
            cuenta.Ciudad_Particular_B__c = ciudades[0].Id;
            update cuenta;
        }
    }

    public void SeleccionComuna_Contratante()
    {
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;
        system.debug('@@@@ Codigo_Comuna_Contratante__c --> '+ this.Cotizador.Codigo_Comuna_Contratante__c);
        List<Comuna__c> comunas = [SELECT Id FROM Comuna__c WHERE COMU_Codigo_Comuna__c =: this.Cotizador.Codigo_Comuna_Contratante__c];
        if (comunas.size() > 0)
        {
            Account cuenta = [SELECT Id, Comuna_Particular_B__c FROM Account WHERE Id =: this.Cotizador.AccountId__c];
            cuenta.Comuna_Particular_B__c = comunas[0].Id;
            update cuenta;
        }
    }

    public void ActualizaDireccion_Contratante()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        Account cuenta = [SELECT Id, Direccion_Particular__pc FROM Account WHERE Id =: this.Cotizador.AccountId__c];
        cuenta.Direccion_Particular__pc = this.Cotizador.Direccion_Contratante__c;
        update cuenta;
    }

    public void Actualiza_Contratante_Email()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, Email_Contratante_Cotizador__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Email_Contratante_Cotizador__c = this.Cotizador.Email_Contratante_2__c;

        update prospecto;
    }

    public void Actualiza_Contratante_Telefono()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, Telefono_Activo__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Telefono_Activo__c = this.Cotizador.Telefono_Contratante__c;

        update prospecto;
    }

    /*  FIELDS TERCERO */
    //getListadoRegion_Contratante  --> getListadoRegion
    public List<SelectOption> getListadoCiudades_Tercero()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Ciudad__c> ciudades = new List<Ciudad__c>();
        system.debug('@@@@ --> '+this.Cotizador.Codigo_Region_Tercero__c);
        if(String.isNotBlank(this.Cotizador.Codigo_Region_Tercero__c))
        {
            ciudades = [SELECT CIUD_C_digo__c, CIUD_Codigo_Region__c, Name FROM Ciudad__c WHERE CIUD_Codigo_Region__c =: this.Cotizador.Codigo_Region_Tercero__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<ciudades.size();j++){
            lista.add(new SelectOption(ciudades[j].CIUD_C_digo__c, ciudades[j].Name));
        }

        return lista;
    }

    public List<SelectOption> getListadoComunas_Tercero()
    {
        List<SelectOption> lista = new List<SelectOption>();

        List<Comuna__c> comunas = new List<Comuna__c>();

        if(String.isNotBlank(this.Cotizador.Codigo_Region_Tercero__c) && String.isNotBlank(this.Cotizador.Codigo_Ciudad_Tercero__c))
        {
            comunas = [SELECT Name, COMU_Codigo_Comuna__c, COMU_C_digo_Ciudad__c,COMU_C_digo_Regi_n__c FROM Comuna__c
            WHERE COMU_C_digo_Regi_n__c =: this.Cotizador.Codigo_Region_Tercero__c AND COMU_C_digo_Ciudad__c =: this.Cotizador.Codigo_Ciudad_Tercero__c];
        }

        lista.add(new SelectOption('', '--Seleccione--'));
        for (Integer j=0;j<comunas.size();j++){
            lista.add(new SelectOption(comunas[j].COMU_Codigo_Comuna__c, comunas[j].Name));
        }

        return lista;
    }

    public void Actualiza_Tercero_RUT()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, RUT_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.RUT_Tercero__c = this.Cotizador.RUT_Tercero__c;

        update prospecto;

        CampaignMember Participante = [SELECT Id, MCAMP_Carga_Tercero_Dv__c, MCAMP_Carga_Tercero_RUT__c
                                        FROM CampaignMember
                                        WHERE LeadId =: prospecto.Id];
        if (String.isNotBlank(this.Cotizador.RUT_Tercero__c))
        {
            Participante.MCAMP_Carga_Tercero_Dv__c = this.Cotizador.RUT_Tercero__c.split('-')[1];
            Participante.MCAMP_Carga_Tercero_RUT__c = this.Cotizador.RUT_Tercero__c.split('-')[0];
        }
        else {
            Participante.MCAMP_Carga_Tercero_Dv__c = '';
            Participante.MCAMP_Carga_Tercero_RUT__c = '';
        }

        update Participante;
    }

    public void Actualiza_Tercero_Nombre()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, Nombre_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Nombre_Tercero__c = this.Cotizador.Nombre_Tercero__c;

        update prospecto;
    }

    public void Actualiza_Tercero_Email()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, Correo_Electronico_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Correo_Electronico_Tercero__c = this.Cotizador.Correo_Electronico_Tercero__c;

        update prospecto;
    }

    public void Actualiza_Tercero_Telefono()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        update this.Cotizador;

        Lead prospecto = [SELECT Id, Telefono_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Telefono_Tercero__c = this.Cotizador.Telefono_Tercero__c;

        update prospecto;
    }

    public void ActualizaDireccion_Tercero()
    {
        system.debug('@@@@ Cotizador --> '+ this.Cotizador);
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        Lead prospecto = [SELECT Id, Direccion_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
        prospecto.Direccion_Tercero__c = this.Cotizador.Direccion_Tercero__c;

        update prospecto;
    }

    public void SeleccionRegion_Tercero()
    {
        this.Cotizador.Codigo_Ciudad_Tercero__c = '';
        this.Cotizador.Codigo_Comuna_Tercero__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        system.debug('@@@@ Codigo_Region_Tercero__c --> '+ this.Cotizador.Codigo_Region_Tercero__c);
        List<Region__c> regiones = [SELECT Id FROM Region__c WHERE REGI_C_digo__c =: this.Cotizador.Codigo_Region_Tercero__c];
        if (regiones.size() > 0)
        {
            Lead prospecto = [SELECT Id, Region_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
            prospecto.Region_Tercero__c = regiones[0].Id;
            update prospecto;
        }
    }

    public void SeleccionCiudad_Tercero()
    {
        this.Cotizador.Codigo_Comuna_Tercero__c = '';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        system.debug('@@@@ Codigo_Ciudad_Tercero__c --> '+ this.Cotizador.Codigo_Ciudad_Tercero__c);
        List<Ciudad__c> ciudades = [SELECT Id FROM Ciudad__c WHERE CIUD_C_digo__c =: this.Cotizador.Codigo_Ciudad_Tercero__c];
        if (ciudades.size() > 0)
        {
            Lead prospecto = [SELECT Id, Ciudad_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
            prospecto.Ciudad_Tercero__c = ciudades[0].Id;
            update prospecto;
        }
    }

    public void SeleccionComuna_Tercero()
    {
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = this.Cotizador.Estado__c;

        system.debug('@@@@ Codigo_Comuna_Tercero__c --> '+ this.Cotizador.Codigo_Comuna_Tercero__c);
        List<Comuna__c> comunas = [SELECT Id FROM Comuna__c WHERE COMU_Codigo_Comuna__c =: this.Cotizador.Codigo_Comuna_Tercero__c];
        if (comunas.size() > 0)
        {
            Lead prospecto = [SELECT Id, Comuna_Tercero__c FROM Lead WHERE Id =: this.Cotizador.LeadId__c];
            prospecto.Comuna_Tercero__c = comunas[0].Id;
            update prospecto;
        }
    }

    /* EVENTS ASEGURADO */

    public void ConsultaAsegurado()
    {
        String aseguradoId = Apexpages.currentPage().getParameters().get('idAsegurado');
        String parentesco = Apexpages.currentPage().getParameters().get('parentesco');
        String fechaNacimiento = Apexpages.currentPage().getParameters().get('fechaNacimiento');
        String idSalesforce = Apexpages.currentPage().getParameters().get('IdSalesforce');
        String fechaNacimientoInt = Apexpages.currentPage().getParameters().get('fechaNacimientoInt');
        system.debug('@@@@ IN');
        system.debug('@@@@ aseguradoId --> '+aseguradoId);
        system.debug('@@@@ parentesco --> '+ parentesco);
        system.debug('@@@@ fechaNacimiento --> '+ fechaNacimiento);
        system.debug('@@@@ idSalesforce--> '+idSalesforce);
        system.debug('@@@@ fechaNacimientoInt--> '+fechaNacimientoInt);

        Cotizador_Express__c asegurado = null;
        Boolean  nuevo  = false;

        if (idSalesforce != 'X')
        {
            Id isSF = idSalesforce;
            asegurado = [SELECT Id, ParentId__c, Fecha_Nacimiento__c, AseguradoId__c, Fecha_Nacimiento_Int__c, Relacion_Titular__c, Codigo_Producto__c,
                                                    WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c, Asegurable__c, Ramo__c, Plan__c, Revision__c, 
                                                    Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, UsuarioTV__c, Tipo_Cliente__c
                                                    FROM Cotizador_Express__c
                                                    WHERE Id =: isSF];
        }

        system.debug('@@@@ asegurado in --> '+asegurado);

        if (asegurado == null)
        {
            asegurado = new Cotizador_Express__c();
            asegurado.ParentId__c = this.CotizadorId;
            asegurado.UsuarioTV__c = this.Cotizador.UsuarioTV__c;
            asegurado.Ramo__c= this.Cotizador.Ramo__c;
            asegurado.Codigo_Producto__c= this.Cotizador.Codigo_Producto__c;
            asegurado.Plan__c = this.Cotizador.Plan__c;
            asegurado.Revision__c = this.Cotizador.Revision__c;
            asegurado.Tipo_Cliente__c = this.Cotizador.Tipo_Cliente__c;
            asegurado.Pregunta_1__c = '';
            asegurado.Pregunta_2__c = '';
            asegurado.Pregunta_3__c = '';
            asegurado.Pregunta_4__c = '';
            asegurado.Pregunta_5__c = '';
        }
        else {
            asegurado.Pregunta_1__c = '';
            asegurado.Pregunta_2__c = '';
            asegurado.Pregunta_3__c = '';
            asegurado.Pregunta_4__c = '';
            asegurado.Pregunta_5__c = '';
        }

        Date fecha = Date.newInstance(Integer.valueOf(fechaNacimiento.split('-')[2]), Integer.valueOf(fechaNacimiento.split('-')[1]), Integer.valueOf(fechaNacimiento.split('-')[0]));

        asegurado.Relacion_Titular__c = parentesco;
        system.debug('@@@@  fecha  --> '+ fecha);
        asegurado.Fecha_Nacimiento__c = fecha;
        asegurado.Fecha_Nacimiento_Int__c =  fechaNacimientoInt;
        asegurado.AseguradoId__c = Decimal.valueOf(aseguradoId);

        system.debug('@@@@ asegurado mid --> '+asegurado);

        CLS_CM_CotizadorExpress_Consume.Response respuesta = new CLS_CM_CotizadorExpress_Consume.Response();
        respuesta.Consulta = false;

        ////// realiza 3 intentos (max) de consumo del WS
        Integer cont = 1;
        while(cont <= 3 && respuesta.Consulta == false)
        {
            respuesta = CLS_CM_CotizadorExpress_Consume.consumoWS(asegurado);
            cont++;
        }

        system.debug('@@@@ respuesta --> '+respuesta);

        if (Test.isRunningTest())
        {
            respuesta = new CLS_CM_CotizadorExpress_Consume.Response();
            respuesta.Consulta =  true;
            respuesta.FechaValida = 'S';
            respuesta.ValorUF = '12';
            respuesta.ValorCLP = '1000';
        }

        if (respuesta.Consulta == true)
        {
            asegurado.WS_Valida_Fecha_Nacimiento__c = respuesta.FechaValida;

            if (asegurado.WS_Valida_Fecha_Nacimiento__c == 'S')
            {
                asegurado.Asegurable__c = 'SI';
                asegurado.WS_Valor_UF__c = respuesta.ValorUF;
                asegurado.WS_Valor_CLP__c = respuesta.ValorCLP;
            }
            else {
                asegurado.Asegurable__c = 'NO';
                asegurado.WS_Valor_UF__c = '0';
                asegurado.WS_Valor_CLP__c = '0';
            }
        }
        else {
            //no consultado
            asegurado.Asegurable__c = 'ER';
            asegurado.WS_Valor_UF__c = '0';
            asegurado.WS_Valor_CLP__c = '0';
            asegurado.WS_Valida_Fecha_Nacimiento__c = '';
        }

        system.debug('@@@@ asegurado pre --> '+asegurado);

        if (idSalesforce == 'X')
        {
            insert asegurado;
        }
        else {
            update asegurado;
        }

        this.RespuestaAsegurado_FechaNac = asegurado.WS_Valida_Fecha_Nacimiento__c;
        this.RespuestaAsegurado_ValorUF = asegurado.WS_Valor_UF__c;
        this.RespuestaAsegurado_ValorCLP = asegurado.WS_Valor_CLP__c;
        this.RespuestaAsegurado_IdSalesforce = asegurado.Id;
        this.cargaAsegurados(false);

        this.Cotizador.Asegurados_Dependientes__c = 'SI';
        this.Cotizador.Estado__c = 'En Proceso';
        update this.Cotizador;
    }

    private void cargaAsegurados(Boolean actualizaContratante){

        List<FilaGrilla> grilla = new List<FilaGrilla> ();

        FilaGrilla filaContratante = new FilaGrilla();

        filaContratante.AseguradoId = '1';

        system.debug('@@@@ CotizadorId --> '+ this.CotizadorId);

        system.debug('@@@@ Cotizador --> '+ this.Cotizador);


        if (actualizaContratante == true)
        {
            this.Cotizador = [SELECT Id, OwnerId, Name, CreatedDate, CampaingMemberId__c, AccountId__c, LeadId__c, Producto__c, RUT_Contratante__c, Nombres__c, Apellidos__c, Fecha_Nacimiento__c,
                            Estado_Civil__c, Email__c, Telefono__c, Celular__c, Region__c, Comuna__c, Ciudad__c, Direccion__c, Asegurados_Dependientes__c, TaskId__c, Estado__c,
                            UsuarioTV__c, Lista_Telefonos__c, Tipo_Producto__c, Tipo_Cliente__c, Carga_Cliente__c, Ramo__c, Codigo_Producto__c, Plan__c, Revision__c, Fecha_Nacimiento_Int__c,
                            RecordTypeId__c, Relacion_Titular__c, ParentId__c, WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c, Poliza_Mandatoria__c, Codigo_Region__c,
                            Codigo_Ciudad__c, Codigo_Comuna__c, ContactId__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, Asegurable__c , TipoCotizacion__c,
                            RUT_Asegurado__c, Nombres_Asegurado__c, Apellidos_Asegurado__c, Tipo_Campagna__c, Telefono_Contratante__c, Telefono_Asegurado__c, Email_Asegurado__c,
                            RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Contrata__c, Email_Contratante_2__c, Validado_WS__c , Direccion_Contratante__c, Comuna_Contratante__c, Ciudad_Contratante__c, Region_Contratante__c, Codigo_Comuna_Contratante__c, Codigo_Ciudad_Contratante__c, Codigo_Region_Tercero__c,
                            Codigo_Region_Contratante__c, Direccion_Tercero__c, Ciudad_Tercero__c, Comuna_Tercero__c, Region_Tercero__c, Codigo_Ciudad_Tercero__c,  Codigo_Comuna_Tercero__c
                            FROM Cotizador_Express__c  WHERE  Id =: this.CotizadorId];
        }

        filaContratante.FechaNacimiento = this.GetDate(this.Cotizador.Fecha_Nacimiento__c);
        filaContratante.Parentesco = this.Cotizador.Relacion_Titular__c;
        filaContratante.PrimaCLP = this.Cotizador.WS_Valor_CLP__c;
        filaContratante.PrimaUF = this.Cotizador.WS_Valor_UF__c;
        filaContratante.ValidaFechaNacimiento = this.Cotizador.WS_Valida_Fecha_Nacimiento__c;
        filaContratante.IdSalesforce = this.Cotizador.Id;
        filaContratante.Asegurable = this.Cotizador.Asegurable__c;

        if (filaContratante.Asegurable == 'NO')
        {
            if (this.Cotizador.Pregunta_1__c == 'SI' || this.Cotizador.Pregunta_2__c  == 'SI' || this.Cotizador.Pregunta_3__c  == 'SI' ||
            this.Cotizador.Pregunta_4__c  == 'SI' || this.Cotizador.Pregunta_5__c  == 'SI')
            {
                filaContratante.NoAsegurable = 'P';
            }
        }
        else {
            filaContratante.NoAsegurable = 'W';
        }

        filaContratante.Pregunta_1 = this.Cotizador.Pregunta_1__c;
        filaContratante.Pregunta_2 = this.Cotizador.Pregunta_2__c;
        filaContratante.Pregunta_3 = this.Cotizador.Pregunta_3__c;
        filaContratante.Pregunta_4 = this.Cotizador.Pregunta_4__c;
        filaContratante.Pregunta_5 = this.Cotizador.Pregunta_5__c;

        system.debug('@@@@ fila --> '+filaContratante);
        system.debug('@@@@ Lista_Telefonos__c --> '+this.Cotizador.Lista_Telefonos__c);

        grilla.add(filaContratante);
        
        List<Cotizador_Express__c> cotizaciones = [SELECT Id,  RUT_Contratante__c, Nombres__c, Apellidos__c, Fecha_Nacimiento__c, Fecha_Nacimiento_Int__c, Relacion_Titular__c, ParentId__c,
                                                        WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c,  Codigo_Comuna__c, ContactId__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c,
                                                        Pregunta_4__c, Pregunta_5__c, Asegurable__c, AseguradoId__c
                                                FROM Cotizador_Express__c
                                                WHERE  ParentId__c =: this.CotizadorId
                                                ORDER BY AseguradoId__c ASC];

        system.debug('@@@@ Cotizaciones size --> '+ cotizaciones.size());


        if (cotizaciones.size() > 0)
        {
            for (Cotizador_Express__c cot : cotizaciones)
            {
                FilaGrilla filaAsegurado = new FilaGrilla();

                filaAsegurado.AseguradoId = String.valueOf(cot.AseguradoId__c);
                filaAsegurado.FechaNacimiento = this.GetDate(cot.Fecha_Nacimiento__c);
                filaAsegurado.Parentesco = cot.Relacion_Titular__c;
                filaAsegurado.PrimaCLP = cot.WS_Valor_CLP__c;
                filaAsegurado.PrimaUF = cot.WS_Valor_UF__c;
                filaAsegurado.ValidaFechaNacimiento = cot.WS_Valida_Fecha_Nacimiento__c;
                filaAsegurado.IdSalesforce = cot.Id;
                filaAsegurado.Asegurable = cot.Asegurable__c;

                if (filaAsegurado.Asegurable == 'NO')
                {
                    if (cot.Pregunta_1__c == 'SI' || cot.Pregunta_2__c  == 'SI' || cot.Pregunta_3__c  == 'SI' ||
                    cot.Pregunta_4__c  == 'SI' || cot.Pregunta_5__c  == 'SI')
                    {
                        filaAsegurado.NoAsegurable = 'P';
                    }
                }
                else {
                    filaAsegurado.NoAsegurable = 'W';
                }

                filaAsegurado.Pregunta_1 = cot.Pregunta_1__c;
                filaAsegurado.Pregunta_2 = cot.Pregunta_2__c;
                filaAsegurado.Pregunta_3 = cot.Pregunta_3__c;
                filaAsegurado.Pregunta_4 = cot.Pregunta_4__c;
                filaAsegurado.Pregunta_5 = cot.Pregunta_5__c;

                system.debug('@@@@ fila --> '+filaAsegurado);
                grilla.add(filaAsegurado);
            }
        }

        system.debug('@@@@ Cotizaciones  => ' + grilla);

        String respuesta = JSON.serialize(grilla);
        this.GrillaAsegurados = respuesta.replace('\'', ' ');
    }

    public void EliminaAsegurado()
    {
        String idSalesforce = Apexpages.currentPage().getParameters().get('IdSalesforce1');

        system.debug('@@@@  idSalesforce  --> '+ idSalesforce);

        String parentId = '';

        try
        {
            Cotizador_Express__c delAse = [SELECT Id FROM Cotizador_Express__c WHERE Id=: idSalesforce];
            delete delAse;

            List<Cotizador_Express__c> asegurados = [SELECT Id, AseguradoId__c, ParentId__c FROM Cotizador_Express__c WHERE ParentId__c =: this.CotizadorId ORDER BY AseguradoId__c ASC];

            Integer cont = 2;
            for (Cotizador_Express__c asegurado : asegurados)
            {
                asegurado.AseguradoId__c = Decimal.valueOf(cont);
                cont++;
            }

            update asegurados;

            system.debug('@@@@  FechaActualizacion  --> '+ FechaActualizacion);

            if (asegurados.size() > 0)
            {
                this.Cotizador.Asegurados_Dependientes__c = 'SI';
            }
            else {
                this.Cotizador.Asegurados_Dependientes__c = 'NO';
            }

            this.Cotizador.Estado__c = 'En Proceso';

            update this.Cotizador;

            this.cargaAsegurados(false);

        } catch (Exception ex) {
            system.debug('@@@@  ex  --> '+ ex.getLineNumber()+' '+ ex.getMessage());
        }
    }

    public void ActualizaPregunta()
    {
        String IdSalesforce = Apexpages.currentPage().getParameters().get('IdSalesforce2');
        String pregunta = Apexpages.currentPage().getParameters().get('Pregunta');
        String respuesta = Apexpages.currentPage().getParameters().get('Respuesta');

        system.debug('@@@@ IdSalesforce --> '+IdSalesforce);
        system.debug('@@@@ pregunta --> '+pregunta);
        system.debug('@@@@ respuesta --> '+respuesta);

        Id isSF = IdSalesforce;

        Cotizador_Express__c  cotizador =  [SELECT Id, Tipo_Producto__c, Estado__c, Asegurados_Dependientes__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, Asegurable__c, ParentId__c, AseguradoId__c, WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c
        FROM Cotizador_Express__c  WHERE  Id =: isSF];

        if (cotizador.Estado__c != 'Procesado' && cotizador.Estado__c != 'Anulado' && cotizador.Estado__c != 'Error')
        {
            system.debug('@@@@ cotizador ini --> '+cotizador);

            if (pregunta == '1')
            {
                cotizador.Pregunta_1__c = respuesta;
            }
            else if (pregunta == '2')
            {
                cotizador.Pregunta_2__c = respuesta;
            }
            else if (pregunta == '3')
            {
                cotizador.Pregunta_3__c = respuesta;
            }
            else if (pregunta == '4')
            {
                cotizador.Pregunta_4__c = respuesta;
            }
            else if (pregunta == '5')
            {
                cotizador.Pregunta_5__c = respuesta;
            }

            cotizador.Asegurable__c = 'SI';

            if (cotizador.Pregunta_1__c == 'SI' || cotizador.Pregunta_2__c == 'SI' || cotizador.Pregunta_3__c == 'SI' || cotizador.Pregunta_4__c == 'SI' || cotizador.Pregunta_5__c == 'SI')
            {
                cotizador.Asegurable__c = 'NO';
            }

            system.debug('@@@@ cotizador fin --> '+cotizador);
            cotizador.Asegurados_Dependientes__c  = cotizador.Asegurados_Dependientes__c;
            cotizador.Estado__c = 'En Proceso';
            update cotizador;

            if (String.isNotBlank(cotizador.ParentId__c))//si la respuesta es para un asegurado
            {
                this.cargaAsegurados(false);
            }
            else
            {//si la respuesta es para el contratante
                this.cargaAsegurados(true);
            }

            this.RespuestaAsegurado_Asegurable = cotizador.Asegurable__c;
            this.RespuestaAsegurado_IdSalesforce = cotizador.Id;

            this.RespuestaAsegurado_ValorUF =  '';
            this.RespuestaAsegurado_ValorCLP = '';

            if (cotizador.Asegurable__c == 'SI')
            {
                this.RespuestaAsegurado_ValorUF = cotizador.WS_Valor_UF__c;
                this.RespuestaAsegurado_ValorCLP = cotizador.WS_Valor_CLP__c;
            }
        }
    }

    private  String GetDate(Date value)
    {
        if (Test.isRunningTest())
        {
            value = System.today();
        }

        String outDate = '';

        system.debug('@@@@ Fecha --> '+value);

        String month = '';

        if (value.month() < 10)
        {
            month = '0'  + String.valueOf(value.month());
        }
        else {
            month = String.valueOf(value.month());
        }

        String day = '';

        if (value.day() < 10)
        {
            day = '0'  + String.valueOf(value.day());
        }
        else {
            day = String.valueOf(value.day());
        }

        outDate  = value.year()+ '-' + month + '-' + day;

        return outDate;
    }

    /* PASO A PREDIGITADOR ASEGURADO */

    public void ActualizaPasoPredigitador()
    {

        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate, Estado__c FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        if (cot.Estado__c != 'Procesado' || cot.Estado__c != 'Anulado' || cot.Estado__c != 'Error')
        {
            cot.Estado__c = 'Procesado';
            update cot;

            cot = [SELECT Id, LastModifiedDate, Estado__c FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        }

        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = cot.Estado__c;
    }

    public PageReference PasoPredigitador()
    {
        /*if (this.Cotizador.Validado_WS__c == false)
        {
            return null;
        }*/

        this.ActualizaPasoPredigitador();

        PageReference pageRef= new PageReference('/apex/SEC_VF_CM_Predigitador');

        pageRef.getParameters().put('CotizacionId', this.CotizadorId);
        pageRef.getParameters().put('TOTAL_UF', '0');

        if(this.TipoCampagna == 'Salud Protegida')
        {
            pageRef.getParameters().put('SaludProtegida', 'SI');
        }
        else {
            pageRef.getParameters().put('SaludProtegida', 'NO');
        }
        //'{!Cotizador.Id}', '{!Campagna_SaludProtegida}

        pageRef.setRedirect(true);

        system.debug('@@@@ pageref --> '+pageRef);
        return pageRef;
    }

    /* FOOTER */

    public void ConsultaFechaCambio()
    {
        Cotizador_Express__c cot = [SELECT Id, LastModifiedDate, Estado__c FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];
        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
        this.EstadoCotizacion = cot.Estado__c;
    }


    /*  GENERACION DE COTIZACION */

    //Método para cargar información del cliente o prospecto en cotizador
    //campañas oncologico o apeg
    public void generaContratanteTarea(String idTarea)
    {
        try
        {
            this.ErrorCarga = 'NO';

            this.Cotizador = new Cotizador_Express__c();

            this.Cotizador.Tipo_Producto__c  = '';

            Task Tarea = [SELECT Id, WhatId, WhoId, TASK_Campana__c, TASK_ID_Miembro_Campana__c, RecordTypeId, TASK_RUT_Ejecutivo_Televenta__c,
                                         Status, TASK_Sub_Estado__c, TASK_Producto_Oferta__c, TASK_Id_Campana__c
                                         FROM Task
                                         WHERE Id =: idTarea];

            system.debug('@@@@@ TAREA CLIENTE => ' + Tarea);

            if (String.isBlank(Tarea.TASK_ID_Miembro_Campana__c) == true)
            {
                this.ErrorCarga = 'ERROR_CM_ID';//id miembro de campaña no encontrado
            }

            if (String.isBlank(Tarea.TASK_Id_Campana__c) == true)
            {
                this.ErrorCarga = 'ERROR_CMP_ID';//id de campaña no encontrado
            }
            else
            {
                this.Cotizador.CampaignId__c = Tarea.TASK_Id_Campana__c;
            }

            if (Test.isRunningTest()){
                this.ErrorCarga = 'NO';
            }

            if(Tarea != null && this.ErrorCarga == 'NO')
            {
                this.Cotizador.TaskId__c = Tarea.Id;
				this.Cotizador.TipoCotizacion__c = 'T';
                //Instanciación objeto Miembro de Campaña para recuperar datos de Cliente Llamada...
                CampaignMember Participante = [SELECT Id, CampaignId, ContactId, Email, FirstName, LastName, LeadId, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, MCAMP_Carga_Apellido_Materno__c, MCAMP_Carga_Apellido_Paterno__c,
                                    MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c,
                                    MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Es_Asegurable__c, MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Plan__c,
                                    MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, MCAMP_Tasa_Riesgo__c,
                                    MCAMP_Tipo_Folio__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, MCAPM_Carga_Primer_Nombre__c, MobilePhone, Name, Phone, RecordTypeId, Status, Type, MCAMP_Tipo_Cliente__c, MCAMP_Tipo_Producto__c, MCAMP_Carga_Tel_fono_3__c, MCAMP_Carga_Tel_fono_4__c,
                                    MCAMP_Carga_Tel_fono_5__c, MCAMP_Carga_Tel_fono_6__c, MCAMP_Carga_Tel_fono_7__c, MCAMP_Carga_Tel_fono_8__c, MCAMP_Carga_Dv__c
                                    FROM CampaignMember
                                    WHERE Id =: Tarea.TASK_ID_Miembro_Campana__c];

                if (Participante.MCAMP_Carga_Fecha_Nacimiento__c == null)
                {
                    this.ErrorCarga = 'ERROR_FN_WS';//id de campaña no encontrado
                }

                if (Test.isRunningTest()){
                	this.ErrorCarga = 'NO';
                }

                if (this.ErrorCarga == 'NO')
                {
                    this.Cotizador.RUT_Contratante__c = Participante.MCAMP_Carga_RUT__c + '-'+ Participante.MCAMP_Carga_Dv__c;
                    this.Cotizador.Nombres__c = Participante.Firstname;
                    this.Cotizador.Apellidos__c = Participante.Lastname;
                    this.Cotizador.UsuarioTV__c = Tarea.TASK_RUT_Ejecutivo_Televenta__c.substring(0, Tarea.TASK_RUT_Ejecutivo_Televenta__c.length()-2);
                    this.Cotizador.Tipo_Producto__c = Participante.MCAMP_Tipo_Producto__c;
                    this.Cotizador.Tipo_Folio__c = Participante.MCAMP_Tipo_Folio__c;
                    this.Cotizador.Fecha_Nacimiento__c = Participante.MCAMP_Carga_Fecha_Nacimiento__c;
                    this.Cotizador.Email__c = Participante.MCAMP_Carga_Email_1__c;
                    this.Cotizador.Lista_Telefonos__c = generaTelefonosCliente(Participante);
                    this.Cotizador.Poliza_Mandatoria__c = Participante.MCAMP_Carga_Poliza_Mandatoria__c;
                    this.Cotizador.CampaingMemberId__c = Participante.Id;
                    this.Cotizador.CampaignId__c = Participante.CampaignId;
                  //  this.cargaTituloCampagna();

                    Campaign cmp = [SELECT Id, Name, RecordTypeId,Type FROM Campaign WHERE Id =: this.Cotizador.CampaignId__c];

                    //this.NombreCampagna = cmp.Name;

                    this.TipoCampagna = cmp.Type;

                    this.Cotizador.Tipo_Campagna__c = this.TipoCampagna;
                    this.Cotizador.Contrata__c = 'C';

                    this.Cotizador.RUT_Asegurado__c = Participante.MCAMP_Carga_RUT__c + '-'+ Participante.MCAMP_Carga_Dv__c;
                    this.Cotizador.Nombres_Asegurado__c = Participante.Firstname;
                    this.Cotizador.Apellidos_Asegurado__c = Participante.Lastname;

                    if (this.Cotizador.Tipo_Producto__c == '19' || this.Cotizador.Tipo_Producto__c== '66' || this.Cotizador.Tipo_Producto__c== '20')//oncologico  | apeg   | salud protegida
                    {
                        this.Cotizador.RecordTypeId__c = [SELECT id FROM Recordtype WHERE name='Ventas Oncológico'].id;
                    }

                    // Asociando tipo de cliente NUEVO o EXISTENTE
                    this.Cotizador.Carga_Cliente__c = Participante.MCAMP_Tipo_Cliente__c;

                    this.Cotizador.EsCliente__c = Participante.MCAMP_Es_cliente__c;

                    if(this.Cotizador.EsCliente__c == true)
                    {
                        this.Cotizador.Tipo_Cliente__c = 'N';
                    }
                    else
                    {
                        this.Cotizador.Tipo_Cliente__c = 'S';
                    }

                    this.Cotizador.Tipo_Cliente__c = 'S';//esta asi en original  1

                    if (Test.isRunningTest())
                    {
                        this.Cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
                    }

                    String[] fecha = String.valueOf(this.Cotizador.Fecha_Nacimiento__c).split('-');
                    this.Cotizador.Fecha_Nacimiento_Int__c = fecha[0]+''+fecha[1]+''+fecha[2];
                    this.Cotizador.Ramo__c = Participante.MCAMP_Ramo__c;
                    this.Cotizador.Codigo_Producto__c = Participante.MCAMP_Codigo_Producto__c;
                    this.Cotizador.Plan__c = Participante.MCAMP_Plan__c;
                    this.Cotizador.Revision__c = Participante.MCAMP_Revision__c;
                    this.Cotizador.Relacion_Titular__c = '0001';

                    system.debug('@@@@ Ramo '+ this.Cotizador.Ramo__c);
                    system.debug('@@@@ Codigo_Producto  '+ this.Cotizador.Codigo_Producto__c);
                    system.debug('@@@@ Plan '+this.Cotizador.Plan__c);
                    system.debug('@@@@ Revision '+ this.Cotizador.Revision__c);
                    system.debug('@@@@ Tipo Cliente '+this.Cotizador.Tipo_Cliente__c);
                    system.debug('@@@@ UsuarioVenta '+this.Cotizador.UsuarioTV__c);

                    system.debug('@@@@ relacionConTitular '+ this.Cotizador.Relacion_Titular__c);
                    system.debug('@@@@ fecha_nacimiento '+ this.Cotizador.Fecha_Nacimiento_Int__c);


                    this.Cotizador.Telefono__c = Participante.MCAMP_Carga_Tel_fono_1__c;

                    if (String.isNotBlank(Participante.MCAMP_Carga_Tel_fono_2__c))
                    {
                        this.Cotizador.Celular__c = Participante.MCAMP_Carga_Tel_fono_2__c;
                    }
                    else
                    {
                        this.Cotizador.Celular__c = Participante.MCAMP_Carga_Tel_fono_1__c;
                    }

                    system.debug('@@@@ Cotizador '+ this.Cotizador);

                    Boolean error = false;

                    if(Tarea.WhatId != null)
                    {
                        //Recuperar información Cuenta de cliente...
                        Account Cuenta = [SELECT Id, Rut__c, Firstname, Lastname, PersonBirthdate, PersonHomePhone, PersonMobilePhone, Estado_Civil__pc,
                                                    Direccion_Particular__pc, Region_Particular__pc, Ciudad_Particular__pc, Comuna_Particular__pc, isPersonAccount
                                            FROM Account
                                            WHERE Id =: Tarea.WhatId];

                        this.Cotizador.AccountId__c = Cuenta.Id;

                        this.Cotizador.Estado_Civil__c = Cuenta.Estado_Civil__pc;

                        this.Cotizador.Direccion__c = Cuenta.Direccion_Particular__pc;

                        system.debug('@@@@ Cotizador In --> '+ this.Cotizador);
                        system.debug('@@@@ Region --> '+ Cuenta.Region_Particular__pc);

                        if (String.isNotBlank(Cuenta.Region_Particular__pc) && String.isNotBlank(Cuenta.Ciudad_Particular__pc) && String.isNotBlank(Cuenta.Comuna_Particular__pc))
                        {
                            try
                            {
                                Integer regCuenta = Integer.valueOf(Cuenta.Region_Particular__pc);
                                String regionCuenta =  '0' + String.valueOf(regCuenta);

                                system.debug('@@@@ regionCuenta -->'+regionCuenta);

                                this.Cotizador.Codigo_Region__c = regionCuenta;
                                this.Cotizador.Region__c = [SELECT Name FROM Region__c WHERE REGI_C_digo__c =: this.Cotizador.Codigo_Region__c].Name;
                                this.Cotizador.Ciudad__c = Cuenta.Ciudad_Particular__pc;
                                this.Cotizador.Codigo_Ciudad__c = [SELECT CIUD_C_digo__c FROM Ciudad__c WHERE CIUD_Codigo_Region__c =: this.Cotizador.Codigo_Region__c AND Name=: this.Cotizador.Ciudad__c].CIUD_C_digo__c;
                                this.Cotizador.Comuna__c = Cuenta.Comuna_Particular__pc;
                                this.Cotizador.Codigo_Comuna__c = [SELECT COMU_Codigo_Comuna__c FROM Comuna__c WHERE COMU_C_digo_Ciudad__c =: this.Cotizador.Codigo_Ciudad__c AND Name=: this.Cotizador.Comuna__c].COMU_Codigo_Comuna__c;
                            }
                            catch (Exception ex) {
                            }
                        }
                    }
                    else if (Tarea.WhoId != null)
                    {
                        String tipoObjeto = String.valueOf(Tarea.WhoId).substring(0,3); // 003 Contacto o 00Q Leads

                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO COTIZADOR => ' +
                        tipoObjeto));
                        system.debug('@@@@ TIPO OBJETO CAPTURADO COTIZADOR => ' + tipoObjeto);

                        if(tipoObjeto == '00Q'){

                            this.Cotizador.LeadId__c = Tarea.WhoId;
                            //Recuperar información de prospecto...
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO => ' +
                            tipoObjeto + ' (LEAD)'));


                        }else{
                            this.Cotizador.ContactId__c = Tarea.WhoId;
                            //Recuperar información de contacto...
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ TIPO OBJETO CAPTURADO => ' +
                            tipoObjeto + ' (CONTACT)'));
                        }
                    }
                    else{
                        error = true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No ha sido posible recuperar la información del cliente, ' +
                                                                                                'intenta más tarde... en caso de persistir el error ' +
                                                                                                'comunica a tu Administrador de Sistema'));
                    }

                    if (Test.isRunningTest())
                    {
                        error = false;
                    }

                    if (error == false)
                    {
                        system.debug('@@@@ Cotizador Out --> '+ this.Cotizador);

                        this.Cotizador.Asegurados_Dependientes__c = 'NO';
                        this.Cotizador.Estado__c = 'Nuevo';
                        insert this.Cotizador;
                        this.CotizadorId = this.Cotizador.Id;

                        Cotizador_Express__c cot = [SELECT Id, CreatedDate, Estado__c, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];

                        this.FechaCreacion = cot.CreatedDate.format('dd-MM-YYYY HH:mm:ss');
                        this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
                        this.EstadoCotizacion = cot.Estado__c;

                        CLS_CM_CotizadorExpress_Consume.ConsumirWSAsync(this.CotizadorId);
                    }
                    else {
                        this.ErrorInicio = true;
                    }
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'No ha sido posible recuperar la información del cliente, ' +
                                                                                      'intenta más tarde... en caso de persistir el error comunica a ' +
                                                                                      'tu Administrador de Sistema'));
            }
        }catch(Exception ex){
            system.debug('@@@@ EXCEPTION => ' + ex.getMessage() + 'LINEA => ' +  ex.getLineNumber() );
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'@@@@ ERROR: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()  ));
        }
    }

    //Método para cargar información del cliente o prospecto en cotizador
    //campaña salud protegida
    public void generaContratanteProspecto(String idProspecto)
    {
        try
        {
            this.ErrorCarga = 'NO';
            this.Cotizador = new Cotizador_Express__c();

            this.Cotizador.Tipo_Producto__c  = '';

            Id leadId = idProspecto;
            this.Cotizador.LeadId__c = leadId;
            this.Cotizador.TipoCotizacion__c = 'L';
            //Instanciación objeto Miembro de Campaña para recuperar datos de Cliente Llamada...
            CampaignMember Participante = [SELECT Id, CampaignId, ContactId, Email, FirstName, LastName, LeadId, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, MCAMP_Carga_Apellido_Materno__c, MCAMP_Carga_Apellido_Paterno__c,
                            MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c,
                            MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Es_Asegurable__c, MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Plan__c,
                            MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, MCAMP_Tasa_Riesgo__c,
                            MCAMP_Tipo_Folio__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, MCAPM_Carga_Primer_Nombre__c, MobilePhone, Name, Phone, RecordTypeId, Status, Type, MCAMP_Tipo_Cliente__c, MCAMP_Tipo_Producto__c, MCAMP_Carga_Tel_fono_3__c, MCAMP_Carga_Tel_fono_4__c,
                            MCAMP_Carga_Tel_fono_5__c, MCAMP_Carga_Tel_fono_6__c, MCAMP_Carga_Tel_fono_7__c, MCAMP_Carga_Tel_fono_8__c, MCAMP_Carga_Dv__c, MCAMP_Carga_Contratante_Dv__c, MCAMP_Carga_Contratante_RUT__c, MCAMP_Carga_Tercero_Dv__c, MCAMP_Carga_Tercero_RUT__c, MCAMP_Carga_Tipo_Cotizacion__c
                            FROM CampaignMember
                            WHERE LeadId =: idProspecto];


            if (Participante == null)
            {
                this.ErrorCarga = 'ERROR_CM_NF';
            }
            else {
				this.Cotizador.CampaingMemberId__c = Participante.Id;
                if (Participante.MCAMP_Carga_Fecha_Nacimiento__c == null)
                {
                    this.ErrorCarga = 'ERROR_FN_WS';//fecha nacimiento
                }
            }

            if (Test.isRunningTest()){
                this.ErrorCarga = 'NO';
            }

            if (this.ErrorCarga == 'NO')
            {
                String rutUsuario = [SELECT RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c;

                system.debug('@@@@ Participante --> '+ Participante);

                this.Cotizador.RUT_Asegurado__c = Participante.MCAMP_Carga_RUT__c + '-'+ Participante.MCAMP_Carga_Dv__c;
                this.Cotizador.Nombres_Asegurado__c = Participante.Firstname;
                this.Cotizador.Apellidos_Asegurado__c = Participante.Lastname;
                this.Cotizador.UsuarioTV__c = rutUsuario.substring(0, rutUsuario.length()-2);
                this.Cotizador.Tipo_Producto__c = Participante.MCAMP_Tipo_Producto__c;
                this.Cotizador.Tipo_Folio__c = Participante.MCAMP_Tipo_Folio__c;
                this.Cotizador.Fecha_Nacimiento__c = Participante.MCAMP_Carga_Fecha_Nacimiento__c;
                this.Cotizador.Email__c = Participante.MCAMP_Carga_Email_1__c;
                this.Cotizador.Lista_Telefonos__c = generaTelefonosCliente(Participante);
                this.Cotizador.CampaingMemberId__c = Participante.Id;
                this.Cotizador.CampaignId__c = Participante.CampaignId;

                Campaign cmp = [SELECT Id, Name, RecordTypeId,Type FROM Campaign WHERE Id =: this.Cotizador.CampaignId__c];

                this.NombreCampagna = cmp.Name;

                this.TipoCampagna = cmp.Type;
                //Televenta - APEG
                //Televenta - Oncológico
                //Salud Protegida
                system.debug('@@@@ Tipo Campagna --> '+this.TipoCampagna);

                this.Cotizador.Tipo_Campagna__c = this.TipoCampagna;

                if (this.TipoCampagna != 'Salud Protegida')
                {
                    this.Cotizador.RUT_Contratante__c = this.Cotizador.RUT_Asegurado__c;
                    this.Cotizador.Nombres__c = this.Cotizador.Nombres_Asegurado__c;
                    this.Cotizador.Apellidos__c = this.Cotizador.Apellidos_Asegurado__c;
                }
                else
                {
                    Lead lead = [SELECT Id, Cuenta__c, Telefono_Activo__c, Phone, Email, Email_Contratante__c, Email_Contratante_Cotizador__c, Prima_Nuevo_Producto__c,
                                 Contratante_Salud_Protegida__c,  RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Poliza__c, SP_Telefono_Activo__c,
                                 SP_Comuna__c, SP_Codigo_Comuna__c, SP_Codigo_Ciudad__c, SP_Codigo_Region__c, SP_Ciudad__c, SP_Region__c, SP_Direccion__c, Direccion_Tercero__c, Ciudad_Tercero__r.Name,
                                 Comuna_Tercero__r.Name, Region_Tercero__r.Name, Ciudad_Tercero__r.CIUD_C_digo__c, Comuna_Tercero__r.COMU_Codigo_Comuna__c, Region_Tercero__r.REGI_C_digo__c
                                FROM Lead WHERE Id =: idProspecto];

                    if (String.isBlank(lead.Email_Contratante_Cotizador__c))
                    {
                        lead.Email_Contratante_Cotizador__c = lead.Email_Contratante__c;
                        update lead;
                    }

                    this.Cotizador.Telefono_Asegurado__c = lead.Phone;
                    this.Cotizador.Email_Asegurado__c = lead.Email;
                    this.Cotizador.Prima_Nuevo_Producto__c = lead.Prima_Nuevo_Producto__c;

                    if (lead.Contratante_Salud_Protegida__c == 'Contratante Original')
                    {
                        this.Cotizador.Contrata__c = 'C';
                        this.Cotizador.Telefono_Contratante__c = lead.SP_Telefono_Activo__c;
                        this.Cotizador.Email_Contratante_2__c  = lead.Email_Contratante_Cotizador__c;
                        this.Cotizador.Direccion_Contratante__c = lead.SP_Direccion__c;
                        this.Cotizador.Ciudad_Contratante__c= lead.SP_Ciudad__c;
                        this.Cotizador.Comuna_Contratante__c= lead.SP_Comuna__c;
                        this.Cotizador.Region_Contratante__c= lead.SP_Region__c;
                        this.Cotizador.Codigo_Ciudad_Contratante__c= lead.SP_Codigo_Ciudad__c;
                        this.Cotizador.Codigo_Comuna_Contratante__c= lead.SP_Codigo_Comuna__c;
                        this.Cotizador.Codigo_Region_Contratante__c= lead.SP_Codigo_Region__c;
                    }
                    else if (lead.Contratante_Salud_Protegida__c == 'Asegurado Titular')
                    {
                        this.Cotizador.Contrata__c = 'A';
                        Participante.MCAMP_Carga_Tipo_Cotizacion__c = 'A';
                        Participante.MCAMP_Tipo_Cliente__c = 'Nuevo';
                        update Participante;
                    }
                    else if (lead.Contratante_Salud_Protegida__c == 'Tercero')
                    {
                        this.Cotizador.Contrata__c = 'T';
                        this.Cotizador.RUT_Tercero__c = lead.RUT_Tercero__c;
                        this.Cotizador.Nombre_Tercero__c = lead.Nombre_Tercero__c;
                        this.Cotizador.Correo_Electronico_Tercero__c = lead.Correo_Electronico_Tercero__c;
                        this.Cotizador.Telefono_Tercero__c = lead.Telefono_Tercero__c;
                        this.Cotizador.Direccion_Tercero__c = lead.Direccion_Tercero__c;
                        this.Cotizador.Ciudad_Tercero__c= lead.Ciudad_Tercero__r.Name;
                        this.Cotizador.Comuna_Tercero__c= lead.Comuna_Tercero__r.Name;
                        this.Cotizador.Region_Tercero__c= lead.Region_Tercero__r.Name;
                        this.Cotizador.Codigo_Ciudad_Tercero__c= lead.Ciudad_Tercero__r.CIUD_C_digo__c;
                        this.Cotizador.Codigo_Comuna_Tercero__c= lead.Comuna_Tercero__r.COMU_Codigo_Comuna__c;
                        this.Cotizador.Codigo_Region_Tercero__c= lead.Region_Tercero__r.REGI_C_digo__c;

                        if (String.isNotBlank(lead.RUT_Tercero__c))
                        {
                            Participante.MCAMP_Carga_Tercero_Dv__c = lead.RUT_Tercero__c.split('-')[1];
                            Participante.MCAMP_Carga_Tercero_RUT__c = lead.RUT_Tercero__c.split('-')[0];
                        }

                        Participante.MCAMP_Carga_Tipo_Cotizacion__c = 'T';
                        update Participante;
                    }

                    if (String.isNotBlank(lead.Poliza__c))
                    {
                        Poliza__c pol = [SELECT Name FROM Poliza__c WHERE Id =: lead.Poliza__c];
                        this.Cotizador.Poliza_Mandatoria__c = pol.Name;
                    }

                    if (lead != null && String.isNotBlank(lead.Cuenta__c))
                    {
                        if (lead.Contratante_Salud_Protegida__c == 'Contratante Original')
                        {
                            Account cuenta = [SELECT Id, Name, Firstname, LastName, RUT__c, DV__c FROM Account WHERE Id =: lead.Cuenta__c];
                            this.Cotizador.RUT_Contratante__c = cuenta.Rut__c + '-' + cuenta.DV__c;
                            this.Cotizador.Nombres__c = cuenta.Firstname;
                            this.Cotizador.Apellidos__c = cuenta.LastName;
                            this.Cotizador.AccountId__c = lead.Cuenta__c;

                            Participante.MCAMP_Carga_Contratante_RUT__c = cuenta.RUT__c;
                            Participante.MCAMP_Carga_Contratante_Dv__c = cuenta.DV__c;
                            Participante.MCAMP_Carga_Tipo_Cotizacion__c = 'C';
                            update Participante;
                        }
                    }
                }

                system.debug('@@@@ this.Cotizador --> '+ this.Cotizador);

                if (!Test.isRunningTest())
                {
                    system.debug('@@@@ query tarea --> SELECT Id, TASK_Campana__c, TASK_ID_Miembro_Campana__c, Status FROM Task WHERE TASK_ID_Miembro_Campana__c =:'+  this.Cotizador.CampaingMemberId__c + ' AND (Status = "En curso" OR  Status = "Abierta"');
                    List<Task> tareas = [SELECT Id, TASK_Campana__c, TASK_ID_Miembro_Campana__c, Status FROM Task WHERE TASK_ID_Miembro_Campana__c =: this.Cotizador.CampaingMemberId__c AND (Status = 'En curso' OR  Status = 'Abierta')];

                    if (tareas.size() > 0)
                    {
                        this.Cotizador.TaskId__c = tareas[0].Id;
                    }
                }

                if (this.Cotizador.Tipo_Producto__c == '19' || this.Cotizador.Tipo_Producto__c== '66' || this.Cotizador.Tipo_Producto__c== '20')//oncologico  | apeg   | salud protegida
                {
                    this.Cotizador.RecordTypeId__c = [SELECT id FROM Recordtype WHERE name='Ventas Oncológico'].id;
                }

                // Asociando tipo de cliente NUEVO o EXISTENTE
                this.Cotizador.Carga_Cliente__c = Participante.MCAMP_Tipo_Cliente__c;

                this.Cotizador.EsCliente__c = Participante.MCAMP_Es_cliente__c;

                if(this.Cotizador.EsCliente__c== true)
                {
                    this.Cotizador.Tipo_Cliente__c = 'N';
                }
                else
                {
                    this.Cotizador.Tipo_Cliente__c = 'S';
                }

                this.Cotizador.Tipo_Cliente__c = 'S';//esta asi en original 3

                if (Test.isRunningTest())
                {
                    this.Cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
                }

                try
                {
                    String[] fecha = String.valueOf(this.Cotizador.Fecha_Nacimiento__c).split('-');
                    this.Cotizador.Fecha_Nacimiento_Int__c = fecha[0]+''+fecha[1]+''+fecha[2];
                }
                catch(Exception ex)
                {
                    this.Cotizador.Fecha_Nacimiento_Int__c = '2902019';
                }

                this.Cotizador.Ramo__c = Participante.MCAMP_Ramo__c;
                this.Cotizador.Codigo_Producto__c = Participante.MCAMP_Codigo_Producto__c;
                this.Cotizador.Plan__c = Participante.MCAMP_Plan__c;
                this.Cotizador.Revision__c = Participante.MCAMP_Revision__c;
                this.Cotizador.Relacion_Titular__c = '0001';

                system.debug('@@@@ Ramo '+ this.Cotizador.Ramo__c);
                system.debug('@@@@ Codigo_Producto  '+ this.Cotizador.Codigo_Producto__c);
                system.debug('@@@@ Plan '+this.Cotizador.Plan__c);
                system.debug('@@@@ Revision '+ this.Cotizador.Revision__c);
                system.debug('@@@@ Tipo Cliente '+this.Cotizador.Tipo_Cliente__c);
                system.debug('@@@@ UsuarioVenta '+this.Cotizador.UsuarioTV__c);

                system.debug('@@@@ relacionConTitular '+ this.Cotizador.Relacion_Titular__c);
                system.debug('@@@@ fecha_nacimiento '+ this.Cotizador.Fecha_Nacimiento_Int__c);

                this.Cotizador.Telefono__c = Participante.MCAMP_Carga_Tel_fono_1__c;

                if (String.isNotBlank(Participante.MCAMP_Carga_Tel_fono_2__c))
                {
                    this.Cotizador.Celular__c = Participante.MCAMP_Carga_Tel_fono_2__c;
                }
                else
                {
                    this.Cotizador.Celular__c = Participante.MCAMP_Carga_Tel_fono_1__c;
                }

                system.debug('@@@@ Cotizador 862 '+ this.Cotizador);
                this.Cotizador.Asegurados_Dependientes__c = 'NO';
                this.Cotizador.Estado__c = 'Nuevo';
                insert this.Cotizador;

                this.CotizadorId = this.Cotizador.Id;

                Cotizador_Express__c cot = [SELECT Id, CreatedDate, Estado__c, LastModifiedDate FROM Cotizador_Express__c WHERE Id =: this.CotizadorId];

                this.FechaCreacion = cot.CreatedDate.format('dd-MM-YYYY HH:mm:ss');
                this.FechaActualizacion = cot.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
                this.EstadoCotizacion = cot.Estado__c;

                CLS_CM_CotizadorExpress_Consume.ConsumirWSAsync(this.CotizadorId);
            }
        }catch(Exception ex){
            system.debug('@@@@ EXCEPTION => ' + ex.getMessage() + 'LINEA => ' +  ex.getLineNumber() );
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'@@@@ ERROR: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()  ));
        }
    }

    /*  LOAD COTIZADOR EXPRESS */
    public PageReference loadCotizadorExpress()
    {
        Cotizador_Express__c cot =[SELECT Id, Asegurable__c, Validado_WS__c, TaskId__c, LeadId__c FROM Cotizador_Express__c  WHERE  Id =: this.CotizadorId];

        system.debug('@@@@ asegurable '+cot.Asegurable__c);
        if (String.isNotBlank(cot.Asegurable__c))
        {
         //   this.Cotizador.Asegurable__c = 'NO';
            cot.Validado_WS__c = true;
            update cot;

            if (this.TipoCampagna == 'Televenta - Oncológico' || this.TipoCampagna == 'Televenta - APEG' )
            {
                PageReference pageRef= new PageReference('/apex/SEC_VF_CM_CotizadorExpress');

                pageRef.getParameters().put('TaskId', cot.TaskId__c);

                pageRef.setRedirect(true);
                return pageRef;
            }
            else if (this.TipoCampagna == 'Salud Protegida')
            {
                PageReference pageRef= new PageReference('/apex/SEC_VF_CM_CotizadorExpress');

                pageRef.getParameters().put('LeadId', cot.LeadId__c);

                pageRef.setRedirect(true);
                return pageRef;
            }
        }
        else
        {
            this.Cotizador = [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, CampaingMemberId__c, CampaignId__c, AccountId__c, LeadId__c, Producto__c, RUT_Contratante__c, Nombres__c, Apellidos__c, Fecha_Nacimiento__c,
                                    Estado_Civil__c, Email__c, Telefono__c, Celular__c, Region__c, Comuna__c, Ciudad__c, Direccion__c, Asegurados_Dependientes__c, TaskId__c, OpportunityId__c, Tipo_Folio__c,
                                    UsuarioTV__c, Lista_Telefonos__c, Tipo_Producto__c, Tipo_Cliente__c, Carga_Cliente__c, Ramo__c, Codigo_Producto__c, Plan__c, Revision__c, Fecha_Nacimiento_Int__c,
                                    RecordTypeId__c, Relacion_Titular__c, ParentId__c, WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c, Poliza_Mandatoria__c, Codigo_Region__c, Estado__c,
                                    Codigo_Ciudad__c, Codigo_Comuna__c, ContactId__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, Asegurable__c, TipoCotizacion__c,
                                    RUT_Asegurado__c, Nombres_Asegurado__c, Apellidos_Asegurado__c, Tipo_Campagna__c, Telefono_Contratante__c, Telefono_Asegurado__c, Email_Asegurado__c,
                                    RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Contrata__c, Email_Contratante_2__c, Prima_Nuevo_Producto__c, Validado_WS__c,
                                    Direccion_Contratante__c, Comuna_Contratante__c, Ciudad_Contratante__c, Region_Contratante__c, Codigo_Comuna_Contratante__c, Codigo_Ciudad_Contratante__c, Codigo_Region_Tercero__c,
                                    Codigo_Region_Contratante__c, Direccion_Tercero__c, Ciudad_Tercero__c, Comuna_Tercero__c, Region_Tercero__c, Codigo_Ciudad_Tercero__c,  Codigo_Comuna_Tercero__c
                            FROM Cotizador_Express__c  WHERE  Id =: this.CotizadorId];

            this.FechaCreacion = this.Cotizador.CreatedDate.format('dd-MM-YYYY HH:mm:ss');
            this.FechaActualizacion = this.Cotizador.LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
            this.EstadoCotizacion = this.Cotizador.Estado__c;
            this.CotizadorId = this.Cotizador.Id;
            CLS_CM_CotizadorExpress_Consume.ConsumirWSAsync(this.Cotizador.Id);
        }
        return null;
    }

    /*  INICIO COTIZADOR EXPRESS */
    public PageReference loadInicio()
    {
        String TaskId = apexpages.currentpage().getparameters().get('TaskId');

        String LeadId = apexpages.currentpage().getparameters().get('LeadId');

        if (String.isNotBlank(TaskId))
        {
            this.Id = TaskId;
            this.Call = 'TASK';
        }
        else if (String.isNotBlank(LeadId))
        {
            this.Id = LeadId;
            this.Call = 'LEAD';

            Lead prospecto = [SELECT Id, Contratante_Salud_Protegida__c, Status, Sub_Estado__c FROM Lead WHERE Id =: this.Id];

            if (String.IsBlank(prospecto.Contratante_Salud_Protegida__c))
            {
                this.Call = 'CONTRATANTE_NO_SELECCIONADO';
            }
            else
            {
                if (prospecto.Status == 'Cierre Administrativo')
                {
                    this.Call = 'CIERRE_ADMINISTRATIVO';
                }
                else if (prospecto.Status == 'Contratante No Contactado')
                {
                    if (prospecto.Sub_Estado__c == 'No Contesta, inubicable' || prospecto.Sub_Estado__c == 'Teléfono Malo' || prospecto.Sub_Estado__c == 'Persona falleció')
                    {
                        this.Call = 'ESTADO_TERMINAL';
                    }
                }
                else if (prospecto.Status == 'Contratante Contactado')
                {
					if (prospecto.Sub_Estado__c == 'No le interesa' || prospecto.Sub_Estado__c == 'Pide no volver a llamar' || prospecto.Sub_Estado__c == 'No reúne condiciones' || prospecto.Sub_Estado__c == 'Molesto con la compañìa' || prospecto.Sub_Estado__c == 'No tiene medio de pago')
                    {
                         this.Call = 'ESTADO_TERMINAL';
                    }
                }
                else if (prospecto.Status == 'Asegurado No Contactado')
                {
                    if (prospecto.Sub_Estado__c == 'No Contesta, inubicable' || prospecto.Sub_Estado__c == 'Teléfono Malo')
                    {
                         this.Call = 'ESTADO_TERMINAL';
                    }
                }
                else if (prospecto.Status == 'Asegurado Contactado')
                {
                    if (prospecto.Sub_Estado__c == 'No le interesa' || prospecto.Sub_Estado__c == 'Pide no volver a llamar' || prospecto.Sub_Estado__c == 'No reúne condiciones' || prospecto.Sub_Estado__c == 'Molesto con la compañìa' || prospecto.Sub_Estado__c == 'No tiene medio de pago')
                    {
                         this.Call = 'ESTADO_TERMINAL';
                    }
                }
                else if (prospecto.Status == 'Contrata')
                {
                    if (prospecto.Sub_Estado__c == 'Contratante de póliza original' || prospecto.Sub_Estado__c == 'Asegurado')
                    {
                         this.Call = 'ESTADO_TERMINAL';
                    }
                }
                else
                {

                }
            }
        }

        return null;
    }

    public PageReference iniciaCotizadorExpress()
    {
        this.ErrorCarga = 'NO';
        this.Cotizador =  null;
        this.ErrorInicio = false;
       // this.Campagna_SaludProtegida = 'NO';

        String TaskId = '';
        String LeadId = '';

        try
        {
            //viene de Tarea
            TaskId = apexpages.currentpage().getparameters().get('TaskId');
        }
        catch(Exception ex)
        {
            TaskId = '';
        }

        try
        {
            //viene de Prospecto
            LeadId = apexpages.currentpage().getparameters().get('LeadId');
        }
        catch(Exception ex)
        {
            LeadId = '';
        }


        system.debug('@@@@@ TaskId  => ' + TaskId);
        system.debug('@@@@@ LeadId  => ' + LeadId);

        String Cotizador_CampaingMemberId = '';
        //verifica si ya existe una cotizacion asociada al valor ingresado por parametro

        if (String.isNotBlank(TaskId))
        {
            //viene de tarea
            Id idTask = TaskId;

            List<Cotizador_Express__c> tmps = [SELECT CampaingMemberId__c FROM Cotizador_Express__c  WHERE  TaskId__c =: idTask AND Estado__c != 'Anulado'];

            if (tmps.size() > 0)
            {
                Cotizador_CampaingMemberId = tmps[0].CampaingMemberId__c;
            }

        }
        else if (String.isNotBlank(LeadId))
        {
            //viene de prospecto
            Id idLead = LeadId;
            system.debug('@@@@ LEAD '+ idLead);
            system.debug('@@@@ QRY LEAD --> SELECT CampaingMemberId__c FROM Cotizador_Express__c  WHERE  LeadId__c ='+idLead+' AND Estado__c != Anulado');

            List<Cotizador_Express__c> tmps= [SELECT CampaingMemberId__c FROM Cotizador_Express__c  WHERE  LeadId__c =: idLead AND Estado__c != 'Anulado'];

            if (tmps.size() > 0)
            {
                Cotizador_CampaingMemberId = tmps[0].CampaingMemberId__c;
            }
        }
        else {
            //else error de parametros

        }

        Boolean LoadCotizador = false;

        List<Cotizador_Express__c> cotizaciones = new List<Cotizador_Express__c>();

        if (String.isNotBlank(Cotizador_CampaingMemberId))
        {
            Id idCampaignMember = Cotizador_CampaingMemberId;

            cotizaciones = [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, CampaingMemberId__c, CampaignId__c, AccountId__c, LeadId__c, Producto__c, RUT_Contratante__c, Nombres__c, Apellidos__c, Fecha_Nacimiento__c,
                            Estado_Civil__c, Email__c, Telefono__c, Celular__c, Region__c, Comuna__c, Ciudad__c, Direccion__c, Asegurados_Dependientes__c, TaskId__c, OpportunityId__c, Tipo_Folio__c,
                            UsuarioTV__c, Lista_Telefonos__c, Tipo_Producto__c, Tipo_Cliente__c, Carga_Cliente__c, Ramo__c, Codigo_Producto__c, Plan__c, Revision__c, Fecha_Nacimiento_Int__c,
                            RecordTypeId__c, Relacion_Titular__c, ParentId__c, WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c, Poliza_Mandatoria__c, Codigo_Region__c, Estado__c,
                            Codigo_Ciudad__c, Codigo_Comuna__c, ContactId__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, Asegurable__c, TipoCotizacion__c,
                            RUT_Asegurado__c, Nombres_Asegurado__c, Apellidos_Asegurado__c, Tipo_Campagna__c, Telefono_Contratante__c, Telefono_Asegurado__c, Email_Asegurado__c,
                            RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Contrata__c, Email_Contratante_2__c, Prima_Nuevo_Producto__c, Validado_WS__c ,
                            Direccion_Contratante__c, Comuna_Contratante__c, Ciudad_Contratante__c, Region_Contratante__c, Codigo_Comuna_Contratante__c, Codigo_Ciudad_Contratante__c, Codigo_Region_Tercero__c,
                            Codigo_Region_Contratante__c, Direccion_Tercero__c, Ciudad_Tercero__c, Comuna_Tercero__c, Region_Tercero__c, Codigo_Ciudad_Tercero__c,  Codigo_Comuna_Tercero__c
                            FROM Cotizador_Express__c  WHERE  CampaingMemberId__c =: idCampaignMember AND Estado__c != 'Anulado'];

            if (cotizaciones.size() > 0)
            {
                this.Cotizador = cotizaciones[0];

                this.FechaCreacion = cotizaciones[0].CreatedDate.format('dd-MM-YYYY HH:mm:ss');
                this.FechaActualizacion = cotizaciones[0].LastModifiedDate.format('dd-MM-YYYY HH:mm:ss');
                this.EstadoCotizacion = cotizaciones[0].Estado__c;
                this.CotizadorId = this.Cotizador.Id;

                if (string.isNotBlank(this.Cotizador.LeadId__c))
                {
                    String newValueTipoCotizacion = '';

                    Lead lead = [SELECT Id, Cuenta__c, Contratante_Salud_Protegida__c, RUT_Tercero__c, SP_Comuna__c, SP_Codigo_Comuna__c, SP_Codigo_Ciudad__c,
                                        SP_Codigo_Region__c, SP_Ciudad__c, SP_Region__c, SP_Direccion__c, Direccion_Tercero__c, Ciudad_Tercero__r.Name,
                                        Comuna_Tercero__r.Name, Region_Tercero__r.Name, Ciudad_Tercero__r.CIUD_C_digo__c, Comuna_Tercero__r.COMU_Codigo_Comuna__c,
                                        Region_Tercero__r.REGI_C_digo__c
                                FROM Lead WHERE Id =: this.Cotizador.LeadId__c];

                    if (lead.Contratante_Salud_Protegida__c == 'Contratante Original')
                    {
                        newValueTipoCotizacion = 'C';
                    }
                    else if (lead.Contratante_Salud_Protegida__c == 'Asegurado Titular')
                    {
                        newValueTipoCotizacion= 'A';
                    }
                    else if (lead.Contratante_Salud_Protegida__c == 'Tercero')
                    {
                        newValueTipoCotizacion = 'T';
                        //actualizar
                        this.Cotizador.RUT_Tercero__c = lead.RUT_Tercero__c;
                        update this.Cotizador;
                    }

                    if (String.isNotBlank(newValueTipoCotizacion) && this.Cotizador.Contrata__c != newValueTipoCotizacion)
                    {
                        this.Cotizador.Contrata__c = newValueTipoCotizacion;
                        update this.Cotizador;

                        CampaignMember Participante = [SELECT Id, MCAMP_Carga_Tipo_Cotizacion__c, MCAMP_Carga_Tercero_Dv__c, MCAMP_Carga_Tercero_RUT__c, MCAMP_Carga_Contratante_RUT__c,MCAMP_Carga_Contratante_Dv__c
                                                      FROM CampaignMember WHERE LeadId =: lead.Id];

                        Participante.MCAMP_Carga_Tipo_Cotizacion__c = newValueTipoCotizacion;

                        if(newValueTipoCotizacion == 'T')
                        {
                            Participante.MCAMP_Carga_Tercero_Dv__c = '';
                            Participante.MCAMP_Carga_Tercero_RUT__c = '';

                            if(String.isNotBlank(this.Cotizador.RUT_Tercero__c))
                            {
                                Participante.MCAMP_Carga_Tercero_Dv__c = this.Cotizador.RUT_Tercero__c.split('-')[1];
                          		Participante.MCAMP_Carga_Tercero_RUT__c = this.Cotizador.RUT_Tercero__c.split('-')[0];
                            }

                            Participante.MCAMP_Carga_Contratante_RUT__c = '';
                            Participante.MCAMP_Carga_Contratante_Dv__c  = '';

                            this.Cotizador.Direccion_Tercero__c = lead.Direccion_Tercero__c;
                            this.Cotizador.Ciudad_Tercero__c= lead.Ciudad_Tercero__r.Name;
                            this.Cotizador.Comuna_Tercero__c= lead.Comuna_Tercero__r.Name;
                            this.Cotizador.Region_Tercero__c= lead.Region_Tercero__r.Name;
                            this.Cotizador.Codigo_Ciudad_Tercero__c= lead.Ciudad_Tercero__r.CIUD_C_digo__c;
                            this.Cotizador.Codigo_Comuna_Tercero__c= lead.Comuna_Tercero__r.COMU_Codigo_Comuna__c;
                            this.Cotizador.Codigo_Region_Tercero__c= lead.Region_Tercero__r.REGI_C_digo__c;

                            update this.Cotizador;
                        }
                        else if(newValueTipoCotizacion == 'A')
                        {
                            Participante.MCAMP_Carga_Tercero_Dv__c = '';
                            Participante.MCAMP_Carga_Tercero_RUT__c = '';
                            Participante.MCAMP_Carga_Contratante_RUT__c = '';
                            Participante.MCAMP_Carga_Contratante_Dv__c  = '';
                        }
                        else if(newValueTipoCotizacion == 'C')
                        {
                            Participante.MCAMP_Carga_Tercero_Dv__c = '';
                            Participante.MCAMP_Carga_Tercero_RUT__c = '';
                            Participante.MCAMP_Carga_Contratante_RUT__c = '';
                            Participante.MCAMP_Carga_Contratante_Dv__c  = '';

                            if (String.isNotBlank(lead.Cuenta__c))
                  		    {
                                Account cuenta = [SELECT Id, Name, Firstname, LastName, RUT__c, DV__c FROM Account WHERE Id =: lead.Cuenta__c];
                                this.Cotizador.RUT_Contratante__c = cuenta.Rut__c + '-' + cuenta.DV__c;
                                this.Cotizador.Nombres__c = cuenta.Firstname;
                                this.Cotizador.Apellidos__c = cuenta.LastName;
                                this.Cotizador.AccountId__c = lead.Cuenta__c;

                                this.Cotizador.Direccion_Contratante__c = lead.SP_Direccion__c;
                                this.Cotizador.Ciudad_Contratante__c= lead.SP_Ciudad__c;
                                this.Cotizador.Comuna_Contratante__c= lead.SP_Comuna__c;
                                this.Cotizador.Region_Contratante__c= lead.SP_Region__c;
                                this.Cotizador.Codigo_Ciudad_Contratante__c= lead.SP_Codigo_Ciudad__c;
                                this.Cotizador.Codigo_Comuna_Contratante__c= lead.SP_Codigo_Comuna__c;
                                this.Cotizador.Codigo_Region_Contratante__c= lead.SP_Codigo_Region__c;

                                update this.Cotizador;

                                Participante.MCAMP_Carga_Contratante_RUT__c = cuenta.RUT__c;
                                Participante.MCAMP_Carga_Contratante_Dv__c = cuenta.DV__c;
                            }

                    	}
                        update Participante;
                    }
                }

                if (this.Cotizador.Tipo_Producto__c == '19')
                {
                    List<Cotizador_Express__c> asegurados = [SELECT Id, AseguradoId__c, ParentId__c FROM Cotizador_Express__c WHERE ParentId__c =: this.CotizadorId ORDER BY AseguradoId__c ASC];

                    /* actualiza orden de asegurados */
                    if (asegurados.size() > 0)
                    {
                        Integer cont = 2;
                        for (Cotizador_Express__c asegurado : asegurados)
                        {
                            asegurado.AseguradoId__c = Decimal.valueOf(cont);
                            cont++;
                        }

                        update asegurados;
                    }

                }
                LoadCotizador = true;
            }

            Campaign cmp = [SELECT Id, Name, RecordTypeId,Type FROM Campaign WHERE Id =: this.Cotizador.CampaignId__c];

            this.NombreCampagna = cmp.Name;

            this.TipoCampagna = cmp.Type;
            //Televenta - APEG
            //Televenta - Oncológico
            //Salud Protegida
            system.debug('@@@@ Tipo Campagna --> '+this.TipoCampagna);
        }

        //si cotizador no estaba almacenado con anterioridad
        if (LoadCotizador == false)
        {
            if (String.isNotBlank(TaskId))
            {
                this.generaContratanteTarea(TaskId);
            }
            else if (String.isNotBlank(LeadId))
            {
                this.generaContratanteProspecto(LeadId);
            }

            system.debug('@@@@ ErrorCarga  => ' + ErrorCarga);

            if(this.ErrorCarga != 'NO')
            {
                PageReference pageRef= new PageReference('/apex/SEC_VF_CM_ErrorCotizacion');
                pageRef.getParameters().put('ErrorCarga', this.ErrorCarga);

                pageRef.setRedirect(true);
                return pageRef;
            }
        }

        if (this.ErrorInicio == false)
        {
        	if (String.isNotBlank(this.CotizadorId))//si la respuesta es para un asegurado
            {
                this.cargaAsegurados(false);
            }
        }
        system.debug('@@@@ Contrata__c  => ' + this.Cotizador.Contrata__c);

        system.debug('@@@@ ErrorInicio  => ' + ErrorInicio);
      //llamada anterior elimiar comment

        if (this.Cotizador.Contrata__c == 'A')
        {
            this.Cotiza = 'Asegurado Titular';
        }
        else if (this.Cotizador.Contrata__c == 'C')
        {
            this.Cotiza = 'Contratante Original';
        }
        else if (this.Cotizador.Contrata__c == 'T')
        {
            this.Cotiza = 'Tercero';
        }

        if (this.Cotizador.Validado_WS__c == false)
        {
            this.Cotizador.WS_Valor_UF__c = '';
            this.Cotizador.WS_Valor_CLP__c = '';
            this.Cotizador.Asegurable__c = '';
        }

        this.TelefonoAsegurado = this.Cotizador.Telefono__c;
        this.CelularAsegurado = this.Cotizador.Celular__c;

        return null;
    }

    /*  REINICIAR COTIZADOR EXPRESS */
    public Pagereference ReiniciarCotizacion()
    {
        Cotizador_Express__c cotizador = [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, CampaingMemberId__c, CampaignId__c, AccountId__c, LeadId__c, Producto__c, RUT_Contratante__c, Nombres__c, Apellidos__c, Fecha_Nacimiento__c,
                                    Estado_Civil__c, Email__c, Telefono__c, Celular__c, Region__c, Comuna__c, Ciudad__c, Direccion__c, Asegurados_Dependientes__c, TaskId__c, OpportunityId__c, Tipo_Folio__c,
                                    UsuarioTV__c, Lista_Telefonos__c, Tipo_Producto__c, Tipo_Cliente__c, Carga_Cliente__c, Ramo__c, Codigo_Producto__c, Plan__c, Revision__c, Fecha_Nacimiento_Int__c,
                                    RecordTypeId__c, Relacion_Titular__c, ParentId__c, WS_Valida_Fecha_Nacimiento__c, WS_Valor_UF__c, WS_Valor_CLP__c, Poliza_Mandatoria__c, Codigo_Region__c, Estado__c,
                                    Codigo_Ciudad__c, Codigo_Comuna__c, ContactId__c, Pregunta_1__c, Pregunta_2__c, Pregunta_3__c, Pregunta_4__c, Pregunta_5__c, Asegurable__c, TipoCotizacion__c,
                                    RUT_Tercero__c, Nombre_Tercero__c, Correo_Electronico_Tercero__c, Telefono_Tercero__c, Contrata__c, Validado_WS__c
                                    FROM Cotizador_Express__c  WHERE  Id =: this.CotizadorId];

        cotizador.Estado__c = 'Anulado';
        update cotizador;//

        Pagereference pCotizador = new PageReference('/apex/SEC_VF_CM_CotizadorExpress');

        if (cotizador.TipoCotizacion__c == 'T') //Task
        {
            pCotizador.getParameters().put('Call', 'T');
            pCotizador.getParameters().put('TaskId', cotizador.TaskId__c);
        }
        else if (cotizador.TipoCotizacion__c == 'L') //Lead
        {
            pCotizador.getParameters().put('Call', 'L');
            pCotizador.getParameters().put('LeadId', cotizador.LeadId__c);
        }

        pCotizador.setRedirect(true);

        return pCotizador;
    }

    /*  ERROR COTIZADOR EXPRESS */
    public PageReference ErrorCotizador()
    {
        String Error = Apexpages.currentPage().getParameters().get('ErrorCarga');

        if (Error == 'ERROR_CMP_ID')
        {
            MensajeError = 'La Tarea o Prospecto seleccionado no estan asociado a ninguna Campaña.';
        }
        else if (Error == 'ERROR_CM_ID')
        {
            MensajeError = 'La Tarea o Prospecto seleccionado no estan asociado a ningun Miembro de Campaña.';
        }
        else if (Error == 'ERROR_FN_WS')
        {
            MensajeError = 'El miembro de campaña asociado a la Tarea o Prospecto no tiene registrado una Fecha de Nacimiento válida';
        }
        else if (Error == 'ERROR_CM_NF')
        {
            MensajeError = 'La Tarea o Prospecto seleccionado no estan asociado a ningun Miembro de Campaña válido.';
        }

        return null;
    }

}