/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_FlujoNotificacion
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 *  2.0     - 2019/02/06 - J.ESPINOZA       - Actualización Clase
 * *****************************************************************************************/
@istest
public class TEST_CTR_FlujoNotificacion {
    
    @istest
    public static void cargaCaso_a()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCaso_b()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.ESTADO = '1';
        Con.cargaCaso();
        Test.stopTest();
    }
    
    @istest
    public static void cargaCaso_c()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.ESTADO = '2';
        Con.cargaCaso();
        Test.stopTest();
    }
    
   
    
    @istest
    public static void cargaCaso_d()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.ESTADO = '3';
        Con.cargaCaso();
        Test.stopTest();
    }
          
    @istest
    public static void guardarCasoCerrado_a()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '1';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_b()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '2';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_c()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }
    
    @istest
    public static void guardarCasoCerrado_d()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_NOTIFI = true;
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }

	@istest
    public static void guardarCasoCerrado_e()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_ASUNTO = 'asunto del caso';
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }    
    
    @istest
    public static void guardarCasoCerrado_f()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.C_COMENT = 'comentario del caso';
        Con.ESTADO = '3';
        Con.guardarCasoCerrado();
        Test.stopTest();
    }   
    
    @istest
    public static void cancelarCerrarCaso()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.cancelarCerrarCaso();
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_a()
    {
        Test.startTest();
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'INGRESADO');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_b()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = '69'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'FINALIZADO');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_c()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = '69'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'REVISION');
        Test.stopTest();
    }
    
    
    @istest
    public static void CambioEstado_EscritorioDigital_d()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = 'NO_REQED'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'REVISION');
        Test.stopTest();
    }
    
    @istest
    public static void CambioEstado_EscritorioDigital_e()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.IdRequerimiento = 'NO_REQED'; 
        String ID = '5000H00000x7H4D';
        Con.CambioEstado_EscritorioDigital(ID, 'FINALIZADO');
        Test.stopTest();
    }
    
    @istest
    public static void VolverCaso()
    {
        Test.startTest();       
         
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_ID = '5000H00000x7H4D';
        Con.USUA_ID = '005i00000098HSL';
       
        Con.volverCaso();
        Test.stopTest();
    }
  /*    @istest 
  public static void CargaRequerimientoED_a()
    {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CargaRequerimieoED();
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoED_b()
    {
        Test.startTest();        
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CASO_PRI.Id_Requerimiento_EscritorioDigital__c = '69';       
        Con.CargaRequerimientoED();
        Test.stopTest();
    }
    
    @istest
    public static void CargaRequerimientoED_c()
    {
        Test.startTest();       
        Account cuenta = Factory.cuenta.buildInsert();        
        CTR_FlujoNotificacion Con = new CTR_FlujoNotificacion();
        Con.CASO_PRI = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.CASO_PRI.Id_Requerimiento_EscritorioDigital__c = null;
        Con.CASO_PRI.Detalle_Solicitud__c  = 'Solicitud Cuota Mortuoria';
        Con.CargaRequerimientoED();
        Test.stopTest();
    }*/


}