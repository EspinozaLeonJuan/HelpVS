/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-01-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CM_PolizasVigentes {
    public List<Poliza__c> LST_POLIZAS_CTE {get; set;}
    public string polMandatoria {get; set;}
    public boolean pmanEncontrada {get; set;}
    
    public PageReference PolizasVigentes()
    {
        this.LST_POLIZAS_CTE = cargaPolizasContratante();
        return null;
    }

    public List<Poliza__c> cargaPolizasContratante(){
        List<Poliza__c> lista = new List<Poliza__c>();

        try{
            String rutContratante = ApexPages.CurrentPage().getParameters().get('rutContratante');
            polMandatoria = ApexPages.CurrentPage().getParameters().get('PolizaMandatoria');

            system.debug('@@@@ polMandatoria --> '+polMandatoria);
            
            if(polMandatoria != '')
            {                
                pmanEncontrada = true;
            }
            else
            {
                pmanEncontrada = false;
            }
            
            system.debug('@@@@ rutContratante --> '+rutContratante);
            
            String rut = rutContratante.split('-')[0];
            String idCte = [SELECT Id FROM Account WHERE Rut_contacto__pc =: rut].Id;

            system.debug('@@@@ idCte --> '+idCte);

            lista = [SELECT Id, Name, Rut_Contratante__c,Estatus__c, Nombre_de_Producto__c, Forma_de_Pago__c, 
                                            Institucion_de_Pago__c, Frecuencia_de_Pago__c, Ejecutivo_de_Clientes__c, Prima_Actual__c, 
                                            Prima_Total__c, Moneda_Poliza__c, Categoria_Poliza__c, RecordTypeId, RecordType.Name 
                                    FROM Poliza__c
                                    WHERE Cuenta__c =: idCte AND Estatus__c = 'ACTIVA'
                                    ORDER BY Name ASC];

            system.debug('@@@@ lista --> '+lista);            
        }
        catch(Exception ex)
        {            
        }

        return lista;
    }
    
}