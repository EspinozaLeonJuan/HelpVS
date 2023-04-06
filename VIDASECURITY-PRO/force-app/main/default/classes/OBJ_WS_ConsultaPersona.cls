/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-03-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class OBJ_WS_ConsultaPersona {
    public OBJ_WS_ConsultaPersona() {

    }

    public String RUT { get; set; }

    public String Nombres { get; set; }

    public String Apellido_Paterno { get; set; }

    public String Apellido_Materno { get; set; }

    public String Fecha_Nacimiento { get; set; }

}