/*******************************************************************************************
 *  NOMBRE                 : CLS_DigitadorController
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO ONCOLOGICO - Gestiona VF Cotizador Express Oncológico
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/        
public class CLS_DigitadorController {

    public ParametroDigitador2 PD_Digitador2 {get;  set;}
    public String IDCANAL {get; set;}

    public class ParametroDigitador2{
        
        public string rutUsuario { get { return rutUsuario; } set { rutUsuario = value; } }
        public string dvUsuario { get { return dvUsuario; } set { dvUsuario = value; } }
        public string idCanal { get { return idCanal; } set { idCanal = value; } }
        public string rutCliente { get { return rutCliente; } set { rutCliente = value; } }
        public string idCampana { get { return idCampana; } set { idCampana = value; } }
        public string tipoFolio { get { return tipoFolio; } set { tipoFolio = value; } }
        public string poliza { get { return poliza; } set { poliza = value; } }
        public string idExterno { get { return idExterno; } set { idExterno = value; } }
        public string totalInic { get { return totalInic; } set { totalInic = value; } }
        public string preimpreso { get { return preimpreso; } set { preimpreso = value; } }
        public string direccion { get { return direccion; } set { direccion = value; } }
        public string mail { get { return mail; } set { mail = value; } }
        public string fono { get { return fono; } set { fono = value; } }
        public string celular { get { return celular; } set { celular = value; } }
        public string codComuna { get { return codComuna; } set { codComuna = value; } }
        public string codRegion { get { return codRegion; } set { codRegion = value; } }
        public string codCiudad { get { return codCiudad; } set { codCiudad = value; } }
        public string tipoCliente { get { return tipoCliente; } set { tipoCliente = value; } }
        public string persistencia { get { return persistencia; } set { persistencia = value; } }
        
        public ParametroDigitador2(string rutUsuario,string dvUsuario,string idCanal,string rutCliente,string idCampana,string tipoFolio,
        				   string poliza,string idExterno,string totalInic,string preimpreso,string direccion,string mail,string fono,
                           string celular,string codComuna,string codRegion,string codCiudad,string tipoCliente,string persistencia){            
            this.rutUsuario = rutUsuario;
            this.dvUsuario = dvUsuario;
            this.idCanal = idCanal;
            this.rutCliente = rutCliente;
            this.idCampana = idCampana;
            this.tipoFolio = tipoFolio;
            this.poliza = poliza;
            this.idExterno = idExterno;
            this.totalInic = totalInic;
            this.preimpreso = preimpreso;
            this.direccion = direccion;
            this.mail = mail;
            this.fono = fono;
            this.celular = celular;
            this.codComuna = codComuna;
            this.codRegion = codRegion;
            this.codCiudad = codCiudad;
            this.tipoCliente = tipoCliente;
            this.persistencia = persistencia;
        }
        
        public ParametroDigitador2(){
            
        }
        
    }

    /* TRABAJO CONEXIÓN PREDIGITADOR 
     * *******************************************************************************************************/   
    public PageReference cargaDatosContratantePreDigitador(){
        try{
            
            String rutUsuario = apexpages.currentpage().getparameters().get('rutUsuario');
            String dvUsuario = apexpages.currentpage().getparameters().get('dvUsuario');
            String idCanal = apexpages.currentpage().getparameters().get('idCanal'); 
            IDCANAL = '20';
            String rutCliente = apexpages.currentpage().getparameters().get('rutCliente');
            String idCampana = apexpages.currentpage().getparameters().get('idCampana');
            String tipoFolio = apexpages.currentpage().getparameters().get('tipoFolio');
            String poliza = apexpages.currentpage().getparameters().get('poliza');
            String idExterno = apexpages.currentpage().getparameters().get('idExterno');
            String totalInic = apexpages.currentpage().getparameters().get('totalInic');
            String preimpreso = apexpages.currentpage().getparameters().get('preimpreso');
            String direccion = apexpages.currentpage().getparameters().get('direccion');
            String mail = apexpages.currentpage().getparameters().get('mail');
            String fono = apexpages.currentpage().getparameters().get('fono');
            String celular = apexpages.currentpage().getparameters().get('celular');
            String codComuna = apexpages.currentpage().getparameters().get('codComuna');
            String codRegion = apexpages.currentpage().getparameters().get('codRegion');
            String codCiudad = apexpages.currentpage().getparameters().get('codCiudad');                                   
            String tipoCliente = apexpages.currentpage().getparameters().get('tipoCliente');
            String persistencia = apexpages.currentpage().getparameters().get('persistencia');              
                
            ParametroDigitador2 PD_Digitador2 = new ParametroDigitador2();
            PD_Digitador2.rutUsuario = rutUsuario;
            PD_Digitador2.dvUsuario = dvUsuario;
            PD_Digitador2.idCanal = idCanal;
            PD_Digitador2.rutCliente = rutCliente;
            PD_Digitador2.idCampana = idCampana;
            PD_Digitador2.tipoFolio = tipoFolio;
            PD_Digitador2.poliza = poliza;
            PD_Digitador2.idExterno = idExterno;
            PD_Digitador2.totalInic = totalInic;
            PD_Digitador2.preimpreso = preimpreso;
            PD_Digitador2.direccion = direccion;
            PD_Digitador2.mail = mail;
            PD_Digitador2.fono = fono;
            PD_Digitador2.celular = celular;
            PD_Digitador2.codComuna = codComuna;
            PD_Digitador2.codRegion = codRegion;
            PD_Digitador2.codCiudad = codCiudad;
            PD_Digitador2.tipoCliente = tipoCliente;
            PD_Digitador2.persistencia = persistencia;
            
            system.debug('@@@@ PD_Digitador => ' + PD_Digitador2);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'@@@@ INFORMACION => xxx ' + PD_Digitador2.idCanal + ' - ' + PD_Digitador2.persistencia));

            return null;
            
        }catch(Exception ex){
            return null;
        }
    }
    
}