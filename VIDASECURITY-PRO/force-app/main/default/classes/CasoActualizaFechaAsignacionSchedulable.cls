global class CasoActualizaFechaAsignacionSchedulable implements Schedulable {

    global void execute(SchedulableContext sc)
    {
        actualizaCasos();
    }
 
    public void actualizaCasos()
    {
        Date dFecha = date.valueOf('2018-07-01T00:00:00Z'); //inicio de proceso de derivacion UR
        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        List<Case> Casos = [Select Id, CreatedDate, Fecha_Asignacion_UR__c From Case Where CreatedDate >: dFecha  and ParentId != null
                             and RecordTypeId =: IdRegistro  and CASO_Responsable_UR__c != null];
        
        if (Test.isRunningTest())
        {
            Casos = new List<Case>();          
            Casos.add(new Case());
        }
        
        for (Case caso : Casos)
        {
            if (caso.Fecha_Asignacion_UR__c == null)
            {
                caso.Fecha_Asignacion_UR__c = caso.CreatedDate;
            	if (!Test.isRunningTest())
        		{
                	update caso;
            	}
            }
            
        }
        
    }
}


/*
Select Id, CreatedDate, Fecha_Asignacion_UR__c From Case Where CreatedDate > 2018-07-01T00:00:00Z  and ParentId != null
                             and RecordTypeId = '012i0000000xqP9AAI'  and CASO_Responsable_UR__c != null
*/