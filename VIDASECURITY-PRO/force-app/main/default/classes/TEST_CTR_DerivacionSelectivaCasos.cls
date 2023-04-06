/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_DerivacionSelectivaCasos
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
@istest
public class TEST_CTR_DerivacionSelectivaCasos {
   
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
        
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
        Test.stopTest();
    }
    
    @istest
    public static void cargaCasosHijosDerivar_a()
    { 
        Test.startTest();
        List<Case> casos = FactoryEscritorio.CasosHijoSolicitudes();
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
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
        
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
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
        
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
                
        Con.cargaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void evaluaCasosHijosDerivar_a()
    { 
        Test.startTest();
        Account cuenta = Factory.crearAccountAnonimo();
        Case caso1 = Factory.buildCasoSF('Solicitudes',cuenta);
        insert caso1;
        Case caso2 = Factory.buildCasoSF('Solicitudes',cuenta);
        insert caso2;
        List<Case> casos = new List<Case>();
        casos.add(caso1);
        casos.add(caso2);
        ApexPages.StandardSetController stdHR ;//= new ApexPages.StandardSetController();
        
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = casos;
                
        Con.evaluaCasosHijosDerivar();
        Test.stopTest();
    }
    
    @istest
    public static void derivarCasoHijoSolicitudes()
    {
        Test.startTest();
        ApexPages.StandardSetController stdHR;
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
        
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
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
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
        CTR_DerivacionSelectivaCasos Con = new CTR_DerivacionSelectivaCasos(stdHR);
        Con.LST_CHIJOS = FactoryEscritorio.CasosHijoReclamos();
            //='500f0000007Ftc1';
        Con.derivarCasoHijo();
        Test.stopTest();
    }
}