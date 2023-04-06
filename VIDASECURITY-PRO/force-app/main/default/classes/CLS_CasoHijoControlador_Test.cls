@isTest
public class CLS_CasoHijoControlador_Test {
    
      @isTest static void RecuperarIDCasoPrincipal() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.RecuperarIDCasoPrincipal();
        Test.stopTest();
    }
    
    @isTest static void OpcionRequerimiento() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.OpcionRequerimiento();
        Test.stopTest();
    }
    
     @isTest static void CargaCaso() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.CargaCaso();
        Test.stopTest();
    }
    
    @isTest static void ObtieneParametrosCaso_Consulta() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.IdTipoRegistro = '012i0000000xndAAAQ';
     /*   Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); */
        Con.ID_CasoPrincipal = '5000H00000x7H4D';
        Con.ObtieneParametrosCaso();
        Test.stopTest();
    }
    
     @isTest static void ObtieneParametrosCaso_Reclamo() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.IdTipoRegistro = '012i0000000xqP8AAI';
       Con.ID_CasoPrincipal = '5000H00000x7H4D';
        Con.ObtieneParametrosCaso();
        Test.stopTest();
    }
    
     @isTest static void ObtieneParametrosCaso_Solicitud() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.IdTipoRegistro = '012i0000000xqP9AAI';
          Con.ID_CasoPrincipal = '5000H00000x7H4D';
     	Con.ObtieneParametrosCaso();
        Test.stopTest();
    }
    
    @isTest static void ActualizaFormatoTipoRegistro_Consulta() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
         Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Con.CASO_Principal = FactoryEscritorio.buildCaso('Consultas', cuenta); 
        
        Con.IdTipoRegistro = '012i0000000xndAAAQ';
          Con.ID_CasoPrincipal = '5000H00000x7H4D';
     	Con.ActualizaFormatoTipoRegistro();
        Test.stopTest();
    }
    
    
     @isTest static void ActualizaFormatoTipoRegistro_Reclamo() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.IdTipoRegistro = '012i0000000xqP8AAI';
          Con.ID_CasoPrincipal = '5000H00000x7H4D';
          Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Con.CASO_Principal = FactoryEscritorio.buildCaso('Reclamos', cuenta); 
       
     	Con.ActualizaFormatoTipoRegistro();
        Test.stopTest();
    }
    
    @isTest static void ActualizaFormatoTipoRegistro_Solicitud() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.IdTipoRegistro = '012i0000000xqP9AAI';
        Con.ID_CasoPrincipal = '5000H00000x7H4D';
        
     	Con.ActualizaFormatoTipoRegistro();
        Test.stopTest();
    }
    
     @isTest static void ActualizaFormatoTipoRegistro_Error() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        //Con.IdTipoRegistro = '012i0000000xqP8AAI';
          //Con.ID_CasoPrincipal = '5003D000002PmVA';
          Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Con.CASO_Principal = FactoryEscritorio.buildCaso('Reclamos', cuenta); 
       
     	Con.ActualizaFormatoTipoRegistro();
        Test.stopTest();
    }
    
    
     @isTest static void guardarCasos_PolizaNula() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
       	Con.guardarCasos();
        Test.stopTest();
    }
    
    @isTest static void guardarCasos_Poliza() {
        Test.startTest();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Solicitudes' LIMIT 1].Id;
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
		Con.Poliza = '1223';
        Con.valorTipoRequerimiento = 'Solicitudes';
        Con.CASO_Hijo = new Case();
        Con.CASO_Hijo.RecordTypeId = recordTypeId;
        Con.CASO_Hijo.Negocio__c = 'Seguros Individuales'; 
        Con.CASO_Hijo.Detalle_Solicitud__c = 'Cobranza';
        Con.CASO_Hijo.Detalle_Solicitud__c = 'Solicitud de suspensión de primas';
        Con.guardarCasos();
        Test.stopTest();
    }
    @isTest static void guardarCasos_Poliza1() {
        Test.startTest();
        Id recordTypeId = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Consultas' LIMIT 1].Id;
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
		Con.Poliza = '1223';
        Con.valorTipoRequerimiento = 'Consultas';
        Con.CASO_Hijo = new Case();
        Con.CASO_Hijo.Es_Protocolo__c = true;
        Con.CASO_Hijo.Protocolo_Envio_Informacion__c = '';
        Con.guardarCasos();
        Test.stopTest();
    }
    @isTest static void cancelarRequerimiento() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        Con.ID_CasoPrincipal = '5000H00000x7H4D';        
		Con.Poliza = '1223';
        Con.cancelarRequerimiento();
        Test.stopTest();
    }
    
    @isTest static void getListaTipoRegistro() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        list<SelectOption> lista = Con.getListaTipoRegistro();
        
        System.assert(lista.Size() > 0);  	
        
        Test.stopTest();
    }
    
    @isTest static void getListaPolizas() {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        list<SelectOption> lista = Con.getListaPolizas();
        
        System.assert(lista.Size() > 0);  	
        
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud01()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Declaración Ingresos Actualización';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud02()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Renuncia Garantía Estatal';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud03()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud cambio pago pensión';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud04()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud cuota mortuoria';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud05()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud de incorporación/ Renovación asignación familiar';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud06()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud de Extinción';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud07()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud garantía estatal';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud08()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud pensión sobrevivencia';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud09()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud periodo garantizado';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud10()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Sitio web';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud11()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud de Beneficios Club Viva Mejor';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud12()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud endoso';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud13()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'ED - Endoso Cambio Periodicidad de Pago';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleOperacion()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Disconformidad con créditos solicitados';
        Con.GetDetalleOperacion(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getConcepto()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Actualización de datos asegurado';
        Con.getConcepto(solicitud);
        Test.stopTest();
    }
   
   
        @isTest static void getDetalleSolicitud14()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud cambio CCAF';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    } 
    
     @isTest static void getDetalleSolicitud15()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud CCAF';        
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud16()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud de problema con Traspaso In';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
        
     @isTest static void getDetalleSolicitud17()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'ED - Solicitud de Rescate Patrimonial';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud18()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud eliminar empleados de planilla (PF-APV)';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud19()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Endosos';        
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud20()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud endoso';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud21()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud nuevo FUN';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
     @isTest static void getDetalleSolicitud22()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud préstamo';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }

    @isTest static void getDetalleSolicitud23()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud valores garantizados';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }

   @isTest static void getDetalleSolicitud24()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Solicitud Otros Endosos';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }

     @isTest static void getDetalleSolicitud25()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();        
        String solicitud = 'ED - Endoso Aumento de Prima en Exceso';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }


     @isTest static void getDetalleSolicitud26()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'ED - Endoso Agregar Coberturas';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }

 @isTest static void getDetalleSolicitud27()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'ED - Endoso Eliminar Coberturas';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }

    @isTest static void getDetalleSolicitud28()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'ED - Modificación de Tipo de Pago';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }
    
    @isTest static void getDetalleSolicitud29()
    {
        Test.startTest();
        CLS_CasoHijoControlador Con = new CLS_CasoHijoControlador();
        String solicitud = 'Siniestro Tradicional Vida COL';
        Con.GetDetalleSolicitud(solicitud);
        Test.stopTest();
    }





}