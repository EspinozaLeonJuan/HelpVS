/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_CV_Casos        															|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Permite listar y administrar los casos de tipo Solicitud que han sioo creados  | 
 |                           por el usuario.                                                                |
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public class CTR_CV_Casos {
 

      /*Paginación*/
    public integer OffsetSize = 0;
    
    public integer LimitSize= 15;
    
    public integer totalRecs {get; set;}
    
    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}
    /*Paginación*/

    public String CurrentPage {get; set;}

    public String MensajePopup {get; set;}

    public String NumeroCaso {get; set;}

    public String Estado {get; set;}

    public String Solicitud {get; set;}

    public String Poliza {get; set;}
    
    public String RUT { get; set; }   

    public String Tipo {get; set;}

    public String Propuesta {get; set;}

    public String SOQL_IDs {get; set;}

    public Boolean SIN_DATA {get; set;}

    public List<Case> CasosUPD {get; set;}

    public String RutUsuario {get; set;}

    public String Categoria {get; set;}

    public String Procedencia {get; set;}

    public Case FiltroCaso {get; set;}

    public Date FechaInicio {get; set;}

    public Date FechaTermino {get; set;}

    public String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
    /*Paginación*/
    public void FirstPage()
    {
         OffsetSize = 0;
         Page = 1;
         system.debug('@@@@ Page FirstPage'+ Page);
    }
 
    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        Page = Page - 1;
        system.debug('@@@@ Page previous'+ Page);
    }

    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        Page = Page + 1;
        system.debug('@@@@ Page next '+ Page);
    }

    public void LastPage()
    {
        OffsetSize = totalrecs - Math.mod(totalRecs, LimitSize);
        Page = totalRecs / LimitSize;

        if(totalrecs > OffsetSize)
        {
             Page = Page + 1;
        }

        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ totalrecs '+ totalrecs);
        system.debug('@@@@ Page  '+ Page);
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
    /*Paginación*/

    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryCasos(String qlimit)
    {
        try{

            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C,  Canal__c, CreatedDate, Tipo_de_Requerimiento__c, Agente__c, Supervisor__c, Numero_Propuesta__c, '+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, '+
            'EsNoCliente__c, Id_Usuario_Creacion__c, CASO_Responsable_UR__c FROM Case';

            //String qwhere = ' WHERE Id_Usuario_Creacion__c = '' AND RVentas__c =  true ';
           // String qwhere = ' WHERE ';

            String qwhere = ' WHERE RecordTypeId = \''+this.IdTipoRegistro +'\' AND RVentas__c =  true ';

            String qestado = '';

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else 
                if (this.Estado == 'En Proceso')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c = null )';
                }
                else{
                    qestado = ' AND (Status = \''+ this.Estado +'\' ) ';                    
                }
            }

            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z';    

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
            }
            
            String qrut = '';
            if (String.isNotBlank(this.RUT) == true)
            {
                qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
            }

            String qnumeroPoliza = '';

            if (String.isNotBlank(this.Poliza) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
            }

            String qnumeroPropuesta = '';

            if (String.isNotBlank(this.Propuesta) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
            }

            String qnegocio = '';
            
            if (String.isNotBlank(this.FiltroCaso.Negocio__c))
            {
                qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
            }

            String qcategoria = '';
            if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
            {
                qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
            }

            String qsolicitud = '';

            if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
            {
                 qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
            }

            system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
            system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
            system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);

            String qorden = ' ORDER BY CreatedDate DESC';

            String queryFull = query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qnegocio + qcategoria + qsolicitud;

            return queryfull +  qorden + qlimit;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }

     /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryMisCasos(String qlimit)
    {
        try{

            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C,  Canal__c, CreatedDate, Tipo_de_Requerimiento__c, Agente__c, Supervisor__c, Numero_Propuesta__c, '+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, '+
            'EsNoCliente__c, Id_Usuario_Creacion__c, CASO_Responsable_UR__c FROM Case';

            //String qwhere = ' WHERE Id_Usuario_Creacion__c = '' AND RVentas__c =  true ';
            String qwhere = ' WHERE Id_Usuario_Creacion__c = \''+UserInfo.getUserId() +'\' AND RecordTypeId = \''+this.IdTipoRegistro +'\' AND RVentas__c =  true ';
            // String qwhere = ' WHERE ';


            String qestado = '';

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else 
                if (this.Estado == 'En Proceso')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c = null )';
                }
                else{
                    qestado = ' AND (Status = \''+ this.Estado +'\' ) ';                    
                }
            }

            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z';    

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
            }
            
            String qrut = '';
            if (String.isNotBlank(this.RUT) == true)
            {
                qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
            }

            String qnumeroPoliza = '';

            if (String.isNotBlank(this.Poliza) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
            }

            String qnumeroPropuesta = '';

            if (String.isNotBlank(this.Propuesta) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
            }

            String qnegocio = '';
            
            if (String.isNotBlank(this.FiltroCaso.Negocio__c))
            {
                qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
            }

            String qcategoria = '';
            if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
            {
                qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
            }

            String qsolicitud = '';

            if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
            {
                 qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
            }

            system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
            system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
            system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);

            String qorden = ' ORDER BY CreatedDate DESC';

            String queryFull = query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qnegocio + qcategoria + qsolicitud;

            return queryfull +  qorden + qlimit;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }

    public String queryCasosCount()
    {
        try{

            String query = 'SELECT Id FROM Case';

            //String qwhere = ' WHERE Id_Usuario_Creacion__c = '' AND RVentas__c =  true ';
            //String qwhere = ' WHERE ';//Id_Usuario_Creacion__c = \''+UserInfo.getUserId() +'\' AND RVentas__c =  true ';
            String qwhere = ' WHERE RecordTypeId = \''+this.IdTipoRegistro +'\'  AND RVentas__c =  true ';

            String qestado = '';

          /*  if (this.Estado == 'Todos')
            {
                qestado = ' (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = '  (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else {
                    qestado = ' (Status = \''+ this.Estado +'\' ) ';                    
                }
            }*/

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = ' AND  (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else 
                if (this.Estado == 'En Proceso')
                {
                    qestado = ' AND  (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c = null )';
                }
                else{
                    qestado = ' AND  (Status = \''+ this.Estado +'\' ) ';                    
                }
            }

            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z';    

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
            }
            
            String qrut = '';
            if (String.isNotBlank(this.RUT) == true)
            {
                qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
            }

            String qnumeroPoliza = '';

            if (String.isNotBlank(this.Poliza) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
            }

            String qnumeroPropuesta = '';

            if (String.isNotBlank(this.Propuesta) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
            }
            
            String qnegocio = '';
            
            if (String.isNotBlank(this.FiltroCaso.Negocio__c))
            {
                qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
            }

            String qcategoria = '';
            if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
            {
                qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
            }

            String qsolicitud = '';

            if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
            {
                 qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
            }

            String queryFull = query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qnegocio + qcategoria + qsolicitud;

            return queryfull;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }

    public String queryMisCasosCount()
    {
        try{

            String query = 'SELECT Id FROM Case';

            //String qwhere = ' WHERE Id_Usuario_Creacion__c = '' AND RVentas__c =  true ';
            String qwhere = ' WHERE Id_Usuario_Creacion__c = \''+UserInfo.getUserId() +'\' AND RecordTypeId = \''+this.IdTipoRegistro +'\'  AND RVentas__c =  true ';


            String qestado = '';

          /*  if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else {
                    qestado = ' AND (Status = \''+ this.Estado +'\' ) ';                    
                }
            }*/

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\'  OR Status = \'Cerrado\' OR Status = \'Rechazado\' OR Status = \'Back Office\' '+
                'OR (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null) ) ';
            } 
            else 
            {
                if (this.Estado == 'En Proceso Derivación')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c != null )';
                }
                else 
                if (this.Estado == 'En Proceso')
                {
                    qestado = ' AND (Status = \'En Proceso\'  AND  CASO_Responsable_UR__c = null )';
                }
                else{
                    qestado = ' AND (Status = \''+ this.Estado +'\' ) ';                    
                }
            }


            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z';    

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
            }
            
            String qrut = '';
            if (String.isNotBlank(this.RUT) == true)
            {
                qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
            }

            String qnumeroPoliza = '';

            if (String.isNotBlank(this.Poliza) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
            }

            String qnumeroPropuesta = '';

            if (String.isNotBlank(this.Propuesta) == true)
            {
                //qnumeroPoliza = ' AND CASO_N_Poliza__c = \''+ this.Poliza +' \'';
                qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
            }
            
            String qnegocio = '';
            
            if (String.isNotBlank(this.FiltroCaso.Negocio__c))
            {
                qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
            }

            String qcategoria = '';
            if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
            {
                qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
            }

            String qsolicitud = '';

            if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
            {
                 qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
            }

            String queryFull = query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qnegocio + qcategoria + qsolicitud;

            return queryfull;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }


      /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarBandeja(){
        try
        {
            this.FechaInicio = Date.today().addDays(-30);
            this.FechaTermino = Date.today();

            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
            this.FiltroCaso = new Case();
            this.FiltroCaso.RecordTypeId = IdTipoRegistro;
            this.FiltroCaso.Negocio__c = 'Seguros Individuales';
            //this.FiltroCaso.CASO_Categoria__c = 'Endoso IND';

            this.Estado = 'Todos';

            String query = this.queryCasosCount();

            system.debug('@@@@  QUERY CASOS LST_Casos => ' + query);

            List<Case> casos = Database.query(query);
            system.debug('@@@@  CASOS LST_Casos => ' + casos.size());

            totalRecs = casos.Size();

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

           this.CurrentPage = 'CASOS_VENTA';

        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarMiBandeja(){
        try
        {
            this.FechaInicio= Date.today().addDays(-30);
            this.FechaTermino = Date.today();

            String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;
            this.FiltroCaso = new Case();
            this.FiltroCaso.RecordTypeId = IdTipoRegistro;
            this.FiltroCaso.Negocio__c = 'Seguros Individuales';
            //this.FiltroCaso.CASO_Categoria__c = 'Endoso IND';

            this.Estado = 'Todos';

            String query = this.queryMisCasosCount();

            system.debug('@@@@  QUERY CASOS LST_Casos => ' + query);

            List<Case> casos = Database.query(query);
            system.debug('@@@@  CASOS LST_Casos => ' + casos.size());

            totalRecs = casos.Size();

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

           this.CurrentPage = 'CASOS_VENTA';

        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

     public List<Selectoption> getListarEstados(){
        try{
            List<Selectoption> LST_Estados = new List<Selectoption>();
            
            LST_Estados.add(new Selectoption('Todos','Todos'));
            
            LST_Estados.add(new Selectoption('Nuevo','Nuevo'));
            LST_Estados.add(new Selectoption('En Proceso','En Proceso'));
            LST_Estados.add(new Selectoption('En Revisión','En Revisión'));
            LST_Estados.add(new Selectoption('Cerrado','Cerrado'));
            LST_Estados.add(new Selectoption('Rechazado','Rechazado'));
            LST_Estados.add(new Selectoption('Back Office','Back Office'));
            LST_Estados.add(new Selectoption('En Proceso Derivación','En Proceso Derivación'));   
         
            return LST_Estados;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

     public List<Selectoption> getListarTipos(){
        try{
            List<Selectoption> LST_Tipos = new List<Selectoption>();
            
            LST_Tipos.add(new Selectoption('Todos','Todos'));
            
            LST_Tipos.add(new Selectoption('Clientes','Clientes'));
            LST_Tipos.add(new Selectoption('No Clientes','No Clientes'));
            
            return LST_Tipos;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
/*
    public List<Selectoption> getListarCategorias(){
        try{
            List<Selectoption> LST_Tipos = new List<Selectoption>();
            
            LST_Tipos.add(new Selectoption('Todos','Todos'));
            
            LST_Tipos.add(new Selectoption('Clientes','Clientes'));
            LST_Tipos.add(new Selectoption('No Clientes','No Clientes'));
            
            return LST_Tipos;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }*/

    public void busquedaCasos(){
        String query = this.queryCasosCount();

        system.debug('@@@@  QUERY CASOS LST_Casos => ' + query);

        List<Case> casos = Database.query(query);
        system.debug('@@@@  CASOS LST_Casos => ' + casos.size());

        totalRecs = casos.Size();

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

    public Pagereference limpiaBusquedaCasos()
    {
       PageReference page = new PageReference('/apex/SEC_VF_CV_Casos');
       page.setRedirect(true);
       return page;
    }

    public Pagereference limpiaBusquedaMisCasos()
    {
       PageReference page = new PageReference('/apex/SEC_VF_CV_MisCasos');
       page.setRedirect(true);
       return page;
    }

    public List<Case> getMisCasos()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryMisCasos(queryLimit);

        system.debug('@@@@ query --> '+ query);

        List<Case> casos = Database.query(query);   

        query = this.queryMisCasosCount();
        Page = 1; 
        List<Case> casosCount = Database.query(query);   
        totalRecs = casosCount.Size();

        Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
        this.TotalPage = totalRecs / LimitSize;

        if(totalrecs > range)
        {
            this.TotalPage++;
        }       
        
       // Pagina = '1';

        return casos;
    }

    public List<Case> getCasos()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryCasos(queryLimit);

        system.debug('@@J@@ query casos --> '+ query);

        List<Case> casos = Database.query(query);   

        query = this.queryCasosCount();
       // Page = 1; 
        List<Case> casosCount = Database.query(query);   
        totalRecs = casosCount.Size();

        Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
        this.TotalPage = totalRecs / LimitSize;

        if(totalrecs > range)
        {
            this.TotalPage++;
        }       
        
       // Pagina = '1';

        return casos;
    }

    public Pagereference NuevoCaso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Caso_IngresoRUT');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference ListadoCasos()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Casos');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference MisCasos()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_MisCasos');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }


   

    public PageReference verCaso(){
        try{
            String ID = apexpages.currentpage().getparameters().get('Id');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Caso?Id='+ID+'&Procedencia=LISTADO_CASOS');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }catch(Exception ex){
            system.debug('@@@@ ERROR LINK verCasoUR -->'+ ex);
        	return null;
        }
    }

    public PageReference verMiCaso(){
        try{
            String ID = apexpages.currentpage().getparameters().get('Id');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_CV_Caso?Id='+ID+'&Procedencia=MIS_CASOS');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }catch(Exception ex){
            system.debug('@@@@ ERROR LINK verCasoUR -->'+ ex);
        	return null;
        }
    }


    public void SeleccionCasos()
    {

    } 

     public void IniciarDerivacionMultiple(){
        try
        {
           
            this.SIN_DATA = false;

            String Ids = System.currentPageReference().getParameters().get('Ids');
            this.Procedencia = System.currentPageReference().getParameters().get('Procedencia');

            system.debug('@@@@ Ids => ' + Ids);
            system.debug('@@@@ Procedencia => ' + Procedencia);

            String[] IdsCambio = Ids.split('@');         

            for (String id : IdsCambio) 
            {
                String id_in_quotes = '\''+id+'\'';

                if (this.SOQL_IDs != '') 
                {
                     this.SOQL_IDs +=',';                      
                }  

                this.SOQL_IDs += id_in_quotes;
            }

            system.debug('@@@@ IdsCambio => ' + IdsCambio);
            
            String query = this.queryCasosDerivacion();
               
            List<Case> result = Database.query(query);   
            
            system.debug('@@@@  result '+result.size());
            
            if (result.size() == 0)
            {
                this.SIN_DATA = true;
            }

        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

    public String queryCasosDerivacion(){
        try 
        {            
            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C,  Canal__c, CreatedDate, Tipo_de_Requerimiento__c, Agente__c, Supervisor__c, Numero_Propuesta__c, Id_Requerimiento_EscritorioDigital__c, '+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, '+
            'EsNoCliente__c FROM Case WHERE Id IN ('+this.SOQL_IDs+')';
            
            return query;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }
    
    public List<Case> getCasosDerivacion()
    {
        String query = this.queryCasosDerivacion();
       
        this.CasosUPD = Database.query(query);   
        
        system.debug('@@@@  result'+ this.CasosUPD.size());  

        return  this.CasosUPD;
    }

    public void DerivarCasos()
    {
        try
        {
            Integer Ok = 0;

            system.debug('@@@@  resultw --> '+ this.CasosUPD.size());  
            if(this.CasosUPD.size() > 0)
            {
                List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()];
                
                if (lusers.size() > 0)
                {
                    this.RutUsuario = lusers[0].RUT_Usuario__c;   
                } 

                system.debug('@@@@@ this.CasosUPD => ' + this.CasosUPD);
                Boolean exito;
                Integer contador = 1;
                for(Case c : this.CasosUPD)
                {        
                    exito = true;
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    String NOM_TIPOREGISTRO = [SELECT Name FROM RecordType WHERE Id =: c.RecordTypeId].Name;
                    
                    String Status = '';

                    if (!Test.isRunningTest())
                    {
                            Status = [SELECT Status FROM Case WHERE Id =: c.Id].Status;
                    }
                    
                    if (Status != 'Cerrado' && Status != 'Caso Cerrado' && 
                        Status != 'Back Office' && Status != 'Rechazado')
                    {
                        if (c.Status != 'En Revisión' && c.Status != 'Revisión')
                        {
                            if (String.isNotBlank(c.Id_Requerimiento_EscritorioDigital__c) == true)
                            {
                                Integer IdRequerimiento = Integer.valueOf(c.Id_Requerimiento_EscritorioDigital__c);

                                CLS_EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(IdRequerimiento, 'INGRESADO', RutUsuario);
                            
                                system.debug('@@@@ Respuesta Cambio Estado ED'+ Respuesta);

                                if (Respuesta.Codigo == '00')
                                {
                                    exito = true;
                                }            
                                else
                                {
                                    exito = false;
                                } 
                            }
                        }

                        system.debug('@@@@ exito '+ exito);
                        system.debug('@@@@ contador '+ contador);
                        contador++;
                        
                        if (exito == true)
                        {
                            String ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                            dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                            c.setOptions(dmo);
                            List<Case> lsC = new List<Case>();
                            c.Status = 'Back Office';   
                            c.Fecha_Derivacion_UR__c = Datetime.now();//                     
                            lsC.add(c);
                            Database.update(lsC,dmo);  

                            //system.debug('@@@@ exito '+ exito);

                            CLS_CV_ProcesoAsignacionResponsableUR CLAsign = new CLS_CV_ProcesoAsignacionResponsableUR();
                            if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
                            {                       
                                CLAsign.AsignarCaso(c); 
                            }
                            else {
                                CLAsign.ReasignarCaso(c.Id);
                            }

                            //Validar si propietario es Manuel Poblete
                            try
                            {
                                Case caso = new Case();
                                if (!Test.isRunningTest()) 
                                {
                                    caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];
                                }
                                else
                                {
                                    caso.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
                                }
                                    
                                if(caso != null)
                                {
                                    system.debug('@@@@ INFO CASO => ' + caso);
                                    String Propietario = caso.OwnerId;
                                    system.debug('@@@@ TIPO PROPIETARIO (USER/QUEUE) => ' + Propietario.substring(0, 3));
                                    if(Propietario.substring(0, 3) == '005')
                                    {
                                        User u = [SELECT Id, FirstName, Username, LastName, Name FROM User WHERE Id =: caso.OwnerId];
                                        system.debug('@@@@ USUARIO => ' + u.Name);

                                        if(u != null && u.Name == 'Manuel Eduardo Poblete López')
                                        {
                                            caso.OwnerId = caso.CreatedById;
                                            caso.Status = 'En Proceso';
                                            caso.CASO_Responsable_UR__c = null;
                                            caso.CASO_Resultado_Derivaci_n__c = 'NO EXISTE REGLA DE ASIGNACIÓN...';
                                            update caso;
                                        }
                                        else
                                        {
                                            caso.CASO_Resultado_Derivaci_n__c = 'CORRECTA ASIGNACIÓN...';
                                            update caso;                                
                                        }
                                    }
                                }
                            }
                            catch(Exception ex){
                                system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                                system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                            }
                            Ok++;
                        }
                    }                   
                }                
            }

            this.MensajePopup = 'Se han derivado exitosamente '+ Ok + ' casos de un total de '+this.CasosUPD.size()+' casos seleccionados.';
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }       
    }

    public String CambioEstado_EscritorioDigital(Integer IdRequerimiento){
        String salida = '';

        try
        {   
            CLS_EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(IdRequerimiento, 'INGRESADO', this.RutUsuario);
                       //EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'INGRESADO', RutUsuario);    
            system.debug('@@@@ Respuesta Cambio Estado ED'+ Respuesta);

            if (Respuesta.Codigo == '00')
            {
                Salida = 'UPDATE_ESTADO_OK;';
            }            
            else
            {
                Salida = 'UPDATE_ESTADO_ERROR;' + Respuesta.Mensaje;//Error al cambiar estado en ED o Valuetech.     
            } 
        }
        catch(Exception ex){
            System.debug('@@@@|CambioEstadoDerivaCaso@@'+ex); 
            Salida = 'EXCEPCION;'+ex.getMessage();
        }

        return Salida;           
    } 
    
    /***INTEGRACION ESCRITORIO DIGITAL**/
}