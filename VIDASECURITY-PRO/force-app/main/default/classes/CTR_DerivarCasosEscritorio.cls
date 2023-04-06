/*******************************************************************************************
 *  NOMBRE                 : CTR_DerivarCasosEscritorio
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CTR_DerivarCasosEscritorio {
    
    public Case Caso {get; set;}   
    
    public String  RUTTitular { get; set; }     
    public String  NombreTitular { get; set; }   
	public String  DetalleSolicitud { get; set; }  
    public Integer NumPoliza { get; set; }       
    public String  Poliza { get; set; } 
    public String  NumeroCaso { get; set; } 
    public String IDCASO  { get; set; } 
    public String Error  { get; set; } 
      
    public String EtiquetaSolicitud {get; set;}
    public String Solicitante { get; set; }  
    
    public String IdRequerimiento {get; set;}
    public String TipoRequerimiento { get; set; } 
    
    public String TipoRequerimientoSF { get; set; } 
    
    
    /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference CargaCasoPendiente(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('idCaso');
            String Mensaje = 'Para el Caso a Derivar no existe un Requerimiento de Escritorio Digital asociado.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Mensaje)); 
            
            if(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                    Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Id_Requerimiento_EscritorioDigital__c, Id_Responsable_UR__c, 
                            Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, Tipo_Requerimiento_EscritorioDigital__c
                            FROM Case
                            WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);    
                }
                
                this.RUTTitular = this.Caso.RUT__c;
                this.NombreTitular = this.Caso.Nombre_Completo_Razon_Social__c;            
                this.NumeroCaso = this.Caso.CaseNumber;        
                this.DetalleSolicitud = this.Caso.Detalle_Solicitud__c;        
                 
                if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
                {
                    this.NumPoliza = Integer.valueOf(this.Caso.CASO_Poliza_Asoc__c);
                    this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
                }
                else
                {
                    this.NumPoliza = 0;
                    this.Poliza = 'No seleccionada';
                }
                
                if(this.DetalleSolicitud != null && this.DetalleSolicitud != '')
                {
                    system.debug('@@@@ jCASO => ' + this.Caso);
                    this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.DetalleSolicitud);
                    system.debug('@@@@ EtiquetaSolicitud => ' + EtiquetaSolicitud);
                    
                    if (this.EtiquetaSolicitud == '')
                    {
                        this.EtiquetaSolicitud = this.DetalleSolicitud;
                    }                   
                }
            } 
                return null;
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    


    public void LoadError()
    {
        system.debug('@@@@  this.Error -->'+this.Error);

        if (this.Error == 'PENDIENTE_DOCUMENTOS_VALUETECH')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Existen en Valuetech documentos pendientes asociados al Requerimiento de Escritorio Digital generado para el Caso seleccionado.'));           
        }
        else if (this.Error == 'REQUERIMIENTO_NO_CARGADO_VALUETECH')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'El Requerimiento de Escritorio Digital asociado al Caso no ha sido ingresado en Valuetech.'));           
        }
        else if (this.Error == 'VALUETECH_ERROR')
        { 
            //6 este con mensaje actual , no trae mensaje, co
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));                  
        }
        else if (this.Error == 'CAMBIO_ESTADO_ERROR')
        {
            //-1
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));          
        }
        else if (this.Error == 'RUT_USUARIO_NO_REGISTRADO')
        {
            //1
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'El usuario actual no tiene registrado un RUT válido en Salesforce.'));          
        }       
        else if (this.Error == 'EXCEPCION')
        {
            //-3
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));               
        }
    }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }
    
    public PageReference ToEscritorioDigital()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_ED_Requerimiento?Id='+  this.Caso.Id); 
        return page;
    }
    
    public PageReference ToDerivar()
    {
        Case caso;
        if (!Test.isRunningTest()) 
        {
           caso = [SELECT Id, RecordTypeId, OwnerId, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: IDCASO];
        }
        else
        {
        	Account cuenta = Factory.crearAccountAnonimo();
        	caso = FactoryEscritorio.buildCasoED('Solicitudes',cuenta);    
        }
                
        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
        caso.setOptions(dmo);
        List<Case> lsC = new List<Case>();
        caso.Status = 'Back Office';
        caso.CASO_Deriva_a_UR__c = true;
        lsC.add(caso);
        Database.update(lsC,dmo);
        
        CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
        
        if (caso.Id_Responsable_UR__c == null || caso.Id_Responsable_UR__c == '')
        {                       
            CLAsign.AsignarCaso(caso); 
        }
        else 
        {
            CLAsign.ReasignarCaso(caso.Id);
        }
        
        Case caso2 = new Case();
        if (!Test.isRunningTest()) 
        {
            caso2 = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: caso.Id];
        }
        else
        {
            caso2.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
        }
        
        if(caso2 != null)
        {
            CLS_DerivarCaso_Comun.ValidaPropietarioCaso(caso2);           
        }        

        PageReference detalleCaso = new PageReference('/' + caso.Id);
        detalleCaso.setRedirect(true);
        return detalleCaso;
    }

	public PageReference eliminarRequerimiento()
    {
     	this.Caso.Id_Requerimiento_EscritorioDigital__c = '';
        this.Caso.Tipo_Requerimiento_EscritorioDigital__c = '';
        if (!Test.isRunningTest())
        {
        	Update Caso;    
        }
        return null;
    }

    /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference CargaCasoError(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('idCaso');

            this.Error = apexpages.currentpage().getparameters().get('Error');
            
            if(IDCASO != '')
            {
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                    Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Id_Requerimiento_EscritorioDigital__c, Id_Responsable_UR__c,
                            Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, Tipo_Requerimiento_EscritorioDigital__c, Tipo_de_Requerimiento__c
                            FROM Case
                            WHERE Id =: IDCASO];
                          
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);    
                }

                if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
                {
                    this.NumPoliza = Integer.valueOf(this.Caso.CASO_Poliza_Asoc__c);
                    this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
                }
                else
                {
                    this.NumPoliza = 0;
                    this.Poliza = 'No seleccionada';
                }

                this.NumeroCaso = this.Caso.CaseNumber;
                this.RUTTitular = this.Caso.RUT__c;
                this.NombreTitular = this.Caso.Nombre_Completo_Razon_Social__c;
                this.DetalleSolicitud = this.Caso.Detalle_Solicitud__c;  
                
                this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.DetalleSolicitud);
        
                if (EtiquetaSolicitud == '')
                {
                    this.EtiquetaSolicitud = this.DetalleSolicitud;   
                }
                    
                this.TipoRequerimientoSF = this.Caso.Tipo_de_Requerimiento__c;
        
                if (this.Caso.Id_Requerimiento_EscritorioDigital__c != null && this.Caso.Id_Requerimiento_EscritorioDigital__c != '')
                {
                    this.IdRequerimiento = this.Caso.Id_Requerimiento_EscritorioDigital__c;
                    this.TipoRequerimiento = this.Caso.Tipo_Requerimiento_EscritorioDigital__c;
                    this.Solicitante = CLS_EscritorioDigital_Internal.Solicitante(this.TipoRequerimiento);               
                }
        
                if (!Test.isRunningTest()) 
                { 
                    this.LoadError();
                }
               
            }
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
           
        } 

        return null;
    }
}