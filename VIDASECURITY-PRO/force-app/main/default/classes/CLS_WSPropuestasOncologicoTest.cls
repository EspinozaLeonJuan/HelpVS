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
public class CLS_WSPropuestasOncologicoTest {
static testMethod void WsPropuestaOncologico(){
     try{
         	  Test.startTest();
         	  Test.setMock(WebServiceMock.class, new CLS_WSprodoncoMock());
         	  
              Campaign cmp = new Campaign();
              cmp.Type = 'Salud Protegida';
              cmp.Name = 'Cmp';
              insert cmp;

              CLS_WSPropuestasOncologico.DatosProspecto datProsp= new CLS_WSPropuestasOncologico.DatosProspecto ();
           
         	  //Forma de Pago
          	  datProsp.FormPago= new CLS_WSPropuestasOncologico.FormaPago();
         	  datProsp.FormPago.CodBanco='001';
         	  datProsp.FormPago.CodTarjeta='001';
              datProsp.FormPago.FechaVencimiento=Date.newInstance(2010, 07, 15);
              datProsp.FormPago.IdPolizaAsoc=1;
              datProsp.FormPago.NumeroCuenta='12345678';
     		  datProsp.FormPago.Propuesta=123456;
         	  datProsp.FormPago.TipoFolio=20;
         	  datProsp.FormPago.TipoFormaPago='PAT';
          	  
         	  //Asegurado 
         	  CLS_WSPropuestasOncologico.Asegurado asegurado = new CLS_WSPropuestasOncologico.Asegurado();
         	  asegurado.CodRelacion='001';
         	  asegurado.Propuesta=123456;
              asegurado.Rut=12345678;
              asegurado.TipoFolio=20;
         	  
         	      	  
         	  List<CLS_WSPropuestasOncologico.ArrAsegurado> arr = new List<CLS_WSPropuestasOncologico.ArrAsegurado>();
         	  List<CLS_WSPropuestasOncologico.Asegurado> ListaAsegurado= new List<CLS_WSPropuestasOncologico.Asegurado>();
         	  CLS_WSPropuestasOncologico.ArrAsegurado arrAsegurado= new CLS_WSPropuestasOncologico.ArrAsegurado();
         	  ListaAsegurado.add(asegurado);
              arrAsegurado.Asegurado=ListaAsegurado;
         	  arr.add(arrAsegurado);
           	  datProsp.LsAsegurado=arr;
         
         	  //Beneficiario
              CLS_WSPropuestasOncologico.Beneficiario beneficiario = new CLS_WSPropuestasOncologico.Beneficiario();
         	  beneficiario.CodRelacion='001';
         	  beneficiario.Propuesta=123456;
              beneficiario.Rut=12345678;
              beneficiario.TipoFolio=20;
         	  beneficiario.Participacion=100;
         
       		  List<CLS_WSPropuestasOncologico.ArrBeneficiario> arrbenifiario = new List<CLS_WSPropuestasOncologico.ArrBeneficiario>();
         	  List<CLS_WSPropuestasOncologico.Beneficiario> ListaBeneficiario= new List<CLS_WSPropuestasOncologico.Beneficiario>();
         	  CLS_WSPropuestasOncologico.ArrBeneficiario arrAseguradoBen= new CLS_WSPropuestasOncologico.ArrBeneficiario();
         	  ListaBeneficiario.add(beneficiario);
              arrAseguradoBen.Beneficiario=ListaBeneficiario;
         	  arrbenifiario.add(arrAseguradoBen);
           	  datProsp.LsBeneficiario=arrbenifiario;
         
                    	  
         
 			  datProsp.Propuesta = new CLS_WSPropuestasOncologico.Propuesta(); 
         	  datProsp.Propuesta.CodCanal=1;
         	  
         	datProsp.Propuesta.NumPropuesta	=123456;
            datProsp.Propuesta.TipoFolio	=20;
            datProsp.Propuesta.CodRamo	='1';
            datProsp.Propuesta.CodPlan	='01';
            datProsp.Propuesta.CodProd	='1';
            datProsp.Propuesta.RevPlan	='1';
            datProsp.Propuesta.CodMoneda	='1';
            datProsp.Propuesta.PorcRiesgo	=1;
            datProsp.Propuesta.Usuario	='1';
            datProsp.Propuesta.Origen	='1';
            datProsp.Propuesta.CodSucursal	='1';
            datProsp.Propuesta.CodCanal	=1;
            datProsp.Propuesta.EstadoPropuesta	='1';
            datProsp.Propuesta.CodPeriodoPago	='1';
            datProsp.Propuesta.IdExterno	='1';
            datProsp.Propuesta.IdCampania	= cmp.Id;
         
         //Persona
         datProsp.LsPersona = new List<CLS_WSPropuestasOncologico.ArrPersona>();
         
         CLS_WSPropuestasOncologico.Persona persona = new CLS_WSPropuestasOncologico.Persona();
   
        persona.Rut	=12345678;
        persona.Dv	='9';
        persona.Nombres	='Nombre';
        persona.ApellidoPaterno	='ApellidoPaterno';
        persona.ApellidoMaterno	='ApellidoMaterno';
        persona.Mail	='mail@mail.cl';
        persona.TelefonoFijo	='TelefonoFijo';
        persona.TelefonoMovil	='TelefonoMovil';
        persona.Direccion	='Direccion';
        persona.CodComuna	='01';
        persona.CodCiudad	='01';
        persona.CodRegion	='01';
        persona.FechaNacimiento	=Date.newInstance(2010, 07, 15);

         
         
         List<CLS_WSPropuestasOncologico.ArrPersona> arrPersona = new List<CLS_WSPropuestasOncologico.ArrPersona>();
         List<CLS_WSPropuestasOncologico.Persona> ListaPersona= new List<CLS_WSPropuestasOncologico.Persona>();
         CLS_WSPropuestasOncologico.ArrPersona arrclasePersona= new CLS_WSPropuestasOncologico.ArrPersona();
         ListaPersona.add(persona);
         arrclasePersona.Persona=ListaPersona;
         arrPersona.add(arrclasePersona);
         datProsp.LsPersona=arrPersona;
         
         
         //Cobertura
		 datProsp.LsCobertura = new List<CLS_WSPropuestasOncologico.ArrCobertura>();  
         
		 CLS_WSPropuestasOncologico.Cobertura cobertura = new CLS_WSPropuestasOncologico.Cobertura();
   
        cobertura.TipoFolio=20;
        cobertura.Propuesta=123456;
        cobertura.Rut=12345678;
        cobertura.CodCobert='';
       cobertura.TasaCambio=660;
        cobertura.TasaPrima=1234;
        cobertura.CapitalAsegurado=1234;
        cobertura.PrimaNeta=1234;
        cobertura.Impuestos=1234;
        cobertura.PrimaNetaLocal=1234;
        cobertura.ImpuestosLocal=1234;

      

         
         
         List<CLS_WSPropuestasOncologico.ArrCobertura> arrCobertura = new List<CLS_WSPropuestasOncologico.ArrCobertura>();
         List<CLS_WSPropuestasOncologico.Cobertura> ListaCobertura= new List<CLS_WSPropuestasOncologico.Cobertura>();
         CLS_WSPropuestasOncologico.ArrCobertura arrclaseCobertura= new CLS_WSPropuestasOncologico.ArrCobertura();
         ListaCobertura.add(cobertura);
         arrclaseCobertura.Cobertura=ListaCobertura;
         arrCobertura.add(arrclaseCobertura);
         datProsp.LsCobertura=arrCobertura;         
         
         
         //Contratante
	     datProsp.LsContratante= new List<CLS_WSPropuestasOncologico.ArrContratante>();   		
         CLS_WSPropuestasOncologico.ContratantePropuesta contratante = new CLS_WSPropuestasOncologico.ContratantePropuesta();
   
        contratante.TipoFolio=20;
        contratante.Propuesta=123456;
        contratante.Rut=12345678;
       

      

         
         
         List<CLS_WSPropuestasOncologico.ArrContratante> arrContratante = new List<CLS_WSPropuestasOncologico.ArrContratante>();
         List<CLS_WSPropuestasOncologico.ContratantePropuesta> ListaContratante= new List<CLS_WSPropuestasOncologico.ContratantePropuesta>();
         CLS_WSPropuestasOncologico.ArrContratante arrclaseContratante= new CLS_WSPropuestasOncologico.ArrContratante();
         ListaContratante.add(contratante);
         arrclaseContratante.ContratantePropuesta=ListaContratante;
         arrContratante.add(arrclaseContratante);
         datProsp.LsContratante=arrContratante;   
         
         
         
         //Intermediario
         datProsp.LsIntermediario= new List<CLS_WSPropuestasOncologico.Intermediario>();  
         
         
         
         CLS_WSPropuestasOncologico.RegistraDatosProspecto('Gpinto', datProsp);
         Test.stopTest();
         }catch(Exception ex){
            Test.stopTest();
            system.debug('@@@@ ERROR METODO TEST CAMPAÑA ACTIVA:');
            system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
}
}