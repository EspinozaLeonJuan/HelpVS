/*******************************************************************************************
 *  NOMBRE                 : TRG_Verificaestatushijo
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - E.MARABOLI       - Creación Clase
 * 
 * *****************************************************************************************/
trigger TRG_Verificaestatushijo on Case (before update) {
  
    case c= trigger.new[0];
    system.debug('@@@@ entro aca => ' + c);
    String tiporegistro = [select id from recordtype where name = 'Atención' and sobjecttype = 'Case'].Id;
    if(c.RecordTypeId==tiporegistro  && (c.Status=='Cerrado')){
       // integer hijos=0;
       // hijos=[select count() from case where ParentId=: c.Id and Status <> 'Cerrado'];
        
        List<Case> hijos = [select Id from case where ParentId=: c.Id and Status <> 'Cerrado' and Status <> 'Rechazado'];
           
        system.debug('@@@@ HIJOS => ' + hijos.size());
        
        if (hijos.size() > 0)
        {
            c.Casos_Hijos_cerrados__c = False ;
        }
        else
        {
            c.Casos_Hijos_cerrados__c = True;
        }
    }
   
    
    /*
    case c= trigger.new[0];
    String tiporegistro = [select id from recordtype where name = 'Atención' and sobjecttype = 'Case'].Id;
    if(c.RecordTypeId==tiporegistro  && c.Casos_Hijos_cerrados__c== false && (c.Status=='Cerrado' ||c.Status=='Rechazado')){
        integer hijos=0;
        hijos=[select count() from case where ParentId=: c.Id and Status <> 'Cerrado'];
        system.debug('@@@@ HIJOS => ' + hijos);
        if(hijos==0){
            c.Casos_Hijos_cerrados__c = True ;
            //c.Entrega_Respuesta__c  = True  ;
        }
        
    }
*/
        
        
}