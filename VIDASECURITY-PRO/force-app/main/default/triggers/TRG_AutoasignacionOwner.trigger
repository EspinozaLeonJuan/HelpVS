/*******************************************************************************************
 *  NOMBRE                 : TRG_AutoasignacionOwner
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Trigger
 
 * *****************************************************************************************/
trigger TRG_AutoasignacionOwner on Case (before insert, before update, before delete, after insert, after update, after delete) {

    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            
            try{
                Case c = Trigger.new[0];
                RecordType tiporegistro = [SELECT Id, Name FROM RecordType WHERE Id =: c.RecordTypeId];
                if( tiporegistro.Name == 'Atención' ){
                    
                    List<Case> cHijos = new List<Case>();

                    cHijos = [SELECT Id, OwnerId, ParentId, Status FROM Case WHERE ParentId =: c.Id AND Status = 'Nuevo'];
                    if(cHijos.size() > 0){
                        for(Case ch:cHijos){
                            ch.OwnerId = c.OwnerId;
                        }
                        update cHijos;
                    }
                }
            }catch(system.Exception ex){
                
            }
            
        }
        
        if(Trigger.isDelete){
            
        }
        
    }else{
        
        if(Trigger.isInsert){
            
        }
        
        if(Trigger.isUpdate){
            
        }
        
        if(Trigger.isDelete){
            
        }        
        
    }
    
}