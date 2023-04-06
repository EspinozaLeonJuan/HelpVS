public class SEC_CTRL_AceptaCommunication {

   	public Quote presupuesto{set;get;} 
    public Opportunity oportunidad{set;get;}
    public User propietario{set;get;}
    public Contacto_Cuenta__c representante{set;get;}
    public Contact contacto{set;get;} 
    public Corredores_Venta__c  ventas{set;get;} 
	public Contact corredor{set;get;}
    public User usuario{set;get;}
    public String message{set;get;}     
    
    public SEC_CTRL_AceptaCommunication(ApexPages.StandardController controller){
        Quote opp = (Quote)controller.getRecord();
        
        presupuesto = [SELECT Id, Session_ID__c , URL__c, Code__c, OpportunityId FROM Quote WHERE Id =: opp.Id limit 1]; 
        oportunidad = [SELECT Id, AccountId, OwnerId FROM Opportunity WHERE Id =: presupuesto.OpportunityId LIMIT 1];
        propietario = [SELECT Id, Name, Email, RUT_Usuario__c FROM User WHERE Id =: oportunidad.OwnerId LIMIT 1];
        representante = [SELECT Id, Contacto__c FROM Contacto_Cuenta__c WHERE Oportunidad__c =: oportunidad.Id and Representante_Legal__c = true LIMIT 1];
        ventas = [SELECT Id, Contacto__c FROM Corredores_Venta__c WHERE Id_Oportunidad__c  =: oportunidad.Id LIMIT 1];
		corredor = [SELECT Id, Email FROM Contact WHERE Id  =: ventas.Contacto__c LIMIT 1];
        if(representante != null){
        	contacto = [SELECT Id, Name, Rut__c, Email FROM Contact WHERE Id =: representante.Contacto__c  LIMIT 1];                    
        }else{
            message = 'Requieres agregar un representante legal';
        }
        
        Id currentId = UserInfo.getUserId();
        usuario = [SELECT Id, Name FROM User WHERE Id =: currentId LIMIT 1];
    }  
    
    public PageReference doPDF(){
        if((presupuesto.Session_ID__c == null || presupuesto.Session_ID__c == '') 
           && (presupuesto.Code__c == null || presupuesto.Code__c == '') 
           && (presupuesto.URL__c == null || presupuesto.URL__c == '') ){
               if(representante != null){               
                   String session_id = doLogin();
                   System.debug('acepta session_id : ' + session_id);
                
                    if(session_id != ''){
                        PageReference pageRef = Page.SEC_VF_COVID_PDF;            
                        pageRef.getParameters().put('id', presupuesto.Id);
                        //pageRef.setRedirect(false);
                        //Blob PDF = pageRef.getContentAsPDF();
                        Blob PDF;
                        if(Test.isRunningTest()) { 
                          PDF = blob.valueOf('Unit.Test');
                        } else {
                          PDF = pageRef.getContentAsPDF();
                        }
                        
                        string base64 = EncodingUtil.base64Encode(PDF);
                        System.debug('acepta base64 : ' + base64);         
                        
                        String code = doDocument(session_id, base64);
                        System.debug('acepta code : ' + code);        
                        
                        String url = getDocument(session_id, code);  
                        System.debug('acepta url : ' + url);        
                        
                        presupuesto.Session_ID__c = session_id;
                        presupuesto.Code__c = code;
                        presupuesto.URL__c = url;
                        presupuesto.Enviado_a_Representante_Legal__c = true;
                        presupuesto.Fecha_envio_a_Representante_Legal__c = System.now();
                        update presupuesto;  
                        
                        sendCompleteNotification();
                        message = 'Correo enviado satisfactoriamente, puedes cerrar esta ventana.';
                        //return pageRef;
                    }                   
               }else{
                   message = 'Requieres agregar un representante legal';                   
               }
           }else{
               //PageReference pageRef = Page.SEC_VF_COVID_PDF;
               //pageRef.getParameters().put('id', presupuesto.Id);
               presupuesto.Enviado_a_Representante_Legal__c = true;
               presupuesto.Fecha_envio_a_Representante_Legal__c = System.now();
               update presupuesto;
               
               sendCompleteNotification();
               message = 'Correo enviado satisfactoriamente, puedes cerrar esta ventana.';               
               //return pageRef;
           }
        return null;   
    }

    public String doLogin(){
        URL_API_Acepta__c servicio = URL_API_Acepta__c.getOrgDefaults();
        String session_id = '';
        
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();      
        gen.writeStringField('user_name', servicio.Acepta_User__c);
        gen.writeStringField('user_pin', servicio.Acepta_Password__c);
        gen.writeEndObject();    
        String body = gen.getAsString();
        
        System.debug('acepta login body : ' + body); 
        
        String point = 'auth/login';        
        Map<String, Object> response = SEC_ACEPTA_Services.doAceptaCommunication(point, body, 'POST'); 
        
        System.debug('acepta login response : ' + response); 
        
        if(response.containsKey('status')) {
            integer status = (integer) response.get('status');
            if(status == 200){
                session_id = (string) response.get('session_id');
            }
        }
        return session_id;
    }
    
    public String doDocument(String session_id, String base64){
        URL_API_Acepta__c servicio = URL_API_Acepta__c.getOrgDefaults();
        String code = '';
        Map<String, Object> obj = new Map<String, Object>();
        obj.put('type_code', servicio.Type_code__c );
        obj.put('name', 'Propuesta Seguro Covid-19');
        obj.put('institution', 'VIDASECURITY');
        obj.put('creator', 'VIDASECURITY');
        obj.put('signers_roles', new List<String>{contacto.Rut__c, propietario.RUT_Usuario__c});        
        obj.put('signers_institutions', new List<String>{contacto.Rut__c, propietario.RUT_Usuario__c});
        if(contacto.Email != null){
        	obj.put('signers_emails', new List<String>{contacto.Email, propietario.Email});
        }else{
        	obj.put('signers_emails', new List<String>{corredor.Email, propietario.Email});
        }
        obj.put('signers_ruts', new List<String>{contacto.Rut__c, propietario.RUT_Usuario__c});       
        obj.put('signers_type', new List<Integer>{0, 0});
        obj.put('signers_order', new List<Integer>{1, 1});
        obj.put('field_tags', new List<String>{''}); 
        obj.put('field_tags_values', new List<String>{''});       
        obj.put('signers_notify', new List<Integer>{0});
        obj.put('session_id', session_id);        
        obj.put('file', base64); 
        obj.put('file_mime', 'application/pdf');
        String body = JSON.Serialize(obj);
        
        System.debug('acepta doDocument body : ' + body);         
        
        String point = 'documents/create';       
        Map<String, Object> response = SEC_ACEPTA_Services.doAceptaCommunication(point, body, 'POST'); 
        
        if(response.containsKey('status')) {
            integer status = (integer) response.get('status');
            if(status == 200){
        		if(response.containsKey('result')) {
            		Map<String, Object> results = (Map<String, Object>) response.get('result');
                	code = (string) results.get('code');                   
        		}
            }
        }
        
        return code;
    }   
    
    public String getDocument(String session_id, String code){
        String url = '';
        String point = 'documents?code='+code+'&institution=VIDASECURITY&extra=signers&session_id='+session_id;
        Map<String, Object> response = SEC_ACEPTA_Services.doAceptaCommunication(point, null, 'GET'); 
        
        if(response.containsKey('status')) {
            integer status = (integer) response.get('status');
            if(status == 200){
        		if(response.containsKey('result')) {
            		Map<String, Object> results = (Map<String, Object>) response.get('result');
                    url = (string) results.get('file_preview');                    
                    
        		}
            }
        }
        return url;
    }    
    
    public void sendCompleteNotification(){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSenderDisplayName(usuario.Name);
        //message.setSubject('Propuesta Seguro Covid-19');
        message.setUseSignature(false);
        message.setBccSender(false);
        message.setSaveAsActivity(false); 
        EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Plantilla de correo presupuesto COVID'];
        message.setTemplateID(emailTemplate.Id); 
        message.setWhatId(oportunidad.Id);
        if(contacto.Email != null){
            message.setTargetObjectId(contacto.Id);
        	message.toAddresses = new String[] {propietario.Email, contacto.Email};
        }else{
            message.setTargetObjectId(corredor.Id);            
        	message.toAddresses = new String[] {propietario.Email};
        }

        message.setCcAddresses(new String[] {corredor.Email});
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages, true);
     
         if (results[0].success) {
           System.debug('The email was sent successfully.');
         } else {
           System.debug('The email failed to send: ' +  results[0].errors[0].message);
         }
    }    
}