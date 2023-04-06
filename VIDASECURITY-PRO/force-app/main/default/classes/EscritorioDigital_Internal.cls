public class EscritorioDigital_Internal {
	
    public static String Etiqueta(String Solicitud)
    {
        String Etiqueta = '';
        
        List<Escritorio__c> lrecords = [Select Id, Name, Nombre_API__c, Etiqueta_ED__c, Tipo_Requerimiento_ED__c, Solicitante__c from Escritorio__c 
         where Nombre_API__c =: Solicitud order by Tipo_Requerimiento_ED__c asc];
                
        if (lrecords.Size() > 0)
        {
            Etiqueta = lrecords[0].Etiqueta_ED__c;
        }
        
        return Etiqueta;
        
    }  
        

	public static List<SelectOption> getListaSolicitantes(String Solicitud) {        
        List<SelectOption> options = new List<SelectOption>();  
        List<Escritorio__c> lrecords = [Select Id, Name, Nombre_API__c, Etiqueta_ED__c, Tipo_Requerimiento_ED__c, Solicitante__c from Escritorio__c 
         where Nombre_API__c =: Solicitud order by Tipo_Requerimiento_ED__c asc];
                
        if (lrecords.Size() > 0)
        {
            for(Escritorio__c escritorio: lrecords) {
           		 options.add(new SelectOption(escritorio.Tipo_Requerimiento_ED__c,escritorio.Solicitante__c));
       		}
        }
        
        return options; 
    }
    
 
    public static String Solicitante(String Tipo)
    {
        List<Escritorio__c> lrecords = [Select Id, Name, Nombre_API__c, Etiqueta_ED__c, Tipo_Requerimiento_ED__c, Solicitante__c from Escritorio__c 
         where Tipo_Requerimiento_ED__c =: Tipo order by Tipo_Requerimiento_ED__c asc];
                
        if (lrecords.Size() > 0)
        {
            return lrecords[0].Solicitante__c;
        }
        
        return '';
    }
    
    public static Boolean EsUsuarioValido()
    {
        String pId_a  = [Select Id FROM Profile where Name = 'Ejecutivo Call Center'][0].Id;
        String pId_b  = [Select Id FROM Profile where Name = 'Ejecutivo Call Center (WEB)'].Id;
        String pId_c  = [Select Id FROM Profile where Name = 'Supervisor Call Center'].Id;
        
        system.debug('@@@@ UserInfo'+ UserInfo.getUserId());
		List<User> lrecords = [ Select Id  From User Where  RUT_Usuario__c = '13287055-1' 
                               Or RUT_Usuario__c = '17517441-9' Or RUT_Usuario__c = '17485712-1' 
                               Or RUT_Usuario__c = '13076268-9'Or RUT_Usuario__c = '12715628-k'
                               Or RUT_Usuario__c = '16074276-3' 
                               Or RUT_Usuario__c = '7672011-8' Or RUT_Usuario__c = '9118493-1'
                               Or RUT_Usuario__c = '7555264-5' Or RUT_Usuario__c = '9806826-0'                               
                               Or RUT_Usuario__c = '17266585-3' Or RUT_Usuario__c = '13989668-8'
                               Or RUT_Usuario__c = '24666461-7' Or RUT_Usuario__c = '10664154-4'
                               Or RUT_Usuario__c = '10896641-6' Or RUT_Usuario__c = '16282760-k'   
                               Or RUT_Usuario__c = '15128315-2' 
                               Or RUT_Usuario__c = '16942371-7'                                 
                               Or RUT_Usuario__c = '14165309-1'  Or RUT_Usuario__c = '15620709-8'
                               Or RUT_Usuario__c = '13885774-3'  Or RUT_Usuario__c = '9645972-6'
                               Or RUT_Usuario__c = '12490047-6'  Or RUT_Usuario__c = '14168359-4'
                               Or RUT_Usuario__c = '13900244-K'
                               Or RUT_Usuario__c = '16150658-3'
                               Or RUT_Usuario__c = '12870148-6' Or RUT_Usuario__c = '12272473-5'
                               Or RUT_Usuario__c = '12403487-6' Or RUT_Usuario__c = '12548759-9'
                               Or RUT_Usuario__c = '12492219-4' Or RUT_Usuario__c = '12443356-8'
                               Or RUT_Usuario__c = '9641972-4'                               
                               Or ProfileId =: pId_a Or ProfileId =: pId_b Or ProfileId =: pId_c];
        
        system.debug('@@@@ lrecords Users'+ lrecords);
        system.debug('@@@@ lrecords Users size'+ lrecords.size());
        if (lrecords.size() > 0)
        {
             for (User rt : lrecords) {
                if (rt.Id == UserInfo.getUserId())
                {
                    system.debug('@@@@ salida EsUsuarioValido --> true');
                    return true;
                }
            	//String etiqueta = ;
             }        
        }    
        system.debug('@@@@ salida EsUsuarioValido --> false');
        return false;
	}
    
    public static Boolean RequerimientoEDIND(String Solicitud)
    {
        Boolean exito = false;
        
        if (Solicitud == 'Devolución por Excepción Comercial') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Cambio de Plan APV Max 3.0 y Dominium Max 3.0') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Cambio de Plan Mi Proyecto Seguro y Mi APV Seguro') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Designación y Actualización de Beneficiarios') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Agregar Coberturas') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Aumento de Prima en Exceso') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Cambio Periodicidad de Pago') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Capital Asegurado') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Eliminar Coberturas') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Endoso Modificacion de Prima en Exceso') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Modificación de Tipo de Pago') 
        {
            exito = true;
        }
        else if (Solicitud == 'ED - Solicitud de Rescate Patrimonial') 
        {
            exito = true;
        }
        else if (Solicitud == 'Endosos') 
        {
            exito = true;
        }
        else if (Solicitud == 'On Time - Solicitud Renuncia') 
        {
            exito = true;
        }
        else if (Solicitud == 'Siniestro Catastrófico') 
        {
            exito = true;
        }
        else if (Solicitud == 'Siniestro Individuales') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud copia de póliza') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de ajuste de utilidades') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de Certificados de cobertura') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de Certificados Tributarios') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de copia formulario notificación Ley APV') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de devolución de prima') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de problema con Traspaso In') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de Rescate Parcial') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de Rescate Total') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud de suspensión de primas') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud Devolución de Prima') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud imputación de pagos') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud Otros Endosos') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud Póliza no Aperturada') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud por disconformidad certificado declaraci√≥n renta') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud préstamo') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud refechaje') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud rehabilitación póliza') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud Tarjeta Club Viva') 
        {
            exito = true;
        }
        else if (Solicitud == 'Solicitud valores garantizados') 
        {
            exito = true;
        }

        return exito;
    }
}