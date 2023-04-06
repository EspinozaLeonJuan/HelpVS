/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 02-10-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-09-2021   Juan Espinoza León   Initial Version
**/
public class CTR_LINK_NotificacionManual {
    public String Id { get; set; }

    public String Mensaje { get; set; }

    public CTR_LINK_NotificacionManual(ApexPages.StandardController controller)
    {

    }

    public Pagereference SendEmail()
    {
        this.Id = apexpages.currentpage().getparameters().get('Id'); 
       
        System.debug('@@@@ ID '+this.Id);

        Opportunity op = [SELECT Id, StageName FROM Opportunity WHERE Id =: this.Id];

        if (op.StageName == 'Asignación')
        {
            this.Mensaje = 'Notificación enviada a agente.';
            CLS_LINK_Notificacion.envioCorreo(this.Id);
        }
        else {
            this.Mensaje = 'No se puede enviar notificación a Agente en el Estado actual.';
        }

        return null;
    }
 
}