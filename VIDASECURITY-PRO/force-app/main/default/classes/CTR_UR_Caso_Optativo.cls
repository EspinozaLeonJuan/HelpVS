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
public  class CTR_UR_Caso_Optativo {

    public String IdCaso {get; set;}
    public String Estado {get; set;}

    public Set<String> ORIGENES = new Set<String>{'Cobranzas Vida','Recepción Pagos','Producción Individuales'};

    public Case Caso {get; set;}

    public Case Padre {get; set;}
    
    public String Ejecutivo {get; set;}

    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Task> LST_TareasCasoUR {get; set;}

    public List<Adjunto__c> LST_Adjuntos {get; set;}

    public Boolean Existen_adjuntos {get; set;}
    
    /*  Variables utilizadas en comunicación con Escritorio Digital*/  
    public Integer Persistencia {get; set;}
    public String IdRequerimiento {get; set;}
    public String RutUsuario {get; set;}
    public String Apodo {get; set;}
    public String UserOS {get; set;}
    /*  Variables utilizadas en comunicación con Escritorio Digital*/
    
    public Boolean EscritorioDigital {get; set;}

    public String TaskRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

    /* Popup */

  
    /* Popup */
    
   
    public String Titulo {get; set;}

    public String RUTCarga{get; set;}

    public Boolean especialTeleventa {get; set;}

    public List<SelectOption> EmailsSelect  = new List<SelectOption>();   

    public Boolean AdjuntoPadre { get; set; }

    public PAR_UR_CASO Pantalla {get; set;}

    public String IdColaUR {get; set;}

    private String nombreColaUR {get; set;}

    public String AreaUsuarioLicencia {get; set;}

    public PageReference IniciaCaso()
    {
        this.CargaParametros_Caso();

        Boolean exito = this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.cargaCaso();
             return null;
        }
        else {
            return ErrorAcceso();
        }
    } 

    public PageReference ErrorAcceso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ErrorAcceso');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }
 
    /*Método para mostrar caso seleccionado y su información relacionada*/
    public void cargaCaso()
    {
        OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();
        
        if (!Test.isRunningTest()){
        	CnfBandeja = [SELECT Id, CNF_UR_Caso__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c =: this.IdColaUR  AND Usuario__c =: UserInfo.getUserId()];
        	system.debug('@@@@  CnfBandeja => ' + CnfBandeja);    
        }
        
        String jsonDisplay = '';

        if (String.isNotBlank(CnfBandeja.CNF_UR_Caso__c))
        {
            jsonDisplay = CnfBandeja.CNF_UR_Caso__c;
        }
        else
        {

            jsonDisplay =		'{'+
		'	"Eventos" : '+ 
		'	{ '+
		'		"EscritorioDigital": false, '+
		'		"EnvioCorreo": false, '+
		'		"AdjuntosValuetech": true, '+
		'		"Adjuntos": true, '+
		'		"Comentarios" : true,'+
		'		"TareasUR" : true,'+
		'		"EnProceso" : false,' +
		'		"RetornoEjecutiva" : false,' +
		'		"Rechazar" : true, '+
		'		"Cerrar" : true, '+
		'       "ActualizaACSEL" : true, '+
		'		"ReasignarResponsable" : true,'+
		'		"Contacto" : true,'+
		'		"Propuesta" : true,'+
		'		"Asunto" : true,'+
		'		"FechaCreacion" : true,'+
		'		"Ejecutivo" : true,'+
		'		"Canal" : true,'+
		'		"FechaCierre" : true,'+
		'		"Agente" : true,'+
		'		"MontoRescate"  : true,'+
		'		"SubEstadoACSEL"  : true'+
		'	}'+
		'}';
        }
       
        this.Pantalla = PAR_UR_CASO.parse(jsonDisplay);

        this.AdjuntoPadre = false;
        this.EscritorioDigital = false;
        this.IdRequerimiento = '';
        this.especialTeleventa = false;

        system.debug('@@@@ Pantalla --> '+this.Pantalla);

        try
        {
            this.Caso = new Case();
            
            if (this.IdCaso != '')
            {
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,  
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,  
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                            Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, CASO_Poliza_Asoc__c, Frecuencia_de_Pago__c, Prima_Total_Final__c,
                            Monto_Rescate__c, Sub_Estado_Acsel__c, OwnerId__c, CASO_Deriva_a_UR__c, Motivo_Derivacion__c 
                            FROM Case WHERE Id =: this.IdCaso];

                    this.Padre = [SELECT Id FROM Case WHERE Id =: this.Caso.ParentId];

                    List<User> us =  [SELECT Name FROM User WHERE Id =: this.Caso.OwnerId__c];
                    if (us.size() > 0)
                    {
                        this.Ejecutivo = us[0].Name;
                    }
                }
                else 
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);       
                }

                this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                                FROM CaseComment
                                                WHERE ParentId =: this.Caso.Id
                                                ORDER BY CreatedDate DESC];
    
                if (this.Pantalla.Eventos.AdjuntosValuetech == true)
                {
                    this.LST_Adjuntos = [SELECT Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, UrlTex__c , Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c 
                    WHERE IdCaso__c =: this.Caso.Id ORDER BY CreatedDate DESC];

                    system.debug('@@@@ QRY --> '+ 'SELECT Tipo_Documento__c, UrlDoc__c, Nombre_Documento__c, Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c WHERE IdCaso__c ='+ this.Caso.Id +' ORDER BY CreatedDate DESC');    
                    system.debug('@@@@ LST_Adjuntos SIZE --> '+this.LST_Adjuntos.size());  

                    if (this.LST_Adjuntos.size() > 0)
                    {
                        this.Existen_adjuntos = true;
                    }
                }

                if (this.Pantalla.Eventos.Adjuntos == true && ORIGENES.contains(this.Caso.Origin))
                {
                    this.AdjuntoPadre = true;
                }
            
                if (this.Pantalla.Eventos.TareasUR == true)
                {
                    this.LST_TareasCasoUR = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Solicitud__c  from Task where RecordTypeId =: this.TaskRecordTypeId AND whatId=: this.Caso.Id ORDER BY CreatedDate desc];
                }

                
                this.Estado = this.Caso.Status;

                if (this.Pantalla.Eventos.EscritorioDigital == true)
                {
                    this.ValidaEscritorioDigital();  
                }

                if (this.Caso.EsNoCliente__c == true)
                {
                    this.Titulo = 'Gestión Caso - No Cliente';
                    this.RUTCarga = this.Caso.RUT_no_Cliente__c;
                }
                else {
                    this.Titulo = 'Gestión Caso - Cliente';
                    this.RUTCarga = this.Caso.RUT__c;
                }

                if (this.Caso.Canal__c == 'Televenta' && this.Caso.Detalle_Solicitud__c == 'ED - Endoso Aumento de Prima en Exceso')
                {
                    this.especialTeleventa = true;//    
                }
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
            }       
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR CARGA CASO --> '+ex);    
        } 
    }

    public Boolean CargaUsuario()
    {        
        User UsuarioSF = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

        system.debug('@@@@ USUARIO SF'+ UsuarioSF);
        system.debug('@@@@ USUARIO Id'+ UsuarioSF.Id);
        system.debug('@@@@ USUARIO Area'+ UsuarioSF.USUA_Area_UR__c);

        if (String.IsBlank(UsuarioSF.USUA_Area_UR__c))
        {
           return false;
        }

        this.AreaUsuarioLicencia = UsuarioSF.USUA_Area_UR__c;
        
       // List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND Usuario__c =: UsuarioSF.Id];
        //List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: UsuarioSF.USUA_Area_UR__c];
        
        List<Usuario_Backup__c> ubackps = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
        FROM Usuario_Backup__c
        WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
        
        system.debug('@@@@  LST_UsuariosBackup[0 => ' + ubackps[0].OwnerId);
        
        if (!Test.isRunningTest()){
            this.IdColaUR = ubackps[0].OwnerId;           
            this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;            
        }
        else
        {
            Group gQuery = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 1];
            this.IdColaUR = gQuery.Id;        
            this.nombreColaUR = gQuery.Name;        
        }

        return true;
    } 

    public void ValidaEscritorioDigital()
    {   
        if (String.isBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c) == false)
        {
            this.IdRequerimiento = this.Caso.Id_Requerimiento_EscritorioDigital__c;    

            if (this.Pantalla.Eventos.EscritorioDigital == true)
            {
                this.EscritorioDigital = true;
            }            
        }

        if (this.IdRequerimiento != '')
        {
            this.Apodo = '';
            this.UserOS = '';
            
            List<User> lusers = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
            
            if (lusers.size() > 0)
            {
                this.RutUsuario = lusers[0].RUT_Usuario__c;      
                this.Apodo = lusers[0].CommunityNickname;
                this.UserOS = 'GRP_SECURITY\\SALESFORCE';                 
            }
    
            if (this.RutUsuario != '')
            {
                CLS_EscritorioDigital_Consume.Respuesta_Persistencia respuesta = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.UserOS, this.apodo);                     
                this.Persistencia = respuesta.IdPersistencia; 
            }
            else
            {
                this.Persistencia = -8;
            }
          
            system.debug('@@@@ 01.Persistencia' + this.Persistencia);
            system.debug('@@@@ 01.IdRequerimiento' + this.IdRequerimiento);
            system.debug('@@@@ 01.RutUsuario' + this.RutUsuario);
        }
       
    }

   
    public void CargaParametros_Caso()
    {
        this.IdCaso = apexpages.currentpage().getparameters().get('Id');

        system.debug('@@@@ IdCaso'+ this.IdCaso);

    }

    

    public PageReference CasosOptativos()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Casos_Optativos');
                
        pagina.setRedirect(true);

        return pagina;
    }




    public Boolean Es_EndosoIndividual(String solicitud)
    {
        List<asignacion_UR__c> lista = [SELECT Id FROM asignacion_UR__c WHERE Categor_a__c = 'ENDOSO IND' AND 
        Detalle_Solicitud__c =: solicitud];

        if (lista.size() > 0)
        {
            return true;
        }

        return false;
    }


}