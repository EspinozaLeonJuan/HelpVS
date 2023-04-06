public class CLS_ActualizaPantalla {

	public PageReference actualizaPropuesta(String recId)
    {
        PageReference pg = new pageReference('/006/' + recId);
        pg.setRedirect(true);
        return pg;
    }    
    
}