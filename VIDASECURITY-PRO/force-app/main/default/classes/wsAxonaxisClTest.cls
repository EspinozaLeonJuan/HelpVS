/*******************************************************************************************
 *  NOMBRE                 : wsAxonaxisClTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Clase Test Aplicación...
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 11/07/2018 - CARLOS ESPINOZA     		- Creación Clase
 * 
 * *****************************************************************************************/
@istest(seeAllData=true)
public class wsAxonaxisClTest {
    static testMethod void PruebaClasewsAxonaxisCI() {
        try{
       		 Test.startTest();
             wsAxonaxisCl.FechaDefuncion_element FechaFuncion = new wsAxonaxisCl.FechaDefuncion_element();
             FechaFuncion.FechaDefuncion=date.today();
             FechaFuncion.FuenteFechaDefuncion='';
            
             wsAxonaxisCl.Edad_element Edad = new wsAxonaxisCl.Edad_element();
             Edad.Edad=1;
             Edad.FuenteEdad='';
            
             wsAxonaxisCl.Sexo_element Sexo = new wsAxonaxisCl.Sexo_element();
             Sexo.Sexo='1';
             Sexo.FuenteSexo='';
            
            
             wsAxonaxisCl.Nombre_element Nombre = new wsAxonaxisCl.Nombre_element();
             Nombre.ApellidoMaterno='';
             Nombre.ApellidoPaterno=''; 
             Nombre.FuenteNombre=''; 
             Nombre.Nombres=''; 
            
             wsAxonaxisCl.Domicilio Domicilio = new wsAxonaxisCl.Domicilio();
             Domicilio.Calle='';
             Domicilio.Ciudad=''; 
             Domicilio.Comuna=''; 
             Domicilio.FuenteDomicilio=''; 
             Domicilio.Region=''; 
            
             wsAxonaxisCl.EstadoCivil_element EstadoCivil = new wsAxonaxisCl.EstadoCivil_element();
			 EstadoCivil.EstadoCivil='';
             EstadoCivil.FechaMatrimonio='';
             EstadoCivil.FuenteEstadoCivil='';
             
             wsAxonaxisCl.Actividad_element Actividad = new wsAxonaxisCl.Actividad_element();
			 Actividad.FuenteActividad='';
             Actividad.Actividad='';
             
             wsAxonaxisCl.Nacionalidad_element Nacionalidad = new wsAxonaxisCl.Nacionalidad_element();
			 Nacionalidad.FuenteNacionalidad='';
             Nacionalidad.Nacionalidad='';
             
             wsAxonaxisCl.FechaNacimiento_element FechaNac = new wsAxonaxisCl.FechaNacimiento_element();
			 FechaNac.FuenteFechaNacimiento='';
             FechaNac.FechaNacimiento=Date.today();
             
             wsAxonaxisCl.DatosPersona persona = new wsAxonaxisCl.DatosPersona();
             persona.RUT = '';
        	 persona.PersonaNatural = new wsAxonaxisCl.PersonaNatural_element();
             persona.Domicilio = new wsAxonaxisCl.Domicilio();
                
             Test.stopTest();
         }
         catch(Exception ex){
                Test.stopTest();
                system.debug('@@@@ ERROR METODO BatchMCTeleventaOnco :');
                system.debug('@@@@ Mensaje => ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
         }
    }
}