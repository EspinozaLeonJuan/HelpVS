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
public with sharing class PAR_EXT_WS_RealizaLlamada {
    public PAR_EXT_WS_RealizaLlamada() {

    }

    public String Id { get; set; }

    public String Desde { get; set; }

    public String Hasta { get; set; }

    public String Rut { get; set; }

    public String Usuario { get; set; }
}