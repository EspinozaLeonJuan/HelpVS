/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-03-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class CLS_CC_LogContactCenter {
    public CLS_CC_LogContactCenter() {
  
    }

    public static String InsertLog(String rut, Integer opcion, String idLlamada, String telefonoIn, String telefonoOut)
    {
        try 
        {
            Contact_Center_Log__c contactCenter = new Contact_Center_Log__c();
            
            contactCenter.RUT__c = rut;
            contactCenter.IdLlamada__c  = idLlamada;
            contactCenter.Opcion_Llamada__c = opcion; 
            contactCenter.TelefonoIn__c = telefonoIn;   
            contactCenter.TelefonoOut__c =  telefonoOut; 
            contactCenter.Fecha_Creacion__c = GetTime();

            insert contactCenter;    

            return contactCenter.Id;

        } catch (Exception ex) {
            system.debug('@@@@ InsertLog -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
            return 'error';
        }
    }

    
    public static String InsertLog(String rut, Integer opcion, String idLlamada, String telefonoIn, String telefonoOut, String idSalesforce, String caseNumber)
    {
        try 
        {
            Contact_Center_Log__c contactCenter = new Contact_Center_Log__c();
            
            contactCenter.RUT__c = rut;
            contactCenter.IdLlamada__c  = idLlamada;
            contactCenter.IdSalesforce__c  = idSalesforce;
            contactCenter.Opcion_Llamada__c = opcion; 
            contactCenter.TelefonoIn__c = telefonoIn;   
            contactCenter.TelefonoOut__c =  telefonoOut; 
            contactCenter.Fecha_Creacion__c = GetTime();

            if (String.isNotBlank(caseNumber))
            {
                contactCenter.NumeroCaso__c = caseNumber;
            }

            insert contactCenter;    

            return contactCenter.Id;

        } catch (Exception ex) {
            system.debug('@@@@ InsertLog -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
            return 'error';
        }
    }

    public static String InsertLog_Account(String idCuenta, String idSalesforce, Integer opcion, String telefonoIn, String telefonoOut, String caseNumber, String response)
    {
        try 
        {
            Account cuenta = [SELECT Id, Name, RUT__c, DV__c, Rut_con_dv__c FROM Account WHERE Id =: idCuenta];

            Contact_Center_Log__c contactCenter = new Contact_Center_Log__c();
            
            contactCenter.RUT__c = cuenta.Rut_con_dv__c;
            contactCenter.RUT_SF__c = cuenta.Rut_con_dv__c;
            contactCenter.EsCliente__c = true;
            contactCenter.IdSalesforce__c  = idSalesforce;//TaskId
            contactCenter.Opcion_Llamada__c = opcion; 
            contactCenter.TelefonoIn__c = telefonoIn;   
            contactCenter.TelefonoOut__c =  telefonoOut; 
            contactCenter.AccountId__c = idCuenta;
            contactCenter.Nombre__c = cuenta.Name;
            contactCenter.Fecha_Creacion__c = GetTime();
            contactCenter.Fecha_Actualizacion__c = contactCenter.Fecha_Creacion__c;
            contactCenter.Respuesta_Llamada__c = response;
            if (String.isNotBlank(caseNumber))
            {
                contactCenter.NumeroCaso__c = caseNumber;
            }

            insert contactCenter;    

            return contactCenter.Id;

        } catch (Exception ex) {
            system.debug('@@@@ InsertLog_Account -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
            return 'error';
        }
    }

    public static String InsertLog_Lead(String idProspecto, String idSalesforce, Integer opcion, String telefonoIn, String telefonoOut, String caseNumber, String response)
    {
        try 
        {
            Lead prospecto = [SELECT Id, Name, LastName, RUT__c FROM Lead WHERE Id =: idProspecto];

            Contact_Center_Log__c contactCenter = new Contact_Center_Log__c();
            
            contactCenter.RUT__c = prospecto.RUT__c;
            contactCenter.RUT_SF__c = prospecto.RUT__c;
            contactCenter.EsCliente__c = true;
            contactCenter.IdSalesforce__c  = idSalesforce;//TaskId
            contactCenter.Opcion_Llamada__c = opcion; 
            contactCenter.TelefonoIn__c = telefonoIn;   
            contactCenter.TelefonoOut__c =  telefonoOut; 
            contactCenter.LeadId__c = idProspecto;
            contactCenter.Nombre__c = prospecto.Name + ' '+ prospecto.LastName;
            contactCenter.Fecha_Creacion__c = GetTime();
            contactCenter.Fecha_Actualizacion__c = contactCenter.Fecha_Creacion__c;
            contactCenter.Respuesta_Llamada__c = response;
            if (String.isNotBlank(caseNumber))
            {
                contactCenter.NumeroCaso__c = caseNumber;
            }

            insert contactCenter;    

            return contactCenter.Id;

        } catch (Exception ex) {
            system.debug('@@@@ InsertLog_Lead -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
            return 'error';
        }
    }

    public static void UpdateLog(String id, String rut, Boolean esCliente)
    {
        try
        {
            Contact_Center_Log__c log = [SELECT Id, RUT_SF__c, EsCliente__c, IdSalesforce__c, Fecha_Actualizacion__c FROM Contact_Center_Log__c WHERE ID =: id];

            if (log != null)
            {
                log.RUT_SF__c = rut;
                log.EsCliente__c = esCliente;
                log.Fecha_Actualizacion__c = GetTime();
                update log;
            }
        } 
        catch (Exception ex) 
        {
            system.debug('@@@@ UpdateLog -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
        }
    }

    public static void UpdateLog_Ok_Account(String id, String rut,  String idSalesforce, String idCuenta, String nombre, String caseNumber)
    {
        try
        {
            Contact_Center_Log__c log = [SELECT Id, RUT_SF__c,Estado__c, EsCliente__c, IdSalesforce__c, AccountId__c, Nombre__c, Fecha_Actualizacion__c FROM Contact_Center_Log__c WHERE ID =: id];

            if (log != null)
            {
                log.RUT_SF__c = rut;
                log.Estado__c = 'OK';
                log.EsCliente__c = true;
                log.AccountId__c = idCuenta;
                log.Nombre__c = nombre;
                log.IdSalesforce__c = idSalesforce;
                log.Fecha_Actualizacion__c = GetTime();
            
                if (String.isNotBlank(caseNumber))
                {
                    log.NumeroCaso__c = caseNumber;
                }

                update log;
            }
        } 
        catch (Exception ex) 
        {
            system.debug('@@@@ UpdateLog_Ok_Account -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
        }
    }

    public static void UpdateLog_Ok_Lead(String id, String rut,  String idSalesforce, String idProspecto, Boolean prospectoCargado, String caseNumber)
    {
        system.debug('@@@@ id -->'+ id);
        system.debug('@@@@ rut -->'+ rut);
        system.debug('@@@@ idSalesforce -->'+ idSalesforce);
        system.debug('@@@@ idProspecto -->'+ idProspecto);
        system.debug('@@@@ prospectoCargado -->'+ prospectoCargado);
        try
        {
            Contact_Center_Log__c log = [SELECT Id, RUT_SF__c,Estado__c, EsCliente__c, IdSalesforce__c, ProspectoCargado__c , LeadId__c, Fecha_Actualizacion__c FROM Contact_Center_Log__c WHERE ID =: id];
            system.debug('@@@@ log -->'+ log);
            if (log != null)
            {
                log.RUT_SF__c = rut;
                log.Estado__c = 'OK';
                log.EsCliente__c = false;
                log.LeadId__c = idProspecto;
                log.ProspectoCargado__c = prospectoCargado;
                log.Fecha_Actualizacion__c = GetTime();
                log.IdSalesforce__c = idSalesforce;
                
                if (String.isNotBlank(caseNumber))
                {
                    log.NumeroCaso__c = caseNumber;
                }
                
                upsert log;
                system.debug('@@@@ log1 -->'+ log);
            }
        } 
        catch (Exception ex) 
        {
            system.debug('@@@@ UpdateLog_Ok_Lead -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
        }
    }

    public static void UpdateLog_Error(String id, String estado, String excepcion)
    {
        try
        {
            Contact_Center_Log__c log = [SELECT Id, Estado__c, Excepcion__c, Fecha_Actualizacion__c FROM Contact_Center_Log__c WHERE ID =: id];

            if (log != null)
            {
                log.Estado__c = estado;
                log.Excepcion__c = excepcion;
                log.Fecha_Actualizacion__c = GetTime();

                update log;
            }
        } 
        catch (Exception ex) 
        {
            system.debug('@@@@ UpdateLog_Error -->'+ ex.getMessage()+'  --  '+ ex.getLineNumber());
        }
    }

    private static String GetTime()
    {
        Datetime timeNow = Datetime.now();
        String dateT = String.valueOf(timeNow);
        return dateT;
    } 
}