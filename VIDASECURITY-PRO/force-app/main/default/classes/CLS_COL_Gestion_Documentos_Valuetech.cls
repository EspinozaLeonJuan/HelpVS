/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-06-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_COL_Gestion_Documentos_Valuetech {
    //TOKEN
    //PARAMETROS QA
    // private static String userName = 'admin';
    // private static String password = '123456';
    // private static String urlToken = 'https://vidasecuritytest.valueweb.cl/vwnetx_VidaSecurity_WSReembolso/api/login/authenticate';
    //PARAMETROS QA

     //PARAMETROS PRODUCCION
    private static String userName = 'vsintapp';
    private static String password = 'bWPJbB@08OZM';
    private static String urlToken = 'https://kta.vidasecurity.cl/vwnetx_VidaSecurity_WSReembolso/api/login/authenticate';
    //PARAMETROS PRODUCCION


    public static String getToken() {
        HttpRequest req = new HttpRequest();
        String body = '{UserName:"'+userName+'",Password:"'+password+'"}';

        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('ClientId', 'vt-vidasecurity');
        req.setEndpoint(urlToken);
        req.setBody(body);

        String token = '';

        Http http = new Http();
        try{
            req.setTimeout(20000);
            HTTPResponse res = http.send(req);

            System.debug('este es el body '+res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());
             String r = CLS_COL_Response_Token_VT.parse(res.getBody());
             token = r;
            //token = res.getBody();
        }
        catch(Exception e){
            System.debug(e.getMessage());
            return 'ERROR';
        }

        return token;
    }

    //PARAMETROS PRODUCCION
    private static String urlUploadDoc = 'https://kta.vidasecurity.cl/vwnetx_VidaSecurity_WSReembolso/api/solicitud/Denuncio';
    //PARAMETROS PRODUCCION

    //PARAMETROS QA
    //private static String urlUploadDoc = 'https://vidasecuritytest.valueweb.cl/vwnetx_VidaSecurity_WSReembolso/api/solicitud/Denuncio';
    //PARAMETROS QA

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

    public static Integer SendDocuments(String idMessage, String numeroDenuncio, String remesa,  String fecha)
    {
        List<String> base64IMG = new List<String>();
        List<String> ExtesionImg = new List<String>();
        Set<Id> contentIds = new Set<Id>();

        Gastos gastos = new Gastos();
        DocAdicionales documentosAdicional = new DocAdicionales();
        DocDiagnostico Diagnostico = new DocDiagnostico();

        List<DocDiagnostico> listDiagnostico = new List<DocDiagnostico>();
        List<DocAdicionales> listDoc = new List<DocAdicionales>();
        List<Gastos> listGastos = new List<Gastos>();

        listDiagnostico.add(Diagnostico);

        Integer IdSolicitud = 0, contad = 0;

        List<ContentDocumentLink> contDocumentList = [SELECT ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.LatestPublishedVersion.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: idMessage];

        try
        {
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

            gastos.IDPrestacion = '3';
            gastos.Fecha = fecha;
            gastos.IdTipoDoc = '11';
            gastos.RutPrestador = '1-9';
            gastos.Extension = ExtesionImg[0];
            gastos.Base64 = base64IMG[0];
            gastos.OrigenImagen = 'camara';
            gastos.Diagnostico = 'Diagnostico';//''
            gastos.Folio = '12345';//QA
            gastos.DiagnosticoFecha = fecha;//Datetime.now()//QA
            gastos.DiagnosticoMonto = '1';//QA
            gastos.IdSolicitud = '0';//QA
            gastos.MontoDocumento  = '12345';
            gastos.DocDiagnostico = listDiagnostico;
            gastos.DocAdicionales = listDoc;
            listGastos.add(gastos);

            //Llamar al servicio Valuetech
        	JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CodCobertura', '0063');
            gen.writeStringField('FechaDenuncia', fecha);
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
            gen.writeStringField('FolioDenuncio', numeroDenuncio);
			gen.writeObjectField('Gastos', listGastos);
            gen.writeEndObject();

            String token = getToken();
            System.debug('token---> ' + token);
            String jsonData = gen.getAsString();
            System.debug('jsonData---> ' + jsonData);

            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('ClientId', 'vt-vidasecurity');
            req.setBody(jsonData);
			req.setEndpoint(urlUploadDoc);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
            	Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                IdSolicitud = (Integer) result.get('IdSolicitud');
                Boolean  Exito = (Boolean) result.get('Exito');

                System.debug('Ext ' + Exito);
                System.debug('Aqui IdSolicitud ' + IdSolicitud);

            }else{
                System.debug('Error'+ res.getStatus());

            }
        }
        catch(Exception ex)
        {
            IdSolicitud = 0;
        }

        return IdSolicitud;
    }


    public static Integer SendDocuments(String idMessage)
    {
        List<String> base64IMG = new List<String>();
        List<String> ExtesionImg = new List<String>();
        Set<Id> contentIds = new Set<Id>();

        Gastos gastos = new Gastos();
        DocAdicionales documentosAdicional = new DocAdicionales();
        DocDiagnostico Diagnostico = new DocDiagnostico();

        List<DocDiagnostico> listDiagnostico = new List<DocDiagnostico>();
        List<DocAdicionales> listDoc = new List<DocAdicionales>();
        List<Gastos> listGastos = new List<Gastos>();

        listDiagnostico.add(Diagnostico);

        Integer IdSolicitud = 0, contad = 0;

        MessagingSession MS = [SELECT Id, Name, CreatedDate, StartTime, EndTime, Status, AgentType, CaseId,  Origin, Contacto__c, OwnerId, Vass_Apellido_CargaTitular__c, Vass_Asunto__c, Vass_Comentario__c, Vass_Denuncio_OK__c, Vass_Negocio__c, Vass_Nombre_Carga_Titular__c, Vass_Nombre_Completo_Carga_Titular__c, Vass_Nro_Poliza__c, Vass_PolizaColectivo__c, Vass_Poliza__c, Vass_Prestacion__c, Vass_RUT_CargaTitular__c, Vass_Remesa__c, consultas_asegurados_colectivos__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c FROM MessagingSession WHERE Id =: idMessage];

        List<ContentDocumentLink> contDocumentList = [SELECT ContentDocument.LatestPublishedVersion.VersionData, ContentDocument.LatestPublishedVersion.FileType FROM ContentDocumentLink WHERE LinkedEntityId =: idMessage];

        try
        {
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

            String fecha = String.valueOf(MS.StartTime);

            gastos.IDPrestacion = '3';
            gastos.Fecha = fecha;
            gastos.IdTipoDoc = '11';
            gastos.RutPrestador = '1-9';
            gastos.Extension = ExtesionImg[0];
            gastos.Base64 = base64IMG[0];
            gastos.OrigenImagen = 'camara';
            gastos.Diagnostico = 'Diagnostico';//''
            gastos.Folio = '12345';//QA
            gastos.DiagnosticoFecha = fecha;//Datetime.now()//QA
            gastos.DiagnosticoMonto = '1';//QA
            gastos.IdSolicitud = '0';//QA
            gastos.MontoDocumento  = '12345';
            gastos.DocDiagnostico = listDiagnostico;
            gastos.DocAdicionales = listDoc;
            listGastos.add(gastos);

            //Llamar al servicio Valuetech
        	JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('CodCobertura', '0063');
            gen.writeStringField('FechaDenuncia', fecha);
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
            gen.writeStringField('Remesa', MS.Vass_Remesa__c);
            gen.writeStringField('FolioDenuncio', MS.Numero_Denuncio__c);
			gen.writeObjectField('Gastos', listGastos);
            gen.writeEndObject();

            String token = getToken();
            System.debug('token---> ' + token);
            String jsonData = gen.getAsString();
            System.debug('jsonData---> ' + jsonData);

            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('ClientId', 'vt-vidasecurity');
            req.setBody(jsonData);
			req.setEndpoint(urlUploadDoc);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
            	Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                IdSolicitud = (Integer) result.get('IdSolicitud');
                Boolean  Exito = (Boolean) result.get('Exito');

                System.debug('Ext ' + Exito);
                System.debug('Aqui IdSolicitud ' + IdSolicitud);

            }else{
                System.debug('Error'+ res.getStatus());

            }
        }
        catch(Exception ex)
        {
            IdSolicitud = 0;
        }

        return IdSolicitud;
    }

}