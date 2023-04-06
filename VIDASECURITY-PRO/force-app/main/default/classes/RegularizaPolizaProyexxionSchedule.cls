global class RegularizaPolizaProyexxionSchedule implements Schedulable {
  global void execute(SchedulableContext sc) {
    RegularizaPolizaProyexxionBatch.start();
  }
}