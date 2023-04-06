/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 04-18-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   11-27-2020   Juan Espinoza León   Initial Version
**/
public class CTR_TV_GestionCarga {

    public Blob csvFileBody{get;set;}

    public string csvAsString{get;set;}

    public List<Campaign> campaigns {get;set;}

    private static Integer LimitUpload = 1000;

    public Boolean CargaOk {get; set;}

    public String EtapaCarga {get; set;}

    public String Mensaje {get; set;}

    public String CampaignId {get; set;}

    public String NombreCampagna {get; set;}

    public String RecordTypeIdProspecto_TeleventaOncologico = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
    public String RecordTypeIdProspecto_SaludProtegida = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Salud Protegida'].Id;

    public String recordType_Campaign_TeleventaOncologico = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;

    public String recordType_Campaign_SaludProtegida = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Salud Protegida'].Id;

    public String TipoCampagna {get; set;}

    public String IdCarga {get; set;}

    public String TipoCMP {get; set;}

    public String Total_Registros_Carga {get; set;}

    public String Total_Registros_Ok {get; set;}

    public String Total_Registros_Error {get; set;}

    public String Total_Prospectos_Ok {get; set;}

    public Boolean RValidos {get; set;}

    public Boolean RInvalidos {get; set;}

    public Carga_Televenta__c Carga {get; set;}

    public List<Registro_Carga_Televenta__c> RegistrosOK {get; set;}

    public List<Registro_Carga_Televenta__c> RegistrosError {get; set;}

    public  Map<Id, Registro_Carga_Televenta__c> rtvs_contactos {get; set;}

    public  Map<Id, Registro_Carga_Televenta__c> rtvs_prospectos {get; set;}

    public Map<Id, Account> map_cuentas  {get; set;}

    public Map<Id, Lead> map_prospectos  {get; set;}

    public String IdCampagna {get; set;}

    public Boolean Reprocesar {get; set;}

    public String Titulo {get; set;}

    /*Paginación*/
    public integer OffsetSize = 0;

    public integer LimitSize= 50;

    public integer totalRecs {get; set;}

    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}
    /*Paginación*/

    /*Paginación*/
    public void FirstPage()
    {
         OffsetSize = 0;
         Page = 1;
    }

    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        Page--;

        system.debug('@@@@  previous OffsetSize --> '+ OffsetSize);
        system.debug('@@@@  previous Page --> '+ Page);
    }

    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        Page++;


        system.debug('@@@@  next OffsetSize --> '+ OffsetSize);
        system.debug('@@@@  next Page --> '+ Page);
    }

    public void LastPage()
    {
        OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        Page = this.TotalPage;

        if (OffsetSize == totalrecs)
        {
            OffsetSize = totalrecs -   LimitSize;
        }

        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ totalrecs '+ totalrecs);
        system.debug('@@@@ Page '+ Page);
    }

    public boolean getprev()
    {
        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ Page '+ Page);

        if(OffsetSize == 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public boolean getnxt()
    {
        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ LimitSize '+ LimitSize);
        system.debug('@@@@ totalrecs '+ totalrecs);
        system.debug('@@@@ Page '+ Page);

        if((OffsetSize + LimitSize) >= totalRecs)
        {
            return true;
        }
        else
        {
            return false;
        }


    }

    /*Paginación*/


    //Cosntructor
    public CTR_TV_GestionCarga() {
        this.csvFileBody = null;
        //this.csvFileLines = new String[]{};
        this.campaigns = [SELECT Id, Name FROM Campaign WHERE IsActive = true AND Status = 'En Curso' AND (RecordTypeId =: recordType_Campaign_SaludProtegida OR RecordTypeId =: recordType_Campaign_TeleventaOncologico) ORDER BY CreatedDate DESC];

        //this.tvclist = New List<Registro_Carga_Televenta__c>();
        this.EtapaCarga = '';
    }

    //listado de campañas
    public  List<Selectoption> getCampagnasOnco()
    {
        try{
            List<Selectoption> LST_CMP = new List<Selectoption>();

            for (Campaign cmp : campaigns)
            {
                LST_CMP.add(new Selectoption(cmp.Id, cmp.Name));
            }

            return LST_CMP;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    //genera nueva carga de campaña
    public Map<String, String> CreateNewUpload()
    {
        Map<String, String> salida = new Map<String, String>();

        try
        {
            Campaign cmp = [SELECT Id, Name, CAMPA_Ejecutivo_Televenta__c, Type, CAMP_Producto__c, EndDate, IsActive FROM Campaign WHERE Id =: this.CampaignId];

            system.debug('@@@@ campaña --> '+ cmp);
            Carga_Televenta__c carga = new Carga_Televenta__c();

            carga.Campagna__c = cmp.Id;
            carga.IsActive__c = cmp.IsActive;
            carga.EndDate__c = cmp.EndDate;
            carga.Campagna_Name__c = cmp.Name;
            carga.Estado__c = 'CREADA';
            carga.Tipo__c = cmp.Type;

            if (cmp.Type == 'Salud Protegida')
            {
                carga.Producto__c = '20';
            }
            else if ((cmp.Type == 'Televenta - Oncológico') || (cmp.Type == 'Televenta - APEG'))
            {
                carga.Ejecutivos__c = cmp.CAMPA_Ejecutivo_Televenta__c;
                if (cmp.Type == 'Televenta - Oncológico')
                {
                    carga.Producto__c = '19';
                    carga.Tipo_Campagna__c = 'ONCO';
                    this.TipoCampagna = 'ONCO';
                }
                else if (cmp.Type == 'Televenta - APEG')
                {
                    carga.Producto__c = '66';
                    carga.Tipo_Campagna__c = 'APEG';
                    this.TipoCampagna = 'APEG';
                }
            }

            /*
            if (carga.Producto__c == '66')
            {
                carga.Tipo_Campagna__c = 'APEG';
                this.TipoCampagna = 'APEG';
            }
            else if (carga.Producto__c == '19')
            {
                carga.Tipo_Campagna__c = 'ONCO';
                this.TipoCampagna = 'ONCO';
            }*/

            system.debug('@@@@ carga --> '+ carga);
            insert carga;

            salida.put('Id', carga.Id);
            salida.put('Type', carga.Tipo__c);

            return salida;
        }
        catch(Exception e)
        {
            system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
            salida.put('Id', 'ERROR');
            salida.put('Type', 'ERROR');
            return salida;
        }
    }

    //realiza el upload del archivo a cargar
    //SEC_VF_TV_Carga_Campagna
    public PageReference importCSVFile()
    {
       system.debug('@@@@ importCSVFile');
       Map<String, String> resultado = this.CreateNewUpload();
       this.IdCarga = resultado.get('Id');
       this.TipoCMP = resultado.get('Type');
       system.debug('@@@@  this.IdCarga '+this.IdCarga);
       system.debug('@@@@ this.TipoCMP '+this.TipoCMP);
       if (this.IdCarga == 'ERROR' || tipoCmp == 'ERROR')
       {
           return null;//mencionar error
       }
       String[] csvFileLines = new String[]{};

       List<Registro_Carga_Televenta__c> tvclist = new List<Registro_Carga_Televenta__c>();
       system.debug('@@@@  this.csvFileBody '+this.csvFileBody);
       if (this.csvFileBody != null)
       {
           try
           {
                this.csvAsString = this.csvFileBody.toString();
                system.debug('@@@@ csvFileLines '+ this.csvAsString.split('\n'));
                csvFileLines = this.csvAsString.split('\n');

                Registro_Carga_Televenta__c tvcObj ;

                if (csvFileLines.size() > 1)
                {
                    string[] csvRecordData = csvFileLines[0].split(',');
                    system.debug('@@@@ csvRecordData '+ csvRecordData.size());
                    if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
                    {
                        if (csvRecordData.size()  == 13 )
                        {
                            for(Integer i=1;i<csvFileLines.size();i++)
                            {
                                csvRecordData = csvFileLines[i].split(',');
                                tvcObj = new Registro_Carga_Televenta__c() ;
                                tvcObj.Carga_Televenta__c = this.IdCarga;
                                tvcObj.RUT__c = csvRecordData[0];
                                tvcObj.DV__c = csvRecordData[1];
                                tvcObj.POLIZA_MANDATORIA__c = csvRecordData[2];
                                tvcObj.TELEFONO_1__c = csvRecordData[3];
                                tvcObj.TELEFONO_2__c = csvRecordData[4];
                                tvcObj.TELEFONO_3__c = csvRecordData[5];
                                tvcObj.TELEFONO_4__c = csvRecordData[6];
                                tvcObj.TELEFONO_5__c = csvRecordData[7];
                                tvcObj.TELEFONO_6__c = csvRecordData[8];
                                tvcObj.TELEFONO_7__c = csvRecordData[9];
                                tvcObj.TELEFONO_8__c = csvRecordData[10];
                                tvcObj.EMAILTEST__c = csvRecordData[11];
                                tvcObj.CORREOENVIADO__c = csvRecordData[12];
                                tvclist.add(tvcObj);
                            }

                            if (tvclist.Size() >LimitUpload)
                            {//limite de 1000 registros
                                this.Mensaje = 'Se ha producido un error al importar datos. Asegúrese de que la cantidad de registros sea menor o igual a '+LimitUpload;
                                this.EtapaCarga = 'ERR';
                            }
                        }
                        else {
                            this.Mensaje = 'Se ha producido un error al importar datos. Valide el formato del archivo de Carga';
                            this.EtapaCarga = 'ERR';
                        }
                    }
                    else if (this.TipoCMP == 'Salud Protegida')
                    {
                        if (csvRecordData.size()  == 13 )
                        {
                            for(Integer i=1;i<csvFileLines.size();i++)
                            {
                                system.debug('@@@@ LINE -->'+csvFileLines[i]);
                                csvRecordData = csvFileLines[i].split(',');
                                tvcObj = new Registro_Carga_Televenta__c() ;
                                tvcObj.Carga_Televenta__c = this.IdCarga;
                                tvcObj.RUT_PROSPECTO__c = csvRecordData[0]; //RUT_PROSPECTO
                                tvcObj.DV_PROSPECTO__c = csvRecordData[1]; //DV_PROSPECTO
                                tvcObj.NOMBRE_PROSPECTO__c = csvRecordData[2]; //NOMBRE_PROSPECTO
                                tvcObj.APELLIDO_PROSPECTO__c = csvRecordData[3]; //APELLIDO_PROSPECTO
                                tvcObj.RUT_CONTRATANTE_ORIGINAL__c = csvRecordData[4]; //RUT_CONTRATANTE_ORIGINAL
                                tvcObj.DV_CONTRATANTE_ORIGINAL__c = csvRecordData[5]; //DV_CONTRATANTE_ORIGINAL
                                tvcObj.POLIZA_CONTRATANTE_ORIGINAL__c = csvRecordData[6]; //POLIZA_CONTRATANTE_ORIGINAL
                                tvcObj.PLAN_COBERTURA__c = csvRecordData[7]; //PLAN_COBERTURA
                                tvcObj.TELEFONO__c = csvRecordData[8]; //TELEFONO
                                tvcObj.EMAIL__c = csvRecordData[9]; //EMAIL
                                tvcObj.FECHA_NACIMIENTO_PROSPECTO__c = csvRecordData[10]; //FECHA_NACIMIENTO_PROSPECTO
                                tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c = csvRecordData[11]; //FECHA_INICIO_VIGENCIA_PROSPECTO
                                tvcObj.CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c = csvRecordData[12]; //COD NUEVO PRODUCTO

                                tvclist.add(tvcObj);
                            }

                            if (tvclist.Size() >LimitUpload)
                            {//limite de 1000 registros
                                this.Mensaje = 'Se ha producido un error al importar datos. Asegúrese de que la cantidad de registros sea menor o igual a '+LimitUpload;
                                this.EtapaCarga = 'ERR';
                            }
                        }
                        else {
                            this.Mensaje = 'Se ha producido un error al importar datos. Valide el formato del archivo de Carga';
                            this.EtapaCarga = 'ERR';
                        }
                    }
                }
                else if (csvFileLines.size() == 1)
                {
                     this.Mensaje = 'El archivo seleccionado no tiene infomación asociada.';
                     this.EtapaCarga = 'ERR';
                }

                system.debug('@@@@ tvclist.size(): ' + tvclist);
            }
            catch (Exception e)
            {
                this.Mensaje = 'Se ha producido un error al importar datos. Asegúrese de que el formato del archivo CSV sea el esperado.';
                system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
                this.EtapaCarga = 'ERR';
            }
       }
       else
       {
          this.Mensaje =  'Se ha producido un error al importar datos. Debe seleccionar un archivo CSV válido.';
          this.EtapaCarga = 'ERR';
       }

       if (String.isBlank(this.EtapaCarga))
       {
            insert tvclist;
            this.EtapaCarga = 'OK';
       }

       if (this.EtapaCarga == 'OK')
       {
            PageReference page = new PageReference('/apex/SEC_VF_TV_Carga_Campagna_Result');
            page.getParameters().put('Id', this.IdCarga);
            page.getParameters().put('Reprocesar', 'false');
            page.setRedirect(true);

            return page;
       }
       else if (this.EtapaCarga == 'ERR')
       {
            Carga_Televenta__c carga = [SELECT Id FROM Carga_Televenta__c WHERE Id =: this.IdCarga];
            delete carga;

            system.debug('@@@@ Mensaje -->' + this.Mensaje);
            PageReference page = new PageReference('/apex/SEC_VF_TV_Carga_Campagna_Error');
            page.getParameters().put('Mensaje', this.Mensaje);
            page.setRedirect(true);

            return page;
       }

       return null;
    }

    //SEC_VF_TV_Carga_Campagna
    //SEC_VF_TV_Carga_Campagna_Result
    public Pagereference ToHistory()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Campagna
    public Pagereference CancelUpload()
    {

        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Campagna');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Campagna_Error
    public void InicioError()
    {
        system.debug('@@@@ Mensaje param -->' + apexpages.currentpage().getparameters().get('Mensaje'));
        this.Mensaje = apexpages.currentpage().getparameters().get('Mensaje');
        system.debug('@@@@ Mensaje -->' + this.Mensaje);
    }

    //SEC_VF_TV_Carga_Campagna_Error
    public Pagereference AceptarError()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Campagna');
        page.setRedirect(true);
        return page;
    }


    //SEC_VF_TV_Carga_Campagna_Result
    public void IniciaEnProceso()
    {
        this.IdCarga = apexpages.currentpage().getparameters().get('Id');
        this.Reprocesar = Boolean.valueOf(apexpages.currentpage().getparameters().get('Reprocesar'));
        this.Titulo = 'Procesar contenido archivo Csv Campaña';

        if (this.Reprocesar == true)
        {
            this.Titulo = 'Reprocesar contenido archivo Csv Campaña';
        }

        system.debug('@@@@ Reprocesar' +Reprocesar);
        List<Registro_Carga_Televenta__c> lista = [SELECT Id FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: this.IdCarga];
        totalRecs = lista.Size();

       OffsetSize = 0;
       Page = 1;

       Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
       this.TotalPage = totalRecs / LimitSize;

       if(totalrecs > range)
       {
           this.TotalPage++;
       }

       if (this.TotalPage == 0)
       {
           this.Page = 0;
       }

       system.debug('@@@@ totalRecs --> '+ totalRecs);
        system.debug('@@@@ range --> '+ range);
        system.debug('@@@@ TotalPage --> '+ TotalPage);
        system.debug('@@@@ Page --> '+ Page);

        this.Total_Registros_Carga = String.valueOf(totalrecs);
        this.Total_Registros_Error = '-';
        this.Total_Registros_Ok = '-';
        this.Total_Prospectos_Ok = '-';
        Carga_Televenta__c carga = [SELECT Campagna__c, Campagna_Name__c, Tipo_Campagna__c, Tipo__c FROM Carga_Televenta__c WHERE Id =: this.IdCarga];

        this.NombreCampagna = carga.Campagna_Name__c;
        this.TipoCampagna = carga.Tipo_Campagna__c;
        this.CampaignId = carga.Campagna__c;
        this.TipoCMP = carga.Tipo__c;
    }

    //SEC_VF_TV_Carga_Campagna_Result
    public List<Registro_Carga_Televenta__c> getData()
    {
        String query = '';

        if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
        {
            query = 'SELECT CORREOENVIADO__c, DV__c, EMAILTEST__c,  Id,  POLIZA_MANDATORIA__c, RUT__c, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }
        else if (this.TipoCMP  == 'Salud Protegida')
        {
            query = 'SELECT APELLIDO_PROSPECTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, Id, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c FROM Registro_Carga_Televenta__c  WHERE Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }

        /*
        Select APELLIDO_PROSPECTO__c, AccountId__c, CORREOENVIADO__c, CampaignMemberId__c, Carga_Televenta__c, ContactId__c, CreatedById, CreatedDate, CurrencyIsoCode, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, DV__c, EMAILTEST__c, EMAIL__c, ErrorCarga__c, ErrorDetalle__c, FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LeadId__c, NOMBRE_PROSPECTO__c, Name, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, POLIZA_MANDATORIA__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c, RUT__c, SystemModstamp, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c, TELEFONO__c FROM Registro_Carga_Televenta__c
        */

        system.debug('@@@@  query --> '+ query);
        List<Registro_Carga_Televenta__c> lista = Database.query(query);

        return lista;
    }

    //SEC_VF_TV_Carga_Campagna_Result
    public Pagereference ArchivoProcesadoOk(){
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Resultado_Ok');
        page.getParameters().put('id', this.IdCarga);
        page.getParameters().put('page', 'OK');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Campagna_Result
    public void ProcessUpload()
    {
        if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
        {
            this.ProcessUpload_ONCO_APEG();
        }
        else if (this.TipoCMP  == 'Salud Protegida')
        {
            this.ProcessUpload_SALUDPROTEGIDA();
        }
    }

    public void ProcessUpload_ONCO_APEG()
    {
        system.debug('@@@@ IdCarga: ' + IdCarga);

        Integer totalError = 0;

        List<Registro_Carga_Televenta__c> tvclist = [SELECT AccountId__c, CORREOENVIADO__c, CampaignMemberId__c, Carga_Televenta__c, ContactId__c, CreatedById, CreatedDate, CurrencyIsoCode, DV__c, EMAILTEST__c,
                                                            ErrorCarga__c, ErrorDetalle__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LeadId__c, Name, POLIZA_MANDATORIA__c, RUT__c, SystemModstamp,
                                                            TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c
                                                     FROM Registro_Carga_Televenta__c
                                                     WHERE Carga_Televenta__c =: this.IdCarga];

        Map<String, CampaignMember> miembros = new Map<String, CampaignMember>();

        for(CampaignMember mc : [SELECT Id, MCAMP_Carga_RUT__c FROM CampaignMember WHERE CampaignId=: this.CampaignId])
        {
            if(!miembros.containsKey(mc.MCAMP_Carga_RUT__c))
            {
                miembros.put(mc.MCAMP_Carga_RUT__c, mc);
            }
        }

        List<String> RUTs = new List<String>();
        List<String> RUTsL = new List<String>();

        for (Registro_Carga_Televenta__c tc : tvclist)
        {
            if (String.isNotBlank(tc.RUT__c))
            {
                RUTs.add(tc.RUT__c);
            }

            if (String.isNotBlank(tc.RUT__c) && String.isNotBlank(tc.DV__c))
            {
                RUTsL.add(tc.RUT__c+ '-'+tc.DV__c);
            }
        }

        system.debug('@@@@ RUTs '+ RUTs);


        Map<String, Account> cuentas = new Map<String, Account>();

        for(Account a : [SELECT Id, RecordTypeId, PersonContactId, PersonBirthdate, CUENT_No_quiere_ser_contactado_Televenta__c, Rut_contacto__pc, Firstname, Lastname,
        CUENT_Participando_en_Campana_Oncologica__c, Cantidad_Polizas_Activas__c, RUT__c
        FROM Account
        WHERE RUT__c IN :RUTs])
        {
            if(!cuentas.containsKey(a.RUT__c))
            {
                cuentas.put(a.RUT__c, a);
            }
        }

        Map<String, Lead> prospectos = new Map<String, Lead>();
        if (this.TipoCampagna== 'ONCO')
        {

            for(Lead l : [SELECT Id, Firstname, Lastname, Email, Phone, PROSP_Carga_Apellido_Materno__c, PROSP_Carga_Email_2__c, PROSP_Carga_RUT__c, PROSP_Carga_Tel_fono_2__c, PROSPE_Carga_Fecha_Nacimiento__c, PROSP_No_quiere_ser_contactado_Televenta__c
            FROM Lead WHERE RecordTypeId =: RecordTypeIdProspecto_TeleventaOncologico AND
            PROSP_Carga_RUT__c IN :RUTsL])
            {
                if(!prospectos.containsKey(l.PROSP_Carga_RUT__c))
                {
                    prospectos.put(l.PROSP_Carga_RUT__c, l);
                }
            }
        }

        List<Lead> leads = new List<Lead>();

        for (Registro_Carga_Televenta__c tvcObj : tvclist)
        {
            String error = '';
            Boolean apeg = false;

            if (String.isNotBlank(tvcObj.RUT__c) && String.isNotBlank(tvcObj.DV__c))
            {
                String rut = tvcObj.RUT__c + '' + tvcObj.DV__c;

                System.debug('@@@@ rut'+ rut);

                if (RUTUtils.isValid(rut) == true)
                {

                    if (miembros.ContainsKey(tvcObj.RUT__c))
                    {
                        tvcObj.ErrorCarga__c = true;
                        error = 'El RUT ingresado ya se encuentra registrado en la campaña.';
                    }

                    if ( tvcObj.ErrorCarga__c == false)
                    {
                        Account cuenta = null;

                        if( cuentas.ContainsKey(tvcObj.RUT__c) ){
                            cuenta = cuentas.get(tvcObj.RUT__c);
                        }

                        if (cuenta != null)
                        {
                            tvcObj.AccountId__c = cuenta.Id;
                            tvcObj.ContactId__c = cuenta.PersonContactId;
                        }
                        else
                        {
                            if (this.TipoCampagna == 'APEG')
                            {
                                error = 'El RUT ingresado no es Cliente.';
                                tvcObj.ErrorCarga__c = true;
                            }
                            else if (this.TipoCampagna == 'ONCO')
                            {
                                Lead prospecto = null;

                                if( prospectos.ContainsKey(tvcObj.RUT__c) ){
                                    prospecto = prospectos.get(tvcObj.RUT__c);
                                }

                                if (prospecto != null)
                                {
                                    tvcObj.LeadId__c = prospecto.Id;
                                }
                                else {
                                    Lead nCliente = new Lead();
                                    nCliente.RecordTypeId = RecordTypeIdProspecto_TeleventaOncologico;
                                    nCliente.FirstName = 'NN' ;
                                    nCliente.LastName = 'NN' ;
                                    nCliente.PROSP_Carga_RUT__c = tvcObj.RUT__c + '-' + tvcObj.DV__c;
                                    nCliente.PROSP_Carga_Apellido_Materno__c = 'NN' ;
                                    nCliente.Phone = tvcObj.TELEFONO_1__c;
                                    nCliente.PROSP_Carga_Tel_fono_2__c = tvcObj.TELEFONO_2__c;
                                    nCliente.Email = tvcObj.EMAILTEST__c;
                                    nCliente.PROSP_Carga_Email_2__c = '';
                                    nCliente.PROSPE_Carga_Fecha_Nacimiento__c = null;
                                    leads.add(nCliente);
                                }
                            }
                        }
                    }
                }
                else
                {
                    error = 'El RUT ingresado es inválido.';

                    tvcObj.ErrorCarga__c = true;
                }
            }
            else
            {
                error = 'El RUT ingresado se encuentra incompleto o vacio.';
                tvcObj.ErrorCarga__c = true;
            }

            if (tvcObj.ErrorCarga__c == false && String.isNotBlank(tvcObj.POLIZA_MANDATORIA__c))
            {
                try
                {
                    Decimal pol = Decimal.valueOf(tvcObj.POLIZA_MANDATORIA__c);
                }
                catch(Exception ex)
                {
                    if (String.isNotBlank(error))
                    {
                        error = error + '\n' + 'La poliza ingresada es errónea.';
                    }
                    else
                    {
                        error = 'La poliza ingresada es errónea.';
                    }

                    tvcObj.ErrorCarga__c = true;
                }
            }

            if (tvcObj.ErrorCarga__c == true)
            {
                tvcObj.ErrorDetalle__c = error;
                totalError++;
            }
        }

        Map<String, Lead> newlead = new Map<String, Lead>();
        if (this.TipoCampagna== 'ONCO')
        {

            for(Lead l : leads)
            {
                if(!newlead.containsKey(l.PROSP_Carga_RUT__c))
                {
                    newlead.put(l.PROSP_Carga_RUT__c, l);
                }
            }
        }


        if (this.TipoCampagna == 'ONCO' && leads.size() > 0)
        {
            insert leads;

            for (Registro_Carga_Televenta__c tv : tvclist) {
                if (String.isBlank(tv.AccountId__c) && String.isBlank(tv.LeadId__c))
                {
                    if(newlead.containsKey(tv.RUT__c + '-' + tv.DV__c))
                    {
                        Lead l = newlead.get(tv.RUT__c + '-' + tv.DV__c);
                        tv.LeadId__c = l.Id;
                    }
                }
            }
        }

        update tvclist;//guarda carga en base de datos

        Integer totalOk = tvclist.size() - totalError;

        if (totalOk == 0)
        {
            CLS_TV_GestionCarga.RefreshCargaTeleventa(this.IdCarga, tvclist.size() , totalError, totalOk, 0);
        }
        else{
            CLS_TV_GestionCarga.RefreshCargaTeleventa(this.IdCarga, tvclist.size() , totalError, totalOk, null);
        }

        Carga_Televenta__c c = [SELECT Id, Estado__c FROM Carga_Televenta__c WHERE Id =: this.IdCarga];
        c.Estado__c = 'EN PROCESO';
        update c;
    }

    public void ProcessUpload_SALUDPROTEGIDA()
    {
        system.debug('@@@@ IdCarga: ' + IdCarga);

        Integer totalError = 0;

        List<Registro_Carga_Televenta__c> tvclist = [SELECT AccountId__c, CampaignMemberId__c, Carga_Televenta__c, ContactId__c, CreatedById, CreatedDate, CurrencyIsoCode,
                                                            ErrorCarga__c, ErrorDetalle__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LeadId__c, Name, SystemModstamp,
                                                            APELLIDO_PROSPECTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c,
                                                            FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c,
                                                            RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c
                                                     FROM Registro_Carga_Televenta__c
                                                     WHERE Carga_Televenta__c =: this.IdCarga];

        Map<String, CampaignMember> miembros = new Map<String, CampaignMember>();//almacena miembros actuales de campaña

        for(CampaignMember mc : [SELECT Id, MCAMP_Carga_RUT__c FROM CampaignMember WHERE CampaignId=: this.CampaignId])
        {
            if(!miembros.containsKey(mc.MCAMP_Carga_RUT__c))
            {
                miembros.put(mc.MCAMP_Carga_RUT__c, mc);
            }
        }

        List<String> RUTs_Contratantes = new List<String>();
        List<String> RUTs_Prospectos = new List<String>();
        List<String> Polizas_Originales = new List<String>();

        for (Registro_Carga_Televenta__c tc : tvclist)
        {
            if (String.isNotBlank(tc.RUT_CONTRATANTE_ORIGINAL__c) && String.isNotBlank(tc.DV_CONTRATANTE_ORIGINAL__c) &&
            (String.isNotBlank(tc.RUT_PROSPECTO__c) && String.isNotBlank(tc.DV_PROSPECTO__c)) &&
            ((String.isNotBlank(tc.POLIZA_CONTRATANTE_ORIGINAL__c))))
            {
                RUTs_Contratantes.add(tc.RUT_CONTRATANTE_ORIGINAL__c);
                RUTs_Prospectos.add(tc.RUT_PROSPECTO__c);
                Polizas_Originales.add(tc.POLIZA_CONTRATANTE_ORIGINAL__c);
            }
        }

        system.debug('@@@@ RUTs_Contratantes '+ RUTs_Contratantes);
        system.debug('@@@@ RUTs_Prospectos '+ RUTs_Prospectos);
        system.debug('@@@@ Polizas_Originales '+ Polizas_Originales);

        Map<String, Account> cuentas = new Map<String, Account>();

        for(Account a : [SELECT Id, Name, RecordTypeId, PersonContactId, PersonBirthdate, CUENT_No_quiere_ser_contactado_Televenta__c, Rut_contacto__pc, Firstname, Lastname,
        CUENT_Participando_en_Campana_Oncologica__c, Cantidad_Polizas_Activas__c, RUT__c, PersonEmail, Comuna_Particular__c, Direccion_Particular__c, PersonHomePhone,
                                                PersonOtherPhone, Phone, PersonMobilePhone, Agente_Original__c, Agente_Actual__c, Codigo_Agente__c, Estado_Agente__c, Tipo_Intermediario__c, Ejecutivo_de_Cliente__c,
                                                Sucursal_Ejecutivo_de_Clientes__c, Fecha_Ultimo_Cambio_Propietario__c, Cliente_Fidelizado__c, Codigo_Ejecutivo__c,
                                                Region_Particular_B__c, Ciudad_Particular_B__c
        FROM Account  WHERE RUT__c IN :RUTs_Contratantes])
        {
            if(!cuentas.containsKey(a.RUT__c))
            {
                cuentas.put(a.RUT__c, a);
            }
        }

        Map<String, Lead> prospectos = new Map<String, Lead>();

        for(Lead l : [SELECT Id, Firstname, Lastname, Email, Phone, PROSP_Carga_Apellido_Materno__c, PROSP_Carga_Email_2__c, PROSP_Carga_RUT__c, PROSP_Carga_Tel_fono_2__c, PROSPE_Carga_Fecha_Nacimiento__c, PROSP_No_quiere_ser_contactado_Televenta__c
        FROM Lead WHERE RecordTypeId =: RecordTypeIdProspecto_SaludProtegida AND PROSP_Carga_RUT__c IN :RUTs_Prospectos AND Status = 'Contratante no contactado' AND Sub_Estado__c = 'Llamar contratante'])
        {
            if(!prospectos.containsKey(l.PROSP_Carga_RUT__c))
            {
                prospectos.put(l.PROSP_Carga_RUT__c, l);
            }
        }

        Map<String, Poliza__c> polizas = new Map<String, Poliza__c>();

        for(Poliza__c p : [SELECT Id, Name, IDPOLIZA__c FROM Poliza__c  WHERE Name IN :Polizas_Originales])
        {
            if(!polizas.containsKey(p.Name))
            {
                polizas.put(p.Name, p);
            }
        }

        List<Lead> leads = new List<Lead>();
        List<Lead> updleads = new List<Lead>();
        for (Registro_Carga_Televenta__c tvcObj : tvclist)
        {
            String error = '';
            Boolean apeg = false;

            if (String.isNotBlank(tvcObj.RUT_PROSPECTO__c) && String.isNotBlank(tvcObj.DV_PROSPECTO__c) && String.isNotBlank(tvcObj.RUT_CONTRATANTE_ORIGINAL__c) && String.isNotBlank(tvcObj.DV_CONTRATANTE_ORIGINAL__c))
            {
                String rutProspecto = tvcObj.RUT_PROSPECTO__c + '' + tvcObj.DV_PROSPECTO__c;
                String rutContratante = tvcObj.RUT_CONTRATANTE_ORIGINAL__c + '' + tvcObj.DV_CONTRATANTE_ORIGINAL__c;

                System.debug('@@@@ rutProspecto'+ rutProspecto);
                System.debug('@@@@ rutContratante'+ rutContratante);

                if (RUTUtils.isValid(rutProspecto) == true && RUTUtils.isValid(rutContratante) == true)
                {
                    if (miembros.ContainsKey(tvcObj.RUT_PROSPECTO__c))
                    {
                        tvcObj.ErrorCarga__c = true;
                        error = 'El RUT ingresado ya se encuentra registrado en la campaña.';
                    }

                    if (tvcObj.ErrorCarga__c == false)
                    {
                        Account cuenta = null;
                        Lead lead = null;
                        Poliza__c poliza = null;

                        if(prospectos.ContainsKey(tvcObj.RUT_PROSPECTO__c) ){
                            lead = prospectos.get(tvcObj.RUT_PROSPECTO__c);
                        }
                        system.debug('@@@@ Lead --> '+lead);

                        if(cuentas.ContainsKey(tvcObj.RUT_CONTRATANTE_ORIGINAL__c) ){
                            cuenta = cuentas.get(tvcObj.RUT_CONTRATANTE_ORIGINAL__c);
                        }
                        system.debug('@@@@ cuenta --> '+cuenta);

                        if(polizas.ContainsKey(tvcObj.POLIZA_CONTRATANTE_ORIGINAL__c) ){
                            poliza = polizas.get(tvcObj.POLIZA_CONTRATANTE_ORIGINAL__c);
                        }

                        system.debug('@@@@ poliza --> '+poliza);

                        if (cuenta != null && poliza != null)
                        {
                            tvcObj.AccountId__c = cuenta.Id;
                            tvcObj.PolizaId__c = poliza.Id;

                            if (lead == null)
                            {
                                lead = new Lead();
                                lead.RecordTypeId = this.RecordTypeIdProspecto_SaludProtegida;
                                lead.Status = 'Contratante no contactado';
                                lead.Sub_Estado__c = 'Llamar contratante';
                                lead.CurrencyIsoCode = 'CLF';
                                lead.OwnerId = '005i0000004xhHp'; //Salesforce Vida Security
                                lead.FirstName = tvcObj.NOMBRE_PROSPECTO__c ;
                                lead.LastName = tvcObj.APELLIDO_PROSPECTO__c ;
                                lead.Plan__c = tvcObj.PLAN_COBERTURA__c ;
                                lead.PROSP_Carga_RUT__c = tvcObj.RUT_PROSPECTO__c ;
                               // lead.Nombre_Contratante__c = cuenta.Name;
                                lead.DV__c = tvcObj.DV_PROSPECTO__c ;
                                //Integer FN_year = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[0]);
                                //Integer FN_month = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[1]);
                                //Integer FN_day = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[2]);

                                Integer FN_year = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[2]);
                                Integer FN_month = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[1]);
                                Integer FN_day = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[0]);

                                lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.newInstance(FN_year, FN_month, FN_day);
                               // lead.Intermediario_Poliza__c = tvcObj.INTERMEDIARIO_POLIZA__c;
                                lead.PROSP_Carga_Tel_fono_2__c = tvcObj.TELEFONO__c ;
                                lead.PROSP_Carga_Email_2__c = tvcObj.EMAIL__c ;
                                lead.Email = tvcObj.EMAIL__c ;
                                lead.Intermediario_Poliza__c = tvcObj.CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c;
                                //Integer FV_year = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('-')[0]);
                                //Integer FV_month = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('-')[1]);
                                //Integer FV_day = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('-')[2]);

                                Integer FV_year = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('/')[2]);
                                Integer FV_month = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('/')[1]);
                                Integer FV_day = Integer.valueOf(tvcObj.FECHA_INICIO_VIGENCIA_PROSPECTO__c.split('/')[0]);
                                lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.newInstance(FV_year, FV_month, FV_day);
                                lead.Cuenta__c = cuenta.Id;
                                lead.Poliza__c = poliza.Id;
                                lead.Phone = tvcObj.TELEFONO__c;
                                leads.add(lead);
                            }
                            else
                            {
                                tvcObj.LeadId__c = lead.Id;
                                lead.PROSP_Carga_Tel_fono_2__c = tvcObj.TELEFONO__c ;
                                lead.PROSP_Carga_Email_2__c = tvcObj.EMAIL__c ;
                                lead.Email = tvcObj.EMAIL__c ;
                               // lead.Nombre_Contratante__c = cuenta.Name;
                                lead.Cuenta__c = cuenta.Id;
                                lead.Poliza__c = poliza.Id;
                                lead.Phone = tvcObj.TELEFONO__c;
                                updleads.add(lead);
                            }
                        }
                        else
                        {
                            //Error no poliza o no cuenta
                            tvcObj.ErrorCarga__c = true;
                            error = 'Cuenta original o Poliza original no encontradas.';
                        }
                    }
                }
                else
                {
                    if (RUTUtils.isValid(rutProspecto) == false)
                    {
                        error = 'El RUT de Prospecto ingresado es inválido.';

                    }
                    else  if (RUTUtils.isValid(rutContratante) == false)
                    {
                        error =  error + 'El RUT de Contratante ingresado es inválido.';
                    }

                    tvcObj.ErrorCarga__c = true;
                }
            }
            else
            {
                error = 'Faltan parametros necesarios para procesar registro, valide ingreso de RUTs y DVs';
                tvcObj.ErrorCarga__c = true;
            }

            if (tvcObj.ErrorCarga__c == true)
            {
                tvcObj.ErrorDetalle__c = error;
                totalError++;
            }
        }

        if (!Test.isRunningTest())
        {
	        update updleads;
    	    insert leads;
        }

        Map<String, Lead> prospectos_nuevos = new Map<String, Lead>();

        for (Lead l : leads)
        {
            if(!prospectos_nuevos.containsKey(l.PROSP_Carga_RUT__c))
            {
                prospectos_nuevos.put(l.PROSP_Carga_RUT__c, l);
            }
        }

        for (Registro_Carga_Televenta__c tv : tvclist) {
            if (tv.LeadId__c == null)
            {
                if(prospectos_nuevos.containsKey(tv.RUT_PROSPECTO__c))
                {
                    Lead l = prospectos_nuevos.get(tv.RUT_PROSPECTO__c);
                    tv.LeadId__c = l.Id;
                }
            }
        }

        update tvclist;//guarda carga en base de datos

        Integer totalOk = tvclist.size() - totalError;

        if (totalOk == 0)
        {
            CLS_TV_GestionCarga.RefreshCargaTeleventa(this.IdCarga, tvclist.size() , totalError, totalOk, 0);
        }
        else{
            CLS_TV_GestionCarga.RefreshCargaTeleventa(this.IdCarga, tvclist.size() , totalError, totalOk, null);
        }

        Carga_Televenta__c c = [SELECT Id, Estado__c FROM Carga_Televenta__c WHERE Id =: this.IdCarga];
        c.Estado__c = 'EN PROCESO';
        update c;
    }

    public void IniciaCargaResultado()
    {
         String Id = apexpages.currentpage().getparameters().get('id');
         String Pagina = apexpages.currentpage().getparameters().get('page');
         system.debug('@@@@  Id --> '+ Id);
         this.RValidos = false;
         this.RInvalidos = false;

         this.Carga = [SELECT Id, Campagna_Name__c, Total_Registros_Carga__c, Tipo__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, Email_Notificacion__c, Estado__c, Campagna__c, Ejecutivos__c, Producto__c, Tipo_Campagna__c, IsActive__c, EndDate__c FROM Carga_Televenta__c WHERE Id=: Id];
         system.debug('@@@@  Carga --> '+ Carga);
         this.IdCampagna = this.Carga.Campagna__c;
         this.TipoCMP = this.Carga.Tipo__c;
         this.IdCarga = this.Carga.Id;

         if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
         {
            this.RegistrosOK = [SELECT Id, RUT__c, DV__c, TELEFONO_1__c, TELEFONO_2__c,TELEFONO_3__c,TELEFONO_4__c,TELEFONO_5__c,TELEFONO_6__c,TELEFONO_7__c,TELEFONO_8__c, AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, EMAILTEST__c, Carga_Televenta__c, ErrorCarga__c, CORREOENVIADO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: Id AND ErrorCarga__c = false];

            this.RegistrosError = [SELECT Id, RUT__c, DV__c, TELEFONO_1__c, TELEFONO_2__c,TELEFONO_3__c,TELEFONO_4__c,TELEFONO_5__c,TELEFONO_6__c,TELEFONO_7__c,TELEFONO_8__c, AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, EMAILTEST__c, Carga_Televenta__c, ErrorCarga__c, CORREOENVIADO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: Id AND ErrorCarga__c = true];
         }
         else if (this.TipoCMP  == 'Salud Protegida')
         {
            this.RegistrosOK = [SELECT APELLIDO_PROSPECTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, Id, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c, AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, EMAILTEST__c, Carga_Televenta__c, ErrorCarga__c, CORREOENVIADO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c, PolizaId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: Id AND ErrorCarga__c = false];

            this.RegistrosError = [SELECT APELLIDO_PROSPECTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, Id, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c,  NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c, PolizaId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: Id AND ErrorCarga__c = true];
         }

        if (Pagina == 'OK')
        {
            totalRecs = this.RegistrosOK.Size();
        }
        else if (Pagina == 'ERROR')
        {
            totalRecs = this.RegistrosError.Size();
        }


         OffsetSize = 0;
         Page = 1;

         Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
         this.TotalPage = totalRecs / LimitSize;

         if(totalrecs > range)
         {
             this.TotalPage++;
         }

         if (this.TotalPage == 0)
         {
             this.Page = 0;
         }

         system.debug('@@@@ totalRecs --> '+ totalRecs);
          system.debug('@@@@ range --> '+ range);
          system.debug('@@@@ TotalPage --> '+ TotalPage);
          system.debug('@@@@ Page --> '+ Page);
          ///


         List<String> accountIds = new List<String>();

         List<String> leadIds = new List<String>();

         this.rtvs_contactos = new Map<Id, Registro_Carga_Televenta__c> ();

         this.rtvs_prospectos = new Map<Id, Registro_Carga_Televenta__c> ();

         this.map_cuentas = new Map<Id, Account> ();

         this.map_prospectos = new Map<Id, Lead> ();

         this.TipoCampagna = this.Carga.Tipo_Campagna__c;

         for (Registro_Carga_Televenta__c tc : this.RegistrosOK)
         {
             if (String.isNotBlank(tc.AccountId__c))
             {
                 rtvs_contactos.put(tc.ContactId__c, tc);
                 accountIds.add(tc.AccountId__c);
             }
             else if (String.isNotBlank(tc.LeadId__c)){
                 rtvs_prospectos.put(tc.LeadId__c, tc);
                 leadIds.add(tc.LeadId__c);
             }

         }

         system.debug('@@@@ accountIds '+ accountIds);
         system.debug('@@@@ leadIds '+ leadIds);


         for(Account a : [SELECT Id, RecordTypeId, PersonContactId, PersonBirthdate, CUENT_No_quiere_ser_contactado_Televenta__c, Rut_contacto__pc, Firstname, Lastname,
         CUENT_Participando_en_Campana_Oncologica__c, Cantidad_Polizas_Activas__c, RUT__c
         FROM Account
         WHERE Id IN :accountIds])
         {
             if(!map_cuentas.containsKey(a.Id))
             {
                 map_cuentas.put(a.Id, a);
             }
         }

         if (this.TipoCampagna== 'ONCO')
         {

             for(Lead l : [SELECT
             Id, Firstname, Lastname, Email, Phone, PROSP_Carga_Apellido_Materno__c, PROSP_Carga_Email_2__c, PROSP_Carga_RUT__c, PROSP_Carga_Tel_fono_2__c, PROSPE_Carga_Fecha_Nacimiento__c, PROSP_No_quiere_ser_contactado_Televenta__c
             FROM Lead
             WHERE Id IN :leadIds])
             {
                 if(!map_prospectos.containsKey(l.Id))
                 {
                     map_prospectos.put(l.Id, l);
                 }
             }
         }

        //this.EtapaCarga = 'INS';
        this.Total_Registros_Carga = String.valueOf(this.RegistrosOK.size()+this.RegistrosError.size());
        this.Total_Registros_Error = String.valueOf(this.RegistrosError.size());
        this.Total_Registros_Ok = String.valueOf(this.RegistrosOK.size());

        if (this.RegistrosOK.size() == 0)
        {
           this.Total_Prospectos_Ok = '0';
        }

        if (this.RegistrosOK.size() > 0)
        {
           this.RValidos = true;
        }

        if (this.RegistrosError.size() > 0)
        {
           this.RInvalidos = true;
        }
    }

    //SEC_VF_TV_Carga_Resultado_OK
    //SEC_VF_TV_Carga_Resultado_Error
    public void GenerateCampaignMember()
    {
        if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
        {
            this.GenerateCampaignMember_ONCO_APEG();
        }
        else if (this.TipoCMP  == 'Salud Protegida')
        {
            this.GenerateCampaignMember_SALUDPROTEGIDA();
        }
    }

    public void GenerateCampaignMember_ONCO_APEG()
    {
        List<CampaignMember> cms = new List<CampaignMember>();

        Map<String, Registro_Carga_Televenta__c> registros = new Map<String, Registro_Carga_Televenta__c>();

        for (Registro_Carga_Televenta__c tvcObj : this.RegistrosOK)
        {
            system.debug('@@@@ tvcObj '+tvcObj);
            CampaignMember cm = new CampaignMember();
            cm.WEB_UPLOAD__c = true;
            cm.MCAMP_Carga_RUT__c = tvcObj.RUT__c;
            cm.MCAMP_Carga_Dv__c = tvcObj.DV__c;
            cm.CampaignId = this.Carga.Campagna__c;

            cm.MCAMP_Carga_Email_1__c = tvcObj.EMAILTEST__c;
            cm.MCAMP_Carga_Poliza_Mandatoria__c = tvcObj.POLIZA_MANDATORIA__c;
            cm.MCAMP_Carga_Tel_fono_1__c = tvcObj.TELEFONO_1__c;
            cm.MCAMP_Carga_Tel_fono_2__c = tvcObj.TELEFONO_2__c;
            cm.MCAMP_Carga_Tel_fono_3__c = tvcObj.TELEFONO_3__c;
            cm.MCAMP_Carga_Tel_fono_4__c = tvcObj.TELEFONO_4__c;
            cm.MCAMP_Carga_Tel_fono_5__c = tvcObj.TELEFONO_5__c;
            cm.MCAMP_Carga_Tel_fono_6__c = tvcObj.TELEFONO_6__c;
            cm.MCAMP_Carga_Tel_fono_7__c = tvcObj.TELEFONO_7__c;
            cm.MCAMP_Carga_Tel_fono_8__c = tvcObj.TELEFONO_8__c;
            if (tvcObj.CORREOENVIADO__c == 'true')
            {
                cm.MCAMP_Enviado_Email_1_Producto_Onco__c = true;
            }

            cm.MCAMP_Campana_Activa__c = carga.IsActive__c;
            cm.MCAMP_Ejecutivo_Televenta__c = carga.Ejecutivos__c;
            cm.MCAMP_Fecha_Fin_Campana__c =  carga.EndDate__c;

            system.debug('@@@@ cm pre'+cm);
            if (this.TipoCampagna == 'APEG')
            {
                Account cuenta = null;

                if( map_cuentas.ContainsKey(tvcObj.AccountId__c) ){
                    cuenta = map_cuentas.get(tvcObj.AccountId__c);
                }

                if (cuenta != null)
                {
                    cm.ContactId = cuenta.PersonContactId;
                    if (cuenta.Cantidad_Polizas_Activas__c > 0)
                    {
                        cm.MCAMP_Es_cliente__c = true;
                        cm.MCAMP_Tipo_Cliente__c = 'Existente';
                    } else {
                        cm.MCAMP_Es_cliente__c = false;
                        cm.MCAMP_Tipo_Cliente__c = 'Nuevo';
                    }

                    cm.MCAMP_Carga_Fecha_Nacimiento__c = cuenta.PersonBirthdate;
                    cm.MCAPM_Carga_Primer_Nombre__c = cuenta.FirstName;
                    cm.MCAMP_Carga_Apellido_Paterno__c = cuenta.LastName;
                }
                cm.MCAMP_Tipo_Producto__c = '66';
            }
            else  if (this.TipoCampagna == 'ONCO')
            {
                Account cuenta = null;

                if(this.map_cuentas.ContainsKey(tvcObj.AccountId__c) ){
                    cuenta = this.map_cuentas.get(tvcObj.AccountId__c);
                }

                if (cuenta != null)
                {
                    cm.ContactId = cuenta.PersonContactId;
                    if (cuenta.Cantidad_Polizas_Activas__c > 0)
                    {
                        cm.MCAMP_Es_cliente__c = true;
                        cm.MCAMP_Tipo_Cliente__c = 'Existente';
                    } else {
                        cm.MCAMP_Es_cliente__c = false;
                        cm.MCAMP_Tipo_Cliente__c = 'Nuevo';
                    }

                    cm.MCAMP_Carga_Fecha_Nacimiento__c = cuenta.PersonBirthdate;
                    cm.MCAPM_Carga_Primer_Nombre__c = cuenta.FirstName;
                    cm.MCAMP_Carga_Apellido_Paterno__c = cuenta.LastName;
                }
                else {

                    Lead prospecto;

                    if( this.map_prospectos.ContainsKey(tvcObj.LeadId__c) ){
                        prospecto = this.map_prospectos.get(tvcObj.LeadId__c);
                    }

                    cm.LeadId = prospecto.Id;
                    cm.MCAMP_Es_cliente__c = false;
                    cm.MCAMP_Tipo_Cliente__c = 'Nuevo';

                    cm.MCAMP_Carga_Fecha_Nacimiento__c = prospecto.PROSPE_Carga_Fecha_Nacimiento__c;
                    cm.MCAPM_Carga_Primer_Nombre__c = prospecto.FirstName;
                    cm.MCAMP_Carga_Apellido_Paterno__c = prospecto.LastName;
                    cm.MCAMP_Carga_Apellido_Materno__c = prospecto.PROSP_Carga_Apellido_Materno__c;
                }
                cm.MCAMP_Tipo_Producto__c = '19';
            }
            system.debug('@@@@ cm ppost'+cm);

            if ((cm.MCAPM_Carga_Primer_Nombre__c == 'NN' && cm.MCAMP_Carga_Apellido_Paterno__c == 'NN') || cm.MCAMP_Carga_Fecha_Nacimiento__c == null)
            {
                cm.MCAMP_WS_Equifax_Consumido__c = false;
            }
            else {
                cm.MCAMP_WS_Equifax_Consumido__c = true;
            }

            cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
            system.debug('@@@@ CM --> '+ cm);
            cms.add(cm); //almacena miembro de campaña
            registros.put(tvcObj.RUT__c, tvcObj);
        }

        system.debug('@@@@ cms --> '+ cms);

        if (!Test.isRunningTest())
        {
           insert cms;
        }

        CLS_TV_GestionCarga.RefreshCargaTeleventa(this.Carga.Id, null, null, null, cms.size());

        List<Registro_Carga_Televenta__c> lregistros = new List<Registro_Carga_Televenta__c>();

        for (CampaignMember mc : cms) {

            if(registros.ContainsKey(mc.MCAMP_Carga_RUT__c) ){
                Registro_Carga_Televenta__c r = registros.get(mc.MCAMP_Carga_RUT__c);
                r.CampaignMemberId__c = mc.Id;
                mc.MCAMP_WS_Producto_Oncol_gico_Consumido__c = false;
                lregistros.add(r);
            }
        }

        Carga_Televenta__c c = [SELECT Id, Estado__c FROM Carga_Televenta__c WHERE Id =: this.Carga.Id];
        c.Estado__c = 'COMPLETADA';
        update c;

        system.debug('@@@@ lregistros '+lregistros);
        update lregistros;

        try
        {
            System.debug('@@@@ Campagna => ' + this.Carga.Campagna__c);
            BAT_CM_ProcesaProspecto_OncoApeg j_MConco = new BAT_CM_ProcesaProspecto_OncoApeg(this.Carga.Campagna__c);
            //BAT_TV_GestionCargaCampagna j_MConco = new BAT_TV_GestionCargaCampagna(this.Carga.Campagna__c);
            Id IdJobs = Database.executeBatch(j_MConco, 1);
            System.debug('@@@@ IdJobs => ' + IdJobs);
        }
        catch(System.Exception ex){
            System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
        }
        finally
        {

        }

    }


    private String[] getValues_Plan_SaludProtegida(String code)
    {
        system.debug('@@@@ code '+ code);
        system.debug('@@@@ code.length() '+ code.length());
        if (code.length() == 14)
        {
            String[] salida = new String[4];
            salida[0] = code.subString(0,4);
            system.debug('@@@@ salida[0] '+ salida[0]);
            salida[1] = code.subString(4,8);
            system.debug('@@@@ salida[1] '+ salida[1]);
            salida[2] = code.subString(8,11);
            system.debug('@@@@ salida[2] '+ salida[2]);
            salida[3] = code.subString(11,14);
            system.debug('@@@@  salida[3] '+  salida[3]);

            return salida;
        }

        return null;
    }

    public void GenerateCampaignMember_SALUDPROTEGIDA()
    {
        List<CampaignMember> cms = new List<CampaignMember>();

        Map<String, Registro_Carga_Televenta__c> registros = new Map<String, Registro_Carga_Televenta__c>();

        //Registro_Carga_Televenta__c tmp = this.RegistrosOK[0];

       // Carga_Televenta__c carga = [SELECT EndDate__c FROM Carga_Televenta__c WHERE Id =: tmp.Carga_Televenta__c];

        for (Registro_Carga_Televenta__c tvcObj : this.RegistrosOK)
        {
            system.debug('@@@@ tvcObj '+tvcObj);
            CampaignMember cm = new CampaignMember();
            cm.LeadId = tvcObj.LeadId__c;
            cm.MCAMP_Carga_RUT__c = tvcObj.RUT_PROSPECTO__c;
            cm.MCAMP_Carga_Dv__c = tvcObj.DV_PROSPECTO__c;

            String[] values = this.getValues_Plan_SaludProtegida(tvcObj.CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c);
            if (values != null)
            {
                cm.MCAMP_Plan__c = values[2];
                cm.MCAMP_Codigo_Producto__c = values[0];
                cm.MCAMP_Ramo__c = values[1];
                cm.MCAMP_Revision__c = values[3];
            }
            // cm.MCAMP_Plan__c = '001';
            // cm.MCAMP_Codigo_Producto__c = 'MD01';
            // cm.MCAMP_Ramo__c = '7400';
            // cm.MCAMP_Revision__c = '001';

            cm.MCAMP_Tipo_Folio__c = '20';
            cm.CampaignId = this.Carga.Campagna__c;
            cm.WEB_UPLOAD__c = false;//permite operar en trigger TRG_GestorMiembrosCampanaTeleventa -- si false -> opera
            cm.MCAMP_Campana_Activa__c = carga.IsActive__c;
            //Integer FN_year = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[0]);
            //Integer FN_month = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[1]);
            //Integer FN_day = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('-')[2]);

            Integer FN_year = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[2]);
            Integer FN_month = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[1]);
            Integer FN_day = Integer.valueOf(tvcObj.FECHA_NACIMIENTO_PROSPECTO__c.split('/')[1]);

            cm.MCAMP_Carga_Fecha_Nacimiento__c = Date.newInstance(FN_year, FN_month, FN_day);
          //  cm.Phone = tvcObj.TELEFONO__c;
            //cm.Email = tvcObj.EMAIL__c ;
            cm.MCAMP_Tipo_Producto__c = '20';
            cm.MCAMP_Fecha_Fin_Campana__c = carga.EndDate__c;
            cm.Poliza__c = tvcObj.PolizaId__c;
            system.debug('@@@@ cm '+cm);
            system.debug('@@@@ CM --> '+ cm);
            cms.add(cm); //almacena miembro de campaña
            registros.put(tvcObj.RUT_PROSPECTO__c, tvcObj);
        }

        system.debug('@@@@ cms --> '+ cms);

        if (!Test.isRunningTest())
        {
           insert cms;
        }

        CLS_TV_GestionCarga.RefreshCargaTeleventa(this.Carga.Id, null, null, null, cms.size());

        List<Registro_Carga_Televenta__c> lregistros = new List<Registro_Carga_Televenta__c>();

        for (CampaignMember mc : cms) {

            if(registros.ContainsKey(mc.MCAMP_Carga_RUT__c) ){
                Registro_Carga_Televenta__c r = registros.get(mc.MCAMP_Carga_RUT__c);
                r.CampaignMemberId__c = mc.Id;
                lregistros.add(r);
            }
        }

        Carga_Televenta__c c = [SELECT Id, Campagna__c, Estado__c FROM Carga_Televenta__c WHERE Id =: this.Carga.Id];

        c.Estado__c = 'COMPLETADA';
        update c;

        system.debug('@@@@ lregistros '+lregistros);
        update lregistros;
    }

    //SEC_VF_TV_Carga_Resultado_OK
    //SEC_VF_TV_Carga_Resultado_Error
    public Pagereference CancelGestion()
    {
        Carga_Televenta__c c = [SELECT Id, Estado__c, Total_Prospectos_Ok__c FROM Carga_Televenta__c WHERE Id =: this.Carga.Id];
        c.Estado__c = 'CANCELADA';
        c.Total_Prospectos_Ok__c = 0;
        update c;
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Resultado_OK
    //SEC_VF_TV_Carga_Resultado_Error
    public Pagereference RegistrosValidos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Resultado_Ok');
        page.getParameters().put('id', this.IdCarga);
        page.getParameters().put('page', 'OK');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Resultado_OK
    //SEC_VF_TV_Carga_Resultado_Error
    public Pagereference RegistrosInvalidos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Resultado_Error');
        page.getParameters().put('id', this.IdCarga);
        page.getParameters().put('page', 'ERROR');
        page.setRedirect(true);
        return page;
    }

    //SEC_VF_TV_Carga_Resultado_OK
    public List<Registro_Carga_Televenta__c> getData_OK()
    {
        String query = '';

        if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
        {
            query = 'SELECT CORREOENVIADO__c, DV__c, EMAILTEST__c,  Id,  POLIZA_MANDATORIA__c, RUT__c, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c FROM Registro_Carga_Televenta__c WHERE ErrorCarga__c = false AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }
        else if (this.TipoCMP  == 'Salud Protegida')
        {
            query = 'SELECT APELLIDO_PROSPECTO__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, Id, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c FROM Registro_Carga_Televenta__c  WHERE ErrorCarga__c = false AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }

        system.debug('@@@@  query --> '+ query);
        List<Registro_Carga_Televenta__c> lista = Database.query(query);

        return lista;
    }

    //SEC_VF_TV_Carga_Resultado_Error
    public List<Registro_Carga_Televenta__c> getData_Error()
    {
        String query = '';

        if (this.TipoCMP == 'Televenta - Oncológico' || this.TipoCMP == 'Televenta - APEG')
        {
            query = 'SELECT CORREOENVIADO__c, DV__c, EMAILTEST__c,  Id,  POLIZA_MANDATORIA__c, RUT__c, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c, ErrorDetalle__c FROM Registro_Carga_Televenta__c WHERE ErrorCarga__c = true AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }
        else if (this.TipoCMP  == 'Salud Protegida')
        {
            query = 'SELECT APELLIDO_PROSPECTO__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c, INTERMEDIARIO_POLIZA__c, Id, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c , ErrorDetalle__c FROM Registro_Carga_Televenta__c  WHERE ErrorCarga__c = true AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
        }

        system.debug('@@@@  query --> '+ query);
        List<Registro_Carga_Televenta__c> lista = Database.query(query);

        return lista;
    }
}