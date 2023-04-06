/**
 * Constantes para proyecto Comercial
 * @author: ChangeMeIn@UserSettingsUnder.SFDoc
 * @date: 05-05-2020
 */
public without sharing class ComercialConstants {

    /** RecordType Ids **/
    public static Id contactComercial;
    public static Id taskComercial;
    public static Id opportunityComercialNuevo;
    public static Id opportunityComercialRenovacion;
    public static Id opportunityCovidCliente;
    public static Id opportunityCovidNoCliente;    
    public static Id quoteComercial;
    public static Id quoteRenovacion;
    public static Id quoteCovid;    
    public static Id accountComercial;

    /** Picklist Importantes **/
    // Opportunity
    public static string oppStageOpen;
    public static string oppStageRequest;
    public static string oppStageAnalysis;
    public static string oppStageClosed;
    public static string oppStageCotizacion;
    public static string oppStageRenovacion;
    // Quote
    public static string qtStatusPrepAntecedentes;
    public static string qtStatusTarificacion;
    public static string qtStatusPrepCotizacion;
    public static string qtStatusNegociacion;
    public static string qtStatusClosed;

    /** SLAs **/
    public static Integer diasPrepAntecedentes = 3;
    public static Integer diasTarificacion     = 2;
    public static Integer diasPrepCotizacion   = 2;
    public static List<String> quoteStatusOrdered;
    public static List<String> slaStatuses;

    /** Profile */
    public static string profileEjecutivoTecnico;
    public static string profileJefaturaTecnico;
    public static string profileEjecutivoComercial;

    
    // Everything in this block **only runs one time**, pls keep away
    static {
        contactComercial = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contactos_Comercial').recordtypeid;
        taskComercial = Schema.SObjectType.Task.getRecordTypeInfosByDeveloperName().get('Comercial_Colectivos').recordtypeid;
        accountComercial = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Cuenta_Corporativa').recordtypeid;
        
        // Quote
        Map<String, Schema.RecordTypeInfo> qtRts = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName();
        quoteComercial = qtRts.get('Cotizacion_Comercial').recordtypeid;
        quoteRenovacion = qtRts.get('Cotizacion_Comercial_Renovacion').recordtypeid;
        quoteCovid = qtRts.get('Presupuesto_Covid').recordtypeid;
        qtStatusPrepAntecedentes = 'Preparar Antecedentes';
        qtStatusTarificacion = 'Tarificacion';
        qtStatusPrepCotizacion = 'Preparar Cotizacion';
        qtStatusNegociacion = 'Negociacion';
        qtStatusClosed = 'Cerrada';
        quoteStatusOrdered = new List<String> {
            qtStatusPrepAntecedentes, qtStatusTarificacion, qtStatusPrepCotizacion, qtStatusNegociacion, qtStatusClosed
        };
        slaStatuses = new List<String> {
            qtStatusPrepAntecedentes, qtStatusTarificacion, qtStatusPrepCotizacion
        };

        // Opportunity
        Map<String, Schema.RecordTypeInfo> oppRts= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName();
        opportunityComercialNuevo = oppRts.get('Comercial_Nuevo').recordtypeid;
        opportunityComercialRenovacion = oppRts.get('Comercial_Renovacion').recordtypeid;
        opportunityCovidCliente = oppRts.get('Seguro_Covid_Cliente').recordtypeid;
        opportunityCovidNoCliente = oppRts.get('Seguro_Covid_No_Cliente').recordtypeid;        
        
        oppStageOpen = 'Ingresar Negocio';
        oppStageRequest = 'Solicitud Antecedentes';
        oppStageAnalysis = 'Se requiere un análisis';
        oppStageClosed = 'Cerrada';
        oppStageCotizacion = 'Cotización';
        oppStageRenovacion = 'Renovación';

        //profile
        profileEjecutivoTecnico = 'Ejecutivo Técnico Colectivo';
        profileJefaturaTecnico = 'Jefatura Técnica Colectivo';
        profileEjecutivoComercial = 'Ejecutivo Comercial Colectivo';
    }

}