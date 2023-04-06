/**
 * Tests para el handler de contacto para Comercial
 * @author: Patricio Labin C.
 */
@isTest
public class ContactTriggerHandlerTest {

    @IsTest
    static void EndYearAlertIsValid() {
        System.assert(
            Integer.valueOf(Label.Comercial_AlertsEndYear) >= Date.today().year(),
            'Se ha llegado al año configurado como fin para tareas recurrentes, cambie el label Comercial_AlertsEndYear.'
        );
    }

    @IsTest
    static void crearTareaBirthday_Success() {
        Contact testContact = new Contact(
            FirstName='Patricio',
            LastName='Labin',
            RecordTypeId=ComercialConstants.contactComercial,
            Birthdate=Date.newInstance(1995, 8, 21)
        );

        Test.startTest();
        insert testContact;
        Test.stopTest();
        String subjectQuery = ContactTriggerHandler.saludoBirthday + '%';
        AggregateResult result = [
            SELECT Count(Id) tasksCount FROM Task
            WHERE WhoId = :testContact.Id and IsRecurrence = true AND Subject LIKE :subjectQuery
        ];
        Integer numOfTasks = (Integer) result.get('tasksCount');

        System.assert(numOfTasks > 0, 'No se crearon las tareas de alerta de cumpleaños');
    }
    
    @isTest
    static void crearTareaBirthday_Failure() {
        Contact testContact = new Contact(
            FirstName='Patricio',
            LastName='Labin',
            RecordTypeId=ComercialConstants.contactComercial
        );
    
        Test.startTest();
        insert testContact;
        Test.stopTest();
        String subjectQuery = ContactTriggerHandler.saludoBirthday + '%';
        AggregateResult result = [
            SELECT Count(Id) tasksCount FROM Task
            WHERE WhoId = :testContact.Id and IsRecurrence = true AND Subject LIKE :subjectQuery
        ];
        Integer numOfTasks = (Integer) result.get('tasksCount');
    
        System.assert(numOfTasks == 0, 'No se crearon las tareas de alerta de cumpleaños');
    }
}