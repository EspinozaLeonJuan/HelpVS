/*******************************************************************************************
 *  NOMBRE                 : CLS_WSprodoncoOperTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 11/07/2018 - CARLOS ESPINOZA     		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_WSprodoncoOperTest {
static testMethod void WsprodoncoOper(){
     try{
         	  Test.startTest();
         	  Test.setMock(WebServiceMock.class, new CLS_WsprodoncoOperMock());
              CLS_WSprodoncoOper.WsProductoOncologicoOperSoap cnx = new CLS_WSprodoncoOper.WsProductoOncologicoOperSoap();
         	  
                String usuario = '';
                Integer rut = 1;
                String dv = '';
                String nombres = '';
                String apelPaterno = '';
                String apelMaterno = '';
                String mail = '';
                String fonoFijo = '';
                String fonoMovil = '';
                String direccion = '';
                String codComuna = '';
                String codCiudad = '';
                String codRegion = '';
                String fechaNac = '';
                CLS_WSprodoncoOper.DatosProspecto datProsp = new CLS_WSprodoncoOper.DatosProspecto();
                Integer propuesta = 1;
                Integer tipoFolio = 1;
                String codTipFormaPago = '';
                String codBanco = '';
                String codTarjeta = '';
                String numCuenta = '';
                String fecVencimiento = '';
                Integer idPolAsoc = 1;
                String codCobert = '';
                Double tasaCambio = 1;
                Double tasaPrima = 1;
                Double capitalAseg = 1;
                Double primaNeta = 1;
                Double impuestos = 1;
                Double primaNetaLocal = 1;
                Double impuestoLocal = 1;
                String codRamo = '';
                String codplan = '';
                String codProd = '';
                String revPlan = '';
                String codMoneda = '';
                Double porcRiesgo = 1;
                String origen = '';
                String codSucursal = '';
                Integer codCanal = 1;
                String estadoPropuesta = '';
                String codPeriodoPago = '';
                String idExterno = '';
                String idCampania = '';
                String codInter = '';
                Double participacion = 1;
                String numGrabacion = '';
                String codRelacion = '';
                
                String res1 = cnx.RegistraPersona(usuario,rut,dv, nombres, apelPaterno, apelMaterno, mail, fonoFijo, fonoMovil, direccion, codComuna, codCiudad, codRegion, fechaNac);
                String res2 = cnx.RegistraDatosProspecto(usuario, datProsp);
                String res3 = cnx.ActualizaDatosPropuesta(usuario, datProsp);
                String res4 = cnx.RegistraFormaPago(usuario, propuesta, tipoFolio, codTipFormaPago, codBanco, codTarjeta, numCuenta, fecVencimiento, idPolAsoc);
                String res5 = cnx.RegistraCoberturaAsegurado(usuario, propuesta, tipoFolio,rut, codCobert, tasaCambio, tasaPrima, capitalAseg, primaNeta, impuestos, primaNetaLocal, impuestoLocal); 
                String res6 = cnx.RegistrarContratantePropuesta(usuario, propuesta, tipoFolio, rut);
                String res7 = cnx.RegistraPropuesta(usuario, propuesta, tipoFolio, codRamo, codplan, codProd, revPlan, codMoneda, porcRiesgo, origen, codSucursal, codCanal, estadoPropuesta, codPeriodoPago, idExterno, idCampania);
                String res8 = cnx.RegistraIntermediario(usuario, propuesta, tipoFolio, codInter, participacion);
                CLS_WSprodoncoOper.DatosProspecto res9 = new CLS_WSprodoncoOper.DatosProspecto();
                res9 = cnx.ObtenerDatosProspecto(usuario); 
                String res10 = cnx.RegistraNumeroGrabacion(usuario, propuesta, tipoFolio, numGrabacion);
                String res11 = cnx.RegistrarAseguradoPropuesta(usuario, propuesta, tipoFolio, rut, codRelacion);
                String res12 = cnx.RegistrarBeneficiario(usuario, propuesta, tipoFolio, rut, codRelacion, participacion);
         	  
             
             Test.stopTest();
         
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST PROD ONCO EQUIFAX:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
}