@IsTest 
public class TEST_PAR_EXT_WS_ConsultaPersona {
	
    
    @isTest static void go()
    {
        Test.startTest();
    	PAR_EXT_WS_ConsultaPersona.Actividad a = new PAR_EXT_WS_ConsultaPersona.Actividad();
        a.Actividad = '';
        a.FuenteActividad = '';
       	PAR_EXT_WS_ConsultaPersona.Nombre n = new PAR_EXT_WS_ConsultaPersona.Nombre();
        n.ApellidoMaterno = '';
        n.ApellidoPaterno = '';
        n.FuenteNombre = '';
        n.Nombres = '';
    	PAR_EXT_WS_ConsultaPersona.FechaNacimiento fn = new PAR_EXT_WS_ConsultaPersona.FechaNacimiento();
        fn.FechaNacimiento = '';
        fn.FuenteFechaNacimiento = '';
        PAR_EXT_WS_ConsultaPersona.Edad e = new PAR_EXT_WS_ConsultaPersona.Edad();
        e.Edad = 0;
        e.FuenteEdad = '';
        PAR_EXT_WS_ConsultaPersona.Nacionalidad na = new PAR_EXT_WS_ConsultaPersona.Nacionalidad();
        na.FuenteNacionalidad = '';
        na.Nacionalidad = '';
        PAR_EXT_WS_ConsultaPersona.EstadoCivil ec = new PAR_EXT_WS_ConsultaPersona.EstadoCivil();
        ec.EstadoCivil = '';
        ec.FechaMatrimonio = '';
        ec.FuenteEstadoCivil = '';
        PAR_EXT_WS_ConsultaPersona.Domicilio d = new PAR_EXT_WS_ConsultaPersona.Domicilio();
        d.Calle = '';
        d.Ciudad = '';
        d.Comuna = '';
        d.FuenteDomicilio = '';
        d.Region = '';
        PAR_EXT_WS_ConsultaPersona.Sexo s = new PAR_EXT_WS_ConsultaPersona.Sexo();
        s.FuenteSexo ='';
        s.Sexo = '';
        PAR_EXT_WS_ConsultaPersona.FechaDefuncion fd = new PAR_EXT_WS_ConsultaPersona.FechaDefuncion();
        fd.FechaDefuncion = '';
        fd.FuenteFechaDefuncion = '';
        
        PAR_EXT_WS_ConsultaPersona.Persona p = new PAR_EXT_WS_ConsultaPersona.Persona();
    	p.Actividad  = new PAR_EXT_WS_ConsultaPersona.Actividad();
       	p.Nombre = new PAR_EXT_WS_ConsultaPersona.Nombre();
    	p.FechaNacimiento = new PAR_EXT_WS_ConsultaPersona.FechaNacimiento();
        p.Edad  = new PAR_EXT_WS_ConsultaPersona.Edad();        
        p.Nacionalidad = new PAR_EXT_WS_ConsultaPersona.Nacionalidad();
        p.EstadoCivil = new PAR_EXT_WS_ConsultaPersona.EstadoCivil();
        p.Domicilio = new PAR_EXT_WS_ConsultaPersona.Domicilio();
        p.Sexo = new PAR_EXT_WS_ConsultaPersona.Sexo();
        p.FechaDefuncion  = new PAR_EXT_WS_ConsultaPersona.FechaDefuncion();
        p.RUT = '';
        Test.stopTest();
    }
 }