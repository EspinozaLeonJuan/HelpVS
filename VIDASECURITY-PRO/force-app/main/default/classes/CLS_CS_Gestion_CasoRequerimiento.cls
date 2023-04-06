/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 12-29-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CS_Gestion_CasoRequerimiento {

    public class Data
    {
        @auraEnabled public String Id {get; set;}

        @auraEnabled public String Name {get; set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<Data> getPolizas(String AccountId, String Negocio, String Canal)
    {
        List<Data> polizas = new  List<Data>();

        String RecordTypeId_Colectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();
        String RecordTypeId_Individuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
        String RecordTypeId_Masivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Masivos').getRecordTypeId();
        String RecordTypeId_RRVV = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Rentas Vitalicias').getRecordTypeId();
        String RecordTypeId_PF = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').getRecordTypeId();

        List<Poliza_Colectivo__c> pListCol = new List<Poliza_Colectivo__c>();
        List<Poliza__c> pList = new List<Poliza__c>();

        if (negocio == 'Seguros Colectivos')
        {
            if (canal != 'SEGURO COVID')
            {
                pList = [SELECT Id, Name, Nombre_de_Producto__c FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_Colectivos  ORDER by Name];
            }
            else //solo considera polizas seguro covid
            {
                pList = [SELECT Id, Name, Nombre_de_Producto__c  FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_Colectivos AND Seguro_Covid__c = true  ORDER by Name];
            }

            pListCol = [SELECT Poliza__c, Poliza__r.Name, N_Poliza__c FROM Poliza_Colectivo__c WHERE Cuenta__c =: AccountId ORDER by N_Poliza__c];

            system.debug('@@@@ POL COL SIZE --> '+pListCol.size());
        }
        else if (negocio == 'Seguros Familiares')
        {
           pList = [SELECT Id, Name, Nombre_de_Producto__c FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_PF  ORDER by Name];
        }
        else if (negocio == 'Seguros Individuales')
        {
            pList = [SELECT Id, Name, Nombre_de_Producto__c FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_Individuales   ORDER by Name];
        }
        else if (negocio == 'Seguros Masivos')
        {
            pList = [SELECT Id, Name, Nombre_de_Producto__c FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_Masivos  ORDER by Name];
        }
        else if (negocio == 'RRVV')
        {
            pList = [SELECT Id, Name, Nombre_de_Producto__c FROM Poliza__c WHERE Cuenta__c =: AccountId AND RecordTypeId =: RecordTypeId_RRVV ORDER by Name];
        }
        else
        {
            //Sin linea de negocio
            //Negocio General
        }

        Data dPol;
        for (Poliza__c poliza : pList)
        {
            dPol = new Data();
            dPol.Name = poliza.Name;
            dPol.Id = poliza.Id;
            polizas.add(dPol);
        }

        for (Poliza_Colectivo__c poliza : pListCol)
        {
            dPol = new Data();
            dPol.Name = poliza.Poliza__r.Name;
            dPol.Id = poliza.Poliza__c;
            polizas.add(dPol);
        }

        return polizas;
    }

    //solicitud

    //VASS (SB): 23-12-2022
    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Detalle_Error_Liquidacion() {
        Case kase = new Case();
        return CLS_UTL_Lightning.get_pickList_without_dependency(kase, 'Detalle_Error_de_liquidaci_n__c') ;
    }
    //--------FIN----//
    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Categorias(String Negocio) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.CASO_Categoria__c, Negocio) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_DetalleSolicitud(String Categoria) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Detalle_Solicitud__c, Categoria) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_DetalleRescate(String DetalleSolicitud) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Detalle_de_Rescate__c, DetalleSolicitud) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_DetalleConfiguracion(String DetalleSolicitud) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Detalle_Configuracion__c, DetalleSolicitud) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_CantidadMesesSuspendido() {
        Case kase = new Case();
        return CLS_UTL_Lightning.get_pickList_without_dependency(kase, 'Cantidad_de_meses_suspendido__c');
    }

    @AuraEnabled
    public static String create_CasoRequerimiento_Solicitud(String parentId, String polizaId, String categoria, String detalleSolicitud, String detalleRescate, String detalleConfiguracion, String fechaSuspension, String mesesSuspension, String esProblema, String cierreCaso, String descripcion, String errorLiquidacion)
    {
        system.debug('@@@@ param case create soli cierreCaso :  '+cierreCaso);
        system.debug('@@@@ param case create soli esProblema :  '+esProblema);
        try
        {
            Case casoPadre = [SELECT
										Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, SourceId,
                                  		CommunityId, BusinessHoursId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone,
                                  		SuppliedCompany, Type, RecordTypeId, Status, Reason, Origin, Subject, Priority,
                                  		Description, IsClosed, ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate,
                                  		IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                  		SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate,
                                  		LastReferencedDate, MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName,
                                  		Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, Entrega_Respuesta__c,
                                  		Problema__c, Apellidos__c, Atencion_Presencial__c, Canal__c, Cantidad_Dias__c,
                                  		Cargo_Propietario__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c,
                                  		Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c,
                                  		Correo_Electronico__c, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c,
                                  		Descripcion__c, Descripcion_de_Respuesta__c, Detalle_Operacion__c, Detalle_Solicitud__c,
                                  		Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c,
                                  		Direccion_Solicitante__c, Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c,
                                  		Domicilio_Particular_Completo__c, Email_1__c, Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c,
                                  		Fecha_de_nacimiento__c, Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c,
                                  		Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, Nombre_Solicitante__c,
                                  		Nombres__c, Numero_caso_estandar__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c,
                                  		Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c,
                                  		Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c,
                                  		Tipo_Contacto_Final__c, Tipo_Operacion__c, Tipo_de_Solicitante__c, Campa_a_Mailing__c,
                                  		Fecha_Hora_de_Cierre__c, Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c,
                                  		Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, Fecha_de_EPA_Contact_Center_Caso__c,
                                  		Colectivo_Banco_BCI__c, Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c,
                                  		Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, Detalle_de_Rescate__c,
                                  		Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, Cantidad_Dias_Desde_Creacion__c,
                                  		Cumplimiento_Fecha_Cierre__c, Cliente_Compania__c, Carta_Cliente__c,
                                  		Estado_Requerimiento_EscritorioDigital__c, Id_Requerimiento_EscritorioDigital__c,
                                  		Tipo_Requerimiento_EscritorioDigital__c, Genero__c, Anular_aprobacion_reclamo_repetitivo__c,
                                  		Aprobado_Reclamo__c, Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c,
                                  		Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c,
                                  		CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, CASO_Responsable_UR__c,
                                  		Tipo_de_Requerimiento__c, Corredor__c, Protocolo_Envio_Informacion__c, Es_Protocolo__c, Detalle_Configuracion__c,
                                        Detalle_Error_de_liquidaci_n__c
                                  FROM
                                  		Case
                                  WHERE
                                  		Id =: parentId];

            Case casoHijo = new Case();
            casoHijo.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').getRecordTypeId();
            casoHijo.ParentId = casoPadre.Id;
            casoHijo.Negocio__c = casoPadre.Negocio__c;
            casoHijo.OwnerId = casoPadre.OwnerId;
            casoHijo.AccountId = casoPadre.AccountId;
            casoHijo.ContactId = casoPadre.ContactId;
            casoHijo.Priority = casoPadre.Priority;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_Electronico__c;
            casoHijo.Tipo_de_Solicitante__c = casoPadre.Tipo_de_Solicitante__c;
            casoHijo.Canal__c = casoPadre.Canal__c;
            casoHijo.Origin = casoPadre.Origin;
            casoHijo.Tipo_de_Requerimiento__c = 'Solicitudes';
            casoHijo.Tipo_de_Cliente__c = casoPadre.Tipo_de_Cliente__c;
            casoHijo.Nombre_Solicitante__c = casoPadre.Nombre_Solicitante__c;
            casoHijo.RUT_Solicitante__c = casoPadre.RUT_Solicitante__c;
            casoHijo.Telefono_Solicitante__c = casoPadre.Telefono_Solicitante__c;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_electronico_Solicitante__c;
            casoHijo.Region_Solicitante__c = casoPadre.Region_Solicitante__c;
            casoHijo.Ciudad_Solicitante__c = casoPadre.Ciudad_Solicitante__c;
            casoHijo.Comuna_Solicitante__c = casoPadre.Comuna_Solicitante__c;
            casoHijo.Direccion_Solicitante__c = casoPadre.Direccion_Solicitante__c;
            /*  sección tipificación	*/
            casoHijo.Entrega_Respuesta__c = casoPadre.Entrega_Respuesta__c;
            casoHijo.Fecha_Hora_de_Cierre__c = casoPadre.Fecha_Hora_de_Cierre__c;
            casoHijo.Fecha_Cierre_Tope__c = casoPadre.Fecha_Cierre_Tope__c;
             /* Informacion Requerimiento*/
            casoHijo.CASO_Categoria__c = categoria;
            casoHijo.Detalle_Solicitud__c = detalleSolicitud;
            casoHijo.Detalle_de_Rescate__c = detalleRescate;
            casoHijo.Detalle_Configuracion__c = detalleConfiguracion;
            casoHijo.Description = descripcion;
            casoHijo.Entrega_Respuesta__c = Boolean.valueOf(cierreCaso);
            casoHijo.Problema__c =  Boolean.valueOf(esProblema);
            //casoHijo.Detalle_Error_de_liquidaci_n__c = casoPadre.Detalle_Error_de_liquidaci_n__c;
            casoHijo.Detalle_Error_de_liquidaci_n__c = errorLiquidacion;
            casoHijo.Corredor__c = casoPadre.Corredor__c;

            if (String.isNotBlank(polizaId))
            {
                casoHijo.CASO_Poliza_Asoc__c = [SELECT Name FROM Poliza__c WHERE Id =: polizaId].Name;
                casoHijo.CASO_N_Poliza__c = polizaId;
            }

            if (String.isNotBlank(fechaSuspension))
            {
                String[] fechaInic = fechaSuspension.Split('-');

                casoHijo.Fecha_de_inicio_de_suspensi_n__c = Date.newInstance(Integer.valueOf(fechaInic[2]), Integer.valueOf(fechaInic[1]), Integer.valueOf(fechaInic[0]));
                casoHijo.Cantidad_de_meses_suspendido__c = mesesSuspension;
            }

            if (casoHijo.Entrega_Respuesta__c == false)
            {
                casoHijo.Status = 'Nuevo';
            }
            else {
                casoHijo.Status = 'Cerrado';
            }

            casoHijo.Subject = GetDetalleSolicitud(casoHijo.Detalle_Solicitud__c);

            insert casoHijo;

            return casoHijo.Id;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ex);
            system.debug('@@@@ ex line '+ex.getLineNumber());
            return 'ERROR';
        }
    }



    //consultas

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Conceptos(String Negocio) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Concepto__c, Negocio) ;
    }

    @AuraEnabled
    public static String create_CasoRequerimiento_Consulta(String parentId, String polizaId, String concepto, String esProblema, String cierreCaso, String descripcion, String esProtocolo, String autoAtencion)
    {
        try
        {
            Case casoPadre = [SELECT
										Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, SourceId,
                                  		CommunityId, BusinessHoursId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone,
                                  		SuppliedCompany, Type, RecordTypeId, Status, Reason, Origin, Subject, Priority,
                                  		Description, IsClosed, ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate,
                                  		IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                  		SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate,
                                  		LastReferencedDate, MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName,
                                  		Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, Entrega_Respuesta__c,
                                  		Problema__c, Apellidos__c, Atencion_Presencial__c, Canal__c, Cantidad_Dias__c,
                                  		Cargo_Propietario__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c,
                                  		Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c,
                                  		Correo_Electronico__c, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c,
                                  		Descripcion__c, Descripcion_de_Respuesta__c, Detalle_Operacion__c, Detalle_Solicitud__c,
                                  		Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c,
                                  		Direccion_Solicitante__c, Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c,
                                  		Domicilio_Particular_Completo__c, Email_1__c, Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c,
                                  		Fecha_de_nacimiento__c, Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c,
                                  		Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, Nombre_Solicitante__c,
                                  		Nombres__c, Numero_caso_estandar__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c,
                                  		Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c,
                                  		Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c,
                                  		Tipo_Contacto_Final__c, Tipo_Operacion__c, Tipo_de_Solicitante__c, Campa_a_Mailing__c,
                                  		Fecha_Hora_de_Cierre__c, Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c,
                                  		Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, Fecha_de_EPA_Contact_Center_Caso__c,
                                  		Colectivo_Banco_BCI__c, Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c,
                                  		Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, Detalle_de_Rescate__c,
                                  		Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, Cantidad_Dias_Desde_Creacion__c,
                                  		Cumplimiento_Fecha_Cierre__c, Cliente_Compania__c, Carta_Cliente__c,
                                  		Estado_Requerimiento_EscritorioDigital__c, Id_Requerimiento_EscritorioDigital__c,
                                  		Tipo_Requerimiento_EscritorioDigital__c, Genero__c, Anular_aprobacion_reclamo_repetitivo__c,
                                  		Aprobado_Reclamo__c, Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c,
                                  		Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c,
                                  		CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, CASO_Responsable_UR__c,
                                  		Tipo_de_Requerimiento__c, Corredor__c, Protocolo_Envio_Informacion__c, Es_Protocolo__c, Detalle_Configuracion__c,
                                        Detalle_Error_de_liquidaci_n__c
                                  FROM
                                  		Case
                                  WHERE
                                  		Id =: parentId];

            Case casoHijo = new Case();
            casoHijo.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consultas').getRecordTypeId();
            casoHijo.ParentId = casoPadre.Id;
            casoHijo.Negocio__c = casoPadre.Negocio__c;
            casoHijo.OwnerId = casoPadre.OwnerId;
            casoHijo.AccountId = casoPadre.AccountId;
            casoHijo.ContactId = casoPadre.ContactId;
            casoHijo.Priority = casoPadre.Priority;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_Electronico__c;
            casoHijo.Tipo_de_Solicitante__c = casoPadre.Tipo_de_Solicitante__c;
            casoHijo.Canal__c = casoPadre.Canal__c;
            casoHijo.Origin = casoPadre.Origin;
            casoHijo.Tipo_de_Requerimiento__c = 'Consultas';
            casoHijo.Tipo_de_Cliente__c = casoPadre.Tipo_de_Cliente__c;
            casoHijo.Nombre_Solicitante__c = casoPadre.Nombre_Solicitante__c;
            casoHijo.RUT_Solicitante__c = casoPadre.RUT_Solicitante__c;
            casoHijo.Telefono_Solicitante__c = casoPadre.Telefono_Solicitante__c;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_electronico_Solicitante__c;
            casoHijo.Region_Solicitante__c = casoPadre.Region_Solicitante__c;
            casoHijo.Ciudad_Solicitante__c = casoPadre.Ciudad_Solicitante__c;
            casoHijo.Comuna_Solicitante__c = casoPadre.Comuna_Solicitante__c;
            casoHijo.Direccion_Solicitante__c = casoPadre.Direccion_Solicitante__c;
            /*  sección tipificación	*/
            casoHijo.Entrega_Respuesta__c = casoPadre.Entrega_Respuesta__c;
            casoHijo.Fecha_Hora_de_Cierre__c = casoPadre.Fecha_Hora_de_Cierre__c;
            casoHijo.Fecha_Cierre_Tope__c = casoPadre.Fecha_Cierre_Tope__c;
             /* Informacion Requerimiento*/
            casoHijo.Concepto__c = concepto;
            casoHijo.Description = descripcion;
            casoHijo.Entrega_Respuesta__c = Boolean.valueOf(cierreCaso);
            casoHijo.Problema__c =  Boolean.valueOf(esProblema);
            casoHijo.Es_Protocolo__c =  Boolean.valueOf(esProtocolo);

            casoHijo.Detalle_Error_de_liquidaci_n__c = casoPadre.Detalle_Error_de_liquidaci_n__c;
            casoHijo.Corredor__c = casoPadre.Corredor__c;

            if (casoHijo.Es_Protocolo__c == true)
            {
                casoHijo.Protocolo_Envio_Informacion__c =  autoAtencion;
            }

            if (String.isNotBlank(polizaId))
            {
                casoHijo.CASO_Poliza_Asoc__c = [SELECT Name FROM Poliza__c WHERE Id =: polizaId].Name;
                casoHijo.CASO_N_Poliza__c = polizaId;
            }

            if (casoHijo.Entrega_Respuesta__c == false)
            {
                casoHijo.Status = 'Nuevo';
            }
            else {
                casoHijo.Status = 'Cerrado';
            }

            casoHijo.Subject = casoHijo.Concepto__c;

            insert casoHijo;

            return casoHijo.Id;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ex);
            system.debug('@@@@ ex line '+ex.getLineNumber());
            return 'ERROR';
        }
    }


    //reclamos
    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Productos(String Negocio) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Producto__c, Negocio) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_TipoOperacion(String Producto) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Tipo_Operacion__c, Producto) ;
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_DetalleOperacion(String TipoOperacion) {
        return CLS_UTL_Lightning.get_pickList_with_dependency(Case.Detalle_Operacion__c, TipoOperacion) ;
    }

    @AuraEnabled
    public static String create_CasoRequerimiento_Reclamo(String parentId, String polizaId, String producto, String tipoOperacion, String detalleOperacion, String esProblema, String respuestaCarta, String respuestaEmail, String descripcion)
    {
        try
        {
            Case casoPadre = [SELECT
										Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, SourceId,
                                  		CommunityId, BusinessHoursId, ParentId, SuppliedName, SuppliedEmail, SuppliedPhone,
                                  		SuppliedCompany, Type, RecordTypeId, Status, Reason, Origin, Subject, Priority,
                                  		Description, IsClosed, ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate,
                                  		IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                                  		SystemModstamp, ContactPhone, ContactMobile, ContactEmail, ContactFax, LastViewedDate,
                                  		LastReferencedDate, MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName,
                                  		Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, Entrega_Respuesta__c,
                                  		Problema__c, Apellidos__c, Atencion_Presencial__c, Canal__c, Cantidad_Dias__c,
                                  		Cargo_Propietario__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c,
                                  		Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c,
                                  		Correo_Electronico__c, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c,
                                  		Descripcion__c, Descripcion_de_Respuesta__c, Detalle_Operacion__c, Detalle_Solicitud__c,
                                  		Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c,
                                  		Direccion_Solicitante__c, Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c,
                                  		Domicilio_Particular_Completo__c, Email_1__c, Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c,
                                  		Fecha_de_nacimiento__c, Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c,
                                  		Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, Nombre_Solicitante__c,
                                  		Nombres__c, Numero_caso_estandar__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c,
                                  		Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c,
                                  		Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c,
                                  		Tipo_Contacto_Final__c, Tipo_Operacion__c, Tipo_de_Solicitante__c, Campa_a_Mailing__c,
                                  		Fecha_Hora_de_Cierre__c, Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c,
                                  		Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, Fecha_de_EPA_Contact_Center_Caso__c,
                                  		Colectivo_Banco_BCI__c, Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c,
                                  		Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, Detalle_de_Rescate__c,
                                  		Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, Cantidad_Dias_Desde_Creacion__c,
                                  		Cumplimiento_Fecha_Cierre__c, Cliente_Compania__c, Carta_Cliente__c,
                                  		Estado_Requerimiento_EscritorioDigital__c, Id_Requerimiento_EscritorioDigital__c,
                                  		Tipo_Requerimiento_EscritorioDigital__c, Genero__c, Anular_aprobacion_reclamo_repetitivo__c,
                                  		Aprobado_Reclamo__c, Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c,
                                  		Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c,
                                  		CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, CASO_Responsable_UR__c,
                                  		Tipo_de_Requerimiento__c, Corredor__c, Protocolo_Envio_Informacion__c, Es_Protocolo__c, Detalle_Configuracion__c,
                                        Detalle_Error_de_liquidaci_n__c
                                  FROM
                                  		Case
                                  WHERE
                                  		Id =: parentId];

            Case casoHijo = new Case();
            casoHijo.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
            casoHijo.ParentId = casoPadre.Id;
            casoHijo.Negocio__c = casoPadre.Negocio__c;
            casoHijo.OwnerId = casoPadre.OwnerId;
            casoHijo.AccountId = casoPadre.AccountId;
            casoHijo.ContactId = casoPadre.ContactId;
            casoHijo.Priority = casoPadre.Priority;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_Electronico__c;
            casoHijo.Tipo_de_Solicitante__c = casoPadre.Tipo_de_Solicitante__c;
            casoHijo.Canal__c = casoPadre.Canal__c;
            casoHijo.Origin = casoPadre.Origin;
            casoHijo.Tipo_de_Requerimiento__c = 'Reclamos';
            casoHijo.Tipo_de_Cliente__c = casoPadre.Tipo_de_Cliente__c;
            casoHijo.Nombre_Solicitante__c = casoPadre.Nombre_Solicitante__c;
            casoHijo.RUT_Solicitante__c = casoPadre.RUT_Solicitante__c;
            casoHijo.Telefono_Solicitante__c = casoPadre.Telefono_Solicitante__c;
            casoHijo.Correo_electronico_Solicitante__c = casoPadre.Correo_electronico_Solicitante__c;
            casoHijo.Region_Solicitante__c = casoPadre.Region_Solicitante__c;
            casoHijo.Ciudad_Solicitante__c = casoPadre.Ciudad_Solicitante__c;
            casoHijo.Comuna_Solicitante__c = casoPadre.Comuna_Solicitante__c;
            casoHijo.Direccion_Solicitante__c = casoPadre.Direccion_Solicitante__c;
            /*  sección tipificación	*/
            casoHijo.Entrega_Respuesta__c = casoPadre.Entrega_Respuesta__c;
            casoHijo.Fecha_Hora_de_Cierre__c = casoPadre.Fecha_Hora_de_Cierre__c;
            casoHijo.Fecha_Cierre_Tope__c = casoPadre.Fecha_Cierre_Tope__c;
             /* Informacion Requerimiento*/
            casoHijo.Producto__c = producto;
            casoHijo.Tipo_Operacion__c = tipoOperacion;
            casoHijo.Detalle_Operacion__c = detalleOperacion;
            casoHijo.Problema__c =  Boolean.valueOf(esProblema);
            casoHijo.Respuesta_por_Carta__c =  Boolean.valueOf(respuestaCarta);
            casoHijo.Respuesta_por_Email__c =  Boolean.valueOf(respuestaEmail);
            casoHijo.Description = descripcion;

            casoHijo.Detalle_Error_de_liquidaci_n__c = casoPadre.Detalle_Error_de_liquidaci_n__c;
            casoHijo.Corredor__c = casoPadre.Corredor__c;
            if (String.isNotBlank(polizaId))
            {
                casoHijo.CASO_Poliza_Asoc__c = [SELECT Name FROM Poliza__c WHERE Id =: polizaId].Name;
                casoHijo.CASO_N_Poliza__c = polizaId;
            }

            casoHijo.Subject = casoHijo.Detalle_Operacion__c;

            insert casoHijo;

            return casoHijo.Id;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ex '+ex);
            system.debug('@@@@ ex line '+ex.getLineNumber());
            return 'ERROR';
        }
    }


    @AuraEnabled
    public static Boolean SaveStatusCase(String Id, String Status, Boolean UpdateParent)
    {
        try
        {
            Case caso = [SELECT Id, Status, Sub_estado__c, Entrega_Respuesta__c, ParentId FROM Case WHERE Id =: Id];


            caso.Status = Status;

            if (Status == 'Cerrado')
            {
                caso.Entrega_Respuesta__c = true;

            }
            else if (Status == 'En Proceso')
            {
                caso.Entrega_Respuesta__c= false;
            }
            else
            {
                caso.Entrega_Respuesta__c= false;
            }

            update caso;

            if (UpdateParent == true && (Status == 'En Proceso' || Status == 'Cerrado'))
            {
                Case parentCase = [SELECT Id, Status, Sub_estado__c, Entrega_Respuesta__c, ParentId FROM Case WHERE Id =: caso.ParentId];

                parentCase.Status = Status;

                if (Status == 'Cerrado')
                {
                    List<Case> casosAbiertos = [SELECT Id, CaseNumber FROM Case WHERE ParentId =: parentCase.Id
                    AND (Status = 'En Proceso' OR  Status = 'Nuevo' OR Status = 'Back Office'  OR Status = 'En Revisión' ) ];

                    if (casosAbiertos.size() == 0)
                    {
                        parentCase.Entrega_Respuesta__c = true;
                        update parentCase;
                    }
                }
                else
                {
                    parentCase.Entrega_Respuesta__c= false;
                    update parentCase;
                }
            }

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }




    @AuraEnabled(cacheable=true)
    public static String get_esCasoDerivable(String IdCaso) {
        Boolean DerivacionPermitida = CLS_CS_Derivacion_Validaciones.Es_DerivacionPermitida(IdCaso);
        return String.valueOf(DerivacionPermitida);
    }

    @AuraEnabled(cacheable=true)
    public static String get_esDerivacionOptativa(String IdCaso) {
        Boolean DerivacionOptativa = CLS_CS_Derivacion_Validaciones.Es_DerivacionOptativa(IdCaso);
        system.debug('@@@@ Dervicacion Optativa '+ DerivacionOptativa);
        return String.valueOf(DerivacionOptativa);
        //return String.valueOf(true);
    }


    @AuraEnabled(cacheable=true)
    public static String get_cambioEscritorioDigital(String IdCaso) {
        String cambioED  = CLS_CS_Derivacion_Escritorio.Valida_EstadoRequerimiento(IdCaso, UserInfo.getUserId());
        system.debug('@@@@ cambioED  '+ cambioED);
        return cambioED;
        //return String.valueOf(true);
    }

    @AuraEnabled
    public static Boolean DerivarCaso(String Id, String Motivo)
    {
        try
        {
            Case tmp = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: Id];

            if (String.isBlank(tmp.OwnerId__c))
            {
                User u = [SELECT Id, Email FROM User WHERE Id =: tmp.OwnerId];
                tmp.Email_Deriva_Caso__c = u.Email;
                tmp.OwnerId__c = tmp.OwnerId;
                update tmp;
            }

            Case caso = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, Motivo_Derivacion__c, CreatedById FROM Case WHERE Id =: Id];

            if (caso.Status == 'En Revisión')
            {
                DerivaCaso(caso, true, '');
            }
            else {
                DerivaCaso(caso, false, Motivo);
            }

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }

    private static void DerivaCaso(Case c, Boolean revision, String motivo)
    {
        Database.DMLOptions dmo = new Database.DMLOptions();
        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
        c.setOptions(dmo);
        List<Case> lsC = new List<Case>();
        c.Status = 'Back Office';
        c.CASO_Deriva_a_UR__c = true;
        if (String.isNotBlank(motivo))
        {
            c.Motivo_Derivacion__c =  motivo;
        }
        lsC.add(c);
        Database.update(lsC,dmo);

        CLS_CS_Derivacion_Proceso CLAsign = new CLS_CS_Derivacion_Proceso();

        if (revision == true)
        {
            CLAsign.ReasignarCaso(c.Id);
        }
        else {
            CLAsign.AsignarCaso(c);
        }

        try
        {
            Case caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];

            if(caso != null)
            {
                CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso);//Validar si propietario es Manuel Poblete
            }

        }catch(Exception ex)
        {
            system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
            system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<Adjunto__c> getAdjuntosCaso(String Id) {
        system.debug('@@@@ getAdjuntosCaso  --> '+Id );
        return [SELECT Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, Id_Retorno__c, Codigo_Adjunto__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById, CreatedBy.Name, Xml__c FROM Adjunto__c
                    WHERE IdCaso__c =: Id ORDER BY CreatedDate DESC];

    }

///

    @AuraEnabled(cacheable=true)
    public static List<Data> getOptionsProtocolo()
    {
        List<Data> options = new  List<Data>();

        Data opt1 = new Data();
        opt1.Name = 'SI';
        opt1.Id = 'SI';
        options.add(opt1);

        Data opt2 = new Data();
        opt2.Name = 'NO';
        opt2.Id = 'NO';
        options.add(opt2);

        return options;
    }

    @AuraEnabled(cacheable=true)
    public static Boolean getIsProtocoloAtencion(String Concepto)
    {
        String perfilesProtocolo = CLS_OBJ_Parameter.GetValue('PROTOCOLO_ATENCION_PERFILES');
        String[] listadoPerfiles = perfilesProtocolo.split('\\|');
        String perfilUsuario = [SELECT Name FROM Profile WHERE Id =:  UserInfo.getProfileId()].Name;

        if (listadoPerfiles.contains(perfilUsuario))
        {
            String tipificacionesProtocolo = CLS_OBJ_Parameter.GetValue('PROTOCOLO_ATENCION_CONCEPTOS');

            String[] listadoTipificaciones = tipificacionesProtocolo.split('\\|');

            if (listadoTipificaciones.contains(Concepto) == true)
            {
                return true;
            }
        }

        return false;
    }


    public static String GetDetalleSolicitud(String solicitud)
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
        // else if(solicitud == 'Solicitud endoso')
        // {
        //     asunto = 'Solicitud endoso a la póliza';
        // }
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

        if (String.isBlank(asunto))
        {
            asunto = solicitud;
        }

        return asunto;
    }

}