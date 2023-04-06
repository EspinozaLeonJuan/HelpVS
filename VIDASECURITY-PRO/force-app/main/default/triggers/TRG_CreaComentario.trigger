/*******************************************************************************************
 *  NOMBRE                 : TRG_CreaComentario
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO UNIDAD RESOLUTORA 
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 20/06/2018 - L.LABBE         - Creación Trigger
 * 
 * *****************************************************************************************/
 trigger TRG_CreaComentario on CaseComment (after Insert) {
 
// if(Trigger.isAfter){
     
     try{
         CaseComment cmtr = trigger.new[0];
         
         List<case> caso = [Select id, Caso_Crea_Comentario__c, recordTypeId from Case where id =: cmtr.ParentId];
         system.debug('@@@@@@@@@@@@ caso'+ caso);
         if(caso.size()>0){
             system.debug('@@@@@@@@@@@@ entra en caso > 1');
             Case cs = new case();             
             cs = caso[0];
             //cs.Id= cmtr.ParentId;
             cs.Caso_Crea_Comentario__c = true;
             system.debug('@@@@@@@@@@@@ cs.id ='+ cs );
            
			//update cs;  
			database.upsert(cs);      
             
             
         }
         
     }catch(Exception ex){
                system.debug('@@@@@ ERROR - No se actualiza el campo crea comentario en el caso => ' + ex);
               
            }
 
  //}
 
}