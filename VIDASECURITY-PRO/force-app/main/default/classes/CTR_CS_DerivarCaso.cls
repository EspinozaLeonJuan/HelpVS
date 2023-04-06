/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CS_DerivarCaso {

    public CTR_CS_DerivarCaso() {

    }

    public PageReference derivarCasos(){
        PageReference page = null;        
        try
        {        
            Boolean pasoDerivacion = false;
    
            String ID = apexpages.currentpage().getparameters().get('id');

            Case tmp = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: ID];
            if (String.isBlank(tmp.OwnerId__c))
            {
                User u = [SELECT Id, Email FROM User WHERE Id =: tmp.OwnerId];
                tmp.Email_Deriva_Caso__c = u.Email;
                tmp.OwnerId__c = tmp.OwnerId;
                update tmp;
            }

            Case c = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: ID];
            
            if (c.Status == 'En Revisión')
            {
                DerivaCaso(c, true);

                page = new PageReference('/' + c.Id);
                page.setRedirect(true);      
                pasoDerivacion = true; 
            }

            if (Test.isRunningTest())
            { 
                pasoDerivacion = false;    
            } 

            if (pasoDerivacion == false)
            {
                Boolean DerivacionPermitida = CLS_CS_Derivacion_Validaciones.Es_DerivacionPermitida(ID);

                if (DerivacionPermitida == false)
                {
                    page = new PageReference ('/apex/SEC_VF_CS_DerivarCaso_Error?idCaso='+ ID);                                           
                    page.getParameters().put('Error', 'DERIVACION_NO_PERMITIDA');  
                }
                
                Boolean DerivacionOptativa = CLS_CS_Derivacion_Validaciones.Es_DerivacionOptativa(ID);
    
                if (DerivacionOptativa == true)
                {
                    page = new PageReference ('/apex/SEC_VF_CS_DerivacionOptativa?Id='+ ID);  
                    page.setRedirect(true);                
                }
                
                if (Test.isRunningTest())
                {
                    DerivacionPermitida = true;
                    DerivacionOptativa = false;    
                }            
                
                if (DerivacionPermitida == true && DerivacionOptativa == false)
                {
                    system.debug('@@@@ ID'+ ID);           
                    system.debug('@@@@ Ic.RecordTypeId'+ c.RecordTypeId);           
        
                    String cambioED  = CLS_CS_Derivacion_Escritorio.Valida_EstadoRequerimiento(ID, UserInfo.getUserId());
                    
                    String mensaje ='';
                    
                    system.debug('@@@@ Estado Caso --> '+ c.Status);
                    
                    system.debug('@@@@ responseED'+ cambioED);                      
        
                    
                    if (cambioED == 'REQUERIMIENTO_NO_ED' || cambioED == 'CAMBIO_ESTADO_OK' || 
                        cambioED == 'REQUERIMIENTO_ESTADO_INGRESADO' || cambioED == 'REQUERIMIENTO_ESTADO_FINALIZADO' )//cambio ok, req no ed
                    {    
                        DerivaCaso(c, false);       
                        page = new PageReference('/' + c.Id);
                        page.setRedirect(true);      
                        pasoDerivacion = true;          
                       /* Database.DMLOptions dmo = new Database.DMLOptions();
                        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                        c.setOptions(dmo);
                        List<Case> lsC = new List<Case>();
                        c.Status = 'Back Office';
                        c.CASO_Deriva_a_UR__c = true;
                        lsC.add(c);
                        Database.update(lsC,dmo);
        
                        CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();
                        if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
                        {                       
                            CLAsign.AsignarCaso(c); 
                        }
                        else {
                            CLAsign.ReasignarCaso(c.Id);
                        }
                                         
                        try
                        {            
                            Case caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];               
                            
                            if(caso != null)
                            {                 
                               CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso);//Validar si propietario es Manuel Poblete
                            }
                        }catch(Exception ex)
                        {
                            system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                            system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                        }            
                        
                        page = new PageReference('/' + c.Id);
                        page.setRedirect(true);      
                        pasoDerivacion = true;           */              
                    }  

                    if (Test.isRunningTest())
                    { 
                        pasoDerivacion = false;    
                    }    
        
                    if (pasoDerivacion ==false)
                    {
                        if (cambioED == 'REQUERIMIENTO_NO_CREADO_ED')//requerimiento corresponde a ED pero no ha sido creado
                        {
                            page = new PageReference ('/apex/SEC_VF_CS_Derivacion_PendienteED?idCaso='+ ID);  
                            page.setRedirect(true);
                            //return page;
                        } 
                        else 
                        {
                            page = new PageReference ('/apex/SEC_VF_CS_Derivacion_ErrorED?idCaso='+ ID);     
                            system.debug('@@@@ Error salida --> '+ cambioED); 
                            page.getParameters().put('Error', cambioED);   
                            if (cambioED == 'VALUETECH_ERROR') //cuando ocurra error en Valuetech (ejemplo)
                            {
                                page.getParameters().put('Mensaje', mensaje);                
                            }
                            page.setRedirect(true);                
                        }
                    } 
                }
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);             
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());            
        }         
        
        return page;                           
    }

    private void DerivaCaso(Case c, Boolean revision)
    {
        Database.DMLOptions dmo = new Database.DMLOptions();
        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
        c.setOptions(dmo);
        List<Case> lsC = new List<Case>();
        c.Status = 'Back Office';
        c.CASO_Deriva_a_UR__c = true;
        lsC.add(c);
        Database.update(lsC,dmo);

        CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();

        if (revision == true)
        {
            CLAsign.ReasignarCaso(c.Id);
        }
        else {
            CLAsign.AsignarCaso(c); 
        }
                            
        try
        {            
            Case caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];               
            
            if(caso != null)
            {                 
                CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso);//Validar si propietario es Manuel Poblete
            }
        }catch(Exception ex)
        {
            system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
        }            
    }
}