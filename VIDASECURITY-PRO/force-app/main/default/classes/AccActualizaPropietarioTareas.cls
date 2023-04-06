/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:
* Description:
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description
*            ----   ----------     ---------------------------     -------------
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class AccActualizaPropietarioTareas {

    public static void execute( List<Task> lTareas ) {

        system.debug('#### lTareas '+lTareas);

        List<Task> lTareasUpdate = new List<Task>();

        for( Task oTask : lTareas ){
            if( oTask.OwnerId != oTask.Account.OwnerId ){
                oTask.OwnerId = oTask.Account.OwnerId;
                lTareasUpdate.add( oTask );
            }
        }

        if( lTareasUpdate.Size() > 0 ){
            update lTareasUpdate;
        }
    }
}