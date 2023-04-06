public without sharing class AsignaReferenciasASuscripcionHandler implements TriggerHandler.HandlerInterface {

    public void handle() {
        Map<String, Account> mapAsegurados = new Map<String, Account>();
        Map<String, Poliza__c> mapPolizas = new Map<String, Poliza__c>();

        Set<String> rutsAsegurados = new Set<String>();
        Set<String> nrosPoliza = new Set<String>();

        Set<Id> idsEmpresas = new Set<Id>();
        Set<Id> idsPolizas = new Set<Id>();

        if (Trigger.new != null) {

            for (Poliza_Colectivo__c suscripcion : (Poliza_Colectivo__c[])Trigger.new) {

                Poliza_Colectivo__c suscripcionOld = (Poliza_Colectivo__c)(Trigger.isUpdate ? Trigger.oldMap.get(suscripcion.Id) : null);

                if(  (Trigger.isInsert && suscripcion.Cuenta__c != null) ||  (suscripcionOld!=null && suscripcionOld.Cuenta__c != suscripcion.Cuenta__c && suscripcion.Cuenta__c!=null) ){
                    if(!idsEmpresas.contains(suscripcion.Cuenta__c))
                        idsEmpresas.add(suscripcion.Cuenta__c);
                }
                else if (String.isNotBlank(suscripcion.Rut_Asegurado__c) && !rutsAsegurados.contains(suscripcion.Rut_Asegurado__c))
                    rutsAsegurados.add(suscripcion.Rut_Asegurado__c.toUpperCase());


                if(  (Trigger.isInsert && suscripcion.Poliza__c != null) ||  (suscripcionOld!=null && suscripcionOld.Poliza__c != suscripcion.Poliza__c && suscripcion.Poliza__c !=null) ){
                    if(!idsPolizas.contains(suscripcion.Poliza__c))
                        idsPolizas.add(suscripcion.Poliza__c);
                }
                else if (String.isNotBlank(suscripcion.N_Poliza__c) && !nrosPoliza.contains(suscripcion.N_Poliza__c))
                    nrosPoliza.add(suscripcion.N_Poliza__c);
            }


            List<Account> asegurados = [Select Id, Rut__c From Account WHere Rut__c IN :rutsAsegurados and RecordType.Name = 'Cuenta personal'];
            List<Poliza__c> polizas = [Select Id, Name From Poliza__c WHere Name IN :nrosPoliza];

            Map<Id, Account> mapCuentasById = new Map<ID, Account>([Select Id, Rut__c From Account Where Id IN :idsEmpresas]);
            Map<Id, Poliza__c> mapPolizasById = new Map<ID, Poliza__c>([Select Id, Name From Poliza__c Where Id IN :idsPolizas]);

            for (Account asegurado : asegurados) {
                if (!mapAsegurados.containsKey(asegurado.Rut__c.toUpperCase())) {
                    mapAsegurados.put(asegurado.Rut__c.toUpperCase(), asegurado);
                }
            }

            for (Poliza__c poliza : polizas) {
                if (!mapPolizas.containsKey(poliza.Name)) {
                    mapPolizas.put(poliza.Name, poliza);
                }
            }

            for (Poliza_Colectivo__c suscripcion : (Poliza_Colectivo__c[])Trigger.new) {
                Poliza_Colectivo__c suscripcionOld = (Poliza_Colectivo__c)(Trigger.isUpdate ? Trigger.oldMap.get(suscripcion.Id) : null);

                if(  (Trigger.isInsert && suscripcion.Cuenta__c != null) ||  (suscripcionOld!=null && suscripcionOld.Cuenta__c != suscripcion.Cuenta__c && suscripcion.Cuenta__c!=null) ){
                    if(mapCuentasById.containsKey(suscripcion.Cuenta__c))
                        suscripcion.Rut_Asegurado__c = mapCuentasById.get(suscripcion.Cuenta__c).Rut__c;
                }
                else if (String.isNotBlank(suscripcion.Rut_Asegurado__c) && mapAsegurados.containsKey(suscripcion.Rut_Asegurado__c.toUpperCase()))
                    suscripcion.Cuenta__c =  mapAsegurados.get(suscripcion.Rut_Asegurado__c.toUpperCase()).Id;

                if(  (Trigger.isInsert && suscripcion.Poliza__c != null) ||  (suscripcionOld!=null && suscripcionOld.Poliza__c != suscripcion.Poliza__c && suscripcion.Poliza__c !=null) ){
                    if(mapPolizasById.containsKey(suscripcion.Poliza__c))
                        suscripcion.N_Poliza__c = mapPolizasById.get(suscripcion.Poliza__c).Name;
                }
                else if (String.isNotBlank(suscripcion.N_Poliza__c) && mapPolizas.containsKey(suscripcion.N_Poliza__c))
                    suscripcion.Poliza__c =  mapPolizas.get(suscripcion.N_Poliza__c).Id;
            }

        }
    }

}