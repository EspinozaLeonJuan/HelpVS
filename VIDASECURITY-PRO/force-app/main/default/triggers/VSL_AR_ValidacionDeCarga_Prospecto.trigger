/*******************************************************************************************
 *  NOMBRE                 : VSL_AR_ValidacionDeCargA_Prospecto
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO LINKS - TELEVENTA LINKS
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE    - OBSERVACIONES
 *  1.0     - 01/06/2020 - ALVARO ROJAS  - INICIO DE VALIDACION CARGA DE PROSPECTOS LINKS
 *  1.1     - 15/06/2020 - JP. HERNANDEZ - AJUSTES DE VALIDACION CARGA DE PROSPECTOS LINKS
 * *****************************************************************************************/
trigger VSL_AR_ValidacionDeCarga_Prospecto on Lead (before insert, before update) {

    if(trigger.isInsert){
        if(trigger.isBefore){
            //========================= Inicio validación prospecto Link ====================================         
            set<String> leadRut = new set<String>();
            String recordTypeLinkLead = [SELECT Id FROM RecordType WHERE Name ='Prospecto Links' Limit 1].Id;
            //Reccorido por los registros entrantes, se realiza asignación de campo Perfil de Asignación
            for(Lead item : trigger.new){
                if(item.RecordTypeId != null){
                    if (item.RecordTypeId.equals(recordTypeLinkLead)) {
                        leadRut.add(item.PROSP_Carga_RUT__c);
                        //asignación de campo perfil de asignación, si no hay valores vacíos, asigna según valor.
                        if(!String.isEmpty(item.Ejecutivo_PostVenta__c) || !String.isEmpty(item.Agente_Venta__c))
                            {
                                if(!String.isEmpty(item.Ejecutivo_PostVenta__c )){
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
                }                   
            }
                                   
            try{
                //query obtiene recordType de Polizas Individuales
                String recordTypeInd = [Select id from RecordType where Name = 'Individuales' limit 1].Id;

                // query obtiene las cuentas asociadas a los rut entrantes
                if (leadRut.size() > 0) {
                    List<Account> accountExist = [select Id, Rut__c, (select Id From Polizas_Nuevas__r where Estatus__c = 'ACTIVA' AND RecordTypeId =:recordTypeInd limit 1), 
                    (select Id, CreatedDate from Opportunities order by CloseDate desc limit 1) 
                    from Account Where Rut__c IN :leadRut];

                    //query obtiene los lead que existen en base a los rut entrantes
                    List<Lead> leadExist = [select Id, PROSP_Carga_RUT__c, isConverted, (select Id, CampaignId from CampaignMembers where Campaign.IsActive = true limit 1) from Lead 
                                    where PROSP_Carga_RUT__c  IN :leadRut];

                 //existe en cuenta persona? si existen valores, recorre los registros entrantes
                 if(accountExist.size() > 0){ 
                  for(Lead item : trigger.new){ 
                      //en base al registro entrante, se recorren las cuentas existentes
                    for(Account currentRecord: accountExist){
                            //si hay coincidencia de RUTS
                            if(item.PROSP_Carga_RUT__c.equals(currentRecord.Rut__c)){

                                //Si el perfil de asignación no es nulo, y si NO es ejecutivo postVenta, entra a la logica
                                //para los lead con ejecutivos post venta no corre la reestricción, deben cargarse siempre
                                if(item.Perfil_asignacion__c != null){
                                       if(!item.Perfil_asignacion__c.equals('Ejecutivo Post Venta') || String.isEmpty(item.Perfil_asignacion__c)){
                                           //si hay coincidencia de rut, se pregunta si existen oportunidades para la cuenta
                                        if(currentRecord.Opportunities.size() > 0){
                                                Date hoy = System.today();

                                                DateTime fechaCreacionDateTime = currentRecord.Opportunities[0].CreatedDate;

                                                Date fechaCreacion = fechaCreacionDateTime.date();
                                                Integer mesesDiff = fechaCreacion.monthsBetween(hoy);

                                                //se pregunta si entre HOY y 6 MESES con respecto a la fecha de creación tiene links
                                                //si no han pasado mas de 6 meses se despliega error de carga
                                                   if(mesesDiff < 12){
                                                        item.addError('RUT '+currentRecord.Rut__c +' tiene una entrevista activa en los últimos 12 meses');
                                                       
                                                   }         
                                                 }
                                                 //además de validar las oportunidades, se valida si tiene un producto activo
                                            if(currentRecord.Polizas_Nuevas__r.size() > 0)
                                            {
                                                   item.addError('RUT '+currentRecord.Rut__c +' Ya tiene un producto activo, es decir, el prospecto tiene polizas activas');
                                            }
                                        }
                                        
                                     break;
                                    }
                                    //si no existe perfil de asignación, se despliega error
                                       else{
                                        item.addError('Cliente debe tener un perfil de asignación para realizar la validación');
                                    } 
                                                          
                            }               
                        }
                      } 
                    }
                       //existe en alguna campaña activa?
                       if(leadExist.size() > 0)
                       { 

                        String campaignIdUnico = leadExist[0].CampaignMembers[0].CampaignId;
                        String campaignName = [Select Id, Name from Campaign Where Id =: campaignIdUnico].Name;
                           //Se recorren los registros entrantes
                          for(Lead item : trigger.new){ 
                                //se recorren los rut existentes
                                  for(Lead currentRecord : leadExist){
                                            //Se realiza match entre rut, si el rut existe en los leads realiza la validacion
                                            if(item.PROSP_Carga_RUT__c.equals(currentRecord.PROSP_Carga_RUT__c) && !currentRecord.isConverted){
                                                //si el lead existente tiene campañas activas despliega el error
                                                if(currentRecord.CampaignMembers.size() > 0){
                                                    item.addError('RUT '+currentRecord.PROSP_Carga_RUT__c +' Ya existe en campaña nombre : '
                                                                 + campaignName);
                                                }
                                                 break;                        
                                            }
                                } 
                          }
                 }    
            }   
            }catch(Exception e){
                system.debug('error: ' + e.getMessage() + ' - ' + e.getCause() + ' ' + e.getLineNumber());
            }
            
            //========================= Fin validación prospecto Link =======================================}
        }    
    }
    if(trigger.isUpdate){
        
        String recordTypeLinkOpp = [SELECT Id FROM RecordType WHERE Name ='Venta - Link' Limit 1].Id;
        String recordTypeLinkLead = [SELECT Id FROM RecordType WHERE Name ='Prospecto Links' Limit 1].Id;

        if(trigger.isBefore){

            String agenteAsignado = '';
            String ejecutivoPostVenta = '';
            Date fechaEntrevista;
            if(trigger.new[0].RecordTypeId != null ){
                    if (trigger.new[0].RecordTypeId.equals(recordTypeLinkLead)) {
                        System.debug(trigger.new[0]);
                        //asignación de campo perfil de asignación, si no hay valores vacíos, asigna según valor.
                        if(!String.isEmpty(trigger.new[0].Ejecutivo_PostVenta__c) || !String.isEmpty(trigger.new[0].Agente_Venta__c))
                        {
                            if(!String.isEmpty(trigger.new[0].Ejecutivo_PostVenta__c )){
                                trigger.new[0].Perfil_asignacion__c='Ejecutivo Post Venta';
                            }
                            else if(!String.isEmpty(trigger.new[0].Agente_Venta__c)){
                                trigger.new[0].Perfil_asignacion__c='Agente_sup';
                            }
                        } 
                    //si van todos los valores vacíos, el valor por defecto es agente
                        else
                        {   
                            trigger.new[0].Perfil_asignacion__c='Agente';
                        }   
                    if (trigger.new[0].Fecha_Entrevista__c != null && trigger.new[0].Tipo_Link__c.equals('Bases Propias')) {
                        if(!String.isBlank(trigger.new[0].Agente_Venta__c)){
                            agenteAsignado = trigger.new[0].Agente_Venta__c;
                            fechaEntrevista =  trigger.new[0].Fecha_Entrevista__c;
                            //Recorrido a las oportunidades del agente asignado a la oportunidad base propia
                            List<Opportunity> opp = [SELECT id, Fecha_Entrevista__c, StageName FROM Opportunity WHERE Agente_de_Venta__c=:agenteAsignado
                            AND RecordTypeId =:recordTypeLinkOpp AND StageName NOT IN ('Cerrada Perdida Link', 'Cerrada Ganada Link')];
                            if (opp.size() > 0 ) {
                                for (Opportunity op  : opp) {
                                    if(op.Fecha_Entrevista__c >= system.today()){
                                        if (op.Fecha_Entrevista__c == fechaEntrevista) {
                                            trigger.new[0].addError('Agente Asignado, ya tiene un link para la misma fecha');
                                        }
                                    }
                                } 
                            }  
                        }  
                        else if(!String.isBlank(trigger.new[0].Ejecutivo_PostVenta__c)){
                            ejecutivoPostVenta = trigger.new[0].Ejecutivo_PostVenta__c;
                            fechaEntrevista =  trigger.new[0].Fecha_Entrevista__c;
                            List<Opportunity> opp = [SELECT id, Fecha_Entrevista__c, StageName FROM Opportunity WHERE Ejecutivo_Post_Venta__c=:ejecutivoPostVenta
                            AND RecordTypeId =:recordTypeLinkOpp AND StageName NOT IN ('Cerrada Perdida Link', 'Cerrada Ganada Link')];
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
}