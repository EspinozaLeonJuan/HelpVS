/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-21-2021   Juan Espinoza León   Initial Version
**/
public with sharing class OBJ_WS_CC_RealizaLlamada {
    public OBJ_WS_CC_RealizaLlamada() {

    }

    public Integer StatusCode { get; set; }

    public String Status { get; set; }

    public String Body { get; set; }

    public String Message { get; set; }
}