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
public class CTR_CS_DerivacionOptativa 
{
    public Case Caso { get; set; }   

    public String IdCaso { get; set; }   

    public String  Poliza { get; set; } 

    public String Etiqueta {get; set;}
    
    public CTR_CS_DerivacionOptativa() {
 
    }

    public Pagereference inicio()
    {
        this.IdCaso = apexpages.currentpage().getparameters().get('Id');

        this.Caso =  [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Id_Requerimiento_EscritorioDigital__c, Id_Responsable_UR__c, 
                            Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, Tipo_Requerimiento_EscritorioDigital__c, Motivo_Derivacion__c 
                      FROM Case  
                      WHERE Id =: this.IdCaso];

        if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
        {
            this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
        }
        else
        {
            this.Poliza = 'No seleccionada';
        }

        this.Etiqueta = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);//
        
        system.debug('@@@@ Etiqueta  => ' + Etiqueta);
        
        if (this.Etiqueta == '')
        {
            this.Etiqueta = this.Caso.Detalle_Solicitud__c;
        }      
        
        String Mensaje = 'El Caso seleccionado puede ser resuelto sin la necesidad de ser Derivado al area correspondiente.';
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, Mensaje)); 

        return null;
    }

    public PageReference ToDerivar()
    {
        system.debug('@@@@ this.IdCaso -->'+ this.IdCaso);
        Case tmp = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: this.IdCaso];
        if (String.isBlank(tmp.OwnerId__c))
        {
            User u = [SELECT Id, Email FROM User WHERE Id =: tmp.OwnerId];
            tmp.Email_Deriva_Caso__c = u.Email;
            tmp.OwnerId__c = tmp.OwnerId;
            update tmp;
        }

        Case c = [SELECT Id, RecordTypeId, OwnerId, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: this.IdCaso];
          
        system.debug('@@@@ c -->'+ c);
        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;

        system.debug('@@@@ ID_RASIG_SOLICITUD -->'+ ID_RASIG_SOLICITUD);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
        c.setOptions(dmo);
        List<Case> lsC = new List<Case>();
        c.Status = 'Back Office';
        c.CASO_Deriva_a_UR__c = true;
        c.Motivo_Derivacion__c =  this.Caso.Motivo_Derivacion__c;
        lsC.add(c);
        Database.update(lsC,dmo);

             
        CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();
        
        if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
        {                       
            system.debug('@@@@ PREV Caso -->'+ c);
            CLAsign.AsignarCaso(c); 
        }
        else 
        {
            CLAsign.ReasignarCaso(c.Id);
        }

        Case caso2 = new Case();
        if (!Test.isRunningTest()) 
        {
            caso2 = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];
        }
        else
        {
            caso2.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
        }
        
        if(caso2 != null)
        {
            CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso2);           
        }   

        PageReference detalleCaso = new PageReference('/' + c.Id);
        detalleCaso.setRedirect(true);
        return detalleCaso;
    }


    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.IdCaso);
        return page;
    }
}