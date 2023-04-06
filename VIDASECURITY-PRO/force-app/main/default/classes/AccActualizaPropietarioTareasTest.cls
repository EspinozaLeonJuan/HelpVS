/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccActualizaPropietarioTareasTest {

    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccActualizaPropietarioTareasTest.testExecute')){return;}
        /**********************************************************************************/
		UserGeneration usuarioAdmin1 = (UserGeneration)Fabricate.usuarioAdmin().adminNombre('nombre1','apellido1','alia1','12321').save();
        UserGeneration usuarioAdmin2 = (UserGeneration)Fabricate.usuarioAdmin().adminNombre('nombre2','apellido2','alia2','32123').save();
        
        Id idOwner1 = [SELECT Id FROM User WHERE FirstName =:'nombre1' limit 1].Id;
        Id idOwner2 = [SELECT Id FROM User WHERE FirstName =:'nombre2' limit 1].Id;

        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .generico('name1', 'lastname1', '16355278', '7', idOwner2 )
            .set('Omitir_Validaciones_AMAC__c',true)
            .save();
        Id idCuenta = (Id)cuenta.get().get('Id');
        TaskFabricate tarea = Fabricate.tarea();
		tarea.set('WhatId', idCuenta);
        tarea.set('ActivityDate', Date.today() );
        tarea.set('OwnerId', idOwner1 );
		tarea.save();
        cuenta.set('OwnerId', idOwner2);
        cuenta.save();
        Integer intGetJobs = Limits.getQueueableJobs();
        Test.startTest();
        
        Task oTask = (Task)tarea.get();
        oTask.OwnerId = idOwner1;
        oTask.WhatId = idCuenta;
        update oTask;
        List<Task> lTareas = new List<Task>{[SELECT Id, OwnerId, WhatId, AccountId, Account.OwnerId FROM Task]};
        
        AccActualizaPropietarioTareas.execute( lTareas );
        Test.stopTest();
    }
}