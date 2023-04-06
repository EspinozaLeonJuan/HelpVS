@isTest
public class Fabricate {

	public static CaseFabricate caso() {
		return new CaseFabricate();
	}

	public static AccountFabricate cuenta() {
		return new AccountFabricate();
	}

	public static AccountGeneration cuentaTest() {
		return new AccountGeneration();
	}
    
    public static PolizaGeneration polizaTest() {
		return new PolizaGeneration();
	}
    
    public static CategoriaPolizaGeneration categoriaPolizaTest() {
		return new CategoriaPolizaGeneration();
	}

	public static CampanaVidaSecurityFabricate campanaVidaSecurity() {
		return new CampanaVidaSecurityFabricate();
	}

	public static CampaignFabricate campana() {
		return new CampaignFabricate();
	}

	public static ContactFabricate contacto() {
		return new ContactFabricate();
	}

	public static EventFabricate evento() {
		return new EventFabricate();
	}

	public static PolizaFabricate poliza() {
		return new PolizaFabricate();
	}

	public static CampaignMemberFabricate miembroDeCampana() {
		return new CampaignMemberFabricate();
	}

	public static TaskFabricate tarea() {
		return new TaskFabricate();
	}

	public static CorredorFabricate corredor(){
		return new CorredorFabricate();
	}

	public static UserFabricate usuario() {
		return new UserFabricate();
	}

	public static UserGeneration usuarioAdmin() {
		return new UserGeneration();
	}

	public static ParticipanteCampangaGeneration participanteCampagna() {
		return new ParticipanteCampangaGeneration();
	}

	public static RegionFabricate region() {
		return new RegionFabricate();
	}

	public static CiudadFabricate ciudad() {
		return new CiudadFabricate();
	}

	public static AreaFabricate area() {
		return new AreaFabricate();
	}

	public static SucursalFabricate sucursal() {
		return new SucursalFabricate();
	}

	public static CiudadSucursalFabricate ciudad_sucursal() {
		return new CiudadSucursalFabricate();
	}

	public static CategoriaDeClienteFabricate categoria_cliente() {
		return new CategoriaDeClienteFabricate();
	}

	public static RelacionDeCategoriaFabricate relacion_categoria() {
		return new RelacionDeCategoriaFabricate();
	}
	
	public static EjecutivoDeClienteFabricate ejecutivoDeCliente() {
		return new EjecutivoDeClienteFabricate();
	}
	
	public static EmailTemplateFabricate emailTemplate() {
		return new EmailTemplateFabricate();
	}
	
	public static ConfigFabricate config() {
		return new ConfigFabricate();
	}

	public static CategoriaSolucionFabricate categoriaSolucion() {
		return new CategoriaSolucionFabricate();
	}

	public static SolucionFabricate Solucion() {
		return new SolucionFabricate();
	}
}