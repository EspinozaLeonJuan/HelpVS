/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-25-2020   Juan Espinoza León   Initial Version
**/
public with sharing class CTR_TV_HistorialCargas {

    public Date FechaInicio {get; set;}

    public Date FechaTermino {get; set;}

    public Boolean FError {get; set;}

    public String CampagnaId {get; set;}

    public String Estado {get; set;}

    /* Paginacion */

    public integer OffsetSize = 0;
    private integer LimitSize= 15;
    
    public integer TotalRecs {get; set;}
    
    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}

    public List<Carga_Televenta__c> lista {get; set;}

    /* Paginacion */

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

    public CTR_TV_HistorialCargas() {
 
    }

    public List<Selectoption> getListarCampagnas(){
        try{
            List<Selectoption> LST_Cmps = new List<Selectoption>();
            
            LST_Cmps.add(new Selectoption('All','Todas'));
            
            List<Campaign> cmp_nativas = [SELECT Id, Name FROM Campaign ORDER BY CreatedDate DESC];

            for(Campaign c : cmp_nativas)
            {
                LST_Cmps.add(new Selectoption(c.Id, c.Name));
            }
            
            return LST_Cmps;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<Selectoption> getListarEstados(){
        try{
            List<Selectoption> LST_Estados= new List<Selectoption>();
            
            LST_Estados.add(new Selectoption('All','Todos'));
            LST_Estados.add(new Selectoption('CREADA','CREADA'));
            LST_Estados.add(new Selectoption('EN PROCESO','EN PROCESO'));
            LST_Estados.add(new Selectoption('COMPLETADA','COMPLETADA'));
            LST_Estados.add(new Selectoption('CANCELADA','CANCELADA'));
           
            return LST_Estados;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public Pagereference ListadoCargas(){
        try
        {
            this.FechaInicio = Date.today().addMonths(-1);//1 mes
            this.FechaTermino = Date.today();
            
            this.FError= false;

            this.totalRecs = [SELECT count() FROM Carga_Televenta__c WHERE  CreatedDate >: FechaInicio AND CreatedDate <=: FechaTermino];
           
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
        }
        catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }

        return null;
    }

    public List<Carga_Televenta__c> getctvlist()
    {
        DateTime dateIni = DateTime.newInstance(this.FechaInicio.year(), this.FechaInicio.month(), this.FechaInicio.day(), 0, 0, 0);
        String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        DateTime dateTer = DateTime.newInstance(this.FechaTermino.year(), this.FechaTermino.month(), this.FechaTermino.day(), 23,59, 59);
        String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
        //List<Carga_Televenta__c> 
        this.lista  = new  List<Carga_Televenta__c>();
        system.debug('@@@@ CampagnaId --> '+this.CampagnaId );
        String query = '', queryAll = '';
        if (String.isBlank(this.CampagnaId) || this.CampagnaId == 'All')
        {
            if (String.isBlank(this.Estado) || this.Estado == 'All')
            {
                query = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  CreatedDate >'+ format_DateIni+ ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC LIMIT '+ this.LimitSize+ ' OFFSET ' +  this.OffsetSize;

                queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  CreatedDate >'+ format_DateIni+ ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC';
            }
            else
            {
                query = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC LIMIT '+ this.LimitSize+ ' OFFSET ' +  this.OffsetSize;

                queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC ';
            }
        }
        else 
        {

            if (String.isBlank(this.Estado) || this.Estado == 'All')
            {
                query = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC LIMIT '+ this.LimitSize+ ' OFFSET ' +  this.OffsetSize;

                queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC';
            }
            else
            {
                query = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC LIMIT '+ this.LimitSize+ ' OFFSET ' +  this.OffsetSize;

                queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC';
            }
        }

        system.debug('@@@@ QUERY --> ' + query);

        if (String.isNotBlank(query))
        {
            this.lista = Database.query(query);
        }
        
        return this.lista;
    }

    public Pagereference NuevaCargaDatos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_TV_Carga_Campagna');
        page.setRedirect(true);
        return page;  
        
    }

    public PageReference ToDetalleCarga()
    {
        String Id = apexpages.currentpage().getparameters().get('id');
        String Estado = apexpages.currentpage().getparameters().get('Estado');
        PageReference page;

        system.debug('@@@@ Estado '+Estado);
        if (Estado == 'CREADA')
        {
            page = new PageReference('/apex/SEC_VF_TV_Carga_Campagna_Result');
            page.getParameters().put('Id', Id);    
            page.getParameters().put('Reprocesar', 'false'); 
        }
        else if (Estado == 'EN PROCESO')
        {
            page = new PageReference('/apex/SEC_VF_TV_Carga_Campagna_Result');
            page.getParameters().put('Id', Id);    
            page.getParameters().put('Reprocesar', 'true'); 
        }
        else if (Estado == 'COMPLETADA')
        {
            page = new PageReference('/apex/SEC_VF_TV_Carga_Detalle_Ok');
            page.getParameters().put('id', Id);  
            page.getParameters().put('page', 'OK');
        }
        else if (Estado == 'CANCELADA')
        {
            page = new PageReference('/apex/SEC_VF_TV_Carga_Detalle_Ok');
            page.getParameters().put('id', Id);  
            page.getParameters().put('page', 'OK');
        }

        page.setRedirect(true);

        return page;
    }

    public void search()
    {
        if (FechaTermino <= FechaTermino)
        {
            String queryAll = '';

            DateTime dateIni = DateTime.newInstance(this.FechaInicio.year(), this.FechaInicio.month(), this.FechaInicio.day(), 0, 0, 0);
            String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            DateTime dateTer = DateTime.newInstance(this.FechaTermino.year(), this.FechaTermino.month(), this.FechaTermino.day(), 23,59, 59);
            String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            if (String.isBlank(this.CampagnaId) || this.CampagnaId == 'All')
            {
                if (String.isBlank(this.Estado) || this.Estado == 'All')
                {
                     queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                    'WHERE  CreatedDate >'+ format_DateIni+ ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC';
                }
                else
                {
                    queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                    'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' ORDER BY CreatedDate DESC ';
                }
            }
            else 
            {
    
                if (String.isBlank(this.Estado) || this.Estado == 'All')
                {
                    queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                    'WHERE  CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC';
                }
                else
                {
                    queryAll = 'SELECT Id, OwnerId, IsDeleted, Campagna_Name__c, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Prospectos_Ok__c, CreatedDate, LastModifiedDate, Email_Notificacion__c, Estado__c FROM Carga_Televenta__c '+
                    'WHERE  Estado__c = \''+this.Estado+'\' AND CreatedDate >'+ format_DateIni + ' AND CreatedDate <= ' + format_DateTer +' AND Campagna__c = \''+ this.CampagnaId+'\'' +' ORDER BY CreatedDate DESC';
                }
            }

            if (String.isNotBlank(queryAll))
            {
                List<Carga_Televenta__c> listAll = Database.query(queryAll);
                this.totalRecs = listAll.size();
                   
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
            }

        }
        else
        {
            FError = true;
        }
    }

    public Pagereference cleanSearch()
    {
       PageReference page = new PageReference('/apex/SEC_VF_TV_Historial_Cargas');
       page.setRedirect(true);
       return page;
    }
}