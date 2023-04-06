/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 08-07-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   08-07-2020   Juan Espinoza Leon   Initial Version
**/
@isTest
public class VSL_AR_AsignacionDeLinks_OportunidadTest {
    
    static String LinkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;  
    
    
    @isTest
    public static void baseNormalRegion1(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '001');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'IQUIQUE', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conSupervisor = new Contact(Lastname='conSupervisor', Region__c = region.Id, Tipo_Cargo__c = 'Jefe Comercial', Activo__c=true);
        insert conSupervisor;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
        insert conGerente;
        Opportunity opSupervisor = new Opportunity(Name = 'opSupervisor', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                   Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today(), Ciudad__c = ciudad.Id);
        insert opSupervisor;
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
        insert opGenrente;
        
        Opportunity updateOpSupervisor = [select id, Link_Auditado__c from Opportunity where Id =: opSupervisor.Id];  
        updateOpSupervisor.Link_Auditado__c=true;    
        updateOpSupervisor.StageName = 'Asignación'; 
        update updateOpSupervisor;
        
        Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true;     
        updateopGenrente.StageName = 'Asignación';
        update updateOpGenrente;
    }
    
    @isTest
    public static void baseNormalRegion1_1(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '001');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'IQUIQUE', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
        insert conGerente;
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
        insert opGenrente;        
        Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true; 
        updateopGenrente.StageName = 'Asignación';     
        update updateOpGenrente;
    }
    
    @isTest
    public static void baseNormalRegion1_2(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '001');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'IQUIQUE', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                     Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
            insert opGenrente;
            
            Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
            updateopGenrente.Link_Auditado__c=true;     
            updateopGenrente.StageName = 'Asignación';     
            update updateOpGenrente;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void baseNormalRegion2_0(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '002');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'IQUIQUE', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            
            Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                     Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
            insert opGenrente;
            
            Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
            updateopGenrente.Link_Auditado__c=true;  
            updateopGenrente.StageName = 'Asignación';        
            update updateOpGenrente;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    @isTest
    public static void baseNormalRegion2(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '002');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'ANTOFAGASTA', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conSupervisor = new Contact(Lastname='conSupervisor', Region__c = region.Id, Tipo_Cargo__c = 'Jefe Comercial', Activo__c=true);
        insert conSupervisor;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
        insert conGerente;
        Opportunity opSupervisor = new Opportunity(Name = 'opSupervisor', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                   Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today(), Ciudad__c = ciudad.Id);
        insert opSupervisor;
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
        insert opGenrente;
        
        Opportunity updateOpSupervisor = [select id, Link_Auditado__c from Opportunity where Id =: opSupervisor.Id];  
        updateOpSupervisor.Link_Auditado__c=true;  
        updateOpSupervisor.StageName = 'Asignación';        
        update updateOpSupervisor;
        
        Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true;   
        updateopGenrente.StageName = 'Asignación';       
        update updateOpGenrente;
    }
    
    @isTest
    public static void baseNormalRegion2_1(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '002');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'ANTOFAGASTA', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
        insert conGerente;
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
        insert opGenrente;
        Opportunity updateopGenrente = [select id, Link_Auditado__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true;    
        updateopGenrente.StageName = 'Asignación';     
        update updateOpGenrente;
    }
    
    @isTest
    public static void baseNormalRegion2_2(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '002');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'ANTOFAGASTA', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            Opportunity opSupervisor = new Opportunity(Name = 'opSupervisor', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                       Tipo_Link__c='Bases Normales', Renta__c = 800000, Fecha_Entrevista__c = System.today(), Ciudad__c = ciudad.Id);
            insert opSupervisor;
            
            Opportunity updateOpSupervisor = [select id, Link_Auditado__c from Opportunity where Id =: opSupervisor.Id];  
            updateOpSupervisor.Link_Auditado__c=true;  
            updateOpSupervisor.StageName = 'Asignación';       
            update updateOpSupervisor;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void baseNormalRegion8_0(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '008');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'CONCEPCIÓN', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                     Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
            insert opGenrente;
            
            Opportunity updateopGenrente = [select id, Link_Auditado__c, Renta__c from Opportunity where Id =: opGenrente.Id];  
            updateopGenrente.Link_Auditado__c=true;   
            updateopGenrente.StageName = 'Asignación';         
            update updateOpGenrente;  
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    
    @isTest
    public static void baseNormalRegion8(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '008');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'CONCEPCIÓN', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conSupervisor = new Contact(Lastname='conSupervisor', Region__c = region.Id, Tipo_Cargo__c = 'Jefe Comercial', Activo__c=true);
        insert conSupervisor;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
        insert conGerente;
        Opportunity opSupervisor = new Opportunity(Name = 'opSupervisor', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                   Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today(), Ciudad__c = ciudad.Id);
        insert opSupervisor;
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
        insert opGenrente;
        
        Opportunity updateOpSupervisor = [select id, Link_Auditado__c from Opportunity where Id =: opSupervisor.Id];  
        updateOpSupervisor.Link_Auditado__c=true;     
        updateOpSupervisor.StageName = 'Asignación';       
        update updateOpSupervisor;
        
        Opportunity updateopGenrente = [select id, Link_Auditado__c, Renta__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true;    
        updateopGenrente.StageName = 'Asignación';        
        update updateOpGenrente;        
    }
    
    @isTest
    public static void baseNormalRegion8_1(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '008');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'CONCEPCIÓN', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Gerente Regional', Activo__c=true);
            insert conGerente;
            
            Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                     Tipo_Link__c='Bases Normales', Renta__c = 1000001, Fecha_Entrevista__c = System.today());
            insert opGenrente;
            
            Opportunity updateopGenrente = [select id, Link_Auditado__c, Renta__c from Opportunity where Id =: opGenrente.Id];  
            updateopGenrente.Link_Auditado__c=true;   
            updateopGenrente.StageName = 'Asignación';         
            update updateOpGenrente;   
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void baseNormalRegion8_2(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '008');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'CONCEPCIÓN', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            Opportunity opSupervisor = new Opportunity(Name = 'opSupervisor', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                       Tipo_Link__c='Bases Normales', Renta__c = 700000, Fecha_Entrevista__c = System.today(), Ciudad__c = ciudad.Id);
            insert opSupervisor;
            
            Opportunity updateOpSupervisor = [select id, Link_Auditado__c from Opportunity where Id =: opSupervisor.Id];  
            updateOpSupervisor.Link_Auditado__c=true;  
            updateOpSupervisor.StageName = 'Asignación';          
            update updateOpSupervisor;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void baseNormalRegion13_0(){
        try{
            Region__c region = new Region__c(Name = '', REGI_C_digo__c = '013');
            insert region;
            Ciudad__c ciudad = new Ciudad__c(Name= 'SANTIAGO', CIUD_Region__c = region.Id);
            insert ciudad;
            Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
            insert cuenta;
            
            Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                     Tipo_Link__c='Bases Normales', Renta__c = 700000, Fecha_Entrevista__c = System.today());
            insert opGenrente;
            
            Opportunity updateopGenrente = [select id, Link_Auditado__c, Renta__c from Opportunity where Id =: opGenrente.Id];  
            updateopGenrente.Link_Auditado__c=true;    
            updateopGenrente.StageName = 'Asignación';        
            update updateOpGenrente;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
    }
    
    @isTest
    public static void baseNormalRegion13(){
        Region__c region = new Region__c(Name = '', REGI_C_digo__c = '013');
        insert region;
        Ciudad__c ciudad = new Ciudad__c(Name= 'SANTIAGO', CIUD_Region__c = region.Id);
        insert ciudad;
        Account cuenta = new Account(Name = 'Cuenta ', Ciudad_Particular_B__c = ciudad.Id);
        insert cuenta;
        Contact conGerente = new Contact(Lastname='conGerente', Region__c = region.Id, Tipo_Cargo__c = 'Supervisor PF', Activo__c=true);
        insert conGerente;
        
        Opportunity opGenrente = new Opportunity(Name = 'opGenrente', AccountId = cuenta.Id, StageName = 'Calificación', CloseDate = System.today(), RecordTypeId = LinkRecordType,
                                                 Tipo_Link__c='Bases Normales', Renta__c = 700000, Fecha_Entrevista__c = System.today());
        insert opGenrente;
        
        Opportunity updateopGenrente = [select id, Link_Auditado__c, Renta__c from Opportunity where Id =: opGenrente.Id];  
        updateopGenrente.Link_Auditado__c=true;    
        updateopGenrente.StageName = 'Asignación';        
        update updateOpGenrente;    
    }
    
    
}