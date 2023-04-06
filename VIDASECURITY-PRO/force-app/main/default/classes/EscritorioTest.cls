@isTest
public class EscritorioTest {
 @isTest static void obtenerSolicitud_SOL0001() {
        Test.startTest();
        String Solicitud = 'SOL0001';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud Pensión Sobrevivencia');
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0002() {
        Test.startTest();
        String Solicitud = 'SOL0002';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud Cuota Mortuoria');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0003() {
        Test.startTest();
        String Solicitud = 'SOL0003';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud cambio Pago Pensión');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0004() {
        Test.startTest();
        String Solicitud = 'SOL0004';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud Periodo Garantizado');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0006() {
        Test.startTest();
        String Solicitud = 'SOL0006';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud de Asignación Familiar');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0007() {
        Test.startTest();
        String Solicitud = 'SOL0007';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Renovación de Asignación Familiar');
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0008() {
        Test.startTest();
        String Solicitud = 'SOL0008';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud de Extinción Asignación Familiar');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0009() {
        Test.startTest();
        String Solicitud = 'SOL0009';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Solicitud Garantía Estatal');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitud_SOL0010() {
        Test.startTest();
        String Solicitud = 'SOL0010';
        String Requerimiento = Escritorio.getSolicitud(Solicitud);        
        System.assert(Requerimiento == 'Renuncia Garantía Estatal');
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0001() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0001';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Conyuge');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0002() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0002';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Madre Filiación');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0003() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0003';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo menor 18 años');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0004() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0004';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo mayor 18 años');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0005() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0005';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Persona o Entidad que realiza el gasto');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0006() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0006';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Rentista Titular');	
        Test.stopTest();
    }    
    
    @isTest static void obtenerSolicitante_0008() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0008';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Rentista Titular');	
        Test.stopTest();
    }  
    
    @isTest static void obtenerSolicitante_0013() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0013';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Afiliado Titular');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0016() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0016';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Afiliado Titular');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0017() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0017';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Conyuge');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0018() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0018';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo menor de 18 años');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0019() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0019';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo mayor de 18 años');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0020() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0020';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Otros');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0021() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0021';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Madre o Padre (Ascendente)');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0022() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0022';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Afiliado Titular');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0023() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0023';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Conyuge');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0024() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0024';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Madre Filiación N/M');	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0025() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0025';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo menor de 18 años');
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0026() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0026';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Hijo mayor de 18 años');
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitante_0027() {
        Test.startTest();
        String Tipo = 'RRVVTIPO0027';
        String Requerimiento = Escritorio.getSolicitante(Tipo);        
        System.assert(Requerimiento == 'Afiliado Titular');	
        Test.stopTest();
    }
    
    @istest static void LoadSolicitudes()  {
        Test.startTest();
        List<SelectOption> solicitudes = Escritorio.getListaSolicitudes();  
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0001() {
        Test.startTest();
        String Solicitud = 'SOL0001';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 4);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0002() {
        Test.startTest();
        String Solicitud = 'SOL0002';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0003() {
        Test.startTest();
        String Solicitud = 'SOL0003';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0004() {
        Test.startTest();
        String Solicitud = 'SOL0004';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0006() {
        Test.startTest();
        String Solicitud = 'SOL0006';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0007() {
        Test.startTest();
        String Solicitud = 'SOL0007';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0008() {
        Test.startTest();
        String Solicitud = 'SOL0008';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 5);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0009() {
        Test.startTest();
        String Solicitud = 'SOL0009';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 5);	
        Test.stopTest();
    }
    
    @isTest static void obtenerSolicitantes_SOL0010() {
        Test.startTest();
        String Solicitud = 'SOL0010';
        List<SelectOption> solicitantes = Escritorio.getListaSolicitantes(Solicitud);                
        System.assert(solicitantes.size() == 1);	
        Test.stopTest();
    }
    
    @isTest static void consultaEstadoSolicitud_01()
    {
        Test.startTest();
        Integer Persistencia = 12345;
        String RutUsuario = '15045517-0';
        Solicitud__c Solicitud = new Solicitud__c();
        Solicitud.IdRequerimiento__c = 69;
        Escritorio.consultaEstadoSolicitud(Persistencia, RutUsuario, Solicitud);
        Test.stopTest();
    }
    
    @isTest static void consultaEstadoSolicitud_02()
    {
        Test.startTest();
        Integer Persistencia = 12345;
        String UserOS = 'GRP_SECURITY\\SALESFORCE';
        String Ip = '10.240.45.150';   
        String RutUsuario = '15045517-0';
        Solicitud__c Solicitud = new Solicitud__c();
        Solicitud.IdRequerimiento__c = 69;
        Escritorio.consultaEstadoSolicitud(RutUsuario, UserOS, Ip, Solicitud);
        Test.stopTest();
    }
    
    @isTest static void consulta_Codigo_SOL0001()
    {
        Test.startTest();
        String Solicitud = 'Solicitud Pensión Sobrevivencia';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0001'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0002()
    {
        Test.startTest();
        String Solicitud = 'Solicitud Cuota Mortuoria';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0002'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0003()
    {
        Test.startTest();
        String Solicitud = 'Solicitud cambio Pago Pensión';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0003'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0004()
    {
        Test.startTest();
        String Solicitud = 'Solicitud Periodo Garantizado';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0004'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0006()
    {
        Test.startTest();
        String Solicitud = 'Solicitud de Asignación Familiar';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0006'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0007()
    {
        Test.startTest();
        String Solicitud = 'Renovación de Asignación Familiar';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0007'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0008()
    {
        Test.startTest();
        String Solicitud = 'Solicitud de Extinción Asignación Familiar';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0008'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0009()
    {
        Test.startTest();
        String Solicitud = 'Solicitud Garantía Estatal';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0009'));
        Test.stopTest();
    }
    
     @isTest static void consulta_Codigo_SOL0010()
    {
        Test.startTest();
        String Solicitud = 'Renuncia Garantía Estatal';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0010'));
        Test.stopTest();
    }
    
    @isTest static void consulta_Codigo_NoExiste()
    {
        Test.startTest();
        String Solicitud = 'No existe codigo';        
        String Codigo = Escritorio.CodigoSolicitud(Solicitud);
        System.assert(Codigo.equalsIgnoreCase('SOL0001'));
        Test.stopTest();
    }    
}