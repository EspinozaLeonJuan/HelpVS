/**
 * @File Name          : PAR_UR_Bandeja.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 04-12-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/22/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class PAR_UR_Bandeja{
    
  public cls_Botonera Botonera { get;  set; }
  
  public class cls_Botonera 
  {
  public boolean CasosUR { get;  set; }
  public boolean TareasUR { get;  set; }
      public boolean ColaboracionesUR { get;  set; }
      public boolean AsignacionesUR { get;  set; }
  public boolean SeleccionUsuario { get;  set; }
  public boolean CasosOptativos { get;  set; }
  }
  
public static PAR_UR_Bandeja parse(String json){
  return (PAR_UR_Bandeja) System.JSON.deserialize(json, PAR_UR_Bandeja.class);
}
}