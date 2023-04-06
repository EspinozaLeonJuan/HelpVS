/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-12-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@isTest
public with sharing class TEST_CTR_UR_Botonera {
    
     @isTest static void IinicioBotonera_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.inicioBotonera();
        Test.stopTest();

    }
    
     @isTest static void BandejaCasosUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.BandejaCasosUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaTareasUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.BandejaTareasUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaColaboracionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.BandejaColaboracionesUR();
        Test.stopTest();
    }
    
     @isTest static void AsignacionesUR_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.AsignacionesUR();
        Test.stopTest();
    }
    
    @isTest static void BandejaCasosOptativos_Test_01()
    {
        Test.startTest();
        CTR_UR_Botonera controlador = new CTR_UR_Botonera();
        controlador.BandejaCasosOptativos();
        Test.stopTest();
    }
    
    
}