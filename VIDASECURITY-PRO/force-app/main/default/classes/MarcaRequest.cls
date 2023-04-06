public with sharing class MarcaRequest {
  public String nombreCampo;
  public String valorCampo;
  public Integer rut;


  public static List<MarcaRequest> parse(String json) {
    return (List<MarcaRequest>) System.JSON.deserialize(json, List<MarcaRequest>.class);
  }

  @testVisible
  public static String getExample(){
    return '['+
    ' {'+
    '   \"nombreCampo\": \"Direccion_Particular__c\",'+
    '   \"valorCampo\": \"AUGUSTO LEGUIA 80\",'+
    '   \"rut\": 9238545'+
    ' },'+
    ' {'+
    '   \"nombreCampo\": \"Phone\",'+
    '   \"valorCampo\": \"12345678\",'+
    '   \"rut\": 8848666'+
    ' },'+
    ' {'+
    '   \"nombreCampo\": \"Direccion_Particular__c\",'+
    '   \"valorCampo\": \"EL GOLF 123\",'+
    '   \"rut\": 8848666'+
    ' }'+
    ']';
  }
}