/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_CV_Caso                                                                    |
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Gestión de Casos tipo Solicitud para Clientes y No Clientes                    |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public  class CTR_CV_Caso  {
     
    public Case Caso {get; set;}

    public Case CasoPopup {get; set;}

    public String RUT { get; set; }
        
    public Integer Salida {get; set;}

    public String Poliza {get; set;}
    public String RUTCliente { get; set; }     
    
    public String NombreCliente { get; set; }     

    public String RUTC  {get; set;}
    public String DVC  {get; set;}
    
    public String IdCuenta {get; set;}

    public String Resultado  {get; set;}

    public String RUTNoCliente { get; set; }     

    public String NombreNoCliente { get; set; }     
  
    public String IdCaso{get; set;}

    public String IdCasoPopup {get; set;}

    public List<CaseComment> LST_ComentariosCaso {get; set;}

    public List<Adjunto__c> LST_Adjuntos {get; set;}

    public CaseComment Comentario {get; set;}

    public Boolean ResultadoPopup {get; set;}

    public String MensajePopup {get; set;}   

    public String RUTCarga {get; set;}

    public String NombreCarga {get; set;}

    public Boolean Existen_adjuntos {get; set;}

    public Boolean ResultadoCarga {get; set;}

    public String ProspectoNombreOK {get; set;}

    public String LeadId {get; set;}

    public String LeadName {get; set;}

    public String LeadLastName {get; set;}

    public String Titulo {get; set;}

    public String NoCliente_Nombres {get; set;}

    public String NoCliente_Apellidos {get; set;}

    public String ResultadoDerivacion {get; set;}

    public String ResultadoCierre {get; set;}

    public Boolean Boton_Derivar {get; set;}

    public Boolean Boton_Derivar_Optativo {get; set;}

    public Boolean Boton_Cerrar {get; set;}

    public Boolean Boton_Comentario {get; set;}

    public Boolean Boton_Adjunto {get; set;}

    public Boolean Boton_EscritorioDigital {get; set;}

    public Integer NumPoliza {get; set;}

    public String EtiquetaSolicitud {get; set;}

    public String TipoRequerimientoED {get; set;}

    public Integer Persistencia { get; set; }   

    public String  RutUsuario { get; set; }    

    public String  UserOS { get; set; }   

    public String  Ip { get; set; }   

    public Integer IdRequerimiento {get; set;}  
          
    public CLS_EscritorioDigital_Consume.Respuesta_Persistencia RespuestaPersistencia {get; set;}

    public CLS_EscritorioDigital_Consume.Respuesta_Requerimiento RespuestaRequerimiento {get; set;}

    public CLS_EscritorioDigital_Internal.Usuario Usuario {get; set;}

    public String  Solicitante { get; set; }     

    public String  Mensaje { get; set; }     

    public String  TipoDocumentoCarga { get; set; }     

    public String  Procedencia { get; set; }     

    public Pagereference IngresoRUT()
    {
        try 
        {
            this.Salida = 0;
            this.CasoPopup = new Case();
            this.CasoPopup.Negocio__c = 'Seguros Individuales';            
        }
        catch (Exception ex) {
            
        }
 
        return null;
    }

    public Pagereference InicioNuevoCasoCliente()
    {
        try {

            this.Caso = new Case();
            this.Resultado = '';
        
            this.IdCuenta = apexpages.currentpage().getparameters().get('Id');
            this.Caso.Negocio__c  = apexpages.currentpage().getparameters().get('Negocio');
             
            List<Account> cuentas = [Select a.Rut__c, a.Name, a.Id, a.DV__c, a.PersonEmail From Account a where a.Id =: this.IdCuenta ];
            
            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
			system.debug('@@@@ cuentas --> '+cuentas);
            if (cuentas.size() > 0)
            {   
                Account cuenta = cuentas[0];
                this.Caso.RecordTypeId = IdTipoRegistro;
                this.RUTCliente = cuenta.Rut__c+'-'+cuenta.DV__c;
                this.NombreCliente = cuenta.Name;
                this.Caso.AccountId = cuenta.Id;
                this.Caso.Tipo_de_Solicitante__c = 'Contratante';//***
                this.Caso.Canal__c = 'Sucursal';
                this.Caso.AccountId = cuenta.Id;
                this.Caso.OwnerId = UserInfo.getUserId();
                this.Caso.Tipo_de_Cliente__c = 'Cliente Normal';
                this.Caso.Origin = 'Sucursal';
                this.Caso.Priority = 'Media';
                this.Caso.Detalle_Solicitud__c = '';
                this.Caso.Detalle_de_Rescate__c = '';                
                
                this.Salida = 1;    
            }
            else {
                this.Salida = 2;    
            }
        } 
        catch (Exception ex) {
            system.debug('@@@@ Exception --> '+ex);
        }
         return null;
    }

    public void GuardaCasoCliente()
    {
        this.Resultado = '';
        try 
        {
            system.debug('@@@@ Caso Cliente -->'+ this.Caso);
            if (String.isBlank(this.Caso.Detalle_Solicitud__c))
            {
                this.Resultado = 'NOT_DET_SOL';
            }
            else 
            {
                if (this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial' || 
                    this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Patrimonial'|| 
                    this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total' ||
                    this.Caso.Detalle_Solicitud__c == 'Solicitud de Rescate Total' ||
                    this.Caso.Detalle_Solicitud__c == 'Solicitud de Rescate Parcial')
                {
                    if (String.isBlank(this.Caso.Detalle_de_Rescate__c))                    
                    {
                        this.Resultado = 'NOT_DET_RES';                        
                    }
                }
            }

           if (String.isBlank(this.Resultado))
            {
                //SELECT Id,Name, SObjectType  FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Corredor' AND IsActive = true 
                String tipoRegistroCorredor = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Corredor' AND IsActive = true ].Id;
                String tipoRegistroAgente = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Agente' AND IsActive = true ].Id;
                String tipoRegistroComercial = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contactos_Comercial' AND IsActive = true ].Id;
                String tipoRegistroContratante = [SELECT Id FROM RecordType WHERE  SObjectType = 'Contact' AND DeveloperName = 'Contratante' AND IsActive = true ].Id;
                
                system.debug('@@@@ tipoRegistroCorredor --> '+ tipoRegistroCorredor);
                system.debug('@@@@ tipoRegistroAgente --> '+ tipoRegistroAgente);
                system.debug('@@@@ tipoRegistroComercial --> '+ tipoRegistroComercial);
                system.debug('@@@@ tipoRegistroContratante --> '+ tipoRegistroContratante);

                system.debug('@@@@ Contacto QUERY -->'+
                'SELECT Id FROM Contact WHERE RecordTypeId != '+ tipoRegistroCorredor + ' AND  RecordTypeId != '+ tipoRegistroAgente +' AND  RecordTypeId != '+
                 tipoRegistroComercial + ' AND  RecordTypeId !='+ tipoRegistroContratante + ' AND AccountId = '+ this.Caso.AccountId );
                
                List<Contact> contactos = [SELECT Id FROM Contact WHERE RecordTypeId !=: tipoRegistroCorredor AND  RecordTypeId !=: tipoRegistroAgente AND  RecordTypeId !=: tipoRegistroComercial 
                AND  RecordTypeId !=: tipoRegistroContratante AND AccountId =: this.Caso.AccountId];

                system.debug('@@@@ Contacto result --> '+ contactos);

                Case Atencion = new Case();

                String IdTipoRegistroAtencion = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Atencion' AND IsActive = true].Id;

                Atencion.RecordTypeId = IdTipoRegistroAtencion;
                Atencion.AccountId = this.Caso.AccountId;
                Atencion.Tipo_de_Solicitante__c = this.Caso.Tipo_de_Solicitante__c;//***
                Atencion.Canal__c = this.Caso.Canal__c;//***
                Atencion.Negocio__c= this.Caso.Negocio__c;
                Atencion.AccountId = this.Caso.AccountId;
                Atencion.OwnerId = this.Caso.OwnerId;
                Atencion.Id_Usuario_Creacion__c = this.Caso.OwnerId;
                Atencion.Tipo_de_Cliente__c = this.Caso.Tipo_de_Cliente__c; //Cliente Normal
                Atencion.Origin = this.Caso.Origin;
                
                if (contactos.size() > 0)
                {
                    Atencion.ContactId = contactos[0].Id;
                }

                List<Poliza__c> rts = [Select  Id, Name  From Poliza__c 
                                       Where ID =: this.Poliza];
                
                if(rts.size() > 0){
                    this.Caso.CASO_Poliza_Asoc__c = rts[0].Name;
                    this.Caso.CASO_N_Poliza__c = rts[0].Id;
                } 

                Case Requerimiento = this.Caso;
				
                system.debug('@@@@ AgenteId --> '+ this.Caso.Agente__c);
                if (String.isNotBlank(this.Caso.Agente__c))
                {
                    Contact Agente = [SELECT Id, Name, ReportsToId, Sucursal__c, Rut__c, Email, MobilePhone, Phone FROM Contact WHERE Id =: this.Caso.Agente__c];    
                    if (Agente != null)
                    {
                        Atencion.Agente__c = Agente.Id;
                        Atencion.Sucursal__c = Agente.Sucursal__c;                        
                        Atencion.Rut_Agente__c = Agente.Rut__c;
                        Atencion.Mail_Agente__c = Agente.Email;
                        Atencion.Celular_Agente__c = Agente.MobilePhone;
                        Atencion.Telefono_Agente__c = Agente.Phone;                        

                        Requerimiento.Agente__c = Atencion.Agente__c ;
                        Requerimiento.Sucursal__c = Atencion.Sucursal__c;                        
                        Requerimiento.Rut_Agente__c = Atencion.Rut_Agente__c ;
                        Requerimiento.Mail_Agente__c = Atencion.Mail_Agente__c;
                        Requerimiento.Celular_Agente__c = Atencion.Celular_Agente__c;
                        Requerimiento.Telefono_Agente__c = Atencion.Telefono_Agente__c;
                        
                        if (String.isNotBlank(Agente.ReportsToId))
                        {
                            Contact Supervisor = [SELECT Id, Name FROM Contact WHERE Id=: Agente.ReportsToId];
                        
                            if (Supervisor != null)
                            {
                                Atencion.Supervisor__c = Supervisor.Name;
                            }
                        }     
                    }
                }

                if (!Test.isRunningTest())
                {
                	insert Atencion;    
                }         
                
                Requerimiento.Id_Usuario_Creacion__c = this.Caso.OwnerId;
                String IdTipoRegistroSolicitud = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
                Requerimiento.RecordTypeId = IdTipoRegistroSolicitud;
                Requerimiento.RVentas__c = true;//
                Requerimiento.EsNoCliente__c = false;
                Requerimiento.Tipo_de_Requerimiento__c = 'Solicitudes';
                Requerimiento.ParentId = Atencion.Id;                
                Requerimiento.Id_Usuario_Creacion__c = this.Caso.OwnerId;
                Requerimiento.Subject = this.GetDetalleSolicitud(Requerimiento.Detalle_Solicitud__c);
                Requerimiento.ContactId = Atencion.ContactId;                
                if (!Test.isRunningTest())
                {
                	insert Requerimiento;
                } 
                
                this.Resultado = 'OK';
                this.IdCaso = Requerimiento.Id;
                
            }
            
        } catch (Exception ex) {
            this.Resultado = '@@@@ Excepcion '+ex.getMessage()+' line '+ ex.getLineNumber();
            system.debug('@@@@ Excepcion '+ex.getMessage()+' line '+ ex.getLineNumber());
        }
    }

    public Pagereference InicioNuevoCasoNoCliente()
    {
        try {
            this.Caso = new Case();
            this.Resultado = '';
            this.ProspectoNombreOK = 'NO';

            this.RUTNoCliente = apexpages.currentpage().getparameters().get('Rut') + '-' + apexpages.currentpage().getparameters().get('Dv');
            this.LeadId = apexpages.currentpage().getparameters().get('LeadId');
            this.LeadName = apexpages.currentpage().getparameters().get('LeadName');
            this.LeadLastName = apexpages.currentpage().getparameters().get('LeadLastName');
            this.Caso.Negocio__c  = apexpages.currentpage().getparameters().get('Negocio');

            system.debug('@@@@ RUTNoCliente '+ this.RUTNoCliente);
            system.debug('@@@@ LeadId '+ this.LeadId);
            system.debug('@@@@ LeadName '+ this.LeadName);
            system.debug('@@@@ LeadLastName '+ this.LeadLastName);
           
            this.NombreNoCliente = this.LeadName +' '+this.LeadLastName;

            if (String.isNotBlank(this.NombreNoCliente) == true)
            {
                this.ProspectoNombreOK = 'OK';
                this.NoCliente_Nombres = this.LeadName;
                this.NoCliente_Apellidos = this.LeadLastName;
            }

            system.debug('@@@@ NombreNoCliente '+ this.NombreNoCliente);
            system.debug('@@@@ ProspectoNombreOK '+ this.ProspectoNombreOK);
            

            List<Account> cuentas = [Select a.Rut__c, a.Name, a.Id, a.DV__c From Account a where a.Rut__c =: '99999996' ];
           
            system.debug('@@@@ cuentas '+ cuentas);
            
            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;

            if (cuentas.size() > 0)
            {   
                Account cuenta = cuentas[0];
                this.Caso.RecordTypeId = IdTipoRegistro;
                this.Caso.AccountId = cuenta.Id;
                this.Caso.Tipo_de_Solicitante__c = 'Contratante';//***
                this.Caso.Canal__c = 'Sucursal';//***
                //this.Caso.Negocio__c = 'Seguros Individuales';
                this.Caso.OwnerId = UserInfo.getUserId();
                this.Caso.Tipo_de_Cliente__c = 'Cliente Normal';
                this.Caso.Origin = 'Sucursal';
                this.Caso.Priority = 'Media';
                this.Caso.Detalle_Solicitud__c = '';
                this.Caso.Detalle_de_Rescate__c = '';
                this.Caso.RUT_no_Cliente__c = this.RUTNoCliente;
                this.Salida = 1;    
            }
            else {
                this.Salida = 2;    
            }
        } 
        catch (Exception ex) {
            system.debug('@@@@ ex '+ex.getMessage()+' linea: '+ex.getLineNumber());
        }
         return null;
    }

    public void GuardaCasoNoCliente()
    {
        this.Resultado = '';
        try 
        {
            if (String.isNotBlank(this.NoCliente_Nombres) || String.isNotBlank(this.NoCliente_Apellidos))
            {
            	this.Caso.Nombre_no_Cliente__c = this.NoCliente_Nombres+' '+this.NoCliente_Apellidos;    
            }
            else
            {
                this.Caso.Nombre_no_Cliente__c = '';
            }
            
            if (String.isBlank(this.Caso.Nombre_no_Cliente__c))
            {
                this.Resultado = 'NOT_NOM_NC';
            }
            else
            {
                if (String.isBlank(this.Caso.Detalle_Solicitud__c))
                {
                    this.Resultado = 'NOT_DET_SOL';
                }
                else 
                {
                    if (this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial' || 
                        this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Patrimonial'|| 
                        this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total' ||
                        this.Caso.Detalle_Solicitud__c == 'Solicitud de Rescate Total' ||
                        this.Caso.Detalle_Solicitud__c == 'Solicitud de Rescate Parcial')
                    {
                        if (String.isBlank(this.Caso.Detalle_de_Rescate__c))                    
                        {
                            this.Resultado = 'NOT_DET_RES';                        
                        }
                    }
                }
            }
                   
           if (String.isBlank(this.Resultado))
            {
                Case Atencion = new Case();

                String IdTipoRegistroAtencion = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Atencion' AND IsActive = true].Id;

                Atencion.RecordTypeId = IdTipoRegistroAtencion;
                Atencion.AccountId = this.Caso.AccountId;
                Atencion.Tipo_de_Solicitante__c = this.Caso.Tipo_de_Solicitante__c;//***
                Atencion.Canal__c = this.Caso.Canal__c;//***
                Atencion.Negocio__c= this.Caso.Negocio__c;
                Atencion.OwnerId = this.Caso.OwnerId;
                Atencion.Tipo_de_Cliente__c = this.Caso.Tipo_de_Cliente__c;
                Atencion.Origin = this.Caso.Origin;
                Atencion.RUT_no_Cliente__c = this.Caso.RUT_no_Cliente__c;
                Atencion.Nombre_no_Cliente__c = this.Caso.Nombre_no_Cliente__c;
                Atencion.Id_Usuario_Creacion__c = this.Caso.OwnerId;

                Lead Prospecto;

                if (this.LeadId != 'newLead')
                {
                     Prospecto = [SELECT Id, FirstName, LastName  FROM Lead WHERE Id =: this.LeadId];
                }
                else {
                    
                    Prospecto = new Lead();
                    Prospecto.Rut__c = this.RUTNoCliente;
                    
                    if (String.isNotBlank(this.NoCliente_Nombres))
                    {
                        Prospecto.FirstName = this.NoCliente_Nombres;
                        Prospecto.LastName = this.NoCliente_Apellidos;
                    }

                    insert Prospecto;
                }

                Case Requerimiento = this.Caso;

                if (String.isNotBlank(this.Caso.Agente__c))
                {
                    Contact Agente = [SELECT Id, Name, ReportsToId, Sucursal__c, Rut__c, Email, MobilePhone, Phone FROM Contact WHERE Id =: this.Caso.Agente__c];    
                    if (Agente != null)
                    {
                        Atencion.Agente__c = Agente.Id;
                        Atencion.Sucursal__c = Agente.Sucursal__c;                        
                        Atencion.Rut_Agente__c = Agente.Rut__c;
                        Atencion.Mail_Agente__c = Agente.Email;
                        Atencion.Celular_Agente__c = Agente.MobilePhone;
                        Atencion.Telefono_Agente__c = Agente.Phone;

                      	Requerimiento.Agente__c = Atencion.Agente__c ;
                        Requerimiento.Sucursal__c = Atencion.Sucursal__c;                        
                        Requerimiento.Rut_Agente__c = Atencion.Rut_Agente__c ;
                        Requerimiento.Mail_Agente__c = Atencion.Mail_Agente__c;
                        Requerimiento.Celular_Agente__c = Atencion.Celular_Agente__c;
                        Requerimiento.Telefono_Agente__c = Atencion.Telefono_Agente__c;
                        Requerimiento.Supervisor__c = Atencion.Supervisor__c;                        
                        
                        if (String.isNotBlank(Agente.ReportsToId))
                        {
                            Contact Supervisor = [SELECT Id, Name FROM Contact WHERE Id=: Agente.ReportsToId];
                        
                            if (Supervisor != null)
                            {
                                Atencion.Supervisor__c = Supervisor.Name;
                            }
                        }                        
                    }
                }

                Atencion.Lead__c = Prospecto.Id;
                
                if (!Test.isRunningTest())
                {
                    insert Atencion;
                }
                
                Requerimiento.ParentId = Atencion.Id;
                Requerimiento.Lead__c = Prospecto.Id;

                String IdTipoRegistroSolicitud = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
                Requerimiento.RecordTypeId = IdTipoRegistroSolicitud;
                Requerimiento.RVentas__c = true;
                Requerimiento.EsNoCliente__c = true;
                Requerimiento.Tipo_de_Requerimiento__c = 'Solicitudes';
                Requerimiento.Id_Usuario_Creacion__c = this.Caso.OwnerId;
                Requerimiento.Subject = this.GetDetalleSolicitud(Requerimiento.Detalle_Solicitud__c);
                                
                if (!Test.isRunningTest())
                {
                    insert Requerimiento;
                }

                this.Resultado = 'OK';
                this.IdCaso = Requerimiento.Id;
            }
        } catch (Exception ex) {
            this.Resultado = '@@@@ Excepcion '+ex.getMessage()+' line '+ ex.getLineNumber();
            system.debug('@@@@ Excepcion '+ex.getMessage()+' line '+ ex.getLineNumber());
        }
    }


    public String GetDetalleSolicitud(String solicitud)
    {
        String asunto = '';
        
        if(solicitud == 'Declaración Ingresos Actualización')
        {	
            asunto = 'ED - Renovación de Asignación Familiar';
        }					
        else if(solicitud == 'Renuncia Garantía Estatal')
        {	
            asunto = 'ED - Renuncia Garantía Estatal';
        }				
        else if(solicitud == 'Solicitud cambio pago pensión')
        {	
            asunto = 'ED - Solicitud cambio pago pensión';
        }					
        else if(solicitud == 'Solicitud cuota mortuoria')
        {
            asunto = 'ED - Solicitud cuota mortuoria';
        }					
        else if(solicitud == 'Solicitud de incorporación/ Renovación asignación familiar')
        {	
            asunto = 'ED - Solicitud de Asignación Familiar';
        }					
        else if(solicitud == 'Solicitud de Extinción')
        {	
            asunto = 'ED - Solicitud de Extinción Asignación Familiar';
        }				
        else if(solicitud == 'Solicitud garantía estatal')
        {	
            asunto = 'ED - Solicitud garantía estatal';
        }					
        else if(solicitud == 'Solicitud pensión sobrevivencia')
        {	
            asunto = 'ED - Solicitud pensión sobrevivencia';
        }					
        else if(solicitud == 'Solicitud periodo garantizado')
        {	
            asunto = 'ED - Solicitud periodo garantizado';
        }				
        else if(solicitud == 'Sitio web')
        {	
            asunto = 'Sitio web (error o problema)';
        }
        else if(solicitud == 'Siniestro Tradicional Vida COL')
        {	
            asunto = 'Siniestro Tradicional Vida';
        }
        else if(solicitud == 'Solicitud endoso')
        {
            asunto = 'Solicitud endoso a la póliza';
        }					        
        else if(solicitud == 'Solicitud cambio CCAF')
        {
            asunto = 'Solicitud cambio CCAF (Caja Compensación)';
        }
        else if(solicitud == 'Solicitud CCAF')
        {
            asunto = 'Solicitud CCAF (Caja Compensación)';
        }
        else if(solicitud == 'Solicitud de problema con Traspaso In')
        {
            asunto = 'Solicitud de problema con Traspaso In (Entrada)';
        }
        else if(solicitud == 'ED - Solicitud de Rescate Patrimonial')
        {
            asunto = 'Solicitud de Rescate Patrimonial';
        }
        else if(solicitud == 'Solicitud eliminar empleados de planilla (PF-APV)')
        {
            asunto = 'Solicitud eliminar empleados de planilla';
        }
        else if(solicitud == 'Endosos')
        {
            asunto = 'Solicitud Endoso';
        }
        else if(solicitud == 'Solicitud endoso')
        {
            asunto = 'Solicitud endoso a la póliza';
        }
        else if(solicitud == 'Solicitud nuevo FUN')
        {
            asunto = 'ED - Solicitud nuevo FUN';
        }
        else if(solicitud == 'Solicitud préstamo')
        {
            asunto = 'Solicitud préstamo (CDS)';
        }
        else if(solicitud == 'Solicitud valores garantizados')
        {
            asunto = 'Solicitud valores garantizados (CDS)';
        }
        else if(solicitud == 'Solicitud Otros Endosos')
        {
            asunto = 'ED - Solicitud Otros Endosos';
        }
        else if(solicitud == 'ED - Endoso Aumento de Prima en Exceso')
        {
            asunto = 'ED - Endoso Modificacion de Prima en Exceso';
        }
        else if(solicitud == 'ED - Endoso Agregar Coberturas')
        {
            asunto = 'ED - Endoso Agregar Cobertura';
        }
        else if(solicitud == 'ED - Endoso Eliminar Coberturas')
        {
            asunto = 'ED - Endoso Eliminar Cobertura';
        }
        else if(solicitud == 'ED - Modificación de Tipo de Pago')
        {
            asunto = 'ED - Modificación de Tipo de Pago PAC o PAT';
        }

        if (asunto == '')
        {
            asunto = solicitud;
        }
        
        return asunto;
    }

    public void validaRut()
    {
        try {
            this.RUT = this.RUT.trim();
            this.RUTC = this.RUT.split('-')[0];   
            this.DVC  = this.RUT.split('-')[1];           
            String sRut = this.RUT.remove('-');            
            Boolean isValid = RUTUtils.isValid(sRut);
            system.debug('@@@@ sRut '+sRut);
            system.debug('@@@@ run '+this.RUTC);
            if (isValid == true)
            {
                List<Account> cuentas = [Select a.Rut__c, a.Name, a.Id, a.DV__c From Account a where a.Rut__c =: this.RUTC];
                
                if (cuentas.Size() > 0)
                {
                    this.Salida = 1;    
                    this.IdCuenta = cuentas[0].Id;
                }
                else {
                    String rut = this.RUTC +'-'+this.DVC;

                    List<Lead> Prospectos = [SELECT Id, FirstName, LastName  FROM Lead WHERE RUT__c =: rut];
            
                    if (Prospectos.size() == 0)
                    {                        
                        String usuario = [SELECT RUT_Usuario__c FROM User WHERE Id =: UserInfo.getUserId()].RUT_Usuario__c;
                
                        try 
                        {
                            EXT_WS_Equifax.Equifax2Soap WSEquifax = new  EXT_WS_Equifax.Equifax2Soap();
                            
                            EXT_WS_Axonaxis.DatosPersona persona = new EXT_WS_Axonaxis.DatosPersona();
                            
                            if (!Test.isRunningTest())
                            {
                            	persona = WSEquifax.ConsultaPersona(rut , usuario, 'PREDIGITADORES');    
                            }
                            else
                            {
                                persona.PersonaNatural = new EXT_WS_Axonaxis.DatosPersona_PersonaNatural_element();
                                persona.PersonaNatural.Nombre = new EXT_WS_Axonaxis.DatosPersona_PersonaNatural_Nombre_element();
                                persona.PersonaNatural.Nombre.Nombres = 'Juan Gastón';
                                persona.PersonaNatural.Nombre.ApellidoPaterno = 'Espinoza';
                                persona.PersonaNatural.Nombre.ApellidoMaterno = 'León';
                            }
                            
                            system.debug('@@@@ persona'+persona);
                
                            if (persona != null)
                            {                         
                                this.LeadId  = 'newLead';     
                                this.LeadName = persona.PersonaNatural.Nombre.Nombres;
                                this.LeadLastName =  persona.PersonaNatural.Nombre.ApellidoPaterno +' '+ persona.PersonaNatural.Nombre.ApellidoMaterno;    
                            }    
                        } 
                        catch (Exception ex) 
                        {
                            system.debug('@@@@@ ex Equifax --> '+ ex.getMessage() +' line: '+ex.getLineNumber());   
                            this.LeadId  = 'newLead';     
                            this.LeadName = '';
                            this.LeadLastName =  '';    
                        }
                    }
                    else 
                    {
                        this.LeadId  = Prospectos[0].Id;
                        this.LeadName = Prospectos[0].FirstName;
                        this.LeadLastName = Prospectos[0].LastName;
                    }

                    this.Salida = 2;    
                }
            }
            else {
                this.Salida = 3;
            }

            system.debug('@@@@ isValid'+isValid);

            system.debug('@@@@ this.Salida'+this.Salida);
            
        } catch (Exception ex) {
            system.debug('@@@@@ ex '+ ex.getMessage() +' line: '+ex.getLineNumber());
            this.Salida = 3;             
        }
       
    }

     public list<SelectOption> getListaPolizas() {
        List<SelectOption> tregistro = new list<SelectOption>(); 
        
        tregistro.add(new SelectOption('','-- Seleccione Poliza --'));
               
        List<Poliza__c> rts = [Select Id, Name, Nombre_de_Producto__c   From Poliza__c 
                                    Where Cuenta__c =: this.IdCuenta
                                    ORDER by Name];

        for (Poliza__c rt : rts) {
                tregistro.add(new SelectOption(rt.ID, rt.Name+' - '+rt.Nombre_de_Producto__c ));
        } 
   
        return tregistro;
    }

     public Pagereference ReiniciaCasoCliente()
    {
       PageReference page = new PageReference('/apex/SEC_VF_CV_Caso_Crea_Cliente?Id='+this.IdCuenta+'&Negocio='+this.Caso.Negocio__c);
       page.setRedirect(true);
       return page;
    }

    public Pagereference ReiniciaCasoNoCliente()
    {
       String rut = this.RUTNoCliente.split('-')[0];
       String dv = this.RUTNoCliente.split('-')[1];
       
       PageReference page = new PageReference('/apex/SEC_VF_CV_Caso_Crea_NoCliente?Rut='+rut+'&dv='+dv+'&LeadId='+this.LeadId+'&LeadName='+this.LeadName+'&LeadLastName='+this.LeadLastName+'&Negocio='+this.Caso.Negocio__c);
       page.setRedirect(true);
       return page;
    }

    public Pagereference ListadoCasos()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Casos');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

     public Pagereference MisCasos()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_MisCasos');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference NuevoCaso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Caso_IngresoRUT');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference cargaCaso()
    {
        try{
            this.Caso = new Case();
            this.IdCaso = apexpages.currentpage().getparameters().get('Id');
            this.Procedencia = apexpages.currentpage().getparameters().get('Procedencia');
            this.ResultadoCarga = false;
            this.ResultadoDerivacion = '';
            this.Mensaje = '';

            this.Boton_Cerrar = true;     
            this.Boton_Derivar = true;     
            this.Boton_Comentario = true;
            this.Boton_Adjunto = true; 
            this.Boton_Derivar_Optativo  = false;

            this.Existen_adjuntos = false;

            this.Boton_EscritorioDigital = true; 

            if (this.IdCaso != '')
            {
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	Id_Requerimiento_EscritorioDigital__c, 
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Canal__c, CreatedDate, Detalle_Solicitud__c, CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Parent.OwnerId, LastModifiedDate, Entrega_Respuesta__c, 
                            NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Numero_Propuesta__c, 
                            CASO_Responsable_UR__c, Id_Responsable_UR__c, Fecha_Derivacion_UR__c FROM Case WHERE Id =: this.IdCaso];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);       
                }

                if (this.Caso.EsNoCliente__c == true)
                {
                    this.RUTCarga = this.Caso.RUT_no_Cliente__c;
                    this.NombreCarga = this.Caso.Nombre_no_Cliente__c;
                    this.Titulo = 'Información Caso - No Cliente';
                    this.Boton_EscritorioDigital = false;
                }
                else 
                {
                    this.RUTCarga = this.Caso.RUT__c;
                    this.NombreCarga = this.Caso.NOMBRE_COMPLETO_RAZON_SOCIAL__C;
                    this.Titulo = 'Información Caso - Cliente';
                    String Etiqueta= CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);  		

                    if (String.isBlank(Etiqueta) == true)
                    {
                        this.Boton_EscritorioDigital = false;
                    }
                }

                this.LST_ComentariosCaso = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                                    FROM CaseComment
                                                    WHERE ParentId =: this.Caso.Id
                                                    ORDER BY CreatedDate DESC];

                this.LST_Adjuntos = [SELECT Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, UrlTex__c , Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c 
                WHERE IdCaso__c =: this.IdCaso ORDER BY CreatedDate DESC];

                if (this.LST_Adjuntos.size() > 0)
                {
                    this.Existen_adjuntos = true;
                }

                system.debug('@@@@ LST_Adjuntos '+this.LST_Adjuntos);
                if (this.Caso.Status == 'Cerrado' || this.Caso.Status == 'Caso Cerrado' || this.Caso.Status == 'Rechazado' )
                {
                    this.Boton_Cerrar = false;            
                    this.Boton_Derivar = false;           
                    this.Boton_Comentario = false;
                    this.Boton_Adjunto = false; 
                }
                else if (this.Caso.Status == 'Back Office' || (this.Caso.Status == 'En Proceso' && this.Caso.CASO_Responsable_UR__c != null))
                {
                    this.Boton_Cerrar = false;            
                    this.Boton_Derivar = false;     
                    this.Boton_Adjunto = false; 

                    if (string.isBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c))
                    {
                        this.Boton_EscritorioDigital = false;
                    }
                }
                else if (this.Caso.Status == 'Nuevo' || (this.Caso.Status == 'En Proceso' && this.Caso.CASO_Responsable_UR__c == null))
                {
                    Boolean DerivacionOptativa = CLS_CS_Derivacion_Validaciones.Es_DerivacionOptativa(this.Caso.Id);
                    system.debug('@@@@ DerivacionOptativa '+ DerivacionOptativa);
        
                    if (DerivacionOptativa == true)
                    {
                        this.Boton_Derivar_Optativo  = true;
                        this.Boton_Derivar  = false;                    
                    }
                }
                else if (this.Caso.Status == 'En Revisión')
                {
                    this.Boton_Cerrar = false;            
                }
                
                if (Test.isRunningTest())
                {
                    this.Caso.Id_Requerimiento_EscritorioDigital__c = '1234';
                }

                if (String.isNotBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c) == true)
                {
                    this.Usuario = CLS_EscritorioDigital_Internal.CargaDatosUsuario(UserInfo.getUserId());
                    
                    this.RutUsuario = Usuario.RUT;
                    this.Ip = Usuario.Ip;
                    this.UserOS = Usuario.UserOS;

                    this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(RutUsuario, userOS, ip);  
                    
                    if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_OK')
                    {
                        this.Persistencia = this.RespuestaPersistencia.IdPersistencia;
                    }
                    else 
                    {
                        this.Persistencia = 0;
                    }
                }

                this.TipoDocumentoCarga = 'ENDOSOS';

                return null;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }       
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR CARGA CASO --> '+ex);    
            return null;
        } 
    }

    public Pagereference IniciaNuevoComentario()
    {
        try{
                     
            this.IdCasoPopup = apexpages.currentpage().getparameters().get('Id');
            
            this.ResultadoPopup = false;
          
            this.Comentario = new CaseComment();
            this.Comentario.ParentId = this.IdCasoPopup;
           
            return null;
            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaNuevoComentario'+ ex);
        	return null;
        
    	}
    }

    public void GuardarComentario(){
        try{

            this.ResultadoPopup = String.isNotBlank(this.Comentario.CommentBody);
            
            if (this.ResultadoPopup == true)
            {
                if (!Test.isRunningTest()) 
                { 
                    Case c = [SELECT Id, Status FROM Case WHERE Id =: this.IdCasoPopup];

                    if (c.Status == 'Nuevo')
                    {
                        c.Status = 'En Proceso';                             
                        update c;            
                    }
                    
                    insert this.Comentario;                                            
                }
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR GuardarComentario'+ ex.getMessage() +' linea '+ex.getLineNumber());
    	}
    }

    public void DerivaCaso()
    {
        if (this.Caso.Status == 'Cerrado' || this.Caso.Status == 'Caso Cerrado' || this.Caso.Status == 'Rechazado' )
        {
            this.ResultadoDerivacion = 'CASO_CERRADO';
        }
        else if (this.Caso.Status == 'Back Office' || (this.Caso.Status == 'En Proceso' && this.Caso.CASO_Responsable_UR__c != null))
        {
            this.ResultadoDerivacion = 'CASO_PROCESO_DER';
        }

        if (String.isBlank(this.ResultadoDerivacion ) == true)
        {
            Case tmp = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: this.Caso.Id];
            if (String.isBlank(tmp.OwnerId__c))
            {
                User u = [SELECT Id, Email FROM User WHERE Id =: tmp.OwnerId];
                tmp.Email_Deriva_Caso__c = u.Email;
                tmp.OwnerId__c = tmp.OwnerId;
                update tmp;
            }

            if ((this.Caso.Status != 'En Revisión' && this.Caso.Status != 'Revisión'))
            {
                if (String.isNotBlank(this.Caso.Id_Requerimiento_EscritorioDigital__c) == true)
                {
                    Integer IdRequerimiento = Integer.valueOf(this.Caso.Id_Requerimiento_EscritorioDigital__c);

                    String response = CambioEstado_EscritorioDigital(IdRequerimiento);

                    String resultado = response.split(';')[0];
					system.debug('@@@@ resultado ED '+resultado);
                    if (resultado == 'UPDATE_ESTADO_ERROR' || resultado == 'EXCEPCION')
                    {
                        this.ResultadoDerivacion = resultado;
                        this.Mensaje = response.split(';')[1];
                    }//('UPDATE_ESTADO_OK')
                }

                if (this.Caso.Fecha_Derivacion_UR__c == null)
                {//registra fecha derivacion, situaciones especiales, con el tiempo dejar obsoleto
                    this.Caso.Fecha_Derivacion_UR__c = Datetime.now();//
                }
            }
        }
      	
        system.debug('@@@@ ResultadoDerivacion '+this.ResultadoDerivacion);

        if (String.isBlank(this.ResultadoDerivacion ) == true)
        {
            Database.DMLOptions dmo = new Database.DMLOptions();
            
            String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;            
            dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
            this.Caso.setOptions(dmo);
            List<Case> lsC = new List<Case>();
            this.Caso.Status = 'Back Office';
            this.Caso.CASO_Deriva_a_UR__c = true;
            if (this.Boton_Derivar_Optativo == true)
            {
                this.Caso.Motivo_Derivacion__c = 'Derivación Optativa de Caso desde Venta de Endosos';
            }
            lsC.add(this.Caso);
            Database.update(lsC,dmo);
            
			system.debug('@@@@ this.Caso PRE -->'+ this.Caso);
            
            CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();
            if (this.Caso.Id_Responsable_UR__c == null || this.Caso.Id_Responsable_UR__c == '')
            {                       
                CLAsign.AsignarCaso(this.Caso); 
            }
            else {
                CLAsign.ReasignarCaso(this.Caso.Id);
            }

            //Validar si propietario es Manuel Poblete
            try{
                Case caso = new Case();
                if (!Test.isRunningTest()) 
                {
                    caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: this.Caso.Id];
                }
                else
                {
                    caso.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
                }
                
                if(caso != null){
                    CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso);
                    this.ResultadoDerivacion ='OK';
                }
            }catch(Exception ex){
                system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                this.ResultadoDerivacion = 'ERROR';
            }            
        }
    }


    public void CierreCaso()
    {
        if (this.Caso.Status == 'Cerrado' || this.Caso.Status == 'Caso Cerrado' || this.Caso.Status == 'Rechazado' )
        {
            this.ResultadoCierre = 'CASO_CERRADO';
        }
        else if (this.Caso.Status == 'Back Office' || (this.Caso.Status == 'En Proceso' && this.Caso.CASO_Responsable_UR__c != null))
        {
            this.ResultadoCierre = 'CASO_PROCESO_DER';
        }
    
        try 
        {
            if (String.isBlank(this.ResultadoCierre ) == true)
            {
                this.Caso.Status = 'Cerrado';
                this.Caso.Entrega_Respuesta__c = true;
                if (!Test.isRunningTest())
                {
                    update this.Caso;
                }
                                
                Case atencion = new Case();
                
                if (!Test.isRunningTest())
                {
                    atencion = [SELECT Id, Status, Entrega_Respuesta__c FROM Case WHERE Id=: this.Caso.ParentId];
                }
                    
                atencion.Entrega_Respuesta__c = true;
                atencion.Status = 'Cerrado';
                
                if (!Test.isRunningTest())
                {
                    update atencion;
                }
                                
                this.ResultadoCierre ='OK';
            }            
        } 
        catch (Exception ex) {
               system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                this.ResultadoCierre = 'ERROR';
        }
    }

    public Pagereference IniciaEscritorioDigital()
    {
        try 
        {
            this.IdCasoPopup = apexpages.currentpage().getparameters().get('Id');            
            this.ResultadoPopup = false;

            this.CasoPopup = new Case();
               
            if (!Test.isRunningTest()) 
            {
                this.CasoPopup = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c,
                                Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c,CaseNumber, Tipo_de_Requerimiento__c, CASO_Resultado_Derivaci_n__c, 
                                CASO_Responsable_UR__c, Negocio__c, CASO_Categoria__c, Status FROM Case
                                WHERE Id =: this.IdCasoPopup];
            }

            system.debug('@@@@ CASO ==>'+ this.CasoPopup);

            if(this.CasoPopup.CASO_Poliza_Asoc__c != null && this.CasoPopup.CASO_Poliza_Asoc__c != '')
            {
                this.NumPoliza = Integer.valueOf(this.CasoPopup.CASO_Poliza_Asoc__c);
                this.Poliza = this.CasoPopup.CASO_Poliza_Asoc__c;
            }
            else
            {
                this.NumPoliza = 0;
                this.Poliza = 'No seleccionada';
            }

            if (!Test.isRunningTest()) 
            { 
                this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.CasoPopup.Detalle_Solicitud__c);  		
            }
            else
            {
                this.EtiquetaSolicitud = 'ED - Solicitud periodo garantizado';
            }

            this.Usuario = CLS_EscritorioDigital_Internal.CargaDatosUsuario(UserInfo.getUserId());
                    
            this.RutUsuario = Usuario.RUT;
            this.Ip = Usuario.Ip;
            this.UserOS = Usuario.UserOS;

            if (Test.isRunningTest())
            {
                this.CasoPopup.Id_Requerimiento_EscritorioDigital__c = '1123';
            }
            
            if (this.CasoPopup.Id_Requerimiento_EscritorioDigital__c != null)
            {
                this.IdRequerimiento = Integer.valueOf(this.CasoPopup.Id_Requerimiento_EscritorioDigital__c);
                this.TipoRequerimientoED = this.CasoPopup.Tipo_Requerimiento_EscritorioDigital__c;            
                this.Solicitante = CLS_EscritorioDigital_Internal.Solicitante(this.TipoRequerimientoED);                        
            }     
        } 
        catch (Exception ex) 
        {
            system.debug('@@@@ EXCEPCION IniciaEscritorioDigital: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
        }

        return null;
    }

    public List<SelectOption> getListaSolicitantes() {
        return CLS_EscritorioDigital_Internal.getListaSolicitantes(this.CasoPopup.Detalle_Solicitud__c);
    }

     public List<SelectOption> getListaNegocios() {
        List<SelectOption> negocios = new List<SelectOption>();
        
        negocios.add(new SelectOption('RRVV', 'RRVV'));
        negocios.add(new SelectOption('Seguros Colectivos', 'Seguros Colectivos'));
        negocios.add(new SelectOption('Seguros Familiares', 'Seguros Familiares'));
        negocios.add(new SelectOption('Seguros Individuales', 'Seguros Individuales'));
        negocios.add(new SelectOption('Seguros Masivos', 'Seguros Masivos'));
        negocios.add(new SelectOption('Sin Linea de Negocio', 'Sin Linea de Negocio'));
        negocios.add(new SelectOption('Negocio General', 'Negocio General'));

        return  negocios;
    }

    public void crearRequerimiento() {         
        if (!Test.isRunningTest()) 
        { 
            this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(RutUsuario, userOS, ip);  
        }
        else
        {
            this.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
            this.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        }      

        if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_OK')
        {
            this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

            if (!Test.isRunningTest()) 
        	{ 
                RespuestaRequerimiento = CLS_EscritorioDigital_Consume.crearRequerimiento(this.Persistencia, this.CasoPopup.RUT__c, Integer.valueOf(this.NumPoliza), this.TipoRequerimientoED, this.RutUsuario);                
        	}
            else {
                RespuestaRequerimiento = new CLS_EscritorioDigital_Consume.Respuesta_Requerimiento();
                RespuestaRequerimiento.Response = 'REQUERIMIENTO_CREADO';
                RespuestaRequerimiento.IdRequerimiento = 221;
            }
            
            system.debug('@@@@ RespuestaRequerimiento --> '+ RespuestaRequerimiento);
            
            if (RespuestaRequerimiento.Response == 'REQUERIMIENTO_CREADO')
            {
                this.CasoPopup.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;                
                this.CasoPopup.Id_Requerimiento_EscritorioDigital__c = String.valueOf(RespuestaRequerimiento.IdRequerimiento);
                this.IdRequerimiento = RespuestaRequerimiento.IdRequerimiento;

                if (this.CasoPopup.Status == 'Nuevo')
                {
                    this.CasoPopup.Status = 'En Proceso';                            
                }

                if (!Test.isRunningTest()) 
        		{ 
                     Update this.CasoPopup;                     
            	}

                this.MensajePopup = 'Ha sido creado en Escritorio Digital el requerimiento asociado al Caso.';
                this.ResultadoPopup = true;
            }
            else {
                this.ResultadoPopup = false;
                this.MensajePopup =  loadError(this.RespuestaRequerimiento.Response);           
            }
        }
        else
        {
            this.ResultadoPopup = false;
            this.MensajePopup =  loadError(this.RespuestaPersistencia.Response);           
        }    
    }

    public String loadError(String error)
    {
        String Mensaje = '';

        if (error == 'RUT_CLIENTE_NO_CORRESPONDE')
        {  
            Mensaje = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún Asegurado registrado.';
        }
        else if (error == 'RUT_CLIENTE_SIN_BENEFICIARIOS')
        {
            Mensaje = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';
        }
        else if (error == 'POLIZA_OBSOLETA')
        {
            Mensaje = 'La Poliza ingresada se encuentra obsoleta.';
        }
        else if (error == 'POLIZA_NO_INGRESADA')
        {
            Mensaje = 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.';
        }
        else if (error == 'CLIENTE_SIN_POLIZAS_ACTIVAS')
        {
            Mensaje = 'El Cliente ingresado no posee una Poliza activa.';
        } 
        else if (error == 'POLIZA_NO_CORRESPONDE')
        {
            Mensaje = 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.';
        }
        else if (error == 'CREA_REQUERIMIENTO_EXCEPCION')
        {
            Mensaje = 'Ha ocurrido un error inesperado en la Creación del Requerimiento, favor intente nuevamente. Si el error continua favor comuniquese con los administradores del Sistema.';
        }        
        else if (error == 'PERSISTENCIA_EXCEPCION_CREA_REQ')
        {
            Mensaje = 'Ha ocurrido un error de Comunicación con Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (error == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (error == 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (error == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        } 
        else if (error == 'PERSISTENCIA_EXCEPCION')
        {
            Mensaje = 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'; 
        }
        else if (error == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (error == 'REQUERIMIENTO_NO_APV')
        {
            Mensaje = 'El Requerimiento no está habilitado para productos APV.'; 
        } 
        else if (error == 'REQUERIMIENTO_MAX_3')
        {
            Mensaje = 'El Requerimiento está habilitado solo para MAX 3.0'; 
        } 
        else if (error == 'REQUERIMIENTO_MI_SEGURO')
        {
            Mensaje = 'El Requerimiento está habilitado solo para productos Mi Seguro.'; 
        } 
        else if (error == 'REQUERIMIENTO_NO_SOPORTADO')
        {
            Mensaje = 'La Solicitud asociada al Requerimiento no es soportada por Escritorio Digital.'; 
        } 
        else {
            Mensaje = Error;
        }

        return Mensaje;
    }
    
    public Pagereference AdjuntarArchivo()
    {          
        PageReference page = new PageReference ('/apex/SEC_VF_CV_CargaAdjunto?Id='+ this.Caso.Id);
        page.setRedirect(true);

        return page;
    }

     /***INTEGRACION ESCRITORIO DIGITAL**/
   
    public String CambioEstado_EscritorioDigital(Integer IdRequerimiento){
        String salida = '';

        try  
        {
            List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()];
                
            if (lusers.size() > 0)
            {
                RutUsuario = lusers[0].RUT_Usuario__c;   
            } 
            
            CLS_UR_Caso_CambioEstado.Actualiza_EscritorioDigital(IdRequerimiento, 'INGRESADO', RutUsuario);

            Salida = 'UPDATE_ESTADO_OK;';
        }
        catch(Exception ex){
            System.debug('@@@@|CambioEstadoDerivaCaso@@'+ex); 
            Salida = 'EXCEPCION;'+ex.getMessage();
        }

        return Salida;           
    }     
    
    /***INTEGRACION ESCRITORIO DIGITAL**/

}