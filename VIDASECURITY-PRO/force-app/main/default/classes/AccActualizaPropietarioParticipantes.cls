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
public class AccActualizaPropietarioParticipantes {
    
    public static void execute( List<Participantes_de_Campa_a__c> lParticipantes ) {
        List<Participantes_de_Campa_a__c> lParticipantesUpdate = new List<Participantes_de_Campa_a__c>();
        
        for(Participantes_de_Campa_a__c oParticipantes : lParticipantes ){
            System.debug('##oParticipantes.OwnerId: ' + oParticipantes.OwnerId + ' oParticipantes.Cuenta__r.OwnerId: ' + oParticipantes.Cuenta__r.OwnerId );
            if( oParticipantes.OwnerId != oParticipantes.Cuenta__r.OwnerId){
                oParticipantes.OwnerId = oParticipantes.Cuenta__r.OwnerId;
                lParticipantesUpdate.add( oParticipantes );
            }
        }

        if( lParticipantesUpdate.Size() > 0){
            update lParticipantesUpdate;
        }
    }
}