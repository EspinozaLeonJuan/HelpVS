public class AsignacionDeEjecutivo {
	
	public class AsignacionDeEjecutivoException extends Exception {}
	
	public List<Ejecutivo> ejecutivos {get;set;}
	public User propietarioActual {get; set;}
	public Ejecutivo ejecutivoAsignado {get; set {
		if (value != null && value.usuario != null && value.usuario.Codigo_Sucursal__c != null)
			this.sucursalAsignada = SucursalUtils.codigoSucursalMap.get(value.usuario.Codigo_Sucursal__c);
			this.ejecutivoAsignado = value;
	}}
	public Sucursal__c sucursalAsignada {get; set;}
	public Account cuenta{get;set;}
	
	// CategoriaId => UserId => Ejecutivo ... un ejecutivo puede atender varias categorias y son instancias diferentes de ejecutivo.
	public static final  Map<Id, Ejecutivo> ejecutivoMap = new Map<Id, Ejecutivo>();


	
	public AsignacionDeEjecutivo(Account cuenta) {
		this.cuenta = cuenta;
		this.ejecutivos = new List<Ejecutivo>();
		this.propietarioActual = AsignarCarteraUtils.allUserMap.get(cuenta.OwnerId);
		if (this.propietarioActual != null && this.propietarioActual.Codigo_Sucursal__c != null)
			this.sucursalAsignada = SucursalUtils.codigoSucursalMap.get(this.propietarioActual.Codigo_Sucursal__c);
		if (this.sucursalAsignada == null)
			this.sucursalAsignada = new Sucursal__c(Name = '--');
	}
    
	public void addEjecutivo(User usuario) {
		for (Ejecutivo ejecutivo : ejecutivos) {
			if (ejecutivo.usuario.Id == usuario.Id)
				return; // No se agrega el ejecutivo porque ya está listado
		}
		Ejecutivo ejecutivo = ejecutivoMap.get(usuario.Id);
		if (ejecutivo == null) {
			ejecutivo = new Ejecutivo(usuario);
			ejecutivoMap.put(usuario.Id, ejecutivo);
		}
		this.ejecutivos.add(ejecutivo);
    }
    
	public void addEjecutivos(User[] ejecutivos) {
		if (ejecutivos != null) {
			for (User ejecutivo : ejecutivos)
				addEjecutivo(ejecutivo);
		}
	}
	
	public User[] getPropietarios() {
		List<User> users = new List<User>();
		Boolean agregarPropietarioActual = true;
		for (Ejecutivo ejecutivo : ejecutivos) {
			users.add(ejecutivo.usuario);
			if (propietarioActual != null && agregarPropietarioActual && propietarioActual.Id == ejecutivo.usuario.Id) // El propietarioActual está ya en la lista de ejecutivos
				agregarPropietarioActual = false;
		}
		if (agregarPropietarioActual && propietarioActual != null)
		users.add(propietarioActual);
		return users;
	}
	
	private Decimal getSumaDeFactor() {
		Decimal suma = 0;
		System.assert(!ejecutivos.isEmpty(), 'No se han especificado ejecutivos para la sucursal ' + cuenta.Sucursal_Asignada__r.Sucursal__r.Name + ', categoría ' + cuenta.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c);
		for (Ejecutivo ejecutivo : ejecutivos) {
			suma += (ejecutivo == null || ejecutivo.usuario == null || ejecutivo.usuario.Factor_de_Ejecutivo__c == null ? 0 : ejecutivo.usuario.Factor_de_Ejecutivo__c);
		}
		System.assertNotEquals(0, suma, 'La suma no puede ser cero');
		return suma;
	}
	
	public void calcularPorcentajes() {
		Decimal suma = getSumaDeFactor();
		if (suma == null || suma == 0) {
			Messages.addError('No es posible realizar la asignación puesto que los factores de ejecutivo no han sido calculados. Suma: ' + suma);
			return;
		}
		System.assertNotEquals(0, ejecutivos.size(), 'No se han asignado ejecutivos');
		for (Ejecutivo ejecutivo : ejecutivos) {
			System.assertNotEquals(null, ejecutivo, 'El ejecutivo no puede ser null');
			System.assertNotEquals(null, ejecutivo.usuario, 'El usuario del ejecutivo no puede ser null');
			System.assertNotEquals(null, ejecutivo.usuario.Factor_de_Ejecutivo__c, 'El factor del ejecutivo es null');
			ejecutivo.porcentajeAsignacion = (ejecutivo == null || ejecutivo.usuario == null || ejecutivo.usuario.Factor_de_Ejecutivo__c == null ? 0 :ejecutivo.usuario.Factor_de_Ejecutivo__c/suma); // porcentaje 0 ... 1
					}
	}
			
	public void setTotalDeClientes(Decimal total) {
		for (Ejecutivo ejecutivo : this.ejecutivos) {
			ejecutivo.totalDeClientes = total;
		}
	}
	
	public Boolean asignar(Ejecutivo ejecutivo) {
		return asignar(ejecutivo, false);
		}
	
	public Boolean asignar(Ejecutivo ejecutivo, Boolean force) {
		if (ejecutivo == null)
			return Messages.addError('No es posible asignar un ejecutivo si no se ha establecido.');
		if (this.ejecutivoAsignado != null)
			return Messages.addError('Ya ha sido asignado un ejecutivo para esta cuenta.');
			if (cuenta == null)
			return Messages.addError('La cuenta no se ha establecido');
		if (ejecutivo.asignar(cuenta, force)) {
			System.assertNotEquals(null, ejecutivo, 'El ejecutivo es null!!! No puede ser!!');
			this.ejecutivoAsignado = ejecutivo;
			System.assertNotEquals(null, this.ejecutivoAsignado, 'El ejecutivo asignado no puede ser null');
			//this.cuenta.OwnerId = ejecutivo.usuario.Id;
			//System.debug(cuenta.Categoria_del_Cliente__r.Name + '\t' + cuenta.Ciudad_Particular_B__r.Name + '\t' + cuenta.Peso_de_Cuenta__c + '\t' + cuenta.Name + '\tASIGNADO\t' + ejecutivo.usuario.Name + '\t' + ejecutivo.usuario.Categoria_de_Ejecutivo__c + '\t' + (sucursalAsignada == null ? '--' : sucursalAsignada.Name) + '\t' + ejecutivo.printPorcentajeAsignacion() + '\t' + ejecutivo.cantidadAAsignar + '\t' + ejecutivo.totalDeClientes + '\t' + ejecutivo.cuentasAsignadas.size() + '\t' + ejecutivo.hashCode());
			ReporteDeAsignacion.addRow(cuenta.Categoria_del_Cliente__r.Name, cuenta.Ciudad_Particular_B__r.Name, cuenta.Peso_de_Cuenta__c, cuenta.Name, 'ASIGNADO', ejecutivo.usuario.Name, ejecutivo.usuario.Categoria_de_Ejecutivo__c, (sucursalAsignada == null ? '--' : sucursalAsignada.Name), ejecutivo.printPorcentajeAsignacion(), ejecutivo.cantidadAAsignar, ejecutivo.totalDeClientes, ejecutivo.cuentasAsignadas.size(), ejecutivo.hashCode());
			return true;
		}
		//System.debug(cuenta.Categoria_del_Cliente__r.Name + '\t' + cuenta.Ciudad_Particular_B__r.Name + '\t' + cuenta.Peso_de_Cuenta__c + '\t' + cuenta.Name + '\tNO ASIGNADO\t' + ejecutivo.usuario.Name + '\t' + ejecutivo.usuario.Categoria_de_Ejecutivo__c + '\t' + (sucursalAsignada == null ? '--' : sucursalAsignada.Name) + '\t' + ejecutivo.printPorcentajeAsignacion() + '\t' + ejecutivo.cantidadAAsignar + '\t' + ejecutivo.totalDeClientes + '\t' + ejecutivo.cuentasAsignadas.size() + '\t' + ejecutivo.hashCode());
		ReporteDeAsignacion.addRow(cuenta.Categoria_del_Cliente__r.Name, cuenta.Ciudad_Particular_B__r.Name, cuenta.Peso_de_Cuenta__c, cuenta.Name, 'NO ASIGNADO', ejecutivo.usuario.Name, ejecutivo.usuario.Categoria_de_Ejecutivo__c, (sucursalAsignada == null ? '--' : sucursalAsignada.Name), ejecutivo.printPorcentajeAsignacion(), ejecutivo.cantidadAAsignar, ejecutivo.totalDeClientes, ejecutivo.cuentasAsignadas.size(), ejecutivo.hashCode());
		//return Messages.addError('No pudo ser asignado el ejecutivo a la cuenta ' + cuenta.Name);
		return false;
		}

}