/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Caso_GeneraPDF															|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Generación de PDF para posteior envio de correo a cliente vinculado a Caso     |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public class CTR_UR_Caso_GeneraPDF {

    public Case CasoPDF {get; set;}
    public Account CuentaPDF {get; set;}
    public Contact ContactoPDF {get; set;}
    public Poliza__c PolizaPDF {get; set;}

    public String NumeroCasoPDF {get; set;}
    public String AsuntoCasoPDF {get; set;}
    public String ComentarioCasoPDF {get; set;}
    public String ClientePDF {get; set;}
    public String NumeroPolizaPDF {get; set;}
        
    public Date FechaPDF {get; set;}
    public String MesPDF {get; set;}

    public String IdCaso {get; set;}
    public String Estado {get; set;}

    public String NombreFirmaPDF  {get; set;}
    public String CargoFirmaPDF  {get; set;}
    public String EmpresaFirmaPDF  {get; set;}    

    public CTR_UR_Caso_GeneraPDF() {

    }

    public PageReference cargaPDF(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                this.IdCaso = ApexPages.currentPage().getParameters().get('id');              
            }
            
            this.NombreFirmaPDF  = 'Hernán Ríos L.';
            this.CargoFirmaPDF = 'Gerente de Clientes';
            this.EmpresaFirmaPDF = 'Vida Security S.A.';    

            //Objeto caso...
            this.CasoPDF = [SELECT AccountId, Anular_aprobacion_reclamo_repetitivo__c, Apellidos__c, Aprobado_Reclamo__c, 
                        Atencion_Presencial__c, BusinessHoursId, CASO_Activa_Flujo_Notificaci_n_Cliente__c, 
                        CASO_Asunto_Notificaci_n__c, CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_Mensaje_Notificaci_n__c, 
                        CASO_N_Poliza__c, CASO_Poliza_Asoc__c, CASO_Responsable_UR__c, CASO_Resultado_Derivaci_n__c, 
                        Campa_a_Mailing__c, Canal__c, Cantidad_Dias_Desde_Creacion__c, Cantidad_Dias__c, 
                        Cantidad_de_Dias_Abierto__c, Cantidad_de_dias_H__c, Cargo_Propietario__c, Carta_Cliente__c, 
                        CaseNumber, Casos_Hijos_cerrados__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, 
                        Ciudad_Solicitante__c, Cliente_Colectivo__c, Cliente_Compania__c, ClosedDate, Colectivo_Banco_BCI__c, 
                        Comments, CommunityId, Complejidad_Numerico__c, Complejidad_del_Reclamo__c, Comuna_Comercial__c, 
                        Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c, Concepto__c, ContactEmail, ContactFax, 
                        ContactId, ContactMobile, ContactPhone, Correo_Electronico__c, Correo_Instancia_del_Reclamo__c, 
                        Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, CreatedById, CreatedDate, 
                        CreatorFullPhotoUrl, CreatorName, CreatorSmallPhotoUrl, Cumplimiento_Fecha_Cierre__c, 
                        D_as_restantes_para_cerrar_Reclamo__c, Descripcion__c, Descripcion_de_Respuesta__c, Description, 
                        Detalle_Operacion__c, Detalle_Solicitud__c, Detalle_de_Rescate__c, Dia_de_Creacion__c, 
                        Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c, Direccion_Solicitante__c, 
                        Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, 
                        Email_1__c, Email_2__c, Email_Contacto__c, EntitlementId, Entrega_Respuesta__c, 
                        Estado_Requerimiento_EscritorioDigital__c, Fecha_Cierre_Tope__c, Fecha_Hora_de_Cierre__c, 
                        Fecha_de_EPA_Contact_Center_Caso__c, Fecha_de_nacimiento__c, Fecha_tope_Vida_Security__c, 
                        Funci_n_Propietario_del_Caso__c, G_Asistencia_Agentes__c, Genero__c, IDVS__c, Id, IdPoliza__c, 
                        Id_Requerimiento_EscritorioDigital__c, Instancia_del_Reclamo__c, IsClosed, IsDeleted, IsEscalated, 
                        IsStopped, LInea_Negocio_Final__c, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, 
                        Linea_Negocio__c, Llamadas_Out__c, MilestoneStatus, Negocio__c, Nombre_Completo_Razon_Social__c, 
                        Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Numero_de_Caso_Anterior__c, 
                        Numero_de_Caso_Inicial__c, Numero_del_Caso_Original__c, Origin, OwnerId, ParentId, PolizaED__c, 
                        Priority, Problema__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Reasignar_a_Rut__c, 
                        Reason, RecordTypeId, Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, SlaExitDate, 
                        SlaStartDate, Solicita_envio_a_otra_direccion__c, SourceId, Status, StopStartDate, Subject, 
                        Sucursal_del_Propietario__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, 
                        Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c, Tipo_Contacto_Final__c, 
                        Tipo_Operacion__c, Tipo_Requerimiento_EscritorioDigital__c, Tipo_de_Cliente__c, Tipo_de_Contacto__c, 
                        Tipo_de_Requerimiento__c, Tipo_de_Resoluci_n_del_Reclamo__c, Tipo_de_Solicitante__c, Type 
                        FROM Case
                        WHERE Id =: this.IdCaso];
            
            if(this.CasoPDF != null)
            {
                //Rescate Cuenta o Contacto Asociado o Solicitante
                if(this.CasoPDF.AccountId != null){
                    this.CuentaPDF = [SELECT Id, Name, IsPersonAccount, PersonEmail, PersonContactId FROM Account WHERE Id =: this.CasoPDF.AccountId];
                    if(this.CuentaPDF != null){
                        if(this.CuentaPDF.IsPersonAccount == True){
                            ClientePDF = this.CuentaPDF.Name;
                        }else{
                            if(this.CasoPDF.ContactId != null){
                                this.ContactoPDF = [SELECT Id, Name, Email FROM Contact WHERE Id =: this.CasoPDF.ContactId];
                                if(this.ContactoPDF != null){
                                    this.ClientePDF = this.ContactoPDF.Name;
                                }
                            }
                        }
                    }
                }else{
                    this.ClientePDF = this.CasoPDF.Nombre_Solicitante__c;
                }
                
                //Rescate Póliza Asociada
                if(this.CasoPDF.CASO_N_Poliza__c != null){
                    this.PolizaPDF = [SELECT Id, Name, Cuenta__c FROM Poliza__c WHERE Id =: this.CasoPDF.CASO_N_Poliza__c];
                    if(this.PolizaPDF != null){
                        this.NumeroPolizaPDF = this.PolizaPDF.Name;
                    }
                }
                
                //Rescate otros datos...
                this.FechaPDF = Date.today();
                
                this.MesPDF = this.GetMes(this.FechaPDF.month());
                
                this.NumeroCasoPDF = this.CasoPDF.CaseNumber;
                this.AsuntoCasoPDF = this.CasoPDF.CASO_Asunto_Notificaci_n__c;
                this.ComentarioCasoPDF = this.CasoPDF.CASO_Mensaje_Notificaci_n__c;
                
                system.debug('@@@@ Asunto => ' + this.CasoPDF.CASO_Asunto_Notificaci_n__c);
                system.debug('@@@@ Mensaje => ' + this.CasoPDF.CASO_Mensaje_Notificaci_n__c);
                system.debug('@@@@ Asunto => ' + this.AsuntoCasoPDF);
                system.debug('@@@@ Mensaje => ' + this.ComentarioCasoPDF);
            }
            
            return null;
            
        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
            return null;
        }
        
    }

    public String GetMes(Integer mes)
    {
        String[] meses = new List<String>(13);

        meses[0] = '';
        meses[1] = 'Enero';
        meses[2] = 'Febrero';
        meses[3] = 'Marzo';
        meses[4] = 'Abril';
        meses[5] = 'Mayo';
        meses[6] = 'Junio';
        meses[7] = 'Julio';
        meses[8] = 'Agosto';
        meses[9] = 'Septiembre';
        meses[10] = 'Octubre';
        meses[11] = 'Noviembre';
        meses[12] = 'Diciembre';
                
        return meses[mes];
    }
}