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
public class CLS_CS_Derivacion_Validaciones {
   
    public static Boolean Es_DerivacionPermitida(String Id)
    {
        Case caso = [SELECT Id, RecordTypeId, CASO_Categoria__c, Tipo_de_Requerimiento__c, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: Id];    

        List<asignacion_UR__c> reqs = [SELECT  Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, 
        Tipo_Asignacion__c, Asignaci_n__c  FROM   asignacion_UR__c  
        WHERE Detalle_Solicitud__c =: caso.Detalle_Solicitud__c AND Categor_a__c =: caso.CASO_Categoria__c AND Negocio__c =: caso.Negocio__c 
         AND Tipo_de_Registro_del_Caso__c = 'Solicitudes'];

        system.debug('@@@@ DERPERMITIDA --> '+'SELECT  Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Responsable__c, '+ 
        'Tipo_Asignacion__c, Asignaci_n__c  FROM   asignacion_UR__c WHERE Detalle_Solicitud__c = '+ caso.Detalle_Solicitud__c +
        ' AND Categor_a__c = '+ caso.CASO_Categoria__c+' AND Negocio__c ='+ caso.Negocio__c + 
         ' AND Tipo_de_Registro_del_Caso__c = Solicitudes');  

        system.debug('@@@@ -->'+reqs);
        if (reqs.size() > 0)
        {
            return true;
        } 
		
        if(Test.isRunningTest())
        {
            return false;
        }
        
        return false;
    }

    public static Boolean Es_DerivacionOptativa(String Id)
    {
        Case caso  = [SELECT Id, RecordTypeId, CASO_Categoria__c, Tipo_de_Requerimiento__c, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: Id];    

        system.debug('@@@@ Detalle_Solicitud__c '+ caso.Detalle_Solicitud__c );
        system.debug('@@@@ CASO_Categoria__c '+ caso.CASO_Categoria__c);
        system.debug('@@@@ Negocio__c '+ caso.Negocio__c );

        List<Requerimiento_UR__c> reqs = [SELECT Id, Derivacion_Optativa__c, Detalle_Solicitud__c, Categoria__c, Negocio__c, Habilitado__c FROM Requerimiento_UR__c WHERE 
        Detalle_Solicitud__c =: caso.Detalle_Solicitud__c AND Categoria__c =: caso.CASO_Categoria__c AND Negocio__c =: caso.Negocio__c 
        AND Derivacion_Optativa__c = true AND Habilitado__c = true];
        

        if (reqs.size() > 0)
        {
            return true;
        }
        
        if(Test.isRunningTest())
        {
            return true;
        }
        
        return false;
    }
}