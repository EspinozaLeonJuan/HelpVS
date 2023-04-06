@istest
public class EscritorioDigital_Deriva_Controller_Test {
	@isTest static void CargaCaso() {
        Test.startTest();
        EscritorioDigital_Deriva_Controller Con = new EscritorioDigital_Deriva_Controller();
        
        Con.CargaCaso();
        Test.StopTest();
    } 
    
    @isTest static void ToCase() {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        EscritorioDigital_Deriva_Controller Con = new EscritorioDigital_Deriva_Controller();    
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        Test.stopTest();
    } 
    
    @isTest static void ToEscritorioDigital() {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        EscritorioDigital_Deriva_Controller Con = new EscritorioDigital_Deriva_Controller();    
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToEscritorioDigital();
        Test.stopTest();
    } 
    
    @isTest static void ToDerivar() {
        Test.startTest();
        //Factory.crearAccountAnonimo();         
        //Account cuenta = Factory.cuenta.buildInsert();                
        EscritorioDigital_Deriva_Controller Con = new EscritorioDigital_Deriva_Controller();    
       // Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);  
        Con.IDCASO = '5000H00000x7H2W';
        Con.ToDerivar();
        Test.stopTest();
    } 
}