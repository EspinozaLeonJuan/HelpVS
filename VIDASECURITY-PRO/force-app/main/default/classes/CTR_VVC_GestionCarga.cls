/**
 * @File Name          : CTR_VVC_GestionCarga.cls
 * @Description        : 
 * @Author             : Consultor Salesforce Vida
 * @Group              : 
 * @Last Modified By   : Consultor Salesforce Vida
 * @Last Modified On   : 5/25/2019, 1:19:43 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/22/2019, 12:32:55 PM   Consultor Salesforce Vida     Initial Version
**/
public  class CTR_VVC_GestionCarga {

    private class ObjError
    {
        public String RUT {get; set;}
        public String Monto {get; set;}
        public String Fecha {get; set;}
        public String Empresa {get; set;}
        public String Tipo {get; set;}
        public String Error {get; set;}
    }
    
    public Blob csvFileBody{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public List<Registro_Vale_Vista__c> vvclist {get;set;}
    public List<ObjError> Errores {get; set;}

   // public String Message {get; set;}

    private static Integer LimitUpload = 1000;
    
    public Boolean CargaOk {get; set;}
    
    public CTR_VVC_GestionCarga() {
        this.csvFileLines = new String[]{};
        this.vvclist = New List<Registro_Vale_Vista__c>(); 
        this.CargaOk = false;
    }

    public void importCSVFile()
    {
       this.vvclist = new List<Registro_Vale_Vista__c>(); 
       this.Errores = new List<ObjError>();
       if (this.csvFileBody != null)
       {
           try
           {
                csvAsString = csvFileBody.toString();
                csvFileLines = csvAsString.split('\n'); 
                Boolean ErrorRut, ErrorMonto, ErrorFecha;
                Registro_Vale_Vista__c vvcObj ;

                if (csvFileLines.size() > 1)
                {
                    for(Integer i=1;i<csvFileLines.size();i++)
                    {
                        ErrorRut = false;
                        ErrorMonto = false;
                        ErrorFecha = false;

                        vvcObj = new Registro_Vale_Vista__c() ;
                        
                        string[] csvRecordData = csvFileLines[i].split(',');

                        try
                        {
                            String valRut = csvRecordData[0].split('-')[0]+''+csvRecordData[0].split('-')[1];

                            if (RUTUtils.isValid(valRut))
                            {
                                vvcObj.RUT__c = csvRecordData[0];
                            }
                            else
                            {
                                ErrorRut = true;
                            }
                        }
                        catch(Exception ex)
                        {
                            ErrorRut = true;
                        }                    

                        try
                        {
                            vvcObj.Monto__c = Decimal.ValueOf(csvRecordData[1]); 
                        }
                        catch(Exception ex)
                        {
                            ErrorMonto = true;
                        }

                        try
                        {
                            String[] fecha = csvRecordData[2].split('-');
                            vvcObj.Fecha_Vale_Vista__c = date.newInstance(Integer.valueOf(fecha[2]), Integer.valueOf(fecha[1]), Integer.valueOf(fecha[0]));
                        }catch(Exception ex)
                        {
                            ErrorFecha = true;
                        }

                        


                    
                    /* vvcObj.Monto__c = Decimal.ValueOf(csvRecordData[1]); 
                        String[] fecha = csvRecordData[2].split('-');            
                        vvcObj.Fecha_Vale_Vista__c = date.newInstance(Integer.valueOf(fecha[2]), Integer.valueOf(fecha[1]), Integer.valueOf(fecha[0]));
    */
                        vvcObj.Empresa__c = csvRecordData[3];
                        vvcObj.Tipo__c = csvRecordData[4];
                        if (ErrorRut == false && ErrorMonto == false && ErrorFecha == false)
                        {
                            vvclist.add(vvcObj);   
                        }
                        else
                        {
                            ObjError error = new ObjError();
                            error.RUT =  csvRecordData[0];
                            error.Monto =  csvRecordData[1];
                            error.Fecha =  csvRecordData[2];
                            error.Empresa =  csvRecordData[3];
                            error.Tipo =  csvRecordData[4];

                            if (ErrorRut == true)
                            {
                                error.Error = 'El RUT es erróneo.';
                            }
                            
                            if (ErrorMonto == true)
                            {
                                error.Error = 'El Monto es erróneo.';
                            }
                            
                            if (ErrorFecha == true)
                            {
                                error.Error = error.Error =  + 'La Fecha es errónea.';
                            }

                            this.Errores.add(error);
                        }
                    }

                    if (this.vvclist.Size() <= LimitUpload)
                    {//limite de 1000 registros
                    
                        //this.Message = 'Se ha realizado exitosamente la carga de '+vvclist.Size()+' registros encontrados en el archivo csv.';
                        ApexPages.Message message = new ApexPages.Message(ApexPages.severity.INFO,'Se ha encontrado '+vvclist.Size()+' registros válidos en el archivo csv cargado.');
                        ApexPages.addMessage(message);
                        this.CargaOk = true;
                    }
                    else
                    {
                        //this.Message = 'Se ha producido un error al importar datos. Asegúrese de que la cantidad de registros sea menor o igual a '+LimitUpload;
                        ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Se ha producido un error al importar datos. Asegúrese de que la cantidad de registros sea menor o igual a '+LimitUpload);                
                        ApexPages.addMessage(errorMessage);
                    }
                }
                else if (csvFileLines.size() == 1)
                {
                     ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'El archivo seleccionado no tiene infomación asociada.');                
                     ApexPages.addMessage(errorMessage);
                }

                system.debug('@@@@ vvclist: ' + vvclist);
            }
            catch (Exception e)
            {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Se ha producido un error al importar datos. Asegúrese de que el formato del archivo CSV sea el esperado.');
                system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
                ApexPages.addMessage(errorMessage);
                this.CargaOk = false;
            }  
       }
       else
       {
           ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Se ha producido un error al importar datos. Debe seleccionar un archivo CSV válido.');    
           ApexPages.addMessage(errorMessage);
           this.CargaOk = false;
       }       
    }

    public String CreateNewUpload()
    {
        try
        {
            Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
            insert carga;
            return carga.Id;
        }
        catch(Exception e)
        {
            system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
            return '';
        }
    }

    public void RefreshTotalCarga(String Id, Integer total, Integer ok, Integer error)
    {
        try
        {
            Carga_Vale_Vista__c carga = [SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c,
            OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM Carga_Vale_Vista__c
            Where Id=: Id];
        
            carga.Total_Registros_Carga__c = total;
            carga.Total_Registros_Ok__c = ok;
            carga.Total_Registros_Error__c = error;

            update carga;
        }
        catch (Exception e)
        {
            system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
        }

    }
    

    public void ProcessUpload()
    {

        String IdCarga = this.CreateNewUpload();

            system.debug('@@@@ IdCarga: ' + IdCarga);
            Integer total = this.vvclist.Size();
            Integer ok = 0;
            Integer error = 0;
            Set<String> accountsRUT = new Set<String>();
            if (IdCarga != '')
            {
                try
                {                        
                    for (Registro_Vale_Vista__c vvcObj : this.vvclist)
                    {
                        vvcObj.Carga_Vale_Vista__c = IdCarga;
                        accountsRUT.add(vvcObj.RUT__c.Split('-')[0]);
                        //marcar todos como erroneos
                        vvcObj.Es_Notificable__c = false; 
                        error++;
                        vvcObj.Resultado__c = 'RUT no se encuentra registrado.';
                    }    

                    system.debug('@@@@ accountsRUT: ' + accountsRUT);
                    
                    Map<String, Account> accountMap = new Map<String, Account>([SELECT Id, Name, LastName, FirstName, IsPersonAccount, PersonEmail, Rut__c, dv__c, Razon_Social__c FROM Account
                                            WHERE Rut__c IN: accountsRUT]);

                    system.debug('@@@@ accountMap: ' + accountMap);

                    Map<String, String> DataMap = new Map<String, String>();

                    for (Account account : accountMap.values()){
                        DataMap.put(account.Rut__c, account.PersonEmail+'#'+account.Id);
                    }

                    system.debug('@@@@ DataMap: ' + DataMap);

                    for (Registro_Vale_Vista__c vvcObj : this.vvclist)
                    {
                        String data = DataMap.get(vvcObj.RUT__c.Split('-')[0]);

                        if (data != null)
                        {
                            system.debug('@@@@ data: ' + data);
                            String[] values = data.split('#');
                           
                            system.debug('@@@@ values: ' + values);
                            system.debug('@@@@ values[0]: ' + values[0]);
                            system.debug('@@@@ values[1]: ' + values[1]);
                            
                            vvcObj.Cuenta__c = values[1];
                            
                            if (values[0] != 'null')
                            {
                                vvcObj.Email__c = values[0];
                                vvcObj.Es_Notificable__c = true;
                                vvcObj.Resultado__c = 'Carga OK';
                                ok++;
                                error--;
                            }
                            else
                            {
                                vvcObj.Resultado__c = 'RUT no posee correo registrado.';
                            }
                        }
                        
                    }

                    //upsert vvclist;
                    insert vvclist;

                    RefreshTotalCarga(IdCarga, total, ok, error);

                    BAT_NotificacionValeVista myBatchObject = new BAT_NotificacionValeVista(IdCarga);
                    Id batchId = Database.executeBatch(myBatchObject);

                }
                catch(Exception e)
                {
                    system.debug('@@@@ error: ' + e.getMessage()+'   line: '+ e.getLineNumber());                    
                }
                
             
            }
            else
            {
                ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Se ha producido un error al Procesar la Carga, no se ha creado identificador asociado.');                
                ApexPages.addMessage(errorMessage);
                
            }    
        

    }

    public Pagereference CancelUpload()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_VVC_CargaArchivoCsv');
        page.setRedirect(true);
        return page;         
    }

    
    public Pagereference ToHistorial()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_VVC_HistorialCargas');
        page.setRedirect(true);
        return page;         
    }
   
/*
    public ApexPages.StandardSetController con {
        
		get {
           // String IdCarga = 'a1MP0000000xhYUMAY';//apexpages.currentpage().getparameters().get('id');
			if(con == null) {
				con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, RUT__c, Monto__c, Fecha_Vale_Vista__c, Empresa__c, Tipo__c, Notificado__c, Carga_Vale_Vista__c, Resultado__c,
                                Tms_Notificacion__c, Cuenta__c FROM Registro_Vale_Vista__c   ]));                  
                                //WHERE Carga_Vale_Vista__c =: IdCarga]));
				// sets the number of records in each page set
				con.setPageSize(5);
			}
			return con;
		}
		set;
	}*/

    
}