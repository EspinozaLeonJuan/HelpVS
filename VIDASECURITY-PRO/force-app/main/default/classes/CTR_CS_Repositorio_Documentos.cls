/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-17-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   12-18-2020   Juan Espinoza León   Initial Version
**/
public with sharing class CTR_CS_Repositorio_Documentos {

    public List<Adjunto__c> LST_Adjuntos {get; set;}
    public List<Adjunto__c> LST_AdjuntosOld {get; set;}
    public String order {get; set;}
    public Boolean isEditable {get; set;}
    public Boolean isAccess {get; set;}

    public CTR_CS_Repositorio_Documentos() {
 
    }

    public String CaseNumber { get; set;}

    public String Id {get; set;}

    public CTR_CS_Repositorio_Documentos(ApexPages.StandardController controller) {
       // controller.addFields(new String[] {'Id', 'Id'});
        Case Caso = (Case)controller.getRecord();
        this.CaseNumber = '';

        Case c = [SELECT Id, CaseNumber, Detalle_Solicitud__c FROM Case WHERE Id =: Caso.Id];

        system.debug('@@@@ c --> '+c);
        if (c.Detalle_Solicitud__c == 'UR - Endoso Anticipo')
        {
            this.CaseNumber = c.CaseNumber;
            system.debug('@@@@  this.CaseNumber --> '+ this.CaseNumber);
        }

        system.debug('@@@@ Caso --> '+Caso);
        
        this.LST_Adjuntos = [SELECT Id, File_Name__c, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c 
                    WHERE IdCaso__c =: Caso.Id ORDER BY CreatedDate ASC];

        this.Id = Caso.Id;
        this.LST_AdjuntosOld = this.LST_Adjuntos; 
        
        Set<String> profiles = new Set<String>{
          '00e0H000001Fa3qQAC', // Responsable UR Lightning - Beneficios
          '00e0H000001FZUlQAO', // Responsable UR Lightning - Cobranza
          '00e0H000001FZUqQAO', // Responsable UR Lightning - Individuales
          '00e0H000001FZUgQAO', // Responsable UR Lightning - RRVV
          '00ei0000000r1FhAAI', // Administrador del sistema
          '00e0H000001e6mzQAA'  // Gestor Funcional
        };

        Id profileId=userinfo.getProfileId();

        this.isAccess = profiles.contains(profileId) ? true : false;

        this.isEditable = true;

    }

    public PageReference guardarEstado() {
      String idAdjunto = ApexPages.currentPage().getParameters().get('idAdjuntos');
      String estado = ApexPages.currentPage().getParameters().get('estadoAdjuntos');
      
      if ( ( estado == 'Nuevo' || estado == '' )  && idAdjunto != null ) {
        Adjunto__c itemUpdate = new Adjunto__c(Id = idAdjunto, Estado__c = 'Abierto');
        update itemUpdate;
        // this.LST_Adjuntos = [SELECT Id, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c WHERE IdCaso__c =: this.Id ORDER BY CreatedDate ASC];
        for ( Adjunto__c item : this.LST_Adjuntos ) {
          if ( item.Id == idAdjunto ) {
            item.Estado__c = 'Abierto';
          }
        }
        this.LST_AdjuntosOld = this.LST_Adjuntos;
      }
    	return null;
  }

  public void editarEstadoBloque() {
    this.isEditable = this.isEditable ? false:true;
  }
  public void cancelarEstadoBloque() {
    this.isEditable = this.isEditable ? false:true;
    this.LST_Adjuntos = [SELECT Id, File_Name__c, Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, Estado__c FROM Adjunto__c WHERE IdCaso__c =: this.Id ORDER BY CreatedDate ASC];
  }
  public void guardarCambios() {
    update this.LST_Adjuntos;
    this.isEditable = this.isEditable ? false:true;
  }
}