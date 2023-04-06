/**
 * Contact Trigger Handler para Comercial
 * @author: Patricio Labin C.
 * @date: 05-05-2020
 */
public without sharing class ContactTriggerHandler {

    public static String saludoBirthday = 'Saludo de Cumpleaños para ';

    /**
     * crearTareaBirthday
     * Crea una tarea que se repite de forma anual para los contactos Comercial y con fecha de nacimiento
     * @author Patricio Labin C.
     * @param newContacts List<Contacts>: Lista de contactos nuevos
     * @date: 05-05-2020
     */
    public static void crearTareaBirthday(Map<Id, Contact> newContacts){
        List<PicklistEntry> recurrenceMonths = Task.RecurrenceMonthOfYear.getDescribe().getPicklistValues();

        // Obtener tareas de cumpleaños ya creadas
        String saludoQuery = saludoBirthday + '%';
        List<Task> oldTasks = [
            SELECT WhoId FROM Task 
            WHERE Subject LIKE :saludoQuery and WhoId in :newContacts.keySet()
        ];
        System.debug(oldTasks);
        Set<Id> contactsId = new Set<Id>();
        for (Task t: oldTasks) {
            contactsId.add(t.WhoId);
        }

        List<Task> newTasks = new List<Task>();
        Date endDate;
        Integer endYear = Integer.valueOf(Label.Comercial_AlertsEndYear);
        for (Contact c: newContacts.values()) {
            endDate = Date.newInstance(endYear, 1, 1);

            if (
                c.RecordTypeId != ComercialConstants.contactComercial
                || c.Birthdate == null
                || contactsId.contains(c.Id)
                || c.Birthdate > endDate
            ) continue;

            // Se crea una tarea recurrente
            Task newTask = new Task (
                RecordTypeId=ComercialConstants.taskComercial,
                Subject=saludoBirthday + c.FirstName + ' ' + c.LastName,
                Priority='Normal',
                WhoId=c.Id,
                IsRecurrence=true,
                RecurrenceType='RecursYearly',
                RecurrenceStartDateOnly=Date.newInstance(Date.today().year(), c.Birthdate.month(), c.Birthdate.day()),
                RecurrenceEndDateOnly=endDate,
                RecurrenceDayOfMonth=c.Birthdate.day(),
                RecurrenceMonthOfYear=recurrenceMonths.get(c.Birthdate.month()-1).getValue()
            );
            newTasks.add(newTask);
        }

        if (!newTasks.isEmpty()) {
            List<Database.SaveResult> results = Database.insert(newTasks, false);
            for (Database.SaveResult r: results) {
                if (!r.getErrors().isEmpty()) System.debug(LoggingLevel.WARN, 'Tareas de cumpleaños no fueron creadas: ' + r.getErrors());
            }
        }
    }

}