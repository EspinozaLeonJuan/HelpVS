@isTest
public class RequerimientoControllerTest {
    
    /*@isTest static void obtenerTipoSolicitantes1() {
        
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 4);	
	}*/
    
    @isTest static void obtenerTipoSolicitantes1() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 4);	
	}
    
     @isTest static void obtenerTipoSolicitantes2() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud cuota mortuoria';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
	}
    
    @isTest static void obtenerTipoSolicitantes3() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud cuota mortuoriaw';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 0);	
	}
    
    @isTest static void obtenerTipoSolicitantes4() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud garantía estatal';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 5);	
     }
    
     @isTest static void obtenerTipoSolicitantes5() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud cambio pago pensión';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    /*
     @isTest static void obtenerTipoSolicitantes6() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud de ingreso poder notarial';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }*/
    
     @isTest static void obtenerTipoSolicitantes7() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud de incorporación/ Renovación asignación familiar';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    
     @isTest static void obtenerTipoSolicitantes8() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud de Extinción';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 5);	
     }
    
      @isTest static void obtenerTipoSolicitantes9() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Declaración Ingresos Actualización';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    /*
      @isTest static void obtenerTipoSolicitantes10() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Declaración Ingresos nuevos beneficiarios';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    */
    @isTest static void obtenerTipoSolicitantes11() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Renuncia Garantía Estatal';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    
    @isTest static void obtenerTipoSolicitantes12() {
    RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud periodo garantizado';
   		List<SelectOption> Tipos = RC.getTiposSolicitante();
    
		System.assert(Tipos.size() == 1);	
     }
    
    
     @isTest static void obtenerNombreFormulario1() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
    	String Formulario = RC.getNombreFormulario();    
		System.assert(Formulario == 'Solicitud Pensión Sobrevivencia');	
	}
 /*   
     @isTest static void obtenerNombreFormulario2() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Declaración Ingresos nuevos beneficiarios';
    	String Formulario = RC.getNombreFormulario();    
		System.assert(Formulario == 'Declaración Ingresos nuevos beneficiarios');	
	}

  @isTest static void obtenerNombreFormulario3() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud de ingreso poder notarial';
    	String Formulario = RC.getNombreFormulario();    
		System.assert(Formulario == 'Mantención poder de cobro a tercero');	
	}
   */ 
      @isTest static void obtenerNombreFormulario4() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencias';
    	String Formulario = RC.getNombreFormulario();    
		System.assert(Formulario == '');	
	}
    
     @isTest static void validaFormulario1() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
    	boolean Respuesta = RC.validaSolicitud();    
		System.assert(Respuesta == true);	
	}
    
    
     @isTest static void validaFormulario2() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Solicitud de Extinción';
    	boolean Respuesta = RC.validaSolicitud();    
		System.assert(Respuesta == true);	
	}
    
    
     @isTest static void validaFormulario3() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'Renuncia Garantía Estatal';
    	boolean Respuesta = RC.validaSolicitud();    
		System.assert(Respuesta == true);	
	}
    
    
     @isTest static void validaFormulario4() {
   		RequerimientoController RC = new RequerimientoController();
        RC.DetalleSolicitud = 'aSolicitud pensión sobrevivencia';
    	boolean Respuesta = RC.validaSolicitud();    
		System.assert(Respuesta == false);	
	}
    
     @isTest static void informacionRequerimiento1() {
   		RequerimientoController RC = new RequerimientoController();
        RC.TipoRequerimientoED = 'RRVVTIPO0003';
    	RC.getInformacionRequerimiento();  
		System.assert(RC.Requerimiento == 'Solicitud Pensión Sobrevivencia');
		System.assert(RC.Solicitante == 'Hijo menor de 18 años');  
	}
    
    @isTest static void informacionRequerimiento2() {
   		RequerimientoController RC = new RequerimientoController();
        RC.TipoRequerimientoED = 'RRVVTIPO0005';
    	RC.getInformacionRequerimiento();  
		System.assert(RC.Requerimiento == 'Cuota Mortuoria');
		System.assert(RC.Solicitante == 'Persona o Entidad que realiza el gasto');  
	}
    
    @isTest static void informacionRequerimiento3() {
   		RequerimientoController RC = new RequerimientoController();
        RC.TipoRequerimientoED = 'RRVVTIPO0023';
    	RC.getInformacionRequerimiento();  
		System.assert(RC.Requerimiento == 'Solicitud Garantía Estatal');
		System.assert(RC.Solicitante == 'Cónyuge');  
	}
    
       @isTest static void informacionRequerimiento4() {
   		RequerimientoController RC = new RequerimientoController();
        RC.TipoRequerimientoED = 'RRVVTIPO0033';
    	RC.getInformacionRequerimiento();  
		System.assert(RC.Requerimiento == '');
		System.assert(RC.Solicitante == '');  
	}
    
    @istest static void crearRequerimiento()
    {
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';
        RC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        RC.Ip = 'JUESLEON';
        RC.crearRequerimiento();        
    }
    
    @istest static void nuevoRequerimiento()
    {
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';
        RC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        RC.Ip = 'JUESLEON';
        RC.TipoRequerimientoED = 'RRVVTIPO0013';
        RC.RutTitular = '12904564-7';
        RC.IdPersistenciaED = 12345;
        RC.nuevoRequerimiento();        
    }
    
    @istest static void verRequerimiento()
    {
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';
        RC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        RC.Ip = 'JUESLEON';
        RC.verRequerimiento();        
    }
    
    @istest static void eliminarRequerimiento()
    {
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';
        RC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        RC.Ip = 'JUESLEON';
        RC.eliminarRequerimiento();        
    }
    
     @istest static void eliminaRequerimiento()
    {
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';      
        RC.IdRequerimientoED = 222;
        RC.IdPersistenciaED = 12345;        
        RC.eliminaRequerimiento();        
    }
    
    @istest static void GeneraParametros_caso01_NULO()
    {           
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';              
        RC.RutTitular = '10103133-0';
        RC.IdRequerimientoED = 0;
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
        RC.TipoRequerimientoED = null;
        RC.EstadoRequerimientoED = null;
        RC.GeneraParametrosInterfaz();
        System.assert(RC.Panel == 'CRE_REQ');  
    }
    
    
    @istest static void GeneraParametros_caso02_PENDIENTE()
    {           
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';             
        RC.RutTitular = '10103133-0';
        RC.IdRequerimientoED = 190;
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
        RC.TipoRequerimientoED = 'RRVVTIPO0001';
        RC.EstadoRequerimientoED = 'PENDIENTE';
        RC.GeneraParametrosInterfaz();
        System.assert(RC.Panel == 'VER_REQ');  
    }
    
     @istest static void GeneraParametros_caso02_FINALIZADO()
    {           
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';                
        RC.RutTitular = '10103133-0';
        RC.IdRequerimientoED = 190;
        RC.DetalleSolicitud = 'Solicitud pensión sobrevivencia';
        RC.TipoRequerimientoED = 'RRVVTIPO0001';
        RC.EstadoRequerimientoED = 'FINALIZADO';
        
        RC.GeneraParametrosInterfaz();
        System.assert(RC.Panel == 'FIN_REQ');  
    }
    
     @istest static void GeneraParametros_caso03_NOEXISTEREQ()
    {   
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = '15045517-0';  
        RC.RutTitular = '10103133-0';
        RC.IdRequerimientoED = 0;
        RC.DetalleSolicitud = 'No esta en Escritorio';
        RC.TipoRequerimientoED = null;
        RC.EstadoRequerimientoED = null;
        RC.GeneraParametrosInterfaz();
        System.assert(RC.Panel == 'NUL_REQ');  
    }
    
     @istest static void GeneraParametros_caso04_NOUSUARIO()
    {   
       	RequerimientoController RC = new RequerimientoController();
        RC.RutUsuario = NULL;  
        RC.RutTitular = '10103133-0';
        RC.IdRequerimientoED = 0;
        RC.DetalleSolicitud = 'No esta en Escritorio';
        RC.TipoRequerimientoED = null;
        RC.EstadoRequerimientoED = null;
        RC.GeneraParametrosInterfaz();
        System.assert(RC.Panel == 'NUL_USER');  
    }
}