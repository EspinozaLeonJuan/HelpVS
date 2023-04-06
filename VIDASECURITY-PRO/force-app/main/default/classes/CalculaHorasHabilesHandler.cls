public without sharing class CalculaHorasHabilesHandler implements TriggerHandler.HandlerInterface {

	@testVisible
	private static Datetime newCloseDate = null;
	@testVisible
	private static Datetime oldCloseDate = null;

	public void handle(){
		if (!Trigger.isUpdate) return;
		Case[] news = Trigger.new;
		Case[] olds = Trigger.old;
		BusinessHours[] bHours = [SELECT Id FROM BusinessHours WHERE IsActive = true];
		if (bHours.isEmpty()) return;
		BusinessHours bHour = bHours[0];
		for (Integer i = 0; i < news.size(); i++){
			Case newCase = news[i];
			Case oldCase = olds[i];
			newCloseDate = Test.isRunningTest() && newCloseDate != null ? newCloseDate : newCase.ClosedDate;
			oldCloseDate = Test.isRunningTest() && oldCloseDate != null ? oldCloseDate : oldCase.ClosedDate;
			if (newCloseDate != null && (newCloseDate != oldCloseDate || newCase.Cantidad_de_Horas_Habiles__c == null || newCase.Cantidad_de_Horas_Habiles__c == 0)){
				Double millisDifference = BusinessHours.diff(bHour.Id, newCase.CreatedDate, newCloseDate);
				Double hoursDifference = millisDifference / 3600000.0;
				if (hoursDifference != null && hoursDifference != 0)
					newCase.Cantidad_de_Horas_Habiles__c = Decimal.valueOf(hoursDifference).setScale(3);
			}
		}
	}
}