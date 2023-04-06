public class ParticipantesCampanaUtils {
    
    public String estadoCierre {get; set;}
    
    Public String listViewId=Apexpages.currentPage().getParameters().get('lv');  
    
    public Participantes_de_Campa_a__c participante{get;set;}
       
    public ParticipantesCampanaUtils(ApexPages.StandardController stdcontroller){
        
        participante=(Participantes_de_Campa_a__c)stdcontroller.getRecord();
    }
    
    public List<String> Ids{get; set;}
    
    //se obtienen los Ids de los registros seleccionados en el boton
    public void getIDD(){
        if (ids == null) {
            String s = ApexPages.currentPage().getParameters().get('ids');
            if (s != null) {
                Ids = s.split(',');}
        } 
    }

    
   
    
  	public void passValueToController()   {//se asigna el valor de la packlist a la variable "estadoCierre"
        try{
            estadoCierre = participante.Estado_Cierre__c;}
        catch(exception ex){
            system.debug('error '+ex);
        }
    }
    
    
    
    public PageReference ActualizarEstadoCierre(){//es actualizado el campo Estado_Cierre__c en los registros de interes
        
        List <Participantes_de_Campa_a__c> recordsToUpdate=new List<Participantes_de_Campa_a__c>();
        getIDD();
        for(Participantes_de_Campa_a__c record: [SELECT Id,Estado_Cierre__c FROM Participantes_de_Campa_a__c WHERE Id in:Ids ] ){
            record.Estado_Cierre__c=estadoCierre;
            recordsToUpdate.add(record);
        }
        try{
            update recordsToUpdate;}
        catch(exception ex){
            system.debug('Error:' +ex);
            }
    	PageReference pg = new PageReference('/a03?fcf'+listViewId);
        pg.setRedirect(true);
        return pg;
    }    
}