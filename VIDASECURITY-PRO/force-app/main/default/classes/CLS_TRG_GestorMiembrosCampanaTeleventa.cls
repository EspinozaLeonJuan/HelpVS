/*******************************************************************************************
 *  NOMBRE                 : CLS_OncologicoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_TRG_GestorMiembrosCampanaTeleventa {

    
    static testMethod void TRG_GestorMiembrosCampanaTeleventa() {
        try{
            
           
            
           /* Campaign campana = new Campaign();
            campana.Id = 'XXXXXXXXXXXX';
            campana.Name = 'test';
            campana.RecordTypeId = '0120H000001QUFOQA4';
            insert campana;*/
            
            Test.startTest();
        	Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
            
            Campaign campana =[select Id,name,recordtypeId from campaign where recordTypeId='0120H000001QUFOQA4' limit 1];
            
            CampaignMember cmProspecto = new CampaignMember();
            
             
            cmProspecto.CampaignId = campana.Id;
            cmProspecto.MCAMP_Carga_RUT__c = '9188219';
            
            cmProspecto.MCAMP_Carga_Dv__c = '1';
            cmProspecto.MCAMP_Carga_Tel_fono_1__c = '+56224565556';
            cmProspecto.MCAMP_Carga_Tel_fono_2__c = '+56224565556';
            cmProspecto.MCAMP_Carga_Poliza_Mandatoria__c = '';
            cmProspecto.MCAMP_Carga_Email_1__c = 'gpinto@microystem.cl';
            cmProspecto.MCAMP_Carga_Email_2__c = '';
            cmProspecto.MCAMP_Abierto_Email_N1_Producto_Onco__c = false;
            cmProspecto.MCAMP_Carga_Tel_fono_1__c = '';
            cmProspecto.MCAMP_Carga_Tel_fono_2__c = '';
            cmProspecto.MCAMP_Campana_Activa__c = true;
            cmProspecto.MCAMP_Codigo_Producto__c = '';
            cmProspecto.MCAMP_Es_Asegurable__c = 'S'; 
            cmProspecto.MCAMP_Campana_Activa__c = true;
            cmProspecto.MCAMP_Enviado_Email_1_Producto_Onco__c = true;
            cmProspecto.MCAMP_WS_Equifax_Consumido__c = true;
            cmProspecto.MCAMP_WS_Producto_Oncol_gico_Consumido__c = false;
            cmProspecto.MCAMP_WS_Equifax_Consumido__c = false;
            cmProspecto.MCAMP_Tipo_Folio__c = '19';
            insert cmProspecto;            
            
            cmProspecto.MCAMP_Carga_Email_1__c = 'jespinoza@email.cl';
            update cmProspecto;
            Test.stopTest();    
        }
        catch(Exception ex)
        {
            system.debug('@@@@@ PRUEBA TRIGGER TRG_GESTORMIEMBROSCAMPANA => ' + ex);
    	    Test.stopTest();    
        } 
	}
    /*
    static testmethod void test2() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
        Account cta = new Account();
        
        String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE Rut__c = '16903814' LIMIT 1];
           
    	Date myDate = Date.today().addMonths(-4);
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = cta.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'M';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  0.864000;
        poliza.Valor_Poliza__c = 0;
        
        insert poliza;
        
		Campaign cam = new Campaign();
        cam.Name = 'CAMPAÑA ONCO TEST';
        cam.Status = 'En curso';
        cam.IsActive = true;
        cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
        cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        cam.StartDate = Date.today();
        cam.EndDate = Date.today() + 5;
        cam.Type = 'Televenta - Oncológico';
        cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        cam.CAMPA_Script_Televenta__c = 'Hola!!';
        cam.CAMP_Producto__c = '66';
        
        Insert cam;
        
        CampaignMember mc = new CampaignMember();
        mc.CampaignId = cam.Id;
        mc.MCAMP_Carga_RUT__c = '16903814';
        mc.MCAMP_Carga_Dv__c = '7';
        mc.MCAPM_Carga_Primer_Nombre__c = 'Isaac';
        mc.MCAMP_Carga_Apellido_Paterno__c = 'Salazar';
        mc.MCAMP_Carga_Apellido_Materno__c = 'Araneda';
        mc.MCAMP_Carga_Email_1__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Email_2__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
        mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
        mc.MCAMP_Tipo_Producto__c = '66';
        
        Insert mc;        
 
        Test.stopTest();
    }*/
    
    static testmethod void test3() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
        Account cta = new Account();
        
        String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE Rut__c = '16903814' LIMIT 1];
           
    	Date myDate = Date.today().addMonths(-4);
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = cta.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        poliza.Frecuencia_de_Pago__c = 'M';
        poliza.Con_o_Sin_Ahorro__c = 'Con Ahorro';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Fecha_Ultimo_Pago__c = myDate;
        poliza.Prima_Minima__c =  0.864000;
        poliza.Valor_Poliza__c = 0;
        
        insert poliza;
        
		Campaign cam = new Campaign();
        cam.Name = 'CAMPAÑA ONCO TEST';
        cam.Status = 'En curso';
        cam.IsActive = true;
        cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
        cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        cam.StartDate = Date.today();
        cam.EndDate = Date.today() + 5;
        cam.Type = 'Televenta - Oncológico';
        cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        cam.CAMPA_Script_Televenta__c = 'Hola!!';
        cam.CAMP_Producto__c = '19';
        
        Insert cam;
        
        CampaignMember mc = new CampaignMember();
        mc.CampaignId = cam.Id;
        mc.MCAMP_Carga_RUT__c = '16903814';
        mc.MCAMP_Carga_Dv__c = '7';
        mc.MCAPM_Carga_Primer_Nombre__c = 'Isaac';
        mc.MCAMP_Carga_Apellido_Paterno__c = 'Salazar';
        mc.MCAMP_Carga_Apellido_Materno__c = 'Araneda';
        mc.MCAMP_Carga_Email_1__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Email_2__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
        mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
        mc.MCAMP_Tipo_Producto__c = '19';
        
        Insert mc;        
 
        Test.stopTest();
    }
    
    static testmethod void test4() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
        Account cta = new Account();
        
        String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE Rut__c = '16903814' LIMIT 1];
                
		Campaign cam = new Campaign();
        cam.Name = 'CAMPAÑA ONCO TEST';
        cam.Status = 'En curso';
        cam.IsActive = true;
        cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
        cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        cam.StartDate = Date.today();
        cam.EndDate = Date.today() + 5;
        cam.Type = 'Televenta - Oncológico';
        cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        cam.CAMPA_Script_Televenta__c = 'Hola!!';
        cam.CAMP_Producto__c = '19';
        
        Insert cam;
        
        CampaignMember mc = new CampaignMember();
        mc.CampaignId = cam.Id;
        mc.MCAMP_Carga_RUT__c = '16903814';
        mc.MCAMP_Carga_Dv__c = '7';
        mc.MCAPM_Carga_Primer_Nombre__c = 'Isaac';
        mc.MCAMP_Carga_Apellido_Paterno__c = 'Salazar';
        mc.MCAMP_Carga_Apellido_Materno__c = 'Araneda';
        mc.MCAMP_Carga_Email_1__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Email_2__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
        mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
        mc.MCAMP_Tipo_Producto__c = '19';
        
        Insert mc;        
 
        Test.stopTest();
    }
    
    static testmethod void test5() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
           
        String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        
		Campaign cam = new Campaign();
        cam.Name = 'CAMPAÑA ONCO TEST';
        cam.Status = 'En curso';
        cam.IsActive = true;
        cam.CAMPA_COD_Campa_a__c = 'CAMP#-10900';
        cam.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        cam.StartDate = Date.today();
        cam.EndDate = Date.today() + 5;
        cam.Type = 'Televenta - Oncológico';
        cam.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        cam.CAMPA_Script_Televenta__c = 'Hola!!';
        cam.CAMP_Producto__c = '19';
        
        Insert cam;
        
        CampaignMember mc = new CampaignMember();
        mc.CampaignId = cam.Id;
        mc.MCAMP_Carga_RUT__c = '13923732';
        mc.MCAMP_Carga_Dv__c = '3';
        mc.MCAPM_Carga_Primer_Nombre__c = 'Isaac';
        mc.MCAMP_Carga_Apellido_Paterno__c = 'Salazar';
        mc.MCAMP_Carga_Apellido_Materno__c = 'Araneda';
        mc.MCAMP_Carga_Email_1__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Email_2__c = 'isalazar@security.cl';
        mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
        mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
        mc.MCAMP_Tipo_Producto__c = '19';
        
        Insert mc;        
 
        Test.stopTest();
    }     
}