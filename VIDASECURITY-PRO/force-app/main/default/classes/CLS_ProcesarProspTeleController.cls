public class CLS_ProcesarProspTeleController {

    public Campaign Campa {get; set;}
    public String idCampa {get; set;}
    
    public CLS_ProcesarProspTeleController(ApexPages.StandardController controller){

        idCampa = ApexPages.currentPage().getparameters().get('id');
   
    }
    
    public PageReference volverCampana(){
        
        try{
            
            //Integer tamLote = 1;
            CLS_ProcesarProspectosNuevosTeleventa j_MConco = new CLS_ProcesarProspectosNuevosTeleventa(idCampa);     
            Id IdJobs = Database.executeBatch(j_MConco, 1); 

        }catch(System.Exception ex){
            System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
        }finally{}

        Campa = [SELECT Id From Campaign WHERE Id =: idCampa];

        PageReference pgcampa = new ApexPages.StandardController(Campa).view();
        pgcampa.setRedirect(true);
        return pgcampa;         

    }
    
}