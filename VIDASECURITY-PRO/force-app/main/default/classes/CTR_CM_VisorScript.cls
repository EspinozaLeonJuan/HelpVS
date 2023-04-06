/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
public class CTR_CM_VisorScript {
    
    public String Script {get; set;}   
     
    public String nombreContratante {get; set;}
	public String nombreAsegurado {get; set;}
    public String nombreEjecutiva {get; set;}
    public String cobertura  {get; set;}
    public String nombreProducto {get; set;}
    public String capitalHasta {get; set;}
    public String capitalHasta76 {get; set;}
    public String precioMensualUF {get; set;}
    public String precioMensualCLP {get; set;}
    public String capitalPrimaAdic {get; set;}
    public String fechaExluido {get; set;}
    public String fechaRegir {get; set;}
    
    public String nombreGrabacion {get; set;}
    public String capitalEquivalente {get; set;}
    public String fechaContratacion {get; set;}
    
    public String fechaContratacion_sinAgno {get; set;}
    public String fechaContratacion_Agno {get; set;}
    
    public String capitalHasta_Cert {get; set;}    
    public String deducible_Cert {get; set;}
    public String fechaInicioVigencia {get; set;}
    
    public String Tipo {get; set;}
    
    public PageReference iniciaVisorScript()
    {
        String Id = apexpages.currentpage().getparameters().get('Id'); 
        
        Lead prospecto = [SELECT Id, Name, Cuenta__c, Status FROM Lead WHERE Id =: Id];
        
        if (prospecto.Status == 'Asegurado Contactado' || prospecto.Status == 'Asegurado No Contactado')
        {
            this.Tipo = 'A';
        }
        else  if (prospecto.Status == 'Contratante Contactado' || prospecto.Status == 'Contratante No Contactado')
        {
            this.Tipo = 'C';
        }
        else {
            this.Tipo = '';
        }
        
        if (String.isNotBlank(prospecto.Cuenta__c))
        {
            Account cuenta = [SELECT Id, Name FROM Account WHERE Id =: prospecto.Cuenta__c];
            this.nombreContratante = cuenta.Name;
        }
        
        this.nombreAsegurado = prospecto.Name;
        this.nombreEjecutiva = [SELECT Name FROM User WHERE Id =: UserInfo.getUserId()].Name;
        this.cobertura = 'XXXXXX';
        this.nombreProducto = 'XXXXXX';
        
        this.capitalHasta = 'XXXXXX';
        this.capitalHasta76 = 'XXXXXX';
        this.precioMensualUF = 'XXXXXX';
        this.precioMensualCLP = 'XXXXXX';
        this.capitalPrimaAdic = 'XXXXXX';
        this.fechaExluido = 'XXXXXX';
        this.fechaRegir = 'XXXXXX';
        this.nombreGrabacion = 'XXXXXX';
        this.capitalEquivalente = 'XXXXXX';
        this.capitalEquivalente = 'XXXXXX';
        this.fechaContratacion = 'XXXXXX';
        this.fechaContratacion_sinAgno = 'XXXXXX';
        this.fechaContratacion_Agno = 'XXXXXX';
        
        this.capitalHasta_Cert = 'XXXXXX';
        this.deducible_Cert = 'XXXXXX';
        this.fechaInicioVigencia = 'XXXXXX';
           
        return null;
    }
}