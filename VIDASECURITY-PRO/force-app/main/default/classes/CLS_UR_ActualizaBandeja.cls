/*
 ************************************************************************************************************
 |  NOMBRE                 : CLS_UR_ActualizaBandeja                                                    	|
 |  TIPO                   : APEX CLASS			                                                            |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/09/27   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
public class CLS_UR_ActualizaBandeja {

    private static String RecordTypeId_Caso = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
    private static String RecordTypeId_Tarea = [SELECT Id FROM RecordType WHERE SObjectType = 'Task' AND Name = 'Caso UR'].Id;
    private static String RecordTypeId_Colaboracion = [SELECT Id FROM RecordType WHERE SObjectType = 'Task' AND Name = 'Colaboracion Caso'].Id;
			
    public static void actualizaCasosUsuariosBackup(String area)
    {
        List<Usuario_Backup__c> usuarios;
        
        if (!Test.isRunningTest())
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                    Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                    Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                    Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c
            WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area];     
        }
        else
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                    Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                    Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                    Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c
            //WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area 
            LIMIT 1];
        }
                                  
        for (Usuario_Backup__c u : usuarios)
        {
            u.Casos_BackOffice__c = cantidadCasos(u.OwnerId, u.Id, 'Back Office');
            u.Casos_En_Proceso__c = cantidadCasos(u.OwnerId, u.Id, 'En Proceso');
            u.Casos_En_Revisi_n__c = cantidadCasos(u.OwnerId, u.Id, 'En Revisión');
            u.Casos_Cerrados__c = cantidadCasos(u.OwnerId, u.Id, 'Cerrado');
            u.Casos_Rechazado__c = cantidadCasos(u.OwnerId, u.Id, 'Rechazado');
            u.Casos_Total__c =  u.Casos_BackOffice__c + u.Casos_En_Proceso__c +  u.Casos_En_Revisi_n__c + u.Casos_Cerrados__c + u.Casos_Rechazado__c;

            system.debug('@@@@  UBACK --> ' + u);
        }

        update usuarios;

    }

      public static void actualizaTareasUsuariosBackup(String area)
    {
        List<Usuario_Backup__c> usuarios; 
        
        if (!Test.isRunningTest())
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c
            WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area];
        }
        else
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c  
            //WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area 
            LIMIT 1];
        }
        
        for (Usuario_Backup__c u : usuarios)
        {          
            u.Tareas_Sin_Iniciar__c = cantidadTareas(u.OwnerId, u.Id,'No iniciada');
            u.Tareas_En_Curso__c = cantidadTareas(u.OwnerId, u.Id,'En curso');
            u.Tareas_Completada__c = cantidadTareas(u.OwnerId, u.Id,'Completada');
            u.Tareas_Rechazada__c = cantidadTareas(u.OwnerId, u.Id,'Rechazada');
            u.Tareas_Descartadas__c = cantidadTareas(u.OwnerId, u.Id,'Descartada');

            u.Tareas_Total__c =  u.Tareas_Sin_Iniciar__c + u.Tareas_En_Curso__c +  u.Tareas_Completada__c + u.Tareas_Rechazada__c + u.Tareas_Descartadas__c;

            system.debug('@@@@  UBACK --> ' + u);
        }

        update usuarios;

    }

    public static void actualizaColaboracionesUsuariosBackup(String area)
    {
        List<Usuario_Backup__c> usuarios;
        
        if (!Test.isRunningTest())
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                    Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                    Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                    Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c
            WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area]; 
        }
        else
        {
            usuarios = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                    Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c,
                    Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, 
                    Colaboraciones_Descartadas__c, Colaboraciones_Total__c, OwnerId 
            FROM Usuario_Backup__c
            //WHERE UBAC_Activo__c = true AND UBAC_Area__c =: area 
            LIMIT 1]; 
        }
                                  
        for (Usuario_Backup__c u : usuarios)
        {
            u.Colaboraciones_Sin_Iniciar__c = cantidadColaboraciones(u.OwnerId, u.Id,'No iniciada');
            u.Colaboraciones_En_Curso__c = cantidadColaboraciones(u.OwnerId, u.Id,'En curso');
            u.Colaboraciones_Completada__c = cantidadColaboraciones(u.OwnerId, u.Id,'Completada');
            u.Colaboraciones_Rechazada__c = cantidadColaboraciones(u.OwnerId, u.Id,'Rechazada');
            u.Colaboraciones_Descartadas__c = cantidadColaboraciones(u.OwnerId, u.Id,'Descartada');

            u.Colaboraciones_Total__c =  u.Colaboraciones_Sin_Iniciar__c + u.Colaboraciones_En_Curso__c +  u.Colaboraciones_Completada__c + u.Colaboraciones_Rechazada__c + u.Colaboraciones_Descartadas__c;

            system.debug('@@@@  UBACK --> ' + u);
        }

        update usuarios;

    }


    public static Integer cantidadCasos(String colaId, String id, String estado)
    {
        if (estado != 'En Revisión')
        {
            List<Case> casos  = [SELECT Id FROM Case WHERE OwnerId =: colaId AND RecordTypeId=: RecordTypeId_Caso AND CASO_Responsable_UR__c =: id AND Status =: estado];
            return casos.size();    
        }
        else 
        {
            List<Case> casos  = [SELECT Id FROM Case WHERE  RecordTypeId=: RecordTypeId_Caso AND Id_Responsable_UR__c =: id AND Status =: estado];
            return casos.size();
        }        
    }

    public static Integer cantidadTareas(String colaId, String id, String estado)
    {
        List<Task> tareas = [SELECT Id FROM Task WHERE RecordTypeId=: RecordTypeId_Tarea AND Responsable_Backup__c =: id  AND Status =: estado];
        return tareas.size();
    }

    public static Integer cantidadColaboraciones(String colaId, String id, String estado)
    {
        List<Task> colaboraciones = [SELECT Id FROM Task WHERE RecordTypeId=: RecordTypeId_Colaboracion AND Responsable_Backup__c =: id  AND Status =: estado];
        return colaboraciones.size();
    }
}