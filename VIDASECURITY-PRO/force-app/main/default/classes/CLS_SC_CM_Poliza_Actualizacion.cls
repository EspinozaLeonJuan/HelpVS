/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 11-18-2021
 * @last modified by  : Juan Espinoza León
**/
global class CLS_SC_CM_Poliza_Actualizacion Implements Schedulable{
    public CLS_SC_CM_Poliza_Actualizacion() {

    }

    /**
    * @description actualiza con información de Poliza registrada(actualizada) a las oportunidades de Salud Protegida, Oncologico y APEG
    * @author Juan Espinoza León | 11-15-2021 
    **/
    private void ActualizaPropuestas()
    {
        String  Poliza_RecordTypeId  = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

        DateTime Past24 = system.now().AddHours(-1).AddDays(-1);//25

        List<String> numPolizas = new List<String>();
        
        for (Poliza__c tmp : [SELECT Name FROM Poliza__c WHERE RecordTypeId =: Poliza_RecordTypeId AND Codigo_de_Producto__c IN ('6907','7300','7400') AND (CreatedDate >=: Past24 OR LastModifiedDate >=: Past24)]){
            numPolizas.add(tmp.Name);
        }

        system.debug('@@@@ numPolizas --> '+ numPolizas.size());

        List<Opportunity> propuestas = [SELECT Id, OPOR_N_Propuesta__c, OPOR_Comentario_Actualizacion_Poliza__c, OPOR_Poliza_Propuesta__c, OPOR_Estado_Poliza__c, OPOR_IdPoliza_Propuesta__c FROM Opportunity WHERE OPOR_N_Propuesta__c IN: numPolizas AND StageName = 'Venta - Aprobada' AND OPOR_WS_Actualiza_Datos_Prospecto__c = true AND (RecordType.Name = 'Oportunidad - Salud Protegida' OR RecordType.Name = 'Venta - Oncológico')];

        system.debug('@@@@ propuestas --> '+ propuestas.size());

        List<String> queryPolizas = new List<String>();
     
        for (Opportunity o : propuestas){
            system.debug('@@@@@ ' +o.OPOR_N_Propuesta__c);
            queryPolizas.add(o.OPOR_N_Propuesta__c);
        }

        system.debug('@@@@ queryPolizas --> '+ queryPolizas.size());

        Map<String, Poliza__c> polizasMap = new Map<String, Poliza__c>();

        List<Poliza__c> polizas = [SELECT Id, Name, Estatus__c FROM Poliza__c WHERE Name IN : queryPolizas];

        for (Poliza__c p : polizas)
        {
            polizasMap.put(p.Name, p);
        }
        
        system.debug('@@@@ polizasMap --> '+ polizasMap.size());

        List<Opportunity> updPropuestas = new List<Opportunity>();

        Integer limite = 0;

        for(Opportunity pro: propuestas)
        {
            Datetime now = Datetime.now();
            Integer offset = UserInfo.getTimezone().getOffset(now);
            Datetime local = now.addSeconds(offset/1000);
            
            Poliza__c p = polizasMap.get(pro.OPOR_N_Propuesta__c);

            if (String.isNotBlank(pro.OPOR_IdPoliza_Propuesta__c))
            {
                if (pro.OPOR_Estado_Poliza__c.Equals(p.Estatus__c) == false)
                {
                    pro.OPOR_Comentario_Actualizacion_Poliza__c = 'LA POLIZA HA SIDO '+ p.Estatus__c+ ' --> '+ local;
                    pro.OPOR_Estado_Poliza__c = p.Estatus__c;
                    updPropuestas.add(pro);
                    limite++;
                }
            }
            else
            {
                pro.OPOR_IdPoliza_Propuesta__c = p.Id;
                pro.OPOR_Poliza_Propuesta__c = p.Name;
                pro.OPOR_Comentario_Actualizacion_Poliza__c = 'LA POLIZA HA SIDO '+ p.Estatus__c+ ' --> '+ local;
                pro.OPOR_Estado_Poliza__c = p.Estatus__c;
                updPropuestas.add(pro);
                limite++;
            }

            if (limite == 100)
                break;
        }

        system.debug('@@@@ updPropuestas  '+ updPropuestas.size());

        update updPropuestas;
    }

    /**
    * @description actualiza con información de Poliza registrada(actualizada) a los prospectos de Salud Protegida
    * @author Juan Espinoza León | 11-15-2021 
    **/
    private void ActualizaProspectos()
    {
        String  Poliza_RecordTypeId  = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

        DateTime Past24 = system.now().AddHours(-1).AddDays(-1);//25

        List<String> rutAsegurados = new List<String>();


        List<Poliza__c> polizas = [SELECT Id, Rut_Asegurado__c, Name, Intermediario__c, Rut_Contratante__c, Cuenta__r.Name, Fecha_Inicio_de_Vigencia__c, Forma_de_Pago__c, Fecha_Inicio_de_Poliza__c 
                                FROM Poliza__c WHERE RecordTypeId =: Poliza_RecordTypeId AND Codigo_de_Producto__c IN ('7400') AND (CreatedDate >=: Past24 OR LastModifiedDate >=: Past24)];

        
        Map<String, Poliza__c> polizasMap = new Map<String, Poliza__c>();

        //salud protegida
        for (Poliza__c p : polizas){
            rutAsegurados.add(p.Rut_Asegurado__c);
            polizasMap.put(p.Rut_Asegurado__c, p);
        }

        system.debug('@@@@ rutAsegurados --> '+ rutAsegurados.size());

        String RecordTypeId_Lead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();
        
        List<Lead> leads = [SELECT Id, PROSP_Carga_RUT__c, NPOL_Numero__c, NPOL_Intermediario__c, NPOL_RUT_Contratante__c, NPOL_Contratante__c, NPOL_Fecha_Inicio_de_Vigencia__c, NPOL_Forma_de_Pago__c, Status, Actualizacion_Datos_Poliza__c 
        FROM Lead WHERE PROSP_Carga_RUT__c IN : rutAsegurados AND RecordTypeId =: RecordTypeId_Lead AND Status = 'Contrata'];

        system.debug('@@@@ leads --> '+ leads.size());

        List<Lead> upleads = new List<Lead>();

        for(Lead lead : leads)
        {
            Poliza__c p = polizasMap.get(lead.PROSP_Carga_RUT__c);

            lead.Actualizacion_Datos_Poliza__c = !lead.Actualizacion_Datos_Poliza__c; // para que no considere reglas de validacion

            if (String.isBlank(lead.NPOL_Numero__c))
            {
                lead.NPOL_Numero__c = p.Name;
                lead.NPOL_Intermediario__c = p.Intermediario__c;
                lead.NPOL_RUT_Contratante__c = p.Rut_Contratante__c;
                lead.NPOL_Contratante__c = p.Cuenta__r.Name;                
                lead.NPOL_Fecha_Inicio_de_Vigencia__c = p.Fecha_Inicio_de_Poliza__c;
                lead.NPOL_Forma_de_Pago__c = p.Forma_de_Pago__c;
                upleads.add(lead);
            }
            else if (lead.NPOL_Forma_de_Pago__c != p.Forma_de_Pago__c)
            {
                lead.NPOL_Forma_de_Pago__c = p.Forma_de_Pago__c;
                upleads.add(lead);
            }
        }

        update upleads;
        system.debug('@@@@ upleads --> '+ upleads.size()); 
    }

    global void execute(SchedulableContext ctx)
    {
        ActualizaPropuestas();
        ActualizaProspectos();
    }
}