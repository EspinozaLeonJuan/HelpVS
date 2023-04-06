/*******************************************************************************************
 *  NOMBRE                 : CLS_EscritorioDigital_Internal
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CLS_EscritorioDigital_Internal {
    
    public class Usuario
    {
        public String Nombre { get; set;}

        public String RUT { get; set;}

        public String UserOS { get; set;}

        public String Ip { get; set;}
    }

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

    public static Usuario CargaDatosUsuario(String Id) {
        
        List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = : Id];

        if (lrecords.size() > 0)
        {
            Usuario User = new Usuario();

            User.RUT = lrecords[0].RUT_Usuario__c;   
            User.UserOS = 'GRP_SECURITY\\SALESFORCE';
            User.Ip = lrecords[0].CommunityNickname;           
            
            return User;
        }

        return null;
    }  
}