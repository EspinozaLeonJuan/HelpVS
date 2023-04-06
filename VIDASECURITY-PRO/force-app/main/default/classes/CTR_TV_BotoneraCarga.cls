/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-30-2020   Juan Espinoza León   Initial Version
**/
public  class CTR_TV_BotoneraCarga {
    public CTR_TV_BotoneraCarga() {

    }

    public Boolean LoadOk { get; set; }

    public String AreaUsuario { get; set; }

    public PageReference inicioBotonera()
    {
        return null;
    }
   
    public Pagereference HistorialCargasCampagnas()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_TV_Historial_Cargas');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference NuevaCargaCampagna()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_TV_Carga_Campagna');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }
    
}