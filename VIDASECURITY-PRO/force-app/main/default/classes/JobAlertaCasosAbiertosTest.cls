@isTest
public class JobAlertaCasosAbiertosTest{  
    
    public static testmethod void prueba(){
        Test.startTest();
        
        Factory.crearAccountAnonimo();
        
        User uEjecutiva = Factory.buildUser();
        uEjecutiva.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Ejecutiva Atención al Cliente' LIMIT 1].Id;
        insert uEjecutiva;
        
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        
        List<Case> casos = new List<Case>();
        
        // 21 casos sin responder creados antes de hoy, para pasar el umbral de casos (revisar umbral en el Job y ajustar si corresponde)
        for(Integer i = 0; i < 21; i++){
            Case caso = Factory.buildCasoSF('Consultas', cuenta);
            caso.OwnerId = uEjecutiva.Id;
            caso.Entrega_Respuesta__c = false;
            caso.CreatedDate = Date.today() - 2;
            casos.add(caso);
        }
        
        insert casos;
        
        JobAlertaCasosAbiertos j = new JobAlertaCasosAbiertos();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Prueba Job Alerta Casos Abiertos', sch, j); 
        Test.stopTest(); 
    }
}