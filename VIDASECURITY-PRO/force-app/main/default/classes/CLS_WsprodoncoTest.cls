/*******************************************************************************************
 *  NOMBRE                 : CLS_WsprodoncoTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 11/07/2018 - CARLOS ESPINOZA     		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class CLS_WsprodoncoTest {
static testMethod void Wsprodonco(){
     try{
         	  Test.startTest();
         	  Test.setMock(WebServiceMock.class, new CLS_WsprodoncoMock());
         	  CLS_WSprodonco.WsProductoOncologicoSoap cnx = new CLS_WSprodonco.WsProductoOncologicoSoap();
         	  String usuario = '19';
              String ramo = 'test';
         	  String prod = '';
              String plan = '';
              String revPlan = '';
              Integer tipoFolio = 1;
              String tipoCliente = '';
         	  String tipoDeAsegurado = '';
             String codComuna = '';
             String codRegion = '';
             String relacionConTitular = '';
             Integer edad = 1;
             Integer fecNacimiento = 1;
             Integer rut = 1;
             String dv = '';
             String codCobert = '';
             String codRamo = '';
             String codPlan = '';
             String codRevPlan = '';
             String codProd = '';
             String codParentesco = '';
             String codCobertura = '';
             Integer fechaNacimiento = 1;
             String esNuevo = '';
             Double capital = 1;
         	  
              String res1 = cnx.FncValidaEsPreImpreso( usuario, ramo, prod, plan, revPlan);
         	  
         	  CLS_WSprodonco.ArrayOfProductoOncologico res2 = new CLS_WSprodonco.ArrayOfProductoOncologico();
              res2 = cnx.GetUltimoProducto( usuario,  tipoFolio, tipoCliente);
         
         	  CLS_WSprodonco.ArrayOfComuna res3 = new CLS_WSprodonco.ArrayOfComuna();
              res3 = cnx.ObtenerListadoComuna(usuario, codComuna);
                  
			  CLS_WSprodonco.ArrayOfCiudad res4 = new CLS_WSprodonco.ArrayOfCiudad(); 
              res4 = cnx.ObtenerListadoCiudad(usuario, codRegion);
         
			  CLS_WSprodonco.Tarificacion res5 = new CLS_WSprodonco.Tarificacion(); 
              res5 = cnx.GetTarificacionOncoEdad(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular,edad);
         
              res5 = cnx.GetTarificacionOncoFechaNacimiento(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular,fecNacimiento);

         	  res5 = cnx.GetTarificacionEdad(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular,esNuevo,edad, capital,codCobertura);

              res5 = cnx.GetTarificacionCoberturaFechaNac(usuario,codRamo,codPlan,codRevPlan,codProd,fecNacimiento, capital,codCobert);
    
         	  CLS_WSprodonco.ArrayOfPoliza res6 = new CLS_WSprodonco.ArrayOfPoliza();
              res6 = cnx.GetPolizasPacPat(usuario,rut,dv);
 
			  CLS_WSprodonco.ArrayOfTarjeta res7 = new CLS_WSprodonco.ArrayOfTarjeta(); 
         	  res7 = cnx.ObtenerListadoTarjeta(usuario);
         
			  CLS_WSprodonco.ArrayOfRegion res8 = new CLS_WSprodonco.ArrayOfRegion();
              res8 = cnx.ObtenerListadoRegion(usuario);
 
			  CLS_WSprodonco.Capital res9 = new CLS_WSprodonco.Capital();
         	  res9 = cnx.PrcObtenerCapital(usuario,ramo,prod,plan,revPlan,codCobert);
         
			  CLS_WSprodonco.CapitalUFPS res10 = new CLS_WSprodonco.CapitalUFPS();
              res10 = cnx.PrcObtenerCapitalParentesco(usuario,codRamo,codPlan,codRevPlan,codProd,tipoDeAsegurado,codParentesco);
         
			  CLS_WSprodonco.ArrayOfProductoOncologico res11 = new CLS_WSprodonco.ArrayOfProductoOncologico();
              res11 = cnx.GetUltimoProducto(usuario,tipoFolio,tipoCliente);
         
			  CLS_WSprodonco.ArrayOfPeriodicidadPago res12 = new CLS_WSprodonco.ArrayOfPeriodicidadPago();
              res12 = cnx.ObtenerListaPeriodicidadPago(usuario);
         
			  CLS_WSprodonco.ArrayOfFormaPago res13 = new CLS_WSprodonco.ArrayOfFormaPago();
              res13 = cnx.ObtenerListadoFormaPago(usuario,ramo,prod,plan,revPlan);
            
			 String res14 = cnx.ValidaAseguradoOnco(usuario,ramo,prod,plan,revPlan,codCobert,rut,fechaNacimiento);
         
         	 Integer res15 = cnx.ValidaCliente(usuario,rut,dv);
			 String res16 = cnx.FncValidaEsPreImpreso(usuario,ramo,prod,plan,revPlan);
			 
			 CLS_WSprodonco.UsuarioValido res17 = new CLS_WSprodonco.UsuarioValido();
             res17 = cnx.ValidacionUsuarioPorFecNac(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular,fechaNacimiento);
         
			 CLS_WSprodonco.ArrayOfSucursal res18 = new CLS_WSprodonco.ArrayOfSucursal();
             res18 = cnx.ObtenerListadoSucursales(usuario);
         
			 CLS_WSprodonco.ArrayOfCobertura res19 = new CLS_WSprodonco.ArrayOfCobertura();
             res19 = cnx.GetCodigoCobertura(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular);
         
			 CLS_WSprodonco.ArrayOfRelacionFamiliar res20 = new CLS_WSprodonco.ArrayOfRelacionFamiliar();
             res20 = cnx.ObtenerRelacionFamiliar(usuario,ramo,prod,plan,revPlan);
         
			 CLS_WSprodonco.UsuarioValido res21 = new CLS_WSprodonco.UsuarioValido();
             res21 = cnx.ValidacionUsuarioPorEdad(usuario,ramo,prod,plan,revPlan,tipoDeAsegurado,relacionConTitular,edad);
         	
			 CLS_WSprodonco.ArrayOfBanco res22 = new CLS_WSprodonco.ArrayOfBanco();
             res22 = cnx.ObtenerListadoBancos(usuario);
         
			 CLS_WSprodonco.Folio res23 = new CLS_WSprodonco.Folio();
             res23 = cnx.ObtenerFolio(usuario,ramo,prod,plan,revPlan);
         
			 CLS_WSprodonco.ArrayOfIntermediario res24 = new CLS_WSprodonco.ArrayOfIntermediario();
             res24 = cnx.GetIntermediario(usuario,rut);
			 
             Test.stopTest();
         
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST PROD ONCO EQUIFAX:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
}