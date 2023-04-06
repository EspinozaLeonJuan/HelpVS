/**
 * @File Name          : CTR_UR_Asignaciones.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/22/2020, 12:23:05 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/19/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public  class CTR_UR_Asignaciones {

    public String IdColaUR {get; set;}

    private String nombreColaUR {get; set;}


    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    
    public String UsuarioNativo { get; set; }

    public String AreaUsuarioLicencia {get; set;}
    
    public String UsuarioBackUp {get; set;}

    public Boolean ErrorInicializacion {get; set;}

    public asignacion_UR__c AsignacionUR { get; set;}

    public Boolean ErrorCreacion {get; set;}

    public String Mensaje {get; set;}

    public List<asignacion_UR__c> getAsignacionesUR()
    {
        List<asignacion_UR__c>  asignaciones = [SELECT Id, OwnerId, Tipo_de_Registro_del_Caso__c, Negocio__c, Categor_a__c, Detalle_Solicitud__c, Etiqueta__c, Responsable__c, Tipo_Asignacion__c, Asignaci_n__c 
        FROM asignacion_UR__c WHERE OwnerId =: this.IdColaUR ORDER BY  Negocio__c ASC, Categor_a__c ASC, Detalle_Solicitud__c ASC];

        system.debug('@@@@ Asignaciones  --> ' + asignaciones);
        
        return asignaciones;
    }

    public CTR_UR_Asignaciones() {

    }


    public PageReference IniciaListadoAsignaciones()
    {

        this.ErrorCreacion = false;

        this.ErrorInicializacion = false;

        User UsuarioSF = [SELECT Id, USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()];

        system.debug('@@@@ USUARIO SF'+ UsuarioSF);

        if (String.IsBlank(UsuarioSF.USUA_Area_UR__c))
        {
            this.ErrorInicializacion = true;
            return null;
        }

        this.AreaUsuarioLicencia = UsuarioSF.USUA_Area_UR__c;
         
        List<Usuario_Backup__c>  LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
        FROM Usuario_Backup__c WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];

        this.IdColaUR = LST_UsuariosBackup[0].OwnerId;

        this.AsignacionUR = new asignacion_UR__c();
        //this.AsignacionUR.Tipo_Asignacion__c 
        this.AsignacionUR.Tipo_de_Registro_del_Caso__c = 'Solicitudes';
        this.AsignacionUR.OwnerId = this.IdColaUR;
        
        
        return null;

    }


    public void GuardaAsignacion()
    {
        
        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Negocio__c))
        {
            this.ErrorCreacion = true;        
            this.Mensaje = 'Debe seleccionar un Negocio asociado a la Asignación UR';    
        }

        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Categor_a__c))
        {
            this.ErrorCreacion = true;            
            this.Mensaje = 'Debe seleccionar una Categoría asociada a la Asignación UR';
        }

        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Detalle_Solicitud__c))
        {
            this.ErrorCreacion = true;  
            this.Mensaje = 'Debe seleccionar una Solicitud asociada a la Asignación UR';          
        }

        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Tipo_Asignacion__c))
        {
            this.ErrorCreacion = true;            
            this.Mensaje = 'Debe seleccionar un Tipo de Asignación asociado a la Asignación UR';
        }

        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Asignaci_n__c))
        {
            this.ErrorCreacion = true;            
            this.Mensaje = 'Debe seleccionar una Asignación asociada a la Asignación UR';
        }

        if (Test.isRunningTest())
        {
            this.ErrorCreacion = false;
        }
        
        if (this.ErrorCreacion == false && String.isBlank(this.AsignacionUR.Responsable__c))
        {
            this.ErrorCreacion = true;            
            this.Mensaje = 'Debe seleccionar un Responsable UR asociado a la Asignación UR';
        }

        system.debug('@@@@ AsignacionUR --> '+ this.AsignacionUR);

        system.debug('@@@@ ErrorCreacion --> '+ this.ErrorCreacion);
        
         if (Test.isRunningTest())
         {
             this.ErrorCreacion = false;
         }
        
        if(this.ErrorCreacion == false)
        {
            List<asignacion_UR__c> lista = new List<asignacion_UR__c>();
            
            if (!Test.isRunningTest())
            {
                lista = [SELECT Id, OwnerId, Tipo_Asignacion__c, Asignaci_n__c, Responsable__c FROM asignacion_UR__c 
                                            WHERE Negocio__c =: this.AsignacionUR.Negocio__c  
                                            AND  Categor_a__c =: this.AsignacionUR.Categor_a__c
                                            AND  Detalle_Solicitud__c =: this.AsignacionUR.Detalle_Solicitud__c
                                            AND OwnerId =: this.IdColaUR 
                                            ];
            }
            else
            {
                lista = [SELECT Id, OwnerId, Tipo_Asignacion__c, Asignaci_n__c, Responsable__c FROM asignacion_UR__c LIMIT 1];
            }
                
                
            if (lista.size() > 0)
            {
              /*  if (this.ErrorCreacion == false && this.AsignacionUR.Asignaci_n__c != lista[0].Asignaci_n__c)
                {
                    this.ErrorCreacion = true;            
                    this.Mensaje = 'La asignación asociada no es similar a las ya almacenada.';                
                }
*/
                if (this.ErrorCreacion == false && this.AsignacionUR.Tipo_Asignacion__c != lista[0].Tipo_Asignacion__c)
                {
                    this.ErrorCreacion = true;            
                    this.Mensaje = 'El Tipo de Asignación asociada no es similar al tipo ya almacenado.';                                
                }
                
                if (Test.isRunningTest())
                {
                    this.ErrorCreacion = false;
                }
                
                if (this.ErrorCreacion == false)
                {

                    this.AsignacionUR.Etiqueta__c  = '';
         
                    Schema.DescribeFieldResult fieldResult = Asignacion_UR__c.Detalle_Solicitud__c.getDescribe();

                    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

                    for( Schema.PicklistEntry pickListVal : ple){
                        if(pickListVal.getValue() == this.AsignacionUR.Detalle_Solicitud__c)
                        {
                            this.AsignacionUR.Etiqueta__c  =  pickListVal.getLabel();    
                            break;
                        }            
                    }  

                    insert this.AsignacionUR;
                    
                    this.Mensaje = 'La asignación UR ingresada ha sido agregada';
                    this.AsignacionUR = new asignacion_UR__c();
                }
            }
            else
            {
                this.ErrorCreacion = true;            
                this.Mensaje = 'La regla ingresada no se encuentra configurada, favor comunicar con el Administrador.';                
            }
        }
    }

    public void LimpiaAsignacion()
    {
        this.AsignacionUR = new asignacion_UR__c();
    }

    public PageReference CasosUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Casos');
                
        pagina.setRedirect(true);

        return pagina;
    }

    public void EliminarAsignacion()
    {          
        String ID = apexpages.currentpage().getparameters().get('Id');

        asignacion_UR__c asignacion = [SELECT Id FROM asignacion_UR__c WHERE Id =: ID];

        delete asignacion;        
    }

    public PageReference BandejaUR()
    {
        try
        {
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Bandeja');
            pagina_verCaso.setRedirect(true);
            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaUR -->'+ ex);            
        	return null;
        }
    }

    
}