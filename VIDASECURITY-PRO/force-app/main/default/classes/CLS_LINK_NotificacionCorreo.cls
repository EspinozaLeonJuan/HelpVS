/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-02-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-04-2021   Juan Espinoza León   Initial Version
**/
global class CLS_LINK_NotificacionCorreo Implements Schedulable{
    global void execute(SchedulableContext ctx)
    {
         CLS_LINK_Notificacion.envioCorreo();

         CLS_LINK_Notificacion.envioCorreo_Cliente();
    }
}