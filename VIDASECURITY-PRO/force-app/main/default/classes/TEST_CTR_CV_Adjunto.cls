/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CTR_CV_Adjunto                                                               |
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CTR_CV_Adjunto                                                                    |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/21   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

@isTest
public class TEST_CTR_CV_Adjunto {
	@isTest static void IniciaCargaAdjunto_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.IniciaCargaAdjunto();
        Test.stopTest();
    }

    @isTest static void getAdjuntos_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.IdRequerimiento = 'TREQ0005';
        controlador.getAdjuntos();
        Test.stopTest();
    }
    
    @isTest static void getAdjuntosAll_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.getAdjuntosAll();
        Test.stopTest();
    }

	@isTest static void getTiposDocumento_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.getTiposDocumento();
        Test.stopTest();
    }
    
    @isTest static void getListaSolicitantes_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.Caso = new Case();
        controlador.Caso.Detalle_Solicitud__c = 'ED - Solicitud Otros Endosos';
        controlador.getListaSolicitantes();
        Test.stopTest();
    }

    @isTest static void changeObligatorio_Test()
    {
        Test.startTest();
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        //List<REL_Requerimiento_Adjunto__c> relaciones = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1];
        
        ApexPages.currentPage().getParameters().put('idAdjunto', '123');//  'a1R550000013oeYEAQ');        
        controlador.changeObligatorio();
        Test.stopTest();
    }
    
    
    @isTest static void Upload_Test_01()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.fileBody = null;
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_02()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.fileBody = Blob.valueOf('emp');
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Status = 'Nuevo';
        controlador.Soportado = true;
        controlador.OtroDocumento = 'Otro documento';
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_03()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.fileBody = Blob.valueOf('emp');
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Status = 'Nuevo';
        controlador.Soportado = true;        
        controlador.Upload();
        Test.stopTest();
    }

	@isTest static void Upload_Test_04()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.fileBody = Blob.valueOf('emp');
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Status = 'Nuevo';
        controlador.Soportado = false;
        controlador.NombreDocumento = 'Nombre documento';
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_05()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();  
        CTR_CV_Adjunto controlador = new CTR_CV_Adjunto();
        controlador.fileBody = Blob.valueOf('emp');
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Status = 'Nuevo';
        controlador.Soportado = false;        
        controlador.Upload();
        Test.stopTest();
    }

    
    
    
}