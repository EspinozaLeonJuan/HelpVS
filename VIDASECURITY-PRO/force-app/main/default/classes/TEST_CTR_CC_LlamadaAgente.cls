/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-29-2021   Juan Espinoza León   Initial Version
**/
@IsTest
public with sharing class TEST_CTR_CC_LlamadaAgente {
    public TEST_CTR_CC_LlamadaAgente() {
 
    }

    @isTest static void postCall()
    {
        Test.startTest();
        PAR_EXT_WS_RealizaLlamada param = new PAR_EXT_WS_RealizaLlamada();
        param.Id = 'asdsadsa';
        param.Desde = '1111111';
        param.Hasta = '222222';
        param.Rut = '15045517-0';
        param.Usuario = 'jespinoza';
        EXT_API_CC_RealizarLlamada.postCall(param);
        Test.stopTest();
    }

    @IsTest(SeeAllData=true) static void cargaInformacionLlamada()
    {
        Test.startTest();
 		TriggerHandler.disable();
        Account cuenta = Factory.cuenta.buildInsert();               
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        
        Task tarea = new Task();
        tarea.Subject = 'Llamada';
        tarea.WhatId = cuenta.Id;
        insert tarea;
        
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();

        ApexPages.currentPage().getParameters().put('Origin', 'Case');
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('CallBack', 'si');
        controlador.cargaInformacionLlamada();

        ApexPages.currentPage().getParameters().put('Origin', 'Account');
        ApexPages.currentPage().getParameters().put('Id', cuenta.Id);
        ApexPages.currentPage().getParameters().put('CallBack', 'no');

        controlador.cargaInformacionLlamada();

        ApexPages.currentPage().getParameters().put('Origin', 'Task');
        ApexPages.currentPage().getParameters().put('Id', tarea.Id);
        ApexPages.currentPage().getParameters().put('CallBack', 'si');

        controlador.cargaInformacionLlamada();       
        
        cuenta = [SELECT Id FROM Account WHERE RUT__C = '99999995'];
                
        String RecordTypeIdLead = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Prospecto_Contact_Center' AND IsActive = true].Id;
                        
        Lead prospecto = new Lead(); 
        prospecto.Rut__c  ='15045517-0';
        prospecto.PROSP_Carga_Tel_fono_2__c  ='947338647';
        prospecto.MobilePhone  ='947338647';
        prospecto.Phone  ='947338647';
        prospecto.LastName = 'Espinoza';
        prospecto.RecordTypeId = RecordTypeIdLead;
        insert prospecto;
        
        caso = Factory.buildCasoSF('Solicitudes', cuenta);
        caso.RUT_no_Cliente__c = '15045517-0';
        insert caso;
        
        ApexPages.currentPage().getParameters().put('Origin', 'Case');
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('CallBack', 'si');

        controlador.cargaInformacionLlamada();
        
        Test.stopTest();
    }

    @isTest static void getListadoTelefonos() {
        Test.startTest();
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
        controlador.Telefonos = new List<String>();
        controlador.getListadoTelefonos();
        Test.stopTest();
    }


    @isTest static void getListadoAnexos() {
         Test.startTest();
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
        controlador.getListadoAnexos();
        Test.stopTest();
        //if (String.IsNotBlank(this.Usuario.Anexo_A__c))
        //if (String.IsNotBlank(this.Usuario.Anexo_B__c))
    }

    @isTest static void btnLlamar() {
        Test.startTest();
        TriggerHandler.disable();
        Account cuenta = Factory.cuenta.buildInsert();               
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
        controlador.NumeroLlamada = '921131233';
        controlador.Anexo = '2211';
        controlador.IdCaso = caso.Id;
        controlador.btnLlamar();
        
        Test.stopTest();
//        if (String.IsNotBlank(this.NumeroLlamada))
   
  //      if (String.IsBlank(this.Anexo))
        
    
    }

   

   @isTest static void seleccionNumero()
   {
	    Test.startTest();
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
        controlador.Telefono = '921131233';
        controlador.seleccionNumero();
        controlador.Telefono = null;
        controlador.seleccionNumero();
        Test.stopTest();
   }

   @isTest static void btnLimpiar()
   {
    	Test.startTest();
 		CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
		controlador.btnLimpiar();
    	Test.stopTest();
   }

   @isTest static void insertaTarea()
   {
   		Test.startTest();
        Account cuenta = Factory.cuenta.buildInsert();               
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        CTR_CC_LlamadaAgente controlador = new CTR_CC_LlamadaAgente();
        controlador.IdCaso = caso.Id;
		controlador.insertaTarea(caso.Id);
        Test.stopTest();        
    }
   
}