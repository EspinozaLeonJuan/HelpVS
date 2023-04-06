/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-18-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_LEAD_Gestion_ProspectoLinks {
    public CLS_LEAD_Gestion_ProspectoLinks() {

    }

    public class Node {
        public String key {get; set;}

        public String value {get; set;}
    }

   @AuraEnabled
   public static Boolean permission_specialfields()
   {
       List<String> profiles = new List<String>();
       profiles.add('Administrador del sistema');
       profiles.add('Gestor Funcional');
       profiles.add('Area Segmento - Gestión Marketing');
       profiles.add('Area Televenta - Gestión Supervisor');

       List<Profile> eval = [SELECT Id FROM Profile WHERE Name IN : profiles AND Id =: UserInfo.getProfileId()];

       if (eval.size() > 0)
       {
           return true;
       }

       return false;
   }

   @AuraEnabled
   public static Boolean update_custom_fields(String Id, String parameters){
    system.debug('@@@@ update_custom_fields');
       try {
           system.debug('@@@@ Id  ->  '+ Id);
           system.debug('@@@@ parameters  ->  '+ parameters);

           List<Node> fields = ( List<Node>) json.deserialize(parameters,  List<Node>.class);

            Lead lead = [SELECT Tipo_Mailing__c, Nombre_producto_en_campa_a__c, Numero_Poliza_Campagna__c, Fecha_inicio_vigencia_Poliza_Campagna__c, Periodicidad_pago_Poliza_Campagna__c, Medio_Pago_Poliza_Campagna__c, Capital_Fallecimiento_Poliza_Campagna__c, Prima_Poliza_Campagna__c, Simulacion_1__c, Simulacion_2__c, Simulacion_3__c, Simulacion_4__c, Simulacion_5__c, Simulacion_6__c, Supuesto_simulacion_1__c, Supuesto_simulacion_2__c, Supuesto_simulacion_3__c, Ultimo_producto_contratado__c, Numero_ultima_Poliza_contratada__c, Fecha_inicio_vigencia_ultima_Poliza_cont__c, Periodicidad_pago_ultima_Poliza_contr__c, Medio_Pago_ultima_Poliza_contr__c, Capital_fallecimiento_ultima_Poliza_cont__c, Prima_ultima_Poliza_contratada__c, Aumento_potencial_de_prima__c, Producto_recomendado__c, Capital_recomendado__c, Cobertura_recomendada__c, Prima_producto_cobertura_recomendada__c, Supuestos_1__c, Supuestos_2__c, Supuestos_3__c, Deposito_esporadico_o_convenido_ultimos__c, Periodo_1__c, Monto_total_deposito_esporadico_1__c, Monto_promedio_deposito_esporadico_1__c, Periodo_2__c, Monto_total_deposito_esporadico_2__c, Monto_promedio_deposito_esporadico_2__c, Periodo_3__c, Monto_total_deposito_esporadico_3__c, Monto_promedio_deposito_esporadico_3__c, Informacion_Adicional_1__c, Informacion_Adicional_2__c, Informacion_Adicional_3__c, Informacion_Adicional_4__c, Informacion_Adicional_5__c, Informacion_Adicional_6__c, Informacion_Adicional_7__c, Informacion_Adicional_8__c FROM Lead WHERE Id =: Id];

            lead.Tipo_Mailing__c = data_custom_field(fields, 'f_tipo_mailing');
            lead.Nombre_producto_en_campa_a__c = data_custom_field(fields, 'f_nombre_producto_campagna');
            lead.Numero_Poliza_Campagna__c = data_custom_field(fields, 'f_numero_poliza_campagna');
            lead.Fecha_inicio_vigencia_Poliza_Campagna__c = getDateValue(data_custom_field(fields, 'f_fecha_inicio_vigencia_poliza_campagna'));
            lead.Periodicidad_pago_Poliza_Campagna__c = data_custom_field(fields, 'f_periodicidad_pago_poliza_campagna');
            lead.Medio_Pago_Poliza_Campagna__c = data_custom_field(fields, 'f_medio_pago_poliza_campagna');
            lead.Capital_Fallecimiento_Poliza_Campagna__c = getDecimalValue(data_custom_field(fields, 'f_tipo_mf_capital_fallecimiento_poliza_campagnaailing'));
            lead.Prima_Poliza_Campagna__c = getDecimalValue(data_custom_field(fields, 'f_prima_poliza_campagna'));
            lead.Simulacion_1__c = data_custom_field(fields, 'f_simulacion_1');
            lead.Simulacion_2__c = data_custom_field(fields, 'f_simulacion_2');
            lead.Simulacion_3__c = data_custom_field(fields, 'f_simulacion_3');
            lead.Simulacion_4__c = data_custom_field(fields, 'f_simulacion_4');
            lead.Simulacion_5__c = data_custom_field(fields, 'f_simulacion_5');
            lead.Simulacion_6__c = data_custom_field(fields, 'f_simulacion_6');
            lead.Supuesto_simulacion_1__c = data_custom_field(fields, 'f_supuesto_simulacion_1');
            lead.Supuesto_simulacion_2__c = data_custom_field(fields, 'f_supuesto_simulacion_2');
            lead.Supuesto_simulacion_3__c = data_custom_field(fields, 'f_supuesto_simulacion_3');
            lead.Ultimo_producto_contratado__c = data_custom_field(fields, 'f_ultimo_producto_contratado');
            lead.Numero_ultima_Poliza_contratada__c = data_custom_field(fields, 'f_numero_ultima_poliza_contratada');
            lead.Fecha_inicio_vigencia_ultima_Poliza_cont__c = getDateValue(data_custom_field(fields, 'f_fecha_inicio_vigencia_ultima_poliza_cont'));
            lead.Periodicidad_pago_ultima_Poliza_contr__c = data_custom_field(fields, 'f_periodicidad_pago_ultima_poliza_contr');
            lead.Medio_Pago_ultima_Poliza_contr__c = data_custom_field(fields, 'f_medio_pago_ultima_poliza_contr');
            lead.Capital_fallecimiento_ultima_Poliza_cont__c = getDecimalValue(data_custom_field(fields, 'f_capital_fallecimiento_ultima_poliza_cont'));
            lead.Prima_ultima_Poliza_contratada__c = getDecimalValue(data_custom_field(fields, 'f_prima_ultima_poliza_contratada'));
            lead.Aumento_potencial_de_prima__c = data_custom_field(fields, 'f_aumento_potencial_de_prima');//
            lead.Producto_recomendado__c = data_custom_field(fields, 'f_producto_recomendado');
            lead.Capital_recomendado__c = getDecimalValue(data_custom_field(fields, 'f_capital_recomendado'));
            lead.Cobertura_recomendada__c = data_custom_field(fields, 'f_cobertura_recomendada');
            lead.Prima_producto_cobertura_recomendada__c = getDecimalValue(data_custom_field(fields, 'f_prima_producto_cobertura_recomendada'));
            lead.Supuestos_1__c = data_custom_field(fields, 'f_supuestos_1');
            lead.Supuestos_2__c = data_custom_field(fields, 'f_supuestos_2');
            lead.Supuestos_3__c = data_custom_field(fields, 'f_supuestos_3');
            lead.Deposito_esporadico_o_convenido_ultimos__c = getBooleanValue(data_custom_field(fields, 'f_deposito_esporadico_o_convenido_ultimos'));
            lead.Periodo_1__c = data_custom_field(fields, 'f_periodo_1');
            lead.Monto_total_deposito_esporadico_1__c = getDecimalValue(data_custom_field(fields, 'f_monto_total_deposito_esporadico_1'));
            lead.Monto_promedio_deposito_esporadico_1__c = getDecimalValue(data_custom_field(fields, 'f_monto_promedio_deposito_esporadico_1'));
            lead.Periodo_2__c = data_custom_field(fields, 'f_periodo_2');
            lead.Monto_total_deposito_esporadico_2__c = getDecimalValue(data_custom_field(fields, 'f_monto_total_deposito_esporadico_2'));
            lead.Monto_promedio_deposito_esporadico_2__c = getDecimalValue(data_custom_field(fields, 'f_monto_promedio_deposito_esporadico_2'));
            lead.Periodo_3__c = data_custom_field(fields, 'f_periodo_3');
            lead.Monto_total_deposito_esporadico_3__c = getDecimalValue(data_custom_field(fields, 'f_monto_total_deposito_esporadico_3'));
            lead.Monto_promedio_deposito_esporadico_3__c = getDecimalValue(data_custom_field(fields, 'f_monto_promedio_deposito_esporadico_3'));
            lead.Informacion_Adicional_1__c = data_custom_field(fields, 'f_informacion_adicional_1');
            lead.Informacion_Adicional_2__c = data_custom_field(fields, 'f_informacion_adicional_2');
            lead.Informacion_Adicional_3__c = data_custom_field(fields, 'f_informacion_adicional_3');
            lead.Informacion_Adicional_4__c = data_custom_field(fields, 'f_informacion_adicional_4');
            lead.Informacion_Adicional_5__c = data_custom_field(fields, 'f_informacion_adicional_5');
            lead.Informacion_Adicional_6__c = data_custom_field(fields, 'f_informacion_adicional_6');
            lead.Informacion_Adicional_7__c = data_custom_field(fields, 'f_informacion_adicional_7');
            lead.Informacion_Adicional_8__c = data_custom_field(fields, 'f_informacion_adicional_8');

            update lead;
            return true;
       }
       catch (Exception e) {
            system.debug('@@@@ Exception  ->  '+ e);
            return false;
       }
   }

   private static String data_custom_field(List<Node> fields, String qField)
   {
       String dataField = '';

        for (Node nodo : fields)
        {
            if (nodo.key == qField)
            {
                dataField = nodo.value;
                break;
            }
        }

        return dataField;
   }

   private static Date getDateValue(String dValue)
   {
       try
       {
            if (String.isNotBlank(dvalue))
            {
                String[] vDate = dvalue.split('-');
                Date fecha = Date.newInstance(Integer.valueOf(vDate[0]), Integer.valueOf(vDate[1]), Integer.valueOf(vDate[2]));
                return fecha;
            }
       }
       catch (Exception ex) {}

       return null;
   }


   private static Time getTimeValue(String dValue)
   {
       try
       {
            if (String.isNotBlank(dvalue))
            {
                String[] strTimeSplit = dValue.split(':');
                Time timeChange = Time.newInstance( Integer.valueOf(strTimeSplit[0]) //hour
                                                   ,Integer.valueOf(strTimeSplit[1]) //min
                                                   ,0                                //sec
                                                   ,0);
                return timeChange;
            }
       }
       catch (Exception ex) {}

       return null;
   }


   private static Datetime getDatetimeValue(String dValue)
   {
       try
       {
            if (String.isNotBlank(dvalue))
            {
                String[] strComponents = dValue.split('T');

                String[] date_array = strComponents[0].split('-');
                String[] time_array = strComponents[1].split(':');

                Datetime dateT = DateTime.newInstanceGMT(Integer.valueOf(date_array[0]),
                                                             Integer.valueOf(date_array[1]),
                                                             Integer.valueOf(date_array[2]),
                                                             Integer.valueOf(time_array[0]),
                                                             Integer.valueOf(time_array[1]),
                                                             0);

                system.debug('@@@@ dateT '+dateT);
                return dateT;
            }
       }
       catch (Exception ex) {}

       return null;
   }

   private static Decimal getDecimalValue(String dValue)
   {
       try
       {
            if (String.isNotBlank(dvalue))
            {
                return Decimal.valueOf(dvalue);
            }
       }
       catch (Exception ex) {}

       return null;
   }

   private static Boolean getBooleanValue(String dValue)
   {
       try
       {
            if (String.isNotBlank(dvalue))
            {
                return Boolean.valueOf(dvalue);
            }
       }
       catch (Exception ex) {}

       return false;
   }

   @AuraEnabled
   public static Boolean update_fields(String Id, String parameters){
    system.debug('@@@@ update_fields');
       try {
           system.debug('@@@@ Id  ->  '+ Id);
           system.debug('@@@@ parameters  ->  '+ parameters);

           List<Node> fields = ( List<Node>) json.deserialize(parameters,  List<Node>.class);
           system.debug('@@@@@ fields '+  fields);

            Lead lead = [SELECT Id, Name, Salutation, FirstName, MiddleName, LastName,  Status, Email, Sub_Estado__c, Title, Renta__c, Phone, PROSP_Carga_Tel_fono_2__c, Telefono_3__c, Telefono_4__c, Telefono_5__c, Telefono_6__c, Telefono_7__c, Telefono_8__c, Direccion__c, Comuna__c, Ciudad__c, Region__c, PROSPE_Carga_Fecha_Nacimiento__c,  Agente_Venta__c, Ejecutivo_PostVenta__c, Perfil_asignacion__c,  Fecha_Entrevista__c, Hora_Entrevista__c, Fecha_Concertacion__c, Reprogramacion__c, Tipo_Link__c, Tipo_Base__c, Nombre_Base__c,   LeadSource, Fecha_Engage__c, Fechas_Engage__c, Acepta_Contacto_Futuro__c, Campana_Engage__c, Observacion__c, Telefono_activo__c, Subject_Link__c, Sucursal__c, Nombre_intermediario_Final__c, Email_intermediario_final__c, Tipo_Intermediario_Final__c, Tipo_Cliente__c FROM Lead WHERE Id =: Id];

            system.debug('@@@@@ f_saludation '+  data_custom_field(fields, 'f_saludation'));
            system.debug('@@@@@ f_firstName '+  data_custom_field(fields, 'f_firstName'));
            system.debug('@@@@@ f_middleName '+  data_custom_field(fields, 'f_middleName'));
            system.debug('@@@@@ f_lastName '+  data_custom_field(fields, 'f_lastName'));
            system.debug('@@@@@ f_status '+  data_custom_field(fields, 'f_status'));
            system.debug('@@@@@ f_email '+ data_custom_field(fields, 'f_email'));
            system.debug('@@@@@ f_subEstado '+ data_custom_field(fields, 'f_subEstado'));
            system.debug('@@@@@ namf_cargoe '+  data_custom_field(fields, 'f_cargo'));
            system.debug('@@@@@ f_renta '+ data_custom_field(fields, 'f_renta'));
            system.debug('@@@@@ f_telefono_1 '+  data_custom_field(fields, 'f_telefono_1'));
            system.debug('@@@@@ f_telefono_2 '+  data_custom_field(fields, 'f_telefono_2'));
            system.debug('@@@@@ f_telefono_3 '+ data_custom_field(fields, 'f_telefono_3'));
            system.debug('@@@@@ f_telefono_4 '+ data_custom_field(fields, 'f_telefono_4'));
            system.debug('@@@@@ f_telefono_5 '+ data_custom_field(fields, 'f_telefono_5'));
            system.debug('@@@@@ f_telefono_6 '+ data_custom_field(fields, 'f_telefono_6'));
            system.debug('@@@@@ f_telefono_7 '+ data_custom_field(fields, 'f_telefono_7'));
            system.debug('@@@@@ f_telefono_8 '+ data_custom_field(fields, 'f_telefono_8'));
            system.debug('@@@@@ f_direccion '+ data_custom_field(fields, 'f_direccion'));
            system.debug('@@@@@ f_comuna '+  data_custom_field(fields, 'f_comuna'));
            system.debug('@@@@@ f_ciudad '+  data_custom_field(fields, 'f_ciudad'));
            system.debug('@@@@@ f_region '+ data_custom_field(fields, 'f_region'));
            system.debug('@@@@@ f_fechaNacimiento '+ getDateValue(data_custom_field(fields, 'f_fechaNacimiento')));
            system.debug('@@@@@ f_agenteVenta '+  data_custom_field(fields, 'f_agenteVenta'));
            system.debug('@@@@@ f_ejecutivoPostVenta '+ data_custom_field(fields, 'f_ejecutivoPostVenta'));
            system.debug('@@@@@ f_perfilAsignacion '+  data_custom_field(fields, 'f_perfilAsignacion'));
            system.debug('@@@@@ f_fechaEntrevista '+ data_custom_field(fields, 'f_fechaEntrevista'));
            system.debug('@@@@@ f_horaEntrevista '+  data_custom_field(fields, 'f_horaEntrevista'));
            system.debug('@@@@@ f_fechaConcertacion '+ data_custom_field(fields, 'f_fechaConcertacion'));
            system.debug('@@@@@ f_reprogramacion '+  data_custom_field(fields, 'f_reprogramacion'));
            system.debug('@@@@@ f_tipoLink '+ data_custom_field(fields, 'f_tipoLink'));
            system.debug('@@@@@ f_tipoBase '+  data_custom_field(fields, 'f_tipoBase'));
            system.debug('@@@@@ f_nombreBase '+  data_custom_field(fields, 'f_nombreBase'));
            system.debug('@@@@@ f_origen '+  data_custom_field(fields, 'f_origen'));
            system.debug('@@@@@ f_fechaEngage '+ data_custom_field(fields, 'f_fechaEngage'));
            system.debug('@@@@@ f_fechasEngage '+ data_custom_field(fields, 'f_fechasEngage'));
            system.debug('@@@@@ f_aceptaContactoFuturo '+  data_custom_field(fields, 'f_aceptaContactoFuturo'));
            system.debug('@@@@@ f_campagnaEngage '+ data_custom_field(fields, 'f_campagnaEngage'));
            system.debug('@@@@@ f_observacion '+  data_custom_field(fields, 'f_observacion'));
            system.debug('@@@@@ f_telefono_activo '+  data_custom_field(fields, 'f_telefono_activo'));
            system.debug('@@@@@ f_subject_link '+  data_custom_field(fields, 'f_subject_link'));
            system.debug('@@@@@ f_tipoCliente '+  data_custom_field(fields, 'f_tipoCliente'));
            system.debug('@@@@@ f_tipoIntermediario '+  data_custom_field(fields, 'f_tipoIntermediario'));
            system.debug('@@@@@ f_sucursal '+  data_custom_field(fields, 'f_sucursal'));
            system.debug('@@@@@ f_nombreIntermediario '+  data_custom_field(fields, 'f_nombreIntermediario'));
            system.debug('@@@@@ f_emailIntermediario '+  data_custom_field(fields, 'f_emailIntermediario'));


            lead.Salutation = data_custom_field(fields, 'f_saludation');
            lead.FirstName = data_custom_field(fields, 'f_firstName');
            lead.MiddleName = data_custom_field(fields, 'f_middleName');
            lead.LastName = data_custom_field(fields, 'f_lastName');
            lead.Status = data_custom_field(fields, 'f_status');
            lead.Email = data_custom_field(fields, 'f_email');
            lead.Sub_Estado__c = data_custom_field(fields, 'f_subEstado');
            lead.Title = data_custom_field(fields, 'f_cargo');
            lead.Renta__c = getDecimalValue(data_custom_field(fields, 'f_renta'));
            lead.Phone = data_custom_field(fields, 'f_telefono_1');
            lead.PROSP_Carga_Tel_fono_2__c = data_custom_field(fields, 'f_telefono_2');
            lead.Telefono_3__c = data_custom_field(fields, 'f_telefono_3');
            lead.Telefono_4__c = data_custom_field(fields, 'f_telefono_4');
            lead.Telefono_5__c = data_custom_field(fields, 'f_telefono_5');
            lead.Telefono_6__c = data_custom_field(fields, 'f_telefono_6');
            lead.Telefono_7__c = data_custom_field(fields, 'f_telefono_7');
            lead.Telefono_8__c = data_custom_field(fields, 'f_telefono_8');
            lead.Direccion__c = data_custom_field(fields, 'f_direccion');
            lead.Comuna__c = data_custom_field(fields, 'f_comuna');
            lead.Ciudad__c = data_custom_field(fields, 'f_ciudad');
            lead.Region__c = data_custom_field(fields, 'f_region');
            lead.PROSPE_Carga_Fecha_Nacimiento__c = getDateValue(data_custom_field(fields, 'f_fechaNacimiento'));
            lead.Agente_Venta__c = data_custom_field(fields, 'f_agenteVenta');
            lead.Ejecutivo_PostVenta__c = data_custom_field(fields, 'f_ejecutivoPostVenta');
            lead.Perfil_asignacion__c = data_custom_field(fields, 'f_perfilAsignacion');
            lead.Fecha_Entrevista__c = getDateValue(data_custom_field(fields, 'f_fechaEntrevista'));
            lead.Hora_Entrevista__c = getTimeValue(data_custom_field(fields, 'f_horaEntrevista'));
            lead.Fecha_Concertacion__c =  getDateValue(data_custom_field(fields, 'f_fechaConcertacion'));
            lead.Reprogramacion__c = getDatetimeValue(data_custom_field(fields, 'f_reprogramacion'));
            lead.Tipo_Link__c = data_custom_field(fields, 'f_tipoLink');
            lead.Tipo_Base__c = data_custom_field(fields, 'f_tipoBase');
            lead.Nombre_Base__c = data_custom_field(fields, 'f_nombreBase');
            lead.LeadSource = data_custom_field(fields, 'f_origen');
            lead.Fecha_Engage__c = getDatetimeValue(data_custom_field(fields, 'f_fechaEngage'));
            lead.Fechas_Engage__c = data_custom_field(fields, 'f_fechasEngage');
            lead.Acepta_Contacto_Futuro__c = data_custom_field(fields, 'f_aceptaContactoFuturo');
            lead.Campana_Engage__c = data_custom_field(fields, 'f_campagnaEngage');
            lead.Observacion__c = data_custom_field(fields, 'f_observacion');
            lead.Telefono_activo__c = data_custom_field(fields, 'f_telefono_activo');
            lead.Subject_Link__c = data_custom_field(fields, 'f_subject_link');
            lead.Tipo_Cliente__c = data_custom_field(fields, 'f_tipoCliente');
            lead.Tipo_Intermediario_Final__c = data_custom_field(fields, 'f_tipoIntermediario');
            lead.Sucursal__c = data_custom_field(fields, 'f_sucursal');
            lead.Nombre_intermediario_Final__c = data_custom_field(fields, 'f_nombreIntermediario');
            lead.Email_intermediario_final__c = data_custom_field(fields, 'f_emailIntermediario');

            update lead;

            return true;
       }
       catch (Exception e) {
            system.debug('@@@@ Exception  ->  '+ e);
            return false;
       }
   }


   @AuraEnabled
   public static Boolean update_owner(String Id, String newOwnerId){
    system.debug('@@@@ update_owner');
       try {
           system.debug('@@@@ Id  ->  '+ Id);
           system.debug('@@@@ ownerId  ->  '+ newOwnerId);

           Lead lead = [SELECT Id, OwnerId FROM Lead WHERE Id =: Id];
           lead.OwnerId = newOwnerId;

           update lead;
           return true;
       }
       catch (Exception e) {
            system.debug('@@@@ Exception  ->  '+ e);
            return false;
       }
   }

   @AuraEnabled
   public static String create_task_call(String Id, String telefono){

        try
        {
            String  CampaignMember_RecordTypeId  = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Prospectos Campañas - Ventas Links').getRecordTypeId();

            Lead lead = [SELECT Id, Name, OwnerId, (SELECT Id, CampaignId FROM CampaignMembers WHERE RecordTypeId =: CampaignMember_RecordTypeId AND Campaign.IsActive = true LIMIT 1) FROM Lead WHERE Id =: Id];

            if (lead != null)
            {
                String Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();

                Task t = new Task();

                t.RecordTypeId = Task_RecordTypeId; // Asigna tipo registro Tarea Televenta Oncológico
                t.WhoId = Id;
                t.ActivityDate = Date.today();
                t.Description = 'Llamada a Candidato campaña LiNk\'s Teléfono: '+telefono;
                t.Subject = 'Realizar Llamada';

                if (lead.CampaignMembers.size() > 0)
                {
                    t.TASK_ID_Miembro_Campana__c = lead.CampaignMembers[0].Id;
                    t.TASK_ID_Campana__c = lead.CampaignMembers[0].CampaignId;
                    t.TASK_Campana__c = lead.CampaignMembers[0].CampaignId;
                }

                t.Status = 'Completada';
                t.Priority = 'Alta';
                t.OwnerId = lead.OwnerId;
                t.Telefono__c = telefono;
                system.debug('@@@@ INSERTA TAREA =>' + t);

                insert t;

                return t.Id;
            }
            else
            {
                return 'NULL';
            }
        }
        catch (Exception ex) {
            return 'ERROR';
        }
    }

    @AuraEnabled
    public static String create_task_Reprogramacion(String Id, Datetime fechaRep){

        try
        {
            String  CampaignMember_RecordTypeId  = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Prospectos Campañas - Ventas Links').getRecordTypeId();

            Lead lead = [SELECT Id, Name, OwnerId, (SELECT Id, CampaignId FROM CampaignMembers WHERE RecordTypeId =: CampaignMember_RecordTypeId AND Campaign.IsActive = true LIMIT 1) FROM Lead WHERE Id =: Id];

            if (lead != null)
            {
                String Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();

                Task t = new Task();

                t.RecordTypeId = Task_RecordTypeId; // Asigna tipo registro Tarea Televenta Oncológico
                t.WhoId = Id;
                t.ActivityDate = Date.newinstance(fechaRep.year(), fechaRep.month(), fechaRep.day());
                t.Fecha_Hora_Actividad__c = fechaRep;
                t.Description = 'Reprogramación Entrevista a Candidato campaña LiNk\'s';
                t.Subject = 'Realizar Llamada';

                t.IsReminderSet = true;
               // t.ReminderDateTime = fechaRep.addMinutes(-15);
               t.ReminderDateTime = fechaRep;


                if (lead.CampaignMembers.size() > 0)
                {
                    t.TASK_ID_Miembro_Campana__c = lead.CampaignMembers[0].Id;
                    t.TASK_ID_Campana__c = lead.CampaignMembers[0].CampaignId;
                    t.TASK_Campana__c = lead.CampaignMembers[0].CampaignId;
                }

                t.Status = 'Abierta';
                t.Priority = 'Alta';
                t.OwnerId = lead.OwnerId;
                system.debug('@@@@ INSERTA TAREA =>' + t);

                insert t;

                return t.Id;
            }
            else
            {
                return 'NULL';
            }
        }
        catch (Exception ex) {
            return 'ERROR';
        }
    }


}