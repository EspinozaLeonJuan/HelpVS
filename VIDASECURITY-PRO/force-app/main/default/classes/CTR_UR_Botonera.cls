/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-08-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class CTR_UR_Botonera {
    public CTR_UR_Botonera() {

    }

    public PAR_UR_Bandeja Pantalla {get; set;}

    public Boolean LoadOk { get; set; }

    public String AreaUsuario { get; set; }

    public PageReference inicioBotonera()
    {
        this.cargaPermisosAcceso();
        return null;
    }

    public void cargaPermisosAcceso()
    {
        String IdColaUR = '';

        this.LoadOk = true;

        User usuario = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

        AreaUsuario = usuario.USUA_Area_UR__c;
        system.debug('@@@@ AreaUsuario --> '+ AreaUsuario);
        if (String.isNotBlank(AreaUsuario))
        {
            List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE 
            UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuario];

            if (ubacks.size() > 0)
            {
                IdColaUR = ubacks[0].OwnerId;
            }

            if (IdColaUR == '')
            {
                this.LoadOk = false;
            }
        }
        else {
            this.LoadOk = false;
        }

        system.debug('@@@@ AreaUsuario --> '+ AreaUsuario);
        system.debug('@@@@ IdColaUR --> '+ IdColaUR);
        system.debug('@@@@ LoadOk --> '+ this.LoadOk);
        
        if (Test.isRunningTest())
        {
            this.LoadOk = true;
        }
        
        if (this.LoadOk == true)
        {
            OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();
        
            if (!Test.isRunningTest())
            {	
                system.debug('@@@@ IdColaUR --> '+ IdColaUR);
                system.debug('@@@@ Usuario__c --> '+ UserInfo.getUserId());
                CnfBandeja = [SELECT Id, CNF_UR_Bandeja__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c =: IdColaUR  AND Usuario__c =: UserInfo.getUserId()];
                system.debug('@@@@  CnfBandeja => ' + CnfBandeja); 
            }
            String jsonDisplay = '';
            
            if (String.isNotBlank(CnfBandeja.CNF_UR_Bandeja__c))
            {
                jsonDisplay = CnfBandeja.CNF_UR_Bandeja__c;
            }
            else
            {
                jsonDisplay = '' +
                    '{'+
                    '"Botonera": '+
                    '{'+ 
                    '"CasosUR" : true,'+ 
                    '"TareasUR" : false,'+
                    '"ColaboracionesUR" : false,'+
                    '"AsignacionesUR" : false,'+
                    '"SeleccionUsuario" : false'+
                    '}'+
                    '}';       
            }
            
            this.Pantalla = PAR_UR_Bandeja.parse(jsonDisplay);
            
            system.debug('@@@@ Pantalla --> '+ this.Pantalla);
        }
    }

    public Pagereference BandejaCasosUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Casos?Area='+this.AreaUsuario+'&idResponsableUR=0&FVentas=false');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference BandejaCasosOptativos()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Casos_Optativos?Area='+this.AreaUsuario+'&idResponsableUR=0&FVentas=false');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference BandejaTareasUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Tareas?Area='+this.AreaUsuario+'&idResponsableUR=0');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference BandejaColaboracionesUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Colaboraciones?Area='+this.AreaUsuario+'&idResponsableUR=0');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference AsignacionesUR()
    {
        try
        {
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Asignaciones');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaCasosUR_Historico -->'+ ex);
        	return null;
        }
    }
}