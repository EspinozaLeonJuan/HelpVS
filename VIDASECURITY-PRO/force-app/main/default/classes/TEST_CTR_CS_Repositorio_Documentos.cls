@istest
public with sharing class TEST_CTR_CS_Repositorio_Documentos {
    
    @isTest static void cargaCaso_Test_01()
    {
        Test.startTest();
        Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Contact contacto = Factory.buildContact(cuenta);
		insert contacto;
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto Vida'; 
		insert caso;
        ApexPages.StandardController standard = new ApexPages.StandardController(caso);
        CTR_CS_Repositorio_Documentos repo = new CTR_CS_Repositorio_Documentos(standard);
        repo.guardarEstado();
        repo.editarEstadoBloque();
        repo.cancelarEstadoBloque();
        repo.guardarCambios();
        
        Test.stopTest();
    }
}