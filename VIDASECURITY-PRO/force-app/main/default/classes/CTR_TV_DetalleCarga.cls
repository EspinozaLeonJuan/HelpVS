/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-28-2020   Juan Espinoza León   Initial Version
**/
public with sharing class CTR_TV_DetalleCarga {

    public String IdCarga {get; set;}

    public String TipoCMP {get; set;}

    public String IdCampagna {get; set;}

    public String Total_Registros_Carga {get; set;}

    public String Total_Registros_Ok {get; set;}

    public String Total_Registros_Error {get; set;}

    public String Total_Prospectos_Ok {get; set;}

    public List<Registro_Carga_Televenta__c> RegistrosOK {get; set;}

    public List<Registro_Carga_Televenta__c> RegistrosError {get; set;}

    public Carga_Televenta__c Carga {get; set;}

    public Boolean Reprocesar {get; set;}
 
    public Boolean RValidos {get; set;}

    public Boolean RInvalidos {get; set;}

    public String RecordTypeIdProspecto = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Televenta Oncológico'].Id;

    public String TipoCampagna {get; set;}

     /*Paginación*/
     public integer OffsetSize = 0;

     public integer LimitSize= 50;
         
     public integer totalRecs {get; set;}
     
     public Integer Page {get; set;}
 
     public Integer TotalPage {get; set;}
     /*Paginación*/
 
     /*Paginación*/
     public void FirstPage()
     {
          OffsetSize = 0;
          Page = 1;
 
 
     }
 
     public void previous()
     {
         OffsetSize = OffsetSize - LimitSize;
         Page--;
 
         system.debug('@@@@  previous OffsetSize --> '+ OffsetSize);
         system.debug('@@@@  previous Page --> '+ Page); 
     }
 
     public void next()
     {
         OffsetSize = OffsetSize + LimitSize;
         Page++;
 
     
         system.debug('@@@@  next OffsetSize --> '+ OffsetSize);
         system.debug('@@@@  next Page --> '+ Page); 
     }
 
     public void LastPage()
     {
         OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
         Page = this.TotalPage;
        /* if(totalrecs > OffsetSize)
         {
              Page++;
         }*/
 
         if (OffsetSize == totalrecs)
         {
             OffsetSize = totalrecs -   LimitSize;
         }
 
         system.debug('@@@@ OffsetSize '+ OffsetSize);
         system.debug('@@@@ totalrecs '+ totalrecs);
         system.debug('@@@@ Page '+ Page);
     }
 
 
     public boolean getprev()
     {
         system.debug('@@@@ OffsetSize '+ OffsetSize);
     system.debug('@@@@ Page '+ Page);
         
         if(OffsetSize == 0)
         {
             return true;
         }            
         else
         {
             return false;
         }            
 
         
     }
     
     public boolean getnxt()
     {
         system.debug('@@@@ OffsetSize '+ OffsetSize);
         system.debug('@@@@ LimitSize '+ LimitSize);
         system.debug('@@@@ totalrecs '+ totalrecs);
         system.debug('@@@@ Page '+ Page);
 
         if((OffsetSize + LimitSize) >= totalRecs)
         {
             return true;
         }            
         else
         {
             return false;
         }
 
        
     }
 
     
     /*Paginación*/

    public CTR_TV_DetalleCarga() {
 
    }
 
    public void IniciaDetalle()
       {
            this.IdCarga = apexpages.currentpage().getparameters().get('id');
            String Pagina = apexpages.currentpage().getparameters().get('page');
      
            this.RValidos = false;
            this.RInvalidos = false;
            this.Reprocesar = false;

            this.Carga = [SELECT Id, Campagna_Name__c, Tipo__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, Email_Notificacion__c, Estado__c, Campagna__c, Ejecutivos__c, Producto__c, Tipo_Campagna__c, IsActive__c, EndDate__c, CreatedDate FROM Carga_Televenta__c WHERE Id=: this.IdCarga];

            this.TipoCMP = this.Carga.Tipo__c;
            this.IdCampagna = this.Carga.Campagna__c;

            this.RegistrosOK = [SELECT Id, RUT__c, DV__c, TELEFONO_1__c, TELEFONO_2__c,TELEFONO_3__c,TELEFONO_4__c,TELEFONO_5__c,TELEFONO_6__c,TELEFONO_7__c,TELEFONO_8__c, AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, EMAILTEST__c, Carga_Televenta__c, ErrorCarga__c, CORREOENVIADO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: this.IdCarga AND ErrorCarga__c = false];

            this.RegistrosError = [SELECT Id, RUT__c, DV__c, TELEFONO_1__c, TELEFONO_2__c,TELEFONO_3__c,TELEFONO_4__c,TELEFONO_5__c,TELEFONO_6__c,TELEFONO_7__c,TELEFONO_8__c, AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, EMAILTEST__c, Carga_Televenta__c, ErrorCarga__c, CORREOENVIADO__c, ErrorDetalle__c, CreatedDate, CampaignMemberId__c FROM Registro_Carga_Televenta__c WHERE Carga_Televenta__c =: this.IdCarga AND ErrorCarga__c = true];

            if (Pagina == 'OK')
            {
                totalRecs = this.RegistrosOK.Size();
            }
            else if (Pagina == 'ERROR')
            {
                totalRecs = this.RegistrosError.Size();
            }
             
    
             OffsetSize = 0;   
             Page = 1;
      
             Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
             this.TotalPage = totalRecs / LimitSize;
      
             if(totalrecs > range)
             {
                 this.TotalPage++;
             }       
      
             if (this.TotalPage == 0)
             {
                 this.Page = 0;
             } 
      
            system.debug('@@@@ totalRecs --> '+ totalRecs);
            system.debug('@@@@ range --> '+ range);
            system.debug('@@@@ TotalPage --> '+ TotalPage);
            system.debug('@@@@ Page --> '+ Page); 

            this.Total_Registros_Carga = String.valueOf(this.RegistrosOK.size()+this.RegistrosError.size());
            this.Total_Registros_Error = String.valueOf(this.RegistrosError.size());
            this.Total_Registros_Ok = String.valueOf(this.RegistrosOK.size());
            this.TipoCampagna = this.Carga.Tipo_Campagna__c ;

            if (this.RegistrosOK.size() == 0)
            {
                this.Total_Prospectos_Ok = '0';
            }

           if (this.RegistrosOK.size() > 0)
           {
              this.RValidos = true;
           }

           if (this.RegistrosError.size() > 0)
           {
              this.RInvalidos = true;
           }

           if (this.Carga.Estado__c == 'PROCESADA')
           {
                this.Total_Prospectos_Ok = '-';
                this.Reprocesar = true;
           }
           else if (this.Carga.Estado__c == 'GESTIONADA')
           {
               this.Total_Prospectos_Ok = this.Total_Registros_Ok;   
           }
           else if (this.Carga.Estado__c == 'CANCELADA')
           {
               this.Total_Prospectos_Ok = '0';
           }
       }

    public Pagereference ToHistory()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page;  
    }

    public Pagereference CancelGestion()
    {
        Carga_Televenta__c c = [SELECT Id, Estado__c, Total_Prospectos_Ok__c FROM Carga_Televenta__c WHERE Id =: this.Carga.Id];
        c.Estado__c = 'CANCELADA';
        c.Total_Prospectos_Ok__c = 0;
        update c;
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Historial_Cargas');
        page.setRedirect(true);
        return page; 
    }

    public List<Registro_Carga_Televenta__c> getData_DOK()
    {
        String query = 'SELECT CORREOENVIADO__c, DV__c, EMAILTEST__c,  Id, RUT__c, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c, '+
        'AccountId__c, ContactId__c, LeadId__c, POLIZA_MANDATORIA__c, Carga_Televenta__c, ErrorCarga__c, CreatedDate, CampaignMemberId__c,'+
        'APELLIDO_PROSPECTO__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c,'+
        ' INTERMEDIARIO_POLIZA__c, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c '+
        'FROM Registro_Carga_Televenta__c WHERE ErrorCarga__c = false AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
      
        system.debug('@@@@  query --> '+ query); 
        List<Registro_Carga_Televenta__c> lista = Database.query(query);

        return lista;
    }

    public List<Registro_Carga_Televenta__c> getData_DError()
    {
        String query = 'SELECT CORREOENVIADO__c, DV__c, EMAILTEST__c,  Id,  POLIZA_MANDATORIA__c, RUT__c, TELEFONO_1__c, TELEFONO_2__c, TELEFONO_3__c, TELEFONO_4__c, TELEFONO_5__c, TELEFONO_6__c, TELEFONO_7__c, TELEFONO_8__c, ErrorDetalle__c, CreatedDate, '+
        'APELLIDO_PROSPECTO__c, CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c, DV_CONTRATANTE_ORIGINAL__c, DV_PROSPECTO__c, EMAIL__c,  FECHA_INICIO_VIGENCIA_PROSPECTO__c, FECHA_NACIMIENTO_PROSPECTO__c,'+
        ' INTERMEDIARIO_POLIZA__c, NOMBRE_PROSPECTO__c, PLAN_COBERTURA__c, POLIZA_CONTRATANTE_ORIGINAL__c, RUT_CONTRATANTE_ORIGINAL__c, RUT_PROSPECTO__c,  TELEFONO__c '+
        'FROM Registro_Carga_Televenta__c WHERE ErrorCarga__c = true AND Carga_Televenta__c =\'' + this.IdCarga + '\' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;
      
        system.debug('@@@@  query --> '+ query); 
        List<Registro_Carga_Televenta__c> lista = Database.query(query);

        return lista;
    }

    public Pagereference RegistrosValidos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Detalle_Ok');
        page.getParameters().put('id', this.IdCarga);  
        page.getParameters().put('page', 'OK');
        page.setRedirect(true);
        return page;
    }

    public Pagereference RegistrosInvalidos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Detalle_Error');
        page.getParameters().put('id', this.IdCarga);  
        page.getParameters().put('page', 'ERROR');
        page.setRedirect(true);
        return page;
    }
}