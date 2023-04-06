public class Ejecutivo implements Comparable {

	public User usuario {get; set;}
	public Decimal porcentajeAsignacion {get; set;}
	public Decimal totalDeClientes {get; set;}
	public Account[] cuentasAsignadas {get; set;}
	public Integer cantidadAAsignar {get {
		if (porcentajeAsignacion == null || porcentajeAsignacion == 0 || totalDeClientes == 0)
			return 0;
		return Integer.valueOf(Math.round(porcentajeAsignacion*totalDeClientes));
	} set;}
		
	public Ejecutivo(User usuario) {
		this.usuario = usuario;
		this.cuentasAsignadas = new List<Account>();
	}
	
	public Integer compareTo(Object compareTo) {
		Ejecutivo other = (Ejecutivo)compareTo;
		if (usuario == null || other.usuario == null || usuario.Factor_de_Ejecutivo__c == other.usuario.Factor_de_Ejecutivo__c)
			return 0;
		if (usuario.Factor_de_Ejecutivo__c > other.usuario.Factor_de_Ejecutivo__c)
			return 1;
		return -1;
	}
	
	public Boolean asignar(Account account) {
		return asignar(account, false);
	}

	public Boolean asignar(Account account, Boolean force) {
		System.assertNotEquals(null, cantidadAAsignar, 'La cantidad a asignar es null');
		System.assertNotEquals(null, cuentasAsignadas, 'cuentasAsignadas es null');
		System.assertNotEquals(null, force, 'Force no puede ser null');
		if (cantidadAAsignar == 0 && !force)
		return false;
		//return !Messages.addWarn('No es posible asignar la cuenta ' + account.Name + ' al ejecutivo ' + usuario.Name + ' pues no tiene disponibilidad. Factor de Ejecutivo: ' + usuario.Factor_de_Ejecutivo__c + ', Total de Clientes a Asignar: ' + totalDeClientes + ', Porcentaje Asignación: ' + porcentajeAsignacion*100 + '%');
		if (cuentasAsignadas.size() >= cantidadAAsignar && !force)
		return false;
			//return !Messages.addWarn('No es posible asignar la cuenta ' + account.Name + ' al ejecutivo ' + usuario.Name + ' pues tiene una disponibilidad de ' + cantidadAAsignar + ' y el proceso asignó ' + cuentasAsignadas.size());
				this.cuentasAsignadas.add(account);
		return true;
	}
	
	public String printPorcentajeAsignacion() {
		if (porcentajeAsignacion == null) return 'null';
		return (porcentajeAsignacion*100).setScale(2) + '%';
	}

	
	    }