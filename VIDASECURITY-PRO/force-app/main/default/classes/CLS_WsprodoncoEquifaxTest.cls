/*******************************************************************************************
 *  NOMBRE                 : CLS_WSPropuestasOncologicoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 11/07/2018 - G.PINTO     		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_WsprodoncoEquifaxTest {
static testMethod void WsprodoncoEquifax(){
     try{
         	  Test.startTest();
         	  Test.setMock(WebServiceMock.class, new CLS_WsprodoncoEquifaxMockImpl());
         	  CLS_WSprodoncoEquifax.Equifax2Soap cnx = new CLS_WSprodoncoEquifax.Equifax2Soap();
              wsAxonaxisCl.DatosPersona res1 = new wsAxonaxisCl.DatosPersona();  
              String rutPersona = '19';
              String usuario = 'test';
              res1 = cnx.ConsultaPersona(rutPersona,usuario,'PREDIGITADORES');
            
              Test.stopTest();
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST PROD ONCO EQUIFAX:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
}