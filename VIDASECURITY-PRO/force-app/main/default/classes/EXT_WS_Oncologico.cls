/**
 * @description       :
 * @author            : Juan Espinoza Leon
 * @group             :
 * @last modified on  : 01-28-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
public class EXT_WS_Oncologico {
	private static final String s_ns0 = 'http://tempuri.org/';
    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();

	public class ArrayOfAseguradoPropuesta {
		public EXT_WS_Oncologico.AseguradoPropuesta[] AseguradoPropuesta;
		private transient String[] AseguradoPropuesta_type_info = new String[]{'AseguradoPropuesta',s_ns0,'AseguradoPropuesta','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'AseguradoPropuesta'};
	}
	public class ArrayOfBanco {
		public EXT_WS_Oncologico.Banco[] Banco;
		private transient String[] Banco_type_info = new String[]{'Banco',s_ns0,'Banco','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Banco'};
	}
	public class ArrayOfBeneficiarioPropuesta {
		public EXT_WS_Oncologico.BeneficiarioPropuesta[] BeneficiarioPropuesta;
		private transient String[] BeneficiarioPropuesta_type_info = new String[]{'BeneficiarioPropuesta',s_ns0,'BeneficiarioPropuesta','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'BeneficiarioPropuesta'};
	}
	public class ArrayOfCiudad {
		public EXT_WS_Oncologico.Ciudad[] Ciudad;
		private transient String[] Ciudad_type_info = new String[]{'Ciudad',s_ns0,'Ciudad','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Ciudad'};
	}
	public class ArrayOfCobertura {
		public EXT_WS_Oncologico.Cobertura[] Cobertura;
		private transient String[] Cobertura_type_info = new String[]{'Cobertura',s_ns0,'Cobertura','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Cobertura'};
	}
	public class ArrayOfComuna {
		public EXT_WS_Oncologico.Comuna[] Comuna;
		private transient String[] Comuna_type_info = new String[]{'Comuna',s_ns0,'Comuna','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Comuna'};
	}
	public class ArrayOfFormaPago {
		public EXT_WS_Oncologico.FormaPago[] FormaPago;
		private transient String[] FormaPago_type_info = new String[]{'FormaPago',s_ns0,'FormaPago','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'FormaPago'};
	}
	public class ArrayOfIntermediario {
		public EXT_WS_Oncologico.Intermediario[] Intermediario;
		private transient String[] Intermediario_type_info = new String[]{'Intermediario',s_ns0,'Intermediario','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Intermediario'};
	}
	public class ArrayOfIntermediarioPropuesta {
		public EXT_WS_Oncologico.IntermediarioPropuesta[] IntermediarioPropuesta;
		private transient String[] IntermediarioPropuesta_type_info = new String[]{'IntermediarioPropuesta',s_ns0,'IntermediarioPropuesta','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'IntermediarioPropuesta'};
	}
	public class ArrayOfPeriodicidadPago {
		public EXT_WS_Oncologico.PeriodicidadPago[] PeriodicidadPago;
		private transient String[] PeriodicidadPago_type_info = new String[]{'PeriodicidadPago',s_ns0,'PeriodicidadPago','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'PeriodicidadPago'};
	}
	public class ArrayOfPoliza {
		public EXT_WS_Oncologico.Poliza[] Poliza;
		private transient String[] Poliza_type_info = new String[]{'Poliza',s_ns0,'Poliza','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Poliza'};
	}
	public class ArrayOfProductoOncologico {
		public EXT_WS_Oncologico.ProductoOncologico[] ProductoOncologico;
		private transient String[] ProductoOncologico_type_info = new String[]{'ProductoOncologico',s_ns0,'ProductoOncologico','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ProductoOncologico'};
	}
	public class ArrayOfRegion {
		public EXT_WS_Oncologico.Region[] Region;
		private transient String[] Region_type_info = new String[]{'Region',s_ns0,'Region','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Region'};
	}
	public class ArrayOfRelacionFamiliar {
		public EXT_WS_Oncologico.RelacionFamiliar[] RelacionFamiliar;
		private transient String[] RelacionFamiliar_type_info = new String[]{'RelacionFamiliar',s_ns0,'RelacionFamiliar','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'RelacionFamiliar'};
	}
	public class ArrayOfSucursal {
		public EXT_WS_Oncologico.Sucursal[] Sucursal;
		private transient String[] Sucursal_type_info = new String[]{'Sucursal',s_ns0,'Sucursal','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Sucursal'};
	}
	public class ArrayOfTarjeta {
		public EXT_WS_Oncologico.Tarjeta[] Tarjeta;
		private transient String[] Tarjeta_type_info = new String[]{'Tarjeta',s_ns0,'Tarjeta','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Tarjeta'};
	}
	public class AseguradoPropuesta {
		public Integer Rut;
		public String Dv;
		public String Nombres;
		public String ApellidoPat;
		public String ApellidoMat;
		public String Mail;
		public String TelefonoFijo;
		public String TelefonoMovil;
		public String Direccion;
		public String CodComuna;
		public String CodCiudad;
		public String CodRegion;
		public DateTime FechaNacimiento;
		public String CodRelacion;
		public String CodCobert;
		public Double CapitalAseg;
		public String CodActividad;
		public String NombreCobert;
		private transient String[] Rut_type_info = new String[]{'Rut',s_ns0,'int','1','1','false'};
		private transient String[] Dv_type_info = new String[]{'Dv',s_ns0,'string','0','1','false'};
		private transient String[] Nombres_type_info = new String[]{'Nombres',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoPat_type_info = new String[]{'ApellidoPat',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoMat_type_info = new String[]{'ApellidoMat',s_ns0,'string','0','1','false'};
		private transient String[] Mail_type_info = new String[]{'Mail',s_ns0,'string','0','1','false'};
		private transient String[] TelefonoFijo_type_info = new String[]{'TelefonoFijo',s_ns0,'string','0','1','false'};
		private transient String[] TelefonoMovil_type_info = new String[]{'TelefonoMovil',s_ns0,'string','0','1','false'};
		private transient String[] Direccion_type_info = new String[]{'Direccion',s_ns0,'string','0','1','false'};
		private transient String[] CodComuna_type_info = new String[]{'CodComuna',s_ns0,'string','0','1','false'};
		private transient String[] CodCiudad_type_info = new String[]{'CodCiudad',s_ns0,'string','0','1','false'};
		private transient String[] CodRegion_type_info = new String[]{'CodRegion',s_ns0,'string','0','1','false'};
		private transient String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento',s_ns0,'dateTime','1','1','false'};
		private transient String[] CodRelacion_type_info = new String[]{'CodRelacion',s_ns0,'string','0','1','false'};
		private transient String[] CodCobert_type_info = new String[]{'CodCobert',s_ns0,'string','0','1','false'};
		private transient String[] CapitalAseg_type_info = new String[]{'CapitalAseg',s_ns0,'double','1','1','false'};
		private transient String[] CodActividad_type_info = new String[]{'CodActividad',s_ns0,'string','0','1','false'};
		private transient String[] NombreCobert_type_info = new String[]{'NombreCobert',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Rut','Dv','Nombres','ApellidoPat','ApellidoMat','Mail','TelefonoFijo','TelefonoMovil','Direccion','CodComuna','CodCiudad','CodRegion','FechaNacimiento','CodRelacion','CodCobert','CapitalAseg','CodActividad','NombreCobert'};
	}
	public class Banco {
		public String CodBanco;
		public String DescBanco;
		private transient String[] CodBanco_type_info = new String[]{'CodBanco',s_ns0,'string','0','1','false'};
		private transient String[] DescBanco_type_info = new String[]{'DescBanco',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodBanco','DescBanco'};
	}
	public class BeneficiarioPropuesta {
		public Integer Rut;
		public String Dv;
		public String Nombres;
		public String ApellidoPat;
		public String ApellidoMat;
		public DateTime FechaNacimiento;
		public String CodRelacion;
		public Double Participacion;
		public String Mail;
		public String TelefonoFijo;
		public String Direccion;
		private transient String[] Rut_type_info = new String[]{'Rut',s_ns0,'int','1','1','false'};
		private transient String[] Dv_type_info = new String[]{'Dv',s_ns0,'string','0','1','false'};
		private transient String[] Nombres_type_info = new String[]{'Nombres',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoPat_type_info = new String[]{'ApellidoPat',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoMat_type_info = new String[]{'ApellidoMat',s_ns0,'string','0','1','false'};
		private transient String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento',s_ns0,'dateTime','1','1','false'};
		private transient String[] CodRelacion_type_info = new String[]{'CodRelacion',s_ns0,'string','0','1','false'};
		private transient String[] Participacion_type_info = new String[]{'Participacion',s_ns0,'double','1','1','false'};
		private transient String[] Mail_type_info = new String[]{'Mail',s_ns0,'string','0','1','false'};
		private transient String[] TelefonoFijo_type_info = new String[]{'TelefonoFijo',s_ns0,'string','0','1','false'};
		private transient String[] Direccion_type_info = new String[]{'Direccion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Rut','Dv','Nombres','ApellidoPat','ApellidoMat','FechaNacimiento','CodRelacion','Participacion','Mail','TelefonoFijo','Direccion'};
	}
	public class Capital {
		public Double SumaAsegMin;
		public Double SumaAsegMax;
		public Double SumaAsegDefecto;
		private transient String[] SumaAsegMin_type_info = new String[]{'SumaAsegMin',s_ns0,'double','1','1','false'};
		private transient String[] SumaAsegMax_type_info = new String[]{'SumaAsegMax',s_ns0,'double','1','1','false'};
		private transient String[] SumaAsegDefecto_type_info = new String[]{'SumaAsegDefecto',s_ns0,'double','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'SumaAsegMin','SumaAsegMax','SumaAsegDefecto'};
	}
	public class CapitalUFPS {
		public Double SumaAsegDefectoUF;
		public Double SumaAsegDefectoPS;
		public Double ValorUF;
		private transient String[] SumaAsegDefectoUF_type_info = new String[]{'SumaAsegDefectoUF',s_ns0,'double','1','1','false'};
		private transient String[] SumaAsegDefectoPS_type_info = new String[]{'SumaAsegDefectoPS',s_ns0,'double','1','1','false'};
		private transient String[] ValorUF_type_info = new String[]{'ValorUF',s_ns0,'double','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'SumaAsegDefectoUF','SumaAsegDefectoPS','ValorUF'};
	}
	public class Ciudad {
		public String CodigoCiudad;
		public String CodigoRegion;
		public String CodigoSucursal;
		public String CodigoCiudadTel;
		public String DescCiudad;
		private transient String[] CodigoCiudad_type_info = new String[]{'CodigoCiudad',s_ns0,'string','0','1','false'};
		private transient String[] CodigoRegion_type_info = new String[]{'CodigoRegion',s_ns0,'string','0','1','false'};
		private transient String[] CodigoSucursal_type_info = new String[]{'CodigoSucursal',s_ns0,'string','0','1','false'};
		private transient String[] CodigoCiudadTel_type_info = new String[]{'CodigoCiudadTel',s_ns0,'string','0','1','false'};
		private transient String[] DescCiudad_type_info = new String[]{'DescCiudad',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodigoCiudad','CodigoRegion','CodigoSucursal','CodigoCiudadTel','DescCiudad'};
	}
	public class Cobertura {
		public String CodigoCobertura;
		public String DescrCobertura;
		private transient String[] CodigoCobertura_type_info = new String[]{'CodigoCobertura',s_ns0,'string','0','1','false'};
		private transient String[] DescrCobertura_type_info = new String[]{'DescrCobertura',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodigoCobertura','DescrCobertura'};
	}
	public class Comuna {
		public String CodComuna;
		public String CodEstado;
		public String CodCiudad;
		public String DescComuna;
		private transient String[] CodComuna_type_info = new String[]{'CodComuna',s_ns0,'string','0','1','false'};
		private transient String[] CodEstado_type_info = new String[]{'CodEstado',s_ns0,'string','0','1','false'};
		private transient String[] CodCiudad_type_info = new String[]{'CodCiudad',s_ns0,'string','0','1','false'};
		private transient String[] DescComuna_type_info = new String[]{'DescComuna',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodComuna','CodEstado','CodCiudad','DescComuna'};
	}
	public class ContratantePropuesta {
		public Integer Rut;
		public String Dv;
		public String Nombres;
		public String ApellidoPat;
		public String ApellidoMat;
		public String Mail;
		public String TelefonoFijo;
		public String TelefonoMovil;
		public String Direccion;
		public String CodComuna;
		public String CodCiudad;
		public String CodRegion;
		public DateTime FechaNacimiento;
		public String CodActividad;
		public String CodEstadoCivil;
		private transient String[] Rut_type_info = new String[]{'Rut',s_ns0,'int','1','1','false'};
		private transient String[] Dv_type_info = new String[]{'Dv',s_ns0,'string','0','1','false'};
		private transient String[] Nombres_type_info = new String[]{'Nombres',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoPat_type_info = new String[]{'ApellidoPat',s_ns0,'string','0','1','false'};
		private transient String[] ApellidoMat_type_info = new String[]{'ApellidoMat',s_ns0,'string','0','1','false'};
		private transient String[] Mail_type_info = new String[]{'Mail',s_ns0,'string','0','1','false'};
		private transient String[] TelefonoFijo_type_info = new String[]{'TelefonoFijo',s_ns0,'string','0','1','false'};
		private transient String[] TelefonoMovil_type_info = new String[]{'TelefonoMovil',s_ns0,'string','0','1','false'};
		private transient String[] Direccion_type_info = new String[]{'Direccion',s_ns0,'string','0','1','false'};
		private transient String[] CodComuna_type_info = new String[]{'CodComuna',s_ns0,'string','0','1','false'};
		private transient String[] CodCiudad_type_info = new String[]{'CodCiudad',s_ns0,'string','0','1','false'};
		private transient String[] CodRegion_type_info = new String[]{'CodRegion',s_ns0,'string','0','1','false'};
		private transient String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento',s_ns0,'dateTime','1','1','false'};
		private transient String[] CodActividad_type_info = new String[]{'CodActividad',s_ns0,'string','0','1','false'};
		private transient String[] CodEstadoCivil_type_info = new String[]{'CodEstadoCivil',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Rut','Dv','Nombres','ApellidoPat','ApellidoMat','Mail','TelefonoFijo','TelefonoMovil','Direccion','CodComuna','CodCiudad','CodRegion','FechaNacimiento','CodActividad','CodEstadoCivil'};
	}
	public class EliminaPropuesta_element {
		public Integer tipoFolio;
		public Integer nroPropuesta;
		public String usuario;
		public Integer canal;
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] canal_type_info = new String[]{'canal',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'tipoFolio','nroPropuesta','usuario','canal'};
	}
	public class EliminaPropuestaResponse_element {
		public EXT_WS_Oncologico.Respuesta EliminaPropuestaResult;
		private transient String[] EliminaPropuestaResult_type_info = new String[]{'EliminaPropuestaResult',s_ns0,'Respuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'EliminaPropuestaResult'};
	}
	public class ExistePropuesta_element {
		public String usuario;
		public Integer tipoFolio;
		public String idCampania;
		public Integer rut;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] idCampania_type_info = new String[]{'idCampania',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','tipoFolio','idCampania','rut'};
	}
	public class ExistePropuestaResponse_element {
		public Integer ExistePropuestaResult;
		private transient String[] ExistePropuestaResult_type_info = new String[]{'ExistePropuestaResult',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExistePropuestaResult'};
	}
	public class FncValidaEsPreImpreso_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan'};
	}
	public class FncValidaEsPreImpresoResponse_element {
		public String FncValidaEsPreImpresoResult;
		private transient String[] FncValidaEsPreImpresoResult_type_info = new String[]{'FncValidaEsPreImpresoResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'FncValidaEsPreImpresoResult'};
	}
	public class Folio {
		public String MensajeError;
		public Integer NumFolio;
		private transient String[] MensajeError_type_info = new String[]{'MensajeError',s_ns0,'string','0','1','false'};
		private transient String[] NumFolio_type_info = new String[]{'NumFolio',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'MensajeError','NumFolio'};
	}
	public class FormaPago {
		public String TipFormaPago;
		public String Descripcion;
		public String Operacion;
		private transient String[] TipFormaPago_type_info = new String[]{'TipFormaPago',s_ns0,'string','0','1','false'};
		private transient String[] Descripcion_type_info = new String[]{'Descripcion',s_ns0,'string','0','1','false'};
		private transient String[] Operacion_type_info = new String[]{'Operacion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'TipFormaPago','Descripcion','Operacion'};
	}
	public class FormaPagoPropuesta {
		public String TipFormaPago;
		public String CodBanco;
		public String CodTarjeta;
		public String NumeroCuenta;
		public DateTime FechaVencimiento;
		public Integer NumPol;
		private transient String[] TipFormaPago_type_info = new String[]{'TipFormaPago',s_ns0,'string','0','1','false'};
		private transient String[] CodBanco_type_info = new String[]{'CodBanco',s_ns0,'string','0','1','false'};
		private transient String[] CodTarjeta_type_info = new String[]{'CodTarjeta',s_ns0,'string','0','1','false'};
		private transient String[] NumeroCuenta_type_info = new String[]{'NumeroCuenta',s_ns0,'string','0','1','false'};
		private transient String[] FechaVencimiento_type_info = new String[]{'FechaVencimiento',s_ns0,'dateTime','1','1','false'};
		private transient String[] NumPol_type_info = new String[]{'NumPol',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'TipFormaPago','CodBanco','CodTarjeta','NumeroCuenta','FechaVencimiento','NumPol'};
	}
	public class GetCodigoCobertura_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular'};
	}
	public class GetCodigoCoberturaResponse_element {
		public EXT_WS_Oncologico.ArrayOfCobertura GetCodigoCoberturaResult;
		private transient String[] GetCodigoCoberturaResult_type_info = new String[]{'GetCodigoCoberturaResult',s_ns0,'ArrayOfCobertura','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetCodigoCoberturaResult'};
	}
	public class GetIntermediario_element {
		public String usuario;
		public Integer rut;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','rut'};
	}
	public class GetIntermediarioResponse_element {
		public EXT_WS_Oncologico.ArrayOfIntermediario GetIntermediarioResult;
		private transient String[] GetIntermediarioResult_type_info = new String[]{'GetIntermediarioResult',s_ns0,'ArrayOfIntermediario','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetIntermediarioResult'};
	}
	public class GetPolizaDatos_element {
		public String usuario;
		public Integer numPol;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] numPol_type_info = new String[]{'numPol',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','numPol'};
	}
	public class GetPolizaDatosResponse_element {
		public EXT_WS_Oncologico.Poliza GetPolizaDatosResult;
		private transient String[] GetPolizaDatosResult_type_info = new String[]{'GetPolizaDatosResult',s_ns0,'Poliza','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetPolizaDatosResult'};
	}
	public class GetPolizasPacPat_element {
		public String usuario;
		public Integer rut;
		public String dv;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] dv_type_info = new String[]{'dv',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','rut','dv'};
	}
	public class GetPolizasPacPatResponse_element {
		public EXT_WS_Oncologico.ArrayOfPoliza GetPolizasPacPatResult;
		private transient String[] GetPolizasPacPatResult_type_info = new String[]{'GetPolizasPacPatResult',s_ns0,'ArrayOfPoliza','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetPolizasPacPatResult'};
	}
	public class GetTarificacionCoberturaFechaNac_element {
		public String usuario;
		public String codRamo;
		public String codPlan;
		public String codRevPlan;
		public String codProd;
		public Integer fecNacimiento;
		public Double capital;
		public String codCobert;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] codRamo_type_info = new String[]{'codRamo',s_ns0,'string','0','1','false'};
		private transient String[] codPlan_type_info = new String[]{'codPlan',s_ns0,'string','0','1','false'};
		private transient String[] codRevPlan_type_info = new String[]{'codRevPlan',s_ns0,'string','0','1','false'};
		private transient String[] codProd_type_info = new String[]{'codProd',s_ns0,'string','0','1','false'};
		private transient String[] fecNacimiento_type_info = new String[]{'fecNacimiento',s_ns0,'int','1','1','false'};
		private transient String[] capital_type_info = new String[]{'capital',s_ns0,'float','1','1','false'};
		private transient String[] codCobert_type_info = new String[]{'codCobert',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','codRamo','codPlan','codRevPlan','codProd','fecNacimiento','capital','codCobert'};
	}
	public class GetTarificacionCoberturaFechaNacResponse_element {
		public EXT_WS_Oncologico.Tarificacion GetTarificacionCoberturaFechaNacResult;
		private transient String[] GetTarificacionCoberturaFechaNacResult_type_info = new String[]{'GetTarificacionCoberturaFechaNacResult',s_ns0,'Tarificacion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetTarificacionCoberturaFechaNacResult'};
	}
	public class GetTarificacionEdad_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		public String esNuevo;
		public Integer edad;
		public Double capital;
		public String codCobertura;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] esNuevo_type_info = new String[]{'esNuevo',s_ns0,'string','0','1','false'};
		private transient String[] edad_type_info = new String[]{'edad',s_ns0,'int','1','1','false'};
		private transient String[] capital_type_info = new String[]{'capital',s_ns0,'double','1','1','false'};
		private transient String[] codCobertura_type_info = new String[]{'codCobertura',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular','esNuevo','edad','capital','codCobertura'};
	}
	public class GetTarificacionEdadResponse_element {
		public EXT_WS_Oncologico.Tarificacion GetTarificacionEdadResult;
		private transient String[] GetTarificacionEdadResult_type_info = new String[]{'GetTarificacionEdadResult',s_ns0,'Tarificacion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetTarificacionEdadResult'};
	}
	public class GetTarificacionOncoEdad_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		public Integer edad;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] edad_type_info = new String[]{'edad',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular','edad'};
	}
	public class GetTarificacionOncoEdadResponse_element {
		public EXT_WS_Oncologico.Tarificacion GetTarificacionOncoEdadResult;
		private transient String[] GetTarificacionOncoEdadResult_type_info = new String[]{'GetTarificacionOncoEdadResult',s_ns0,'Tarificacion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetTarificacionOncoEdadResult'};
	}
	public class GetTarificacionOncoFechaNacimiento_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		public Integer fecNacimiento;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] fecNacimiento_type_info = new String[]{'fecNacimiento',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular','fecNacimiento'};
	}
	public class GetTarificacionOncoFechaNacimientoResponse_element {
		public EXT_WS_Oncologico.Tarificacion GetTarificacionOncoFechaNacimientoResult;
		private transient String[] GetTarificacionOncoFechaNacimientoResult_type_info = new String[]{'GetTarificacionOncoFechaNacimientoResult',s_ns0,'Tarificacion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetTarificacionOncoFechaNacimientoResult'};
	}
	public class GetUltimoProducto_element {
		public String usuario;
		public Integer tipoFolio;
		public String tipoCliente;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] tipoCliente_type_info = new String[]{'tipoCliente',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','tipoFolio','tipoCliente'};
	}
	public class GetUltimoProductoResponse_element {
		public EXT_WS_Oncologico.ArrayOfProductoOncologico GetUltimoProductoResult;
		private transient String[] GetUltimoProductoResult_type_info = new String[]{'GetUltimoProductoResult',s_ns0,'ArrayOfProductoOncologico','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'GetUltimoProductoResult'};
	}
	public class Intermediario {
		public String CodInter;
		public String ApeInter;
		public String NomInter;
		public String CodOfi;
		private transient String[] CodInter_type_info = new String[]{'CodInter',s_ns0,'string','0','1','false'};
		private transient String[] ApeInter_type_info = new String[]{'ApeInter',s_ns0,'string','0','1','false'};
		private transient String[] NomInter_type_info = new String[]{'NomInter',s_ns0,'string','0','1','false'};
		private transient String[] CodOfi_type_info = new String[]{'CodOfi',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodInter','ApeInter','NomInter','CodOfi'};
	}
	public class IntermediarioPropuesta {
		public String CodInter;
		public Double Participacion;
		private transient String[] CodInter_type_info = new String[]{'CodInter',s_ns0,'string','0','1','false'};
		private transient String[] Participacion_type_info = new String[]{'Participacion',s_ns0,'double','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodInter','Participacion'};
	}
	public class obtenerCoberturasCapital_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String codParentesco;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] codParentesco_type_info = new String[]{'codParentesco',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','codParentesco'};
	}
	public class obtenerCoberturasCapitalResponse_element {
		public String obtenerCoberturasCapitalResult;
		private transient String[] obtenerCoberturasCapitalResult_type_info = new String[]{'obtenerCoberturasCapitalResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtenerCoberturasCapitalResult'};
	}
	public class obtenerDatosPropuesta_element {
		public String idCampania;
		public Integer rut;
		public String usuario;
		public Integer canal;
		private transient String[] idCampania_type_info = new String[]{'idCampania',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] canal_type_info = new String[]{'canal',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'idCampania','rut','usuario','canal'};
	}
	public class obtenerDatosPropuestaResponse_element {
		public String obtenerDatosPropuestaResult;
		private transient String[] obtenerDatosPropuestaResult_type_info = new String[]{'obtenerDatosPropuestaResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtenerDatosPropuestaResult'};
	}
	public class ObtenerFolio_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan'};
	}
	public class ObtenerFolioResponse_element {
		public EXT_WS_Oncologico.Folio ObtenerFolioResult;
		private transient String[] ObtenerFolioResult_type_info = new String[]{'ObtenerFolioResult',s_ns0,'Folio','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerFolioResult'};
	}
	public class ObtenerListadoBancos_element {
		public String usuario;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario'};
	}
	public class ObtenerListadoBancosResponse_element {
		public EXT_WS_Oncologico.ArrayOfBanco ObtenerListadoBancosResult;
		private transient String[] ObtenerListadoBancosResult_type_info = new String[]{'ObtenerListadoBancosResult',s_ns0,'ArrayOfBanco','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoBancosResult'};
	}
	public class ObtenerListadoCiudad_element {
		public String usuario;
		public String codRegion;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] codRegion_type_info = new String[]{'codRegion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','codRegion'};
	}
	public class ObtenerListadoCiudadResponse_element {
		public EXT_WS_Oncologico.ArrayOfCiudad ObtenerListadoCiudadResult;
		private transient String[] ObtenerListadoCiudadResult_type_info = new String[]{'ObtenerListadoCiudadResult',s_ns0,'ArrayOfCiudad','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoCiudadResult'};
	}
	public class ObtenerListadoComuna_element {
		public String usuario;
		public String codComuna;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] codComuna_type_info = new String[]{'codComuna',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','codComuna'};
	}
	public class ObtenerListadoComunaResponse_element {
		public EXT_WS_Oncologico.ArrayOfComuna ObtenerListadoComunaResult;
		private transient String[] ObtenerListadoComunaResult_type_info = new String[]{'ObtenerListadoComunaResult',s_ns0,'ArrayOfComuna','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoComunaResult'};
	}
	public class ObtenerListadoFormaPago_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan'};
	}
	public class ObtenerListadoFormaPagoResponse_element {
		public EXT_WS_Oncologico.ArrayOfFormaPago ObtenerListadoFormaPagoResult;
		private transient String[] ObtenerListadoFormaPagoResult_type_info = new String[]{'ObtenerListadoFormaPagoResult',s_ns0,'ArrayOfFormaPago','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoFormaPagoResult'};
	}
	public class ObtenerListadoRegion_element {
		public String usuario;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario'};
	}
	public class ObtenerListadoRegionResponse_element {
		public EXT_WS_Oncologico.ArrayOfRegion ObtenerListadoRegionResult;
		private transient String[] ObtenerListadoRegionResult_type_info = new String[]{'ObtenerListadoRegionResult',s_ns0,'ArrayOfRegion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoRegionResult'};
	}
	public class ObtenerListadoSucursales_element {
		public String usuario;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario'};
	}
	public class ObtenerListadoSucursalesResponse_element {
		public EXT_WS_Oncologico.ArrayOfSucursal ObtenerListadoSucursalesResult;
		private transient String[] ObtenerListadoSucursalesResult_type_info = new String[]{'ObtenerListadoSucursalesResult',s_ns0,'ArrayOfSucursal','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoSucursalesResult'};
	}
	public class ObtenerListadoTarjeta_element {
		public String usuario;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario'};
	}
	public class ObtenerListadoTarjetaResponse_element {
		public EXT_WS_Oncologico.ArrayOfTarjeta ObtenerListadoTarjetaResult;
		private transient String[] ObtenerListadoTarjetaResult_type_info = new String[]{'ObtenerListadoTarjetaResult',s_ns0,'ArrayOfTarjeta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListadoTarjetaResult'};
	}
	public class ObtenerListaPeriodicidadPago_element {
		public String usuario;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario'};
	}
	public class ObtenerListaPeriodicidadPagoResponse_element {
		public EXT_WS_Oncologico.ArrayOfPeriodicidadPago ObtenerListaPeriodicidadPagoResult;
		private transient String[] ObtenerListaPeriodicidadPagoResult_type_info = new String[]{'ObtenerListaPeriodicidadPagoResult',s_ns0,'ArrayOfPeriodicidadPago','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerListaPeriodicidadPagoResult'};
	}
	public class ObtenerRelacionFamiliar_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan'};
	}
	public class ObtenerRelacionFamiliarResponse_element {
		public EXT_WS_Oncologico.ArrayOfRelacionFamiliar ObtenerRelacionFamiliarResult;
		private transient String[] ObtenerRelacionFamiliarResult_type_info = new String[]{'ObtenerRelacionFamiliarResult',s_ns0,'ArrayOfRelacionFamiliar','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerRelacionFamiliarResult'};
	}
	public class obtieneAsegurados_element {
		public Integer nroPropuesta;
		public Integer tipoFolio;
		public String usuario;
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'nroPropuesta','tipoFolio','usuario'};
	}
	public class obtieneAseguradosResponse_element {
		public EXT_WS_Oncologico.ArrayOfAseguradoPropuesta obtieneAseguradosResult;
		private transient String[] obtieneAseguradosResult_type_info = new String[]{'obtieneAseguradosResult',s_ns0,'ArrayOfAseguradoPropuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneAseguradosResult'};
	}
	public class obtieneBeneficiarios_element {
		public Integer nroPropuesta;
		public Integer tipoFolio;
		public String usuario;
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'nroPropuesta','tipoFolio','usuario'};
	}
	public class obtieneBeneficiariosResponse_element {
		public EXT_WS_Oncologico.ArrayOfBeneficiarioPropuesta obtieneBeneficiariosResult;
		private transient String[] obtieneBeneficiariosResult_type_info = new String[]{'obtieneBeneficiariosResult',s_ns0,'ArrayOfBeneficiarioPropuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneBeneficiariosResult'};
	}
	public class obtieneContratante_element {
		public Integer nroPropuesta;
		public Integer tipoFolio;
		public String usuario;
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'nroPropuesta','tipoFolio','usuario'};
	}
	public class obtieneContratanteResponse_element {
		public EXT_WS_Oncologico.ContratantePropuesta obtieneContratanteResult;
		private transient String[] obtieneContratanteResult_type_info = new String[]{'obtieneContratanteResult',s_ns0,'ContratantePropuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneContratanteResult'};
	}
	public class obtieneFormaPago_element {
		public Integer nroPropuesta;
		public Integer tipoFolio;
		public String usuario;
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'nroPropuesta','tipoFolio','usuario'};
	}
	public class obtieneFormaPagoResponse_element {
		public EXT_WS_Oncologico.FormaPagoPropuesta obtieneFormaPagoResult;
		private transient String[] obtieneFormaPagoResult_type_info = new String[]{'obtieneFormaPagoResult',s_ns0,'FormaPagoPropuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneFormaPagoResult'};
	}
	public class obtieneIntermediarios_element {
		public Integer nroPropuesta;
		public Integer tipoFolio;
		public String usuario;
		private transient String[] nroPropuesta_type_info = new String[]{'nroPropuesta',s_ns0,'int','1','1','false'};
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'nroPropuesta','tipoFolio','usuario'};
	}
	public class obtieneIntermediariosResponse_element {
		public EXT_WS_Oncologico.ArrayOfIntermediarioPropuesta obtieneIntermediariosResult;
		private transient String[] obtieneIntermediariosResult_type_info = new String[]{'obtieneIntermediariosResult',s_ns0,'ArrayOfIntermediarioPropuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneIntermediariosResult'};
	}
	public class obtienePropuesta_element {
		public String idCampana;
		public Integer rut;
		public String usuario;
		private transient String[] idCampana_type_info = new String[]{'idCampana',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'idCampana','rut','usuario'};
	}
	public class obtienePropuestaResponse_element {
		public EXT_WS_Oncologico.Propuesta obtienePropuestaResult;
		private transient String[] obtienePropuestaResult_type_info = new String[]{'obtienePropuestaResult',s_ns0,'Propuesta','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtienePropuestaResult'};
	}
	public class obtieneURLValueWeb_element {
		public Integer tipoFolio;
		public Integer numProp;
		public String usuario;
		public Integer canal;
		private transient String[] tipoFolio_type_info = new String[]{'tipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] numProp_type_info = new String[]{'numProp',s_ns0,'int','1','1','false'};
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] canal_type_info = new String[]{'canal',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'tipoFolio','numProp','usuario','canal'};
	}
	public class obtieneURLValueWebResponse_element {
		public String obtieneURLValueWebResult;
		private transient String[] obtieneURLValueWebResult_type_info = new String[]{'obtieneURLValueWebResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'obtieneURLValueWebResult'};
	}
	public class PeriodicidadPago {
		public String CodigoPago;
		public String DescPeriodicidad;
		private transient String[] CodigoPago_type_info = new String[]{'CodigoPago',s_ns0,'string','0','1','false'};
		private transient String[] DescPeriodicidad_type_info = new String[]{'DescPeriodicidad',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodigoPago','DescPeriodicidad'};
	}
	public class Poliza {
		public String NumPol;
		public String IdePol;
		public String DescPol;
		public String PagoPol;
		public String FechaPol;
		private transient String[] NumPol_type_info = new String[]{'NumPol',s_ns0,'string','0','1','false'};
		private transient String[] IdePol_type_info = new String[]{'IdePol',s_ns0,'string','0','1','false'};
		private transient String[] DescPol_type_info = new String[]{'DescPol',s_ns0,'string','0','1','false'};
		private transient String[] PagoPol_type_info = new String[]{'PagoPol',s_ns0,'string','0','1','false'};
		private transient String[] FechaPol_type_info = new String[]{'FechaPol',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'NumPol','IdePol','DescPol','PagoPol','FechaPol'};
	}
	public class PrcObtenerCapital_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String codCobert;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] codCobert_type_info = new String[]{'codCobert',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','codCobert'};
	}
	public class PrcObtenerCapitalParentesco_element {
		public String usuario;
		public String codRamo;
		public String codPlan;
		public String codRevPlan;
		public String codProd;
		public String tipoDeAsegurado;
		public String codParentesco;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] codRamo_type_info = new String[]{'codRamo',s_ns0,'string','0','1','false'};
		private transient String[] codPlan_type_info = new String[]{'codPlan',s_ns0,'string','0','1','false'};
		private transient String[] codRevPlan_type_info = new String[]{'codRevPlan',s_ns0,'string','0','1','false'};
		private transient String[] codProd_type_info = new String[]{'codProd',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] codParentesco_type_info = new String[]{'codParentesco',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','codRamo','codPlan','codRevPlan','codProd','tipoDeAsegurado','codParentesco'};
	}
	public class PrcObtenerCapitalParentescoResponse_element {
		public EXT_WS_Oncologico.CapitalUFPS PrcObtenerCapitalParentescoResult;
		private transient String[] PrcObtenerCapitalParentescoResult_type_info = new String[]{'PrcObtenerCapitalParentescoResult',s_ns0,'CapitalUFPS','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'PrcObtenerCapitalParentescoResult'};
	}
	public class PrcObtenerCapitalResponse_element {
		public EXT_WS_Oncologico.Capital PrcObtenerCapitalResult;
		private transient String[] PrcObtenerCapitalResult_type_info = new String[]{'PrcObtenerCapitalResult',s_ns0,'Capital','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'PrcObtenerCapitalResult'};
	}
	public class ProductoOncologico {
		public String DescPlanProd;
		public String CodPlan;
		public String RevPlan;
		public String CodRamoPlan;
		public String DescRamo;
		public String CodProd;
		public String TipoFolio;
		public String ContiguAlAseg;
		public String AceptaAsegAdic;
		public String AceptaBenefic;
		public String BenefAsegTit;
		public String AdjuntaArchivos;
		public String UsanMismaDireccion;
		private transient String[] DescPlanProd_type_info = new String[]{'DescPlanProd',s_ns0,'string','0','1','false'};
		private transient String[] CodPlan_type_info = new String[]{'CodPlan',s_ns0,'string','0','1','false'};
		private transient String[] RevPlan_type_info = new String[]{'RevPlan',s_ns0,'string','0','1','false'};
		private transient String[] CodRamoPlan_type_info = new String[]{'CodRamoPlan',s_ns0,'string','0','1','false'};
		private transient String[] DescRamo_type_info = new String[]{'DescRamo',s_ns0,'string','0','1','false'};
		private transient String[] CodProd_type_info = new String[]{'CodProd',s_ns0,'string','0','1','false'};
		private transient String[] TipoFolio_type_info = new String[]{'TipoFolio',s_ns0,'string','0','1','false'};
		private transient String[] ContiguAlAseg_type_info = new String[]{'ContiguAlAseg',s_ns0,'string','0','1','false'};
		private transient String[] AceptaAsegAdic_type_info = new String[]{'AceptaAsegAdic',s_ns0,'string','0','1','false'};
		private transient String[] AceptaBenefic_type_info = new String[]{'AceptaBenefic',s_ns0,'string','0','1','false'};
		private transient String[] BenefAsegTit_type_info = new String[]{'BenefAsegTit',s_ns0,'string','0','1','false'};
		private transient String[] AdjuntaArchivos_type_info = new String[]{'AdjuntaArchivos',s_ns0,'string','0','1','false'};
		private transient String[] UsanMismaDireccion_type_info = new String[]{'UsanMismaDireccion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'DescPlanProd','CodPlan','RevPlan','CodRamoPlan','DescRamo','CodProd','TipoFolio','ContiguAlAseg','AceptaAsegAdic','AceptaBenefic','BenefAsegTit','AdjuntaArchivos','UsanMismaDireccion'};
	}
	public class Propuesta {
		public Integer Nropropuesta;
		public Integer TipoFolio;
		public String CodRamo;
		public String CodProd;
		public String CodPlan;
		public String RevPlan;
		private transient String[] Nropropuesta_type_info = new String[]{'Nropropuesta',s_ns0,'int','1','1','false'};
		private transient String[] TipoFolio_type_info = new String[]{'TipoFolio',s_ns0,'int','1','1','false'};
		private transient String[] CodRamo_type_info = new String[]{'CodRamo',s_ns0,'string','0','1','false'};
		private transient String[] CodProd_type_info = new String[]{'CodProd',s_ns0,'string','0','1','false'};
		private transient String[] CodPlan_type_info = new String[]{'CodPlan',s_ns0,'string','0','1','false'};
		private transient String[] RevPlan_type_info = new String[]{'RevPlan',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Nropropuesta','TipoFolio','CodRamo','CodProd','CodPlan','RevPlan'};
	}
	public class Region {
		public String Codigo;
		public String Descripcion;
		private transient String[] Codigo_type_info = new String[]{'Codigo',s_ns0,'string','0','1','false'};
		private transient String[] Descripcion_type_info = new String[]{'Descripcion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Codigo','Descripcion'};
	}
	public class RelacionFamiliar {
		public String CodRelacion;
		public String DescRelacion;
		private transient String[] CodRelacion_type_info = new String[]{'CodRelacion',s_ns0,'string','0','1','false'};
		private transient String[] DescRelacion_type_info = new String[]{'DescRelacion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodRelacion','DescRelacion'};
	}
	public class Respuesta {
		public String MensajeError;
		public Integer NumRespuesta;
		private transient String[] MensajeError_type_info = new String[]{'MensajeError',s_ns0,'string','0','1','false'};
		private transient String[] NumRespuesta_type_info = new String[]{'NumRespuesta',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'MensajeError','NumRespuesta'};
	}
	public class Sucursal {
		public String Codigo;
		public String Descripcion;
		private transient String[] Codigo_type_info = new String[]{'Codigo',s_ns0,'string','0','1','false'};
		private transient String[] Descripcion_type_info = new String[]{'Descripcion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Codigo','Descripcion'};
	}
	public class Tarificacion {
		public Double PrimaNetaUF;
		public Double PrimaIVAUF;
		public Double PrimaBrutaUF;
		public Double PrimaNetaPS;
		public Double PrimaIVAPS;
		public Double PrimaBrutaPS;
		public Double TasaRiesgo;
		public Double ValorUF;
		private transient String[] PrimaNetaUF_type_info = new String[]{'PrimaNetaUF',s_ns0,'double','1','1','false'};
		private transient String[] PrimaIVAUF_type_info = new String[]{'PrimaIVAUF',s_ns0,'double','1','1','false'};
		private transient String[] PrimaBrutaUF_type_info = new String[]{'PrimaBrutaUF',s_ns0,'double','1','1','false'};
		private transient String[] PrimaNetaPS_type_info = new String[]{'PrimaNetaPS',s_ns0,'double','1','1','false'};
		private transient String[] PrimaIVAPS_type_info = new String[]{'PrimaIVAPS',s_ns0,'double','1','1','false'};
		private transient String[] PrimaBrutaPS_type_info = new String[]{'PrimaBrutaPS',s_ns0,'double','1','1','false'};
		private transient String[] TasaRiesgo_type_info = new String[]{'TasaRiesgo',s_ns0,'double','1','1','false'};
		private transient String[] ValorUF_type_info = new String[]{'ValorUF',s_ns0,'double','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'PrimaNetaUF','PrimaIVAUF','PrimaBrutaUF','PrimaNetaPS','PrimaIVAPS','PrimaBrutaPS','TasaRiesgo','ValorUF'};
	}
	public class Tarjeta {
		public String CodTarjeta;
		public String DescTarjeta;
		private transient String[] CodTarjeta_type_info = new String[]{'CodTarjeta',s_ns0,'string','0','1','false'};
		private transient String[] DescTarjeta_type_info = new String[]{'DescTarjeta',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'CodTarjeta','DescTarjeta'};
	}
	public class UsuarioValido {
		public String Respuesta;
		public String Mensaje;
		private transient String[] Respuesta_type_info = new String[]{'Respuesta',s_ns0,'string','0','1','false'};
		private transient String[] Mensaje_type_info = new String[]{'Mensaje',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Respuesta','Mensaje'};
	}
	public class ValidaAseguradoOnco_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String codCobert;
		public Integer rut;
		public Integer fechaNacimiento;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] codCobert_type_info = new String[]{'codCobert',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] fechaNacimiento_type_info = new String[]{'fechaNacimiento',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','codCobert','rut','fechaNacimiento'};
	}
	public class ValidaAseguradoOncoResponse_element {
		public String ValidaAseguradoOncoResult;
		private transient String[] ValidaAseguradoOncoResult_type_info = new String[]{'ValidaAseguradoOncoResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ValidaAseguradoOncoResult'};
	}
	public class ValidacionUsuarioPorEdad_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		public Integer edad;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] edad_type_info = new String[]{'edad',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular','edad'};
	}
	public class ValidacionUsuarioPorEdadResponse_element {
		public EXT_WS_Oncologico.UsuarioValido ValidacionUsuarioPorEdadResult;
		private transient String[] ValidacionUsuarioPorEdadResult_type_info = new String[]{'ValidacionUsuarioPorEdadResult',s_ns0,'UsuarioValido','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ValidacionUsuarioPorEdadResult'};
	}
	public class ValidacionUsuarioPorFecNac_element {
		public String usuario;
		public String ramo;
		public String prod;
		public String plan;
		public String revPlan;
		public String tipoDeAsegurado;
		public String relacionConTitular;
		public Integer fechaNacimiento;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] ramo_type_info = new String[]{'ramo',s_ns0,'string','0','1','false'};
		private transient String[] prod_type_info = new String[]{'prod',s_ns0,'string','0','1','false'};
		private transient String[] plan_type_info = new String[]{'plan',s_ns0,'string','0','1','false'};
		private transient String[] revPlan_type_info = new String[]{'revPlan',s_ns0,'string','0','1','false'};
		private transient String[] tipoDeAsegurado_type_info = new String[]{'tipoDeAsegurado',s_ns0,'string','0','1','false'};
		private transient String[] relacionConTitular_type_info = new String[]{'relacionConTitular',s_ns0,'string','0','1','false'};
		private transient String[] fechaNacimiento_type_info = new String[]{'fechaNacimiento',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','ramo','prod','plan','revPlan','tipoDeAsegurado','relacionConTitular','fechaNacimiento'};
	}
	public class ValidacionUsuarioPorFecNacResponse_element {
		public EXT_WS_Oncologico.UsuarioValido ValidacionUsuarioPorFecNacResult;
		private transient String[] ValidacionUsuarioPorFecNacResult_type_info = new String[]{'ValidacionUsuarioPorFecNacResult',s_ns0,'UsuarioValido','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ValidacionUsuarioPorFecNacResult'};
	}
	public class ValidaCliente_element {
		public String usuario;
		public Integer rut;
		public String dv;
		private transient String[] usuario_type_info = new String[]{'usuario',s_ns0,'string','0','1','false'};
		private transient String[] rut_type_info = new String[]{'rut',s_ns0,'int','1','1','false'};
		private transient String[] dv_type_info = new String[]{'dv',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'usuario','rut','dv'};
	}
	public class ValidaClienteResponse_element {
		public Integer ValidaClienteResult;
		private transient String[] ValidaClienteResult_type_info = new String[]{'ValidaClienteResult',s_ns0,'int','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ValidaClienteResult'};
	}
	public class WsProductoOncologicoSoap {
		public String endpoint_x = servicio.URL_EXT_WS_Oncologico__c;//'https://servicios.vidasecurity.cl/wsProductoOnco/wsProductoOncologico.asmx';
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x = 120000;
		private transient String[] ns_map_type_info = new String[]{'http://tempuri.org/','EXT_WS_Oncologico'};
		public EXT_WS_Oncologico.Respuesta EliminaPropuesta(Integer tipoFolio,Integer nroPropuesta,String usuario,Integer canal) {
			EXT_WS_Oncologico.EliminaPropuesta_element request_x = new EXT_WS_Oncologico.EliminaPropuesta_element();
			EXT_WS_Oncologico.EliminaPropuestaResponse_element response_x;
			request_x.tipoFolio = tipoFolio;
			request_x.nroPropuesta = nroPropuesta;
			request_x.usuario = usuario;
			request_x.canal = canal;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.EliminaPropuestaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.EliminaPropuestaResponse_element>();
			response_map_x.put('response_x', response_x);

            if (!Test.isRunningTest())
			{
				//endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/EliminaPropuesta', // The SOAP action.
				s_ns0, // The request namespace.
				'EliminaPropuesta', // The request name.
				s_ns0, // The response namespace.
				'EliminaPropuestaResponse', //  The response name.
				'EXT_WS_Oncologico.EliminaPropuestaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.EliminaPropuestaResult;
		}
		public Integer ExistePropuesta(String usuario,Integer tipoFolio,String idCampania,Integer rut) {
			EXT_WS_Oncologico.ExistePropuesta_element request_x = new EXT_WS_Oncologico.ExistePropuesta_element();
			EXT_WS_Oncologico.ExistePropuestaResponse_element response_x;
			request_x.usuario = usuario;
			request_x.tipoFolio = tipoFolio;
			request_x.idCampania = idCampania;
			request_x.rut = rut;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ExistePropuestaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ExistePropuestaResponse_element>();
			response_map_x.put('response_x', response_x);

                   /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ExistePropuesta', // The SOAP action.
				s_ns0, // The request namespace.
				'ExistePropuesta', // The request name.
				s_ns0, // The response namespace.
				'ExistePropuestaResponse', //  The response name.
				'EXT_WS_Oncologico.ExistePropuestaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ExistePropuestaResult;
		}
		public String FncValidaEsPreImpreso(String usuario,String ramo,String prod,String plan,String revPlan) {
			EXT_WS_Oncologico.FncValidaEsPreImpreso_element request_x = new EXT_WS_Oncologico.FncValidaEsPreImpreso_element();
			EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element>();
			response_map_x.put('response_x', response_x);

         /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/
			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/FncValidaEsPreImpreso', // The SOAP action.
				s_ns0, // The request namespace.
				'FncValidaEsPreImpreso', // The request name.
				s_ns0, // The response namespace.
				'FncValidaEsPreImpresoResponse', //  The response name.
				'EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.FncValidaEsPreImpresoResult;
		}
		public EXT_WS_Oncologico.ArrayOfCobertura GetCodigoCobertura(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular) {
			EXT_WS_Oncologico.GetCodigoCobertura_element request_x = new EXT_WS_Oncologico.GetCodigoCobertura_element();
			EXT_WS_Oncologico.GetCodigoCoberturaResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetCodigoCoberturaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetCodigoCoberturaResponse_element>();
			response_map_x.put('response_x', response_x);

                   /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

            WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetCodigoCobertura', // The SOAP action.
				s_ns0, // The request namespace.
				'GetCodigoCobertura', // The request name.
				s_ns0, // The response namespace.
				'GetCodigoCoberturaResponse', //  The response name.
				'EXT_WS_Oncologico.GetCodigoCoberturaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetCodigoCoberturaResult;
		}
		public EXT_WS_Oncologico.ArrayOfIntermediario GetIntermediario(String usuario,Integer rut) {
			EXT_WS_Oncologico.GetIntermediario_element request_x = new EXT_WS_Oncologico.GetIntermediario_element();
			EXT_WS_Oncologico.GetIntermediarioResponse_element response_x;
			request_x.usuario = usuario;
			request_x.rut = rut;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetIntermediarioResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetIntermediarioResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetIntermediario', // The SOAP action.
				s_ns0, // The request namespace.
				'GetIntermediario', // The request name.
				s_ns0, // The response namespace.
				'GetIntermediarioResponse', //  The response name.
				'EXT_WS_Oncologico.GetIntermediarioResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetIntermediarioResult;
		}
		public EXT_WS_Oncologico.Poliza GetPolizaDatos(String usuario,Integer numPol) {
			EXT_WS_Oncologico.GetPolizaDatos_element request_x = new EXT_WS_Oncologico.GetPolizaDatos_element();
			EXT_WS_Oncologico.GetPolizaDatosResponse_element response_x;
			request_x.usuario = usuario;
			request_x.numPol = numPol;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetPolizaDatosResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetPolizaDatosResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetPolizaDatos', // The SOAP action.
				s_ns0, // The request namespace.
				'GetPolizaDatos', // The request name.
				s_ns0, // The response namespace.
				'GetPolizaDatosResponse', //  The response name.
				'EXT_WS_Oncologico.GetPolizaDatosResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetPolizaDatosResult;
		}
		public EXT_WS_Oncologico.ArrayOfPoliza GetPolizasPacPat(String usuario,Integer rut,String dv) {
			EXT_WS_Oncologico.GetPolizasPacPat_element request_x = new EXT_WS_Oncologico.GetPolizasPacPat_element();
			EXT_WS_Oncologico.GetPolizasPacPatResponse_element response_x;
			request_x.usuario = usuario;
			request_x.rut = rut;
			request_x.dv = dv;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetPolizasPacPatResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetPolizasPacPatResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetPolizasPacPat', // The SOAP action.
				s_ns0, // The request namespace.
				'GetPolizasPacPat', // The request name.
				s_ns0, // The response namespace.
				'GetPolizasPacPatResponse', //  The response name.
				'EXT_WS_Oncologico.GetPolizasPacPatResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetPolizasPacPatResult;
		}
		public EXT_WS_Oncologico.Tarificacion GetTarificacionCoberturaFechaNac(String usuario,String codRamo,String codPlan,String codRevPlan,String codProd,Integer fecNacimiento,Double capital,String codCobert) {
			EXT_WS_Oncologico.GetTarificacionCoberturaFechaNac_element request_x = new EXT_WS_Oncologico.GetTarificacionCoberturaFechaNac_element();
			EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element response_x;
			request_x.usuario = usuario;
			request_x.codRamo = codRamo;
			request_x.codPlan = codPlan;
			request_x.codRevPlan = codRevPlan;
			request_x.codProd = codProd;
			request_x.fecNacimiento = fecNacimiento;
			request_x.capital = capital;
			request_x.codCobert = codCobert;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetTarificacionCoberturaFechaNac', // The SOAP action.
				s_ns0, // The request namespace.
				'GetTarificacionCoberturaFechaNac', // The request name.
				s_ns0, // The response namespace.
				'GetTarificacionCoberturaFechaNacResponse', //  The response name.
				'EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetTarificacionCoberturaFechaNacResult;
		}
		public EXT_WS_Oncologico.Tarificacion GetTarificacionEdad(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,String esNuevo,Integer edad,Double capital,String codCobertura) {
			EXT_WS_Oncologico.GetTarificacionEdad_element request_x = new EXT_WS_Oncologico.GetTarificacionEdad_element();
			EXT_WS_Oncologico.GetTarificacionEdadResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
			request_x.esNuevo = esNuevo;
			request_x.edad = edad;
			request_x.capital = capital;
			request_x.codCobertura = codCobertura;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetTarificacionEdadResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetTarificacionEdadResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetTarificacionEdad', // The SOAP action.
				s_ns0, // The request namespace.
				'GetTarificacionEdad', // The request name.
				s_ns0, // The response namespace.
				'GetTarificacionEdadResponse', //  The response name.
				'EXT_WS_Oncologico.GetTarificacionEdadResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetTarificacionEdadResult;
		}
		public EXT_WS_Oncologico.Tarificacion GetTarificacionOncoEdad(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer edad) {
			EXT_WS_Oncologico.GetTarificacionOncoEdad_element request_x = new EXT_WS_Oncologico.GetTarificacionOncoEdad_element();
			EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
			request_x.edad = edad;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetTarificacionOncoEdad', // The SOAP action.
				s_ns0, // The request namespace.
				'GetTarificacionOncoEdad', // The request name.
				s_ns0, // The response namespace.
				'GetTarificacionOncoEdadResponse', //  The response name.
				'EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetTarificacionOncoEdadResult;
		}
		public EXT_WS_Oncologico.Tarificacion GetTarificacionOncoFechaNacimiento(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer fecNacimiento) {
			EXT_WS_Oncologico.GetTarificacionOncoFechaNacimiento_element request_x = new EXT_WS_Oncologico.GetTarificacionOncoFechaNacimiento_element();
			EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
			request_x.fecNacimiento = fecNacimiento;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element>();
			response_map_x.put('response_x', response_x);

             /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetTarificacionOncoFechaNacimiento', // The SOAP action.
				s_ns0, // The request namespace.
				'GetTarificacionOncoFechaNacimiento', // The request name.
				s_ns0, // The response namespace.
				'GetTarificacionOncoFechaNacimientoResponse', //  The response name.
				'EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetTarificacionOncoFechaNacimientoResult;
		}
		public EXT_WS_Oncologico.ArrayOfProductoOncologico GetUltimoProducto(String usuario,Integer tipoFolio,String tipoCliente) {
			EXT_WS_Oncologico.GetUltimoProducto_element request_x = new EXT_WS_Oncologico.GetUltimoProducto_element();
			EXT_WS_Oncologico.GetUltimoProductoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.tipoFolio = tipoFolio;
			request_x.tipoCliente = tipoCliente;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.GetUltimoProductoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.GetUltimoProductoResponse_element>();
			response_map_x.put('response_x', response_x);

                /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/GetUltimoProducto', // The SOAP action.
				s_ns0, // The request namespace.
				'GetUltimoProducto', // The request name.
				s_ns0, // The response namespace.
				'GetUltimoProductoResponse', //  The response name.
				'EXT_WS_Oncologico.GetUltimoProductoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.GetUltimoProductoResult;
		}
		public String obtenerCoberturasCapital(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String codParentesco) {
			EXT_WS_Oncologico.obtenerCoberturasCapital_element request_x = new EXT_WS_Oncologico.obtenerCoberturasCapital_element();
			EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.codParentesco = codParentesco;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtenerCoberturasCapital', // The SOAP action.
				s_ns0, // The request namespace.
				'obtenerCoberturasCapital', // The request name.
				s_ns0, // The response namespace.
				'obtenerCoberturasCapitalResponse', //  The response name.
				'EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtenerCoberturasCapitalResult;
		}
		public String obtenerDatosPropuesta(String idCampania,Integer rut,String usuario,Integer canal) {
			EXT_WS_Oncologico.obtenerDatosPropuesta_element request_x = new EXT_WS_Oncologico.obtenerDatosPropuesta_element();
			EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element response_x;
			request_x.idCampania = idCampania;
			request_x.rut = rut;
			request_x.usuario = usuario;
			request_x.canal = canal;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element>();
			response_map_x.put('response_x', response_x);

                   /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtenerDatosPropuesta', // The SOAP action.
				s_ns0, // The request namespace.
				'obtenerDatosPropuesta', // The request name.
				s_ns0, // The response namespace.
				'obtenerDatosPropuestaResponse', //  The response name.
				'EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtenerDatosPropuestaResult;
		}
		public EXT_WS_Oncologico.Folio ObtenerFolio(String usuario,String ramo,String prod,String plan,String revPlan) {
			EXT_WS_Oncologico.ObtenerFolio_element request_x = new EXT_WS_Oncologico.ObtenerFolio_element();
			EXT_WS_Oncologico.ObtenerFolioResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerFolioResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerFolioResponse_element>();
			response_map_x.put('response_x', response_x);

               /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerFolio', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerFolio', // The request name.
				s_ns0, // The response namespace.
				'ObtenerFolioResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerFolioResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerFolioResult;
		}
		public EXT_WS_Oncologico.ArrayOfBanco ObtenerListadoBancos(String usuario) {
			EXT_WS_Oncologico.ObtenerListadoBancos_element request_x = new EXT_WS_Oncologico.ObtenerListadoBancos_element();
			EXT_WS_Oncologico.ObtenerListadoBancosResponse_element response_x;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoBancosResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoBancosResponse_element>();
			response_map_x.put('response_x', response_x);

                   /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoBancos', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoBancos', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoBancosResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoBancosResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoBancosResult;
		}
		public EXT_WS_Oncologico.ArrayOfCiudad ObtenerListadoCiudad(String usuario,String codRegion) {
			EXT_WS_Oncologico.ObtenerListadoCiudad_element request_x = new EXT_WS_Oncologico.ObtenerListadoCiudad_element();
			EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element response_x;
			request_x.usuario = usuario;
			request_x.codRegion = codRegion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element>();
			response_map_x.put('response_x', response_x);

               /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoCiudad', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoCiudad', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoCiudadResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoCiudadResult;
		}
		public EXT_WS_Oncologico.ArrayOfComuna ObtenerListadoComuna(String usuario,String codComuna) {
			EXT_WS_Oncologico.ObtenerListadoComuna_element request_x = new EXT_WS_Oncologico.ObtenerListadoComuna_element();
			EXT_WS_Oncologico.ObtenerListadoComunaResponse_element response_x;
			request_x.usuario = usuario;
			request_x.codComuna = codComuna;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoComunaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoComunaResponse_element>();
			response_map_x.put('response_x', response_x);

             /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoComuna', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoComuna', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoComunaResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoComunaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoComunaResult;
		}
		public EXT_WS_Oncologico.ArrayOfFormaPago ObtenerListadoFormaPago(String usuario,String ramo,String prod,String plan,String revPlan) {
			EXT_WS_Oncologico.ObtenerListadoFormaPago_element request_x = new EXT_WS_Oncologico.ObtenerListadoFormaPago_element();
			EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element>();
			response_map_x.put('response_x', response_x);
                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/
			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoFormaPago', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoFormaPago', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoFormaPagoResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoFormaPagoResult;
		}
		public EXT_WS_Oncologico.ArrayOfRegion ObtenerListadoRegion(String usuario) {
			EXT_WS_Oncologico.ObtenerListadoRegion_element request_x = new EXT_WS_Oncologico.ObtenerListadoRegion_element();
			EXT_WS_Oncologico.ObtenerListadoRegionResponse_element response_x;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoRegionResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoRegionResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoRegion', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoRegion', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoRegionResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoRegionResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoRegionResult;
		}
		public EXT_WS_Oncologico.ArrayOfSucursal ObtenerListadoSucursales(String usuario) {
			EXT_WS_Oncologico.ObtenerListadoSucursales_element request_x = new EXT_WS_Oncologico.ObtenerListadoSucursales_element();
			EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element response_x;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element>();
			response_map_x.put('response_x', response_x);

                /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoSucursales', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoSucursales', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoSucursalesResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoSucursalesResult;
		}
		public EXT_WS_Oncologico.ArrayOfTarjeta ObtenerListadoTarjeta(String usuario) {
			EXT_WS_Oncologico.ObtenerListadoTarjeta_element request_x = new EXT_WS_Oncologico.ObtenerListadoTarjeta_element();
			EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element response_x;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListadoTarjeta', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListadoTarjeta', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListadoTarjetaResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListadoTarjetaResult;
		}
		public EXT_WS_Oncologico.ArrayOfPeriodicidadPago ObtenerListaPeriodicidadPago(String usuario) {
			EXT_WS_Oncologico.ObtenerListaPeriodicidadPago_element request_x = new EXT_WS_Oncologico.ObtenerListaPeriodicidadPago_element();
			EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element response_x;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element>();
			response_map_x.put('response_x', response_x);

              /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerListaPeriodicidadPago', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerListaPeriodicidadPago', // The request name.
				s_ns0, // The response namespace.
				'ObtenerListaPeriodicidadPagoResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerListaPeriodicidadPagoResult;
		}
		public EXT_WS_Oncologico.ArrayOfRelacionFamiliar ObtenerRelacionFamiliar(String usuario,String ramo,String prod,String plan,String revPlan) {
			EXT_WS_Oncologico.ObtenerRelacionFamiliar_element request_x = new EXT_WS_Oncologico.ObtenerRelacionFamiliar_element();
			EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element>();
			response_map_x.put('response_x', response_x);

             /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ObtenerRelacionFamiliar', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerRelacionFamiliar', // The request name.
				s_ns0, // The response namespace.
				'ObtenerRelacionFamiliarResponse', //  The response name.
				'EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerRelacionFamiliarResult;
		}
		public EXT_WS_Oncologico.ArrayOfAseguradoPropuesta obtieneAsegurados(Integer nroPropuesta,Integer tipoFolio,String usuario) {
			EXT_WS_Oncologico.obtieneAsegurados_element request_x = new EXT_WS_Oncologico.obtieneAsegurados_element();
			EXT_WS_Oncologico.obtieneAseguradosResponse_element response_x;
			request_x.nroPropuesta = nroPropuesta;
			request_x.tipoFolio = tipoFolio;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneAseguradosResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneAseguradosResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneAsegurados', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneAsegurados', // The request name.
				s_ns0, // The response namespace.
				'obtieneAseguradosResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneAseguradosResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneAseguradosResult;
		}
		public EXT_WS_Oncologico.ArrayOfBeneficiarioPropuesta obtieneBeneficiarios(Integer nroPropuesta,Integer tipoFolio,String usuario) {
			EXT_WS_Oncologico.obtieneBeneficiarios_element request_x = new EXT_WS_Oncologico.obtieneBeneficiarios_element();
			EXT_WS_Oncologico.obtieneBeneficiariosResponse_element response_x;
			request_x.nroPropuesta = nroPropuesta;
			request_x.tipoFolio = tipoFolio;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneBeneficiariosResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneBeneficiariosResponse_element>();
			response_map_x.put('response_x', response_x);

              /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneBeneficiarios', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneBeneficiarios', // The request name.
				s_ns0, // The response namespace.
				'obtieneBeneficiariosResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneBeneficiariosResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneBeneficiariosResult;
		}
		public EXT_WS_Oncologico.ContratantePropuesta obtieneContratante(Integer nroPropuesta,Integer tipoFolio,String usuario) {
			EXT_WS_Oncologico.obtieneContratante_element request_x = new EXT_WS_Oncologico.obtieneContratante_element();
			EXT_WS_Oncologico.obtieneContratanteResponse_element response_x;
			request_x.nroPropuesta = nroPropuesta;
			request_x.tipoFolio = tipoFolio;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneContratanteResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneContratanteResponse_element>();
			response_map_x.put('response_x', response_x);

                  /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneContratante', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneContratante', // The request name.
				s_ns0, // The response namespace.
				'obtieneContratanteResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneContratanteResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneContratanteResult;
		}
		public EXT_WS_Oncologico.FormaPagoPropuesta obtieneFormaPago(Integer nroPropuesta,Integer tipoFolio,String usuario) {
			EXT_WS_Oncologico.obtieneFormaPago_element request_x = new EXT_WS_Oncologico.obtieneFormaPago_element();
			EXT_WS_Oncologico.obtieneFormaPagoResponse_element response_x;
			request_x.nroPropuesta = nroPropuesta;
			request_x.tipoFolio = tipoFolio;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneFormaPagoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneFormaPagoResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneFormaPago', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneFormaPago', // The request name.
				s_ns0, // The response namespace.
				'obtieneFormaPagoResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneFormaPagoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneFormaPagoResult;
		}
		public EXT_WS_Oncologico.ArrayOfIntermediarioPropuesta obtieneIntermediarios(Integer nroPropuesta,Integer tipoFolio,String usuario) {
			EXT_WS_Oncologico.obtieneIntermediarios_element request_x = new EXT_WS_Oncologico.obtieneIntermediarios_element();
			EXT_WS_Oncologico.obtieneIntermediariosResponse_element response_x;
			request_x.nroPropuesta = nroPropuesta;
			request_x.tipoFolio = tipoFolio;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneIntermediariosResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneIntermediariosResponse_element>();
			response_map_x.put('response_x', response_x);

               /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneIntermediarios', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneIntermediarios', // The request name.
				s_ns0, // The response namespace.
				'obtieneIntermediariosResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneIntermediariosResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneIntermediariosResult;
		}
		public EXT_WS_Oncologico.Propuesta obtienePropuesta(String idCampana,Integer rut,String usuario) {
			EXT_WS_Oncologico.obtienePropuesta_element request_x = new EXT_WS_Oncologico.obtienePropuesta_element();
			EXT_WS_Oncologico.obtienePropuestaResponse_element response_x;
			request_x.idCampana = idCampana;
			request_x.rut = rut;
			request_x.usuario = usuario;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtienePropuestaResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtienePropuestaResponse_element>();
			response_map_x.put('response_x', response_x);

                /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtienePropuesta', // The SOAP action.
				s_ns0, // The request namespace.
				'obtienePropuesta', // The request name.
				s_ns0, // The response namespace.
				'obtienePropuestaResponse', //  The response name.
				'EXT_WS_Oncologico.obtienePropuestaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtienePropuestaResult;
		}
		public String obtieneURLValueWeb(Integer tipoFolio,Integer numProp,String usuario,Integer canal) {
			EXT_WS_Oncologico.obtieneURLValueWeb_element request_x = new EXT_WS_Oncologico.obtieneURLValueWeb_element();
			EXT_WS_Oncologico.obtieneURLValueWebResponse_element response_x;
			request_x.tipoFolio = tipoFolio;
			request_x.numProp = numProp;
			request_x.usuario = usuario;
			request_x.canal = canal;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.obtieneURLValueWebResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.obtieneURLValueWebResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/obtieneURLValueWeb', // The SOAP action.
				s_ns0, // The request namespace.
				'obtieneURLValueWeb', // The request name.
				s_ns0, // The response namespace.
				'obtieneURLValueWebResponse', //  The response name.
				'EXT_WS_Oncologico.obtieneURLValueWebResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.obtieneURLValueWebResult;
		}
		public EXT_WS_Oncologico.Capital PrcObtenerCapital(String usuario,String ramo,String prod,String plan,String revPlan,String codCobert) {
			EXT_WS_Oncologico.PrcObtenerCapital_element request_x = new EXT_WS_Oncologico.PrcObtenerCapital_element();
			EXT_WS_Oncologico.PrcObtenerCapitalResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.codCobert = codCobert;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.PrcObtenerCapitalResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.PrcObtenerCapitalResponse_element>();
			response_map_x.put('response_x', response_x);

             /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/PrcObtenerCapital', // The SOAP action.
				s_ns0, // The request namespace.
				'PrcObtenerCapital', // The request name.
				s_ns0, // The response namespace.
				'PrcObtenerCapitalResponse', //  The response name.
				'EXT_WS_Oncologico.PrcObtenerCapitalResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.PrcObtenerCapitalResult;
		}
		public EXT_WS_Oncologico.CapitalUFPS PrcObtenerCapitalParentesco(String usuario,String codRamo,String codPlan,String codRevPlan,String codProd,String tipoDeAsegurado,String codParentesco) {
			EXT_WS_Oncologico.PrcObtenerCapitalParentesco_element request_x = new EXT_WS_Oncologico.PrcObtenerCapitalParentesco_element();
			EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.codRamo = codRamo;
			request_x.codPlan = codPlan;
			request_x.codRevPlan = codRevPlan;
			request_x.codProd = codProd;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.codParentesco = codParentesco;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/PrcObtenerCapitalParentesco', // The SOAP action.
				s_ns0, // The request namespace.
				'PrcObtenerCapitalParentesco', // The request name.
				s_ns0, // The response namespace.
				'PrcObtenerCapitalParentescoResponse', //  The response name.
				'EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.PrcObtenerCapitalParentescoResult;
		}
		public String ValidaAseguradoOnco(String usuario,String ramo,String prod,String plan,String revPlan,String codCobert,Integer rut,Integer fechaNacimiento) {
			EXT_WS_Oncologico.ValidaAseguradoOnco_element request_x = new EXT_WS_Oncologico.ValidaAseguradoOnco_element();
			EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.codCobert = codCobert;
			request_x.rut = rut;
			request_x.fechaNacimiento = fechaNacimiento;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ValidaAseguradoOnco', // The SOAP action.
				s_ns0, // The request namespace.
				'ValidaAseguradoOnco', // The request name.
				s_ns0, // The response namespace.
				'ValidaAseguradoOncoResponse', //  The response name.
				'EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidaAseguradoOncoResult;
		}
		public EXT_WS_Oncologico.UsuarioValido ValidacionUsuarioPorEdad(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer edad) {
			EXT_WS_Oncologico.ValidacionUsuarioPorEdad_element request_x = new EXT_WS_Oncologico.ValidacionUsuarioPorEdad_element();
			EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
			request_x.edad = edad;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element>();
			response_map_x.put('response_x', response_x);

                 /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ValidacionUsuarioPorEdad', // The SOAP action.
				s_ns0, // The request namespace.
				'ValidacionUsuarioPorEdad', // The request name.
				s_ns0, // The response namespace.
				'ValidacionUsuarioPorEdadResponse', //  The response name.
				'EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidacionUsuarioPorEdadResult;
		}
		public EXT_WS_Oncologico.UsuarioValido ValidacionUsuarioPorFecNac(String usuario,String ramo,String prod,String plan,String revPlan,String tipoDeAsegurado,String relacionConTitular,Integer fechaNacimiento) {
			EXT_WS_Oncologico.ValidacionUsuarioPorFecNac_element request_x = new EXT_WS_Oncologico.ValidacionUsuarioPorFecNac_element();
			EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element response_x;
			request_x.usuario = usuario;
			request_x.ramo = ramo;
			request_x.prod = prod;
			request_x.plan = plan;
			request_x.revPlan = revPlan;
			request_x.tipoDeAsegurado = tipoDeAsegurado;
			request_x.relacionConTitular = relacionConTitular;
			request_x.fechaNacimiento = fechaNacimiento;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element>();
			response_map_x.put('response_x', response_x);

                /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ValidacionUsuarioPorFecNac', // The SOAP action.
				s_ns0, // The request namespace.
				'ValidacionUsuarioPorFecNac', // The request name.
				s_ns0, // The response namespace.
				'ValidacionUsuarioPorFecNacResponse', //  The response name.
				'EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidacionUsuarioPorFecNacResult;
		}
		public Integer ValidaCliente(String usuario,Integer rut,String dv) {
			EXT_WS_Oncologico.ValidaCliente_element request_x = new EXT_WS_Oncologico.ValidaCliente_element();
			EXT_WS_Oncologico.ValidaClienteResponse_element response_x;
			request_x.usuario = usuario;
			request_x.rut = rut;
			request_x.dv = dv;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Oncologico.ValidaClienteResponse_element> response_map_x = new Map<String, EXT_WS_Oncologico.ValidaClienteResponse_element>();
			response_map_x.put('response_x', response_x);

                /*   if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSONCO_ENDPOINT');
			}
*/

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://tempuri.org/ValidaCliente', // The SOAP action.
				s_ns0, // The request namespace.
				'ValidaCliente', // The request name.
				s_ns0, // The response namespace.
				'ValidaClienteResponse', //  The response name.
				'EXT_WS_Oncologico.ValidaClienteResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidaClienteResult;
		}
	}
}