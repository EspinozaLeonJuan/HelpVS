/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CS_DerivarCaso_Error {
    public CTR_CS_DerivarCaso_Error() {

    } 

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

    public void LoadError()
    {
        system.debug('@@@@  this.Error -->'+this.Error);

        if (this.Error == 'DERIVACION_NO_PERMITIDA')
        {           
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Actualmente no es posible derivar este tipo de Requerimiento.'));          
        }
    }

    /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference CargaCaso(){
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

                if (Test.isRunningTest()) 
                {
                    this.Caso.Id_Requerimiento_EscritorioDigital__c  = '221';
                }

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
            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
           
        } 

        return null;
    }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }
}