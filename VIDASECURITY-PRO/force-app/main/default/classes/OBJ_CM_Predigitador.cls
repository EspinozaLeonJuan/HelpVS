/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 08-24-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   03-01-2021   Juan Espinoza León   Initial Version
**/
public class OBJ_CM_Predigitador {
    public String rutUsuario { get { return rutUsuario; } set { rutUsuario = value; } }
    public String dvUsuario { get { return dvUsuario; } set { dvUsuario = value; } }
    public String idCanal { get { return idCanal; } set { idCanal = value; } }
    public String rutContratante { get { return rutContratante; } set { rutContratante = value; } }
    public String idCampana { get { return idCampana; } set { idCampana = value; } }
    public String tipoFolio { get { return tipoFolio; } set { tipoFolio = value; } }
    public String poliza { get { return poliza; } set { poliza = value; } }
    public String idExterno { get { return idExterno; } set { idExterno = value; } }
    public String totalInic { get { return totalInic; } set { totalInic = value; } }
    public String preimpreso { get { return preimpreso; } set { preimpreso = value; } }
    public String direccion { get { return direccion; } set { direccion = value; } }
    public String mail { get { return mail; } set { mail = value; } }
    public String fono { get { return fono; } set { fono = value; } }
    public String celular { get { return celular; } set { celular = value; } }
    public String codComuna { get { return codComuna; } set { codComuna = value; } }
    public String codRegion { get { return codRegion; } set { codRegion = value; } }
    public String codCiudad { get { return codCiudad; } set { codCiudad = value; } }
    public String tipoCliente { get { return tipoCliente; } set { tipoCliente = value; } }
    public String persistencia { get { return persistencia; } set { persistencia = value; } }

    //Obtener url de sitio clientes vidasecurity
    public String url { get { return url; } set { url = value; } }
    public String plan { get { return plan; } set { plan = value; } }

    public String rutAseguradoTitular { get { return rutAseguradoTitular; } set { rutAseguradoTitular = value; } }
    public String direccionAsegT { get { return direccionAsegT; } set { direccionAsegT = value; } }
    public String mailAsegT { get { return mailAsegT; } set { mailAsegT = value; } }
    public String fonoAsegT { get { return fonoAsegT; } set { fonoAsegT = value; } }
    public String celularAsegT { get { return celularAsegT; } set { celularAsegT = value; } }
    public String codComunaAsegT { get { return codComunaAsegT; } set { codComunaAsegT = value; } }
    public String codRegionAsegT { get { return codRegionAsegT; } set { codRegionAsegT = value; } }
    public String codCiudadAsegT { get { return codCiudadAsegT; } set { codCiudadAsegT = value; } }


    public OBJ_CM_Predigitador(String persistencia, String rutUsuario, String dvUsuario, String rutContratante, String idCampagna,
                        String tipoFolio, String poliza, String totalInic, String direccion, String mail,
                        String fono, String celular, String numComuna, String numRegion, String numCiudad, String tipoCliente)
    {
        this.persistencia = persistencia;
        this.idCanal = '20';
        this.rutUsuario = rutUsuario;
        this.dvUsuario = dvUsuario;
        this.rutContratante = rutContratante;
        this.idCampana = idCampagna;
        this.tipoFolio = tipoFolio;
        this.poliza = poliza;
        this.totalInic = totalInic;
        this.preimpreso = '1';
        this.direccion = direccion;
        this.mail = mail;
        this.fono = fono;
        this.celular = celular;
        this.codComuna = numComuna;
        this.codRegion = numRegion;
        this.codCiudad = numCiudad;
        this.tipoCliente = tipoCliente;
        this.idExterno = '0';

      /*  this.rutUsuario = '9869387';
        this.dvUsuario = '1';
       // this.totalInic = '0d5670';
        this.persistencia = '6963129';*/

    }

    public OBJ_CM_Predigitador(String persistencia, String rutUsuario, String dvUsuario, String rutContratante, String idCampagna,
                        String tipoFolio, String poliza, String totalInic, String direccion, String mail,
                        String fono, String celular, String numComuna, String numRegion, String numCiudad, String tipoCliente, String rutAsegurado,
                        String plan, String direccionAsegurado, String mailAsegurado, String telefonoAsegurado, String celularAsegurado, String numComunaAsegurado,
                        String numCiudadAsegurado, String numRegionAsegurado)
    {
        system.debug('@@@@ persistencia --> '+persistencia);
        system.debug('@@@@ rutUsuario --> '+rutUsuario);
        system.debug('@@@@ dvUsuario --> '+dvUsuario);
        system.debug('@@@@ rutContratante --> '+rutContratante);
        system.debug('@@@@ idCampagna --> '+idCampagna);
        system.debug('@@@@ tipoFolio --> '+tipoFolio);
        system.debug('@@@@ poliza --> '+poliza);
        system.debug('@@@@ totalInic --> '+totalInic);
        system.debug('@@@@ direccion --> '+direccion);
        system.debug('@@@@ mail --> '+mail);
        system.debug('@@@@ fono --> '+fono);
        system.debug('@@@@ celular --> '+celular);
        system.debug('@@@@ numComuna --> '+numComuna);
        system.debug('@@@@ numRegion --> '+numRegion);
        system.debug('@@@@ numCiudad --> '+numCiudad);
        system.debug('@@@@ tipoCliente --> '+tipoCliente);
        system.debug('@@@@ rutAsegurado --> '+rutAsegurado);
        system.debug('@@@@ plan --> '+plan);
        system.debug('@@@@ direccionAsegurado --> '+direccionAsegurado);
        system.debug('@@@@ mailAsegurado --> '+mailAsegurado);
        system.debug('@@@@ telefonoAsegurado --> '+telefonoAsegurado);
        system.debug('@@@@ celularAsegurado --> '+celularAsegurado);
        system.debug('@@@@ numComunaAsegurado --> '+numComunaAsegurado);
        system.debug('@@@@ numCiudadAsegurado --> '+numCiudadAsegurado);
        system.debug('@@@@ numRegionAsegurado --> '+numRegionAsegurado);

        this.persistencia = persistencia;
        this.idCanal = '20';
        this.rutUsuario = rutUsuario;
        this.dvUsuario = dvUsuario;
        this.rutContratante = rutContratante;
        this.idCampana = idCampagna;
        this.tipoFolio = tipoFolio;
        this.poliza = poliza;
        this.idExterno = '0';
        this.totalInic = totalInic;
        this.preimpreso = '1';
        this.direccion = direccion;
        this.mail = mail;
        this.fono = fono;
        this.celular = celular;
        this.codComuna = numComuna;
        this.codRegion = numRegion;
        this.codCiudad = numCiudad;
        this.tipoCliente = tipoCliente;
        this.rutAseguradoTitular = rutAsegurado;
        this.plan = plan;
        this.direccionAsegT = direccionAsegurado;
        this.mailAsegT = mailAsegurado;
        this.fonoAsegT = telefonoAsegurado;
        this.celularAsegT = celularAsegurado;
        this.codComunaAsegT = numComunaAsegurado;
        this.codRegionAsegT = numRegionAsegurado;
        this.codCiudadAsegT = numCiudadAsegurado;

        /*this.rutUsuario = '9869387';
        this.dvUsuario = '1';
        this.persistencia = '6963129';*/

        system.debug('@@@@ @@@@ @@@@ @@@@ @@@@ @@@@ @@@@ @@@@ @@@@ @@@@ @@@@');

        system.debug('@@@@ persistencia --> '+this.persistencia);
        system.debug('@@@@ idCanal --> '+this.idCanal);
        system.debug('@@@@ rutUsuario --> '+ this.rutUsuario);
        system.debug('@@@@ dvUsuario --> '+this.dvUsuario);
        system.debug('@@@@ rutContratante --> '+this.rutContratante);
        system.debug('@@@@ idCampagna --> '+this.idCampana );
        system.debug('@@@@ tipoFolio --> '+this.tipoFolio);
        system.debug('@@@@ poliza --> '+this.poliza);
        system.debug('@@@@ idExterno --> '+this.idExterno);
        system.debug('@@@@ totalInic --> '+this.totalInic);
        system.debug('@@@@ preimpreso --> '+this.preimpreso);
        system.debug('@@@@ direccion --> '+this.direccion);
        system.debug('@@@@ mail --> '+this.mail);
        system.debug('@@@@ fono --> '+this.fono);
        system.debug('@@@@ celular --> '+this.celular);
        system.debug('@@@@ codComuna --> '+this.codComuna);
        system.debug('@@@@ codRegion --> '+this.codRegion);
        system.debug('@@@@ codCiudad --> '+this.codCiudad);
        system.debug('@@@@ tipoCliente --> '+this.tipoCliente);
        system.debug('@@@@ rutAseguradoTitular --> '+this.rutAseguradoTitular);
        system.debug('@@@@ plan --> '+this.plan);
        system.debug('@@@@ direccionAsegT --> '+this.direccionAsegT);
        system.debug('@@@@ mailAsegT --> '+this.mailAsegT);
        system.debug('@@@@ fonoAsegT --> '+this.fonoAsegT);
        system.debug('@@@@ celularAsegT --> '+this.celularAsegT);
        system.debug('@@@@ codComunaAsegT --> '+this.codComunaAsegT);
        system.debug('@@@@ codRegionAsegT --> '+this.codRegionAsegT);
        system.debug('@@@@ codCiudadAsegT --> '+this.codCiudadAsegT);
    }

    public OBJ_CM_Predigitador() {

    }
}