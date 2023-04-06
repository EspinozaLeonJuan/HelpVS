/*******************************************************************************************
 *  NOMBRE                 : CTR_EscritorioDigitalError
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CTR_EscritorioDigitalError {
   //llenar esta con la nueva estructura de persistencia y creacion de caso erroneo, luego volver a la ctr_escritoroidigital
   //pendiente ademas subie cambios de derivacion /ya listos
   public Case Caso {get; set;}   
    
   
   public String EtiquetaSolicitud {get; set;}
   public String Poliza { get; set; } 
   
   
   public String Error { get; set; }
  
   ///

  /*Método para mostrar caso y su información relacionada*/
   public PageReference cargaCaso()
   {
      try{
            String IDCASO = apexpages.currentpage().getparameters().get('id');
                     
            if(IDCASO != '')
            {  
               this.Caso = new Case();
               
               if (!Test.isRunningTest()) 
               {
                  this.Caso = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c,
                                    Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c,CaseNumber, Tipo_de_Requerimiento__c, CASO_Resultado_Derivaci_n__c, 
                                    CASO_Responsable_UR__c , Negocio__c, CASO_Categoria__c FROM Case
                                    WHERE Id =: IDCASO];
               }
               
               if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
               {
                  this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
               }
               else
               {                  
                  this.Poliza = 'No seleccionada';
               }
                                          
               this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c); 

               if (String.isBlank(this.EtiquetaSolicitud))
               {
                   this.EtiquetaSolicitud = this.Caso.Detalle_Solicitud__c;
               } 
               
                if (!Test.isRunningTest()) 
                { 
                    this.LoadAlerta();
                }

                return null;               
            }
            else {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
               return null;
            }
         
      }catch (Exception ex)
      {        
            ApexPages.addMessages(ex);  
            return null;          
      }
   }

   public void LoadAlerta()
   {
        String Mensaje = '';

        if (!Test.isRunningTest()) 
        { 
            this.Error = Apexpages.currentPage().GetParameters().get('Error');
        }

        system.debug('@@@@ ERROR_ED --> '+ this.Error);

        if (this.Error == 'RUT_CLIENTE_NO_CORRESPONDE')
        {  
            Mensaje = 'El RUT de Cliente ingresado no es válido o no corresponde a ningún Asegurado registrado.';
        }
        else if (this.Error == 'RUT_CLIENTE_SIN_BENEFICIARIOS')
        {
            Mensaje = 'El RUT de Cliente ingresado no posee beneficiarios asociados para satisfacer el requerimiento solicitado.';
        }
        else if (this.Error == 'POLIZA_OBSOLETA')
        {
            Mensaje = 'La Poliza ingresada se encuentra obsoleta.';
        }
        else if (this.Error == 'POLIZA_NO_INGRESADA')
        {
            Mensaje = 'Debe ingresar una poliza asociada al Requerimiento, Cliente posee mas de una Poliza activa.';
        }
        else if (this.Error == 'CLIENTE_SIN_POLIZAS_ACTIVAS')
        {
            Mensaje = 'El Cliente ingresado no posee una Poliza activa.';
        } 
        else if (this.Error == 'POLIZA_NO_CORRESPONDE')
        {
            Mensaje = 'La Poliza ingresada no existe o no corresponde a el RUT de Cliente ingresado.';
        }
        else if (this.Error == 'CREA_REQUERIMIENTO_EXCEPCION')
        {
            Mensaje = 'Ha ocurrido un error inesperado en la Creación del Requerimiento, favor intente nuevamente. Si el error continua favor comuniquese con los administradores del Sistema.';
        }        
        else if (this.Error == 'PERSISTENCIA_EXCEPCION_CREA_REQ')
        {
            Mensaje = 'Ha ocurrido un error de Comunicación con Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.';
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_EXCEPCION')
        {
            Mensaje = 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'; 
        }
        else if (this.Error == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO')
        {
            Mensaje = 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'; 
        } 
        else if (this.Error == 'REQUERIMIENTO_NO_APV')
        {
            Mensaje = 'El Requerimiento no está habilitado para productos APV.'; 
        } 
        else if (this.Error == 'REQUERIMIENTO_MAX_3')
        {
            Mensaje = 'El Requerimiento está habilitado solo para MAX 3.0'; 
        } 
        else if (this.Error == 'REQUERIMIENTO_MI_SEGURO')
        {
            Mensaje = 'El Requerimiento está habilitado solo para productos Mi Seguro.'; 
        } 
        else if (this.Error == 'REQUERIMIENTO_NO_SOPORTADO')
        {
            Mensaje = 'La Solicitud asociada al Requerimiento no es soportada por Escritorio Digital.'; 
        } 
        else if (this.Error == 'REQUERIMIENTO_CERO')
        {
            Mensaje = 'Ha ocurrido un Error creando el Requerimiento en Escritorio Digital, favor adjuntar el o los documentos asociados al Requerimiento al Caso Salesforce creado.'; 
        } 

        if (String.isBlank(Mensaje) == false)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Mensaje));  
        }   
   }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }

   

}