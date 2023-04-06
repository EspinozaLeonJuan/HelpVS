/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-01-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   12-01-2020   Juan Espinoza León   Initial Version
**/
@istest
public class TEST_CTR_TV_DetalleCarga {
    public TEST_CTR_TV_DetalleCarga() {

    }
    
    @istest
    public static void IniciaDetalle_1()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'GESTIONADA';
        insert carga;
        
         Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        ApexPages.currentPage().getParameters().put('id', carga.Id);    
        ApexPages.currentPage().getParameters().put('page', 'OK');  
        dcarga.IniciaDetalle();      
        Test.stopTest();
    }

    @istest
    public static void IniciaDetalle_2()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'PROCESADA';
        insert carga;
        
         Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        ApexPages.currentPage().getParameters().put('id', carga.Id);  
        ApexPages.currentPage().getParameters().put('page', 'ERROR');  
        dcarga.IniciaDetalle();
        Test.stopTest();
    }

    @istest
    public static void IniciaDetalle_3()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        ApexPages.currentPage().getParameters().put('id', carga.Id);  
        ApexPages.currentPage().getParameters().put('page', 'OK');
        dcarga.IniciaDetalle();
        Test.stopTest();
    }
    
    
    
     @istest public static void FirstPage()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.FirstPage();
         Test.stopTest();
     }
 
     @istest public static void previous()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.previous();
         Test.stopTest();        
     }
 

     @istest public static void next()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.next();
         Test.stopTest();
     }
 
     @istest public static void LastPage()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.LastPage();
         Test.stopTest();
     }
 
 
     @istest public static void getprev()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getprev();
         Test.stopTest();
     }
     
     @istest public static void getnxt()
     {
         Test.startTest();
         CTR_TV_DetalleCarga dt = new CTR_TV_DetalleCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getnxt();
         Test.stopTest();
     }
/*
    @istest
    public static void ReprocessUpload()
    {
        Test.startTest();

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        campaign.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospectos Campañas - Ventas Oncológico'].Id;
        campaign.Name = 'Campañana Oncologico Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta - Oncológico';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;        
        insert campaign;

    
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'ONCO';
        insert carga;

        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;

        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.IdCampagna = campaign.Id;
        dcarga.IdCarga = carga.Id;
        dcarga.TipoCampagna = carga.Tipo_Campagna__c;
        //ApexPages.currentPage().getParameters().put('id', carga.Id);
        dcarga.ReprocessUpload();
        Test.stopTest();
    }
*/

    @istest
    public static void ToHistory()
    {
        Test.startTest();
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.ToHistory();
        Test.stopTest();
    }


    @istest
    public static void CancelGestion()
    {
        Test.startTest();

        Carga_Televenta__c carga = new Carga_Televenta__c();
        insert carga;

        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.Carga = [SELECT Id FROM Carga_Televenta__c WHERE Id =: carga.Id];
        dcarga.CancelGestion();
        Test.stopTest();
    }


  /*  @istest
    public static void ArchivoProcesadoOk()
    {
        Test.startTest();

        Carga_Televenta__c carga = new Carga_Televenta__c();
        insert carga;

        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.IdCarga = carga.Id;
        dcarga.ArchivoProcesadoOk();
        Test.stopTest();
    }*/

    
    /**
     * 
     * 
     
    public Pagereference ToHistory()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page;  
    }

    public Pagereference CancelGestion()
    {
        Carga_Televenta__c c = [SELECT Id, Estado__c, Total_Prospectos_Ok__c FROM Carga_Televenta__c WHERE Id =: this.Carga.Id];
        c.Estado__c = 'CANCELADA';
        c.Total_Prospectos_Ok__c = 0;
        update c;
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page; 
    }

     */

    
    @istest
    public static void getData_DOK()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = false;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga(); 
        dcarga.IdCarga = carga.Id;
        dcarga.getData_DOK();
        Test.stopTest();        
    }

    @istest
    public static void getData_DError()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = true;
        insert registro2;
        
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.IdCarga = carga.Id;
        dcarga.getData_DError();
        Test.stopTest();       
    }

    @istest
    public static void RegistrosValidos()
    {
        Test.startTest();
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.IdCarga = '1';
        dcarga.RegistrosValidos();
        Test.stopTest();
    }

    @istest
    public static void RegistrosInvalidos()
    {
        Test.startTest();
        CTR_TV_DetalleCarga dcarga = new CTR_TV_DetalleCarga();
        dcarga.IdCarga = '1';
        dcarga.RegistrosInvalidos();
        Test.stopTest();        
    }

    
}