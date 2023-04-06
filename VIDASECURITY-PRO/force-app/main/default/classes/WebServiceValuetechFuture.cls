global class WebServiceValuetechFuture {
  @future(callout=true)
  public static void WebServiceValuetechFuture(
    String Token, 
    String IdTransaccion, 
    String Archivador, 
    String Content, 
    String XmlIndex, 
    String Extension, 
    String fileName,
    String CodigoAdjunto,
    String Documento) {
    EXT_WS_Valuetech.AgregarDocumentoReturn retorno = new EXT_WS_Valuetech.AgregarDocumentoReturn();
    EXT_WS_Valuetech.WSDWIntegrationSoap WS = new EXT_WS_Valuetech.WSDWIntegrationSoap();
    if (!Test.isRunningTest())
    {
      retorno = WS.AgregarDocumento(Token, IdTransaccion, Archivador, Content, XmlIndex, Extension);
    }
    String FileNameNew = fileName.abbreviate(255);
    if (retorno.Code == 0 || Test.isRunningTest() )
    {
        Long idDoc = retorno.DWDocID;
        Adjunto__c adjunto = new Adjunto__c();
        system.debug('@@@@ Caso Id --> '+ IdTransaccion);
        adjunto.IdCaso__c  = IdTransaccion;

        adjunto.Codigo_Adjunto__c =  CodigoAdjunto;
        adjunto.File_Name__c =  FileNameNew;
        //adjunto.Obligatorio__c = upload.Obligatorio;
        adjunto.Nombre_Documento__c = Documento;
        //adjunto.Tipo_Documento__c = upload.TipoDocumento;
        adjunto.Id_Retorno__c = String.valueOf(idDoc);
        adjunto.Xml__c = XmlIndex;
        //adjunto.Nombre_Imagen__c = upload.NombreImagen;
        adjunto.UrlDoc__c = retorno.Url;
        if (!Test.isRunningTest())
        {
            system.debug('@@@@ adjunto --> '+adjunto);
            system.debug('limit size : ' + Limits.getHeapSize());
            system.debug('limit limit : ' + Limits.getLimitHeapSize());
            insert adjunto;
        }
    }
  }
}