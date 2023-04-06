/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-07-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-07-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class CTR_CS_AdjuntoValuetech {
    
    public Case Caso {get; set;}

    public String IdCaso {get; set;}
    
    public Transient blob fileBody { get; set; }
    
    public String fileName  {get; set;}

    public Boolean ResultadoCarga {get; set;}

    public String Titulo  {get; set;}

    public String IdRequerimiento  {get; set;}

    public String IdAdjunto  {get; set;}

    public Boolean Obligatorio {get; set;}

    public String RUTCarga {get; set;}

    public String NombreCarga {get; set;}

    public String TipoDocumento {get; set;}

    public Boolean Soportado {get; set;}

    public String NombreDocumento {get; set;}

    public String OtroDocumento {get; set;}

    public String ErrorCarga {get; set;}
    
    public CTR_CS_AdjuntoValuetech() {

    }

public Pagereference IniciaCargaAdjunto()
    {
        try
        {
            this.Caso = new Case();
            this.IdCaso = apexpages.currentpage().getparameters().get('Id');
            this.ResultadoCarga = false;
            this.Soportado = false; 

            if (this.IdCaso != '')
            {
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	Id_Requerimiento_EscritorioDigital__c, 
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Canal__c, CreatedDate, Detalle_Solicitud__c, CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Parent.OwnerId, LastModifiedDate, Entrega_Respuesta__c, 
                            NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Numero_Propuesta__c, 
                            CASO_Responsable_UR__c, Id_Responsable_UR__c FROM Case WHERE Id =: this.IdCaso];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);       
                }

                if (this.Caso.EsNoCliente__c == true)
                {
                    this.Titulo = 'Carga de archivo Adjunto  Valuetech - No Cliente';
                    this.RUTCarga = this.Caso.RUT_no_Cliente__c;
                    this.NombreCarga = this.Caso.Nombre_no_Cliente__c;
                }
                else 
                {
                     this.RUTCarga = this.Caso.RUT__c;
                    this.NombreCarga = this.Caso.NOMBRE_COMPLETO_RAZON_SOCIAL__C;
                    this.Titulo = 'Carga de archivo Adjunto Valuetech  - Cliente';
                }

                List<OBJ_Requerimiento__c> requerimientos = [SELECT Id, Name, Codigo__c FROM OBJ_Requerimiento__c WHERE Descripcion__c =: this.Caso.Detalle_Solicitud__c];
                
                if (requerimientos.size() > 0)
                {
                    this.IdRequerimiento = requerimientos[0].Codigo__c; //[SELECT Id, Name FROM OBJ_Requerimiento__c WHERE Descripcion__c =: this.Caso.Detalle_Solicitud__c].Name;
                    this.Soportado = true;
                }
                
                system.debug('@@@@ IdRequerimiento'+ this.IdRequerimiento );
            }
            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCargaAdjunto'+ ex);
    	}

        return null;
    }

    public List<SelectOption>  getAdjuntos()
    {
        List<SelectOption> adjuntos = new List<SelectOption>();
		
        system.debug('@@@@ IdRequerimiento'+ this.IdRequerimiento );
        
        if (String.isNotBlank(this.IdRequerimiento))
        {
            List<REL_Requerimiento_Adjunto__c> Relaciones = [SELECT Id, Codigo_Adjunto__c, Nombre_Adjunto__c, Obligatorio__c FROM REL_Requerimiento_Adjunto__c 
            WHERE Codigo_Requerimiento__c=: this.IdRequerimiento];

            for (REL_Requerimiento_Adjunto__c rt : Relaciones) {
                adjuntos.add(new SelectOption(rt.Id, rt.Nombre_Adjunto__c));
            } 
			if (Relaciones.size() > 0)
            {
            	this.IdAdjunto = Relaciones[0].Id;
            	this.Obligatorio = Relaciones[0].Obligatorio__c;    
            }            
        }

        return adjuntos;
    }

    public List<SelectOption>  getAdjuntosAll()
    {
        List<SelectOption> adjuntos = new List<SelectOption>();

        adjuntos.add(new SelectOption('0', 'Seleccione un adjunto...'));

        List<OBJ_Adjunto__c> result = [SELECT Id, Name, Codigo__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Activo__c = true];

        for (OBJ_Adjunto__c rt : result) {
            adjuntos.add(new SelectOption(rt.Id, rt.Descripcion__c));
        } 

        this.IdAdjunto = '0';
        
        return adjuntos;
    }

    public List<SelectOption> getTiposDocumento()
    {
        List<SelectOption> tipos = new List<SelectOption>();

        tipos.add(new SelectOption('ENDOSOS','ENDOSOS'));
        tipos.add(new SelectOption('EVALUACIONMEDICA','EVALUACIONMEDICA'));
        tipos.add(new SelectOption('MANDATOSSAAP','MANDATOSSAAP'));
        tipos.add(new SelectOption('OTROS','OTROS'));
        tipos.add(new SelectOption('POLIZA','POLIZA'));
        tipos.add(new SelectOption('PROPUESTA','PROPUESTA'));
        tipos.add(new SelectOption('SINIESTRO','SINIESTRO'));

        this.TipoDocumento = 'ENDOSOS';

        return tipos;

    }


    public List<SelectOption> getListaSolicitantes() {        
        List<SelectOption> options = new List<SelectOption>();  
        List<OBJ_Requerimiento__c> lrecords = [SELECT Id, Codigo__c, Descripcion__c, Etiqueta__c, Negocio__c, Activo__c, Solicitante__c FROM OBJ_Requerimiento__c 
                    WHERE  Descripcion__c =: this.Caso.Detalle_Solicitud__c ORDER BY Solicitante__c ASC];
                
        if (lrecords.Size() > 0)
        {
            for(OBJ_Requerimiento__c req: lrecords) {
           		 options.add(new SelectOption(req.Codigo__c, req.Solicitante__c));
       		}
        }
        
        return options; 
    }


    public void changeObligatorio()
    { 
        system.debug('@@@@ Param IdAdjunto '+ apexpages.currentpage().getparameters().get('idAdjunto'));
        this.IdAdjunto = apexpages.currentpage().getparameters().get('idAdjunto');
		this.Obligatorio = false;
        
        List<REL_Requerimiento_Adjunto__c> relaciones = [SELECT Id, Codigo_Adjunto__c, Nombre_Adjunto__c, Obligatorio__c FROM REL_Requerimiento_Adjunto__c WHERE Id =: this.IdAdjunto];
        
        if (relaciones.size() > 0)
        {
        	this.Obligatorio =  relaciones[0].Obligatorio__c;    
        }
        
        system.debug('@@@@ Param Obligatorio '+ Obligatorio);
    }

    public void Upload() {
        system.debug('@@@@ Upload');
            
        try 
        {
            
            system.debug('@@@@ TipoDocumento' + this.TipoDocumento);

            if (this.fileBody == null || this.fileBody.size() == 0) 
            {
                this.ResultadoCarga = false;
                this.ErrorCarga = 'Debe seleccionar un Archivo para realizar la carga.';                
            }
            else 
            {
                system.debug('@@@@ Upload' + this.fileBody.size());
                String Id = this.Caso.Id;
                Blob targetBlob = Blob.valueOf('V1D4S3CUR1TY' + 'Vida Sec-Seguro Individual' + Id);
                Blob hash = Crypto.generateDigest('MD5', targetBlob);
                String token = EncodingUtil.convertToHex(hash);
                String idTransaccion = this.Caso.Id;
                String content = EncodingUtil.base64Encode(fileBody);

                if (this.Caso.CASO_POLIZA_ASOC__C == null)
                {
                this.Caso.CASO_POLIZA_ASOC__C = '';
                }

                if (this.Caso.Numero_Propuesta__c == null)
                {
                this.Caso.Numero_Propuesta__c = '';
                }

                String inicio = '<IndexList>';
                String empresa = '<Index Value="VIDA SECURITY" Label="Empresa" />';
                String poliza = '<Index Value="'+this.Caso.CASO_POLIZA_ASOC__C+'" Label="Póliza" />';
                String propuesta = '<Index Value="'+this.Caso.Numero_Propuesta__c+'" Label="Propuesta" />';
                String tipoDocumento = '<Index Value="'+this.TipoDocumento+'" Label="Tipo de Documento" />';
                String rutAsegurado = '<Index Value="' + this.RUTCarga + '" Label="RUT Asegurado" />';
                String nombreAsegurado = '<Index Value="' + this.NombreCarga + '" Label="Nombre Contratante" />';
                String envioAcsel = '<Index Value="false" Label="EnviaAcsel" />' ;
                String caja = '<Index Value="' + this.IdCaso + '" Label="CAJA" />';

                Adjunto__c adjunto = new Adjunto__c();
                adjunto.IdCaso__c = this.Caso.Id;

                String nombreImagen = '';
                String codigoAdjunto = '';
                String nombreDoc = '';
                Boolean obligatorio = false;

                system.debug('@@@@ Soportado '+ this.Soportado);
                system.debug('@@@@ OtroDocumento '+ this.OtroDocumento);
                if (this.Soportado == true)
                {
                    if (String.isNotBlank(this.OtroDocumento) ==  true)
                    {
                        nombreDoc = this.OtroDocumento;

                        if (this.OtroDocumento.length() >= 40)
                        {
                            nombreImagen = this.OtroDocumento.substring(0,40);
                        }
                        else 
                        {
                            nombreImagen =  this.OtroDocumento;
                        }               

                        obligatorio = false;         
                    }
                    else
                    {
                        REL_Requerimiento_Adjunto__c relacion =  [SELECT Codigo_Adjunto__c, Nombre_Adjunto__c, Obligatorio__c FROM REL_Requerimiento_Adjunto__c WHERE Id =: this.IdAdjunto];
                        nombreDoc = relacion.Nombre_Adjunto__c;
                        obligatorio = relacion.Obligatorio__c;
                        codigoAdjunto = relacion.Codigo_Adjunto__c;

                        if (relacion.Nombre_Adjunto__c.length() >= 40)
                        {
                            nombreImagen = relacion.Nombre_Adjunto__c.substring(0,40);
                        }
                        else {
                            nombreImagen =  relacion.Nombre_Adjunto__c;
                        }
                    }                   
                }
                else 
                {
                    system.debug('@@@@ IdAdjunto '+ this.IdAdjunto);
                    system.debug('@@@@ NombreDocumento '+ this.NombreDocumento);

                    if (String.isNotBlank(this.NombreDocumento) ==  true)
                    {
                        nombreDoc = this.NombreDocumento;

                        if (this.NombreDocumento.length() >= 40)
                        {
                            nombreImagen = this.NombreDocumento.substring(0,40);
                        }
                        else 
                        {
                            nombreImagen =  this.NombreDocumento;
                        }                        
                    }
                    else 
                    {
                        if (this.IdAdjunto != '0')
                        {
                            OBJ_Adjunto__c adj = [SELECT Id, Name,  Descripcion__c FROM OBJ_Adjunto__c o WHERE Id =: this.IdAdjunto];
                            nombreDoc = adj.Descripcion__c;

                            if ( adj.Descripcion__c.length() >= 40)
                            {
                                nombreImagen = adj.Descripcion__c.substring(0,40);
                            }
                            else {
                                nombreImagen =  adj.Descripcion__c;
                            }   
                        }
                    }
                }
                
                 system.debug('@@@@ nombreImagen '+nombreImagen);

                if (String.isBlank(nombreImagen) == false)
                {
                    String nombre_imagen = '<Index Value="'+nombreImagen  +'" Label="Nombre Imagen" />';
                    String fin = '</IndexList>';

                    system.debug('@@@@ empresa '+empresa);
                    system.debug('@@@@ poliza '+poliza);
                    system.debug('@@@@ propuesta '+propuesta);
                    system.debug('@@@@ tipoDocumento '+tipoDocumento);
                    system.debug('@@@@ rutAsegurado '+rutAsegurado);
                    system.debug('@@@@ nombreAsegurado '+nombreAsegurado);
                    system.debug('@@@@ envioAcsel '+envioAcsel);
                    system.debug('@@@@ caja '+caja);
                    system.debug('@@@@ nombreImagen '+nombreImagen);

                    String xmlIndex = inicio + empresa + poliza + propuesta+ tipoDocumento + rutAsegurado + nombreAsegurado + envioAcsel + caja + nombre_imagen + fin;
                    String extension = 'pdf';           

                    system.debug('@@@@ token '+token);
                    system.debug('@@@@ idTransaccion '+idTransaccion);

                    system.debug('@@@@ xmlIndex '+xmlIndex);

                    WS_ValueWeb.AgregarDocumentoReturn retorno = new WS_ValueWeb.AgregarDocumentoReturn();                    
                    
                    if (!Test.isRunningTest())
                    {
                       retorno = ClienteValueWeb.AgregarDocumento(token, idTransaccion, content, xmlIndex, extension); 
                    }
                    else
                    {
                        retorno.Code = 0;
                    }
                    
                    system.debug('@@@@ retorno' + retorno);
                    

                    if (retorno.Code == 0 ) 
                    {
                        Integer idDoc = retorno.DWDocID;
                        if (this.Caso.Status == 'Nuevo')
                        {
                            this.Caso.Status = 'En Proceso';  
                            
                            if (!Test.isRunningTest())
	                        {
    	                    	update this.Caso;
        	                }                                                                                
                        }

                        adjunto.Codigo_Adjunto__c =  codigoAdjunto;
                        adjunto.Obligatorio__c = obligatorio;
                        adjunto.Nombre_Documento__c = nombreDoc;
                        adjunto.Tipo_Documento__c = this.TipoDocumento;
                        adjunto.Id_Retorno__c = String.valueOf(idDoc);
                        adjunto.Nombre_Imagen__c = nombreImagen;
                        
                        if (!Test.isRunningTest())
                        {
                        	insert adjunto;    
                        }                        

                        this.ResultadoCarga = true;
                    }
                    else
                    {
                 	    this.ResultadoCarga = false;
                    	this.ErrorCarga = 'Ha ocurrido un Error al intentar realizar la carga del archivo a Valuetech.';
                    }
                } 
                else
                {
                    this.ResultadoCarga = false;
                    this.ErrorCarga = 'Debe seleccionar del listado o ingresar un nombre asociado al Archivo cargado.';
                }
            }
            
        } catch(Exception ex) {
			//ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getlineNumber()+' '+ex.getMessage()));
            system.debug('@@@@' + ex.getlineNumber()+' '+ex.getMessage());
            this.ErrorCarga = 'Ha ocurrido un error al realizar la carga.';
		}
    }

    
}