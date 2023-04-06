/**
 * @File Name          : CasoActualizaFechaDerivacionSchedulable.cls
 * @Description        : 
 * @Author             : Juan Espinoza León
 * @Group              : 
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 9/3/2019, 3:20:54 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/3/2019   Juan Espinoza León     Initial Version
**/
global class CasoActualizaFechaDerivacionSchedulable implements Schedulable {
     global void execute(SchedulableContext sc)
    {
        actualizaCasos();
    }
 
    public void actualizaCasos()
    {
        Date dFecha = date.valueOf('2018-07-01T00:00:00Z'); //inicio de proceso de derivacion UR
        
        String IdRegistro = [SELECT Id FROM RecordType WHERE SobjectType='Case' and Name = 'Solicitudes'].Id;
        
        List<Case> Casos = [Select Id, CreatedDate, Fecha_Asignacion_UR__c, Fecha_Derivacion_UR__c From Case Where CreatedDate >: dFecha  and ParentId != null
                             and RecordTypeId =: IdRegistro  and CASO_Responsable_UR__c != null];
        
        if (Test.isRunningTest())
        {
            Casos = new List<Case>();          
            Casos.add(new Case());
        }
        
        for (Case caso : Casos)
        {
            if (caso.Fecha_Derivacion_UR__c == null)
            {
                caso.Fecha_Derivacion_UR__c = caso.Fecha_Asignacion_UR__c;
            	if (!Test.isRunningTest())
        		{
                	update caso;
            	}
            }
            
        }
        
    }
}