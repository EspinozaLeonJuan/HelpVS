@IsTest(SeeAllData=true) 
public with sharing class TEST_CTR_CC_RealizarLlamada {
    public TEST_CTR_CC_RealizarLlamada() {

    }
    
     @isTest static void postCall()
    {
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('RUT', '15045517-0');
        ApexPages.currentPage().getParameters().put('Anexo', '2472');
        ApexPages.currentPage().getParameters().put('NumeroLlamada', '922133313');
        ApexPages.currentPage().getParameters().put('Usuario', 'juespinoza');
        ApexPages.currentPage().getParameters().put('Id', '23213123');
        ApexPages.currentPage().getParameters().put('IdTarea', '3213213213');
        ApexPages.currentPage().getParameters().put('CoL', '');
        ApexPages.currentPage().getParameters().put('CoLId', '');
        CTR_CC_RealizarLlamada controlador = new CTR_CC_RealizarLlamada();
        controlador.postCall();
        
        Test.stopTest();
    }
    
     @isTest static void checkPostCall()
    {
        Test.startTest();
        
        CTR_CC_RealizarLlamada controlador = new CTR_CC_RealizarLlamada();
        
        
        controlador.Col = 'C';
        controlador.checkPostCall();

        controlador.Col = 'L';
        controlador.checkPostCall();
        
        Account cuenta = Factory.cuenta.buildInsert();               
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        insert caso;
        
        Task tarea = new Task();
        tarea.Subject = 'Llamada';
        tarea.WhatId = cuenta.Id;
        insert tarea;
        
        controlador.call = new PAR_EXT_WS_RealizaLlamada();
        controlador.call.Rut =  '15045517-0';
        controlador.call.Desde = '2472';
        controlador.call.Hasta = '922133313';
        controlador.call.Usuario =  'juespinoza';
        controlador.call.Id = '3213213213';
        controlador.IdTarea = tarea.Id;
        controlador.CoL = 'C';
        controlador.CoLId = '';
        
        controlador.checkPostCall();
        Test.stopTest();
    }
    
    
}