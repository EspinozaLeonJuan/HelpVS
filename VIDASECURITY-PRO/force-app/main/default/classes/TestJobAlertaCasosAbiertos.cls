@isTest(SeeAllData=true)
public class TestJobAlertaCasosAbiertos{  
    
    public static testmethod void prueba(){
        Test.startTest();
        JobAlertaCasosAbiertos j = new JobAlertaCasosAbiertos();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Prueba Job Alerta Casos Abiertos', sch, j); 
        Test.stopTest(); 
    }
}