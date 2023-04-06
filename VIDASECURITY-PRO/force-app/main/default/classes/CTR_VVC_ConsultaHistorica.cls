public class CTR_VVC_ConsultaHistorica {

    public integer OffsetSize = 0;

    public integer LimitSize= 20;

    public integer totalRecs {get; set;}

    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}

    public String IdCarga {get; set;}

    public Task FDate {get; set;}

    public Boolean FError {get; set;}

    public String RutCliente {get; set;}

    public String Notificado {get; set;}

    public String EstadoValeVista {get; set;}

    public String EstadoCarga {get; set;}

    public Carga_Vale_Vista__c CargaVVC {get; set;}    

    public CTR_VVC_ConsultaHistorica() {

    }

    public List<Registro_Vale_Vista__c> getvvclist()
    {
        if (this.OffsetSize > 2000)
        {
            this.OffsetSize = 2000;
        }

        
                    String query = 'SELECT Id, Name, RUT__c, Monto__c, Fecha_Vale_Vista__c, Empresa__c, Tipo__c, Notificado__c, Carga_Vale_Vista__c, Resultado__c,' +
                        'Tms_Notificacion__c, Cuenta__c, Es_Notificable__c FROM Registro_Vale_Vista__c WHERE Fecha_Vale_Vista__c > ' +   String.valueOf(FDate.Fecha_de_Llamada__c)+' AND Fecha_Vale_Vista__c <= ' +   String.valueOf(FDate.Fecha_de_Cierre__c.addDays(1));
                        String orderby = 'ORDER BY Fecha_Vale_Vista__c DESC LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

                    String queryRut = EvaluaRutCliente();
                    String queryEstadoVVC = EvaluaEstadoValeVista();
                    String queryEstadoCarga = EvaluaEstadoCarga();
                    String queryNotificacion = EvaluaNotificacion();

                    String fullQuery = query + queryRut + queryEstadoVVC + queryEstadoCarga + queryNotificacion +' '+ orderby;
                    System.debug('@@@@ fullQuery'+ fullQuery);
/*
 List<Registro_Vale_Vista__c> lista = [SELECT Id, Name, RUT__c, Monto__c, Fecha_Vale_Vista__c, Empresa__c, Tipo__c, Notificado__c, Carga_Vale_Vista__c, Resultado__c,
                        Tms_Notificacion__c, Cuenta__c FROM Registro_Vale_Vista__c                     
                        WHERE Carga_Vale_Vista__c =: this.IdCarga AND Fecha_Vale_Vista__c >: FDate.Fecha_de_Llamada__c 
                        AND Fecha_Vale_Vista__c <=: FDate.Fecha_de_Cierre__c.addDays(1)

                        
                        AND (RUT__C =: this.RutCliente )

                        ORDER BY Fecha_Vale_Vista__c DESC LIMIT :LimitSize OFFSET : OffsetSize]; 
*/
         List<Registro_Vale_Vista__c> lista = Database.query(fullQuery);
         return lista;
    }

    public List<Selectoption> getEstadosValeVista()
    {
        try{
            List<Selectoption> LST_Estado = new List<Selectoption>();

            LST_Estado.add(new Selectoption('Todos','Todos'));
            LST_Estado.add(new Selectoption('PENDIENTE','PENDIENTE'));
            LST_Estado.add(new Selectoption('CADUCADO','CADUCADO'));  

            return LST_Estado;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<Selectoption> getEstadosCarga()
    {
        try{
            List<Selectoption> LST_Estado = new List<Selectoption>();

            LST_Estado.add(new Selectoption('Todos','Todos'));
            LST_Estado.add(new Selectoption('Carga Ok','Carga Ok'));
            LST_Estado.add(new Selectoption('Error','Error'));  

            return LST_Estado;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<Selectoption> getNotificaciones()
    {
        try{
            List<Selectoption> LST_Estado = new List<Selectoption>();

            LST_Estado.add(new Selectoption('Todos', 'Todos'));
            LST_Estado.add(new Selectoption('Notificado por Correo', 'Notificado por Correo'));
            LST_Estado.add(new Selectoption('No notificado por Correo', 'No notificado por Correo'));  

            return LST_Estado;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public String EvaluaRutCliente()
    {
        String queryRut = '';
        String queryEstadoVVC = '';
        String queryEstadoCarga = '';
        String queryNotificacion = '';

       /* if (this.RutCliente == 'null')
        {
            this.RutCliente = '';
        }*/
        

        if (String.isBlank(this.RutCliente) == false)
        {
            queryRut =  ' AND RUT__c =  \''+this.RutCliente+ '\' ';
        }

        return queryRut;
    }

    public String EvaluaEstadoValeVista()
    {
        String queryEstadoVVC = '';

        if (this.EstadoValeVista != 'Todos')
        {
            queryEstadoVVC =  ' AND Tipo__c =  \''+this.EstadoValeVista+ '\' ';
        }

        return queryEstadoVVC;
    }

    public String EvaluaEstadoCarga()
    {
        String queryEstadoCarga = '';

        if (this.EstadoCarga == 'Carga Ok')
        {
            queryEstadoCarga =  ' AND Es_Notificable__c =  true';
        }
        else if (this.EstadoCarga == 'Error')
        {
            queryEstadoCarga =  ' AND Es_Notificable__c =  false';
        }

        return queryEstadoCarga;
    }

    public String EvaluaNotificacion()
    {
        String queryNotificacion = '';
       
        if (this.Notificado == 'Notificado por Correo')
        {
            queryNotificacion =  ' AND Notificado__c =  true';
        }
        else if (this.Notificado == 'No notificado por Correo')
        {
            queryNotificacion =  ' AND Notificado__c =  false';
        }

        return queryNotificacion;
    }

    public Pagereference LoadDetalleCarga()
    {
        try
        {        
            this.EstadoCarga = 'Todos';
            this.EstadoValeVista = 'Todos';
            this.Notificado = 'Todos';
            this.RutCliente = '';
        
            if(this.IdCarga != ''){

                FDate = new Task();
                FDate.Fecha_de_Llamada__c = Date.today().addMonths(-1);
                FDate.Fecha_de_Cierre__c = Date.today();
                FError= false;

                String queryCount = 'SELECT Id FROM Registro_Vale_Vista__c WHERE Fecha_Vale_Vista__c >' +   String.valueOf(FDate.Fecha_de_Llamada__c)+
                ' AND Fecha_Vale_Vista__c <=' + String.valueOf(FDate.Fecha_de_Cierre__c.addDays(1))+ ' LIMIT 2000';

                List<Registro_Vale_Vista__c> lista = Database.query(queryCount);
                totalRecs = lista.Size();

                system.debug('@@@@  totalRecs '+totalRecs);

                OffsetSize = 0;   
                FError = false; 
                Page = 1;

                Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
                this.TotalPage = totalRecs / LimitSize;

                if(totalrecs > range)
                {
                    this.TotalPage++;
                }

                return null;
            }else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }catch(Exception e){
            system.debug('@@@@ EXCEPCION: ' + e.getMessage() + '; LINEA: ' + e.getLineNumber());
            ApexPages.addMessages(e);
            return null;
        }
        
    }

    public Pagereference ToHistorial()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_VVC_HistorialCargas');
        page.setRedirect(true);
        return page;         
    }

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

        if(totalrecs > OffsetSize)
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
                String queryCount = 'SELECT Id FROM Registro_Vale_Vista__c WHERE Fecha_Vale_Vista__c >' +   String.valueOf(FDate.Fecha_de_Llamada__c)+
                ' AND Fecha_Vale_Vista__c <=' + String.valueOf(FDate.Fecha_de_Cierre__c.addDays(1));

                String queryRut = EvaluaRutCliente();
                String queryEstadoVVC = EvaluaEstadoValeVista();
                String queryEstadoCarga = EvaluaEstadoCarga();
                String queryNotificacion = EvaluaNotificacion();

                String fullQuery = queryCount + queryRut + queryEstadoVVC + queryEstadoCarga + queryNotificacion + ' LIMIT 2000';

                List<Registro_Vale_Vista__c> lista = Database.query(fullQuery);
                totalRecs = lista.Size();

            system.debug('@@@@  totalRecs '+totalRecs);
         //   totalRecs = [SELECT count() FROM Registro_Vale_Vista__c WHERE Carga_Vale_Vista__c =: this.IdCarga 
           //     AND Fecha_Vale_Vista__c >: FDate.Fecha_de_Llamada__c AND Fecha_Vale_Vista__c <=: FDate.Fecha_de_Cierre__c.addDays(1)];

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
       PageReference page = new PageReference('/apex/SEC_VF_VVC_ConsultaHistorica?id='+this.IdCarga);
       page.setRedirect(true);
       return page;
    }

    
}