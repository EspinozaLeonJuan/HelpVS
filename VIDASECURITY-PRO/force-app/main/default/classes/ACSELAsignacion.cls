public class ACSELAsignacion {

	public Integer rut;
	public Integer codigoEjecutivo;


	public static List<ACSELAsignacion> parse(String json) {
		return (List<ACSELAsignacion>) System.JSON.deserialize(json, List<ACSELAsignacion>.class);
	}

  @testVisible
  public static String getExample(){
    String json = '['+
    '{'+
    ' \"rut\": 16006641,'+
    ' \"codigoEjecutivo\": 17611'+
    '},'+
    '{'+
    ' \"rut\": 15772859,'+
    ' \"codigoEjecutivo\": 21376'+
    '}'+
    ']';
    return json;
  }
}