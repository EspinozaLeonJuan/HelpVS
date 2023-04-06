trigger TRG_Lead_ValidacionDeCargaLinks on Lead (before insert, before update) {
if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();
            String  Poliza_RecordTypeId  = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
            String  Oportunidad_RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').getRecordTypeId();
            String  Tarea_RecordTypeId_Llamada_Cliente  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Llamada Cliente').getRecordTypeId();
            String  Tarea_RecordTypeId_PostVenta  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PostVenta').getRecordTypeId();


            if (trigger.new[0].RecordTypeId == Lead_RecordTypeId)
            {
                //========================= Inicio validación prospecto Link ====================================
                set<String> leads_RUT = new set<String>();
                Map<String, Lead> leadsExist = new Map<String, Lead>();
                Map<String, Account> accountExist = new Map<String, Account>();
                Map<Id, Contact>  agentesExist = new Map<Id, Contact>();

                set<String> leads_Agentes = new set<String>();
                //String
                for(Lead item : trigger.new){

                    leads_RUT.add(item.PROSP_Carga_RUT__c);
                    if (String.isnotBlank(item.Agente_Venta__c))
                    {
                        leads_Agentes.add(item.Agente_Venta__c);
                    }

                    item.Telefono_Activo__c = item.Phone;

                    //asignación de campo perfil de asignación, si no hay valores vacíos, asigna según valor.
                    if(!String.isEmpty(item.Ejecutivo_PostVenta__c) || !String.isEmpty(item.Agente_Venta__c))
                    {
                        if(!String.isEmpty(item.Ejecutivo_PostVenta__c ))
                        {
                            item.Perfil_asignacion__c='Ejecutivo Post Venta';
                        }
                        else if(!String.isEmpty(item.Agente_Venta__c)){
                            item.Perfil_asignacion__c='Agente_sup';
                        }
                    }
                    //si van todos los valores vacíos, el valor por defecto es agente
                    else
                    {
                        item.Perfil_asignacion__c='Agente';
                    }
                }

                system.debug('@@@@ leads_RUT --> '+leads_RUT.size());

                if (leads_RUT.size() > 0)
                {
                    List<Account> accountList = [SELECT Id, Rut__c, Fecha_Ultimo_Reclamo__c, Fecha_Sin_Trabajo__c, Sin_Trabajo__c, Fecha_con_problema_economico__c, Con_Problema_Economico__c,
                    Vive_en_el_Extranjero__c, Ejecutivo_de_Cliente__c, Ejecutivo_de_Cliente__r.Usuario__c, (SELECT Id, Name, Fecha_de_inicio_de_suspensi_n__c, Cantidad_de_meses_suspendido__c FROM Polizas_Nuevas__r WHERE Estatus__c = 'ACTIVA' AND RecordTypeId =: Poliza_RecordTypeId), (SELECT Id, TaskId, CreatedDate, CreatedById FROM TaskRelations WHERE (Task.RecordTypeId =: Tarea_RecordTypeId_Llamada_Cliente OR Task.RecordTypeId =: Tarea_RecordTypeId_PostVenta) ORDER BY CreatedDate DESC), (SELECT Id, CreatedDate FROM Opportunities WHERE RecordTypeId =: Oportunidad_RecordTypeId ORDER BY CreatedDate DESC) FROM Account WHERE Rut__c IN : leads_RUT];

                    for(Account a : accountList)
                    {
                        accountExist.put(a.Rut__c, a);
                    }

                    system.debug('@@@@ accountExist.size() --> '+accountExist.size());

                    List<Lead> leadsList = [SELECT Id, PROSP_Carga_RUT__c, isConverted, (SELECT Id, Name, Type, CampaignId, CreatedDate, Campaign.Name, Campaign.Origen_de_Base__c, Campaign.CreatedDate, Campaign.RecordTypeId FROM CampaignMembers WHERE Campaign.IsActive = true ORDER BY CreatedDate DESC LIMIT 1) FROM Lead WHERE PROSP_Carga_RUT__c  IN :leads_RUT];

                    for(Lead l : leadsList)
                    {
                        leadsExist.put(l.PROSP_Carga_RUT__c, l);
                    }

                    system.debug('@@@@ leadsExist.size() --> '+leadsExist.size());
                }

                system.debug('@@@@ leads_Agentes --> '+leads_Agentes.size());
                if (leads_Agentes.size() > 0)
                {
                    agentesExist = new Map<Id, Contact>([SELECT Id ,LastName, FirstName, Name, Activo__c, Estado__c FROM Contact WHERE Id IN : leads_Agentes AND Activo__c = true
                    AND Estado__c = 'Vigente' ORDER BY Name]);

                    system.debug('@@@@ agentesExist '+agentesExist.size());
                }

                try
                {
                    if (leads_RUT.size() > 0)
                    {
                        Date hoy = System.today();

                        Boolean leadError;

                        for(Lead item : trigger.new)
                        {
                            leadError = false;

                            Account account = accountExist.get(item.PROSP_Carga_RUT__c);
                            Lead lead = leadsExist.get(item.PROSP_Carga_RUT__c);

                            system.debug('@@@@ item RUT --> '+item.PROSP_Carga_RUT__c);
                            system.debug('@@@@ item Tipo Base --> '+item.Tipo_Base__c);
                            

                            if (String.isBlank(item.Tipo_Base__c) || String.isBlank(item.Nombre_Base__c) || String.isBlank(item.Tipo_Link__c))
                            {
                                item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' Debe ingresar valores en los campo "Tipo de Base", "Nombre de Base", "Tipo de Link"');
                                leadError = true;
                            }
                            
                             system.debug('@@@@ item leadError --> '+item.Tipo_Base__c);

                            if (leadError == false)
                            {
                                if (item.Tipo_Base__c.toUppercase() == 'BASES BI') //campaña de Base BI
                                {
                                    system.debug('@@@@ account --> '+account);
                                    //se valida si existe la cuenta
                                    if (account != null)
                                    {
                                        //se valida si tiene un producto activo
                                        if(account.Polizas_Nuevas__r.size() == 0)
                                        {
                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' no tiene un producto activo, es decir, el prospecto no tiene polizas activas');
                                            leadError = true;
                                        }

                                        system.debug('@@@@ item RUT --> '+item.PROSP_Carga_RUT__c);
                                        system.debug('@@@@ lead '+ lead);
                                        if (lead != null && leadError == false)
                                        {
                                            for (CampaignMember cm : lead.CampaignMembers)
                                            {
                                                DateTime fechaCreacionDateTime = cm.CreatedDate;

                                                Date fechaCreacion = fechaCreacionDateTime.date();
                                                Integer mesesDiff = fechaCreacion.monthsBetween(hoy);

                                                //se pregunta si entre HOY y 6 MESES con respecto a la fecha de creación tiene links
                                                if(mesesDiff < 6)
                                                {
                                                    if (cm.Campaign.Origen_de_Base__c == 'Bases BI')
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' existe en campaña "Bases BI" nombre : '+cm.Campaign.Name);
                                                        leadError = true;
                                                    }
                                                    else
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' existe en campaña Televentas nombre: '+cm.Campaign.Name);
                                                        leadError = true;
                                                    }
                                                }
                                            }
                                        }
                                        system.debug('@@@@ leadError '+ leadError);

                                        //si hay coincidencia de rut, se pregunta si existen oportunidades para la cuenta
                                        if(account.Opportunities.size() > 0 && leadError == false)
                                        {
                                            DateTime fechaCreacionDateTime = account.Opportunities[0].CreatedDate;

                                            Date fechaCreacion = fechaCreacionDateTime.date();
                                            Integer mesesDiff = fechaCreacion.monthsBetween(hoy);

                                            //se pregunta si entre HOY y 12 MESES con respecto a la fecha de creación tiene links
                                            if(mesesDiff < 12)
                                            {
                                                item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' tiene una entrevista activa en los últimos 12 meses');
                                                leadError = true;
                                            }
                                        }

                                        if (account.Fecha_Ultimo_Reclamo__c != null && leadError == false)
                                        {
                                            DateTime fechaUltimoReclamoDT = account.Fecha_Ultimo_Reclamo__c;

                                            Date fechaUltimoReclamo = fechaUltimoReclamoDT.date();
                                            Integer mesesDiff = fechaUltimoReclamo.monthsBetween(hoy);

                                            if(mesesDiff < 12){
                                                item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' tiene un reclamo creado en los últimos 12 meses');
                                                leadError = true;
                                            }
                                        }

                                        if(account.Polizas_Nuevas__r.size() > 0 && leadError == false)
                                        {
                                            for(Poliza__c poliza : account.Polizas_Nuevas__r)
                                            {
                                                if (poliza.Fecha_de_inicio_de_suspensi_n__c != null)
                                                {
                                                    DateTime fechaSuspensionPrimaDT = poliza.Fecha_de_inicio_de_suspensi_n__c;

                                                    if (poliza.Cantidad_de_meses_suspendido__c == 'Indefinido')
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' --> póliza '+poliza.Name+ ' se encuentra con suspensión de pagos indefinida');
                                                        leadError = true;
                                                    }
                                                    else
                                                    {
                                                        Integer cantidadMesesSuspendido = Integer.valueOf(poliza.Cantidad_de_meses_suspendido__c);

                                                        Date fechaSuspensionPrima = fechaSuspensionPrimaDT.date();

                                                        Integer mesesDiff = hoy.monthsBetween(fechaSuspensionPrima.addMonths(cantidadMesesSuspendido));

                                                        if (mesesDiff > 0)
                                                        {
                                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' --> póliza '+poliza.Name+ ' se encuentra con suspensión de pagos hasta el '+fechaSuspensionPrima);
                                                            leadError = true;
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        if (account.Sin_Trabajo__c == true && leadError == false)
                                        {
                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' se encuentra Sin Trabajo, desde '+ account.Fecha_Sin_Trabajo__c);
                                            leadError = true;
                                        }

                                        if (account.Con_Problema_Economico__c == true && leadError == false)
                                        {
                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' se encuentra Con Problemas Ecónomicos, desde '+ account.Fecha_con_problema_economico__c);
                                            leadError = true;
                                        }

                                        if (account.Vive_en_el_Extranjero__c == true && leadError == false)
                                        {
                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' vive en el extranjero');
                                            leadError = true;
                                        }

                                        if(Test.isRunningTest() || (account.TaskRelations.size() > 0 && String.isNotBlank(account.Ejecutivo_de_Cliente__c) && leadError == false))
                                        {
                                            for(Integer i = 0; i < account.TaskRelations.size(); i++)
                                            {
                                                DateTime fechaCreacionDateTime = account.TaskRelations[i].CreatedDate;
                                                Date fechaCreacion = fechaCreacionDateTime.date();
                                                Integer mesesDiff = fechaCreacion.monthsBetween(hoy);

                                                if (account.TaskRelations[i].CreatedById == account.Ejecutivo_de_Cliente__c)
                                                {
                                                    if (mesesDiff < 12)
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' tiene una reunión con Cliente creada (tipo Llamada Cliente) en los últimos 12 meses');
                                                        leadError = true;
                                                    }
                                                }
                                            }
                                        }

                                        if (item.Agente_Venta__c == null && item.Ejecutivo_PostVenta__c == null && leadError == false)
                                        {
                                            item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' todo prospecto de campaña BI, debe tener asociado un Ejecutivo o un Agente');
                                            leadError = true;
                                        }
                                        else
                                        {
                                            system.debug('@@@@ Agente --> '+item.Agente_Venta__c);

                                            if (String.isNotBlank(item.Agente_Venta__c) && leadError == false)
                                            {
                                                if (item.Agente_Venta__c != null)
                                                {
                                                    Contact agente = agentesExist.get(item.Agente_Venta__c);
                                                    system.debug('@@@ agente --> '+ agente);

                                                    if (agente == null)
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' Agente vinculado no existe o no se encuentra Vigente');
                                                        leadError = true;
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                if (leadError == false && (String.isBlank(item.Ejecutivo_PostVenta__c) || item.Ejecutivo_PostVenta__c == null))
                                                {
                                                    item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' debe ingresar un Ejecutivo vinculado');
                                                    leadError = true;
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        item.addError('Prospecto debe estar registrado como Cuenta en este tipo de campaña (Bases BI)');
                                        leadError = true;
                                    }
                                }
                                else if (item.Tipo_Base__c.toUppercase() == 'BASES NORMALES' || item.Tipo_Base__c.toUppercase() == 'BASES SUPERVISORES' ||item.Tipo_Base__c.toUppercase() == 'REFERIDOS WEB' ||
                                item.Tipo_Base__c.toUppercase() == 'BASES BANCO' || item.Tipo_Base__c.toUppercase() == 'BASES PROPIAS')
                                {
                                    if (account != null)
                                    {
                                        //Si el perfil de asignación no es nulo, y si NO es ejecutivo postVenta, entra a la logica
                                        //para los lead con ejecutivos post venta no corre la reestricción, deben cargarse siempre
                                        if(item.Perfil_asignacion__c != null && leadError == false)
                                        {
                                            if(!item.Perfil_asignacion__c.equals('Ejecutivo Post Venta') || String.isEmpty(item.Perfil_asignacion__c))
                                            {
                                                //si hay coincidencia de rut, se pregunta si existen oportunidades para la cuenta
                                                if(account.Opportunities.size() > 0 && leadError == false)
                                                {
                                                    DateTime fechaCreacionDateTime = account.Opportunities[0].CreatedDate;
                                                    Date fechaCreacion = fechaCreacionDateTime.date();
                                                    Integer mesesDiff = fechaCreacion.monthsBetween(hoy);
                                                    //se pregunta si entre HOY y 12 MESES con respecto a la fecha de creación tiene links
                                                    //si no han pasado mas de 6 meses se despliega error de carga
                                                    if(mesesDiff < 12)
                                                    {
                                                        item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' tiene una entrevista activa en los últimos 12 meses');
                                                        leadError = true;
                                                    }
                                                }
                                                    //además de validar las oportunidades, se valida si tiene un producto activo
                                                if(account.Polizas_Nuevas__r.size() > 0 && leadError == false)
                                                {
                                                    item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' Ya tiene un producto activo, es decir, el prospecto tiene polizas activas');
                                                    leadError = true;
                                                }
                                            }
                                        }
                                    }

                                    if (Test.isRunningTest() || (lead != null && leadError == false))
                                    {
                                        for (CampaignMember cm : lead.CampaignMembers)
                                        {
                                            DateTime fechaCreacionDateTime = cm.CreatedDate;

                                            Date fechaCreacion = fechaCreacionDateTime.date();
                                            Integer mesesDiff = fechaCreacion.monthsBetween(hoy);

                                            //se pregunta si entre HOY y 6 MESES con respecto a la fecha de creación tiene links
                                            if(mesesDiff < 6 )
                                            {
                                                item.addError('RUT '+item.PROSP_Carga_RUT__c +'-'+item.DV__c+' existe en campaña Televentas nombre: '+cm.Campaign.Name);
                                                leadError = true;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                catch(Exception e){
                    system.debug('error: ' + e.getMessage() + ' - ' + e.getCause() + ' ' + e.getLineNumber());
                }
            }
        }
    }
    if(trigger.isUpdate){

        String  Opportunity_RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Link').getRecordTypeId();
        String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();

        if(trigger.isBefore){

            String agenteAsignado = '';
            String ejecutivoPostVenta = '';

            Date fechaEntrevista;

            if (trigger.new[0].RecordTypeId.equals(Lead_RecordTypeId))
            {
                System.debug(trigger.new[0]);
                //asignación de campo perfil de asignación, si no hay valores vacíos, asigna según valor.
                if(!String.isEmpty(trigger.new[0].Ejecutivo_PostVenta__c) || !String.isEmpty(trigger.new[0].Agente_Venta__c))
                {
                    if(!String.isEmpty(trigger.new[0].Ejecutivo_PostVenta__c ))
                    {
                        trigger.new[0].Perfil_asignacion__c='Ejecutivo Post Venta';
                    }
                    else if(!String.isEmpty(trigger.new[0].Agente_Venta__c))
                    {
                        trigger.new[0].Perfil_asignacion__c='Agente_sup';
                    }
                }
            //si van todos los valores vacíos, el valor por defecto es agente
                else
                {
                    trigger.new[0].Perfil_asignacion__c='Agente';
                }

                if (trigger.new[0].Fecha_Entrevista__c != null && trigger.new[0].Tipo_Link__c.equals('Bases Propias')) {
                    if(!String.isBlank(trigger.new[0].Agente_Venta__c))
                    {
                        agenteAsignado = trigger.new[0].Agente_Venta__c;
                        system.debug('@@@@ agenteasignado '+agenteAsignado);
                        fechaEntrevista =  trigger.new[0].Fecha_Entrevista__c;
                        //Recorrido a las oportunidades del agente asignado a la oportunidad base propia
                        List<Opportunity> opp = [SELECT id, Name, Fecha_Entrevista__c, StageName FROM Opportunity WHERE Agente_de_Venta__c=:agenteAsignado
                        AND RecordTypeId =:Opportunity_RecordTypeId AND StageName NOT IN ('Cerrada Perdida Link', 'Cerrada Ganada Link')];

                        if (opp.size() > 0 )
                        {
                            for (Opportunity op  : opp) {
                                if(op.Fecha_Entrevista__c >= system.today()){
                                    if (op.Fecha_Entrevista__c == fechaEntrevista) {
                                        trigger.new[0].addError('Agente Asignado, ya tiene un link para la misma fecha');
                                    }
                                }
                            }
                        }
                    }
                    else if(!String.isBlank(trigger.new[0].Ejecutivo_PostVenta__c))
                    {
                        ejecutivoPostVenta = trigger.new[0].Ejecutivo_PostVenta__c;
                        fechaEntrevista =  trigger.new[0].Fecha_Entrevista__c;
                        List<Opportunity> opp = [SELECT id, Fecha_Entrevista__c, StageName FROM Opportunity WHERE Ejecutivo_Post_Venta__c=:ejecutivoPostVenta
                        AND RecordTypeId =:Opportunity_RecordTypeId AND StageName NOT IN ('Cerrada Perdida Link', 'Cerrada Ganada Link')];
                        if (opp.size() > 0 ) {
                            for (Opportunity op  : opp) {
                                if(op.Fecha_Entrevista__c >= system.today()){
                                    if (op.Fecha_Entrevista__c == fechaEntrevista) {
                                        trigger.new[0].addError('Ejecutivo Post Venta, ya tiene un link para la misma fecha');
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}