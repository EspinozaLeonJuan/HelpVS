/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-01-2021
 * @last modified by  : Juan Espinoza León
**/
public class CLS_UTL_Lightning {
    public CLS_UTL_Lightning() {

    }
    public with sharing class customValueWrapper {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }

    public static List <customValueWrapper>  get_pickList_with_dependency(Schema.sObjectField dependToken, String Filter) {
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new List <customValueWrapper>();
        }
    
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
    
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        List <customValueWrapper> dependentPicklistValues = new List <customValueWrapper>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars = String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue = 
                        (controlEntries == null
                                ?   (Object) (index == 1)
                                :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getValue() : null)
                        );
                    system.debug('@@@@@ '+String.valueOf(controlValue));
                    if (String.valueOf(controlValue) == Filter)
                    {
                        Integer bitIndex = index / 6;
                        if (bitIndex > base64chars.size() - 1) {
                            break;
                        }
                        Integer bitShift = 5 - Math.mod(index, 6);
                        if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                            continue;

                            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
                            selectOptionValueWrapper.custFldlabel = entry.getLabel();
                            selectOptionValueWrapper.custFldvalue = entry.getValue();
                            dependentPicklistValues.add(selectOptionValueWrapper);
                    }                   
                }
            }
        }

        return dependentPicklistValues;
    }

  
    public static List < customValueWrapper > get_pickList_without_dependency(sObject customObjInfo, string selectPicklistApi) {
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();     
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) {
          customValueWrapper selectOptionValueWrapper = new customValueWrapper();
             selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
             selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
        
        return customObjWrapper;
    }

}