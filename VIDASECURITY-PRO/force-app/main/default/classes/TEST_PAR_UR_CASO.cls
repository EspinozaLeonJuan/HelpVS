@IsTest
public with sharing class TEST_PAR_UR_CASO {
    public TEST_PAR_UR_CASO() {

    }
    
    @isTest
    static void testParse() {
        Test.startTest();
        String json =		'{'+
		'	"Eventos" : '+ 
		'	{ '+
		'		"EscritorioDigital": false, '+
		'		"EnvioCorreo": false, '+
		'		"AdjuntosValuetech": true, '+
		'		"Adjuntos": true, '+
		'		"Comentarios" : true,'+
		'		"TareasUR" : true,'+
		'		"EnProceso" : false,' +
		'		"RetornoEjecutiva" : false,' +
		'		"Rechazar" : true, '+
		'		"Cerrar" : true, '+
		'       "ActualizaACSEL" : true, '+
		'		"ReasignarResponsable" : true,'+
		'		"Contacto" : true,'+
		'		"Propuesta" : true,'+
		'		"Asunto" : true,'+
		'		"FechaCreacion" : true,'+
		'		"Ejecutivo" : true,'+
		'		"Canal" : true,'+
		'		"FechaCierre" : true,'+
		'		"Agente" : true,'+
		'		"MontoRescate"  : true,'+
		'		"SubEstadoACSEL"  : true'+
		'	}'+
		'}';
        
		PAR_UR_CASO obj = PAR_UR_CASO.parse(json);
        system.debug('EscritorioDigital  ' + obj.Eventos.EscritorioDigital);
        system.debug('EnvioCorreo  ' + obj.Eventos.EnvioCorreo);
        system.debug('AdjuntosValuetech  ' + obj.Eventos.AdjuntosValuetech);
        system.debug('Adjuntos  ' + obj.Eventos.Adjuntos);
        system.debug('Comentarios  ' + obj.Eventos.Comentarios);
        system.debug('TareasUR  ' + obj.Eventos.TareasUR);
        system.debug('EnProceso  ' + obj.Eventos.EnProceso);
        system.debug('RetornoEjecutiva  ' + obj.Eventos.RetornoEjecutiva);
        system.debug('Rechazar  ' + obj.Eventos.Rechazar);
        system.debug('Cerrar  ' + obj.Eventos.Cerrar);
        system.debug('ActualizaACSEL  ' + obj.Eventos.ActualizaACSEL);
        system.debug('ReasignarResponsable  ' + obj.Eventos.ReasignarResponsable);
        system.debug('Contacto  ' + obj.Eventos.Contacto);
        system.debug('Propuesta  ' + obj.Eventos.Propuesta);
        system.debug('Asunto  ' + obj.Eventos.Asunto);
        system.debug('FechaCreacion  ' + obj.Eventos.FechaCreacion);
        system.debug('Ejecutivo  ' + obj.Eventos.Ejecutivo);
        system.debug('Canal  ' + obj.Eventos.Canal);
        system.debug('FechaCierre  ' + obj.Eventos.FechaCierre);
        system.debug('Agente  ' + obj.Eventos.Agente);
        system.debug('MontoRescate  ' + obj.Eventos.MontoRescate);
        system.debug('SubEstadoACSEL  ' + obj.Eventos.SubEstadoACSEL);
        Test.stopTest();		
	}
}