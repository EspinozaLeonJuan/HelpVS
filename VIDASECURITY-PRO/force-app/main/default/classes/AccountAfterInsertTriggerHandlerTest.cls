@IsTest
public class AccountAfterInsertTriggerHandlerTest {
    static testMethod void AccountAfterInsertTriggerHandlerTest() {
        Id recordIdAgente = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId();
        //String idAgente = [SELECT Codigo_agente__c FROM Contact WHERE RecordTypeId = :recordIdAgente AND Estado__c = 'Desvinculado' LIMIT 1].Codigo_agente__c;
        Test.startTest();
        Contact agente = new Contact();
        agente.Codigo_agente__c = '9999999';
        agente.FirstName = 'Agente';
        agente.LastName = 'Individual';
        agente.RecordTypeId = recordIdAgente;
        agente.Estado__c = 'Desvinculado';
        agente.Cargo_Agente__c = 'Agente';
        
        insert agente;
        
        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'CARLOS';
        CUENTA_PRI.LastName = 'ESPINOZA P';
        CUENTA_PRI.PersonEmail = 'cespinoza@microsystem.cl';
        CUENTA_PRI.Rut_contacto__pc = '16790926';
        CUENTA_PRI.DV_contacto__pc = '4';
        CUENTA_PRI.Fecha_Ultimo_Cambio_Propietario__c = Date.today();
        CUENTA_PRI.OwnerId = '005i0000001O3jkAAC';
        CUENTA_PRI.Codigo_Agente__c = '9999999';
        CUENTA_PRI.Agente_Actual__c = agente.Id;
        CUENTA_PRI.Agente_Original__c = agente.Id;
        insert CUENTA_PRI;
        
    Set<Id> ids = new Set<Id>{CUENTA_PRI.id};
        
        
        List<Account> nlist = [
            SELECT Actividad_desde_Reasignaci_n_Ejecutiva__c,Activo__pc,Agente_vigente__c,Campa_a_Masiva__c,Cantidad_de_Meses_sin_Actividades__c,
            Cantidad_de_Meses_sin_Llamados__c,Cantidad_Polizas_Activas_Todas__c,Cantidad_Polizas_Activas__c,Cantidad_Polizas_RV_Activas__c,
            Cant_Meses_sin_Act_desde_Asignacion_Eje__c,Capital_Administrado_UF__c,Categor_a_Cliente_Final__c,Clientes_Contactados__c,
            Cliente_Asegurado_Empresa__c,Cliente_en_campa_a__c,Cliente_Fidelizado__c,Cliente_Inubicable__c,Cliente_No_Contactar__c,Con_Problema_Economico__c,
            Con_Siniestro__c,Copia_Correo_electronico_Persona__c,Correo_Pendiente_de_Envio__c,CreatedById,CreatedDate,
            CUENT_No_quiere_ser_contactado_Televenta__c,CUENT_Participando_en_Campana_Oncologica__c,CurrencyIsoCode,Declarado_Fallecido__c,
            Dias_Con_Ejecutivo__c,Dias_Sin_Ejecutivo__c,Dicom__c,DV_contacto__pc,DV__c,EAP__c,Edad_cliente__c,Edad__c,Ejecutivo_Asignado__c,
            Empresa_declinada__c,Enviar_correo__c,Envio_Informacion__c,Envio_Informacion__pc,Excluido_de_Polizas__c,Factor_Ejecutivo__c,
            Firma_Convenio__c,Firma_pagar__c,FirstName,Holding__c,Id,Incluir_comunicados__pc,Indicador_de_Devolucion_de_Correos__c,
            Indicador_de_Email_Rebotado_o_Malo__c,Indicador_de_Fonos_Malos__c,IsDeleted,IsPersonAccount,LastModifiedById,LastModifiedDate,LastName,
            Lista_Negra__c,Meses_sin_Actividades_ni_Asig_Ejec__c,Meses_sin_Actividad_con_la_Ejecutiva__c,Meses_sin_Llamados_ni_Asignaci_n_Ejec__c,
            Nacionalidad__c,Name,Nombres_Cliente__c,No_cobrar__c,NP_Apellidos__c,NP_Nombres__c,N_de_Hijos_Resumen__c,Omitir_Validaciones_AMAC__c,
            OwnerId,Participa_Campaign_Amac__c,Pendiente_Envio_Encuesta__c,Pensionado__c,Perfil_Propietario__c,PersonContactId,PersonEmail,
            Peso_por_Cuenta__c,PhotoUrl,Plantilla_Atento__c,Plantilla_Ejecutivo__c,Plantilla_Estimado__c,Plantilla_Saludarlo__c,
            Posee_Seguros_con_otras_Cias__c,Postergacion_de_Credito__c,Prima_Mensualizada_Administrada__c,Prima_UFAnualizado__c,Producto_Activo__c,
            Producto_Ahorro_4__c,Producto_Ahorro_5__c,Producto_Ahorro__c,Producto_con_Ahorro_1__c,Producto_con_Ahorro_2__c,Propietario_Activo__c,
            Recibe_Correos_Cumpleanos__c,Reclamos_Ultimo_Anio__c,RecordTypeId,Reenviar__c,Resetear_Sistema_de_Correo_de_Cumplea_os__c,
            rh2__Formula_Test__pc,Rut_contacto__pc,Rut_con_dv__c,Rut__c,Siniestro_Vida__c,Sin_Agente__c,Sin_Trabajo__c,Suma_PrimaUF__c,
            SystemModstamp,Tarjeta_Club_Viva_Mejor__c,Tiene_57__c,Tiene_APV_1__c,Tiene_APV__c,Tiene_Auto__c,Tiene_ejecutivo_de_Cliente__c,
            Tiene_Link_Activo__c,Tramo_de_Edad__c,Valor_Poliza_Total__c,Vive_en_el_Extranjero__c, Categoria_del_Cliente__c, Sincronizar_Ejecutivo__c, ultima_actualizacion_amac__c  
            FROM Account ORDER BY CreatedDate DESC NULLS FIRST LIMIT 1];        
        List<Account> olist;
        Map<Id, Account> omap = new Map<Id, Account>(nlist); 
        Map<Id, Account> nmap; 
        Boolean ib, ia, id, ii, iu, iud, ie, isExtender;
        ITriggerHandler handlerInstance;
        ii = true;
        ib = true;
        System.TriggerOperation triggerOperation = TriggerOperation.AFTER_INSERT;
        String dispatcherHandlerName = 'AccountTriggerDispacher';
        TriggerParameters tp = new TriggerParameters( nlist, nlist, omap, omap, ib, ia, id, ii, iu, iud, ie, isExtender, triggerOperation, dispatcherHandlerName);
        TestTriggerDispatcherBase cls = new TestTriggerDispatcherBase( tp );
        AccountAfterInsertTriggerHandler asd = new AccountAfterInsertTriggerHandler();
        asd.mainEntry(tp);
        Test.stopTest();        
    }
}