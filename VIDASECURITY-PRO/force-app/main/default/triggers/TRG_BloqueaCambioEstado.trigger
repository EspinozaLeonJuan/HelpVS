trigger TRG_BloqueaCambioEstado on Case (before update) {
    try
    {
        Case c = Trigger.new[0];
        RecordType tiporegistro = [SELECT Id, Name FROM RecordType WHERE Id =: c.RecordTypeId];
        if( tiporegistro.Name == 'Atención' ){
            
            Case Caso = [select Id, Status, Entrega_Respuesta__c from Case Where Id=:c.Id][0];
            system.debug('@@@@@ TRG_BloqueaCambioEstado Caso => ' + Caso);      
            if (Caso.Status == 'Basura')
            {
                c.addError('No puede ser modificado el Estado "Basura" asociado a un Caso de Atención');
                //c.Status = 'Basura';
                //c.Entrega_Respuesta__c = true;
                //c.Status = 'En Proceso';
                //c.Entrega_Respuesta__c = false;
            }
            else if (Caso.Status == 'Cerrado (Correo Duplicado)')
            {
                c.addError('No puede ser modificado el Estado "Cerrado (Correo Duplicado)" asociado a un Caso de Atención');
                //c.Status = 'Basura';
                //c.Entrega_Respuesta__c = true;
                //c.Status = 'En Proceso';
                //c.Entrega_Respuesta__c = false;
            }
            else if (Caso.Status == 'Cerrado (Correo Masivo)')
            {
                 c.addError('No puede ser modificado el Estado "Cerrado (Correo Masivo)" asociado a un Caso de Atención');
               
                //c.Status = 'Basura';
                //c.Entrega_Respuesta__c = true;
                //c.Status = 'En Proceso';
                //c.Entrega_Respuesta__c = false;
            }
        }
    }
    catch(system.Exception ex)
    {
         system.debug('@@@@@ TRG_BloqueaCambioEstado EXCEPCION => ' + ex);        
    }
}