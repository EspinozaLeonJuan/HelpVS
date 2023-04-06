/*******************************************************************************************
*  NOMBRE                 : TEST_CLS_ParticipanteCobranzaTV
*  TIPO                   : APEX CLASS
*  REQUERIMIENTO          : PROYECTO COBRANZA TELEVENTA
*  DESCRIPCION            : TEST para clase CLS_ParticipanteCobranzaTV
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 08/04/2019 - I.S              - Creación Clase
* *****************************************************************************************/
@isTest
public class TEST_CLS_ParticipanteCobranzaTV {
    
    static {
        TriggerHandler.enable(CLS_ParticipanteCobranzaTV.class);
    }
    
    static testMethod void TestDefault() {
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];
        
        update user;
        
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;  
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;
        
        Date myDate = Date.today().addMonths(-4);
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'M';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  0.864000;
        poliza.Valor_Poliza__c = 0;        
        
        Date myDate2 = Date.today().addMonths(-4);
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza2.Frecuencia_de_Pago__c = 'M';
        poliza2.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.N_Poliza__c = 1516893;
        poliza2.Fecha_Ultimo_Pago__c = myDate2;
        poliza2.Prima_Minima__c =  0.864000;
        poliza2.Valor_Poliza__c = 0;
        
        Date myDate3 = Date.today().addMonths(2);
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza3.Frecuencia_de_Pago__c = 'M';
        poliza3.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.N_Poliza__c = 1516891;
        poliza3.Fecha_Ultimo_Pago__c = myDate3;
        poliza3.Prima_Minima__c =  0.864000;
        poliza3.Valor_Poliza__c = 0;
        
        Test.startTest();
        insert poliza;
        insert poliza2;
        insert poliza3;
        
         
        
        Test.stopTest();  
    }
    
    static testMethod void TestFrecuenciaMensual() {
        Set<String> TIPOPROD = new Set<String>{'Seguro de Salud','Seguro de Vida','57','Flexibles','APV','Patrimonial','Valor Garantizado'};
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];        
        update user;
        
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;          
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;  
        
        Date myDate = Date.today().addMonths(-4);         
        
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.N_Poliza__c = 987654;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'M';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  2.250000;
        poliza.Valor_Poliza__c = 935.249000;
        
        Date myDate2 = Date.today().addMonths(-14);         
        
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.N_Poliza__c = 123456;
        poliza2.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza2.Frecuencia_de_Pago__c = 'M';
        poliza2.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.Fecha_Ultimo_Pago__c = myDate2;
        poliza2.Prima_Minima__c =  2.250000;
        poliza2.Valor_Poliza__c = 935.249000;
        
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.N_Poliza__c = 1987654;
        poliza3.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza3.Frecuencia_de_Pago__c = 'M';
        poliza3.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.Fecha_Ultimo_Pago__c = myDate;
        poliza3.Prima_Minima__c =  2.250000;
        poliza3.Valor_Poliza__c = 935.249000;        
        
        Test.startTest();
        insert poliza;
        insert poliza2;
        insert poliza3;
        Test.stopTest();  
    }
    
    static testMethod void TestFrecuenciaTrimestral() {
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];        
        update user;
        
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;        
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;  
        
        Date myDate = Date.today().addMonths(-6);         
        
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.N_Poliza__c = 9876542;
        poliza.Frecuencia_de_Pago__c = 'T';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  2.250000;
        poliza.Valor_Poliza__c = 935.249000;
        
        Date myDate2 = Date.today().addMonths(-20);         
        
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.N_Poliza__c = 1234562;
        poliza2.Frecuencia_de_Pago__c = 'T';
        poliza2.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.Fecha_Ultimo_Pago__c = myDate2;
        poliza2.Prima_Minima__c =  2.250000;
        poliza2.Valor_Poliza__c = 935.249000;
        
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.N_Poliza__c = 39876542;
        poliza3.Frecuencia_de_Pago__c = 'T';
        poliza3.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.Fecha_Ultimo_Pago__c = myDate;
        poliza3.Prima_Minima__c =  2.250000;
        poliza3.Valor_Poliza__c = 935.249000;        
        
        Test.startTest();
        insert poliza;
        insert poliza2;
        insert poliza3;
        Test.stopTest();
    }
    
    static testMethod void TestFrecuenciaSemestral() {
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];        
        update user;
         
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;  
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;  
        
        Date myDate = Date.today().addMonths(-6);         
        
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.N_Poliza__c = 9876543;
        poliza.Frecuencia_de_Pago__c = 'S';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  2.250000;
        poliza.Valor_Poliza__c = 935.249000;
        
        Date myDate2 = Date.today().addMonths(-20);         
        
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.N_Poliza__c = 1234563;
        poliza2.Frecuencia_de_Pago__c = 'S';
        poliza2.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.Fecha_Ultimo_Pago__c = myDate2;
        poliza2.Prima_Minima__c =  2.250000;
        poliza2.Valor_Poliza__c = 935.249000;
        
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.N_Poliza__c = 39876543;
        poliza3.Frecuencia_de_Pago__c = 'S';
        poliza3.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.Fecha_Ultimo_Pago__c = myDate;
        poliza3.Prima_Minima__c =  2.250000;
        poliza3.Valor_Poliza__c = 935.249000;        
        
        Test.startTest();
        insert poliza;
        insert poliza2;
        insert poliza3;
        Test.stopTest();
    }
    
    static testMethod void TestFrecuenciaAnual() {
        Test.startTest();
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];        
        update user;
        
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;  
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;  
        
        Date myDate = Date.today().addMonths(-20);         
        
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.N_Poliza__c = 9876544;
        poliza.Frecuencia_de_Pago__c = 'A';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  2.250000;
        poliza.Valor_Poliza__c = 935.249000;
        
        Date myDate2 = Date.today().addMonths(-40);         
        
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.N_Poliza__c = 1234564;
        poliza2.Frecuencia_de_Pago__c = 'A';
        poliza2.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza2.Estatus__c = 'ACTIVA';
        poliza2.Fecha_Ultimo_Pago__c = myDate2;
        poliza2.Prima_Minima__c =  2.250000;
        poliza2.Valor_Poliza__c = 935.249000;
        
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.N_Poliza__c = 39876544;
        poliza3.Frecuencia_de_Pago__c = 'A';
        poliza3.Con_o_Sin_Ahorro__c = 'Sin Ahorro';
        poliza3.Estatus__c = 'ACTIVA';
        poliza3.Fecha_Ultimo_Pago__c = myDate;
        poliza3.Prima_Minima__c =  2.250000;
        poliza3.Valor_Poliza__c = 935.249000;        
        
        insert poliza;
        insert poliza2;
        insert poliza3;
        
        poliza.Estatus__c = 'ANULADA';
        upsert poliza;
        Date myDate4 = Date.today().addMonths(1);      
        poliza2.Fecha_Ultimo_Pago__c = myDate4;
        upsert poliza2;
        Test.stopTest();
    }     
    
    static testMethod void TestFiltros() {
        Id recordTypeColectivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId();
        Campana_Vida_Security__c campaign = new Campana_Vida_Security__c();
        campaign.Name = 'Campaña Cobranzas Televenta';
        insert campaign;
        
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas Televenta'].Id;
        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE CommunityNickname = 'sfvida'];        
        update user;
        
        Ciudad__c ciudad = new Ciudad__c();
        ciudad.Name = 'SANTIAGO';
       	insert ciudad;          
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
        account.Ciudad_Particular_B__c = ciudad.Id;
        insert account;
        
        Date myDate = Date.today().addMonths(-4);
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'U';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  0.864000;
        poliza.Valor_Poliza__c = 0;
        
        Test.startTest();
        insert poliza;
        poliza.Frecuencia_de_Pago__c = '';
        upsert poliza;
        poliza.RecordTypeId = recordTypeColectivos;
        poliza.Frecuencia_de_Pago__c = 'Con Ahorro';
        upsert poliza;
        Test.stopTest();  
    }
}