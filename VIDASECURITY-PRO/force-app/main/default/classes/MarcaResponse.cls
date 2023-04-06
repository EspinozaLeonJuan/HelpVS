public class MarcaResponse {

  public Integer codigo;
  public String descripcion;
  public Integer rut;
  public String nombreCampo;


  public static List<MarcaResponse> parse(String json) {
    return (List<MarcaResponse>) System.JSON.deserialize(json, List<MarcaResponse>.class);
  }

  @testVisible
  public static String getExample(){
    return '['+
    '      {'+
    '      \"codigo\": 0,'+
    '      \"descripcion\": \"OK\",'+
    '      \"rut\": 9238545,'+
    '      \"nombreCampo\": \"Direccion_Particular__c\"'+
    '   },'+
    '      {'+
    '      \"codigo\": 0,'+
    '      \"descripcion\": \"OK\",'+
    '      \"rut\": 8848666,'+
    '      \"nombreCampo\": \"Phone\"'+
    '   },'+
    '      {'+
    '      \"codigo\": 0,'+
    '      \"descripcion\": \"OK\",'+
    '      \"rut\": 8848666,'+
    '      \"nombreCampo\": \"Direccion_Particular__c\"'+
    '   }'+
    ']';
  }
}