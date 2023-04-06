global class ScheduleBatchOpportunity implements Schedulable {
  global void execute(SchedulableContext sc) {
    BatchOpportunityDaysToClose.start();
  }
}