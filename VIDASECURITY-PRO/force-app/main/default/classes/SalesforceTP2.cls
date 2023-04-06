public class SalesforceTP2 {
    //UI Panel
    public String Sucursal{ get; set; }
    public String Estado{ get; set; }
    public String Turno{ get; set; }
    public String Espera{ get; set; }
    public String TiempoAtencion{ get; set; }
    public String ClienteRut{ get; set; }
    public String OficinaEspera{ get; set; }
    public String OficinaTiempoEspera{ get; set; }
    public String EscritorioEspera{ get; set; }
    public String EscritorioTiempoEspera{ get; set; }
    public integer CodError { get; set; }
    public boolean DisplayBotonIniciaAtencion{ get; set; }
    public boolean DisplayBotonCierraAtencion{ get; set; }
    public boolean DisplayBotonPausa{ get; set; }
    public boolean DisplayBotonClienteLlego{ get; set; }
    public boolean DisplayBotonRellamada{ get; set; }
    public boolean DisplayBotonAnular{ get; set; }
    public boolean DisplayBotonUrgencia{ get; set; }
    public boolean DisplayBotonSalir{ get; set; }
    public boolean DisplayBotonCambiaRut { get; set; }
    public boolean DisplayBotonLogin { get; set; }
    public boolean DisplayCuadroDetallesTurno{ get; set; }
    public boolean DisplayCuadroDetallesSucursal{ get; set; }
    public boolean DisplayPopup{ get; set; }
    public boolean DisplayWaitEnPopup{ get; set; }
    public boolean DisplayLinkCaso { get; set; }
    public string UrlCaso { get; set; }
    public boolean ReintentoLogin { get; set; }
    public boolean DisplayErrorLogin { get; set; }
    
    //UI Popup
    public boolean CierraPopup { get; set; }
    public String uTurno { get; set; }
    public string uRut { get; set; }
    public string PausaItem{ get; set; }
    public List<string> MotivoItems{ get; set; }
    public string SerieItem{ get; set; }
    public Integer RecordatorioCierreAtencionMsecs { get; set; }
    
    //Utiles
    public SalesforceTPSoap.Oficina Ofi { get; set; }
    public User Usuario { get; set; }
    public integer IdEscritorio { get; set; }
    
    // Info Cliente
    public string ClienteNombre { get; set; }
    public string ClienteFechaInicioRelacion { get; set; }
    public string ClienteUltimaVisitaSucursal { get; set; }
    public string ClienteUrlUltimoCaso { get; set; }
    public string ClienteFechaUltimoCaso { get; set; }
    public string ClienteCantidadPolizasActivas { get; set; }
    public string ClienteReclamosAno { get; set; }
    public string ClienteReclamosAnteriores { get; set; }
    public string ClienteConsultasAno { get; set; }
    public string ClienteConsultasAnteriores { get; set; }
    public string ClienteSolicitudesAno { get; set; }
    public string ClienteSolicitudesAnteriores { get; set; }
    
    //variables globales
    private SalesforceTPSoap.WsSFTotalpackSoap servicio;
    
    //helpers
    public void Inicializa(){
        try {
            DisplayPopup = true;
            servicio = new SalesforceTPSoap.WsSFTotalpackSoap();
            servicio.timeout_x = 60000;
            SetDatosUsuario();       
            MotivoItems = new List<String>();
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
    }
    
    public void InicializaActualiza(){
        try {
            Inicializa();
            ActualizaUI();
            
            if (this.Estado == 'REINTENTANDO LOGIN'){
                Login();
            }
            
            if (Estado == 'ESPERANDO'){
                PidoTurno();
            }
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
    }
    
    private void OficinaBuilder(integer idOficina, string pais, string negocio){
        this.Ofi = new SalesforceTPSoap.Oficina();
        this.Ofi.IdOficina = idOficina;
        this.Ofi.Pais = pais;
        this.Ofi.Negocio = negocio;
    }
    
    private void SetDatosUsuario() {
        this.Usuario = [select u.Alias, u.Email,u.TP_Usuario__c, u.TP_Password__c, u.TP_Escritorio__c from User u where u.id = :Userinfo.getUserId()];
        Id IdSucursal = [select su.Sucursal__c from SucursalUsuario__c su where su.Usuario__c = :Userinfo.getUserId()].get(0).Sucursal__c;
        Sucursal__c sucUsuario = [select s.TP_Oficina__c, s.Area__c from Sucursal__c s where s.id = :IdSucursal];
        Area__c area = [select a.TP_Negocio__c, a.TP_Pais__c from Area__c a where a.id = :sucUsuario.Area__c];
        OficinaBuilder(integer.valueOf(sucUsuario.TP_Oficina__c), area.TP_Pais__c, area.TP_Negocio__c); 
        this.IdEscritorio = integer.valueOf(this.Usuario.TP_Escritorio__c);
    }
    
    //métodos WS
    public void Login() {
        try {
            string alias = Usuario.TP_Usuario__c;
            SalesforceTPSoap.ResultadoLogin r = servicio.Login(this.IdEscritorio, Ofi, alias, Usuario.TP_Password__c, Userinfo.getUserId());
            
            if (!r.Err.DescError.StartsWithIgnoreCase('Login OK')) {
                this.ReintentoLogin = true;            
            }               
            else {
                this.ReintentoLogin = false;
            }
            
            if (r.Err.CodError != 0){
                system.debug('Error Login');
                ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, r.Err.DescError);
                ApexPages.addMessage(error);
            }
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
    }
    
    public void Logoff() {
        
        try {
            servicio.Logoff(this.IdEscritorio, Ofi, Userinfo.getUserId());
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI();
    }
    
    public void LoginPausa(){
        try {
            Inicializa();
            Login();
            SetPausa('Login');
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI();
    }
    
    public void PidoTurno() {
        try {
            Login();
            servicio.PidoTurno(this.IdEscritorio, Ofi);
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI();
    }
    
    public void ProcesoTurno(){
        try {
            servicio.ProcesoTurno(this.IdEscritorio, Ofi, Userinfo.getUserId()); 
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI(); 
    }
    
    public void Anulo(){
        try {
            servicio.Anulo(this.IdEscritorio, Ofi, Userinfo.getUserId());
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI();
    }
    
    public void Rellamo(){
        try {
            servicio.Rellamo(this.IdEscritorio, Ofi, Userinfo.getUserId());
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
    }
    
    public void FinTurno(){
        System.debug('finturno');
        
        try {
            SalesforceTPSoap.ArrayOfMotivoFinTurno arr = new SalesforceTPSoap.ArrayOfMotivoFinTurno();
            SalesforceTPSoap.MotivoFinTurno mft = new SalesforceTPSoap.MotivoFinTurno();
            mft.IdMot = 1;
            mft.Cantidad = 1;
            arr.MotivoFinTurno = new List<SalesforceTPSoap.MotivoFinTurno>();
            arr.MotivoFinTurno.Add(mft);
            servicio.FinTurno(this.IdEscritorio, Ofi, arr , Userinfo.getUserId()); //arreglo fijo ya que motivos de atención se verán dentro del caso Salesforce
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        ActualizaUI();
    }
    
    //Listas
    public List<SelectOption> GetPausas(){
        List<SelectOption> options = new List<SelectOption>();
        system.debug('inicio GetPausas');
        
        try {
            SalesforceTPSoap.Pausa[] Pausas = servicio.GetPausas(this.IdEscritorio, Ofi).Pausas.Pausa;
            
            for(SalesforceTPSoap.Pausa p : Pausas){
                system.debug('pausa id: ' + p.IdPausa + ' | pausa: ' + p.Pausa);
                options.add(new SelectOption(string.valueOf(p.IdPausa),p.Pausa));
            } 
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        return options;
    }
    
    public void SetPausa(string p){
        try {
            system.debug(p);
            servicio.SetPausa(this.IdEscritorio, Ofi, 1, Userinfo.getUserId());
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
    }
    
    public void SetSerie(SalesforceTPSoap.Serie s){
        try {
            servicio.SetPausa(this.IdEscritorio, Ofi, s.IdSerie, Userinfo.getUserId());
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
    }
    
    public List<SelectOption> GetSeries(){
        List<SelectOption> options = new List<SelectOption>();
        
        try {
            SalesforceTPSoap.Serie[] Series = servicio.GetSeries(this.IdEscritorio, Ofi).Series.Serie;
            
            for(SalesforceTPSoap.Serie s : Series){
                options.add(new SelectOption(string.valueOf(s.IdSerie),s.Serie));
            }
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        return options;
    }
    
    //Popup
    public void CerrarPopup() {        
        DisplayPopup = false;    
    }     
    public void MostrarPopup() {        
        DisplayPopup = true;    
    }
    
    public PageReference getRegresoPopup(){
        try {
            MostrarPopup();
            ActualizaUI(); 
            CerrarPopup();
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        return null;
    }
    
    public void CargaPopup(){
        DisplayPopup = true;
        DisplayWaitEnPopup = false;
        Inicializa();
    }
    
    public PageReference GuardarPopup() {
        string valorAccion = apexPages.currentPage().getParameters().get('accion');
        DisplayPopup = true;
        DisplayWaitEnPopup = true;
        system.debug(valorAccion);
        
        try {
            if(valorAccion == 'PAUSA'){
                ActualizaUI();
                
                if (this.Estado == 'ATENDIENDO') {
                    FinTurno(); 
                }
                
                SetPausa(PausaItem);
            }
            else if(valorAccion == 'FINTURNO'){ //motivos de atención no implementados por requerimiento
                FinTurno();
            }
            else if(valorAccion == 'URGENCIA'){
                
                System.debug('eval fin de turno por urgencia, estado p1: ' + this.Estado);
                ActualizaUI();
                System.debug('eval fin de turno por urgencia, estado p2: ' + this.Estado);
                
                //continúa atención de varios clientes sin quedar disponible a usuarios en la cola
                if (this.Estado == 'ATENDIENDO') {
                    System.debug('fin de turno por urgencia');
                    FinTurno(); 
                    uTurno = '0';
                }
                
                if (uTurno == '') uTurno = '0';
                SalesforceTPSoap.Err e = servicio.Urgencia(this.IdEscritorio, Ofi, integer.valueOf(SerieItem), integer.valueOf(uTurno), Userinfo.getUserId());
                
                if (e.CodError != 0){
                    ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.DescError);
                    ApexPages.addMessage(error);
                    CierraPopup = false;
                    return null;
                }
            }
            else if(valorAccion == 'CAMBIORUT'){
                
                system.debug(ClienteRut);
                
                try {
                    if (this.ClienteRut == '') {
                        system.debug('clienterut vacío');
                        CierraPopup = false;
                        return null;
                    }
                    else {
                        string inputRut = this.ClienteRut.ReplaceAll('[^\\dKk]', '');
                        string rut = inputRut.substring(0, inputRut.length() - 1);
                        string dv = inputRut.substring(inputRut.length() - 1, inputRut.length());
                        
                        system.debug(inputRut);
                        system.debug(rut);
                        system.debug(dv);
                        
                        servicio.CambiaRutAtencionVigente(this.IdEscritorio, Ofi, Userinfo.getUserId(), rut, dv);
                    }
                }
                catch(Exception e){
                    ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, 'RUT no válido');
                    ApexPages.addMessage(error);
                    CierraPopup = false;
                    return null;
                }
            }
            else if(valorAccion == 'CAMBIOESC'){
                
                system.debug('cambioesc old: ' + this.IdEscritorio);
                
                if (this.IdEscritorio == null) {
                    CierraPopup = false;
                    return null;
                }
                else {
                    servicio.CambiaEscritorio(this.IdEscritorio, Userinfo.getUserId());
                    InicializaActualiza();
                    system.debug('cambioesc new: ' + this.IdEscritorio);
                }
            }
            else if (valorAccion == 'RECORDATORIOCIERREATENCION') {
                system.debug('recordatorio: ' + this.RecordatorioCierreAtencionMsecs);
                
                if (this.RecordatorioCierreAtencionMsecs != null){
                    Datetime dt = ObtenerFechaFuturaMilisegundos(this.RecordatorioCierreAtencionMsecs);
                    servicio.CambiaRecordatorio(dt, Userinfo.getUserId());
                }
            }
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        DisplayWaitEnPopup = false;
        CierraPopup = true;
        return null;
    }
    
    public List<SelectOption> getListaMinutos(){
        
        List<SelectOption> listaMinutos = new List<SelectOption>();
        listaMinutos.add(new SelectOption('-1', 'No recordar'));
        listaMinutos.add(new SelectOption('120000', '2 minutos'));
        listaMinutos.add(new SelectOption('300000', '5 minutos'));
        listaMinutos.add(new SelectOption('600000', '10 minutos'));
        listaMinutos.add(new SelectOption('1200000', '20 minutos'));
        listaMinutos.add(new SelectOption('1800000', '30 minutos'));
        
        return listaMinutos;
    }
    
    //Métodos UI
    private string StringCalculaMinutosSegundos(integer segundos) {
        decimal div = decimal.valueOf(segundos) / 60;
        string min = string.valueOf(div.round(System.RoundingMode.FLOOR));
        string seg = string.valueOf((((div - div.round(System.RoundingMode.FLOOR)) * 6000)/100).round());
        
        if (seg.length() == 1) seg = '0' + seg;
        
        return string.Format('{0}:{1}', new string[]{min, seg});
    }
    
    private integer SegundosDesdeFecha(datetime fechaInicio){
        Long fechaInicioLong = fechaInicio.getTime();
        TimeZone tz = UserInfo.getTimeZone();
        Datetime dt = Datetime.now();
        Datetime fechaActualLocal = dt.AddSeconds(tz.getOffset(dt)/1000);
        Long fechaActualLong = fechaActualLocal.getTime();
        Long diferencia = fechaActualLong - fechaInicioLong;  
        return integer.valueOf(diferencia / 1000); 
    }
    
    private Integer MilisegundosHastaFecha(datetime fechaFin){
        return Integer.valueOf(fechaFin.getTime() - DateTime.now().getTime());
    }
    
    private datetime ObtenerFechaFuturaMilisegundos(integer ms){
        Datetime dt = Datetime.now();
        Datetime fechaNueva = dt.addSeconds(ms / 1000);
        System.debug('ObtenerFechaFuturaMilisegundos: ' + fechaNueva);
        return fechaNueva; 
    }
    
    public void ActualizaUI(){
        DisplayPopup = true;
        
        try {
            SalesforceTPSoap.ResultadoGetEdoBase base = servicio.GetEdoBase(this.IdEscritorio, Ofi);
            SalesforceTPSoap.ResultadoGetEdoSesion sesion = servicio.GetEdoSesion(this.IdEscritorio, Ofi, UserInfo.getUserId());
            
            String TateA_tiempo = '';
            if (sesion.Fhini != null) {
                String Fhini_sf = '"' + sesion.Fhini.replace(' ', 'T') + '.000Z"'; //comillas dobles necesarias para método de conversión
                Datetime dtFhini_sf = (DateTime)JSON.deserialize(Fhini_sf,DateTime.class); 
                TateA_tiempo = StringCalculaMinutosSegundos(SegundosDesdeFecha(dtFhini_sf));
            }
            
            String Tesp_tiempo = StringCalculaMinutosSegundos(sesion.Tesp);
            String TespO_tiempo = StringCalculaMinutosSegundos(sesion.TespO);
            String TespE_tiempo = StringCalculaMinutosSegundos(sesion.TespE);
            
            this.Sucursal = base.Oficina;
            this.Estado = base.Estado;
            this.Turno = sesion.Letra + sesion.Turno;
            this.Espera = Tesp_tiempo;
            this.TiempoAtencion = TateA_tiempo;
            this.ClienteRut = sesion.RUT == '' ? this.ClienteRut : sesion.RUT;
            this.OficinaEspera = string.valueOf(sesion.QespO);
            this.OficinaTiempoEspera = TespO_tiempo;
            this.EscritorioEspera = string.valueOf(sesion.QespE);
            this.EscritorioTiempoEspera = TespE_tiempo;
            
            system.debug('coderror actualizaUI: ' + base.Err.CodError);
            
            if (base.Err.CodError != 0){
                system.debug('Error ActualizaUI');
                ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, sesion.Err.DescError);
                ApexPages.addMessage(error);
                this.Estado = 'REINTENTANDO LOGIN';
            }
            
            if (this.Estado == 'LOGOFF' || this.Estado == null){
                this.DisplayBotonLogin = true;
                this.DisplayBotonIniciaAtencion = false;
                this.DisplayBotonCierraAtencion = false;
                this.DisplayBotonPausa = false;
                this.DisplayBotonClienteLlego = false;
                this.DisplayBotonRellamada = false;
                this.DisplayBotonAnular = false;
                this.DisplayBotonUrgencia = false;
                this.DisplayCuadroDetallesTurno = false;
                this.DisplayCuadroDetallesSucursal = false;
                this.DisplayBotonSalir = false;
                this.DisplayErrorLogin = false;
                this.DisplayBotonCambiaRut = false;
                this.DisplayLinkCaso = false;
            }
            else if (this.Estado == 'REINTENTANDO LOGIN'){
                this.DisplayBotonLogin = false;
                this.DisplayBotonIniciaAtencion = false;
                this.DisplayBotonCierraAtencion = false;
                this.DisplayBotonPausa = false;
                this.DisplayBotonClienteLlego = false;
                this.DisplayBotonRellamada = false;
                this.DisplayBotonAnular = false;
                this.DisplayBotonUrgencia = false;
                this.DisplayCuadroDetallesTurno = false;
                this.DisplayCuadroDetallesSucursal = false;
                this.DisplayBotonSalir = false;
                this.DisplayErrorLogin = true;
                this.DisplayBotonCambiaRut = false;
                this.DisplayLinkCaso = false;
            }
            else if (this.Estado == 'PAUSA'){
                this.DisplayBotonLogin = false;
                this.DisplayBotonIniciaAtencion = true;
                this.DisplayBotonCierraAtencion = false;
                this.DisplayBotonPausa = false;
                this.DisplayBotonClienteLlego = false;
                this.DisplayBotonRellamada = false;
                this.DisplayBotonAnular = false;
                this.DisplayBotonUrgencia = true;
                this.DisplayCuadroDetallesTurno = false;
                this.DisplayCuadroDetallesSucursal = true;
                this.DisplayBotonSalir = true;
                this.DisplayErrorLogin = false;
                this.DisplayBotonCambiaRut = false;
                this.DisplayLinkCaso = false;
            }
            else if (this.Estado == 'ESPERANDO'){
                this.DisplayBotonLogin = false;
                this.DisplayBotonIniciaAtencion = true;
                this.DisplayBotonCierraAtencion = false;
                this.DisplayBotonPausa = true;
                this.DisplayBotonClienteLlego = false;
                this.DisplayBotonRellamada = false;
                this.DisplayBotonAnular = false;
                this.DisplayBotonUrgencia = true;
                this.DisplayCuadroDetallesTurno = false;
                this.DisplayCuadroDetallesSucursal = true;
                this.DisplayBotonSalir = true;
                this.DisplayErrorLogin = false;
                this.DisplayBotonCambiaRut = false;
                this.DisplayLinkCaso = false;
            }
            else if (this.Estado == 'LLAMANDO'){
                this.DisplayBotonLogin = false;
                this.DisplayBotonIniciaAtencion = false;
                this.DisplayBotonCierraAtencion = false;
                this.DisplayBotonPausa = false;
                this.DisplayBotonClienteLlego = true;
                this.DisplayBotonRellamada = true;
                this.DisplayBotonAnular = true;
                this.DisplayBotonUrgencia = false;
                this.DisplayCuadroDetallesTurno = true;
                this.DisplayCuadroDetallesSucursal = true;
                this.DisplayBotonSalir = false;
                this.DisplayErrorLogin = false;
                this.DisplayBotonCambiaRut = false;
                this.DisplayLinkCaso = false;
            }
            else if (this.Estado == 'ATENDIENDO'){
                this.DisplayBotonLogin = false;
                this.DisplayBotonIniciaAtencion = false;
                this.DisplayBotonCierraAtencion = true;
                this.DisplayBotonPausa = true;
                this.DisplayBotonClienteLlego = false;
                this.DisplayBotonRellamada = false;
                this.DisplayBotonAnular = false;
                this.DisplayBotonUrgencia = true;
                this.DisplayCuadroDetallesTurno = true;
                this.DisplayCuadroDetallesSucursal = true;
                this.DisplayBotonSalir = false;
                this.DisplayErrorLogin = false;
                this.DisplayBotonCambiaRut = true;
                this.DisplayLinkCaso = true;
                this.UrlCaso = URL.getSalesforceBaseUrl().toExternalForm() + '/' + sesion.Err.DescError;
                this.RecordatorioCierreAtencionMsecs = MilisegundosHastaFecha(servicio.GetRecordatorio(UserInfo.getUserId()));
                getInfoCliente();
            }
        }
        catch (Exception e) {
            ApexPages.Message error = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(error);
        }
        
        
        DisplayPopup = false;
    }
    
    public void getInfoCliente(){
        this.ClienteNombre = 'CLIENTE NO ENCONTRADO';
        this.ClienteFechaInicioRelacion = '';                                                                                         
        this.ClienteUltimaVisitaSucursal = '';
        this.ClienteUrlUltimoCaso = '';
        this.ClienteFechaUltimoCaso = '';
        this.ClienteCantidadPolizasActivas = '';
        this.ClienteReclamosAno = '';
        this.ClienteReclamosAnteriores = '';
        this.ClienteConsultasAno = '';
        this.ClienteConsultasAnteriores = '';
        this.ClienteSolicitudesAno = '';
        this.ClienteSolicitudesAnteriores = '';
        
        TPAtencion__c[] AtencionVigente = [select rut__c from TPAtencion__c where Sesion_Totalpack__r.Usuario__c =: UserInfo.getUserId() order by CreatedDate desc LIMIT 1];
        
        if (AtencionVigente.size() > 0){
            string rut = string.valueOf(AtencionVigente[0].Rut__c);
            System.debug(rut);
            
            if (rut != null && rut != '99999998'){
                Account[] cuenta = [select FirstName, LastName, Name, Fecha_de_Inicio_Relacion__c from Account where (rut__c =: rut or rut_contacto__pc =: rut) limit 1];
                
                //ultima visita sucursal
                Case[] ultCaso = [select CreatedDate from Case where (Account.rut__c =: rut or Account.rut_contacto__pc =: rut) and Canal__c = 'Sucursal' order by CreatedDate desc limit 1];
                if (ultCaso.size() > 0) {
                    integer dias = Integer.valueOf((DateTime.now().getTime() - ultCaso[0].CreatedDate.getTime())/(1000*60*60*24));
                    
                    if (dias == 0) this.ClienteUltimaVisitaSucursal = 'Hace menos de un día';
                    else this.ClienteUltimaVisitaSucursal = 'Hace ' + string.valueOf(dias) + ' dias';
                }
                
                if (cuenta.size() > 0) {
                    this.ClienteNombre = cuenta[0].Name == null ? cuenta[0].FirstName + ' ' + cuenta[0].LastName : cuenta[0].Name;
                    this.ClienteFechaInicioRelacion = string.ValueOf(cuenta[0].Fecha_de_Inicio_Relacion__c);
                    
                    // ultimo caso (en realidad es el penultimo, ya que el último caso es el que se acaba de crear en la atención)
                    Case[] c = [select Id, CreatedDate from Case where Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut order by CreatedDate desc limit 2];
                    if (c.size() > 1) {
                        this.ClienteUrlUltimoCaso = URL.getSalesforceBaseUrl().toExternalForm() + '/' + c[1].Id;
                        this.ClienteFechaUltimoCaso = string.ValueOf(c[1].CreatedDate.format('MMMMM dd, yyyy'));
                    }
                    
                    // polizas activas
                    this.ClienteCantidadPolizasActivas = string.ValueOf([select count() from Poliza__c where (Cuenta__r.Rut_contacto__pc =: rut or Cuenta__r.Rut__c =: rut) and Estatus__c = 'ACTIVA']);
                    
                    // cantidad de casos
                    this.ClienteReclamosAno = string.ValueOf([select count() from Case where RecordType.Name = 'Reclamos' and CreatedDate = THIS_YEAR and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                    this.ClienteReclamosAnteriores = string.ValueOf([select count() from Case where RecordType.Name = 'Reclamos' and CreatedDate in (LAST_N_YEARS:10, LAST_YEAR) and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                    this.ClienteConsultasAno = string.ValueOf([select count() from Case where RecordType.Name = 'Consultas' and CreatedDate = THIS_YEAR and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                    this.ClienteConsultasAnteriores = string.ValueOf([select count() from Case where RecordType.Name = 'Consultas' and CreatedDate in (LAST_N_YEARS:10, LAST_YEAR) and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                    this.ClienteSolicitudesAno = string.ValueOf([select count() from Case where RecordType.Name = 'Solicitudes' and CreatedDate = THIS_YEAR and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                    this.ClienteSolicitudesAnteriores = string.ValueOf([select count() from Case where RecordType.Name = 'Solicitudes' and CreatedDate in (LAST_N_YEARS:10, LAST_YEAR) and (Account.Rut_contacto__pc =: rut or Account.Rut__c =: rut)]);
                }
            }
        }
    }
    
    public List<TPAtencion__c> getInfoAtenciones() {
        return [select Cuenta__c, Rut__c, DV__c, Caso__c, Fecha_Hora_de_Termino__c from TPAtencion__c where Sesion_Totalpack__r.Usuario__c =: UserInfo.getUserId() and CreatedDate >=: date.today() order by Fecha_Hora_de_Termino__c desc];
    }
}