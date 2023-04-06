@istest
public class CLS_CasoConsulta_Test {

    // Cuentas
	static testMethod void ConsultaSiniestros() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
        CLS_CasoConsulta Con = new CLS_CasoConsulta();
        //Con.ID = '5000R000004eapT';
        Con.ConsultaSiniestros();
		Test.stopTest();
	}

	static testMethod void ConsultaRescates() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
        CLS_CasoConsulta Con = new CLS_CasoConsulta();
        //Con.ID = '5000R000004eapT';
		Con.ConsultaRescates();
		Test.stopTest();
	}
    
    static testMethod void SendEmailIncidente() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
        CLS_CasoConsulta Con = new CLS_CasoConsulta();
        //Con.ID = '5000R000004eapT';
		Con.SendEmailIncidente('Asunto', '15045517-0', '99999998-0', '123', 'mensaje');
		Test.stopTest();
	}
    
    
     static testMethod void CargaDatos_0() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
         try
         {
               CLS_CasoConsulta Con = new CLS_CasoConsulta();
         Con.UsoPruebas = '0';
        //Con.ID = '5000R000004eapT';
		Con.CargaDatos();
         }catch(Exception ex)
         {
             
         }
      
		Test.stopTest();
	}
    
    static testMethod void CargaDatos_1() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
        try
         {
               CLS_CasoConsulta Con = new CLS_CasoConsulta();
         Con.UsoPruebas = '1';
        //Con.ID = '5000R000004eapT';
		Con.CargaDatos();
         }catch(Exception ex)
         {
             
         }
		
		Test.stopTest();
	}
    
    static testMethod void CargaDatos_2() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
       try
         {
               CLS_CasoConsulta Con = new CLS_CasoConsulta();
         Con.UsoPruebas = '2';
        //Con.ID = '5000R000004eapT';
		Con.CargaDatos();
         }catch(Exception ex)
         {
             
         }
		Test.stopTest();
	}
    
    static testMethod void CargaDatos_3() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
       try
         {
               CLS_CasoConsulta Con = new CLS_CasoConsulta();
         Con.UsoPruebas = '3';
        //Con.ID = '5000R000004eapT';
		Con.CargaDatos();
         }catch(Exception ex)
         {
             
         }
		Test.stopTest();
	}
    
    static testMethod void CargaDatos_4() {
		//Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
        try
         {
               CLS_CasoConsulta Con = new CLS_CasoConsulta();
         Con.UsoPruebas = '4';
        //Con.ID = '5000R000004eapT';
		Con.CargaDatos();
         }catch(Exception ex)
         {
             
         }
		Test.stopTest();
	}
}