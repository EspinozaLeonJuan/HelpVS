/*
 ************************************************************************************************************
 |  NOMBRE                 : CLS_UR_Bandeja_Contador                                                        |
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Actuaiza casos, tareas y colaboraciones en el objeto Usuario_Backup__c         |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/09/16   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
public  class CLS_UR_Bandeja_Contador {

    public class CambioMasivoResponsable
    {
        public String IdActual {get; set;}

        public String IdNuevo {get; set;}

        public String EstadoActual {get; set;}
    }

    public class CambioMasivoEstado
    {
        public String Id {get; set;}

        public String EstadoNuevo {get; set;}

        public String EstadoActual {get; set;}
    }

    public static String ActualizaEstado_Caso(String Id, String estado, String estadoPrevio)
    {
        if (Id == null)
        {
            return 'ID_NOT_FOUND';
        }

        Usuario_Backup__c uback = [SELECT Id, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: Id];
        
        if (uback == null)
        {
            return 'UBACK_NOEXISTE';
        }

        try 
        {

            if (estado == 'Back Office')
            {
                uback.Casos_BackOffice__c = uback.Casos_BackOffice__c + 1;

                if (estadoPrevio == 'En Revisión' || estadoPrevio == 'Revisión')
                {
                    if (uback.Casos_En_Revisi_n__c > 0)
                    {
                        uback.Casos_En_Revisi_n__c = uback.Casos_En_Revisi_n__c - 1;
                    }
                }
            }
            else if (estado == 'En Proceso')
            {
                uback.Casos_En_Proceso__c = uback.Casos_En_Proceso__c + 1;
                
                if (uback.Casos_BackOffice__c > 0)
                {
                    uback.Casos_BackOffice__c = uback.Casos_BackOffice__c - 1;
                }
            }
            else if (estado == 'En Revisión' || estado == 'Revisión')
            {                
                uback.Casos_En_Revisi_n__c = uback.Casos_En_Revisi_n__c + 1;

                if (uback.Casos_En_Proceso__c > 0)
                {
                    uback.Casos_En_Proceso__c = uback.Casos_En_Proceso__c - 1;
                }
            }
            else if (estado == 'Cerrado' || estado == 'Caso Cerrado')
            {
                uback.Casos_Cerrados__c = uback.Casos_Cerrados__c + 1;
                
                if (uback.Casos_En_Proceso__c > 0)
                {
                    uback.Casos_En_Proceso__c = uback.Casos_En_Proceso__c - 1;
                }
            }
            else if (estado == 'Rechazado')
            {
                uback.Casos_Rechazado__c = uback.Casos_Rechazado__c + 1;
                
                if (uback.Casos_En_Proceso__c > 0)
                {
                    uback.Casos_En_Proceso__c = uback.Casos_En_Proceso__c - 1;
                }
            }       

            uback.Casos_Total__c = uback.Casos_BackOffice__c + uback.Casos_En_Proceso__c + uback.Casos_En_Revisi_n__c + uback.Casos_Cerrados__c +  uback.Casos_Rechazado__c;

            update uback;

            return 'UBACK_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaEstado_Casos  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'UBACK_ERROR';
        }        
    }


    public static  String ActualizaResponsable_Caso(String IdActual, String IdNuevo, string estadoActual)
    {
        system.debug('@@@@  IdActual --> '+ IdActual + '  IdNuevo ---> '+IdNuevo + '  estado Actual ---> '+estadoActual);

        Usuario_Backup__c ubackActual = [SELECT Id, Name, Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdActual];
        

        Usuario_Backup__c ubackNuevo = [SELECT Id, Name,  Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdNuevo];

        system.debug('@@@@  ubackActual --> '+ ubackActual);

        system.debug('@@@@  ubackNuevo --> '+ ubackNuevo);
        
        if (ubackActual == null)
        {
            return 'UBACK_ACTUAL_NOEXISTE';
        }

        if (ubackNuevo == null)
        {
            return 'UBACK_NUEVO_NOEXISTE';
        }

        try 
        {

            if (estadoActual == 'Back Office')
            {
                if (ubackActual.Casos_BackOffice__c > 0)
                {
                    ubackActual.Casos_BackOffice__c = ubackActual.Casos_BackOffice__c - 1;
                }

                ubackNuevo.Casos_BackOffice__c = ubackNuevo.Casos_BackOffice__c + 1;
            }
            else if (estadoActual == 'En Proceso')
            {
                if (ubackActual.Casos_En_Proceso__c > 0)
                {
                    ubackActual.Casos_En_Proceso__c = ubackActual.Casos_En_Proceso__c - 1;
                }

                ubackNuevo.Casos_BackOffice__c = ubackNuevo.Casos_BackOffice__c + 1;                
            }

            ubackActual.Casos_Total__c = ubackActual.Casos_BackOffice__c + ubackActual.Casos_En_Proceso__c + ubackActual.Casos_En_Revisi_n__c + ubackActual.Casos_Cerrados__c +  ubackActual.Casos_Rechazado__c;
            ubackNuevo.Casos_Total__c = ubackNuevo.Casos_BackOffice__c + ubackNuevo.Casos_En_Proceso__c + ubackNuevo.Casos_En_Revisi_n__c + ubackNuevo.Casos_Cerrados__c +  ubackNuevo.Casos_Rechazado__c;

            update ubackActual;
            update ubackNuevo;

            return 'RESPONSABLES_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaResponsable_Casos  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'RESPONSABLES_ERROR';
        }        
    }

    public static String ActualizaEstado_Tarea(String Id, String estado, String estadoPrevio)
    {
        Usuario_Backup__c uback = [SELECT Id, Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: Id];
        
        if (uback == null)
        {
            return 'UBACK_NOEXISTE';
        }

        try 
        {
            if (estado == 'No Iniciada')
            {
                uback.Tareas_Sin_Iniciar__c = uback.Tareas_Sin_Iniciar__c + 1;                
            } 
            else if (estado == 'En Curso')
            {
                uback.Tareas_En_Curso__c = uback.Tareas_En_Curso__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Tareas_Sin_Iniciar__c > 0)
                    {
                        uback.Tareas_Sin_Iniciar__c = uback.Tareas_Sin_Iniciar__c - 1;
                    }
                }
            }
            else if (estado == 'Completada')
            {
                uback.Tareas_Completada__c = uback.Tareas_Completada__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Tareas_Sin_Iniciar__c > 0)
                    {
                        uback.Tareas_Sin_Iniciar__c = uback.Tareas_Sin_Iniciar__c - 1;
                    }
                }
                else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Tareas_En_Curso__c > 0)
                    {
                        uback.Tareas_En_Curso__c = uback.Tareas_En_Curso__c - 1;
                    }
                }
            }
            else if (estado == 'Rechazada')
            {
                uback.Tareas_Rechazada__c = uback.Tareas_Rechazada__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Tareas_Sin_Iniciar__c > 0)
                    {
                        uback.Tareas_Sin_Iniciar__c = uback.Tareas_Sin_Iniciar__c - 1;
                    }
                } else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Tareas_En_Curso__c > 0)
                    {
                        uback.Tareas_En_Curso__c = uback.Tareas_En_Curso__c - 1;
                    }
                }
            }
            else if (estado == 'Descartada')
            {
                uback.Tareas_Descartadas__c = uback.Tareas_Descartadas__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Tareas_Sin_Iniciar__c > 0)
                    {
                        uback.Tareas_Sin_Iniciar__c = uback.Tareas_Sin_Iniciar__c - 1;
                    }
                } else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Tareas_En_Curso__c > 0)
                    {
                        uback.Tareas_En_Curso__c = uback.Tareas_En_Curso__c - 1;
                    }
                }
            }

            uback.Tareas_Total__c = uback.Tareas_Sin_Iniciar__c + uback.Tareas_En_Curso__c + uback.Tareas_Completada__c + uback.Tareas_Rechazada__c + uback.Tareas_Descartadas__c;

            update uback;

            return 'UBACK_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaEstado_Tareas  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'UBACK_ERROR';
        }        
    }

    public static String ActualizaResponsable_Tarea(String IdActual, String IdNuevo, string estadoActual)
    {
        Usuario_Backup__c ubackActual = null;

        if (IdActual != 'NO_ID')
        {
            ubackActual = [SELECT Id, Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdActual];

            /*if (ubackActual == null)
            {
                return 'UBACK_ACTUAL_NOEXISTE';
            }*/
        }      
              
        Usuario_Backup__c ubackNuevo = [SELECT Id, Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Descartadas__c, Tareas_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdNuevo];        
      
        system.debug('@@@@ Entrada ActualizaResponsable_Tarea  -->  IdActual : '+ IdActual+'   -  IdNuevo: '+IdNuevo+' - estadoActual: '+estadoActual);
        if (ubackNuevo == null)
        {
            return 'UBACK_NUEVO_NOEXISTE';
        }

        try 
        {
            if (estadoActual == 'No Iniciada')
            {                
                if (ubackActual != null)
                {
                    if (ubackActual.Tareas_Sin_Iniciar__c > 0)
                    {
                        ubackActual.Tareas_Sin_Iniciar__c = ubackActual.Tareas_Sin_Iniciar__c - 1;
                    }
                }
                
                ubackNuevo.Tareas_Sin_Iniciar__c = ubackNuevo.Tareas_Sin_Iniciar__c + 1;
            }
            else if (estadoActual == 'En Curso')
            {
                if (ubackActual != null)
                {
                    if (ubackActual.Tareas_En_Curso__c > 0)
                    {
                        ubackActual.Tareas_En_Curso__c = ubackActual.Tareas_En_Curso__c - 1;
                    }
                }                   
                
                ubackNuevo.Tareas_Sin_Iniciar__c = ubackNuevo.Tareas_Sin_Iniciar__c + 1;                
            }

            if (ubackActual != null)
            {
                ubackActual.Tareas_Total__c = ubackActual.Tareas_Sin_Iniciar__c + ubackActual.Tareas_En_Curso__c + ubackActual.Tareas_Completada__c + ubackActual.Tareas_Rechazada__c + ubackActual.Tareas_Descartadas__c;
            }

            ubackNuevo.Tareas_Total__c = ubackNuevo.Tareas_Sin_Iniciar__c + ubackNuevo.Tareas_En_Curso__c + ubackNuevo.Tareas_Completada__c + ubackNuevo.Tareas_Rechazada__c + ubackNuevo.Tareas_Descartadas__c;

            if (ubackActual != null)
            {
                update ubackActual;
            }

            update ubackNuevo;

            return 'RESPONSABLES_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaResponsable_Tareas  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'RESPONSABLES_ERROR';
        }        
    }

    public static String ActualizaEstado_Colaboracion(String Id, String estado, String estadoPrevio)
    {
        Usuario_Backup__c uback = [SELECT Id, Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Descartadas__c, Colaboraciones_Total__c  FROM Usuario_Backup__c  
                                    WHERE Id =: Id];
        
        if (uback == null)
        {
            return 'UBACK_NOEXISTE';
        }

        try 
        {
            if (estado == 'No Iniciada')
            {
                uback.Colaboraciones_Sin_Iniciar__c = uback.Colaboraciones_Sin_Iniciar__c + 1;                
            } 
            else if (estado == 'En Curso')
            {
                uback.Colaboraciones_En_Curso__c = uback.Colaboraciones_En_Curso__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Colaboraciones_Sin_Iniciar__c > 0)
                    {
                        uback.Colaboraciones_Sin_Iniciar__c = uback.Colaboraciones_Sin_Iniciar__c - 1;
                    }
                }
            }
            else if (estado == 'Completada')
            {
                uback.Colaboraciones_Completada__c = uback.Colaboraciones_Completada__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Colaboraciones_Sin_Iniciar__c > 0)
                    {
                        uback.Colaboraciones_Sin_Iniciar__c = uback.Colaboraciones_Sin_Iniciar__c - 1;
                    }
                }
                else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Colaboraciones_En_Curso__c > 0)
                    {
                        uback.Colaboraciones_En_Curso__c = uback.Colaboraciones_En_Curso__c - 1;
                    }
                }
            }
            else if (estado == 'Rechazada')
            {
                uback.Colaboraciones_Rechazada__c = uback.Colaboraciones_Rechazada__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Colaboraciones_Sin_Iniciar__c > 0)
                    {
                        uback.Colaboraciones_Sin_Iniciar__c = uback.Colaboraciones_Sin_Iniciar__c - 1;
                    }
                }
                else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Colaboraciones_En_Curso__c > 0)
                    {
                        uback.Colaboraciones_En_Curso__c = uback.Colaboraciones_En_Curso__c - 1;
                    }
                }
            }
            else if (estado == 'Descartada')
            {
                uback.Colaboraciones_Descartadas__c = uback.Colaboraciones_Descartadas__c + 1;
                if (estadoPrevio == 'No Iniciada')
                {
                    if (uback.Colaboraciones_Sin_Iniciar__c > 0)
                    {
                        uback.Colaboraciones_Sin_Iniciar__c = uback.Colaboraciones_Sin_Iniciar__c - 1;
                    }
                }
                else if (estadoPrevio == 'En Curso')
                {
                    if (uback.Colaboraciones_En_Curso__c > 0)
                    {
                        uback.Colaboraciones_En_Curso__c = uback.Colaboraciones_En_Curso__c - 1;
                    }
                }
            }

            uback.Colaboraciones_Total__c = uback.Colaboraciones_Sin_Iniciar__c + uback.Colaboraciones_En_Curso__c + uback.Colaboraciones_Completada__c + uback.Colaboraciones_Rechazada__c + uback.Colaboraciones_Descartadas__c;

            update uback;

            return 'UBACK_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaEstado_Colaboraciones  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'UBACK_ERROR';
        }        
    }

    public static String ActualizaResponsable_Colaboracion(String IdActual, String IdNuevo, string estadoActual)
    {
        Usuario_Backup__c ubackActual = null;

        if (IdActual != 'NO_ID')
        {
            ubackActual = [SELECT Id, Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Descartadas__c, Colaboraciones_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdActual];

            /*if (ubackActual == null)
            {
                return 'UBACK_ACTUAL_NOEXISTE';
            }*/
        }          

        system.debug('@@@@ Entrada ActualizaResponsable_Colaboracion  -->  IdActual : '+ IdActual+'   -  IdNuevo: '+IdNuevo+' - estadoActual: '+estadoActual);
              
        Usuario_Backup__c ubackNuevo = [SELECT Id, Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Descartadas__c, Colaboraciones_Total__c FROM Usuario_Backup__c  
                                    WHERE Id =: IdNuevo];        
      
        if (ubackNuevo == null)
        {
            return 'UBACK_NUEVO_NOEXISTE';
        }

        try 
        {
            if (estadoActual == 'No Iniciada')
            {                
                if (ubackActual != null)
                {
                    if (ubackActual.Colaboraciones_Sin_Iniciar__c > 0)
                    {
                        ubackActual.Colaboraciones_Sin_Iniciar__c = ubackActual.Colaboraciones_Sin_Iniciar__c - 1;
                    }
                }               

                ubackNuevo.Colaboraciones_Sin_Iniciar__c = ubackNuevo.Colaboraciones_Sin_Iniciar__c + 1;
            }
            else if (estadoActual == 'En Curso')
            {
                if (ubackActual != null)
                {
                    if (ubackActual.Colaboraciones_En_Curso__c > 0)
                    {
                        ubackActual.Colaboraciones_En_Curso__c = ubackActual.Colaboraciones_En_Curso__c - 1;
                    }
                }

                ubackNuevo.Colaboraciones_Sin_Iniciar__c = ubackNuevo.Colaboraciones_Sin_Iniciar__c + 1;                
            }

            if (ubackActual != null)
            {
                ubackActual.Colaboraciones_Total__c = ubackActual.Colaboraciones_Sin_Iniciar__c + ubackActual.Colaboraciones_En_Curso__c + ubackActual.Colaboraciones_Completada__c + ubackActual.Colaboraciones_Rechazada__c + ubackActual.Colaboraciones_Descartadas__c;
            }
            
            ubackNuevo.Colaboraciones_Total__c = ubackNuevo.Colaboraciones_Sin_Iniciar__c + ubackNuevo.Colaboraciones_En_Curso__c + ubackNuevo.Colaboraciones_Completada__c + ubackNuevo.Colaboraciones_Rechazada__c + ubackNuevo.Colaboraciones_Descartadas__c;


            if (ubackActual != null)
            {
                update ubackActual;
            }
            
            update ubackNuevo;

            return 'RESPONSABLES_ACTUALIZADO';
            
        } catch (Exception ex) {
            system.debug('@@@@ Exc ActualizaResponsable_Colaboraciones  -->'+ ex.getLineNumber()+'   <--->  '+ex.getMessage());
            return 'RESPONSABLES_ERROR';
        }        
    }
}