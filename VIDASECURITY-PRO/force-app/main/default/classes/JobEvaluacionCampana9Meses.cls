global class JobEvaluacionCampana9Meses implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        
        system.debug('Inicio');
        
        // Obtener todas las pólizas con fecha de inicio de vigencia >= 9 meses
        List<Poliza__c> polizasSometimiento9Meses = new List<Poliza__c>([select id, Nombre_de_Producto__c, Cuenta__c from Poliza__c where Fecha_Sometimiento__c = :Date.today().addMonths(-9) and Estatus__c = 'ACTIVA' and RecordType.Name = 'Individuales']);
        
        system.debug('polizasSometimiento9Meses: ' + polizasSometimiento9Meses.size());
        
        //filtros
        List<integer> indicePolizaNoAplica = new List<integer>();
        
        for(Integer i = polizasSometimiento9Meses.size() - 1; i >= 0 ; --i) {
            
            Poliza__c poliza = polizasSometimiento9Meses.get(i);
            
            // Se excluyen las de sanatorio y de accidentes personales
            if (string.isNotBlank(poliza.Nombre_de_Producto__c)) {
                if (poliza.Nombre_de_Producto__c.containsIgnoreCase('Sanatorio') || poliza.Nombre_de_Producto__c.containsIgnoreCase('AP ') || poliza.Nombre_de_Producto__c.containsIgnoreCase('Accidentes Personales')) { 
                    indicePolizaNoAplica.add(i);
                }
            }
        }
        
        for(Integer i : indicePolizaNoAplica) {
            polizasSometimiento9Meses.remove(i);
        }
        
        system.debug('polizasSometimiento9Meses 2: ' + polizasSometimiento9Meses.size());
        
        //todas las cuentas que cumplen con el criterio anterior
        List<Id> tempCuentasIdCampana9Meses = new List<Id>();
        
        for (Poliza__c poliza : polizasSometimiento9Meses) {
            tempCuentasIdCampana9Meses.add(poliza.Cuenta__c);
        }
        
        system.debug('tempCuentasIdCampana9Meses: ' + tempCuentasIdCampana9Meses.size());
        
        //eliminación de duplicados (cuentas con más de una póliza), esto es para ocupar estas cuentas en los filtros que vienen después.
        Set<Id> cuentasIdCampana9Meses = new Set<Id>();
        cuentasIdCampana9Meses.addAll(tempCuentasIdCampana9Meses);
        
        //Obtener:
        List<Campana_Vida_Security__c> campanasBienvenida = new List<Campana_Vida_Security__c>([select Id from Campana_Vida_Security__c where Name like 'BIENVENIDA%']);
        List<Participantes_de_campa_a__c> participantesCampanasBienvenida = new List<Participantes_de_campa_a__c>([select Id, Cuenta__c from Participantes_de_campa_a__c where Campa_a_Vida_Security__c in :campanasBienvenida and Cuenta__c in :cuentasIdCampana9Meses]);
        
        Set<Id> cuentasIdParticipantesCampanasBienvenida = new Set<Id>();
        for (Participantes_de_campa_a__c pc : participantesCampanasBienvenida)
            cuentasIdParticipantesCampanasBienvenida.add(pc.Cuenta__c);
        
        List<Campana_Vida_Security__c> campanas9Meses = new List<Campana_Vida_Security__c>([select Id from Campana_Vida_Security__c where Name like '9_MESES%']);
        
        //1.a) (INCLUIR) Todas las cuentas donde no existe campaña bienvenida abierta...
        Map<Id, Account> cuentasCumplenCondicion1a = 
            new Map<Id,Account> (
                [select Id 
                 from Account 
                 where Id in :cuentasIdCampana9Meses
                 and Id not in :cuentasIdParticipantesCampanasBienvenida]);
        
        //1.b) (INCLUIR) ...o existe campaña bienvenida cerrada con contacto = no 
        Map<Id, Participantes_de_campa_a__c> cuentasCumplenCondicion1b = 
            new Map<Id,Participantes_de_campa_a__c> (
                [select Cuenta__c, Id 
                 from Participantes_de_campa_a__c 
                 where Cuenta__c in :cuentasIdCampana9Meses
                 and Id in :participantesCampanasBienvenida and Estado_Cierre__c = 'Finalizado' and Contactado__c = 'No']);
        
        //2) (INCLUIR) Todas las cuentas donde existe campaña bienvenida abierta con contacto no indicado 
        Map<Id, Participantes_de_campa_a__c> cuentasCumplenCondicion2 = 
            new Map<Id,Participantes_de_campa_a__c> (
                [select Cuenta__c, Id 
                 from Participantes_de_campa_a__c 
                 where Cuenta__c in :cuentasIdCampana9Meses
                 and (Campa_a_Vida_Security__c in :campanasBienvenida and Estado_Cierre__c in ('Abierto', 'En proceso') and Contactado__c != 'Si')]);
        
        //3) (EXCLUIR) Todas las cuentas donde existe campaña 9 meses creada con antiguedad <= 1 año y con contacto = si 
        Map<Id, Participantes_de_campa_a__c> cuentasNoCumplenCondicion3 = 
            new Map<Id,Participantes_de_campa_a__c> (
                [select Cuenta__c, Id 
                 from Participantes_de_campa_a__c 
                 where Cuenta__c in :cuentasIdCampana9Meses
                 and (Campa_a_Vida_Security__c in :campanas9Meses and CreatedDate <= :Date.today().addYears(-1))
                 and Contactado__c = 'Si']);
        
        //4) (EXCLUIR) Clientes con campaña 9 meses actualmente abierta 
        Map<Id, Participantes_de_campa_a__c> cuentasNoCumplenCondicion4 = 
            new Map<Id,Participantes_de_campa_a__c> (
                [select Cuenta__c, Id 
                 from Participantes_de_campa_a__c 
                 where Cuenta__c in :cuentasIdCampana9Meses
                 and (Campa_a_Vida_Security__c in :campanas9Meses and Estado_Cierre__c = 'Abierto')]);
        
        // Eliminar cuentas de condición 3 y 4
        cuentasNoCumplenCondicion3.putAll(cuentasNoCumplenCondicion4);
        for (Participantes_de_campa_a__c pc : cuentasNoCumplenCondicion3.values()){
            cuentasIdCampana9Meses.remove(pc.Cuenta__c);
        }
        
        // Incluir cuentas que cumplen condición 1a, 1b y 2
        cuentasCumplenCondicion1b.putAll(cuentasCumplenCondicion2);
        List<Id> cuentasCumplenCondicion1y2 = new List<Id>();
        
        for (Account c : cuentasCumplenCondicion1a.values()){
            cuentasCumplenCondicion1y2.add(c.Id);
        }
        
        for (Participantes_de_campa_a__c pc : cuentasCumplenCondicion1b.values()){
            cuentasCumplenCondicion1y2.add(pc.Cuenta__c);
        }
        
        cuentasIdCampana9Meses.retainAll(cuentasCumplenCondicion1y2);
        
        system.debug('cuentasIdCampana9Meses filtradas: ' + cuentasIdCampana9Meses.size());
        
        //Buscar campaña existente
        string nombreCampana = '9_MESES_' + DateTime.now().format('MMYYYY');
        Campana_Vida_Security__c[] campana9MesesActual = [select Id from Campana_vida_Security__c where Name = :nombreCampana];
        
        //Si no existe crear
        if(campana9MesesActual.size() == 0){
            Campana_Vida_Security__c campana9MesesNueva = new Campana_Vida_Security__c();
            campana9MesesNueva.Name = nombreCampana;
            campana9MesesNueva.Tipo_de_Campa_a__c = '9 Meses Vigencia';
            campana9MesesNueva.Fecha_Inicio_de_Campa_a__c = Date.today().toStartOfMonth();
            campana9MesesNueva.Fecha_de_Termino_de_Campa_a__c = Date.today().addMonths(1).toStartOfMonth().addDays(-1);
            insert campana9MesesNueva;
            campana9MesesActual.add(campana9MesesNueva);
        }
        
        //después obtenerla
        Campana_Vida_Security__c campana9Meses = campana9MesesActual[0];
        
        //Generar participantes de campaña 9 meses para esas cuentas
        List<Participantes_de_Campa_a__c> listaPCNuevos = new List<Participantes_de_Campa_a__c>();
        
        system.debug('cuentasIdCampana9Meses final: ' + cuentasIdCampana9Meses.size());
        
        List<Account> listaCuentasFinal = new List<Account>([select FirstName, LastName, Name, IsPersonAccount, Id, (select Id from Contacts) from Account where Id in :cuentasIdCampana9Meses]);
        
        system.debug('listaCuentasFinal: ' + listaCuentasFinal.size());
        
        for (Account cuenta : listaCuentasFinal) {
            Participantes_de_Campa_a__c pc = new Participantes_de_Campa_a__c();
            pc.Cuenta__c = cuenta.Id;
            pc.Contacto__c = cuenta.Contacts.size() > 0 ? cuenta.Contacts[0].Id : null;
            pc.Campa_a_Vida_Security__c = campana9Meses.Id;
            pc.RecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('9 Meses Vigencia').getRecordTypeId();
            pc.Contactado__c = 'No';
            pc.Estado_Cierre__c = 'Abierto';
            
            if (cuenta.IsPersonAccount)
                pc.Name = '9 MESES: ' + DateTime.now().format('MMYYYY') + ' ' + cuenta.FirstName.ToUpperCase() + ' ' + cuenta.LastName.ToUpperCase();
            else
                pc.Name = '9 MESES: ' + DateTime.now().format('MMYYYY') + ' ' + cuenta.Name.ToUpperCase();
            
            listaPCNuevos.add(pc);
        }
        
        //insert final
        insert listaPCNuevos;
        
        system.debug('Fin');
    }
    
}