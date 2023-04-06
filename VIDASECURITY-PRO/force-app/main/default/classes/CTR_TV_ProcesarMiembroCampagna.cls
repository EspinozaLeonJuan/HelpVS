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
public class CTR_TV_ProcesarMiembroCampagna {
    
    public String IdMiembroCampagna {get; set;}
    
    public CTR_TV_ProcesarMiembroCampagna(ApexPages.StandardController controller)
    {
        this.IdMiembroCampagna = ApexPages.currentPage().getparameters().get('id');
    }
    
    public PageReference volverMiembroCampana(){
        
        try
        {
            BAT_TV_GestionMiembroCampagna j_MConco = new BAT_TV_GestionMiembroCampagna(this.IdMiembroCampagna);     
            Id IdJobs = Database.executeBatch(j_MConco, 1); 
        }
        catch(System.Exception ex){
            System.debug('@@@@ ERROR JOB MC ONCO => ' + ex);
        }
        finally
        {

        }

        CampaignMember Miembro = [SELECT Id From CampaignMember WHERE Id =: this.IdMiembroCampagna];

        PageReference pgmcampa = new ApexPages.StandardController(Miembro).view();
        pgmcampa.setRedirect(true);
        return pgmcampa;         
 
    }
}