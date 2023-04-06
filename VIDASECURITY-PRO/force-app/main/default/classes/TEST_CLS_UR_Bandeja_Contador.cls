/**
 * @File Name          : TEST_CLS_UR_Bandeja_Contador.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/2/2020, 11:55:43 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public class TEST_CLS_UR_Bandeja_Contador {
    @IsTest
    public static void ActualizaEstado_Caso_Test_01()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Back Office';
        String estadoNuevo = 'En Proceso';
        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(Uback.Id,  estadoNuevo, estado);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Caso_Test_02()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estadoNuevo = 'Back Office';
        String estado = 'En Revisión';
        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(Uback.Id,  estadoNuevo, estado);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Caso_Test_03()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estadoNuevo = 'Cerrado';
        String estado = 'En Proceso';
        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(Uback.Id,  estadoNuevo, estado);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Caso_Test_04()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Back Office';
        String estadoNuevo = 'En Revisión';
        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(Uback.Id,  estadoNuevo, estado);
        Test.stopTest();
    }
    
      @IsTest
    public static void ActualizaEstado_Caso_Test_05()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estadoNuevo = 'Rechazado';
        String estado = 'En Proceso';
        CLS_UR_Bandeja_Contador.ActualizaEstado_Caso(Uback.Id,  estadoNuevo, estado);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaResponsable_Caso_Test_01()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'Back Office';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Caso(Uback1.Id, Uback2.Id, estado);
        Test.stopTest();
    }

    @IsTest
    public static void ActualizaResponsable_Caso_Test_02()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'En Proceso';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Caso(Uback1.Id, Uback2.Id, estado);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Tarea_Test_01()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, '');
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Tarea_Test_02()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'En Curso';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Tarea_Test_03()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Completada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Tarea_Test_04()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Completada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }

    @IsTest
    public static void ActualizaEstado_Tarea_Test_05()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Rechazada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Tarea_Test_06()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Rechazada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Tarea_Test_07()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Descartada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Tarea_Test_08()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Descartada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
     @IsTest
    public static void ActualizaResponsable_Tarea_Test_01()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'No Iniciada';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Tarea(Uback1.Id, Uback2.Id, estado);
        
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaResponsable_Tarea_Test_02()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'En Curso';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Tarea(Uback1.Id, Uback2.Id, estado);
        
        Test.stopTest();
    }

    
      @IsTest
    public static void ActualizaEstado_Colaboracion_Test_01()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, '');
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Colaboracion_Test_02()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'En Curso';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Colaboracion_Test_03()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Completada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaEstado_Colaboracion_Test_04()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Completada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }

    @IsTest
    public static void ActualizaEstado_Colaboracion_Test_05()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Rechazada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Colaboracion_Test_06()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Rechazada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Colaboracion_Test_07()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Descartada';        
        String estadoPrevio = 'No Iniciada';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
    @IsTest
    public static void ActualizaEstado_Colaboracion_Test_08()
    {
        Test.startTest();
        Usuario_Backup__c Uback = Factory.buildUsuarioBackup();
        String estado = 'Descartada';        
        String estadoPrevio = 'En Curso';        
        CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(Uback.Id,  estado, estadoPrevio);
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaResponsable_Colaboracion_Test_01()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'No Iniciada';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Colaboracion(Uback1.Id, Uback2.Id, estado);
        
        Test.stopTest();
    }
    
     @IsTest
    public static void ActualizaResponsable_Colaboracion_Test_02()
    {
        Test.startTest();
        
        Usuario_Backup__c Uback1= Factory.buildUsuarioBackup();        
        
        Usuario_Backup__c Uback2= Factory.buildUsuarioBackup();        
        String estado = 'En Curso';
        CLS_UR_Bandeja_Contador.ActualizaResponsable_Colaboracion(Uback1.Id, Uback2.Id, estado);
        
        Test.stopTest();
    }
    
     @IsTest
    public static void Creacion_Objecto_Test01()
    {
        Test.startTest();
        
        CLS_UR_Bandeja_Contador.CambioMasivoResponsable casoMasivo = new CLS_UR_Bandeja_Contador.CambioMasivoResponsable();
        casoMasivo.IdActual = '';
        casoMasivo.IdNuevo = '';
        casoMasivo.EstadoActual = '';
        CLS_UR_Bandeja_Contador.CambioMasivoEstado casoMasivoEstado = new CLS_UR_Bandeja_Contador.CambioMasivoEstado();
        casoMasivoEstado.Id = '';
        casoMasivoEstado.EstadoNuevo = '';
        casoMasivoEstado.EstadoActual = '';
        Test.stopTest();
    }
    
}