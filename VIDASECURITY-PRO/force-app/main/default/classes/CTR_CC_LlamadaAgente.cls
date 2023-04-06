/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-06-2020   Juan Espinoza Leon   Initial Version
**/
public class CTR_CC_LlamadaAgente {

    public String IdCuenta { get; set;}

    public String IdCaso { get; set;}

    public String IdTarea { get; set;}

    public String IdProspecto { get; set;}

    public String IdSalesforce {get; set;}

    public String Procedencia { get; set;}

    public String Error { get; set;}

    public List<String> Telefonos {get; set;}

    public String Telefono {get; set;}

    public String NumeroLlamada {get; set;}

    public Boolean UsuarioHabilitado  {get; set;}

    public User Usuario {get; set;}

    public String RUT {get; set;}

    public String Name {get; set;}

    public String Title {get; set;}
    
    public String MensajeError {get; set;}
    
    public String CaseNumber {get; set;}
    
    public String Anexo {get; set;}

    public String CallUser {get; set;}
    
    public Decimal An_exo {get; set;}
    
     public Decimal Numer_o {get; set;}


    public String requestLabel { get; set; }

    public String CoL { get; set; }

    public String CoLId { get; set; }

    OBJ_WS_CC_RealizaLlamada Llamada { get; set; }

    public CTR_CC_LlamadaAgente() {
 
    }

    public Pagereference cargaInformacionLlamada()
    {
        this.IdCaso = '';
        this.IdCuenta = '';
        this.IdTarea = '';
        this.IdProspecto = '';

        String call = '';

        this.Error = '';

        this.Telefono = 'null';

        this.Telefonos = new List<String>();   

        this.Procedencia = apexpages.currentpage().getparameters().get('Origin');
        this.IdSalesforce = apexpages.currentpage().getparameters().get('Id');

        try 
        {
            call = apexpages.currentpage().getparameters().get('CallBack');
        }
        catch (Exception ex) 
        {
            call = 'no';
        }

        system.debug('@@@@ Procedencia '+this.Procedencia);
        system.debug('@@@@ id '+ this.IdSalesforce);

        if (this.Procedencia == 'Account')
        {
            this.Load_Account();    
        }
        else if (this.Procedencia == 'Case')
        {               
            this.Load_Case();            
        }
        else if (this.Procedencia == 'Task')
        {
            this.Load_Task();
        }

        if (String.IsBlank(this.Error))
        {
            this.Usuario = [SELECT Id, Anexo_A__c, Anexo_B__c, Usuario_A__c, Usuario_B__c, CommunityNickname FROM User WHERE Id =: UserInfo.getUserId()];

            if (String.isNotBlank(this.Usuario.Anexo_A__c) && String.isNotBlank(this.Usuario.Anexo_B__c)  &&  String.isNotBlank(this.Usuario.Usuario_A__c) &&  String.isNotBlank(this.Usuario.Usuario_B__c))
            {
                this.UsuarioHabilitado = true;
            }
        }
        
        return null;
    }


    private void Load_Account()
    {
        system.debug('@@@@ Cuenta --> '+this.IdSalesforce);

        List<Account> cuentas = [SELECT Id, Name, RUT__c, DV__c, Rut_con_dv__c, PersonMobilePhone, PersonHomePhone, isPersonAccount FROM Account WHERE Id =: this.IdSalesforce];

        if (cuentas.size() > 0)
        {            
            this.IdCuenta = cuentas[0].Id;

            this.Title = 'Llamada a Cliente';

            if (String.isNotBlank(cuentas[0].PersonHomePhone))
            {
                this.Telefonos.add(cuentas[0].PersonHomePhone);
            }

            if (String.isNotBlank(cuentas[0].PersonMobilePhone))
            {
                this.Telefonos.add(cuentas[0].PersonMobilePhone);
            }

            this.Name = cuentas[0].Name;
            this.RUT = cuentas[0].Rut_con_dv__c;
        }
        else {
            this.Error = 'ACCOUNT_NOT_FOUND';
        }        
    }

    private void Load_Case(){ //validar si es caso de prospecto mandar rut de prospecto en este caso
        system.debug('@@@@ Caso --> '+this.IdSalesforce);
        Case caso = [SELECT Id, AccountId, CaseNumber, RUT_no_Cliente__c FROM Case WHERE Id =: this.IdSalesforce];
        this.CaseNumber = caso.CaseNumber;
        system.debug('@@@@ caso '+caso);
        if (caso != null)
        {
            this.IdCaso = caso.Id;

            if (String.isNotBlank(caso.AccountId))
            {
                Account cuenta = [SELECT Id, Name, RUT__c, DV__c, Rut_con_dv__c, PersonMobilePhone, PersonHomePhone, isPersonAccount FROM Account WHERE Id =: caso.AccountId];

                if (cuenta != null)
                {
                    if (cuenta.Rut_con_dv__c != '99999995-6'){
                        this.IdCuenta = cuenta.Id;

                        this.Title = 'Llamada a Cliente';
    
                        if (String.isNotBlank(cuenta.PersonHomePhone))
                        {
                            this.Telefonos.add(cuenta.PersonHomePhone);
                        }
            
                        if (String.isNotBlank(cuenta.PersonMobilePhone))
                        {
                            this.Telefonos.add(cuenta.PersonMobilePhone);
                        }
        
                        this.Name = cuenta.Name;
                        this.RUT = cuenta.Rut_con_dv__c;

                        this.CoL = 'C';
                        this.CoLId = cuenta.Id;
                    }
                    else
                    {
                        String RecordTypeIdLead = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Prospecto_Contact_Center' AND IsActive = true].Id;
                        
                        Lead prospecto = [SELECT Id, Name, LastName, RUT__c , PROSP_Carga_Tel_fono_2__c, MobilePhone, Phone FROM Lead WHERE RUT__c =: caso.RUT_no_Cliente__c AND RecordTypeId =: RecordTypeIdLead];
                        
                        system.debug('@@@@ LEAD -->'+prospecto);
                        this.Title = 'Llamada a Prospecto';
                        
                        if (prospecto != null)
                        {
                            if (String.isNotBlank(prospecto.MobilePhone))
                            {
                                this.Telefonos.add(prospecto.MobilePhone);
                            }
                
                            if (String.isNotBlank(prospecto.Phone))
                            {
                                this.Telefonos.add(prospecto.Phone);
                            }
    
                            if (String.isNotBlank(prospecto.PROSP_Carga_Tel_fono_2__c))
                            {
                                this.Telefonos.add(prospecto.PROSP_Carga_Tel_fono_2__c);
                            }
    
                            this.Name = prospecto.Name + ' '+ prospecto.LastName;
                            this.RUT = prospecto.RUT__c;
                            this.IdProspecto = prospecto.Id;
                            this.CoL = 'L';
                            this.CoLId = prospecto.Id;
                        }
                        else
                        {
                            this.Error = 'LEAD_NOT_FOUND';
                        }
                    }
                }
                else {
                    this.Error = 'ACCOUNT_NOT_FOUND';
                }  
            }
            else
            {
                this.Error = 'ACCOUNT_NOT_FOUND';
            }
        }
        else {
            this.Error = 'CASE_NOT_FOUND';
        } 
    }

    private void Load_Task(){
        system.debug('@@@@ Tarea --> '+this.IdSalesforce);
        Task task = [SELECT Id, WhoId, AccountId FROM Task WHERE Id =: this.IdSalesforce];

        if (task != null)
        {
            this.IdTarea = task.Id;

            if (String.isBlank(task.AccountId) == false)
            {
                Account cuenta = [SELECT Id, Name, RUT__c, DV__c, Rut_con_dv__c, PersonMobilePhone, PersonHomePhone, isPersonAccount FROM Account WHERE Id =: task.AccountId];

                if (cuenta != null)
                {
                    this.IdCuenta = cuenta.Id;

                    this.Title = 'Llamada a Cliente';

                    if (String.isNotBlank(cuenta.PersonHomePhone))
                    {
                        this.Telefonos.add(cuenta.PersonHomePhone);
                    }
        
                    if (String.isNotBlank(cuenta.PersonMobilePhone))
                    {
                        this.Telefonos.add(cuenta.PersonMobilePhone);
                    }
                    
                    this.Name = cuenta.Name;
                    this.RUT = cuenta.Rut_con_dv__c;
                }
              /*   else 
                {
                   List<Lead> prospectos = [SELECT Id, Name, LastName, RUT__c, MobilePhone, Phone, PROSP_Carga_Tel_fono_2__c FROM Lead WHERE Id =: task.WhoId];
                    if (prospectos.size() > 0)
                    {
                        system.debug('@@@@ LEAD -->'+prospectos[0]);

                        this.IdProspecto = prospectos[0].Id;

                        this.Title = 'Llamada a Prospecto';
                    
                        if (String.isNotBlank(prospectos[0].MobilePhone))
                        {
                            this.Telefonos.add(prospectos[0].MobilePhone);
                        }
            
                        if (String.isNotBlank(prospectos[0].Phone))
                        {
                            this.Telefonos.add(prospectos[0].Phone);
                        }

                        if (String.isNotBlank(prospectos[0].PROSP_Carga_Tel_fono_2__c))
                        {
                            this.Telefonos.add(prospectos[0].PROSP_Carga_Tel_fono_2__c);
                        }

                        this.Name = prospectos[0].Name;
                        this.RUT = prospectos[0].RUT__c;
                    }
                    else {
                        this.Error = 'TASK_NOT_ASSIGNED';        
                    }
                } */
            }
            else {
                this.Error = 'TASK_NOT_ASSIGNED';        
            }
        }
        else {
            this.Error = 'TASK_NOT_FOUND';        
        }
    }

 
    public list<SelectOption> getListadoTelefonos() {
        List<SelectOption> tvalue = new list<SelectOption>(); 
        
        tvalue.add(new SelectOption('null','-- Seleccione --'));
               
        for (String rt : Telefonos) {
            tvalue.add(new SelectOption(rt, rt));
        } 
   
        return tvalue;
    }


    public list<SelectOption> getListadoAnexos() {
        List<SelectOption> tvalue = new list<SelectOption>(); 
        
        //tvalue.add(new SelectOption('','-- Seleccione --'));

        if (String.IsNotBlank(this.Usuario.Anexo_A__c))
        {
            tvalue.add(new SelectOption('UA', this.Usuario.Anexo_A__c ));
        }
    
        if (String.IsNotBlank(this.Usuario.Anexo_B__c))
        {
            tvalue.add(new SelectOption('UB',this.Usuario.Anexo_B__c));
        }
   
        return tvalue;
    }

    public System.Pagereference btnLlamar() {
        Boolean ErrorNumero = false, ErrorAnexo = false;

        if (String.IsNotBlank(this.NumeroLlamada))
        {        	
            String cadena = this.NumeroLlamada.substring(0,1);
            system.debug('@@@@ cadena '+ cadena);
            if (cadena != '9')
            {
                ErrorNumero = true;
                this.MensajeError = 'NUMBER_ERROR_NINE';
            }
        }
        else
        {
            ErrorNumero = true;
            this.MensajeError = 'NUMBER_IS_BLANK';
        }
   
        if (String.IsBlank(this.Anexo))
        { 
            ErrorAnexo = true;
            this.MensajeError = 'ANEXO_IS_BLANK';
        }
        
        if (ErrorNumero == false && ErrorAnexo == false)
        {           
            if (this.IdTarea == '')
            {
                if (String.IsNotBlank(this.IdCaso) == true)
                {
                    this.IdTarea = insertaTarea(this.IdCaso);                    
                }
                else {
                    this.IdTarea = insertaTarea(this.IdCuenta);      
                }
            }
            else {
                this.IdTarea = '0';
            }

            String vId = '';

            if (String.isNotBlank(this.CaseNumber))
            {
                vId = this.CaseNumber;
            }
            else {                
                vId = this.IdTarea; 
            }

            if (this.Anexo == 'UA')
            {
                this.Anexo = this.Usuario.Anexo_A__c;
                this.CallUser = this.Usuario.Usuario_A__c;
            }
            else if (this.Anexo == 'UB')
            {
                this.Anexo = this.Usuario.Anexo_B__c;
                this.CallUser = this.Usuario.Usuario_B__c;
            }

            system.debug('@@@@ NumeroDeTelefono '+this.NumeroLlamada);
            system.debug('@@@@ AnexoAgente '+this.Anexo);
            system.debug('@@@@ RutCliente '+this.RUT);
            system.debug('@@@@ IdSalesforce '+this.CaseNumber);
            system.debug('@@@@ Usuario '+this.CallUser);
            PageReference page = new PageReference('/apex/SEC_VF_CC_RealizarLlamada');

            page.getParameters().put('RUT', this.RUT);
            page.getParameters().put('Anexo', this.Anexo);
            page.getParameters().put('NumeroLlamada', this.NumeroLlamada);
            page.getParameters().put('Id', vId);
            page.getParameters().put('Usuario', this.CallUser);
            page.getParameters().put('IdTarea',  this.IdTarea);
            page.getParameters().put('CoL',  this.CoL);
            page.getParameters().put('CoLId',  this.CoLId);

            return page;
        }
        else {
            return null;
        }
    }

    //DELETE
    /*public System.Pagereference btnLlamar_Url() {
        Boolean ErrorNumero = false, ErrorAnexo = false;
        
        if (String.IsNotBlank(this.NumeroLlamada))
        {
        	try
            {
                Integer numero = Integer.valueOf(this.NumeroLlamada);
            }
            catch(Exception ex)
            {
				ErrorNumero = true;       
                this.MensajeError = 'NUMBER_ERROR';
            }

            String cadena = this.NumeroLlamada.substring(0,1);

            system.debug('@@@@ cadena '+ cadena);

            if (cadena != '9')
            {
                ErrorNumero = true;
                this.MensajeError = 'NUMBER_ERROR_NINE';
            }
        }
        else
        {
            ErrorNumero = true;
            this.MensajeError = 'NUMBER_IS_BLANK';
        }
        
        if (String.IsNotBlank(this.Anexo))
        {
        	try
            {
                Integer numero = Integer.valueOf(this.Anexo);
            }
            catch(Exception ex)
            {
				ErrorAnexo = true;       
                this.MensajeError = 'ANEXO_EEROR';
            }
        }
        else
        {
            ErrorAnexo = true;
            this.MensajeError = 'ANEXO_IS_BLANK';
        }
        
        if (ErrorNumero == false && ErrorAnexo == false)
        {           
            if (this.IdTarea == '')
            {
                if (String.IsNotBlank(this.IdCaso) == true)
                {
                    this.IdTarea = insertaTarea(this.IdCaso);                    
                }
                else {
                    this.IdTarea = insertaTarea(this.IdCuenta);      
                }
            }
            else {
                this.IdTarea = '0';
            }

            String vId = '';

            if (String.isNotBlank(this.CaseNumber))
            {
                vId = this.CaseNumber;
            }
            else {                
                vId = this.IdTarea; 
            }

            String url = '';

            if (this.IdCuenta != '')
            {
                String LogId = CLS_CC_LogContactCenter.InsertLog_Account(this.IdCuenta, this.IdTarea, 9, this.Anexo, this.NumeroLlamada,'', ''); 
            }
            else {
                if (this.IdProspecto != '')
                {
                    String LogId = CLS_CC_LogContactCenter.InsertLog_Lead(this.IdProspecto, this.IdTarea, 9, this.Anexo, this.NumeroLlamada,'','');
                }
            }
            
            if (String.isNotBlank(this.CaseNumber))
            {
                url = 'http://10.50.20.29:9080/webcall.html?NumeroDeTelefono='+this.NumeroLlamada+'&AnexoAgente='+this.Anexo+'&RutCliente='+this.RUT+'&IdSalesforce='+this.CaseNumber+'\'';              
            }
            else
            {
	            url = 'http://10.50.20.29:9080/webcall.html?NumeroDeTelefono='+this.NumeroLlamada+'&AnexoAgente='+this.Anexo+'&RutCliente='+this.RUT+'&IdSalesforce='+this.IdTarea+'\'';
            }

           system.debug('@@@@ url ContactCenter '+url);

           Task tareaUpdate = [SELECT Id, Status FROM Task WHERE Id =: this.IdTarea];

           tareaUpdate.Status = 'Completada';

           update tareaUpdate;

           return new System.Pagereference(url);
        }
        else {
            return null;
        }
    }*/

   /*public void clickTeclado()
   {
    system.debug('@@@@ Telefono In --> '+this.Telefono);


       if (this.Telefono != 'null')
       {
           this.Telefono = 'null';
           this.NumeroLlamada = '';
       }

       system.debug('@@@@ Telefono Out --> '+this.Telefono);
       String numero = apexpages.currentpage().getparameters().get('number'); 

       if (numero != '-1')
       {
            system.debug('@@@@ number --> '+apexpages.currentpage().getparameters().get('number'));
            system.debug('@@@@ numero --> '+numero); 
            if (this.NumeroLlamada.length() <= 10)
            {
                this.NumeroLlamada = this.NumeroLlamada +  numero;
            }
       }
       else {
            if (this.NumeroLlamada.length() > 0)
            {
                this.NumeroLlamada = this.NumeroLlamada.substring(0, this.NumeroLlamada.length() - 1);
            }
       }
       
       system.debug('@@@@ NumeroLlamada --> '+this.NumeroLlamada);
   }*/

   public void seleccionNumero()
   {
    if (this.Telefono == 'null')
    {
        this.NumeroLlamada = '';
    }
    else {
        this.NumeroLlamada = this.Telefono;    
    }

    system.debug('@@@@ NumeroLlamada --> '+this.NumeroLlamada);
   }

   public void btnLimpiar()
   {
       this.NumeroLlamada = '';
       this.Anexo = '';
       this.Telefono = 'null';
   }

   public String insertaTarea(String idRelacion)
   {
        try
        {
            Task t = new Task();

            //String recordTypeOnco = '0123D0000007N8uQAE';  //QAProdOnco
            String recordTypeTask = [SELECT Id FROM RecordType WHERE Name = 'Llamada Cliente'].Id;
            
            if (recordTypeTask==null)
            {
                recordTypeTask='';
            }
            
            t.WhatId = idRelacion;
            t.RecordTypeId = recordTypeTask; // Asigna tipo registro Tarea Llamada CLiente
            //t.WhoId = cm.LeadId;
            t.ActivityDate = Date.today();
            t.Description = '';
            t.Status = 'No Iniciada';
            t.Priority = 'Normal';
            t.OwnerId = this.Usuario.Id;
            
            system.debug('@@@@ INSERTA TAREA =>' + t);
            
            insert t;
            
            system.debug('@@@@ TAREA INSERTADA =>' + t);
            
            return t.Id;     
            
        }catch(Exception ex){
            system.debug('@@@@ Excepcion -->  ' + ex.getMessage() + '; ' + ex.getLineNumber());
            return 'error';
        }
    }
}