/**
 * @File Name          : CTR_VVC_HistorialCargas.cls
 * @Description        : 
 * @Author             : Consultor Salesforce Vida
 * @Group              : 
 * @Last Modified By   : Consultor Salesforce Vida
 * @Last Modified On   : 5/25/2019, 1:36:21 AM
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/22/2019, 1:59:17 PM   Consultor Salesforce Vida     Initial Version
**/
public class CTR_VVC_HistorialCargas {

    //public List<Carga_Vale_Vista__c> LST_Upload_VVCs {get; set;}

    public integer OffsetSize = 0;
    private integer LimitSize= 20;
    
    public integer totalRecs {get; set;}
    
    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}

    public Task FDate {get; set;}

    public Boolean FError {get; set;}
    
    public Pagereference ListadoCargas(){
        try
        {
            FDate = new Task();
            FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
            FDate.Fecha_de_Cierre__c = Date.today();
            FError= false;

            totalRecs = [SELECT count() FROM Carga_Vale_Vista__c WHERE  CreatedDate >: FDate.Fecha_de_Llamada__c AND CreatedDate <=: FDate.Fecha_de_Cierre__c.addDays(1)];
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }

           /* this.LST_Upload_VVCs = [SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c,
            OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM Carga_Vale_Vista__c
            ORDER BY CreatedDate DESC];*/

            system.debug('@@ Fecha_de_Llamada__c => ' + FDate.Fecha_de_Llamada__c );
            system.debug('@@ Fecha_de_Cierre__c => ' + FDate.Fecha_de_Cierre__c );
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }

        return null;
    }

    public List<Carga_Vale_Vista__c> getcvvlist()
    {
        /* List<Carga_Vale_Vista__c> lista = Database.Query('SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM Carga_Vale_Vista__c '+
         'WHERE  CreatedDate >: '+dFechaInicio+' AND CreatedDate <=: '+dFechaTermino +' ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize');
        */

         List<Carga_Vale_Vista__c> lista = [SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Registros_Notificados__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM Carga_Vale_Vista__c 
         WHERE  CreatedDate >: FDate.Fecha_de_Llamada__c AND CreatedDate <=: FDate.Fecha_de_Cierre__c.addDays(1) ORDER BY CreatedDate DESC LIMIT :LimitSize OFFSET : OffsetSize];

         system.debug('@@@@ QUERY --> '+ 'SELECT Id, Total_Registros_Carga__c, Total_Registros_Error__c, Total_Registros_Ok__c, Total_Registros_Notificados__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp FROM Carga_Vale_Vista__c '+
         'WHERE  CreatedDate > '+ FDate.Fecha_de_Llamada__c +' AND CreatedDate <= '+ FDate.Fecha_de_Cierre__c.addDays(1));
         return lista;
    }

    public Pagereference NuevaCargaDatos()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_VVC_CargaArchivoCsv');
        page.setRedirect(true);
        return page;  
        
    }

    public PageReference ToDetalleCarga()
    {
        String ID = apexpages.currentpage().getparameters().get('id');
        PageReference page = new PageReference('/apex/SEC_VF_VVC_DetalleCarga?id='+ID);
        page.setRedirect(true);

        return page;
    }

    public PageReference ToConsultaHistorica()
    {
        PageReference page = new PageReference('/apex/SEC_VF_VVC_ConsultaHistorica');
        page.setRedirect(true);

        return page;
    }
/*
    public Pagereference TestPagination()
    {
        String ID = 'a1MP0000000xhYUMAY';
        //String ID = apexpages.currentpage().getparameters().get('id');
        PageReference page = new PageReference ('/apex/TEST_Pagination?id='+ID);
        page.setRedirect(true);
        return page;         
    }
    */

    public void FirstPage()
    {
         OffsetSize = 0;
         Page = 1;
    }

    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        Page--;
    }

    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        Page++;
    }

    public void LastPage()
    {
        OffsetSize = totalrecs - Math.mod(totalRecs,LimitSize);
        Page = totalRecs / LimitSize;

        if(totalrecs >= OffsetSize)
        {
             Page++;
        }
        
        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ totalrecs '+ totalrecs);
        system.debug('@@@@ Page '+ Page);
    }


    public boolean getprev()
    {
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
        if((OffsetSize + LimitSize) > totalRecs)
            {
            return true;
        }            
        else
        {
            return false;
        }
    }

    public void search()
    {
        if (FDate.Fecha_de_Llamada__c <= FDate.Fecha_de_Cierre__c)
        {
            totalRecs = [SELECT count() FROM Carga_Vale_Vista__c WHERE  CreatedDate >: FDate.Fecha_de_Llamada__c AND CreatedDate <=: FDate.Fecha_de_Cierre__c.addDays(1)];
            OffsetSize = 0;   
            FError = false; 
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }
        }
        else
        {
            FError = true;
        }
    }

    public Pagereference cleanSearch()
    {
       PageReference page = new PageReference('/apex/SEC_VF_VVC_HistorialCargas');
       page.setRedirect(true);
       return page;
    }
}