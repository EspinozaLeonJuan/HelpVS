/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-24-2021   Juan Espinoza León   Initial Version
**/
public  class CLS_CM_CorreoSaludProtegida {
    public CLS_CM_CorreoSaludProtegida() {

    }

    //@future(callout=true)
    public static void enviarEmail(String IdLead)
    {
        try
        {
            system.debug('@@@@ PASO => Entro en enviarEmail: ' );
            system.debug('@@@@ PASO => IdLead: '+IdLead );
            
            List<String> direcciones = new List<String>();
            List<String> direccionesBcc = new List<String>();
            String[] bbcAddresses = new String[]{};  //tmp       
            bbcAddresses.add('emoya@security.cl');
            bbcAddresses.add('blanca.revilla@ext-security.cl');

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setTargetObjectId(IdLead);
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'contactovida@security.cl'];

            if ( owea.size() > 0 ) 
            {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            email.setSaveAsActivity(true); //true guarda correo electronico
              //tmp       
             email.setBccAddresses(bbcAddresses);
                //tmp
            email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Televenta - Salud Protegida'].Id);    

            system.debug('@@@@ email => '+email);
            system.debug('@@@@ emailgetToAddresses. => '+email.getToAddresses());
            
            system.debug('@@@@ PASO => Va a Enviar Correo : ');
            
            if (!Test.isRunningTest()) 
            { 
                Messaging.SendEmailResult[] resultadoEnvio = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email}); 
            }
            
        } catch(system.Exception ex){
            system.debug('@@@@ ERROR => Enviar notificación a Cliente: ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }   
}