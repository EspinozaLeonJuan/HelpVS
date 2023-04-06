/**
 * @File Name          : TEST_CLS_CS_UploadValuetech.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 4/21/2020, 7:22:51 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/21/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@istest
public with sharing class TEST_CLS_CS_UploadValuetech {
    public TEST_CLS_CS_UploadValuetech() {

    }
    
    @isTest static void Upload_Test_01()
    {
        Test.startTest();
        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        upload.fileBody = Blob.valueOf('emp');
        CLS_CS_UploadValuetech.Upload(upload);       
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_02()
    {
        Test.startTest();
        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        upload.fileBody = Blob.valueOf('emp');
        upload.Archivador = 'Seguros Individuales';
        upload.Seguros_Individuales = new CLS_CS_UploadValuetech.Upload_Seguros_Individuales();
        upload.Seguros_Individuales.Empresa = 'Empresa';
        upload.Seguros_Individuales.Propuesta = '12345';
        upload.Seguros_Individuales.Poliza = '12345';
        upload.Seguros_Individuales.TipoDocumento = 'TipoDocumento';
        upload.Seguros_Individuales.RutAsegurado = '12345678-0';
        upload.Seguros_Individuales.NombreContratante = 'Empresa';
        upload.Seguros_Individuales.Siniestro = 'N';
        upload.Seguros_Individuales.EnviaAcsel = 'true';
        CLS_CS_UploadValuetech.Upload(upload);
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_03()
    {
        Test.startTest();
        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        upload.fileBody = Blob.valueOf('emp');
        upload.Archivador = 'Créditos';
        upload.Creditos = new CLS_CS_UploadValuetech.Upload_Creditos();
        upload.Creditos.Pagare = '12345';
        upload.Creditos.Empresa = 'Vida Security';
        upload.Creditos.RutEmpresa = '12345678-0';
        upload.Creditos.RutContratante = '12345678-0';
        upload.Creditos.NombreContrata = 'Nombre';
        upload.Creditos.TipoDocumento = 'Tipo';
        upload.Creditos.FamiliaDocumento = 'Familia';
        CLS_CS_UploadValuetech.Upload(upload);
        Test.stopTest();
    }
    
    @isTest static void Upload_Test_04()
    {
        Test.startTest();
        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        upload.fileBody = Blob.valueOf('emp');   
        upload.Archivador = 'Seguros Colectivos';     
        CLS_CS_UploadValuetech.Upload(upload);
        Test.stopTest();
    }
    
     @isTest static void Upload_Test_05()
    {
        Test.startTest();
        CLS_CS_UploadValuetech.UploadValuetech upload = new CLS_CS_UploadValuetech.UploadValuetech();
        upload.fileBody = Blob.valueOf('emp');
        upload.Archivador = 'Rentas Vitalicias';
        upload.Rentas_Vitalicias = new CLS_CS_UploadValuetech.Upload_Rentas_Vitalicias();
        upload.Rentas_Vitalicias.Empresa = 'Empresa';
        upload.Rentas_Vitalicias.RutEmpresa = '12345678-0';
        upload.Rentas_Vitalicias.Poliza = '12345';
        upload.Rentas_Vitalicias.RutContratante = '12345678-0';
        upload.Rentas_Vitalicias.NombreContrata = '';
        upload.Rentas_Vitalicias.TipoDocumento = '';
        upload.Rentas_Vitalicias.FamiliaDocumento = '';
        upload.Rentas_Vitalicias.Sielaf = '';
        upload.Rentas_Vitalicias.CodigoTipoDocumento = '';
        CLS_CS_UploadValuetech.Upload(upload);
        Test.stopTest();
    }
}