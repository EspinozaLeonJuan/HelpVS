public class AccAsignarRelacionDeCategoria {

    public static Id getCategoriaID(Account accountNew, Account accountOld, List<Id> categoriaIds ){
		if( accountOld == null || 
    accountOld.Ciudad_Particular_B__c != accountNew.Ciudad_Particular_B__c || 
    accountOld.Categoria_del_Cliente__c != accountNew.Categoria_del_Cliente__c || 
    accountNew.Relacion_de_Categoria__c == null || 
    accountNew.Sucursal_Asignada__c == null ){
			if( accountNew.Categoria_del_Cliente__c != null && !categoriaIds.contains( accountNew.Categoria_del_Cliente__c ) ){
				return accountNew.Categoria_del_Cliente__c;
            }
        }
        return null;
    }

    public static Id getCiudadID(Account accountNew, Account accountOld, List<Id> ciudadIds ){
        if( accountOld == null || 
			accountOld.Ciudad_Particular_B__c != accountNew.Ciudad_Particular_B__c || 
			accountOld.Categoria_del_Cliente__c != accountNew.Categoria_del_Cliente__c || 
			accountNew.Relacion_de_Categoria__c == null || 
			accountNew.Sucursal_Asignada__c == null ){
            if( accountNew.Ciudad_Particular_B__c != null && !ciudadIds.contains(accountNew.Ciudad_Particular_B__c) ){
                return accountNew.Ciudad_Particular_B__c;
            }
        }
        return null;
    }

    public static Account getAccountEje(Account accountNew, Account accountOld, List<Id> ciudadIds ){
        if( accountOld == null || accountOld.Ciudad_Particular_B__c != accountNew.Ciudad_particular_B__c || accountOld.Categoria_del_Cliente__c != accountNew.Categoria_del_Cliente__c || accountNew.Relacion_de_Categoria__c == null || accountNew.Sucursal_Asignada__c == null) {
            if( accountNew.Ciudad_particular_B__c != null && !ciudadIds.contains(accountNew.Ciudad_Particular_B__c)){
                return accountNew;
            }
        }
        return null;
    }

    public static Boolean validar_condition( Account accountOld, Account accountNew ){
      if ( accountOld != null ) {
        if ( accountOld.Categoria_del_Cliente__c == accountNew.Categoria_del_Cliente__c &&
              accountOld.Relacion_de_Categoria__c != null &&
              accountNew.Relacion_de_Categoria__c == null &&
              accountOld.Sucursal_Asignada__c == accountNew.Sucursal_Asignada__c &&
              accountOld.Ciudad_Particular_B__c == accountNew.Ciudad_Particular_B__c ) {
              return false;
          } else if (accountOld.Categoria_del_Cliente__c == accountNew.Categoria_del_Cliente__c &&
              accountOld.Relacion_de_Categoria__c == accountNew.Relacion_de_Categoria__c &&
              accountOld.Sucursal_Asignada__c == accountNew.Sucursal_Asignada__c &&
              accountOld.Ciudad_Particular_B__c == accountNew.Ciudad_Particular_B__c) {
              return false;
          }
          return true;
      }
      return true;
    }

    public static void asignarRelacion(Account accountNew, Account accountOld,Map<Id, Categoria_de_Cliente__c> categoriaClienteMap, Map<Id, Ciudad_de_Sucursal__c> ciudadSucursalMap, Map<Id, Ciudad__c> ciudadMap, Map<Id, Map<Id, Relacion_de_Categoria__c>> relacionMap){
		System.debug('##AccAsignarRelacionDeCategoria.asignarRelacion');

    Boolean valid_relation = true;
    valid_relation = validar_condition( accountOld, accountNew );
    if(valid_relation == false) { accountNew.Relacion_de_Categoria__c = accountOld.Relacion_de_Categoria__c; }
		
    Categoria_de_Cliente__c categoriaCliente = ( categoriaClienteMap != null && accountNew != null && accountNew.Categoria_del_Cliente__c != null && categoriaClienteMap.containsKey(accountNew.Categoria_del_Cliente__c) ? categoriaClienteMap.get(accountNew.Categoria_del_Cliente__c) : null );
		if( accountNew.Ciudad_Particular_B__c == null ){
			if( ( accountNew.Omitir_Validaciones_AMAC__c == null || accountNew.Omitir_Validaciones_AMAC__c == false ) && valid_relation == true ){
				accountNew.Ciudad_Particular_B__c.addError('1, La ciudad particular es obligatoria para la cuenta con RUT: ' + accountNew.RUT__c + ', Omitir Validaciones AMAC=' + accountNew.Omitir_Validaciones_AMAC__c + ' accountOld.Relacion_de_Categoria__c = ' + ( accountOld == null ? null : accountOld.Relacion_de_Categoria__c) + ' accountNew.Relacion_de_Categoria__c = ' + accountNew.Relacion_de_Categoria__c +  ' accountOld.Sucursal_Asignada__c = ' + ( accountOld == null ? null : accountOld.Sucursal_Asignada__c) + ' accountNew.Sucursal_Asignada__c = ' + accountNew.Sucursal_Asignada__c +' accountNew.Id' + accountNew.Id +  ' valid_relation = ' + valid_relation);
      }
			System.debug('##1.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			accountNew.Relacion_de_Categoria__c = null;
			accountNew.Sucursal_Asignada__c =null;	
		}
		Ciudad_de_Sucursal__c sucursalAsignada = null;
		if( ciudadSucursalMap.containsKey( accountNew.Ciudad_Particular_B__c ) ){
			sucursalAsignada = ciudadSucursalMap.get( accountNew.Ciudad_Particular_B__c );
		}

    valid_relation = validar_condition( accountOld, accountNew );
    if(valid_relation == false) { accountNew.Relacion_de_Categoria__c = accountOld.Relacion_de_Categoria__c; }

		//( ciudadSucursalMap != null && accountNew != null && accountNew.Ciudad_Particular_B__c != null && ciudadSucursalMap.containsKey( accountNew.Ciudad_Particular_B__c ) ? ciudadSucursalMap.get( accountNew.Ciudad_Particular_B__c ) : null );
		if( sucursalAsignada == null ){
			Ciudad__c ciudad = ciudadMap.get(accountNew.Ciudad_Particular_B__c);
			if( ( accountNew.Omitir_Validaciones_AMAC__c == null || accountNew.Omitir_Validaciones_AMAC__c == false ) && valid_relation == true ){
				accountNew.addError('No se han especificado sucursales para la ciudad ' + (ciudad == null ? accountNew.Ciudad_Particular__c : ciudad.Name) + ', por favor comuníquese con el administrador del sistema para incluir un registro de Ciudad de Sucursal ' + 
        ' relacionMap = ' + relacionMap + ' accountOld.Ciudad_Particular_B__c = ' + ( accountOld == null ? null : accountOld.Ciudad_Particular_B__c) +' accountNew.Ciudad_Particular_B__c = ' + accountNew.Ciudad_Particular_B__c +' accountOld.Categoria_del_Cliente__c = ' + ( accountOld == null ? null : accountOld.Categoria_del_Cliente__c) +' accountNew.Categoria_del_Cliente__c = ' + accountNew.Categoria_del_Cliente__c +' accountOld.Relacion_de_Categoria__c = ' + ( accountOld == null ? null : accountOld.Relacion_de_Categoria__c) +' accountNew.Relacion_de_Categoria__c = ' + accountNew.Relacion_de_Categoria__c +' accountOld.Sucursal_Asignada__c = ' + ( accountOld == null ? null : accountOld.Sucursal_Asignada__c) +' accountNew.Sucursal_Asignada__c = ' + accountNew.Sucursal_Asignada__c +' accountNew.Id' + accountNew.Id +' valid_relation = ' + valid_relation);  
			}
			System.debug('##2.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			accountNew.Relacion_de_Categoria__c = null; 
			accountNew.Sucursal_Asignada__c = null;
		}else{
			accountNew.Sucursal_Asignada__c = sucursalAsignada.Id;
		}
		
    valid_relation = validar_condition( accountOld, accountNew );
    if(valid_relation == false) { accountNew.Relacion_de_Categoria__c = accountOld.Relacion_de_Categoria__c; }

		Map<Id, Relacion_de_Categoria__c> categoriaMap = (  relacionMap != null && sucursalAsignada != null && sucursalAsignada.Sucursal__c != null && relacionMap.containsKey(sucursalAsignada.Sucursal__c) ? relacionMap.get(sucursalAsignada.Sucursal__c) : null );
		if( categoriaMap == null && accountNew.Categoria_del_Cliente__c != null ){
			if( ( accountNew.Omitir_Validaciones_AMAC__c == null || accountNew.Omitir_Validaciones_AMAC__c == false ) && valid_relation == true ){
				accountNew.addError('new, No se ha especificado una relación de categoría para la sucursal ' + sucursalAsignada.Sucursal__r.Name + ' y categoría de cliente ' + (categoriaCliente == null ? (String)null : categoriaCliente.Name) + '. Por favor, comuníquese con el administrador del sistema.' +
        ' relacionMap = ' + relacionMap + ' accountOld.Ciudad_Particular_B__c = ' + ( accountOld == null ? null : accountOld.Ciudad_Particular_B__c) +' accountNew.Ciudad_Particular_B__c = ' + accountNew.Ciudad_Particular_B__c +' accountOld.Categoria_del_Cliente__c = ' + ( accountOld == null ? null : accountOld.Categoria_del_Cliente__c) +' accountNew.Categoria_del_Cliente__c = ' + accountNew.Categoria_del_Cliente__c +' accountOld.Relacion_de_Categoria__c = ' + ( accountOld == null ? null : accountOld.Relacion_de_Categoria__c) +' accountNew.Relacion_de_Categoria__c = ' + accountNew.Relacion_de_Categoria__c +' accountOld.Sucursal_Asignada__c = ' + ( accountOld == null ? null : accountOld.Sucursal_Asignada__c) +' accountNew.Sucursal_Asignada__c = ' + accountNew.Sucursal_Asignada__c +' accountNew.Id' + accountNew.Id +' valid_relation = ' + valid_relation);  
			}
			System.debug('##3.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			accountNew.Relacion_de_Categoria__c = null;
		}

		if( accountNew.Categoria_del_Cliente__c == null ){
			System.debug('##4.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			accountNew.Relacion_de_Categoria__c = null;
		}

    valid_relation = validar_condition( accountOld, accountNew );
    if(valid_relation == false) { accountNew.Relacion_de_Categoria__c = accountOld.Relacion_de_Categoria__c; }

		//System.debug('##categoriaMap: ' + categoriaMap + '\n');
		//System.debug('##accountNew: ' + accountNew +'\n');
		//System.debug('##accountNew.Categoria_del_Cliente__c: ' + accountNew.Categoria_del_Cliente__c +'\n');
		//System.debug('##categoriaMap.containsKey(accountNew.Categoria_del_Cliente__c)' + categoriaMap.containsKey(accountNew.Categoria_del_Cliente__c) +'\n' );
		Relacion_de_Categoria__c relacion = ( categoriaMap != null && accountNew != null && accountNew.Categoria_del_Cliente__c != null && categoriaMap.containsKey(accountNew.Categoria_del_Cliente__c) ? categoriaMap.get(accountNew.Categoria_del_Cliente__c) : null );
		if( relacion == null && accountNew.Categoria_del_Cliente__c != null) {
			if( ( accountNew.Omitir_Validaciones_AMAC__c == null || accountNew.Omitir_Validaciones_AMAC__c == false ) && valid_relation == true){
				accountNew.addError('new, No se ha especificado una relación de categoría para la sucursal ' + sucursalAsignada.Sucursal__r.Name + ' y la categoría de cliente ' + (categoriaCliente == null ? String.valueOf(accountNew.Categoria_del_Cliente__c) : categoriaCliente.Name) + ', RUT CLIENTE: ' + accountNew.RUT__c +
        ' relacionMap = ' + relacionMap + ' accountOld.Ciudad_Particular_B__c = ' + ( accountOld == null ? null : accountOld.Ciudad_Particular_B__c) +' accountNew.Ciudad_Particular_B__c = ' + accountNew.Ciudad_Particular_B__c +' accountOld.Categoria_del_Cliente__c = ' + ( accountOld == null ? null : accountOld.Categoria_del_Cliente__c) +' accountNew.Categoria_del_Cliente__c = ' + accountNew.Categoria_del_Cliente__c +' accountOld.Relacion_de_Categoria__c = ' + ( accountOld == null ? null : accountOld.Relacion_de_Categoria__c) +' accountNew.Relacion_de_Categoria__c = ' + accountNew.Relacion_de_Categoria__c +' accountOld.Sucursal_Asignada__c = ' + ( accountOld == null ? null : accountOld.Sucursal_Asignada__c) +' accountNew.Sucursal_Asignada__c = ' + accountNew.Sucursal_Asignada__c +' accountNew.Id' + accountNew.Id +' valid_relation = ' + valid_relation);  
			}
			System.debug('##5.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			if( accountNew != null && accountNew.Ciudad_Particular_B__c == null ){
				accountNew.Relacion_de_Categoria__c = null;
			}
		}else if( relacion == null || relacion.Id != null ){
			System.debug('##6.AccAsignarRelacionDeCategoria.asignarRelacion Relacion_de_Categoria__c = null');
			accountNew.Relacion_de_Categoria__c = relacion == null ? null : relacion.Id;
		}
		System.debug('##FIN AccAsignarRelacionDeCategoria.asignarRelacion');
    }
}