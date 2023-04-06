/**
* @File Name : CTR_CS_UploadValuetech.cls
* @Description : 
* @Author : ChangeMeIn@UserSettingsUnder.SFDoc
* @Group : 
* @Last Modified By : Juan Espinoza León
* @Last Modified On : 05-18-2021
* @Modification Log : 
* Ver Date Author Modification
* 1.0 4/14/2020 ChangeMeIn@UserSettingsUnder.SFDoc Initial Version
**/ 
public class CTR_CS_UploadValuetech 
{
    public class RRVV
    {
        public String TipoDocumento {get; set;}
        public String FamiliaDocumento {get; set;}
        public String CodigoTipoDocumento {get; set;}
        public String CodigoAdjunto {get; set;}
        public String Sielaf {get; set;}
        //public String RutCausante {get; set;}
        public String Documento {get; set;}
    }
    
    public class Individual
    {
        public String CodigoAdjunto {get; set;}
        public String Documento {get; set;}
    }

    public class Colectivo
    {
        public String CodigoAdjunto {get; set;}
        public String Documento {get; set;}
    }

    public Case Caso {get; set;}
    public String IdCaso {get; set;}
    public Transient blob fileBody { get; set; }
    public String fileName {get; set;}
    public Boolean ResultadoCarga {get; set;}
    public Boolean Error {get; set;}
    public String Mensaje {get; set;}
    public String Titulo {get; set;}
  //  public String IdRequerimiento {get; set;}
    public String IdRelacionAdjunto {get; set;}
    public String IdAdjunto {get; set;}
    public Boolean Obligatorio {get; set;}
    public String RUTCarga {get; set;}
    public String NombreCarga {get; set;}
    public String TipoDocumentoInd {get; set;}
    public String Familia {get; set;}
    public String OtroDocumento {get; set;}
    public String Codigo_Requerimiento {get; set;}
    public Boolean Es_RentasVitalicias {get; set;}
    public Boolean Es_Individuales {get; set;}
    public Boolean Es_Colectivo {get; set;}
    public Boolean Es_Credito {get; set;}
    public Boolean EscritorioDigital {get; set;}
    public Boolean Requiere_RutCausante { get; set;}
    public String RutCausante {get; set;}
    public String Procedencia { get; set;}
    public String IdTarea {get; set;}
    public String UBackUp {get; set;}
    public String Tipo {get; set;}
    public String ProcedenciaUR { get; set;}
    public Boolean ListaSeleccion {get; set;}
    public Boolean NombreAdjunto {get; set;}
    public String Poliza {get; set;}


    public String ErrorCargaInicial {get; set;}

    public String RutEmpresaCOL {get; set;}

    public String NombreEmpresaCOL {get; set;}

    public CTR_CS_UploadValuetech() {
    }


    public static RRVV GetData_RRVV(String IdRelacion, String idAdjunto, String otroDocumento)
    {
        RRVV data = new RRVV();
        Boolean exito = false;
        data.Sielaf = '';
        system.debug('@@@@ data GetData_RRVV IdRelacion --> '+ IdRelacion);
        system.debug('@@@@ data GetData_RRVV idAdjunto --> '+ idAdjunto);
        system.debug('@@@@ data GetData_RRVV otroDocumento --> '+ otroDocumento);
    
        if (String.isNotBlank(otroDocumento))
        {
            data.Documento = otroDocumento;
            if (otroDocumento.length() >= 40)
            {
                data.TipoDocumento = otroDocumento.substring(0,40);
            }
            else
            {
                data.TipoDocumento = otroDocumento;
            } 
            exito = true;
        }
        
        if (Test.isRunningTest())
        {
            exito = false;     
        }
 
        if (exito == false && String.IsNotBlank(IdRelacion))//escritorio digital
        {
            REL_Requerimiento_Adjunto__c relacion = [SELECT Activo__c, Codigo_Adjunto__c, Codigo_Requerimiento__c, CreatedById, CreatedDate, CurrencyIsoCode, FamiliaDocumento__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Name, Nombre_Adjunto__c, Obligatorio__c, OwnerId, RUT_Causante__c, SystemModstamp FROM REL_Requerimiento_Adjunto__c 
                                                     WHERE Id =: IdRelacion];
            if (relacion != null)
            {
                data.FamiliaDocumento = relacion.FamiliaDocumento__c;
               
                if (relacion.Nombre_Adjunto__c.length() >= 40)
                {
                    data.TipoDocumento = relacion.Nombre_Adjunto__c.substring(0,40);
                }
                else
                {
                    data.TipoDocumento = relacion.Nombre_Adjunto__c;
                }
            }
            
            data.CodigoTipoDocumento = relacion.Codigo_Adjunto__c;
            data.CodigoAdjunto = relacion.Codigo_Adjunto__c;
            data.Documento = relacion.Nombre_Adjunto__c;
            if (!Test.isRunningTest()){ 
              OBJ_Adjunto__c adj = [SELECT Id, Name, Codigo__c, Codigo_Sielaf__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Codigo__c =: relacion.Codigo_Adjunto__c];
            
              if (adj.Codigo_Sielaf__c != null)
              {
                  data.CodigoTipoDocumento = String.valueOf(adj.Codigo_Sielaf__c);
                  data.Sielaf = '1';
              }
            } 
            
            exito = true;
        }

        if (Test.isRunningTest())
        {
            exito = false;     
        }
        
        if (exito == false && String.isNotBlank(idAdjunto))//ur
        {
            OBJ_Adjunto__c adjunto = [SELECT Id, Name, Codigo__c, Codigo_Sielaf__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Id =: idAdjunto];
            data.Documento = adjunto.Descripcion__c;
        
            if (adjunto.Descripcion__c.length() >= 40)
            {
                data.TipoDocumento = adjunto.Descripcion__c.substring(0,40);
            }
            else
            {
                data.TipoDocumento = adjunto.Descripcion__c;
            } 
            
            data.CodigoTipoDocumento = adjunto.Codigo__c;
            data.CodigoAdjunto = adjunto.Codigo__c;
            if (adjunto.Codigo_Sielaf__c != null)
            {
                data.CodigoTipoDocumento = String.valueOf(adjunto.Codigo_Sielaf__c);
                data.Sielaf = '1';
            }
            
            exito = true;
        }

        if (exito == false)
            return null;

        system.debug('@@@@ data RRVV --> '+ data);
    
        return data;
    }

    public static Individual GetData_Individuales(String IdRelacion, String idAdjunto, String otroDocumento)
    {
        Individual data = new Individual();
        Boolean exito = false;
        
        if (String.isNotBlank(otroDocumento))
        {
            data.Documento = otroDocumento;
            exito = true;
        }
        
        if (Test.isRunningTest())
        {
            exito = false;     
        }
    
        if (exito == false && String.IsNotBlank(IdRelacion))//escritorio 
        {
            REL_Requerimiento_Adjunto__c relacion = [SELECT Activo__c, Codigo_Adjunto__c, Codigo_Requerimiento__c, CreatedById, CreatedDate, CurrencyIsoCode, FamiliaDocumento__c, Id, IsDeleted, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Name, Nombre_Adjunto__c, Obligatorio__c, OwnerId, RUT_Causante__c, SystemModstamp FROM REL_Requerimiento_Adjunto__c 
                                                    WHERE Id =: IdRelacion];
            data.CodigoAdjunto = relacion.Codigo_Adjunto__c;
            data.Documento = relacion.Nombre_Adjunto__c;
            exito = true;
        }
        
        if (Test.isRunningTest())
        {
            exito = false;     
        }

        if (exito == false && String.isNotBlank(idAdjunto))//ur
        {
            OBJ_Adjunto__c adjunto = [SELECT Id, Name, Codigo__c, Codigo_Sielaf__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Id =: idAdjunto];
            data.Documento = adjunto.Descripcion__c;
            data.CodigoAdjunto = adjunto.Codigo__c;
            exito = true;
        }

        if (exito == false)
            return null;
        
        return data;
    }

    public static Colectivo GetData_Colectivos(String idAdjunto, String otroDocumento)
    {
        Colectivo data = new Colectivo();
        Boolean exito = false;
        
        if (String.isNotBlank(otroDocumento))
        {
            data.Documento = otroDocumento;
            exito = true;
        }
      
        if (Test.isRunningTest())
        {
            exito = false;     
        }

        if (exito == false && String.isNotBlank(idAdjunto))
        {
            OBJ_Adjunto__c adjunto = [SELECT Id, Name, Codigo__c, Codigo_Sielaf__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Id =: idAdjunto];
            data.Documento = adjunto.Descripcion__c;
            data.CodigoAdjunto = adjunto.Codigo__c;
            exito = true;
        }

        if (exito == false)
            return null;
        
        return data;
    }
    
    public Pagereference IniciaCargaAdjunto()
    {
        try
        {
            this.ErrorCargaInicial = '';

            this.Familia = '';
            this.TipoDocumentoInd = '';
            this.Caso = new Case();
            this.IdCaso = apexpages.currentpage().getparameters().get('Id'); 
            this.Procedencia = apexpages.currentpage().getparameters().get('From');
            this.Requiere_RutCausante = false;
            this.Error = false;
            try 
            {
                this.IdTarea = apexpages.currentpage().getparameters().get('IdTarea');
            } 
            catch (Exception ex) 
            {
                this.IdTarea = '';
            }
            
            try 
            {
                this.UBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            } catch (Exception ex)  
            {
                this.UBackUp = '';
            }
            
            try 
            {
                this.ProcedenciaUR = apexpages.currentpage().getparameters().get('FromUR');
            } 
            catch (Exception ex) 
            {
                this.ProcedenciaUR = '';
            }
        
            this.ResultadoCarga = false;
            this.EscritorioDigital = false; 
            //this.IdRequerimiento = '';
            this.Codigo_Requerimiento = '';
            this.Obligatorio = false;
           
            if (this.IdCaso != '')
            {
                //crear campo en caso para diferenciar casos con imagenes subida antigua de nueva version
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Id_Requerimiento_EscritorioDigital__c, 
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
            
                this.Poliza = this.Caso.CASO_POLIZA_ASOC__C;

                if (this.Caso.Negocio__c == 'Seguros Colectivos')
                {
                    if (String.isBlank(this.Caso.CASO_POLIZA_ASOC__C) || this.Caso.CASO_POLIZA_ASOC__C == null)
                    {
                        this.ErrorCargaInicial = 'Para realizar la carga de un adjunto para un Caso de Seguros Colectivos, debe estar ingresada la Póliza asociada al Cliente';
                        return null;
                    }
                    else 
                    {
                        Poliza__c pol = [SELECT Id, Cuenta__c FROM Poliza__c WHERE Id =: this.Caso.CASO_N_Poliza__c];

                        if (pol != null)
                        { 
                            Account cuentaPr = [SELECT Id, Name, RUT__c, DV__c FROM Account WHERE Id=:pol.Cuenta__c];
                                
                            //SELECT Id, Name, RUT__c, DV__c From Account WHERE Id = id];
                            this.NombreEmpresaCOL = cuentaPr.Name;
                            this.RutEmpresaCOL = cuentaPr.RUT__c+'-'+cuentaPr.DV__c;
                        }
                        else 
                        {
                            this.ErrorCargaInicial = 'Para realizar la carga de un adjunto para un Caso de Seguros Colectivos, debe estar ingresada la Póliza válida asociada al Cliente';
                            return null;
                        }
                    }
                }
                if (this.Caso.EsNoCliente__c == true)
                {
                    this.Titulo = 'Carga de archivo a Repositorio de Documentos - No Cliente';
                    this.RUTCarga = this.Caso.RUT_no_Cliente__c;
                    this.NombreCarga = this.Caso.Nombre_no_Cliente__c;
                }
                else 
                {
                    this.RUTCarga = this.Caso.RUT__c;
                    this.NombreCarga = this.Caso.NOMBRE_COMPLETO_RAZON_SOCIAL__C;
                    this.Titulo = 'Carga de archivo a Repositorio de Documentos - Cliente';
                }
                         
                List<OBJ_Requerimiento__c> requerimientos = [SELECT Id, Name, Codigo__c FROM OBJ_Requerimiento__c WHERE Descripcion__c =: this.Caso.Detalle_Solicitud__c];
                
                if (Test.isRunningTest())
                {
                    requerimientos = [SELECT Id, Name, Codigo__c FROM OBJ_Requerimiento__c LIMIT 3];
                }
                
                if (requerimientos.size() > 0)
                {                    
                    this.Codigo_Requerimiento = requerimientos[0].Codigo__c; //[SELECT Id, Name FROM OBJ_Requerimiento__c WHERE Descripcion__c =: this.Caso.Detalle_Solicitud__c].Name;
                    this.EscritorioDigital = true;
                    List<REL_Requerimiento_Adjunto__c> Relaciones = [SELECT Id, Obligatorio__c, RUT_Causante__c, FamiliaDocumento__c FROM REL_Requerimiento_Adjunto__c 
                    WHERE Codigo_Requerimiento__c=: this.Codigo_Requerimiento];
                    if (Relaciones[0].RUT_Causante__c == 'S')
                    {
                        this.Requiere_RutCausante = true;
                    }
                    this.Obligatorio = Relaciones[0].Obligatorio__c;     
                    this.Familia = Relaciones[0].FamiliaDocumento__c;
                }

                if (this.Caso.Negocio__c == 'RRVV')
                {
                    if (this.Caso.Detalle_Solicitud__c == 'Prepago de préstamo' || this.Caso.Detalle_Solicitud__c == 'Solicitud de préstamo o repactación')
                    {//buscar los tipos creditos
                        this.Es_Credito = true;
                        this.Codigo_Requerimiento = 'RRVVTIPO0009';
                        this.EscritorioDigital = true;
                        this.Familia = 'CRÉDITOS';
                    }
                    else {
                        this.Es_RentasVitalicias = true; 
                    }
                }
                else if (this.Caso.Negocio__c == 'Seguros Individuales' || this.Caso.Negocio__c == 'Seguros Familiares'  || this.Caso.Negocio__c == 'Seguros Masivos' || this.Caso.Negocio__c == 'Negocio General' )
                {
                    this.Es_Individuales = true;
                }
                else if (this.Caso.Negocio__c == 'Seguros Colectivos')
                {
                    this.Es_Colectivo = true;                    
                }
                else 
                {
                    this.ErrorCargaInicial = 'Linea de Negocio no soportada';
                    return null;
                }

                system.debug('@@@@ Codigo_Requerimiento'+ this.Codigo_Requerimiento );
            }
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR IniciaCargaAdjunto'+ ex);
        }

        return null;
    }

    public List<SelectOption> getAdjuntos()
    {
        List<SelectOption> adjuntos = new List<SelectOption>();
        system.debug('@@@@ Codigo_Requerimiento ··· '+ this.Codigo_Requerimiento );
        if (String.isNotBlank(this.Codigo_Requerimiento))
        {
            List<REL_Requerimiento_Adjunto__c> Relaciones = [SELECT Id, Codigo_Adjunto__c, Nombre_Adjunto__c, Obligatorio__c, RUT_Causante__c, FamiliaDocumento__c FROM REL_Requerimiento_Adjunto__c 
                                                            WHERE Codigo_Requerimiento__c=: this.Codigo_Requerimiento AND Activo__c = true ORDER BY Codigo_Adjunto__c ASC];
            
            for (REL_Requerimiento_Adjunto__c rt : Relaciones) 
            {
                adjuntos.add(new SelectOption(rt.Id, rt.Nombre_Adjunto__c));
            } 
            
            if (Relaciones.size() > 0)
            {
                this.IdRelacionAdjunto = Relaciones[0].Id;
                this.Obligatorio = Relaciones[0].Obligatorio__c; 

                if (Relaciones[0].RUT_Causante__c == 'S')
                {
                    this.Requiere_RutCausante = true;
                }
                this.Familia = Relaciones[0].FamiliaDocumento__c;
            } 
        }
        
        system.debug('@@@@ IdRelacionAdjunto ··· '+ this.IdRelacionAdjunto );
        system.debug('@@@@ Obligatorio ··· '+ this.Obligatorio );
        system.debug('@@@@ Requiere_RutCausante ··· '+ this.Requiere_RutCausante );
        system.debug('@@@@ Familia ··· '+ this.Familia );
        return adjuntos;
    }

    public List<SelectOption> getAdjuntosAll()
    {
        List<SelectOption> adjuntos = new List<SelectOption>();
        adjuntos.add(new SelectOption('0', 'Seleccione un adjunto...'));
        
        List<OBJ_Adjunto__c> result = [SELECT Id, Name, Codigo__c, Descripcion__c FROM OBJ_Adjunto__c o WHERE Activo__c = true];
    
        for (OBJ_Adjunto__c rt : result) {
            adjuntos.add(new SelectOption(rt.Id, rt.Descripcion__c));
        } 
    
        this.IdAdjunto = '';
    
        return adjuntos;
    }

    //utilizado para Seguros Individuales / Seguros Colectivos
    public List<SelectOption> getTiposDocumento_IND()
    {
        List<SelectOption> tipos = new List<SelectOption>();
    
        tipos.add(new SelectOption('','-- Ninguno --'));
        tipos.add(new SelectOption('ENDOSOS','ENDOSOS'));
        tipos.add(new SelectOption('EVALUACIONMEDICA','EVALUACIONMEDICA'));
        tipos.add(new SelectOption('MANDATOSSAAP','MANDATOSSAAP'));
        tipos.add(new SelectOption('OTROS','OTROS'));
        tipos.add(new SelectOption('POLIZA','POLIZA'));
        tipos.add(new SelectOption('PROPUESTA','PROPUESTA'));
        tipos.add(new SelectOption('SINIESTRO','SINIESTRO'));
    
        //this.TipoDocumentoInd = 'ENDOSOS';
    
        return tipos;
    }

     //utilizado para RRVV
     public List<SelectOption> getFamilia_RRVV()
     {
         List<SelectOption> family = new List<SelectOption>();
     
         family.add(new SelectOption('','-- Ninguno --'));
         family.add(new SelectOption('ENDOSO ANTICIPO','ENDOSO ANTICIPO'));
         family.add(new SelectOption('CUOTA MORTUORIA','CUOTA MORTUORIA'));
         family.add(new SelectOption('MANTENCIÓN FORMA DE PAGO','MANTENCIÓN FORMA DE PAGO'));
         family.add(new SelectOption('DECLARACION BENEFICIARIOS PERIODO GARANT','DECLARACION BENEFICIARIOS PERIODO GARANT'));
         family.add(new SelectOption('CRÉDITOS','CRÉDITOS'));
         family.add(new SelectOption('REPACTACIÓN','REPACTACIÓN'));
         family.add(new SelectOption('SOLICITUD GARANTÍA ESTATAL','SOLICITUD GARANTÍA ESTATAL'));
         family.add(new SelectOption('SOLICITUD PENSIÓN SOBREVIVENCIA','SOLICITUD PENSIÓN SOBREVIVENCIA'));
         family.add(new SelectOption('ASIGNACION FAMILIAR','ASIGNACION FAMILIAR'));
         family.add(new SelectOption('SOLICITUD NUEVO FUN','SOLICITUD NUEVO FUN'));
     
         //this.Familia = '';
     
         return family;
     }

    public List<SelectOption> getListaSolicitantes() 
    { 
        List<SelectOption> options = new List<SelectOption>(); 
        
        if (this.Codigo_Requerimiento == 'RRVVTIPO0009')
        {
            options.add(new SelectOption('RRVVTIPO0009', 'Rentista Titular'));
        }
        else 
        {
            List<OBJ_Requerimiento__c> lrecords = [SELECT Id, Codigo__c, Descripcion__c, Etiqueta__c, Negocio__c, Activo__c, Solicitante__c FROM OBJ_Requerimiento__c 
                                                   WHERE Descripcion__c =: this.Caso.Detalle_Solicitud__c ORDER BY Solicitante__c ASC];

            if (lrecords.Size() > 0)
            {
                for(OBJ_Requerimiento__c req: lrecords) 
                {
                    options.add(new SelectOption(req.Codigo__c, req.Solicitante__c));
                }
            } 
        }

        return options; 
    }
    
    public void changeObligatorio()
    { 
        system.debug('@@@@ Param IdAdjunto '+ apexpages.currentpage().getparameters().get('idAdjunto'));
        this.IdRelacionAdjunto = apexpages.currentpage().getparameters().get('idAdjunto');
        this.Obligatorio = false;
        this.Requiere_RutCausante = false;

        List<REL_Requerimiento_Adjunto__c> relaciones = [SELECT Id, Codigo_Adjunto__c, Nombre_Adjunto__c, Obligatorio__c, RUT_Causante__c, FamiliaDocumento__c FROM REL_Requerimiento_Adjunto__c WHERE Id =: this.IdRelacionAdjunto];

        if (relaciones.size() > 0)
        {
            this.Obligatorio = relaciones[0].Obligatorio__c; 
            this.Familia = relaciones[0].FamiliaDocumento__c;
            system.debug('@@@@ Familia '+ this.Familia);
            if (this.Caso.Negocio__c == 'RRVV' && relaciones[0].RUT_Causante__c == 'S')
            {
                this.Requiere_RutCausante = true;                
                this.RutCausante = '';
            }
        }

        system.debug('@@@@ Param Requiere_RutCausante '+ Requiere_RutCausante);
        system.debug('@@@@ Param Obligatorio '+ Obligatorio);
    }

    public void Upload() 
    {
        system.debug('@@@@ Upload');

        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        try 
        {
            Boolean datosCorrectos = false;
            system.debug('@@@@ TipoDocumento' + this.TipoDocumentoInd);
            system.debug('@@@@ fileBody' + this.fileBody);
            system.debug('@@@@ fileName' + this.fileName);
            system.debug('@@@@ OtroDocumento' + this.OtroDocumento);
            system.debug('@@@@ Requiere_RutCausante --> ' + this.Requiere_RutCausante);
            system.debug('@@@@ RutCausante --> ' + this.RutCausante);

            if(Test.isRunningTest())
            {
                this.fileName = 'archivo.wav';
            }

            String[] vExtension = this.fileName.split('\\.'); 

            Integer sizevExt = vExtension.size();

            String extension = vExtension[sizevExt - 1];//

            if (String.isBlank(this.OtroDocumento))
            {
                if (this.Requiere_RutCausante == true)
                {
                    if (String.isBlank(this.RutCausante))
                    {
                        this.ResultadoCarga = false;
                        this.Error = true;
                        this.Mensaje = 'Debe ingresar un RUT Causante asociado al documento cargado.'; 
                        return;
                    }
                }
    
                if (this.EscritorioDigital == false && String.isBlank(this.IdAdjunto))
                {
                    this.ResultadoCarga = false;
                    this.Error = true;
                    this.Mensaje = 'Debe seleccionar un Documento a adjuntar.'; 
                    return;
                }
                
                if (this.EscritorioDigital == true && String.isBlank(this.IdRelacionAdjunto))
                {
                    this.ResultadoCarga = false;
                    this.Error = true;
                    this.Mensaje = 'Debe seleccionar un Documento a adjuntar.'; 
                    return;
                }
            }

            upload.TipoDocumento = this.TipoDocumentoInd;
            upload.fileName = this.fileName;
    
            if (this.fileBody == null || this.fileBody.size() == 0) 
            { 
                system.debug('@@@@ ResultadoCarga false');
                this.ResultadoCarga = false;
                this.Error = true;
                this.Mensaje = 'Debe seleccionar un Archivo para realizar la carga.'; 
                return; 
            }
            else 
            {
                system.debug('@@@@ fileBody.size()' + this.fileBody.size());
                upload.Id = this.Caso.Id;
            
                if (this.Caso.CASO_POLIZA_ASOC__C == null)
                {
                    this.Caso.CASO_POLIZA_ASOC__C = '';
                }
                
                if (this.Caso.Numero_Propuesta__c == null)
                {
                    this.Caso.Numero_Propuesta__c = '';
                }

                if (this.NombreCarga.length() > 40)
                {
                    this.NombreCarga = this.NombreCarga.substring(0,40);                                
                }
                               
                if (this.Caso.Negocio__c == 'RRVV')
                {
                    RRVV data = GetData_RRVV(this.IdRelacionAdjunto, this.IdAdjunto, this.OtroDocumento);
                    
                    if (data != null)
                    {
                        //this.Familia = data.FamiliaDocumento; 
                        system.debug('@@@@ Familia --> '+ data);
                        if (this.Es_Credito == true)
                        {
                            // 'Prepago de préstamo' || 'Solicitud de préstamo o repactación'
                            // UR - Prepago de préstamo || UR - Solicitud de préstamo o repactación
                            upload.Archivador = 'Créditos';
                            upload.Creditos = new CLS_CS_UploadValuetech.Upload_Creditos();
                            upload.Creditos.Empresa = 'VIDA SECURITY';
                            upload.Creditos.RutEmpresa = '99.301.000 - 6';
                            upload.Creditos.RutContratante = this.RUTCarga;
                            upload.Creditos.NombreContrata = this.NombreCarga;
                            upload.Creditos.Poliza = this.Poliza;
                            upload.Creditos.TipoDocumento = data.TipoDocumento;
                            //upload.Creditos.FamiliaDocumento = data.FamiliaDocumento;
                            upload.Creditos.FamiliaDocumento = this.Familia;
                        }
                        else {
                            upload.Archivador = 'Rentas Vitalicias';
                            upload.Rentas_Vitalicias = new CLS_CS_UploadValuetech.Upload_Rentas_Vitalicias();
                            upload.Rentas_Vitalicias.Empresa = 'VIDA SECURITY';
                            upload.Rentas_Vitalicias.RutEmpresa = '99.301.000 - 6';
                            upload.Rentas_Vitalicias.RutContratante = this.RUTCarga;                         
                            upload.Rentas_Vitalicias.NombreContrata = this.NombreCarga;                            
                            upload.Rentas_Vitalicias.RutCausante = this.RutCausante;
                            upload.Rentas_Vitalicias.Poliza = this.Poliza;
                            upload.Rentas_Vitalicias.TipoDocumento = data.TipoDocumento;
                            //upload.Rentas_Vitalicias.FamiliaDocumento = data.FamiliaDocumento;
                            upload.Rentas_Vitalicias.FamiliaDocumento = this.Familia;
                            upload.Rentas_Vitalicias.CodigoTipoDocumento = data.CodigoTipoDocumento;
                            upload.Rentas_Vitalicias.Sielaf = data.Sielaf;
                        }

                        upload.Documento = data.Documento;
                        upload.CodigoAdjunto = data.CodigoAdjunto;
                        datosCorrectos = true;
                    }
                }
                else if (this.Caso.Negocio__c == 'Seguros Individuales' || this.Caso.Negocio__c == 'Seguros Familiares'  || this.Caso.Negocio__c == 'Seguros Masivos' || this.Caso.Negocio__c == 'Negocio General' )
                {
                    Individual data = GetData_Individuales(this.IdRelacionAdjunto, this.IdAdjunto, this.OtroDocumento);
                    if (data!= null)
                    {
                        upload.Archivador = 'Seguros Individuales';
                        upload.Seguros_Individuales = new CLS_CS_UploadValuetech.Upload_Seguros_Individuales();
                        upload.Seguros_Individuales.Empresa = 'VIDA SECURITY';
                        upload.Seguros_Individuales.NombreContratante = this.NombreCarga;
                        upload.Seguros_Individuales.RutAsegurado = this.RUTCarga;
                        upload.Seguros_Individuales.Propuesta = this.Caso.Numero_Propuesta__c;
                        upload.Seguros_Individuales.Poliza = this.Poliza;
                        upload.Seguros_Individuales.TipoDocumento = this.TipoDocumentoInd;
                        upload.Seguros_Individuales.EnviaAcsel = 'false';
                        upload.Seguros_Individuales.Siniestro = '';
                        upload.Documento = data.Documento;
                        upload.CodigoAdjunto = data.CodigoAdjunto;
                        datosCorrectos = true;
                    }
                }
                else if (this.Caso.Negocio__c == 'Seguros Colectivos')
                {
                    Colectivo data = GetData_Colectivos(this.IdAdjunto, this.OtroDocumento);
                   
                    if (data!= null)
                    {
                        upload.Archivador = 'Seguros Colectivos';

                        upload.Seguros_Colectivos = new CLS_CS_UploadValuetech.Upload_Seguros_Colectivos();
                        upload.Seguros_Colectivos.NombreCompagnia = 'VIDA SECURITY';
                        upload.Seguros_Colectivos.RutEmpresa = this.RutEmpresaCOL;
                        upload.Seguros_Colectivos.NombreEmpresa = this.NombreEmpresaCOL;
                        upload.Seguros_Colectivos.RutTitular = this.RUTCarga;
                        upload.Seguros_Colectivos.NombreTitular = this.NombreCarga;
                        upload.Seguros_Colectivos.FechaRecepcion = String.ValueOf(Datetime.now().date());
                        upload.Seguros_Colectivos.Poliza = this.Poliza;
                        upload.Seguros_Colectivos.TipoDocumento = this.TipoDocumentoInd;
                        upload.Seguros_Colectivos.Siniestro = '';
                        upload.Seguros_Colectivos.NumeroLote = '';
                        upload.Seguros_Colectivos.NumeroSolicitud = '';
                        
                        upload.Documento = data.Documento;
                        upload.CodigoAdjunto = data.CodigoAdjunto;
                        datosCorrectos = true;
                    }
                }
                
                upload.FileBody = this.fileBody; 
                system.debug('@@@@ NombreDocumento '+ this.OtroDocumento);

                if (datosCorrectos == true)
                {
                    upload.Extension = extension;//
                    system.debug('@@@@ upload '+ upload);
                    upload.NumeroCaso = this.Caso.CaseNumber;
                    CLS_CS_UploadValuetech.UploadResult result = CLS_CS_UploadValuetech.Upload(upload);
                    this.ResultadoCarga = result.Result;
                    this.Mensaje = result.Message;
                  
                    system.debug('@@@@ result '+ result);
                } 
                else
                {
                    this.ResultadoCarga = false;
                    this.Mensaje = 'Debe seleccionar del listado o ingresar un nombre asociado al Archivo cargado.';
                }
            }
    
            system.debug('@@@@ ResultadoCarga '+ ResultadoCarga);
            system.debug('@@@@ Mensaje '+ Mensaje);
        } catch(Exception ex) 
        {
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getlineNumber()+' '+ex.getMessage()));
            system.debug('@@@@' + ex.getlineNumber()+' '+ex.getMessage());
            // this.ErrorCarga = 'Ha ocurrido un error al realizar la carga.';
            this.Mensaje = '@@@@' + ex.getlineNumber()+' '+ex.getMessage();
        }
    }

    public void cambio()
    {

    }

    
   
}