/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-05-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-03-2021   Juan Espinoza León   Initial Version
**/
public with sharing class OBJ_LINK_Notificacion {

    //public Opportunity oportunidad {get; set;}

    public Id Supervisor_Id {get; set;}

    public String Supervisor_Name {get; set;}

    public String Supervisor_Email {get; set;}

    public Id Agente_Id {get; set;}

    public String Agente_Name {get; set;}

    public String Agente_Email {get; set;}

    //public String Agente_Ciudad {get; set;}

    public String Entrevista_Fecha { get; set;}

    public String Entrevista_Hora { get; set;}

    public Date Oportunidad_Entrevista_Fecha { get; set;}

    public Time Oportunidad_Entrevista_Hora { get; set;}

    public String Oportunidad_Name { get; set;}

    public String Oportunidad_FechaNacimiento { get; set;}

    public String Oportunidad_CodigoLink { get; set;}

    public String Oportunidad_Telefono { get; set;}

    public String Oportunidad_Renta { get; set;}

    public String Oportunidad_Direccion { get; set;}

    public String Oportunidad_Cargo { get; set;}

    public String Oportunidad_Comuna { get; set;}

    public String Oportunidad_Observacion { get; set;}

    public String Titulo_Mensaje_Agente { get; set;}

    public String Mensaje_Agente { get; set;}

    public OBJ_LINK_Notificacion() {

    }
}