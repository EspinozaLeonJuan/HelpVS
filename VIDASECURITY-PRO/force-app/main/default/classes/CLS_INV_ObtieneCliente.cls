public class CLS_INV_ObtieneCliente {
	@InvocableMethod 
    public static void ActualizaDatos (List<String> Ids)
    {
        try
        {
            Participantes_de_Campa_a__c participante = [SELECT Id, P_liza_1_Recuperacion__c, Nombres_del_Cliente__c, Cuenta__c, Poliza__c   FROM Participantes_de_Campa_a__c  WHERE Id =: Ids[0]];
                
            if (participante != null)
            {
                String nombre = participante.Nombres_del_Cliente__c;                                
                String numeroPoliza = participante.P_liza_1_Recuperacion__c.split(' ')[0];
                
                List<Account> cuentas = [SELECT Id FROM Account WHERE Name =: nombre]; 
                List<Poliza__c> polizas = [SELECT Id FROM Poliza__c WHERE  Name =: numeroPoliza]; 
                
                system.debug('@@@@ ID -->'+Ids[0]);
                system.debug('@@@@ nombre -->'+nombre);
                system.debug('@@@@ numeroPoliza -->'+ numeroPoliza);
                
                system.debug('@@@@ cuentas -->'+ cuentas.size());
                if (cuentas.size() > 0)
                {
                    Account cuenta = cuentas[0];
                    participante.Cuenta__c = cuenta.Id;
                    
                    system.debug('@@@@ cuenta -->'+ cuenta);
                }
     			
                system.debug('@@@@ polizas -->'+ polizas.size());
                if (polizas.size() > 0)
                {
                    Poliza__c poliza = polizas[0];
                    participante.Poliza__c = poliza.Id;
                    
                    system.debug('@@@@ poliza -->'+ poliza);                
                }
                
                update participante;
            }
        }
        catch(Exception ex)
        {
           
   			system.debug('@@@@ Exception Line -->'+ ex.getLineNumber());            
            system.debug('@@@@ Exception Causa -->'+ ex.getCause());            
            system.debug('@@@@ Exception Mensaje -->'+ ex.getMessage());            
        }
        
    }
}