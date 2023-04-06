@isTest
public class TaskFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Task(
			ActivityDate = Date.today(),
			Subject = 'Llamada',
			Status = 'Abierta'
			);
	}
	
	public TaskFabricate setCuenta(AccountFabricate account) {
		return (TaskFabricate) set('WhatId', account);
	}
}