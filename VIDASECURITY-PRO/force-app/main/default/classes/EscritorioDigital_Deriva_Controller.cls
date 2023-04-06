public class EscritorioDigital_Deriva_Controller {
 	public Case Caso {get; set;}   
    
    public String  RUTTitular { get; set; }     
    public String  NombreTitular { get; set; }     
    public String  Etiqueta { get; set; }     
	public String  DetalleSolicitud { get; set; }  
   // public String  EtiquetaSolicitud {get; set;}
	//public String  Solicitante { get; set; }      
    public Integer NumPoliza { get; set; }       
    public String  Poliza { get; set; } 
    
    //public Integer IdRequerimiento {get; set;}
    //public String  TipoRequerimientoED { get; set; } 
    //public String  TipoRequerimientoSF { get; set; }     
    public String  NumeroCaso { get; set; } 
    //public String  ResultadoDerivacion { get; set; } 
    //public String Panel { get; set; } 
    public String IDCASO  { get; set; } 
    
    /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference CargaCaso(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('idCaso');
            String Mensaje = 'Para el Caso a Derivar no existe un Requerimiento de Escritorio Digital asociado.';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Mensaje)); 
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                    Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Id_Requerimiento_EscritorioDigital__c,
                            Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c, Tipo_Requerimiento_EscritorioDigital__c
                            FROM Case
                            WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);    
                }
                
                this.RUTTitular = this.Caso.RUT__c;
                this.NombreTitular = this.Caso.Nombre_Completo_Razon_Social__c;            
                this.NumeroCaso = this.Caso.CaseNumber;        
                this.DetalleSolicitud = this.Caso.Detalle_Solicitud__c;        
                 
                if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
                {
                    this.NumPoliza = Integer.valueOf(this.Caso.CASO_Poliza_Asoc__c);
                    this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
                }
                else
                {
                    this.NumPoliza = 0;
                    this.Poliza = 'No seleccionada';
                }
                
                if(this.DetalleSolicitud != null && this.DetalleSolicitud != '')
                {
                    system.debug('@@@@ jCASO => ' + this.Caso);
                    this.Etiqueta = EscritorioDigital_Internal.Etiqueta(this.DetalleSolicitud);
                    system.debug('@@@@ EtiquetaSolicitud => ' + Etiqueta);
                    
                    if (this.Etiqueta == '')
                    {
                        this.Etiqueta = this.DetalleSolicitud;
                    }                   
                }
            } 
                return null;
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }
    
    public PageReference ToEscritorioDigital()
    {
        PageReference page = new PageReference ('/apex/EscritorioDigital_Page?Id='+  this.Caso.Id); 
        return page;
    }
    
    public PageReference ToDerivar()
    {
        Case caso;
        if (!Test.isRunningTest()) 
        {
           caso = [SELECT Id, RecordTypeId, OwnerId, CreatedById FROM Case WHERE Id =: IDCASO];
        }
        else
        {
        	Account cuenta = Factory.crearAccountAnonimo();
        	caso = FactoryEscritorio.buildCasoED('Solicitudes',cuenta);    
        }
                
        String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
        caso.setOptions(dmo);
        List<Case> lsC = new List<Case>();
        caso.Status = 'Back Office';
        caso.CASO_Deriva_a_UR__c = true;
        lsC.add(caso);
        Database.update(lsC,dmo);
        CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
        CLAsign.AsignarCaso(caso);
        
        
        Case caso2 = new Case();
                if (!Test.isRunningTest()) 
                {
                    caso2 = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: caso.Id];
                }
                else
                {
                    caso2.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
                }
                
                if(caso2 != null){
                    system.debug('@@@@ INFO CASO => ' + caso2);
                    String Propietario = caso2.OwnerId;
                    system.debug('@@@@ TIPO PROPIETARIO (USER/QUEUE) => ' + Propietario.substring(0, 3));
                    if(Propietario.substring(0, 3) == '005'){
                        User u = [SELECT Id, FirstName, Username, LastName, Name FROM User WHERE Id =: caso2.OwnerId];
                        system.debug('@@@@ USUARIO => ' + u.Name);
                        if(u != null && u.Name == 'Manuel Eduardo Poblete López'){                            
                            caso2.OwnerId =caso2.CreatedById;
                            caso2.Status = 'Nuevo';
                            caso2.CASO_Responsable_UR__c = null;
                            caso2.CASO_Resultado_Derivaci_n__c = 'NO EXISTE REGLA DE ASIGNACIÓN...';
                            if (!Test.isRunningTest()) 
        					{
                            	update caso2;
        					}
                        }
                    }else{                        
                        caso2.CASO_Resultado_Derivaci_n__c = 'CORRECTA ASIGNACIÓN...';
                        if (!Test.isRunningTest()) 
        				{
                        	update caso2;                                
        				}
                    }
                }
        
        
        
        /* ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                    dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                    c.setOptions(dmo);
                    List<Case> lsC = new List<Case>();
                    c.Status = 'Back Office';
                    c.CASO_Deriva_a_UR__c = true;
                    lsC.add(c);
                    Database.update(lsC,dmo);
                    CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
                    CLAsign.AsignarCaso(c); 
                    */
        PageReference detalleCaso = new PageReference('/' + caso.Id);
        detalleCaso.setRedirect(true);
        return detalleCaso;
        
       // PageReference page = new PageReference ('/apex/EscritorioDigital_Page?Id='+  this.Caso.Id); 
        //return page;
    }
    
    // 
}