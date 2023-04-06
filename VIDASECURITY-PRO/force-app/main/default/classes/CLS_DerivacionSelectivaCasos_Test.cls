@istest
public class CLS_DerivacionSelectivaCasos_Test {

    @istest
    public static void constructor()
    {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = '36';
        ApexPages.StandardSetController stdHR;
        
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Test.stopTest();
    }
    
    @istest
    public static void cargaCasosHijosDerivar_a()
    { 
        Test.startTest();
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = casos;
                
        Con.cargaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCasosHijosDerivar_b()
    { 
        Test.startTest();
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = new List<Case>();
                
        Con.cargaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCasosHijosDerivar_c()
    { 
        Test.startTest();
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
                
        Con.cargaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void evaluaCasosHijosDerivar_a()
    { 
        Test.startTest();
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = casos;
                
        Con.evaluaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void derivarCasoHijoSolicitudes()
    {
        Test.startTest();
        ApexPages.StandardSetController stdHR;
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        
        Con.LST_CHIJOS = FactoryEscritorio.CasosHijoSolicitudes();
            //='500f0000007Ftc1';
        Con.derivarCasoHijo();
        Test.stopTest();
    }
    
    @istest
    public static void derivarCasoHijoConsultas()
    {
        Test.startTest();
        ApexPages.StandardSetController stdHR;
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = FactoryEscritorio.CasosHijoConsultas();
            //='500f0000007Ftc1';
        Con.derivarCasoHijo();
        Test.stopTest();
    }
    
    @istest
    public static void derivarCasoHijoReclamos()
    {
        Test.startTest();
        ApexPages.StandardSetController stdHR;
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = FactoryEscritorio.CasosHijoReclamos();
            //='500f0000007Ftc1';
        Con.derivarCasoHijo();
        Test.stopTest();
    }
    
        
    @istest static void CambioEstado_EscritorioDigital()
    {
        Test.startTest();
        ApexPages.StandardSetController stdHR;
        CLS_DerivacionSelectivaCasos Con = new CLS_DerivacionSelectivaCasos(stdHR);
        String ID = '500f0000007Ex6c';
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso = FactoryEscritorio.buildCasoED2('Solicitudes',cuenta);
        
        Con.CambioEstado_EscritorioDigital(caso.Id);
        Test.stopTest();
    }
    
    
}