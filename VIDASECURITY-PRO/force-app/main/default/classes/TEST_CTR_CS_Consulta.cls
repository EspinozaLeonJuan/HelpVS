/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-15-2021
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_CTR_CS_Consulta {
  
    @IsTest
    private static void callToVidaSecurity_Test_01()
    {
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = cuenta.Id;
        p.Name = '234500';
        insert p;
       
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        caso.CASO_N_Poliza__c = p.Id;
        insert caso;
        Test.startTest();
        CTR_CS_Consulta controlador = new CTR_CS_Consulta();
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('tipo', 'R');
        controlador.callToVidaSecurity();
        Test.stopTest();
    }

    @IsTest
    private static void callToVidaSecurity_Test_02()
    {
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = cuenta.Id;
        p.Name = '234500';
        insert p;
       
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        caso.CASO_N_Poliza__c = p.Id;
        insert caso;
        Test.startTest();
        CTR_CS_Consulta controlador = new CTR_CS_Consulta();
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        ApexPages.currentPage().getParameters().put('tipo', 'S');
        controlador.callToVidaSecurity();
        Test.stopTest();
    }

    @IsTest
    private static void SendEmailIncidente() {
		Test.startTest();
        CTR_CS_Consulta controlador = new CTR_CS_Consulta();
        controlador.SendEmailIncidente('Asunto', '15045517-0', '99999998-0', '123', 'mensaje');
		Test.stopTest();
	}
}