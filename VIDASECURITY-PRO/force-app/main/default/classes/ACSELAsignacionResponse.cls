public class ACSELAsignacionResponse {

  public Integer codigo;
  public String descripcion;
  public Integer rut;


  public static List<ACSELAsignacionResponse> parse(String json) {
    return (List<ACSELAsignacionResponse>) System.JSON.deserialize(json, List<ACSELAsignacionResponse>.class);
  }

  @testVisible
  public static String getExample(){
    String json = '['+
    '      {'+
    '      \"codigo\": 0,'+
    '      \"descripcion\": \"OK\",'+
    '      \"rut\": 16006641'+
    '   },'+
    '      {'+
    '      \"codigo\": 0,'+
    '      \"descripcion\": \"OK\",'+
    '      \"rut\": 15772859'+
    '   }'+
    ']';
    return json;
  }
}