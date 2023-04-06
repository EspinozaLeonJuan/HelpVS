@isTest
public class ContactFabricate extends AbstractFabricate {

  public static final String CORREDOR_RT_NAME = 'Corredor';
  public static final String CONTRATANTE_RT_NAME = 'Contratante';

    public override Sobject default() {
        return new Contact(
            FirstName = 'Will',
            LastName = 'Smith',
            Email = 'will.smith@testcase.cl'
        );
    }

  public AbstractFabricate corredor() {
    return this.set('FirstName', 'Corredor')
      .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Contact.sObjectType, CORREDOR_RT_NAME));
  }

  public AbstractFabricate empresa() {
    return this.set('FirstName', 'ContactoEmpresa')
      .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Contact.sObjectType, CONTRATANTE_RT_NAME));
  }
  
    public AbstractFabricate temporal() {
        return this.set('FirstName', '').set('LastName', 'Contacto Temporal');
            //.set('RecordTypeId', ReflectionUtils.getRecordTypeId(Contact.sObjectType, CONTRATANTE_RT_NAME));
    }
    
    public ContactFabricate supervisor() {
        return (ContactFabricate) set('FirstName', 'Supervisor')
            .set('Cargo_Agente__c', 'Supervisor')
            .set('LastName', 'Supervisor')
            .set('Rut__c', '22222222-2')
            .set('RecordTypeId', Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId());
    }
    
    // agentes de venta 
    public ContactFabricate agente() {
        return (ContactFabricate) set('FirstName', 'Agente')
            .set('Cargo_Agente__c', 'Agente')
            .set('LastName', 'Agente')
            .set('Rut__c', '33333333-3')
            .set('Estado__c', 'Vigente')
            .set('RecordTypeId', Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId());
    }

    public ContactFabricate setCuenta(AccountFabricate cuenta) {
        return (ContactFabricate)set('AccountId', cuenta);
    }

    public ContactFabricate asignarSupervisor(ContactFabricate supervisor) {
        return (ContactFabricate)set('ReportsToId', supervisor);
    }
}