/**
* VASS
* @author           Javier Cubillos
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    01/12/2021     Javier Cubillos JATC 	       Class Created
***********************************************************************************************************************/
public class AccountTriggerHelper {
    
	public static Map<String, Account> getMapCuentas( Account a, Account accOld, Map<String, Account> mapCuentas ){
		Account cuenta = AccCrearCuentaConContactoExistente.getMapAccount(a, accOld, mapCuentas);
		if( cuenta != null ){
			mapCuentas.put(cuenta.rut__c, cuenta);
		}
		return mapCuentas;
	}
    
	public static Set<Id> getIdsEmpresas( Account acc, Set<Id> idsEmpresas ){
		if( acc != null && acc.Cuenta_Corporativa__c  != null ){
			idsEmpresas.add( acc.Cuenta_Corporativa__c );
		}
		return idsEmpresas;
	}
	
	public static Set<String> getRutsEmpresas( Account acc, Set<String> rutsEmpresas, Id recordTypeCuentaPersonal ){
		if( acc != null && String.isNotBlank(acc.RUT_Empresa__c) && !rutsEmpresas.contains(acc.RUT_Empresa__c) && acc.RecordTypeId == recordTypeCuentaPersonal ){
			rutsEmpresas.add(acc.RUT_Empresa__c.toUpperCase());
		}
		return rutsEmpresas;
	}
	
	public static Set<Id> getIdsEjecutivos( Account a, Account accOld, Set<Id> idsEjecutivos, Id recordTypeCuentaEmpresa ){
		Account ac = AccAsignaEjecutivoComercialACuenta.getIdEjecutivo(a, accOld, idsEjecutivos, recordTypeCuentaEmpresa);
		if(ac != null && ac.Ejecutivo_Comercial__c != null ){
			idsEjecutivos.add(ac.Ejecutivo_Comercial__c);
		}
		return idsEjecutivos;
	}
	
	public static Set<String> getRutsEjecutivos( Account a, Account accOld, Set<String> rutsEjecutivos, Id recordTypeCuentaEmpresa ){
		Account cu = AccAsignaEjecutivoComercialACuenta.getRutsPorVencer(a, accOld, rutsEjecutivos, recordTypeCuentaEmpresa);
		if( cu != null && cu.RUT_Ejecutivo_Comercial__c != null ){
			rutsEjecutivos.add( cu.RUT_Ejecutivo_Comercial__c.toUpperCase() );
		}
		return rutsEjecutivos;
	}
	
	public static Set<Id> getIdsAdmins( Account a, Account accOld, Set<Id> idsAdmins, Id recordTypeCuentaEmpresa ){
		Account cue = AccAsignaAdminProdACuenta.getIdAdmin(a, accOld, idsAdmins, recordTypeCuentaEmpresa);
		if( cue != null && cue.Administrador_de_Produccion__c != null ){
			idsAdmins.add(cue.Administrador_de_Produccion__c);
		}
		return idsAdmins;
	}
	
	public static Set<String> getRutsAdmins( Account a, Account accOld, Set<String> rutsAdmins, Id recordTypeCuentaEmpresa ){
		Account cuen = AccAsignaAdminProdACuenta.getRutsAdmin(a, accOld, rutsAdmins, recordTypeCuentaEmpresa);
		if( cuen != null && cuen.RUT_Administrador_de_Produccion__c != null ){
			rutsAdmins.add(cuen.RUT_Administrador_de_Produccion__c.toUpperCase());
		}
		return rutsAdmins;
	}
	
	public static List<Id> getCiudadIds( Account a, Account accOld, List<Id> ciudadIds ){
		Id ciudadId = AccAsignarRelacionDeCategoria.getCiudadID(a, accOld, ciudadIds);
		if( ciudadId != null ){
			ciudadIds.add( ciudadId );
		}
		return ciudadIds;
	}
	
	public static List<Account> getAccountsCategoria( Account a, Account accOld, List<Account> accountsCategoria, List<Id> ciudadIds ){
		Account accountCategoria = AccAsignarRelacionDeCategoria.getAccountEje(a, accOld, ciudadIds);
		if( accountCategoria != null ){
			accountsCategoria.add( accountCategoria );
		}
		return accountsCategoria;
	}
	
	public static List<Id> getCategoriaIds( Account a, Account accOld, List<Id> categoriaIds ){
		Id categoriaId = AccAsignarRelacionDeCategoria.getCategoriaID(a, accOld, categoriaIds);
		if( categoriaId != null ){
			categoriaIds.add( categoriaId );
		}
		return categoriaIds;
	}
	
	public static Set<Id> getOwnerIdsAgent( Account a, Account accOld, Set<Id> ownerIdsAgent ){
		Id ownerIdAgent = AccAsignaEjecutivoDeCliente.getOwnerID(a, accOld, ownerIdsAgent);
		if( ownerIdAgent != null ){
			ownerIdsAgent.add( ownerIdAgent );
		}
		return ownerIdsAgent;
	}

  public static Set<Id> getAccountsId( Account a, Account accOld, Set<Id> accountsId ){
		Id accountId = CreaParticipantesAMAC.getAccountIdAMAC(a, accOld, accountsId );
		if( accountId != null ){
			accountsId.add( accountId );
		}
		return accountsId;
	}

  public static Set<Id> getAccountsIdCartera( Account a, Account accOld, Set<Id> accountsId ){
		Id accountId = AdministrarCarteraHuerfana.getAccountIdCartera(a, accOld, accountsId );
		if( accountId != null ){
			accountsId.add( accountId );
		}
		return accountsId;
	}

    public static Set<String> getCodigos( Account a, Set<Id> ownerIdsAgent,Set<String> codigos  ){
        String codAgente = AccAsignaAgenteActualACuenta.GetCodeAccount(a, codigos);
        if( codAgente != null && codAgente != '' ){
            codigos.add(codAgente);
        }
        return codigos;
    }

    public static Set<Id> getOwnerIds( Account a, Set<Id> ownerIdsAgent, Set<Id> ownerIds ){
        Id ownerId = AccAsignaFechaSinEjecutivo.getAgentID(a, null, ownerIds,null);
        if( ownerId != null ){
            ownerIds.add( ownerId );
        }
        return ownerIds;
    }
    
    public static Set<Id> getAgenteIds( Account a, Set<Id> agenteIds ){
        Id agenteId = AccAsignaFechaSinEjecutivo.getAgentID(a, null, null,agenteIds);
        if( agenteId != null ){
            agenteIds.add( agenteId );
        }
        return agenteIds;
    }

	public static Set<String> getRutsContacto( Account a, Account accOld, Set<String> rutsContacto ){
        String rut = AccCrearCuentaConContactoExistente.getRutContacto( a, accOld, rutsContacto );
		if( rut != '' && rut != null ){
			rutsContacto.add( rut );	
		}
		return rutsContacto;
    }
    
}