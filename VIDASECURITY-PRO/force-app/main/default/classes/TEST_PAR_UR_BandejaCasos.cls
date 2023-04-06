@IsTest
public with sharing class TEST_PAR_UR_BandejaCasos {
    public TEST_PAR_UR_BandejaCasos() {

    }

    @isTest
    static void testParse() {
        Test.startTest();
        String json= '{'+
        '"Filtro":'+ 
        '{'+ 
        '"FechaDerivacion" : true,'+
        '"HoraDerivacion" : true,'+ 
        '"EstadoCaso" : true,'+ 
        '"Negocio" : false,'+ 
        '"Categoria" : false,'+ 
        '"Solicitud" : false,'+ 
        '"NumeroCaso" : true,'+ 
        '"RUTCaso" : true,'+ 
        '"ClienteNoCliente" : true,'+ 
        '"Poliza" : true,'+ 
        '"Propuesta" : true,'+ 
        '"Origen" : true,'+ 
        '"SubEstadoACSEL" : false'+ 
        '},'+ 
        '"Grilla" :'+ 
        '{'+ 
        '"EstadoCaso" : true,'+ 
        '"NumeroCaso" : true,'+
        '"Propuesta" : true,'+ 
        '"Poliza" : true,'+
        '"ClienteNoCliente" : true,'+
        '"RUTCaso" : true,'+
        '"Nombre" : true,'+
        '"Negocio" : false,'+
        '"Categoria" : true,'+
        '"Solicitud" : true,'+
        '"FechaCreacion" : true,'+
        '"FechaDerivacion" : true,'+
        '"FechaAsignacion" : true,'+
        '"FechaCierre" : true,'+
        '"Agente" : false,'+
        '"Ejecutivo" : true,'+
        '"Responsable" : true,'+
        '"Origen" : true,'+
        '"SubEstadoACSEL" : false,'+
        '"MontoRescate" : false'+
        '},'+
        '"Acciones":'+
        '{'+
        '"ResponsableMultiple" : true,'+
        '"CierreMultiple" : true'+
        '},'+
        '"Botonera":'+
        '{'+
        '"CasosUR" : true,'+
        '"CasosUREnRevision" : false,'+
        '"CasosURHistorico" : true'+ 
        '}'+
        '}';
        
		PAR_UR_BandejaCasos obj = PAR_UR_BandejaCasos.parse(json);
        
        system.debug('FechaDerivacion  ' +obj.Filtro.FechaDerivacion);
        system.debug('HoraDerivacion  ' +obj.Filtro.HoraDerivacion);		
        system.debug('EstadoCaso  ' +obj.Filtro.EstadoCaso);
        system.debug('Negocio  ' +obj.Filtro.Negocio);
        system.debug('Categoria  ' +obj.Filtro.Categoria);
        system.debug('Solicitud  ' +obj.Filtro.Solicitud);
        system.debug('NumeroCaso  ' +obj.Filtro.NumeroCaso);
		system.debug('RUTCaso  ' +obj.Filtro.RUTCaso);
		system.debug('ClienteNoCliente  ' +obj.Filtro.ClienteNoCliente);        
		system.debug('Poliza  ' +obj.Filtro.Poliza);
		system.debug('Propuesta  ' +obj.Filtro.Propuesta);
		system.debug('Origen  ' +obj.Filtro.Origen);
		system.debug('SubEstadoACSEL  ' +obj.Filtro.SubEstadoACSEL);
        
        system.debug('EstadoCaso  ' +obj.Grilla.EstadoCaso);
        system.debug('NumeroCaso  ' +obj.Grilla.NumeroCaso);
        system.debug('Propuesta  ' +obj.Grilla.Propuesta);
        system.debug('Poliza  ' +obj.Grilla.Poliza);
        system.debug('ClienteNoCliente  ' +obj.Grilla.ClienteNoCliente);
        system.debug('RUTCaso  ' +obj.Grilla.RUTCaso);
        system.debug('Nombre  ' +obj.Grilla.Nombre);
        system.debug('Negocio  ' +obj.Grilla.Negocio);
        system.debug('Categoria  ' +obj.Grilla.Categoria);
        system.debug('Solicitud  ' +obj.Grilla.Solicitud);
        system.debug('FechaCreacion  ' +obj.Grilla.FechaCreacion);
        system.debug('FechaDerivacion  ' +obj.Grilla.FechaDerivacion);
        system.debug('FechaAsignacion  ' +obj.Grilla.FechaAsignacion);
        system.debug('FechaCierre  ' +obj.Grilla.FechaCierre);
        system.debug('Agente  ' +obj.Grilla.Agente);
        system.debug('Ejecutivo  ' +obj.Grilla.Ejecutivo);        
        system.debug('Responsable  ' +obj.Grilla.Responsable);        
        system.debug('Origen  ' +obj.Grilla.Origen);        
        system.debug('SubEstadoACSEL  ' +obj.Grilla.SubEstadoACSEL);        
        system.debug('MontoRescate  ' +obj.Grilla.MontoRescate);         
        system.debug('ResponsableMultiple  ' +obj.Acciones.ResponsableMultiple); 
        system.debug('CierreMultiple  ' +obj.Acciones.CierreMultiple);         
        system.debug('CasosUR  ' +obj.Botonera.CasosUR); 
        system.debug('CasosUREnRevision  ' +obj.Botonera.CasosUREnRevision); 
        system.debug('CasosURHistorico  ' +obj.Botonera.CasosURHistorico); 
        
		///System.assert(obj != null);
        Test.stopTest();		
	}
}