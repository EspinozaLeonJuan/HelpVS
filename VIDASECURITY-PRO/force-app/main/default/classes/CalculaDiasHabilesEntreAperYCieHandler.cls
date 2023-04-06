/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-25-2022
 * @last modified by  : Juan Espinoza León
**/
public class CalculaDiasHabilesEntreAperYCieHandler implements TriggerHandler.HandlerInterface
	  {

	public void handle() {

		for (Case caso : (Case[])Trigger.new) {

			Case oldCase  = (Case)(Trigger.isUpdate ? Trigger.oldMap.get(caso.Id) : null);

			if (oldCase == null || (oldCase != null && oldCase.Status != 'Cerrado' && oldCase.Status != 'Rechazado'))
			{
				if ((oldCase != null &&  String.isNotBlank(String.valueOf(caso.CreatedDate)) && String.isNotBlank(String.valueOf(caso.Fecha_Hora_de_Cierre__c)) && (caso.CreatedDate != oldCase.CreatedDate  || caso.Fecha_Hora_de_Cierre__c != oldCase.Fecha_Hora_de_Cierre__c) ) || (oldCase == null && String.isNotBlank(String.valueOf(caso.Fecha_Hora_de_Cierre__c))))
				{
					Date fechaInicio = (oldCase == null && String.isBlank(String.valueOf(caso.CreatedDate)) ) ? Date.today() : Date.newInstance(caso.CreatedDate.year(), caso.CreatedDate.month(), caso.CreatedDate.day());

					Date fechaFin = Date.newInstance(caso.Fecha_Hora_de_Cierre__c.year(), caso.Fecha_Hora_de_Cierre__c.month(), caso.Fecha_Hora_de_Cierre__c.day());
					caso.Cantidad_de_dias_H__c = HolidayUtils.bussinessDaysBetweenDates(fechaInicio, fechaFin);
				}
				else if( String.isBlank(String.valueOf(caso.CreatedDate)) || String.isBlank(String.valueOf(caso.Fecha_Hora_de_Cierre__c)))
				{
					caso.Cantidad_de_dias_H__c = null;
				}
			}
		}

	}


}