/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-24-2020   Juan Espinoza León   Initial Version
**/
public class CTR_TV_ProcesarMiembrosCampagna {
    public String IdCampagna {get; set;}
    
    public CTR_TV_ProcesarMiembrosCampagna(ApexPages.StandardController controller)
    {
        this.IdCampagna = ApexPages.currentPage().getparameters().get('id');
    }
    
    public PageReference volverCampana(){
        
        try
        {
            BAT_TV_GestionCargaCampagna j_MConco = new BAT_TV_GestionCargaCampagna(this.IdCampagna);     
            Id IdJobs = Database.executeBatch(j_MConco, 1); 
        }
        catch(System.Exception ex){
            System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
        }
        finally
        {

        }

        Campaign Campagna = [SELECT Id From Campaign WHERE Id =: this.IdCampagna];

        PageReference pgcampa = new ApexPages.StandardController(Campagna).view();
        pgcampa.setRedirect(true);
        return pgcampa;         
 
    }
}