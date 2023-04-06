/*******************************************************************************************
 *  NOMBRE                 : TRG_GestorMiembrosCampanasTv_Test
 *  TIPO                   : APEX CLASS TEST
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 17/12/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
@isTest(SeeAllData=true)
private class TRG_GestorMiembrosCampanasTv_Test {

    // Métodos Test Llamadas WS Onco Backoffice
    static testMethod void Escenarios_ClienteExistente_A(){
        
        try{
            
            Test.startTest();
            //Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());

            Account cta = new Account();
            String rtype = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            cta = [SELECT Id, FirstName, LastName, PersonEmail, PersonMobilePhone, PersonHomePhone, RecordTypeId, Rut__c, DV__c FROM Account WHERE RecordTypeId =: rtype LIMIT 1];
            //insert cta;

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
            mc.MCAMP_Carga_RUT__c = cta.Rut__c;
            mc.MCAMP_Carga_Dv__c = Cta.DV__c;
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
            Insert mc;
            
            //String rutPersona = '10355641-4';
          
            //CLS_LlamadaWSonco.consultarDatosEquifaxOnco('12-9', rutPersona, mc.Id);
            //CLS_LlamadaWSonco.actualizarPropuestaOnco( '12-9', o.Id );

            //CLS_LlamadaWSonco.RESPjson r = new CLS_LlamadaWSonco.RESPjson('200','Prueba');
            //CLS_LlamadaWSonco.RESPjson r1 = new CLS_LlamadaWSonco.RESPjson();
            //r1.Codigo = '200';
            //r1.Descripcion = 'Prueba';            
            
            Test.stopTest();
            
        }catch(Exception ex){
            system.debug('@@@@ ERROR METODO TEST TRG_GESTORMIEMBROSCAMPANA CLIENTE EXISTENTE CUENTA => ' + ex.getMessage() + ', LINEA => ' + ex.getLineNumber());
        }finally{
            
        }
    }
    
    // Métodos Test Llamadas WS Onco Backoffice
    static testMethod void Escenarios_ClienteExistente_B(){
        
        try{
            
            Test.startTest();
            //Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());

            Lead can = new Lead();
            can.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;
            can.FirstName = 'Juan';
            can.LastName = 'Juanito';
            can.Email = 'hola@hola.cl';
            can.Phone = '56227789900';
            can.MobilePhone = '5694565566';
            can.PROSP_Carga_RUT__c = '21621986';            
            insert can;

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
            mc.MCAMP_Carga_RUT__c = '21621986';
            mc.MCAMP_Carga_Dv__c = '4';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';

            Insert mc;
            
            //String rutPersona = '10355641-4';
          
            //CLS_LlamadaWSonco.consultarDatosEquifaxOnco('12-9', rutPersona, mc.Id);
            //CLS_LlamadaWSonco.actualizarPropuestaOnco( '12-9', o.Id );

            //CLS_LlamadaWSonco.RESPjson r = new CLS_LlamadaWSonco.RESPjson('200','Prueba');
            //CLS_LlamadaWSonco.RESPjson r1 = new CLS_LlamadaWSonco.RESPjson();
            //r1.Codigo = '200';
            //r1.Descripcion = 'Prueba';            
            
            Test.stopTest();
            
        }catch(Exception ex){
            system.debug('@@@@ ERROR METODO TEST TRG_GESTORMIEMBROSCAMPANA CLIENTE EXISTEN LEAD => ' + ex.getMessage() + ', LINEA => ' + ex.getLineNumber());
        }finally{
            
        }
    }    
    
    // Métodos Test Llamadas WS Onco Backoffice
    static testMethod void Escenarios_ClienteNuevo_A(){
        
        try{
            
            Test.startTest();

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
            mc.MCAMP_Carga_RUT__c = '17659955';
            mc.MCAMP_Carga_Dv__c = '3';
            mc.MCAPM_Carga_Primer_Nombre__c = 'Héctor';
            mc.MCAMP_Carga_Apellido_Paterno__c = 'Norambuena';
            mc.MCAMP_Carga_Apellido_Materno__c = 'Orellana';
            mc.MCAMP_Carga_Email_1__c = 'hno@no.cl';
            mc.MCAMP_Carga_Email_2__c = 'hno@no.cl';
            mc.MCAMP_Carga_Tel_fono_1__c = '56227896655';
            mc.MCAMP_Carga_Tel_fono_2__c = '56227896655';
            mc.MCAMP_Tipo_Producto__c = '19';
            
            Insert mc;
            
            Test.stopTest();
            
        }catch(Exception ex){
            system.debug('@@@@ ERROR METODO TEST TRG_GESTORMIEMBROSCAMPANA CLIENTE NUEVO => ' + ex.getMessage() + ', LINEA => ' + ex.getLineNumber());
        }finally{
            
        }
    }     
    
}