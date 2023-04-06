/**
* VASS
* @author           Jessica Gómez
* @email: 			jessica.gomez@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Jessica Gómez JMGR	       Class Created
***********************************************************************************************************************/
public class AccValidaRUTCuenta {
    public static void validaRutCuenta( Account accNew, Account accOld, Set<Id> invalid_rut, List<Account_Error_Log__c> records_log){
		String rut = accNew.IsPersonAccount ? (accNew.Rut_contacto__pc + accNew.DV_contacto__pc) : accNew.Rut__c + accNew.DV__c;
		if (!RUTUtils.isValid(rut)){
      if (accOld != null ) {
        String rut_old = accNew.IsPersonAccount ? (accOld.Rut_contacto__pc + accOld.DV_contacto__pc) : accOld.Rut__c + accOld.DV__c;
        if ( rut == rut_old ) {
          String descrip = accNew.IsPersonAccount ? 'El RUT '+ accNew.Rut_contacto__pc + '-' + accNew.DV_contacto__pc +' es incorrecto' : 'El RUT '+ accNew.Rut__c + '-' + accNew.DV__c +' es incorrecto';
          Account_Error_Log__c record_log = new Account_Error_Log__c( Cuenta__c = accNew.Id, Description__c = descrip, Type__c='RUT inválido' );
          invalid_rut.add(accNew.Id);
          records_log.add(record_log);
        } else {
          TriggerHandler.addError('RUT no válido', accNew);
        }
      } else {
      	TriggerHandler.addError('RUT no válido', accNew);
      }
		}
	}
}