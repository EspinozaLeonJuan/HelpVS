global class ScheduleViajeComunicacionesUpdate implements Schedulable {
  global void execute(SchedulableContext sc) {
    ScheduleViajeComunicacionesBatch.start();
  }
}