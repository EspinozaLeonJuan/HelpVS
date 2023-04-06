/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Caso_Cartas                                                             |
 |  TIPO                   : APEX CLASS                                                                     |
 |  REQUERIMIENTO          : MEJORAS UR                                                                     |
 |  DESCRIPCION            : Gestión de Cartas sobreprima y exlcusion asociadas a un Caso                   |
 |                                                                                                          |
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES                                     |
 |    1.0      *    2019/11/03   *    JUAN ESPINOZA  *    Creación Clase                                    |
 |                                                                                                          |
 ************************************************************************************************************
*/
public class CTR_UR_Caso_Cartas {

    public class Nodo_Cobertura
    {
        public Integer Id {get; set;}

        public String Cobertura {get; set;}

        public String Sobreprima {get; set;}
    }

    public class Nodo_Exclusion
    {
        public Integer Id {get; set;}

        public String Cobertura {get; set;}

        public String Nombre {get; set;}

        public String Exclusion {get; set;}
    }

    public String UsuarioBackUp {get; set;}

    public String Procedencia {get; set;}

    public String IdCaso {get; set;}

    public Boolean ResultadoPopup {get; set;}

    public Case Caso { get; set; }

    public Carta_Caso__c Carta { get; set; }

    public String Nombre_Carta {get; set;}

    public String Direccion_Carta {get; set;}

    public String Ciudad_Carta {get; set;}

    public String Comuna_Carta {get; set;}

    public String Poliza_Carta {get; set;}

    public String Descripcion_Carta {get; set;}

    public String Cobertura {get; set;}

    public String Sobreprima {get; set;}

    public List<Nodo_Cobertura> Lista_Coberturas {get; set;}

    public Integer Contador_Coberturas { get; set; }

    public Integer Contador_Exclusiones { get; set; }

    public Boolean IngresoCorrecto { get; set; }

    public Boolean Actualizar { get; set; }

    public String Exclusion_Nombre {get; set;}

    public String Exclusion_Condicion {get; set;}

    public List<Nodo_Exclusion> Lista_Exclusiones {get; set;}

    public String IdCarta {get; set;}

    public String NombreFirmaPDF  {get; set;}

    public String CargoFirmaPDF  {get; set;}

    public String EmpresaFirmaPDF  {get; set;}    

    public Date FechaPDF {get; set;}

    public String MesPDF {get; set;}

    public List<String> Detalle_Carta {get; set;}

    public List<String> Cobertura_Carta {get; set;}

    public String EmailBBC =  'juespinoza@security.cl';

    public void CargaParametros_Caso()
    {
        this.IdCaso = apexpages.currentpage().getparameters().get('Id');
        this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
        this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');        

        system.debug('@@@@ IdCaso'+ this.IdCaso);
        system.debug('@@@@ UsuarioBackUp'+ this.UsuarioBackUp);
        system.debug('@@@@ Procedencia'+ this.Procedencia);
    }

    public void Inicia_Carta_Sobreprima()
    {
        this.CargaParametros_Caso();

        this.ResultadoPopup = false;
       
        this.Lista_Coberturas = new List<Nodo_cobertura>();     
        this.Contador_Coberturas = 1;  
        
        if (!Test.isRunningTest()) 
        { 
            this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,  
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,  
                        Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                        Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                        CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                        Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                        Nombre_Completo_Razon_Social__c, Numero_Propuesta__c, CASO_Poliza_Asoc__c, Carta_Sobreprima__c, Carta_Exclusion__c 
                    FROM Case
                    WHERE Id =: this.IdCaso];      
        } 
        
        if (this.Caso.Carta_Sobreprima__c == false)
        {
            if (this.Caso.EsNoCliente__c == false)
            {
                Account cuenta = [SELECT Id, Name, Direccion_Particular__PC, Ciudad_Particular__PC, Comuna_Particular__PC FROM Account WHERE Id =: this.Caso.AccountId];
                this.Nombre_Carta = cuenta.Name;
                this.Direccion_Carta = cuenta.Direccion_Particular__PC;
                this.Ciudad_Carta = cuenta.Ciudad_Particular__PC;
                this.Comuna_Carta = cuenta.Comuna_Particular__PC;
                this.Poliza_Carta = this.Caso.CASO_Poliza_Asoc__c;
            }

            this.Actualizar = false;
        }
        else
        {
           this.Actualizar = true;
           
           if (!Test.isRunningTest())
           {
           		this.Carta = [SELECT Id, Name, Nombre__c, Direccion__c, Comuna__c, Ciudad__c, Poliza__c, Descripcion__c, Tipo__c, Detalle__c, IdCaso__c FROM Carta_Caso__c 
                     WHERE IdCaso__c =: this.Caso.Id AND Tipo__c = 'SOBREPRIMA'];               
           }
           
           this.Nombre_Carta = this.Carta.Nombre__c;
           this.Direccion_Carta = this.Carta.Direccion__c;
           this.Ciudad_Carta = this.Carta.Comuna__c;
           this.Comuna_Carta = this.Carta.Ciudad__c;
           this.Poliza_Carta = this.Carta.Poliza__c;
           this.Descripcion_Carta = this.Carta.Descripcion__c;
            
           if (Test.isRunningTest())
           {
               this.Carta = new Carta_Caso__c();
               this.Carta.Detalle__c = 'cob1#1&cob2#1&';
           }

           if (String.isNotBlank(this.Carta.Detalle__c))
           {
                String[] fCoberturas =  this.Carta.Detalle__c.split('&');

                this.Lista_Coberturas = new List<Nodo_Cobertura>();
                Integer  contador = 1;
                system.debug('@@@@ fCoberturas --> '+fCoberturas); 
                for(String cob : fCoberturas)
                {
                        system.debug('@@@@ cob --> '+cob); 
                        Nodo_Cobertura nodo = new Nodo_Cobertura();

                        String[] dcob = cob.split('#');
                        nodo.Id = contador;
                        nodo.Cobertura = dcob[0];
                        nodo.Sobreprima = dcob[1];
                        this.Lista_Coberturas.add(nodo);
                        contador++;    
                }

                this.Contador_Coberturas = contador;
           }
        }

        system.debug('@@@@ CasoPopup --> '+this.Caso);

    }

    public void Guarda_Carta_Sobreprima()
    {
        this.Carta = new Carta_Caso__c();

        this.IngresoCorrecto = true;

        if (String.isBlank(this.Nombre_Carta) == true || 
            String.isBlank(this.Direccion_Carta) == true || 
            String.isBlank(this.Comuna_Carta) == true || 
            String.isBlank(this.Ciudad_Carta) == true || 
            String.isBlank(this.Poliza_Carta) == true)
        {
            this.IngresoCorrecto = false;
        }

        if (this.IngresoCorrecto == true)
        {
            this.Carta.Nombre__c = this.Nombre_Carta;
            this.Carta.Direccion__c = this.Direccion_Carta;
            this.Carta.Comuna__c = this.Comuna_Carta;
            this.Carta.Ciudad__c = this.Ciudad_Carta;
            this.Carta.Poliza__c = this.Poliza_Carta;
            this.Carta.Descripcion__c = this.Descripcion_Carta;
            this.Carta.IdCaso__c = this.Caso.Id;
            this.Carta.Tipo__c = 'SOBREPRIMA';
            String cobertura = '';

            for(Nodo_Cobertura nodo : this.Lista_Coberturas)
            {
                cobertura = cobertura + nodo.Cobertura+'#'+nodo.Sobreprima+'&';
            }
            
            //this.Carta.Detalle__c = '';
            this.Carta.Detalle__c = cobertura;

            this.Caso.Carta_Sobreprima__c = true;

            system.debug('@@@@ Carta --> '+this.Carta);
            //system.debug('@@@@ CasoPopup --> '+this.CasoPopup);

            if (!Test.isRunningTest())
            {
                insert Carta;
                update this.Caso;
            }
        }
    }

    public void Actualiza_Carta_Sobreprima()
    {
        this.IngresoCorrecto = true;

        if (String.isBlank(this.Nombre_Carta) == true || 
            String.isBlank(this.Direccion_Carta) == true || 
            String.isBlank(this.Comuna_Carta) == true || 
            String.isBlank(this.Ciudad_Carta) == true || 
            String.isBlank(this.Poliza_Carta) == true)
        {
            this.IngresoCorrecto = false;
        }

        if (this.IngresoCorrecto == true)
        {
            this.Carta.Nombre__c = this.Nombre_Carta;
            this.Carta.Direccion__c = this.Direccion_Carta;
            this.Carta.Comuna__c = this.Comuna_Carta;
            this.Carta.Ciudad__c = this.Ciudad_Carta;
            this.Carta.Poliza__c = this.Poliza_Carta;
            this.Carta.Descripcion__c = this.Descripcion_Carta;
            this.Carta.IdCaso__c = this.Caso.Id;
            this.Carta.Tipo__c = 'SOBREPRIMA';
           
            String cobertura = '';

            for(Nodo_Cobertura nodo : this.Lista_Coberturas)
            {
                cobertura = cobertura + nodo.Cobertura+'#'+nodo.Sobreprima+'&';
            }
            
            //this.Carta.Detalle__c = '';
            this.Carta.Detalle__c = cobertura;

            if (!Test.isRunningTest())
            {
                update Carta;
            }
        }
    }

    public List<SelectOption> getCoberturas_Sobreprima()
    {
        List<SelectOption> coberturas  = new List<SelectOption>();
        coberturas.add(new SelectOption('Fallecimiento', 'Fallecimiento'));    
        coberturas.add(new SelectOption('Invalidez Total y Permanente 2/3', 'Invalidez Total y Permanente 2/3'));    
        coberturas.add(new SelectOption('Invalidez Total y Permanente 80%', 'Invalidez Total y Permanente 80%'));    
        coberturas.add(new SelectOption('Invalidez por Accidente', 'Invalidez por Accidente'));   
        coberturas.add(new SelectOption('Muerte Accidental', 'Muerte Accidental'));   
        coberturas.add(new SelectOption('Muerte Accidental y Desmembramiento', 'Muerte Accidental y Desmembramiento'));      
        
        return coberturas;
    }

    public List<SelectOption> getCoberturas_Exclusion()
    {
        List<SelectOption> coberturas  = new List<SelectOption>();
        coberturas.add(new SelectOption('Máxima Cobertura en Salud', 'Máxima Cobertura en Salud'));   
        coberturas.add(new SelectOption('Fallecimiento', 'Fallecimiento'));    
        coberturas.add(new SelectOption('Invalidez Total y Permanente 2/3', 'Invalidez Total y Permanente 2/3'));    
        coberturas.add(new SelectOption('Invalidez Total y Permanente 80%', 'Invalidez Total y Permanente 80%'));    
        coberturas.add(new SelectOption('Invalidez por Accidente', 'Invalidez por Accidente'));   
        coberturas.add(new SelectOption('Muerte Accidental', 'Muerte Accidental'));   
        coberturas.add(new SelectOption('Muerte Accidental y Desmembramiento', 'Muerte Accidental y Desmembramiento'));    
        
        return coberturas;
    }

    public List<Nodo_Cobertura> getListaCoberturas()
    {   
        return this.Lista_Coberturas;
    }
    
    public void AddCobertura_Sobreprima()
    {
        if (String.isNotBlank(this.Cobertura) && String.isNotBlank(this.Sobreprima))
        {
            Nodo_Cobertura nodo = new Nodo_Cobertura();
            nodo.Sobreprima = this.Sobreprima;
            nodo.Cobertura = this.Cobertura;
            nodo.Id = this.Contador_Coberturas;
            this.Lista_Coberturas.add(nodo);
            this.Contador_Coberturas++;
        }

        this.Sobreprima = '';
    }

    public void DeleteCobertura()
    {
        String ID = apexpages.currentpage().getparameters().get('IdCob');

        List<Nodo_Cobertura> tmp = this.Lista_Coberturas;

        this.Lista_Coberturas = new List<Nodo_Cobertura>();

        for (Nodo_Cobertura nodo : tmp)
        {
            if (nodo.Id != Integer.valueOf(ID))
            {
                 this.Lista_Coberturas.add(nodo);
            }
        }
    }

    public void Inicia_Carta_Exclusion()
    {
        this.CargaParametros_Caso();

        this.ResultadoPopup = false;
               
        this.Lista_Exclusiones = new List<Nodo_Exclusion>();     
        this.Contador_Exclusiones = 1;  

        this.Lista_Coberturas = new List<Nodo_cobertura>();     
        this.Contador_Coberturas = 1;  

        if (!Test.isRunningTest()) 
        { 
            this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,  
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,  
                        Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                        Parent.OwnerId, Id_Responsable_UR__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Entrega_Respuesta__c,
                        CASO_Asunto_Notificaci_n__c, CASO_Mensaje_Notificaci_n__c,Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                        Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,
                        Nombre_Completo_Razon_Social__c, Numero_Propuesta__c,CASO_Poliza_Asoc__c, Carta_Sobreprima__c, Carta_Exclusion__c 
                    FROM Case
                    WHERE Id =: this.IdCaso];      
        } 

         system.debug('@@@@ CasoPopup Exclusion --> '+this.Caso);

        if (this.Caso.Carta_Exclusion__c == false)
        {
            if (this.Caso.EsNoCliente__c == false)
            {
                Account cuenta = [SELECT Id, Name, Direccion_Particular__PC, Ciudad_Particular__PC, Comuna_Particular__PC FROM Account WHERE Id =: this.Caso.AccountId];
                this.Nombre_Carta = cuenta.Name;
                this.Direccion_Carta = cuenta.Direccion_Particular__PC;
                this.Ciudad_Carta = cuenta.Ciudad_Particular__PC;
                this.Comuna_Carta = cuenta.Comuna_Particular__PC;
                this.Poliza_Carta = this.Caso.CASO_Poliza_Asoc__c;
            }
            this.Actualizar = false;
        }
        else
        {
           this.Actualizar = true;
            
           if (!Test.isRunningTest())
           {
           		this.Carta = [SELECT Id, Name, Nombre__c, Direccion__c, Comuna__c, Ciudad__c, Poliza__c, Descripcion__c, Tipo__c, Detalle__c, IdCaso__c FROM Carta_Caso__c 
                        WHERE IdCaso__c =: this.Caso.Id AND Tipo__c = 'EXCLUSION'];
           }
            
           this.Nombre_Carta = this.Carta.Nombre__c;
           this.Direccion_Carta = this.Carta.Direccion__c;
           this.Ciudad_Carta = this.Carta.Comuna__c;
           this.Comuna_Carta = this.Carta.Ciudad__c;
           this.Poliza_Carta = this.Carta.Poliza__c;
           this.Descripcion_Carta = this.Carta.Descripcion__c;
            
           if (Test.isRunningTest())
           {
               this.Carta = new Carta_Caso__c();
               this.Carta.Detalle__c = 'col1#exc1#1&col2#exc2#1&';
           }

           if (String.isNotBlank(this.Carta.Detalle__c))
           {
                String[] fExclusiones =  this.Carta.Detalle__c.split('&');

                this.Lista_Exclusiones = new List<Nodo_Exclusion>();

                Integer contador = 1;
                system.debug('@@@@ fExclusiones --> '+fExclusiones); 
                for(String exc : fExclusiones)
                {
                    system.debug('@@@@ exc --> '+ exc); 
                    Nodo_Exclusion nodo = new Nodo_Exclusion();
                    
                    String[] dexc = exc.split('#');
                    nodo.Id = contador;
                    nodo.Cobertura = dexc[0];
                    nodo.Nombre = dexc[1];
                    nodo.Exclusion = dexc[2];
                    this.Lista_Exclusiones.add(nodo);
                    contador++;    
                }

                this.Contador_Exclusiones = contador;
           }
        }
    }

    public void Guarda_Carta_Exclusion()
    {
        this.Carta = new Carta_Caso__c();

        this.IngresoCorrecto = true;

        if (String.isBlank(this.Nombre_Carta) == true || 
            String.isBlank(this.Direccion_Carta) == true || 
            String.isBlank(this.Comuna_Carta) == true || 
            String.isBlank(this.Ciudad_Carta) == true || 
            String.isBlank(this.Poliza_Carta) == true)
        {
            this.IngresoCorrecto = false;
        }

        if (this.IngresoCorrecto == true)
        {
            this.Carta.Nombre__c = this.Nombre_Carta;
            this.Carta.Direccion__c = this.Direccion_Carta;
            this.Carta.Comuna__c = this.Comuna_Carta;
            this.Carta.Ciudad__c = this.Ciudad_Carta;
            this.Carta.Poliza__c = this.Poliza_Carta;
            this.Carta.Descripcion__c = this.Descripcion_Carta;
            this.Carta.IdCaso__c = this.Caso.Id;
            this.Carta.Tipo__c = 'EXCLUSION';
            String detalle = '';

            for(Nodo_Exclusion nodo : this.Lista_Exclusiones)
            {
                detalle = detalle + nodo.Cobertura + '#' + nodo.Nombre + '#' + nodo.Exclusion +'&';
            }
            
            this.Carta.Detalle__c = detalle;
            this.Caso.Carta_Exclusion__c = true;

            if (!Test.isRunningTest())
            {
                insert Carta;
                update this.Caso;
            }
        }
    }

    public void Actualiza_Carta_Exclusion()
    {
        this.IngresoCorrecto = true;

        if (String.isBlank(this.Nombre_Carta) == true || 
            String.isBlank(this.Direccion_Carta) == true || 
            String.isBlank(this.Comuna_Carta) == true || 
            String.isBlank(this.Ciudad_Carta) == true || 
            String.isBlank(this.Poliza_Carta) == true)
        {
            this.IngresoCorrecto = false;
        }

        if (this.IngresoCorrecto == true)
        {
            this.Carta.Nombre__c = this.Nombre_Carta;
            this.Carta.Direccion__c = this.Direccion_Carta;
            this.Carta.Comuna__c = this.Comuna_Carta;
            this.Carta.Ciudad__c = this.Ciudad_Carta;
            this.Carta.Poliza__c = this.Poliza_Carta;
            this.Carta.Descripcion__c = this.Descripcion_Carta;
            this.Carta.IdCaso__c = this.Caso.Id;
            this.Carta.Tipo__c = 'EXCLUSION';
            String detalle = '';
            for(Nodo_Exclusion nodo : this.Lista_Exclusiones)
            {
                detalle = detalle + nodo.Cobertura + '#' + nodo.Nombre + '#' + nodo.Exclusion +'&';
            }
            
            this.Carta.Detalle__c = detalle;

            if (!Test.isRunningTest())
            {
                update Carta;
            }
        }
    }

    public void AddExclusion()
    {
        if (String.isNotBlank(this.Cobertura) && String.isNotBlank(this.Exclusion_Nombre) && String.isNotBlank(this.Exclusion_Condicion))
        {
            Nodo_Exclusion nodo = new Nodo_Exclusion();
            nodo.Cobertura = this.Cobertura;
            nodo.Nombre = this.Exclusion_Nombre;
            nodo.Exclusion = this.Exclusion_Condicion;
            nodo.Id = this.Contador_Coberturas;
            this.Lista_Exclusiones.add(nodo);
            this.Contador_Coberturas++;
        }

        this.Exclusion_Nombre = '';
        this.Exclusion_Condicion = '';
    }

    public void DeleteExclusion()
    {
        String ID = apexpages.currentpage().getparameters().get('IdExc');

        List<Nodo_Exclusion> tmp = this.Lista_Exclusiones;

        this.Lista_Exclusiones = new List<Nodo_Exclusion>();
        for (Nodo_Exclusion nodo : tmp)
        {
            if (nodo.Id != Integer.valueOf(ID))
            {
                 this.Lista_Exclusiones.add(nodo);
            }
        }
    }

    public void generaPfd_CartaSobreprima()
    {
        this.NombreFirmaPDF  = 'Rosa Emilia Carmona';
        this.CargoFirmaPDF = 'Jefe Área Evaluación de Riesgo';
        this.EmpresaFirmaPDF = 'Seguros Vida Security S.A.';    

        if (!Test.isRunningTest())
        {
	        this.Carta = [SELECT Id, Name, Nombre__c, Direccion__c, Comuna__c, Ciudad__c, Poliza__c, Descripcion__c, Tipo__c, Detalle__c, IdCaso__c FROM Carta_Caso__c 
                    WHERE Id =: this.IdCarta];    
        }
        
        this.Nombre_Carta = this.Carta.Nombre__c;
        this.Direccion_Carta = this.Carta.Direccion__c;
        this.Ciudad_Carta = this.Carta.Comuna__c;
        this.Comuna_Carta = this.Carta.Ciudad__c;
        this.Poliza_Carta = this.Carta.Poliza__c;
        this.Descripcion_Carta = this.Carta.Descripcion__c;

        String[] fCoberturas =  this.Carta.Detalle__c.split('&');

        system.debug('@@@@ fCoberturas --> '+fCoberturas); 

        String salto = '#';

        this.Cobertura_Carta = new List<String>();
        for(String cob : fCoberturas)
        {
            system.debug('@@@@ cob --> '+cob); 
            Nodo_Cobertura nodo = new Nodo_Cobertura();
            
            String[] dcob = cob.split('#');
            nodo.Cobertura = dcob[0];
            nodo.Sobreprima = dcob[1];

            this.Cobertura_Carta.add( 'Cobertura: ' + nodo.Cobertura);
            this.Cobertura_Carta.add( 'Sobreprima: UF '+nodo.Sobreprima);
            this.Cobertura_Carta.add(salto);
        } 
    }

    public PageReference cargaPDF_Carta_Sobreprima(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                this.IdCarta = ApexPages.currentPage().getParameters().get('id');              
            }
            
            this.generaPfd_CartaSobreprima();           
            
            return null;
            
        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
            return null;
        }
    }

    public PageReference Genera_Carta_Sobreprima()
    {
        PageReference pdf = Page.SEC_PDF_UR_Caso_CartaSobreprima;
        pdf.getParameters().put('id', this.Carta.Id);
        return pdf;
    }

    public PageReference Genera_Carta_Exclusion()
    {
        PageReference pdf = Page.SEC_PDF_UR_Caso_CartaExclusion;
        pdf.getParameters().put('id', this.Carta.Id);
        return pdf;
    }

    public List<String> getDetalleCarta()
    {   
        return this.Detalle_Carta;
    }

    public List<String> getCoberturaCarta()
    {   
        return this.Cobertura_Carta;
    }

    public void generaPfd_CartaExclusion()
    {
        this.NombreFirmaPDF  = 'Rosa Emilia Carmona';
        this.CargoFirmaPDF = 'Jefe Área Evaluación de Riesgo';
        this.EmpresaFirmaPDF = 'Seguros Vida Security S.A.';    

        if (!Test.isRunningTest())
        {
            this.Carta = [SELECT Id, Name, Nombre__c, Direccion__c, Comuna__c, Ciudad__c, Poliza__c, Descripcion__c, Tipo__c, Detalle__c, IdCaso__c FROM Carta_Caso__c 
                    WHERE Id =: this.IdCarta];
        }
        
        this.Nombre_Carta = this.Carta.Nombre__c;
        this.Direccion_Carta = this.Carta.Direccion__c;
        this.Ciudad_Carta = this.Carta.Comuna__c;
        this.Comuna_Carta = this.Carta.Ciudad__c;
        this.Poliza_Carta = this.Carta.Poliza__c;
        this.Descripcion_Carta = this.Carta.Descripcion__c;

        String[] fExclusiones =  this.Carta.Detalle__c.split('&');

        system.debug('@@@@ fExclusioness --> '+fExclusiones); 

        String salto = '#';

        this.Detalle_Carta = new List<String>();
        for(String exc : fExclusiones)
        {
            system.debug('@@@@ cob --> '+exc); 
            Nodo_Exclusion nodo = new Nodo_Exclusion();
            
            String[] dexc = exc.split('#');
            nodo.Cobertura = dexc[0];
            nodo.Nombre = dexc[1];
            nodo.Exclusion = dexc[2];

            this.Detalle_Carta.add( '- '+nodo.Cobertura);
            this.Detalle_Carta.add( 'Nombre: ' + nodo.Nombre);
            this.Detalle_Carta.add( 'Condición excluida: '+nodo.Exclusion);
            this.Detalle_Carta.add(salto);
        } 

        String[] fCoberturas =  this.Carta.Detalle__c.split('&');

        system.debug('@@@@ fCoberturas --> '+fCoberturas); 

        this.Cobertura_Carta = new List<String>();
        for(String cob : fCoberturas)
        {
            system.debug('@@@@ cob --> '+cob); 
            Nodo_Cobertura nodo = new Nodo_Cobertura();
            
            nodo.Cobertura = cob;

            this.Cobertura_Carta.add(nodo.Cobertura);
        } 

    }

    public PageReference cargaPDF_Carta_Exclusion(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                this.IdCarta = ApexPages.currentPage().getParameters().get('id');              
            }
            
           this.generaPfd_CartaExclusion();
            
            return null;
            
        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
            return null;
        }
    }
}