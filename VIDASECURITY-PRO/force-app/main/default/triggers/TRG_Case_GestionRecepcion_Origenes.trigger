/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-16-2022
 * @last modified by  : Juan Espinoza León
**/
trigger TRG_Case_GestionRecepcion_Origenes on Case (before insert, after insert) {

    if(trigger.isInsert)
    {
        if(trigger.isBefore)
        {
            Set<String> ORIGENES_SEGURO_COVID = new Set<String>{'SEGURO COVID'};

            String  Contact_RecordTypeId_Corredor  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Corredor').getRecordTypeId();

            for (Case caso : (Case[])Trigger.new){
                if (ORIGENES_SEGURO_COVID.contains(caso.Origin) && String.isNotBlank(caso.SuppliedEmail)) {

                    List<Contact> contactosAnonimos = [SELECT Id, AccountId, Email FROM Contact WHERE Email =: caso.SuppliedEmail AND Es_Seguro_COVID__c = true AND Es_Anonimo__c = true];

                    caso.Negocio__c = 'Seguros Colectivos';
                    caso.Canal__c = caso.Origin;
                    caso.Tipo_de_Solicitante__c = 'Corredor / Cliente';
                    caso.CASO_Categoria__c = 'Seguro Covid';
                    caso.Via_contacto__c = 'Mail';

                    String subjet = caso.Subject;
                    Boolean result= subjet.contains('Rut:');

                    Boolean isValid = false;
                    String RUT = '';
                    String ANONIMO = '99999998-0';

                    List<String> RUTs = new List<String>();

                    RUTs.add(ANONIMO.split('-')[0]);

                    if (result == true)
                    {
                        try {
                            String value =  subjet.substringAfter('Rut:').trim();
                            System.debug('@@@@ value : '+value);

                            RUT = value.substring(0, 10); //PRO

                            String dv = RUTUtils.getDigito(Integer.valueOf(RUT.substring(0,8)));
                            System.debug('@@@@ dv : '+dv);

                            if (dv == RUT.substring(9,10))
                            {
                                isValid = true;
                                RUTs.add(RUT.split('-')[0]);
                            }
                        }
                        catch (Exception ex) {

                        }
                    }

                    List<Account> cuentasList = [SELECT Id, RUT_con_DV__c FROM Account WHERE RUT__c IN : RUTs];

                    Map<String, Account> cuentasMap = new Map<String, Account>();

                    for (Account cuenta : cuentasList)
                    {
                        cuentasMap.put(cuenta.RUT_con_DV__c.toUpperCase(), cuenta);
                    }

                    Account cuentaAnom = cuentasMap.get(ANONIMO);

                    System.debug('@@@@ isValid : '+isValid);

                    if (isValid == true)
                    {
                        Account cuenta = cuentasMap.get(RUT.toUpperCase());

                        System.debug('@@@@ cuenta : '+cuenta);
                        //no deberia pasar nunca, si responde desde el correo
                        if (cuenta == null)
                        {
                            cuenta = cuentasMap.get(ANONIMO.toUpperCase());
                        }

                        caso.AccountId = cuenta.Id;

                        List<Contact> contactosCuenta = [SELECT Id, AccountId, Email FROM Contact WHERE Email =: caso.SuppliedEmail AND AccountId =: cuenta.Id AND Es_Seguro_COVID__c = true];

                        if (contactosCuenta.size() > 0)
                        {
                            caso.ContactId = contactosCuenta[0].Id;
                        }
                        else
                        {
                            //cualquier correo que consulte por empresa se considera corredor
                            Contact contacto =new Contact();
                            contacto.FirstName = '';
                            contacto.LastName = caso.SuppliedName == null ? caso.SuppliedEmail.split('@')[0] : caso.SuppliedName;
                            contacto.Email = caso.SuppliedEmail.trim();
                            contacto.Rut__c = '';
                            contacto.AccountId = cuentaAnom.Id;
                            contacto.Es_Seguro_COVID__c = true;
                            contacto.Activo_Seguro_COVID__c = false;
                            contacto.Es_Anonimo__c = true;
                            contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                            insert contacto;
                            caso.ContactId = contacto.Id;
                        }
                        //si trae adjuntos a solicitud
                        //si no trae adjunto consulta
                    }
                    else
                    {
                        Contact contacto = null;

                        if (contactosAnonimos.size() > 0)
                        {
                            contacto = contactosAnonimos[0];
                        }

                        if (contacto == null)
                        {
                            contacto = new Contact();
                            contacto.FirstName = '';
                            contacto.LastName = caso.SuppliedName == null ? caso.SuppliedEmail.split('@')[0] : caso.SuppliedName;
                            contacto.Email = caso.SuppliedEmail.trim();
                            contacto.Rut__c = '';
                            contacto.AccountId = cuentaAnom.Id;
                            contacto.Es_Seguro_COVID__c = true;
                            contacto.Activo_Seguro_COVID__c = false;
                            contacto.Es_Anonimo__c = true;
                            contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
                            insert contacto;
                            caso.AccountId = contacto.AccountId;
                            caso.ContactId = contacto.Id;
                        }
                        else
                        {
                            caso.AccountId = contacto.AccountId;
                            caso.ContactId = contacto.Id;
                        }
                    }
                }
            }
        }
        else  if(trigger.isAfter)
        {
        }
    }
}