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
public class CTR_CM_LeadFields {

    public class Data
    {
        public String Field { get;  set; }
        
        public String Value { get;  set; }
    }
        
    
    public  String Id {get; set;}

    public Boolean Cerrado {get; set;}

    public List<Data> getFields()
    { 
        this.Id = apexpages.currentpage().getparameters().get('Id'); 
        
        Lead prospecto = [SELECT Id,  Cobertura__c, Capital_Remanente_Asegurado__c, PROSPE_Carga_Fecha_Inicio_Vigencia__c, Nombre_de_Producto__c, Prima_Nuevo_Producto__c, 
                         Prima_Final_Poliza_Original__c, Exclusiones__c, Status, Sub_Estado__c, Cierre_Administrativo__c, Plan__c FROM Lead WHERE Id =: this.Id];

        system.debug('@@@@ Id  => ' + Id);

        List<Data> lista = new List<Data>();
        
        Data d = new Data();
        d.Field = 'Cobertura original del prospecto';
        d.Value = prospecto.Cobertura__c;
        lista.add(d);
        d = new Data();
        d.Field = 'Capital remanente del prospecto (UF)';
        if (prospecto.Capital_Remanente_Asegurado__c != null)
        {
            d.Value = String.valueOf(prospecto.Capital_Remanente_Asegurado__c.format());
        }
        lista.add(d);

        d = new Data();
        d.Field = 'Exclusiones del prospecto';
        d.Value = prospecto.Exclusiones__c;
        lista.add(d); 

        d = new Data();
        d.Field = 'Producto a contratar para el prospecto';
        d.Value = prospecto.Plan__c;
        lista.add(d);
        
        d = new Data();
        d.Field = 'Fecha de inicio vigencia nuevo producto';
        d.Value = String.valueOf(prospecto.PROSPE_Carga_Fecha_Inicio_Vigencia__c);
        lista.add(d);
        
        d = new Data();
        d.Field = 'Prima nuevo producto (UF)';
        
        if (prospecto.Prima_Nuevo_Producto__c != null)
        {
            d.Value = String.valueOf(prospecto.Prima_Nuevo_Producto__c.format());
        }      
        lista.add(d);
        
        d = new Data();
        d.Field = 'Disminución prima final póliza original (al excluir hijo) (UF)';
         
        if (prospecto.Prima_Final_Poliza_Original__c != null)
        {
            d.Value = String.valueOf(prospecto.Prima_Final_Poliza_Original__c.format());
        }            
        lista.add(d);
        
        if (prospecto.Status == 'Contratante No Contactado' && (prospecto.Sub_Estado__c  == 'Teléfono Malo' || prospecto.Sub_Estado__c  == 'No Contesta, inubicable' ||  prospecto.Sub_Estado__c  == 'Persona falleció'))
        {
            this.Cerrado = true;
        }
        else if (prospecto.Status == 'Asegurado No Contactado' && (prospecto.Sub_Estado__c  == 'Teléfono Malo' || prospecto.Sub_Estado__c  == 'No Contesta, inubicable'))
        {
            this.Cerrado = true;
        }
        else if ((prospecto.Status == 'Contratante Contactado' || prospecto.Status == 'Asegurado Contactado') && (prospecto.Sub_Estado__c  == 'No le interesa' ||  prospecto.Sub_Estado__c  == 'Pide no volver a llamar' || prospecto.Sub_Estado__c  == 'No reúne condiciones' || prospecto.Sub_Estado__c  == 'Molesto con la compañía' || prospecto.Sub_Estado__c  == 'No tiene medio de pago'))
        {
            this.Cerrado = true;
        }
        else if (prospecto.Status == 'Contrata' && (prospecto.Sub_Estado__c  == 'Contratante de póliza original' || prospecto.Sub_Estado__c  == 'Asegurado'))
        {
            this.Cerrado = true;
        }
        else if (prospecto.Cierre_Administrativo__c == true)//Aca agregar logica con los estado nuevos definidos
        {
            this.Cerrado = true;
        }

        return lista;
    }
    
    public PageReference iniciaLeadFields()
    {
        return null;
    }

    public PageReference refreshLeadFields()
    {
       // this.Id = apexpages.currentpage().getparameters().gzzet('Id'); 
        Boolean callOk = CLS_CM_DatosSaludProtegida.DatosSaludProtegida(this.Id);
       
        PageReference page = new PageReference('/'+Id);
		return page;
    }
}