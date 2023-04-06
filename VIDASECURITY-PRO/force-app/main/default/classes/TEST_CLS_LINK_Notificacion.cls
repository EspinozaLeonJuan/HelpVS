/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-06-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-06-2021   Juan Espinoza León   Initial Version
**/
@isTest
public class TEST_CLS_LINK_Notificacion {
    public TEST_CLS_LINK_Notificacion() {

    }

    @IsTest
    static void envioCorreo(){

        Test.startTest();

        List<Opportunity> opptys = new List<Opportunity>();

        Ciudad__c cd = New Ciudad__c(Name= 'IQUIQUE');
        insert cd;
        Region__c rg = new Region__c(Name= 'REGION DE ARICA Y PARINACOTA');
        insert rg;

        String regionSup = [SELECT Id FROM Region__c WHERE Name='REGION DE ARICA Y PARINACOTA' Limit 1].Id;
        String iquique = [SELECT Id FROM Ciudad__c WHERE Name='IQUIQUE' Limit 1].Id;

        Contact co = new Contact(
            FirstName = 'Supervisor Iquique',
            LastName = 'LastName',
            Ciudad__c = iquique,
            email = 'supervisor@gmail.com',
            Tipo_Cargo__c = 'Gerente Regional',
            Region__c = regionSup
        );

        insert co;

        String supervisor = [SELECT Id FROM Contact WHERE Tipo_Cargo__c = 'Gerente Regional' AND Region__r.Name = 'REGION DE ARICA Y PARINACOTA'].Id;

        String recordTypeLink = [SELECT Id FROM RecordType WHERE Name = 'Venta - Link'].Id;

        List<Contact> contys = new List<Contact>();

        for (Integer i = 0; i < 1; i++) {
            Contact c = new Contact(
                FirstName = 'Contact' + i,
                LastName = 'Last' + i,
                Ciudad__c = iquique,
                email = 'contact'+i+'@gmail.com',
                ReportsToId = supervisor,
                Tipo_Cargo__c = 'Jefe Comercial'
            );
            contys.add(c);
        }

        insert contys;

        Account acc = new Account(Name='Account Test',
        Direccion__c = 'RAMON CARINCER 1928',
        Cargo__c = 'Consultor',
        Renta__c = '1200000'
        );
        insert acc;

        Map<Id, Contact> contactInserted = new Map<Id, Contact>(contys);
        List<Id> contactIds = new List<Id>(contactInserted.keySet());
        Time myTime = Time.newInstance(18, 00, 00, 00);
        date mydate = System.today().addDays(10);

        for (Integer i = 0; i < 5; i++) {

            Opportunity o = new Opportunity(
                Name = 'Opportunity ' + i,
                StageName = 'Asignación',
                Agente_de_venta__c = contactIds[0],
                Fecha_Entrevista__c = System.today(),
                Direccion__c = 'RAMON CARNICER 1924',
                Hora_Entrevista__c = myTime,
                Renta__c = 1200000,
                RecordTypeId = recordTypeLink,
                AccountId = acc.Id,
                Telefono_activo__c = '942332571',
                agente_asignado__c = true,
                Observacion__c = 'SE GENERA OBSERVACION',
                Link_Auditado__c = true,
                CloseDate = mydate,
                Codigo_de_Link__c = i
            );
            opptys.add(o);
        }

        insert opptys;

        CLS_LINK_Notificacion.envioCorreo();
        CLS_LINK_Notificacion.envioCorreo(opptys[0].Id);

        CLS_LINK_Notificacion.envioCorreo_Cliente();
        CLS_LINK_Notificacion.envioCorreo_Cliente(opptys[0].Id);

        Test.stopTest();

    }
}