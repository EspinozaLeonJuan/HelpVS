/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-20-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CS_Correo_Liquidaciones_RRVV {
    public CLS_CS_Correo_Liquidaciones_RRVV() {

    }

    // @future(callout=true)
    public static void SendEmail(String Id)
    {
        try
        {
            system.debug('@@@@ Id --> '+ Id);
            Case caso = [SELECT Id, Correo_Liquidaciones__c, Meses_Liquidaciones__c, AccountId, Account.PersonEmail, ContactEmail, Account.PersonContactId FROM Case WHERE Id =: Id];
            system.debug('@@@@ caso --> '+ caso);
            List<Liquidacion_RRVV__c> liquidaciones = [SELECT Id, Periodo__c, Agno__c, Mes__c, CaseId__c, RUT__c, AccountId__c, CaseNumber__c, Estado__c, Base64_1__c, Base64_2__c, Base64_3__c FROM Liquidacion_RRVV__c WHERE CaseId__c =: Id AND Estado__c = 'Liquidación encontrada'
            ORDER BY Periodo__c ASC];

            String meses = '';

            if (liquidaciones.size() > 0)
            {
                if (liquidaciones.size() > 2)
                {
                    for (Integer i = 0; i < liquidaciones.size() -2; i++)
                    {
                        meses = meses + liquidaciones[i].Mes__c +' '+liquidaciones[i].Agno__c + ', ';
                    }

                    meses = meses + liquidaciones[liquidaciones.size() -2].Mes__c +' '+liquidaciones[liquidaciones.size() -2].Agno__c + ' y ';
                    meses = meses + liquidaciones[liquidaciones.size() -1].Mes__c  +' '+liquidaciones[liquidaciones.size() -1].Agno__c;
                }
                else if (liquidaciones.size() == 2)
                {
                    meses = meses + liquidaciones[0].Mes__c +' '+liquidaciones[0].Agno__c + ' y ';
                    meses = meses + liquidaciones[1].Mes__c +' '+liquidaciones[1].Agno__c;
                }
                else if (liquidaciones.size() == 1)
                {
                    meses = liquidaciones[0].Mes__c  +' '+liquidaciones[0].Agno__c;
                }

                caso.Meses_Liquidaciones__c = meses;
                caso.Correo_Liquidaciones__c = true;

                update caso;

                List<String> direcciones = new List<String>();
                List<String> direccionesBcc  = new List<String>();
                List<String> direccionesCc = new List<String>();

                direcciones.add(caso.ContactEmail);

                //direcciones.add('juanespinozaleon@ibm.com');

                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(direcciones);
                //email.setCcAddresses(direccionesCc);
                //email.setBccAddresses(direccionesBcc);

                email.setWhatId(caso.Id);
                email.setTargetObjectId(caso.Account.PersonContactId);

                OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'sfvida@security.cl'];

                if ( owea.size() > 0 )
                {
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                }

                email.setSaveAsActivity(true); //true guarda correo electronico

                List<Messaging.EmailFileAttachment> AdjCorreo = new List<Messaging.EmailFileAttachment>();

                system.debug('@@@@ liquidaciones --> '+ liquidaciones);

                String rut = liquidaciones[0].RUT__c.split('-')[0];

                for (Liquidacion_RRVV__c liq : liquidaciones)
                {
                    if (String.isnotBlank(liq.Base64_1__c))
                    {
                        Messaging.EmailFileAttachment adj = new Messaging.EmailFileAttachment();
                        adj.setFileName(liq.Periodo__c+'.pdf');
                        String b64 = liq.Base64_1__c + liq.Base64_2__c + liq.Base64_3__c;
                        adj.setBody(EncodingUtil.base64Decode(b64));
                        adj.setContentType('application/pdf');
                        AdjCorreo.add(adj);
                        liq.Estado__c = 'Liquidación enviada';
                    }

                }

                update liquidaciones;

                system.debug('@@@@ AdjCorreo --> '+ AdjCorreo.size());

                email.setFileAttachments(AdjCorreo);

                EmailTemplate ET;

                if (liquidaciones.size() == 1)
                {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'Envio Liquidacion RRVV'].Id);
                }
                else if (liquidaciones.size() > 1)
                {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'Envio Liquidaciones RRVV'].Id);
                }

                Messaging.SendEmailResult[] resultadoEnvio = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});

            }

        }
        catch(Exception ex)
        {
            system.debug('@@@@ EXLN --> '+ ex.getLineNumber());
            system.debug('@@@@ EX --> '+ ex);
        }
    }

}