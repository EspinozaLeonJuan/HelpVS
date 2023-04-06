public class CLS_ParticipanteCampanaFile {
    transient public Participantes_de_Campa_a__c part { get; set; }
    private Id Id { get; set; }
    transient public Blob Audio { get; set; }
    transient public String NombreArchivo { get; set; }
    transient private String Rut { get; set; }
    transient private String Dv { get; set; }
    private String NombreCliente { get; set; }
    private String RutCliente { get; set; }   

   
    public CLS_ParticipanteCampanaFile(ApexPages.StandardController controller) {
    	part = (Participantes_de_Campa_a__c) controller.getRecord();
        Id = part.Id;
        Rut = [Select RUT_Cliente__c from Participantes_de_Campa_a__c where Id = :Id].RUT_Cliente__c;
        Dv = [Select DV_Clientes__c from Participantes_de_Campa_a__c where Id = :Id].DV_Clientes__c;
        NombreCliente = [Select Nombres_del_Cliente__c from Participantes_de_Campa_a__c where Id = :Id].Nombres_del_Cliente__c;
        if(String.IsBlank(Rut)){
            Rut = [Select RUT_Clientes__c from Participantes_de_Campa_a__c where Id = :Id].RUT_Clientes__c;
           }
        RutCliente = Rut + '-' + Dv;
        
    }
    
    public PageReference Upload() {
        try {
            if (Audio != null) {
                if (Audio.size() > 0 ) {
                    transient Blob targetBlob = Blob.valueOf('V1D4S3CUR1TYVida Sec-Seguro Individual' + Id);
                    transient Blob hash = Crypto.generateDigest('MD5', targetBlob);
                    transient String token = EncodingUtil.convertToHex(hash);
                    transient String idTransaccion = Id;
                    transient String content = EncodingUtil.base64Encode(Audio);
                    transient String xmlIndex = '<IndexList><Index Value="VIDA SECURITY" Label="Empresa" /><Index Value="ENDOSOS" Label="Tipo de Documento" /><Index Value="' + RutCliente + '" Label="RUT Asegurado" /><Index Value="' + NombreCliente + '" Label="Nombre Contratante" /><Index Value="false" Label="EnviaAcsel" /></IndexList>';
                    transient String extension = 'wav';           

                    transient WS_ValueWeb.AgregarDocumentoReturn retorno = ClienteValueWeb.AgregarDocumento(token, idTransaccion, content, xmlIndex, extension);
                    
                    if (retorno.Code == 0 ) {
						Participantes_de_Campa_a__c p = [SELECT Id, Id_Documento_ValueTech__c FROM Participantes_de_Campa_a__c WHERE Id =: Id];
                        Integer idDoc = retorno.DWDocID;
						p.Id_Documento_ValueTech__c = String.valueOf(idDoc);
                        update p;
						PageReference page = new PageReference ('/apex/SEC_VF_ParticipanteCampanaUpOK'); 
						page.setRedirect(true);
						return page;
                    } else {
                        PageReference page = new PageReference ('/apex/SEC_VF_ParticipanteCampanaUpER'); 
                           page.setRedirect(true);
                           return page;                    
                    }
                } else {
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Por favor seleccione un archivo en formato WAV.'));
                    return null; 	
                }
            } else {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Por favor seleccione un archivo en formato WAV.'));
                return null; 	
            }
            
                
        } catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getlineNumber()+' '+ex.getMessage()));
            system.debug('@@@@' + ex.getlineNumber()+' '+ex.getMessage());
			return null; 	
		}
    }
    
    public string Upload2() {
     
            if (Audio != null) {
                if (Audio.size() > 0 ) {
                    transient Blob targetBlob = Blob.valueOf('V1D4S3CUR1TYVida Sec-Seguro Individual' + Id);
                    transient Blob hash = Crypto.generateDigest('MD5', targetBlob);
                    transient String token = EncodingUtil.convertToHex(hash);
                    transient String idTransaccion = Id;
                    transient String content = EncodingUtil.base64Encode(Audio);
                    transient String xmlIndex = '<IndexList><Index Value="VIDA SECURITY" Label="Empresa" /><Index Value="ENDOSOS" Label="Tipo de Documento" /><Index Value="' + RutCliente + '" Label="RUT Asegurado" /><Index Value="Juanito Perez" Label="Nombre Contratante" /><Index Value="false" Label="EnviaAcsel" /></IndexList>';
                    transient String extension = 'wav';
                    
                    return 'ok';

                } else {
                    return 'error';
                }
            } else {
                return 'error';
            }         

    }
}