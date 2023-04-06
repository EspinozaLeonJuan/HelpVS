/*******************************************************************************************
 *  NOMBRE                 : PolizaAsignaProductoTrigger
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : Tipo de Producto Masivo
 *
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.1     - 12/12/2018 - I. SALAZAR       - Se agrega pólizas masivas.
 *  1.2     - 23/11/2021 - Javier Tibamoza  - Se unifica la lógica del trigger en uno solo PolizaTrigger.
 * *****************************************************************************************/
trigger PolizaAsignaProductoTrigger on Poliza__c (before insert, before update) {
    Map<String,Switch_new_functions__mdt> mSwitch = UtilityClass.getSwitchNewFunctions();
    if( !UtilityClass.validateSwitchNewFunctions('newTriggerFactory', mSwitch ) ) {
        Set<String> CodigosMasivos = new Set<String>{'1170', '0124', '6803', '6801', '6800', '6353', '6350', '0163', '6301', '6300', '0162', '0149', '0148', '0122', '0121', '0120', '6700', '6600', '6500', '6400', '6205', '6204', '6201', '6200', '6100', 'M312', 'M313', 'M302', 'M309', 'M310', 'M311', '6936'};
        Set<String> CodigosPf = new Set<String>{'1150', '9001', '9002', '1140', '1835', '7100', '2130', '1300', '1200', '1250', '2400', '9200', '2120', '7000'};
        Id recordTypeMasivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Masivos').getRecordTypeId();
        Id recordTypePf = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').getRecordTypeId();

        for (Poliza__c p: Trigger.new) {
            try {
                if (CodigosPf.contains(p.Codigo_de_Producto__c)) {
                    p.RecordTypeId = recordTypePf;
                }

                if (CodigosMasivos.contains(p.Codigo_de_Producto__c)) {
                    p.RecordTypeId = recordTypeMasivos;
                }

            } catch (Exception e) {
                system.debug('@@@@ -> :' + e.getMessage());
            }
        }
    }
}