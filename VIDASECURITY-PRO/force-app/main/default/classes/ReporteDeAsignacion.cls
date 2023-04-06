public with sharing class ReporteDeAsignacion {
	
	private static final String COLUMN_SEPARATOR = ';';
	private static final String name = 'reporte_asignacion.csv';
	
	public String csv {get; set;}
	private static ReporteDeAsignacion reporte;
	
	public ReporteDeAsignacion() {
		this.csv = '';
			}
	
	public static void newInstance() {
String username = UserInfo.getUserName();
		if (username != null && username.startsWith('gocode@security.cl'))
		reporte = new ReporteDeAsignacion();
			}
			
			public static void addHeaders() {
				if (reporte != null)
			reporte.csv = 'Categoría Cliente' + COLUMN_SEPARATOR + 'Ciudad Particular' + COLUMN_SEPARATOR + 'Peso Cuenta' + COLUMN_SEPARATOR + 'Cliente' + COLUMN_SEPARATOR + 'Acción' + COLUMN_SEPARATOR + 'Ejecutivo' + COLUMN_SEPARATOR + 'Categoria Ejecutivo' + COLUMN_SEPARATOR + 'Sucursal Asignada' + COLUMN_SEPARATOR + 'Porcentaje Asignación' + COLUMN_SEPARATOR + 'Cantidad a Asignar' + COLUMN_SEPARATOR + 'Total de Clientes' + COLUMN_SEPARATOR + 'Clientes Asignados' + COLUMN_SEPARATOR + 'Id Ejecutivo\r\n';
						}
						
						public static void addRow(String categoriaCliente, String ciudadParticular, Decimal pesoCuenta, String cliente, String accion, String ejecutivo, String categoriaEjecutivo, String sucursalAsignada, String porcentajeAsignacion, Decimal cantidadAAsignar, Decimal totalDeClientes, Decimal clientesAsignados, Integer idEjecutivo) {
							if (reporte != null)
			reporte.csv += categoriaCliente + COLUMN_SEPARATOR + ciudadParticular + COLUMN_SEPARATOR + pesoCuenta + COLUMN_SEPARATOR + cliente + COLUMN_SEPARATOR + accion + COLUMN_SEPARATOR + ejecutivo + COLUMN_SEPARATOR + categoriaEjecutivo + COLUMN_SEPARATOR + sucursalAsignada + COLUMN_SEPARATOR + porcentajeAsignacion + COLUMN_SEPARATOR + cantidadAAsignar + COLUMN_SEPARATOR + totalDeClientes + COLUMN_SEPARATOR + clientesAsignados + COLUMN_SEPARATOR + idEjecutivo + '\r\n';
	}
						
	public static void save() {
		if (reporte != null) {
			Document document = getDocument();
			document = document == null ? new Document(FolderId = UserInfo.getUserId(), Name = name, ContentType = 'text/csv') : document;
			document.Body = Blob.valueOf(reporte.csv);
			upsert document;
		}
			}
			
	public static Document getDocument() {
		if (reporte == null)
		return null;
		Document[] documents = [SELECT Id FROM Document WHERE FolderId = :userInfo.getUserId() AND Name = :name];
		return documents.isEmpty() ? null : documents[0];
			} 

}