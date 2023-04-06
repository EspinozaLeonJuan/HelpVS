@isTest
public class EventFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Event(
			StartDateTime = Datetime.now(),
			DurationInMinutes = 30
			);
	}

	public AbstractFabricate withContact() {
		return this.set('WhoId', Fabricate.contacto());
	}
	
	public EventFabricate setCuenta(AccountFabricate account) {
		return (EventFabricate) set('WhatId', account);
	}
}