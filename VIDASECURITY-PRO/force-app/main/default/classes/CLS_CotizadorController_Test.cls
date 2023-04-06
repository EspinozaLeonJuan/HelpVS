@istest
public class CLS_CotizadorController_Test {

    @istest static void ParametroDigitador()
    {
          Test.startTest();
        
         CLS_CotizadorController.ParametroDigitador Par1 = new CLS_CotizadorController.ParametroDigitador('','','','','','','','','','','','','','','','','','','');
         CLS_CotizadorController.ParametroDigitador Par2 = new CLS_CotizadorController.ParametroDigitador();
       	 CLS_CotizadorController Con = new CLS_CotizadorController();
        
        //Con.ParametroDigitador = new CLS_CotizadorController.ParametroDigitador();
      //  Con.ParametroDigitador('','','','','','','','','','','','','','','','','','','');*/
      //  
      	Con.idTarea='0';
        CLS_CotizadorController.IDCANAL='';
        CLS_CotizadorController.URL_parametros='';
        CLS_CotizadorController.activaBotonPD=false;
        CLS_CotizadorController.UsuaroTvta='';
        CLS_CotizadorController.tipoCliente='';
        CLS_CotizadorController.LST_RegionesSF= new List<Region__c>();
        CLS_CotizadorController.LST_Regiones= new List<SelectOption>();
        CLS_CotizadorController.LST_Ciudades= new List<SelectOption>();
        CLS_CotizadorController.LST_Comunas= new List<SelectOption>();
        CLS_CotizadorController.VER_CAMPOCIUDAD=false;
        CLS_CotizadorController.VER_CAMPOCOMUNA=false;
        CLS_CotizadorController.LST_Tarjetas= new List<SelectOption>();
        CLS_CotizadorController.COD_TarjetaSeleccionada='';
    
        Test.stopTest();
    }
    
    @istest static void cargaDatosContratanteCotizadorExpress()
    {
         Test.startTest();
        CLS_CotizadorController Con = new CLS_CotizadorController();
        Con.TAREA_Contratante = new Task();
        Con.cargaDatosContratanteCotizadorExpress();
        Test.stopTest();
    }
    
    @istest static void getCargaRegiones()
    {
         Test.startTest();
       
        List<SelectOption>  lista = CLS_CotizadorController.getCargaRegiones();
        Test.stopTest();
    }
    
     @istest static void AbrirPreDigita()
    {
        Test.startTest();
        CLS_CotizadorController Con = new CLS_CotizadorController();
        Test.setMock(WebServiceMock.class, new WSAccessMantienePersistenciaMock());
        
        
        
        //Generación Campaña Activa...
            Campaign campana = new Campaign();
            campana.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
            campana.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospectos Campañas - Ventas Oncológico'].Id;
            campana.Name = 'Campañana Oncologico Test';
            campana.Status = 'En Curso';
            campana.IsActive = true;
            campana.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
            campana.Type = 'Televenta - Oncológico';
            campana.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
            campana.Description = 'Test';
            campana.CAMPA_Script_Televenta__c = 'Test';
            campana.StartDate = Date.today();
            campana.EndDate = Date.today() + 1;
            //insert campana;
            
        
        
        
        CampaignMember cmCliente = new CampaignMember();
            
        cmCliente.CampaignId = campana.Id;
        cmCliente.MCAMP_Carga_RUT__c = '15154056';
        cmCliente.MCAMP_Carga_Dv__c = '2';
        cmCliente.MCAMP_Carga_Tel_fono_1__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_2__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_3__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_4__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_5__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_6__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_7__c = '+56224565556';
        cmCliente.MCAMP_Carga_Tel_fono_8__c = '+56224565556';
        cmCliente.MCAMP_Carga_Poliza_Mandatoria__c = '';
        cmCliente.MCAMP_Carga_Email_1__c = 'consultor@norvid.cl';
        cmCliente.MCAMP_Carga_Email_2__c = '';
           // insert cmCliente;
        
        Con.MC_CLIENTE = cmCliente;
        Con.AbrirPreDigita();
        Test.stopTest();
    }
    
     @istest static void cargaDatosContratantePreDigitador()
    {
         Test.startTest();
        CLS_CotizadorController Con = new CLS_CotizadorController();
        Con.cargaDatosContratantePreDigitador();
        Test.stopTest();
    }
    
    @istest static void RegionCiudadComuna()
    {
         Test.startTest();
        
        CLS_CotizadorController Con = new CLS_CotizadorController();
        Con.getRegion();
        Con.getCiudad();
        Con.getComuna();
        
        CLS_CotizadorController.CLS_Region Region = new CLS_CotizadorController.CLS_Region('','');
        CLS_CotizadorController.CLS_Ciudad Ciudad = new CLS_CotizadorController.CLS_Ciudad('','','');
        CLS_CotizadorController.CLS_Comuna Comuna = new CLS_CotizadorController.CLS_Comuna('','','','');
 
        Test.stopTest();
    }
    
    
    
}