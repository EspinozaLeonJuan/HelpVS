/**
 * @File Name          : CLS_CS_UploadValuetech.cls
 * @Description        :
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              :
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 01-17-2022
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    4/14/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class CLS_CS_UploadValuetech {
    public class UploadResult
    {
        public Boolean Result {get; set;}

        public String Message {get; set;}
    }

    public class UploadValuetech
    {
        public String Id {get; set;}

        public Transient blob FileBody {get; set;}

        public String Extension {get; set;}

        public String TipoDocumento {get; set;}

        public String fileName {get; set;}

        public String Archivador {get; set;}//Negocio

        /*public String RutContratante {get; set;}

        public String NombreContratante {get; set;}

        public String Poliza {get; set;}

        public String Propuesta {get; set;}*/

        public Boolean EscritorioDigital {get; set;}

        public String Documento {get; set;}

        public String CodigoAdjunto {get; set;}

        public Boolean Obligatorio {get; set;}

        public Upload_Rentas_Vitalicias Rentas_Vitalicias {get; set;}

        public Upload_Seguros_Individuales Seguros_Individuales {get; set;}

        public Upload_Seguros_Colectivos Seguros_Colectivos {get; set;}

        public Upload_Creditos Creditos {get; set;}

        public String NumeroCaso {get; set;}//Negocio
    }

    public class Upload_Rentas_Vitalicias
    {
        public String Empresa  {get; set;}
        public String RutEmpresa  {get; set;}
        public String Poliza {get; set;}
        public String RutContratante {get; set;}
        public String NombreContrata {get; set;}
        public String TipoDocumento {get; set;}
        public String FamiliaDocumento {get; set;}
        public String RutCausante {get; set;}
        public String Agno {get; set;}
        public String Periodo {get; set;}
        public String Sielaf {get; set;}
        public String CodigoTipoDocumento {get; set;}
        public String FechaDocumento {get; set;}
        public String FolioDocumento {get; set;}
    }

    public class Upload_Seguros_Individuales
    {
        public String Empresa  {get; set;}
        public String Propuesta  {get; set;}
        public String Poliza  {get; set;}
        public String TipoDocumento  {get; set;}
        public String RutAsegurado  {get; set;}
        public String NombreContratante  {get; set;}
        public String Siniestro  {get; set;}
        public String EnviaAcsel  {get; set;}
    }

    public class Upload_Seguros_Colectivos
    {
        public String NombreCompagnia  {get; set;}
        public String RutEmpresa  {get; set;}
        public String NombreEmpresa  {get; set;}
        public String RutTitular  {get; set;}
        public String NombreTitular  {get; set;}
        public String FechaRecepcion  {get; set;}
        public String TipoDocumento  {get; set;}
        public String Siniestro  {get; set;}
        public String NumeroLote  {get; set;}
        public String NumeroSolicitud  {get; set;}
        public String Poliza  {get; set;}
    }

    public class Upload_Creditos
    {
        public String Pagare  {get; set;}
        public String Empresa  {get; set;}
        public String RutEmpresa  {get; set;}
        public String Poliza  {get; set;}
        public String RutContratante  {get; set;}
        public String NombreContrata  {get; set;}
        public String TipoDocumento  {get; set;}
        public String FamiliaDocumento  {get; set;}
    }

    public CLS_CS_UploadValuetech() {

    }

    private static String GetXml(UploadValuetech upload)
    {
        String inicio = '<IndexList>';
        String fin = '</IndexList>';
        String XmlOutput = '';


        if (upload.Archivador == 'Rentas Vitalicias')
        {
            if (upload.Rentas_Vitalicias != null)
            {
                Date today = Date.Today();
                upload.Rentas_Vitalicias.FechaDocumento = today.day()+'-'+today.month()+'-'+today.year();
                upload.Rentas_Vitalicias.FolioDocumento = '';
                upload.Rentas_Vitalicias.Agno = String.valueOf(today.year());

                String Empresa = '<Index Value="'+upload.Rentas_Vitalicias.Empresa+'" Label="Empresa" />';
                String Poliza = '<Index Value="'+upload.Rentas_Vitalicias.Poliza+'" Label="POLIZA" />';
                String Agno = '<Index Value="'+upload.Rentas_Vitalicias.Agno+'" Label="ANO" />';
                String Periodo = '<Index Value="'+upload.Rentas_Vitalicias.Periodo+'" Label="PERIODO" />';

                if (String.isBlank(upload.Rentas_Vitalicias.Periodo))
                {
                    Periodo = '';
                }

                String Sielaf = '<Index Value="'+upload.Rentas_Vitalicias.Sielaf+'" Label="SIELAF" />';//revisar con ed

                if (String.isBlank(upload.Rentas_Vitalicias.Sielaf))
                {
                    Sielaf = '';
                }

                String RutEmpresa = '<Index Value="'+upload.Rentas_Vitalicias.RutEmpresa+'" Label="RUT EMPRESA" />';//PROD
                String RutContratante = '<Index Value="'+upload.Rentas_Vitalicias.RutContratante+'" Label="RUT CONTRATANTE" />'; //PROD
                String NombreContrata = '<Index Value="'+upload.Rentas_Vitalicias.NombreContrata+'" Label="NOMBRE CONTRATA" />';//PROD
                String TipoDocumento = '<Index Value="'+upload.Rentas_Vitalicias.TipoDocumento+'" Label="TIPO DOCUMENTO" />';//PROD
                String FamiliaDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FamiliaDocumento+'" Label="FAMILIA DOCUMENTO" />';//PROD
                String RutCausante = '<Index Value="'+upload.Rentas_Vitalicias.RutCausante+'" Label="RUT CAUSANTE" />';//PROD --validar **
                String CodigoTipoDocumento = '<Index Value="'+upload.Rentas_Vitalicias.CodigoTipoDocumento+'" Label="CODIGOTIPODOCUMENTO" />';//PROD
                String FechaDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FechaDocumento+'" Label="Fecha Documento" />';//PROD
                String FolioDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FolioDocumento+'" Label="Folio Documento" />';//PROD
                String Caja = '<Index Value="'+upload.NumeroCaso+'" Label="CAJA" />';//PROD
                //String RutEmpresa = '<Index Value="'+upload.Rentas_Vitalicias.RutEmpresa+'" Label="RUTEMPRESA" />';//QA
                //String RutContratante = '<Index Value="'+upload.Rentas_Vitalicias.RutContratante+'" Label="RUTCONTRATANTE" />'; //QA
                //String NombreContrata = '<Index Value="'+upload.Rentas_Vitalicias.NombreContrata+'" Label="NOMBRECONTRATANTE" />';//QA
                //String TipoDocumento = '<Index Value="'+upload.Rentas_Vitalicias.TipoDocumento+'" Label="TIPODOCUMENTO" />';//QA
                //String FamiliaDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FamiliaDocumento+'" Label="FAMILIADOCUMENTO" />';//QA
                //String RutCausante = '<Index Value="'+upload.Rentas_Vitalicias.RutCausante+'" Label="RUTCAUSANTE" />';//QA
                //String CodigoTipoDocumento = '<Index Value="'+upload.Rentas_Vitalicias.CodigoTipoDocumento+'" Label="CODIGOINTERNOTIPODOCUMENTO" />';//QA
                //String FechaDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FechaDocumento+'" Label="FECHADOCUMENTO" />';//QA
                //String FolioDocumento = '<Index Value="'+upload.Rentas_Vitalicias.FolioDocumento+'" Label="FOLIODOCUMENTO" />';//QA

                if (String.isBlank(upload.Rentas_Vitalicias.FolioDocumento))
                {
                    FolioDocumento = '';
                }

                XmlOutput = inicio + Empresa + RutEmpresa + Poliza + RutContratante + NombreContrata + TipoDocumento + FamiliaDocumento + RutCausante +
                            Agno + Periodo + Sielaf + CodigoTipoDocumento + FechaDocumento + FolioDocumento + Caja + fin;
            }
        }
        else   if (upload.Archivador == 'Seguros Individuales')
        {
            String Empresa = '<Index Value="'+upload.Seguros_Individuales.Empresa+'" Label="Empresa" />';
            String Propuesta = '<Index Value="'+upload.Seguros_Individuales.Propuesta+'" Label="Propuesta" />';
            String TipoDocumento = '<Index Value="'+upload.Seguros_Individuales.TipoDocumento+'" Label="Tipo de Documento" />';
            String RutAsegurado = '<Index Value="'+upload.Seguros_Individuales.RutAsegurado+'" Label="Rut Asegurado" />';
            String NombreContratante = '<Index Value="'+upload.Seguros_Individuales.NombreContratante+'" Label="Nombre Contratante" />';
            String Siniestro = '<Index Value="'+upload.Seguros_Individuales.Siniestro+'" Label="Siniestro" />';
            String EnviaAcsel = '<Index Value="'+upload.Seguros_Individuales.EnviaAcsel+'" Label="EnviaAcsel" />';

            String Poliza = '<Index Value="'+upload.Seguros_Individuales.Poliza+'" Label="Póliza" />';//PROD
            String Caja = '<Index Value="'+upload.NumeroCaso+'" Label="CAJA" />';//PROD

            //String Poliza = '<Index Value="'+upload.Seguros_Individuales.Poliza+'" Label="POLIZA" />';//QA

            XmlOutput = inicio + Empresa + Propuesta + Poliza + TipoDocumento + RutAsegurado + NombreContratante + Siniestro + EnviaAcsel + Caja + fin;
        }
        else   if (upload.Archivador == 'Créditos')
        {
            upload.Creditos.Pagare = '';
            String Pagare = '<Index Value="'+upload.Creditos.Pagare+'" Label="PAGARE" />';
            String Empresa = '<Index Value="'+upload.Creditos.Empresa+'" Label="EMPRESA" />';
            String RutEmpresa = '<Index Value="'+upload.Creditos.RutEmpresa+'" Label="RUT EMPRESA" />';
            String Poliza = '<Index Value="'+upload.Creditos.Poliza+'" Label="POLIZA" />';
            String TipoDocumento = '<Index Value="'+upload.Creditos.TipoDocumento+'" Label="TIPO DOCUMENTO" />';
            String FamiliaDocumento = '<Index Value="'+upload.Creditos.FamiliaDocumento+'" Label="FAMILIA DOCUMENTO" />';

            String RutContratante = '<Index Value="'+upload.Creditos.RutContratante+'" Label="RUT CONTRATANTE" />';//PROD
            String NombreContrata = '<Index Value="'+upload.Creditos.NombreContrata+'" Label="NOMBRE CONTRATA" />';//PROD

            String Caja = '<Index Value="'+upload.NumeroCaso+'" Label="CAJA" />';//PROD


            //String RutContratante = '<Index Value="'+upload.Creditos.RutContratante+'" Label="RUTCONTRATANTE" />';//QA
            //String NombreContrata = '<Index Value="'+upload.Creditos.NombreContrata+'" Label="NOMBRECONTRATANTE" />';//QA

            XmlOutput = inicio + Pagare + Empresa + RutEmpresa + Poliza + RutContratante + NombreContrata + TipoDocumento +
                            FamiliaDocumento + Caja + fin;
        }
        else   if (upload.Archivador == 'Seguros Colectivos')
        {
            String NombreCompagnia = '<Index Value="'+upload.Seguros_Colectivos.NombreCompagnia+'" Label="Nombre Compañia" />';
            String RutEmpresa = '<Index Value="'+upload.Seguros_Colectivos.RutEmpresa+'" Label="RUT Empresa" />';
            String NombreEmpresa = '<Index Value="'+upload.Seguros_Colectivos.NombreEmpresa+'" Label="Nombre Empresa" />';
            String RutTitular = '<Index Value="'+upload.Seguros_Colectivos.RutTitular+'" Label="RUT Titular" />';
            String NombreRutTitular = '<Index Value="'+upload.Seguros_Colectivos.NombreTitular+'" Label="Nombre Titular" />';
            String FechaRecepcion = '<Index Value="'+upload.Seguros_Colectivos.FechaRecepcion+'" Label="Fecha Recepción" />';
            String TipoDocumento = '<Index Value="'+upload.Seguros_Colectivos.TipoDocumento+'" Label="Tipo de Documento" />';

            String Siniestro = '';
            if (String.isNotBlank(upload.Seguros_Colectivos.Siniestro))
            {
                Siniestro = '<Index Value="'+upload.Seguros_Colectivos.Siniestro+'" Label="SINIESTRO" />';
            }

            String NumeroLote = '';
            if (String.isNotBlank(upload.Seguros_Colectivos.NumeroLote))
            {
                NumeroLote = '<Index Value="'+upload.Seguros_Colectivos.NumeroLote+'" Label="N° Lote VidaSecurity" />';
            }

            String NumeroSolicitud = '';
            if (String.isNotBlank(upload.Seguros_Colectivos.NumeroSolicitud))
            {
                NumeroSolicitud = '<Index Value="'+upload.Seguros_Colectivos.NumeroSolicitud+'" Label="N° Solicitud" />';
            }

            String Poliza  = '<Index Value="'+upload.Seguros_Colectivos.Poliza+'" Label="N° Póliza" />';

            String Caja = '<Index Value="'+upload.NumeroCaso+'" Label="CAJA" />';//PROD

            XmlOutput = inicio + NombreCompagnia + RutEmpresa + NombreEmpresa + RutTitular + NombreRutTitular + FechaRecepcion + TipoDocumento +
                            Siniestro + NumeroLote + NumeroSolicitud + Poliza + Caja + fin;
        }

        return XmlOutput;

    }

    private static String GetToken(String id, String archivador)
    {
        Blob targetBlob = Blob.valueOf('V1D4S3CUR1TY' + archivador + id);
        Blob hash = Crypto.generateDigest('MD5', targetBlob);
        String token = EncodingUtil.convertToHex(hash);
        return token;
    }

    public static UploadResult Upload(UploadValuetech upload) {
        system.debug('@@@@ Upload');

        UploadResult result = new UploadResult();

        try
        {
            system.debug('@@@@ Upload size ' + upload.FileBody.size());

            String token = GetToken(upload.Id, upload.Archivador);

            String content = EncodingUtil.base64Encode(upload.FileBody);

            String xmlIndex = GetXml(upload);// retorna segun tipo de Archivador y parametros ingresados

            system.debug('@@@@ token '+ token);
            system.debug('@@@@ idTransaccion '+ upload.Id);

            system.debug('@@@@ xmlIndex '+xmlIndex);

            EXT_WS_Valuetech.AgregarDocumentoReturn retorno = new EXT_WS_Valuetech.AgregarDocumentoReturn();

            if (!Test.isRunningTest())
            {
                system.debug('@@@@ upload.Extension '+ upload.Extension);
                EXT_WS_Valuetech.WSDWIntegrationSoap WS = new EXT_WS_Valuetech.WSDWIntegrationSoap();
                if ( upload.FileBody.size() < 4400000 ) { // soporta hasta 4.4 MB Técnicamente
                  retorno = WS.AgregarDocumento(token, upload.Id, upload.Archivador, content, xmlIndex, upload.Extension);
                } else if ( upload.FileBody.size() < 8900000 ) { // soporta hasta 8.7 MB Técnicamente
                  WebServiceValuetechFuture.WebServiceValuetechFuture(token, upload.Id, upload.Archivador, content, xmlIndex, upload.Extension, upload.fileName, upload.CodigoAdjunto, upload.Documento);
                } 
            }
            else
            {
                retorno.Code = 0;
            }

            system.debug('@@@@ retorno' + retorno);
            String FileNameNew = upload.fileName.abbreviate(255);

            if (retorno.Code == 0 )
            {
                Long idDoc = retorno.DWDocID;
                Adjunto__c adjunto = new Adjunto__c();
                system.debug('@@@@ Caso Id --> '+ upload.Id);
                adjunto.IdCaso__c  = upload.Id;

                adjunto.Codigo_Adjunto__c =  upload.CodigoAdjunto;
                adjunto.File_Name__c =  FileNameNew;
                //adjunto.Obligatorio__c = upload.Obligatorio;
                adjunto.Nombre_Documento__c = upload.Documento;
                //adjunto.Tipo_Documento__c = upload.TipoDocumento;
                adjunto.Id_Retorno__c = String.valueOf(idDoc);
                adjunto.Xml__c = xmlIndex;
                //adjunto.Nombre_Imagen__c = upload.NombreImagen;
                adjunto.UrlDoc__c = retorno.Url;
                if (!Test.isRunningTest())
                {
                    system.debug('@@@@ adjunto --> '+adjunto);
                    insert adjunto;
                }

                result.Result =  true;
                result.Message = 'Ha sido agregado al Repositorio de Documentos un nuevo documento adjunto asociado al Caso relacionado.';
            }
            else
            {
              if ( upload.FileBody.size() < 4400000 ) { // soporta hasta 4.4 MB Técnicamente
                result.Result = false;
                result.Message = 'Ha ocurrido un Error al intentar realizar la carga del archivo al Repositorio de Documentos.';
              } else if ( upload.FileBody.size() < 8900000 ) { // soporta hasta 8.7 MB Técnicamente
                result.Result = true;
                result.Message = 'El archivo tiene un peso mayor a 4.3MB, por lo tanto será cargado en un tiempo posterior (1min aprox.)';
              } else {
                result.Result = false;
                result.Message = 'Archivo no cargado: Sólo se pueden cargar archivos de hasta 8.5 MB. ';
              }
            }

        } catch(Exception ex) {
			//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getlineNumber()+' '+ex.getMessage()));
            system.debug('@@@@' + ex.getlineNumber()+' '+ex.getMessage());
            result.Result = false;
            result.Message = 'Ha ocurrido un error al realizar la carga.';
		}

        return result;
    }
}