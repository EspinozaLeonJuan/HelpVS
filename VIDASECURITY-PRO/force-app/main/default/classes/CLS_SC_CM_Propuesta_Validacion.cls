/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-28-2022
 * @last modified by  : Juan Espinoza León
**/

global class CLS_SC_CM_Propuesta_Validacion Implements Schedulable{

    public CLS_SC_CM_Propuesta_Validacion() {

    }

    public static Parametros_Vida_Security__c parametros =  Parametros_Vida_Security__c.getOrgDefaults();

    private void ValidaPropuestasPendientes()
    {
        string usuario = [SELECT Id,  Name, RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c;


        Long Ln = 5;

        try
        {
            Ln = Math.roundToLong(parametros.Intentos_Consulta_WS_Oncologico__c);
        }
        catch (Exception ex){}

        Integer limiteConsultasWS = Integer.valueOf(Ln);

        List<Opportunity> propuestas = [SELECT Id, OPOR_N_Propuesta__c, OPOR_Comentario_Actualizacion_Poliza__c, OPOR_Poliza_Propuesta__c, OPOR_Estado_Poliza__c, OPOR_IdPoliza_Propuesta__c, Intentos_Consulta_WS_Oncologico__c FROM Opportunity WHERE  StageName = 'Venta - Aprobada' AND OPOR_WS_Actualiza_Datos_Prospecto__c = false AND (RecordType.Name = 'Oportunidad - Salud Protegida' OR RecordType.Name = 'Venta - Oncológico') AND Intentos_Consulta_WS_Oncologico__c <: limiteConsultasWS];  // intento 3, 4, 5

        system.debug('@@@@ propuestas --> '+ propuestas.size());

        List<String> queryPolizas = new List<String>();

        for (Opportunity pro : propuestas) {
            system.debug('@@@@ pro '+ pro);
            EXT_WS_CM_Oncologico.validarPropuesta(usuario, pro.Id);

            DateTime start = System.Now();
            while(System.Now().getTime()< start.getTime()+30000){} //Delay
        }

        // List<Opportunity> propuestas_conProblemas = [SELECT Id, OPOR_N_Propuesta__c, OPOR_Comentario_Actualizacion_Poliza__c, OPOR_Poliza_Propuesta__c, OPOR_Estado_Poliza__c, OPOR_IdPoliza_Propuesta__c, Intentos_Consulta_WS_Oncologico__c FROM Opportunity WHERE  StageName = 'Venta - Aprobada' AND OPOR_WS_Actualiza_Datos_Prospecto__c = false AND (RecordType.Name = 'Oportunidad - Salud Protegida' OR RecordType.Name = 'Venta - Oncológico') AND Intentos_Consulta_WS_Oncologico__c >=: limiteConsultasWS];  // intento 3, 4, 5
    }

    global void execute(SchedulableContext ctx)
    {
        ValidaPropuestasPendientes();
    }

}