/**
 * @File Name          : TEST_CTR_CS_UploadValuetech.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 4/21/2020, 5:31:32 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/21/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@istest(seeAllData=true)
public with sharing class TEST_CTR_CS_UploadValuetech {
    public TEST_CTR_CS_UploadValuetech() {

    }
    
    @isTest static void IniciaCargaAdjunto_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.IniciaCargaAdjunto();
        Test.stopTest();
    }
    
     @isTest static void getAdjuntos_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.Codigo_Requerimiento = 'RRVVTIPO0004';
        controlador.getAdjuntos();
        Test.stopTest();
    }
    
    @isTest static void getAdjuntosAll_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.getAdjuntosAll();
        Test.stopTest();
    }
    
    @isTest static void getTiposDocumento_IND_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.getTiposDocumento_IND();
        Test.stopTest();
    }
    
    @isTest static void getListaSolicitantes_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.getListaSolicitantes();
        Test.stopTest();
    }
    
     @isTest static void changeObligatorio_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.changeObligatorio();
        Test.stopTest();
    }

     @isTest static void getFamiliaRRVV_Test()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.getFamilia_RRVV();
        Test.stopTest();
    }
    
     @isTest static void Upload_Test_01()
    {
        Test.startTest();
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);               
        controlador.Upload();
        Test.stopTest();
    }


	@isTest static void Upload_Test_02()
    {
        Test.startTest();
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c ='123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item2;
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.fileBody = Blob.valueOf('emp');        
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        
        controlador.OtroDocumento = 'nombre de otro documento';
        controlador.IdRelacionAdjunto = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        controlador.IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        controlador.NombreCarga = 'Juan Espinoza Leon';
        controlador.Es_Credito = true;
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_03()
    {
        Test.startTest();
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c ='123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item2;
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.fileBody = Blob.valueOf('emp');        
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.OtroDocumento = 'nombre de otro documento';
        controlador.NombreCarga = 'Juan Espinoza Leon';
        controlador.IdRelacionAdjunto = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        controlador.IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        
        controlador.Es_Credito = false;
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_04()
    {
        Test.startTest();
        
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description'  ,Codigo__c='123');
        insert item2;
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c = '123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.fileBody = Blob.valueOf('emp');        
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Negocio__c = 'Seguros Individuales';
        controlador.OtroDocumento = 'nombre de otro documento';
        controlador.NombreCarga = 'Juan Espinoza Leon';
        controlador.IdRelacionAdjunto = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        controlador.IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        
        controlador.Upload();
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_05()
    {
        Test.startTest();
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c ='123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item2;
        CTR_CS_UploadValuetech controlador = new CTR_CS_UploadValuetech();
        controlador.fileBody = Blob.valueOf('emp');        
        Account cuenta = Factory.cuenta.buildInsert();               
        controlador.Caso = Factory.buildCasoSF('Solicitudes', cuenta);
        controlador.Caso.Negocio__c = 'Seguros Colectivos';
        controlador.OtroDocumento = 'nombre de otro documento';
        controlador.NombreCarga = 'Juan Espinoza Leon';
        controlador.IdRelacionAdjunto = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        controlador.IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        
        controlador.Upload();
        Test.stopTest();
    }
      @isTest static void GetData_Individuales_Test()
    {
        Test.startTest();
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c ='123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item2;
        String IdRelacion = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        String IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        CTR_CS_UploadValuetech.GetData_Individuales(IdRelacion, IdAdjunto,'otro documento nombre');
        Test.stopTest();
    }
    
      @isTest static void GetData_RRVV_Test()
    {
        Test.startTest();
        REL_Requerimiento_Adjunto__c item = new REL_Requerimiento_Adjunto__c(Codigo_Adjunto__c ='123', Codigo_Requerimiento__c='1234', Nombre_Adjunto__c='12345');
        insert item;
        OBJ_Adjunto__c item2 = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item2;
        String IdRelacion = [SELECT Id FROM REL_Requerimiento_Adjunto__c LIMIT 1].Id;
        String IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;
        CTR_CS_UploadValuetech.GetData_RRVV(IdRelacion, IdAdjunto,'otro documento nombre');
        Test.stopTest();
    }
    
    @isTest static void GetData_Colectivos_Test()
    {
        Test.startTest(); 
        OBJ_Adjunto__c item = new OBJ_Adjunto__c(Activo__c=true,Descripcion__c = 'description');
        insert item;
        String IdAdjunto = [SELECT Id FROM OBJ_Adjunto__c LIMIT 1].Id;     
        CTR_CS_UploadValuetech.GetData_Colectivos(IdAdjunto,'otro documento nombre');
        Test.stopTest();
    }
    
     

}