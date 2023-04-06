public with sharing class AsignacionMasivaEjecutivosControlador {

    private static final Asignacion_Cartera__mdt configuracion = [Select Tamano_Paginacion__c, URL_Asignacion_Masiva__c, URL_Informe_Cartera_Desvinculada__c, URL_Informe_Cartera_Vinculada__c From Asignacion_Cartera__mdt LIMIT 1];
    private static final Integer ERROR_LIMIT = 5;
    private static final Id INDIVIDUALES = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
    private static final Map<String, String> MAP_QUERIES = new Map<String, String>{
        'Cuenta_Desvinculada' =>  ' WHERE Cantidad_Polizas_Activas__c > 0 AND Cliente_Fidelizado__c = false AND (Agente_Actual__r.Estado__c = \'Desvinculado\' OR Agente_Actual__r.Estado__c = \'Cambio de Cargo\') AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) AND Id IN :cuentaIds order by FirstName asc LIMIT :upperBound',
        'Cuenta_Vinculada' =>  '  WHERE (Agente_Actual__r.Estado__c = \'Vigente\' OR (Owner.IsActive = true AND Owner.Ejecutivo_de_Cliente__c = true)) AND Id IN (Select Cuenta__c From Poliza__c Where RecordTypeId = \'' +INDIVIDUALES+'\' And Estatus__c = \'ACTIVA\') order by FirstName asc LIMIT :upperBound'
    };

    public Integer tamanoLista {get;set;}
    public Integer tamanoTotal {get; set;}
    public String filtro {get;set;}
    public ApexPages.StandardSetController controladorLista {get;set;}
    public Map<Id, List<SelectOption>> mapCuentasUsuarios {get;set;}
    public Integer paginaActual {get;set;}
    public Map<Id, AsignacionDeEjecutivo> mapUsuariosPorCuenta {get;set;}
    public String linkAsignacionMasiva {get;set;}

    public List<Account> getCuentas() {
        if (controladorLista == null)
        return new List<Account>();
        return (List<Account>) controladorLista.getRecords();
    }

    public AsignacionMasivaEjecutivosControlador() {
        this.tamanoTotal = 0;
        if(configuracion==null)
        addError('Ocurrió un error al consultar los datos de configuración. Por Favor revise estos valores.');
        else{
            tamanoLista = Integer.valueOf(configuracion.Tamano_Paginacion__c);
            linkAsignacionMasiva = configuracion.URL_Asignacion_Masiva__c;
            paginaActual = 1;
            mapUsuariosPorCuenta = new Map<Id, AsignacionDeEjecutivo>();
                    //mapCuentasUsuarios = new Map<Id, List<SelectOption>>();
                    filtro = 'Cuenta_Desvinculada';
                    cambioFiltro();
        }
    }

    public List<Integer> getPaginas(){
        List<Integer> paginas = new List<Integer>();
        Decimal total = (Decimal)tamanoTotal / tamanoLista;
        Integer cantidadPaginas = Integer.valueOf(total.round(System.RoundingMode.CEILING));
        for(Integer i=1 ; i  <= cantidadPaginas ; i++)
        paginas.add(i);
        return paginas;
    }

    public void asignarUsuariosPorCuenta() {
        this.mapUsuariosPorCuenta = AsignarCarteraUtils.obtenerEjecutivos((Account[])controladorLista.getRecords());
        if (filtro != 'Cuenta_Desvinculada') {
            this.mapCuentasUsuarios = null;
            return;
        }
        this.mapCuentasUsuarios = new Map<Id, List<SelectOption>>();
        for(Id idCuenta: mapUsuariosPorCuenta.keySet()) {
            AsignacionDeEjecutivo asignacion = mapUsuariosPorCuenta.get(idCuenta);
            mapCuentasUsuarios.put(idCuenta, getOptions(asignacion.getPropietarios(), User.Name, User.Id, null));
        }
    }

    public void irAPagina(){
        if(!isChange()) {
            controladorLista.setPageNumber(paginaActual);
            asignarUsuariosPorCuenta();
        }
    }

    public System.PageReference asignarMasivamente(){
        System.PageReference pagina = new System.PageReference(linkAsignacionMasiva);
        return pagina;
    }

    public System.PageReference proponerAsignacion(){
        AsignarCarteraUtils.proponerAsignacion(mapUsuariosPorCuenta);
        for (Account cuenta : getCuentas()) {
            AsignacionDeEjecutivo asignacion = mapUsuariosPorCuenta.get(cuenta.Id);
            if (asignacion == null) {
                addError('La asignación es null para la cuenta ' + cuenta.Id);
                continue;
            }
            if (asignacion.ejecutivoAsignado == null) {
                addError('No pudo encontrarse un ejecutivo asignado para la cuenta: ' + asignacion.cuenta.Name);
                continue;
            }
            if (asignacion.ejecutivoAsignado.usuario == null) {
                addError('No pudo encontrarse un usuario de ejecutivo asignado para la cuenta: ' + asignacion.cuenta.Name);
                continue;
            }
            if (asignacion != null && asignacion.ejecutivoAsignado != null && asignacion.ejecutivoAsignado.usuario != null)
            cuenta.OwnerId = asignacion.ejecutivoAsignado.usuario.Id;
        }
        return null;
    }

    private System.PageReference getExportURL(String url) {
        if (String.isBlank(url)) {
            addError('La URL de exportación no se ha especificado, por favor asegurese de establecerla en el objeto de configuración.');
            return null;
        }
        String s = url.contains('?') ? '&' : '?';
        url = url + s + 'export=1&enc=UTF-8&xf=xls';
        return new System.PageReference(url);
    }

    public System.PageReference exportar() {
        if (this.filtro == 'Cuenta_Desvinculada')
        return getExportUrl(configuracion.URL_Informe_Cartera_Desvinculada__c);
        if (this.filtro == 'Cuenta_Vinculada')
        return getExportUrl(configuracion.URL_Informe_Cartera_Vinculada__c);
        addError('No se ha especificado URL de exportación para el filtro: ' + filtro);
        return null;
    }

    public System.PageReference asignar(){
        ApexPages.getMessages().clear();
        List<Account> cuentasActualizar = controladorLista.getRecords();
        Integer successes = 0;
        Integer failures = 0;

        Map<Id, String> errorMap = new Map<Id, String>();

        ACSELAsignacion[] asignacionesEfectivas = new ACSELAsignacion[]{};
        Database.SaveResult[] sresults = Database.update(cuentasActualizar, false);
        for (Integer i=0; i < cuentasActualizar.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            Account cuenta = cuentasActualizar[i];
            if (sresult.isSuccess()) {
                AsignacionDeEjecutivo asignacion = mapUsuariosPorCuenta.get(sresult.getId());
                if(asignacion.cuenta.OwnerId != cuenta.OwnerId){
                    successes++;
                }
                continue;
            }
            failures++;
            Account account = cuentasActualizar[i];
            for (Database.Error error : sresult.getErrors()) {
                if (ApexPages.getMessages().size() < ERROR_LIMIT)
                errorMap.put(account.Id, error.getMessage());
            }
        }
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('[Vida Security] Reporte de Asignación AMAC');
        
        message.setToAddresses(new String[] {'juan.espinoza@security.cl'});
        
        String body = 'Se han asignado ' + successes + ' clientes exitosamente.\n';
        if (failures > 0) {
            body += 'Se han producido ' + failures + ' errores al asignar los ejecutivos.';
        }        
        
        message.setPlainTextBody(body);
        message.setSaveAsActivity(false);
        
        if (!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.Email[] {message});  
            
        Account[] accounts = [SELECT Id, Name FROM Account WHERE Id IN :errorMap.keySet()];

        for (Account account : accounts) {
            String error = errorMap.get(account.Id);
            addError('Ocurrió un error al asignar el ejecutivo a la cuenta de ' +  account.Name + ', el error es ' + error);
        }

        if (ApexPages.hasMessages()) {
            String warning = 'Han ocurrido ' + failures + ' errores al intentar asignar los ejecutivos';
            if (failures > ERROR_LIMIT)
            warning += '. Pero solo mostramos el detalle de ' + ApexPages.getMessages().size();
            warning += '. Por favor solucione estos errores de validación y vuelva a realizar la asignación.';
            if (successes > 0)
            warning += ' Por ahora solo hemos podido asignar el ejecutivo a ' + successes + ' cuentas exitosamente.';
            else
            warning += ' Ningún ejecutivo ha sido asignado.';
            return addWarn(warning);
        }
        
        cambioFiltro();
        return addInfo('Se ha realizado la asignación exitosa de ejecutivos post venta a ' + successes + ' cuentas.');
        //return null;
    }

    public void cambioFiltro(){
        String query = null;
        try {
            Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            Integer upperBound = Math.min(remainingRows, 2000);

            query = 'Select Id, Cliente_Asegurado_Empresa__c, Sucursal_Asignada__c, OwnerId, Owner.Name, Categoria_Ejecutivo__c, Dias_Con_Ejecutivo__c, Dias_Sin_Ejecutivo__c, Rut_con_dv__c, Agente_Actual__c, Categoria_del_Cliente__c, Ciudad_Particular_B__c,  Sucursal_Ejecutivo_de_Clientes__c, Valor_Poliza_Total__c, Capital_Administrado_UF__c, Prima_Mensualizada_Administrada__c, Agente_Actual__r.Name, Categoria_del_Cliente__r.Name, Ciudad_Particular_B__r.Name From Account ';

            if(MAP_QUERIES.containsKey(filtro))
            query += MAP_QUERIES.get(filtro);

            System.debug('remainingRows antes de query polizas : ' +upperBound);
            List<Id> cuentaIds = new List<Id>();
            Poliza__c[] polizas = [Select Cuenta__c From Poliza__c Where RecordType.Name = 'Individuales' And Estatus__c = 'ACTIVA' AND (Cuenta__r.Categoria_del_Cliente__r.Name IN ('A','B','C') OR ((Cuenta__r.Categoria_del_Cliente__r.Name IN ('D', 'D-') AND Cantidad_de_Meses_Sin_Pago__c <= 3 AND Frecuencia_de_Pago__c = 'M' AND Cuenta__r.Ciudad_Particular_b__R.Name = 'SANTIAGO')OR (Cuenta__r.Categoria_del_Cliente__r.Name IN ('D', 'D-') AND Cantidad_de_Meses_Sin_Pago__c <= 5 AND Frecuencia_de_Pago__c = 'T' AND Cuenta__r.Ciudad_Particular_b__R.Name = 'SANTIAGO') OR (Cuenta__r.Categoria_del_Cliente__r.Name IN ('D', 'D-') AND Cantidad_de_Meses_Sin_Pago__c <= 8 AND Frecuencia_de_Pago__c = 'S' AND Cuenta__r.Ciudad_Particular_b__R.Name = 'SANTIAGO') OR(Cuenta__r.Categoria_del_Cliente__r.Name IN ('D', 'D-') AND Cantidad_de_Meses_Sin_Pago__c <= 14 AND Frecuencia_de_Pago__c = 'A' AND Cuenta__r.Ciudad_Particular_b__R.Name = 'SANTIAGO')) OR (Cuenta__r.Categoria_del_Cliente__r.Name IN ('D', 'D-') AND Cuenta__r.Ciudad_Particular_b__R.Name <> 'SANTIAGO')) AND (Cuenta__r.Owner.IsActive = false OR Cuenta__r.Owner.Ejecutivo_de_Cliente__c = false) AND (Cuenta__r.Agente_Actual__r.Estado__c = 'Desvinculado' OR Cuenta__r.Agente_Actual__r.Estado__c = 'Cambio de Cargo')AND Cuenta__r.Cliente_Fidelizado__c = false AND Cuenta__r.Cantidad_Polizas_Activas__c > 0 LIMIT :upperBound];
            for (Poliza__c poliza : polizas) {
                if (!cuentaIds.contains(poliza.Cuenta__c))
                cuentaIds.add(poliza.Cuenta__c);
            }
            remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
            upperBound = Math.min(remainingRows, 2000);
            System.debug('remainingRows antes de query StandardSetController : ' +remainingRows);
            System.debug('*** QUERY *** :' + query);
            if (!query.contains('LIMIT'))
            query += ' LIMIT :remainingRows';
            controladorLista = new ApexPages.StandardSetController(Database.Query(query));
            controladorLista.setPageSize(tamanoLista);
            asignarUsuariosPorCuenta();


            tamanoTotal = controladorLista.getResultSize();
            } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ocurrió un error al consultar los datos : '+e.getMessage() + '\n' + e.getStackTraceString()));
            }
        }

        private Boolean isChange(){
            Boolean respuesta = false;
            List<Account> cuentas = (List<Account>)controladorLista.getRecords();
            for(Account c: cuentas){
                AsignacionDeEjecutivo asignacion = mapUsuariosPorCuenta.get(c.Id);
                if(asignacion!=null){
                    if(asignacion.cuenta.OwnerId != c.OwnerId){
                        addWarn('Ha realizado el cambio de propietario en la cuenta ' + asignacion.cuenta.Name + ' Por favor antes de cambiar de pagina le sugerimos guardar los cambios.');
                        respuesta = true;
                    }
                    } else {
                        addError('Ocurrió un error al consultar la cuenta. Asignacion NULL');
                    }
                }
                return respuesta;
            }

            public void first() {
                if(!isChange()) {
                    controladorLista.first();
                    asignarUsuariosPorCuenta();
                }
            }

            public void previous() {
                if(!isChange()) {
                    controladorLista.previous();
                    asignarUsuariosPorCuenta();
                }
            }

            public void last() {
                if(!isChange()) {
                    controladorLista.last();
                    asignarUsuariosPorCuenta();
                }
            }

            public void next() {
                if(!isChange()) {
                    controladorLista.next();
                    asignarUsuariosPorCuenta();
                }
            }

            public Boolean hasNext {
                get
                {
                    return controladorLista != null && controladorLista.getHasNext();
                }
                set;
            }
            public Boolean hasPrevious {
                get
                {
                    return controladorLista != null && controladorLista.getHasPrevious();
                }
                set;
            }

            public List<SelectOption> getItems() {
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('Cuenta_Desvinculada','Cartera Agente Desvinculado'));
        //options.add(new SelectOption('Cuenta_Vinculada','Cartera Asignada'));
        return options;
    }
    public SelectOption[] getOptions(Sobject[] sobjects, Schema.SObjectField labelField, Schema.SObjectField valueField, String allText) {
        return getOptions(sobjects, labelField.getDescribe().getName(), valueField.getDescribe().getName(), allText);
    }

    public SelectOption[] getOptions(Sobject[] sobjects, String labelField, String valueField, String allText) {
        List<SelectOption> options = new List<SelectOption>();
        if (allText != null)
        options.add(new SelectOption('', allText));
        if (sobjects == null)
        return options;
        List<String> values = new List<String>();
        for (Sobject sobj : sobjects) {
            String label = String.valueOf(sobj.get(labelField));
            String value = String.valueOf(sobj.get(valueField));
            if (value != null && !values.contains(value)) {
                options.add(new SelectOption(value, label));
                values.add(value);
            }
        }
        return options;
    }

    private System.PageReference addMessage(ApexPages.Severity severity, String message) {
        ApexPages.addMessage(new ApexPages.Message(severity, message));
        return null;
    }

    @TestVisible
    private System.PageReference addError(String message) {
        return addMessage(ApexPages.Severity.ERROR, message);
    }

    @TestVisible
    private System.PageReference addInfo(String message) {
        return addMessage(ApexPages.Severity.INFO, message);
    }

    @TestVisible
    private System.PageReference addWarn(String message) {
        return addMessage(ApexPages.Severity.WARNING, message);
    }

    public System.PageReference establecerSucursal() {
        Id ownerId = System.currentPageReference().getParameters().get('ownerId');
        System.assertNotEquals(null, ownerId, 'el ownerId es null');
        Id accountId = System.currentPageReference().getParameters().get('accountId');
        System.assertNotEquals(null, accountId, 'El accountId es null');
        User owner = AsignarCarteraUtils.allUserMap.get(ownerId);
        if (owner == null)
        return addError('El id del ejecutivo no existe.');
        if (String.isBlank(owner.Codigo_Sucursal__c))
        return addError('No se ha especificado código de sucursal para el ejecutivo ' + owner.Name);
        Sucursal__c sucursal = SucursalUtils.codigoSucursalMap.get(owner.Codigo_Sucursal__c);
        if (sucursal == null)
        return addError('La sucursal con código ' + owner.Codigo_Sucursal__c + ' no existe. Cree una sucursal con este código o cambie el código de sucursal establecido en el usuario ' + owner.Name);
        AsignacionDeEjecutivo asignacion = mapUsuariosPorCuenta.get(accountId);
        System.assertNotEquals(null, asignacion, 'La asignación no se ha establecido');
        asignacion.sucursalAsignada = sucursal;
        return null;
    }

    public Integer getPageNumber() {
        return controladorLista == null ? 0 : controladorLista.getPageNumber();
    }

}