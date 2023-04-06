/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-15-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_LWC_Gestion_Seguro_Covid {


    @AuraEnabled
    public static List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact> uploadFileContacts(String jsonData) {
        system.debug('@@@@ jsonData '+jsonData);
        String data = JSON.deserializeUntyped(jsonData).toString();
        system.debug('@@@@ DATA '+data);
        List<String> lstCSVLines = data.split('\n');

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact> listOut = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact>();

        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact value;
        List<String> csvRowData;

        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            value = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
            csvRowData = getDataLine(lstCSVLines[i]);
            system.debug('@@@@ line '+lstCSVLines[i]);
            value.RutEmpresa = csvRowData[0].trim();
            value.RutContacto = csvRowData[1].trim();
            value.NombreContacto = csvRowData[2];
            value.ApellidoContacto = csvRowData[3];
            value.TipoContacto = csvRowData[4];
            value.EmailContacto = csvRowData[5].trim();
            value.RutEmpresaCorredora = csvRowData[6];
            system.debug('@@@@ value '+value);

            listOut.add(value);
        }

        return listOut;
    }

    @AuraEnabled
    public static List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa> uploadFileRutEmpresas(String jsonData) {
        String data = JSON.deserializeUntyped(jsonData).toString();
        system.debug('@@@@ DATA '+data);
        List<String> lstCSVLines = data.split('\n');

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa> listOut = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa>();

        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa value;

        List<String> csvRowData;

        List<String> RUTEmpresas = new List<String>();

        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            value = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa();
            csvRowData = getDataLine(lstCSVLines[i]);
            value.RutEmpresa = csvRowData[0].trim();
            value.ExisteEmpresa = false;
            listOut.add(value);
            RUTEmpresas.add(value.RutEmpresa);
            system.debug('@@@@ RutEmpresa '+value.RutEmpresa );
        }

        Map<String, Account> empresas = CLS_BAK_Gestion_Seguro_Covid.retornaCuentasEnvioCorreo(RUTEmpresas);

        system.debug('@@@@ empresas.size() '+empresas.size());

        for(CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa dato : listOut)
        {
            Account cuenta = empresas.get(dato.RutEmpresa);
            system.debug('@@@@ # RUT '+dato.RutEmpresa );
            system.debug('@@@@ cuenta  '+cuenta);
            if (cuenta != null)
            {
                dato.NombreEmpresa = cuenta.Name;
              //  dato.NotificacionSeguroCovid = cuenta.Notificacion_Seguro_COVID__c;

                dato.ExisteEmpresa = true;
            }
        }

        return listOut;
    }

    private static List<String> getDataLine(String csvLine)
    {
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;

        while(csvLine.indexOf('"') > -1){

            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }

            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }

        List<String> csvRowData = new List<String>();
        for(String column : csvLine.split(',')){
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
            csvRowData.add(column);
        }

        return csvRowData;
    }

    @AuraEnabled
    public static Boolean saveFileContacts(String jsonData) {
        String data = JSON.deserializeUntyped(jsonData).toString();
        List<String> lstCSVLines = data.split('\n');

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact> listToWork = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact>();

        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact value;
        List<String> csvRowData;

        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            value = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
            csvRowData = getDataLine(lstCSVLines[i]);
            value.RutEmpresa = csvRowData[0].trim();
            value.RutContacto = csvRowData[1].trim();
            value.NombreContacto = csvRowData[2];
            value.ApellidoContacto = csvRowData[3];
            value.TipoContacto = csvRowData[4];
            value.EmailContacto = csvRowData[5].trim();
            value.RutEmpresaCorredora = csvRowData[6];
            listToWork.add(value);
        }

        System.debug('@@@@ '+listToWork.size());

        return CLS_BAK_Gestion_Seguro_Covid.actualizaContactos(listToWork);
    }


    @AuraEnabled
    public static Integer sendEmail(String jsonData) {
        String data = JSON.deserializeUntyped(jsonData).toString();
        List<String> lstCSVLines = data.split('\n');

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa> listToWork = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa>();

        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa value;
        List<String> csvRowData;

        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            value = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa();
            csvRowData = getDataLine(lstCSVLines[i]);
            value.RutEmpresa = csvRowData[0].trim();
            listToWork.add(value);
        }

        Integer success = CLS_BAK_Gestion_Seguro_Covid.ejecutaEnvioMasivo(listToWork);

        System.debug('@@@@ '+listToWork.size());

        return success;
    }

}