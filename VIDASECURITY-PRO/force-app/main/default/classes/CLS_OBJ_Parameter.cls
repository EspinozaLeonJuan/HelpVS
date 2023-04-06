public class CLS_OBJ_Parameter {
    
    public static String GetValue(String key)
    {
        OBJ_Parameter__c parameter = [SELECT Id, Key__c, Value__c, Activo__c, Descripcion__c FROM OBJ_Parameter__c 
        WHERE key__c =: key];

        if (parameter != null)
        {
            return parameter.Value__c;
        }

        return '';
    }

}