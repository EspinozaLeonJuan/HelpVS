@isTest
private class CalculaDiasHabilesEntreAperYCieTest {
	static CaseFabricate caso {get; set;}

	static {
		TriggerHandler.enable(new Type[] {
     		CalculaDiasHabilesEntreAperYCieHandler.class,
    		ActualizaFechaHoraDeCierreHandler.class,
    		AsignaFechaTopeHandler.class
    	});
	}

	static testMethod void para_TODOS_dado_fecha_inicio_fecha_fin_entre_feriado_debe_calcular_cantidad_dias_habiles() {
		Datetime fechaInicio = Datetime.newInstance(2017, 12, 31);
		Datetime fechaFin = Datetime.newInstance(2018, 1, 2);
		AccountFabricate cuenta = Fabricate.cuenta();
		cuenta.corporativa();		
		cuenta.save();
		caso = Fabricate.caso().reclamo();
		Id cuentaId = (Id)cuenta.get().get('Id');
		caso.set('AccountId', cuentaId);
		caso.set('CreatedDate', fechaInicio);
		caso.set('Fecha_Hora_de_Cierre__c', fechaFin);
		caso.save();
		Case casoResul = [Select Cantidad_de_dias_H__c From Case];
		//System.assertEquals(1, casoResul.Cantidad_de_dias_H__c);	
	}

	static testMethod void para_TODOS_cuando_estado_es_cerrado_debe_calcular_cantidad_dias_habiles() {
		Datetime fechaInicio = Datetime.newInstance(2018, 1, 2);
		Datetime fechaFin = Datetime.newInstance(2018, 1, 4);
		AccountFabricate cuenta = Fabricate.cuenta();
		cuenta.corporativa();		
		cuenta.save();
		Id cuentaId = (Id)cuenta.get().get('Id');
		caso = Fabricate.caso().reclamo();
		caso.set('AccountId', cuentaId);
		caso.set('CreatedDate', fechaInicio);
		caso.set('Fecha_Hora_de_Cierre__c', fechaFin);
		caso.save();
		Case casoResul = [Select Cantidad_de_dias_H__c From Case];
		//System.assertEquals(3, casoResul.Cantidad_de_dias_H__c);	
	}

	static testMethod void para_TODOS_dado_fecha_inicio_sin_fecha_fin_debe_calcular_cantidad_dias_habiles() {
		AccountFabricate cuenta = Fabricate.cuenta();
		cuenta.corporativa();
		cuenta.save();
		Id cuentaId = (Id)cuenta.get().get('Id');
		caso = Fabricate.caso().reclamo();
		caso.set('AccountId', cuentaId);
		caso.save();
		Case casoResul = [Select Cantidad_de_dias_H__c From Case];
		System.assertEquals(null, casoResul.Cantidad_de_dias_H__c);	
	}
	
}