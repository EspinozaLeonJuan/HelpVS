/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-10-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class EBV_GestorDocumental {
    public class Input{
        @InvocableVariable(required = True)
        public String remitt;
        @InvocableVariable(required=True)
        public String numR;
         @InvocableVariable(required=True)
        public String idMessaging;
        @InvocableVariable(required=True)
        public String token;
    }
    public class Output {
   	   	@InvocableVariable(required=true)
       	public boolean exito;
        @InvocableVariable(required=true)
       	public Integer IdSolicitud;
  	}


    //Body Servicio
    public class DocDiagnostico {
		public String Extension = 'jpg';
		public String Base64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxIPEhUPEhIVFRUVFxcVFRUVFxcVFRUVFRgXFhUVFRUYHSggGBolHRUXITEhJSkrLi4uGB8zODMtNygtLisBCgoKDQ0NDg0NDi0ZFRktKysrKy0rKysrLSstKysrKzc3Lis3KzIrNysrKysrKys3KysrKysrKy0uKzcrMjIrK//AABEIALcBEwMBIgACEQEDEQH/xAAZAAEBAQEBAQAAAAAAAAAAAAAAAQMCBwT/xAAeEAEBAAMBAQADAQAAAAAAAAAAAQIR8DFBcYGxIf/EABUBAQEAAAAAAAAAAAAAAAAAAAAB/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A9r0mlQBdGgEFARUUEBQQFBBQEsNACCgENACLoARUqgipVAiABsCiAaQFTalB9AArEEBQAQAAUBFAAADYACBQWoqAQAAAACgAoIB39BIKCIKAlFQG4sBWKLvu7/ADu74ACQUAAAAAKAAACKgAAKioAKgAVQRUUEAAlSqAIqCKCUG8CArJFL3d4AAAAAEIAAAAAAAigCLUBUUBFEBagoIaAADYAAgUAKBYDaBiCsgAKEAAAAAAAAAAAAQFqKgKCAKAAACCgIKAIABAQABtiEBWQAAAAAAEAAAoAAAAAFEAURdAAAENAAaAAAQAAFBDQA2x8DDxAZhACAAB3d8AAAAAAAAAAAQAFRQEFIABARQBFAEigCRUgClEBtj4Jh4AzKd3fEBQ7u+gAAAAAEAoKCAAbA2CCgIbUAiKAAkBQAAAAARU/SggpQaYeBh4AzgAAACKAAAAABfyAAAAACAKIAoAENAAAAAAEARUUBFgDvDwMQHECAAQAAAAAAAAAAAAAAAAAAASKAAAigCKAIqKIACu8fAxAZwJ3d6AokAUACAAoIBQUEBQQAAABFAAAAIAAAAAAAAAEAdSiAiQAAAUFAQUBBQEAAFAQAAAAAA0AAoCCgIKAmhQHK7ABNqAbAEf/9k=';
        public String OrigenImagen = 'camara';
	}
	public class DocAdicionales {
		public String Extension;
		public String Base64;
		public String OrigenImagen;
	}
	public class Gastos {
		public String IDPrestacion;
		public String Fecha;
		public String IdTipoDoc;
		public String RutPrestador;
		public String Extension;
		public String Base64;
		public String OrigenImagen;
		public String Diagnostico;
        public String MontoDocumento;
		public List<DocDiagnostico> DocDiagnostico;
		public List<DocAdicionales> DocAdicionales;

        public String Folio;//QA
        public String DiagnosticoFecha;//QA
        public String DiagnosticoMonto;//QA
        public String IdSolicitud;//QA

	}

    @InvocableMethod(label='EBV Enviar documentos')
    Public static List<Output> EnviarDocumentos(List<Input> Inputs){
        //Listas
        List<Output> statusServicio = new List<Output>();
        List<DocDiagnostico> listDiagnostico = new List<DocDiagnostico>();
        List<DocAdicionales> listDoc = new List<DocAdicionales>();
        List<Gastos> listGastos = new List<Gastos>();
        List<String> base64IMG = new List<String>();
        List<String> ExtesionImg = new List<String>();
        //List<ContentDocumentLink> contDocumentList = new List<String>();
        //Id's
        Set<Id> contentIds = new Set<Id>();
        //Clases
        DocDiagnostico Diagnostico = new DocDiagnostico();
        DocAdicionales documentosAdicional = new DocAdicionales();
        Gastos gastoss = new Gastos();
        //Variables
        String remesa;
        String numR;
        String idmensaje;
        Integer contad = 0;
        Integer IdSolicitud;
        Boolean exito;
        String token;

        //Variables para body
        String dates = string.valueOfGmt(System.today());


        for(Input rutInput :Inputs){
            remesa = rutInput.remitt;
            System.debug('Aqui rut ' + rutInput.idMessaging);
            numR = rutInput.numR;
            idmensaje= rutInput.idMessaging;
            Token = rutInput.token;
        }

        List<ContentDocumentLink> contDocumentList = [SELECT ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.LatestPublishedVersion.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: idmensaje];
        listDiagnostico.add(Diagnostico);
        Try
        {
            //Parsear documento a BASE64
            for (ContentDocumentLink cont :contDocumentList) {
                contentIds.add(cont.Id);
                Blob actual = cont.ContentDocument.LatestPublishedVersion.VersionData;
                string base64 = EncodingUtil.base64Encode(actual);
                base64IMG.add(base64);
                String ext = cont.ContentDocument.LatestPublishedVersion.FileType;
                ExtesionImg.add(ext);

            }
            System.debug('Lista de IDs: '+contentIds);
            System.debug('Lista de Extenciones: '+ExtesionImg);
            System.debug('lista de 64 '+base64IMG.size());

            //Creacion de las listas con documentos para servicio
            If(base64IMG.size() >= 2){
                for(String contImg : base64IMG){
                    if(contad>0){
                        documentosAdicional.Extension = ExtesionImg[contad];
                        documentosAdicional.Base64 = base64IMG[contad];
                        documentosAdicional.OrigenImagen= 'camara';
                        listDoc.add(documentosAdicional);
                    }
                    contad++;
                }

            }
            gastoss.IDPrestacion = '3';
            gastoss.Fecha = string.valueOfGmt(System.today());
            gastoss.IdTipoDoc = '11';
            gastoss.RutPrestador = '1-9';
            gastoss.Extension = ExtesionImg[0];
            gastoss.Base64 = base64IMG[0];
            gastoss.OrigenImagen = 'camara';

            gastoss.Diagnostico = 'Diagnostico';//''
            gastoss.Folio = '12345';//QA
            gastoss.DiagnosticoFecha = string.valueOfGmt(System.today());
            gastoss.DiagnosticoMonto = '1';//QA
            gastoss.IdSolicitud = '0';//QA

            gastoss.MontoDocumento  = '12345';
            gastoss.DocDiagnostico = listDiagnostico;
            gastoss.DocAdicionales = listDoc;
            listGastos.add(gastoss);

        //Llamar al servicio Valuetech
        	JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CodCobertura', '0063');
            gen.writeStringField('FechaDenuncia', dates);
            gen.writeStringField('RutTitular', '11111111');
            gen.writeStringField('DVRutTitular', '1');
            gen.writeStringField('RutBeneficiario', '11111111');
            gen.writeStringField('DVRutBeneficiario', '1');
            gen.writeStringField('NombresBeneficiario', 'Usuario Whatsapp');
            gen.writeStringField('ApellidosBeneficiario', 'Usuario Whatsapp');
            gen.writeStringField('MailCliente', 'aaaa@aa.aa');
            gen.writeStringField('IDIsapre', '200');
            gen.writeStringField('ValorUF', '1');
            gen.writeStringField('TopeUF', '1');
            gen.writeStringField('Plataforma', 'MOVIL');
            gen.writeStringField('SistemaOperativo', 'Otros');
            gen.writeStringField('NombresTitular', 'Usuario Whatsapp');
            gen.writeStringField('ApellidosTitular', 'Usuario Whatsapp');
            gen.writeStringField('RutEmpresa', '99301000-6');
            gen.writeStringField('Remesa', remesa);
            gen.writeStringField('FolioDenuncio', numR);
			gen.writeObjectField('Gastos', listGastos);
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            System.debug('jsonData---> ' + jsonData);

            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('ClientId', 'vt-vidasecurity');
            req.setEndpoint('https://kta.vidasecurity.cl/vwnetx_VidaSecurity_WSReembolso/api/solicitud/Denuncio');
            req.setBody(jsonData);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
            	Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                IdSolicitud = (Integer) result.get('IdSolicitud');
                Exito = (Boolean) result.get('Exito');

                System.debug('Ext ' + Exito);
                System.debug('Aqui IdSolicitud ' + IdSolicitud);

            }else{
                System.debug('Error'+ res.getStatus());
            }

        }
        catch (Exception ex )
        {
            System.debug( 'EBV_GestorDocumental ' + ex);

        }

        Output out = new Output();
        out.exito = exito;
        out.IdSolicitud = IdSolicitud;
        statusServicio.add(out);


        Return statusServicio;
    }






}