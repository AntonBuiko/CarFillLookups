public with sharing class MapLookupsFieldAndNames {
    public static Map<SObjectField, SObjectField> getMap() {
        Map<String, Schema.SObjectField> fieldMap = Car__c.SObjectType.getDescribe().fields.getMap();
        List<SObjectField> lookupFields = new List<SObjectField>();
        List<SObjectField> lookupFieldsName = new List<SObjectField>();
        for (String key : fieldMap.keySet()) {
            SObjectField field = fieldMap.get(key);
            if (field.getDescribe().getType() == DisplayType.REFERENCE && field.getDescribe().getName().endsWith('__c')) {
                lookupFields.add(field);
            } else if (field.getDescribe().getType() == DisplayType.STRING && field.getDescribe().getName().endsWith('__c')) {
                lookupFieldsName.add(field);
            }
        }
        Map<SObjectField, SObjectField> mapLookupFieldsAndNames = new Map<SObjectField, SObjectField>();
        for (SObjectField lookField : lookupFields) {
            for (SObjectField lookFieldName : lookupFieldsName) {
                if (lookFieldName.getDescribe().getLabel().contains(lookField.getDescribe().getLabel())) {
                    mapLookupFieldsAndNames.put(lookField, lookFieldName);
                }
            }
        }
        system.debug(mapLookupFieldsAndNames);
        return mapLookupFieldsAndNames;
    }
}