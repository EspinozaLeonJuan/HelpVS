/*******************************************************************************************
 *  NOMBRE                 : CLS_ProductosContratante
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Retornar Lista de Productos Vigentes
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
global class CLS_ProductosContratante {

    public List<Poliza__c> LST_POLIZAS_CTE {get; set;}

    public string polMandatoria {get; set;}
    public boolean pmanEncontrada {get; set;}
    
    public PageReference cargaProductos(){
        recuperarPolizasContratante();
        return null;
    }
    
    public List<Poliza__c> recuperarPolizasContratante(){
        try{
            string rutContratante = ApexPages.CurrentPage().getParameters().get('rutContratante');
            polMandatoria = ApexPages.CurrentPage().getParameters().get('PolizaMandatoria');
            
            if(polMandatoria != ''){
                pmanEncontrada = true;
            }else{
                pmanEncontrada = false;
            }
            
            string idCte = [SELECT Id FROM Account WHERE Rut_contacto__pc =: rutContratante].Id;
            LST_POLIZAS_CTE = [SELECT Id, Name, Rut_Contratante__c, Estatus__c, Nombre_de_Producto__c, Forma_de_Pago__c, Institucion_de_Pago__c,Frecuencia_de_Pago__c,
                               Ejecutivo_de_Clientes__c, Prima_Actual__c, Prima_Total__c, Moneda_Poliza__c,  Categoria_Poliza__c, RecordTypeId, RecordType.Name
                               FROM Poliza__c
                               WHERE Cuenta__c =: idCte AND 
                               Estatus__c = 'ACTIVA'
                               ORDER BY
                               Name ASC];
            
            
            if(LST_POLIZAS_CTE.size() > 0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'CANTIDAD PÓLIZAS ASOCIADAS AL RUT CONSULTADO => ' + LST_POLIZAS_CTE.size()));
                return LST_POLIZAS_CTE;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'NO EXISTEN PÓLIZAS ASOCIADAS AL RUT CONSULTADO => ' + LST_POLIZAS_CTE.size())); 
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ERROR AL TRATAR DE RECUPERAR LAS PÓLIZAS ASOCIADAS AL RUT CONSULTADO => ' + ex)); 
            return null;
        }
    }
    
    
}