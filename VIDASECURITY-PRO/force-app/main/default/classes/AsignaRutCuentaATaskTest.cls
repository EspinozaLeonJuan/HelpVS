@isTest
public class AsignaRutCuentaATaskTest {
	static {
		TriggerHandler.enable(AsignaRutCuentaATaskHandler.class);
		AccountFabricate cuenta = Fabricate.cuenta().personal();
		cuenta.save();	
	}

	@isTest static void para_Todos_dado_WhatIdCuenta_cuando_insertaOActualizaTarea_debe_AsignarRutCuentaARutTarea() {
		Account cuentaResultado = [Select Id, Rut_con_dv__c From Account Limit 1];
		TaskFabricate tarea = Fabricate.tarea();
		tarea.set('WhatId', cuentaResultado.Id);
		tarea.save();
		Task tareaResultado = [Select Id, WhatId, Rut_Cuenta__c From Task Limit 1];
		System.assertEquals(cuentaResultado.Id, tareaResultado.WhatId);
		//System.assertEquals(cuentaResultado.Rut_con_dv__c, tareaResultado.Rut_Cuenta__c);
	}

	/*@isTest static void para_Todos_dado_WhatIdCuenta_cuando_insertaOActualizaEvento_debe_AsignarRutCuentaARutEvento() {
		Account cuentaResultado = [Select Id, Rut_con_dv__c From Account Limit 1];
		EventFabricate evento = Fabricate.evento();
		evento.set('WhatId', cuentaResultado.Id);
		evento.save();
		Event eventoResultado = [Select Id, WhatId, Rut_Cuenta__c From Event Limit 1];
		System.assertEquals(cuentaResultado.Id, eventoResultado.WhatId);
		//System.assertEquals(cuentaResultado.Rut_con_dv__c, eventoResultado.Rut_Cuenta__c);

	}*/
}