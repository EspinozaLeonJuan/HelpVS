trigger TRG_CambiaEstadoAtencionManual on Case (before insert) {
   
    try
    {
    	Case c = Trigger.new[0];
    	RecordType tiporegistro = [SELECT Id, Name FROM RecordType WHERE Id =: c.RecordTypeId];
   		if( tiporegistro.Name == 'Atención' ){
            if (c.SuppliedEmail == null || c.SuppliedEmail == '')
            {
                c.Status = 'En Proceso';
            }
        }
    }
    catch(system.Exception ex)
    {
         system.debug('@@@@@ TRG_CambiaEstadoAtencionManual EXCEPCION => ' + ex);        
    }
}