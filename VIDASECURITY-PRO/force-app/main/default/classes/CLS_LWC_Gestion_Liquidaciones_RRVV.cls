/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-14-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_LWC_Gestion_Liquidaciones_RRVV {
    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Months() {

        List <CLS_UTL_Lightning.customValueWrapper> months = new List <CLS_UTL_Lightning.customValueWrapper>();

        CLS_UTL_Lightning.customValueWrapper month = new  CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '01';
        month.custFldlabel = 'Enero';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '02';
        month.custFldlabel = 'Febrero';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '03';
        month.custFldlabel = 'Marzo';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '04';
        month.custFldlabel = 'Abril';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '05';
        month.custFldlabel = 'Mayo';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '06';
        month.custFldlabel = 'Junio';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '07';
        month.custFldlabel = 'Julio';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '08';
        month.custFldlabel = 'Agosto';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '09';
        month.custFldlabel = 'Septiembre';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '10';
        month.custFldlabel = 'Octubre';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '11';
        month.custFldlabel = 'Noviembre';
        months.add(month);

        month = new CLS_UTL_Lightning.customValueWrapper();
        month.custFldValue = '12';
        month.custFldlabel = 'Diciembre';
        months.add(month);

        return months;
    }

    public static String getMonth(String monthVal)
    {
        if (monthVal == '01')
        {
            return 'Enero';
        }
        else if (monthVal == '02')
        {
            return 'Febrero';
        }
        else if (monthVal == '03')
        {
            return 'Marzo';
        }
        else if (monthVal == '04')
        {
            return 'Abril';
        }
        else if (monthVal == '05')
        {
            return 'Mayo';
        }
        else if (monthVal == '06')
        {
            return 'Junio';
        }
        else if (monthVal == '07')
        {
            return 'Julio';
        }
        else if (monthVal == '08')
        {
            return 'Agosto';
        }
        else if (monthVal == '09')
        {
            return 'Septiembre';
        }
        else if (monthVal == '10')
        {
            return 'Octubre';
        }
        else if (monthVal == '11')
        {
            return 'Noviembre';
        }
        else if (monthVal == '12')
        {
            return 'Diciembre';
        }
        else
        {
            return '';
        }
    }

    @AuraEnabled(cacheable=true)
    public static List <CLS_UTL_Lightning.customValueWrapper>  get_pickList_Years() {
        List <CLS_UTL_Lightning.customValueWrapper> years = new List <CLS_UTL_Lightning.customValueWrapper>();

        Integer currentYear = System.Today().year();

        CLS_UTL_Lightning.customValueWrapper year;
        for(Integer i = currentYear; i > (currentYear - 20); --i){
            year = new  CLS_UTL_Lightning.customValueWrapper();
            year.custFldValue = String.valueOf(i);
            year.custFldlabel = String.valueOf(i);
            system.debug('@@@@ year '+ i);
            years.add(year);
        }

        return years;
    }


    public class Wrapper_Liquidacion
    {
        @auraEnabled public String Period {get;set;}
        @auraEnabled public String Year {get;set;}
        @auraEnabled public String Month {get;set;}
        @auraEnabled public String Id {get;set;}
        @auraEnabled public String Status {get;set;}

    }

    @AuraEnabled
    public static List<Wrapper_Liquidacion> getLiquidaciones(String Id)
    {
        List<Wrapper_Liquidacion> liqs = new List<Wrapper_Liquidacion>();

        List<Liquidacion_RRVV__c> liquidaciones = [SELECT Id, Periodo__c, Agno__c, Mes__c, CaseId__c, AccountId__c, CaseNumber__c, Estado__c, Base64_1__c, Base64_2__c FROM Liquidacion_RRVV__c WHERE CaseId__c =: Id
        ORDER BY Periodo__c ASC];

        Wrapper_Liquidacion wliq = null;

        for(Liquidacion_RRVV__c liq : liquidaciones)
        {
            wliq = new Wrapper_Liquidacion();
            wliq.Period = liq.Periodo__c;
            wliq.Year = String.valueOf(liq.Agno__c);
            wliq.Month = liq.Mes__c;
            wliq.Id = liq.Id;
            wliq.Status = liq.Estado__c;
            liqs.add(wliq);
        }

        return liqs;
    }

    @AuraEnabled
    public static Boolean saveLiquidacion(String Id, String Year, String Month) {

        String period = Year+''+Month;

        List<Liquidacion_RRVV__c> liqs = [SELECT Id FROM Liquidacion_RRVV__c WHERE CaseId__c =: Id AND Periodo__c =: period];

        if (liqs.size() > 0)
        {
            return false;
        }

        try
        {
            Case caso = [SELECT Id, CaseNumber, RUT__c, Nombre_Completo_Razon_Social__c,  AccountId FROM Case WHERE Id =: Id];

            String rutSDV = caso.RUT__c.remove('-');
            Liquidacion_RRVV__c liq = new Liquidacion_RRVV__c();

            liq.Periodo__c = Year+''+Month;
            liq.Mes__c = getMonth(Month);
            liq.Agno__c = Integer.valueOf(Year);
            liq.CaseNumber__c = caso.CaseNumber;
            liq.AccountId__c = caso.AccountId;
            liq.RUT__c = rutSDV;
            liq.Nombre_Cliente__c = caso.Nombre_Completo_Razon_Social__c;
            liq.CaseId__c = caso.Id;
            liq.Estado__c = 'Ingresada';

            insert liq;


            // BAT_CS_ObtenerB64_Liquidacion j_PGU = new BAT_CS_ObtenerB64_Liquidacion(Id);
            // Id IdJobs = Database.executeBatch(j_PGU, 1);
            // System.debug('@@@@ IdJobs => ' + IdJobs);

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }

    @AuraEnabled
    public static Boolean deleteLiquidacion(String Id) {

        try
        {
            Liquidacion_RRVV__c liq =  [SELECT Id FROM Liquidacion_RRVV__c WHERE Id =: Id ];

            delete liq;

            return true;
        }
        catch(Exception ex)
        {
            return false;
        }
    }

    @AuraEnabled
    public static Boolean generateMail(String Id) {

        try
        {
            List<Liquidacion_RRVV__c> liquidaciones = [SELECT Id, Periodo__c, Agno__c, Mes__c, CaseId__c, AccountId__c, CaseNumber__c, Estado__c, RUT__c FROM Liquidacion_RRVV__c WHERE CaseId__c =: Id
            ORDER BY Periodo__c ASC];

            String meses = '';

            if (liquidaciones.size() > 2)
            {
                for (Integer i = 0; i < liquidaciones.size() -2; i++)
                {
                    meses = meses + liquidaciones[i].Mes__c +' '+liquidaciones[i].Agno__c + ', ';
                }

                meses = meses + liquidaciones[liquidaciones.size() -2].Mes__c +' '+liquidaciones[liquidaciones.size() -2].Agno__c + ' y ';
                meses = meses + liquidaciones[liquidaciones.size() -1].Mes__c  +' '+liquidaciones[liquidaciones.size() -1].Agno__c;
            }
            else if (liquidaciones.size() == 2)
            {
                meses = meses + liquidaciones[0].Mes__c +' '+liquidaciones[0].Agno__c + ' y ';
                meses = meses + liquidaciones[1].Mes__c +' '+liquidaciones[1].Agno__c;
            }
            else if (liquidaciones.size() == 1)
            {
                meses = liquidaciones[0].Mes__c  +' '+liquidaciones[0].Agno__c;
            }


             Case caso = [SELECT Id, Correo_Liquidaciones__c, Meses_Liquidaciones__c FROM Case WHERE Id =: Id];
             caso.Correo_Liquidaciones__c = true;
             caso.Meses_Liquidaciones__c = meses;
             update caso;


            BAT_CS_Gestion_Liquidaciones_RRVV j_PGU = new BAT_CS_Gestion_Liquidaciones_RRVV(Id);
            Id IdJobs = Database.executeBatch(j_PGU, 1);
            System.debug('@@@@ IdJobs => ' + IdJobs);

            return true;
         }
         catch(Exception ex)
         {
             system.debug('@@@ EX --> '+ex);
             return false;
         }

    }


   @AuraEnabled
    public static Boolean getEtapaLiquidacion(String Id) {

        Case caso = [SELECT Correo_Liquidaciones__c FROM Case WHERE Id =: Id];

        return caso.Correo_Liquidaciones__c;
    }
}