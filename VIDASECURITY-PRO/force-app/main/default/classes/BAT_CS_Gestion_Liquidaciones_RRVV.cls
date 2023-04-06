/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-18-2022
 * @last modified by  : Juan Espinoza León
**/
global class BAT_CS_Gestion_Liquidaciones_RRVV implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    public String caseId {get; set;}

    public BAT_CS_Gestion_Liquidaciones_RRVV(String id) {
        this.caseId = id;
        system.debug('@@@@ this.caseId: ' + this.caseId);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query =  'SELECT Id, Periodo__c, RUT__c,  Base64_1__c, Base64_2__c, Base64_3__c FROM Liquidacion_RRVV__c WHERE CaseId__c = \'' + String.escapeSingleQuotes(this.caseId) + '\'';

        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Liquidacion_RRVV__c> liquidaciones) {

        system.debug('@@@@ liquidaciones.size(): ' + liquidaciones.size());

        DateTime start = null;

        String token = CLS_CS_Servicio_Liquidaciones_RRVV.getToken();
        
        for (Liquidacion_RRVV__c liq : liquidaciones) {

            String b64 = CLS_CS_Servicio_Liquidaciones_RRVV.getLiquidacionPeriodo(token, liq.RUT__c, liq.Periodo__c);
            
            if (Test.isRunningTest())
            {
                b64 = '';
            }

            if (String.isBlank(b64))
            {
                start = System.Now();
                while(System.Now().getTime()< start.getTime()+2000){}
				token = CLS_CS_Servicio_Liquidaciones_RRVV.getToken();
                b64 = CLS_CS_Servicio_Liquidaciones_RRVV.getLiquidacionPeriodo(token, liq.RUT__c, liq.Periodo__c);
            }

            if (Test.isRunningTest())
            {
                b64 = '';
            }
            
            if (String.isBlank(b64))
            {
                start = System.Now();
                while(System.Now().getTime()< start.getTime()+2000){}
				token = CLS_CS_Servicio_Liquidaciones_RRVV.getToken();
                b64 = CLS_CS_Servicio_Liquidaciones_RRVV.getLiquidacionPeriodo(token, liq.RUT__c, liq.Periodo__c);
            }
			system.debug('@@@@ b64 --> '+b64);
            if (String.isNotBlank(b64))
            {
                String[] vB64 = getBase64(b64);
                if (vB64.size() == 3)
                {
                    liq.Base64_1__c = vB64[0];
                    liq.Base64_2__c = vB64[1];
                    liq.Base64_3__c = vB64[2];
                }
                else if (vB64.size() == 2)
                {
                    liq.Base64_1__c = vB64[0];
                    liq.Base64_2__c = vB64[1];
                }
                else if (vB64.size() == 1)
                {
                    liq.Base64_1__c = vB64[0];
                }

                liq.Estado__c = 'Liquidación encontrada';
            }
            else
            {
                liq.Estado__c = 'Liquidación no encontrada';
            }

            start = System.Now();
            while(System.Now().getTime()< start.getTime()+2000){}
        }

        update liquidaciones;

    }

    global void finish(Database.BatchableContext bc) {

        try {
            TriggerHandler.disable();
            CLS_CS_Correo_Liquidaciones_RRVV.SendEmail(this.caseId);
            TriggerHandler.enable();

        } catch (Exception e) {
            system.debug('@@@@ finish Exception: ' + e.getMessage());
        }
    }

    public static String[] getBase64(String b64)
    {
        String[] outB64;// = new String[1];

        if (b64.length() > 260000)
        {
            outB64 = new String[3];
            outB64[0] = b64.subString(0, 130000);
            outB64[1] = b64.subString(130000, 260000);
            outB64[2] = b64.subString(260000, b64.length());
        }
        else if (b64.length() > 130000 && b64.length() <= 260000)
        {
            outB64 = new String[2];
            outB64[0] = b64.subString(0, 130000);
            outB64[1] = b64.subString(130000, b64.length());
        }
        else
        {
            outB64 = new String[1];
            outB64[0] = b64;
        }

        return outB64;
    }
}