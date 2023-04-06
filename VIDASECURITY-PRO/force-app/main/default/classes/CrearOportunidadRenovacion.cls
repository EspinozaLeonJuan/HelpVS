/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-01-2022
 * @last modified by  : felipe.pena@vasslatam.com
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-09-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public  without sharing class CrearOportunidadRenovacion {

    public static void creaOppRenovacion(){
    
        Map<ID, Account> cuentas = new Map<ID, Account>([SELECT id, name, Suscriptor_de_renovacion__c, Holding__c, ownerId, ParentId FROM Account WHERE Holding__c = true AND ParentId = Null]);        
        if(cuentas.size() < 1)
        {
            return;
        }
    
        Set<Id> ids             = new Set<Id>();
        
        for(Id id : cuentas.keyset())
        {
            Account cuenta = cuentas.get(id);
            ids.add(cuenta.id);
        }
            
        Datetime fecha_time = (Datetime.now()).AddDays(60);
        Date fecha          =  Date.newInstance(fecha_time.year(),fecha_time.month(),fecha_time.day());
        System.debug(fecha);
        ID IdrecordTypeRenovacion = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Comercial_Renovacion').getRecordTypeId();
    
        List<Opportunity> oportunities      = [SELECT id, Name, AccountId FROM Opportunity WHERE RecordTypeId = :IdrecordTypeRenovacion AND StageName != 'Cerrada' AND AccountId IN :ids];
        List<Poliza__c>  polizas            = [SELECT id, Name, Corredor__c,Corredor__r.Codigo__c,Ejecutivo_Comercial__c,Equipo_Suscriptor__c,Suscriptor__c, Tipo_Intermediacion__c,Tipo_Reaseguro__c,Tipo_de_Riesgo__c, Cuenta__c, Fecha_Termino_de_Poliza__c, Tiene_DEF__c FROM Poliza__c WHERE Fecha_Termino_de_Poliza__c = :fecha AND Estatus__c = 'ACTIVA' AND Holding_Comercial_Colectivo__c = true AND Cuenta__c IN :ids];
        List<Poliza__c>  polizas_new        = new List<Poliza__c>();
        Opportunity op1                     = new Opportunity();
        List<Opportunity> opList            = new List<Opportunity>();
        Boolean flag;
    
        if(polizas.size() < 1)
        {
            return;
        }
        
        for(Poliza__c poliza : polizas)
        {
            flag = true;
            for(Opportunity op : oportunities)
            {
                if(op.AccountId == poliza.Cuenta__c)
                {
                    string nombre = op.name.split(' ')[0];
                
                    if(nombre == poliza.name)
                    {
                        flag = false;
                    }       
                }
            }
            if(flag)
            {
                Account cuenta           = cuentas.get(poliza.Cuenta__c);
            
                Date fecha_termino       = poliza.Fecha_Termino_de_Poliza__c;    
                op1                      = new Opportunity();
                op1.AccountId            = cuenta.id;  
                op1.Name                 = poliza.name + ' ' + cuenta.name +' '+ fecha_termino.year();
                op1.OwnerId              = cuenta.ownerId;
                op1.Corredor_actual__c   = poliza.Corredor__c;
                op1.Corredor__c          = poliza.Corredor__c;
                op1.CloseDate            = poliza.Fecha_Termino_de_Poliza__c;
                op1.recordTypeId         = IdrecordTypeRenovacion;  
                op1.Codigo_Historico__c  			 = poliza.Corredor__r.Codigo__c;  
                op1.Ejecutivo_Comercial_Historico__c = poliza.Ejecutivo_Comercial__c; 
                op1.Equipo_Suscriptor_Historico__c   = poliza.Equipo_Suscriptor__c;
                op1.Suscriptor_Historico__c 		 = poliza.Suscriptor__c;
                op1.Tipo_Intermediacion_Historico__c = poliza.Tipo_Intermediacion__c;
                op1.Tipo_Reaseguro_Historico__c 	 = poliza.Tipo_Reaseguro__c;
                op1.Tipo_de_Riesgo_Historico__c 	 = poliza.Tipo_de_Riesgo__c;
                op1.Tiene_DEF_Historico__c           = poliza.Tiene_DEF__c;
                op1.Poliza__c           = poliza.Id;
                op1.Opp_Automatica__c                = true;
                opList.add(op1);
            }
        }
    
        if(opList.size() < 1)
        {
            return;
        }
    
        List<Database.Saveresult> insertResults = Database.insert(opList, false);
        Set<Id> idOppToUpdate = new Set<Id>();
    
        for (Database.SaveResult sr : insertResults) {
            if (sr.isSuccess()) {
                idOppToUpdate.add(sr.getId());
            }
        }
    
        List<Opportunity> newOpList             = [SELECT Id, Name, OwnerId, AccountId, Corredor_actual__c, stageName, Codigo_Comercial__c FROM Opportunity WHERE Id IN:idOppToUpdate FOR UPDATE];
        List<Opportunity> newOpListToUpdate     = new List<Opportunity>();
        Opportunity op                          = new Opportunity();
        for(Opportunity opp : newOpList)
        {
            opp.stageName            = 'Renovación';
            newOpListToUpdate.add(opp);
        }
    
        update newOpListToUpdate;        
    
        List<Quote> presupestoList  = new List<Quote>();
        Quote presupuesto           = new Quote();
        Id IdrecordTypePresupuesto  = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('Cotizacion_Comercial_Renovacion').getRecordTypeId();
        for(Opportunity opp : newOpListToUpdate)
        {   
            List<string> nombre =    opp.name.split(' ');
            presupuesto                     =  new Quote();
            presupuesto.OpportunityId       =  opp.id;
            presupuesto.OwnerId             =  opp.ownerId;
            presupuesto.name                =  nombre[nombre.size() - 1];
            presupuesto.status              = 'Tarificacion';
            presupuesto.Tipo_Cotizacion__c  = 'Plan Vigente';
            presupuesto.RecordTypeId        = IdrecordTypePresupuesto;
            //presupuesto.FechaTarificacion__c = (Datetime.now()).addDays(30);
            presupestoList.add(presupuesto);   
        }
    
        Database.insert(presupestoList, true);
    
    }
    
}