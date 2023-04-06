public class CLS_INV_Case_DerivacionAutomatica {
    public CLS_INV_Case_DerivacionAutomatica() {

    }

    @InvocableMethod 
    public static void Execute (List<String> Ids)
    {
        ToDerivarUR(Ids[0]);
    }


    @future 
    private static void ToDerivarUR (String Id)
    {
        Case caso = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById, CASO_Categoria__c FROM Case WHERE Id =: Id];
            
        if (caso != null)
        {
            List<asignacion_UR__c> reqs = [SELECT  Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, 
            Tipo_Asignacion__c, Asignaci_n__c  FROM   asignacion_UR__c  
            WHERE Detalle_Solicitud__c =: caso.Detalle_Solicitud__c AND Categor_a__c =: caso.CASO_Categoria__c AND Negocio__c =: caso.Negocio__c 
             AND Tipo_de_Registro_del_Caso__c = 'Solicitudes'];
    
            Database.DMLOptions dmo = new Database.DMLOptions();
            String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
            dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
            caso.setOptions(dmo);
            List<Case> lsC = new List<Case>();
            caso.Status = 'Back Office';
            caso.CASO_Deriva_a_UR__c = true;
            lsC.add(caso);
            Database.update(lsC,dmo);
    
            system.debug('@@@@ CASO OWNER (1) '+caso.OwnerId);
            CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();
            CLAsign.AsignarCaso(caso); 
    
            try
            {            
                Case c = [SELECT Id, OwnerId, Status, CASO_Responsable_UR__c, CASO_Resultado_Derivaci_n__c, CreatedById FROM Case WHERE Id =: caso.Id];
                system.debug('@@@@ CASO OWNER (2) '+c.OwnerId);
                CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(c);//Validar si propietario es Manuel Poblete
            }
            catch(Exception ex)
            {
                system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            }   
        }
        
    }
}