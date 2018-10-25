public with sharing class MapperFields {
    public static Map<SObjectField, SObjectField> getMapLookupsAndNames() {
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
        return mapLookupFieldsAndNames;
    }

    public static Map<SObjectField, List<String>> getMapLookupsAndRecords(List<Car__c> cars, Map<SObjectField, SObjectField> mapLookupsAndNameForLookups) {
        Map<SObjectField, List<String>> mapLookupsAndRecords = new Map<SObjectField, List<String>>();
        for (Car__c car : cars){
            for (SObjectField lookupField : mapLookupsAndNameForLookups.keySet()) {
                SObjectField nameFieldForLookup = mapLookupsAndNameForLookups.get(lookupField);
                        if (mapLookupsAndRecords.containsKey(lookupField)){
                            if (!mapLookupsAndRecords.get(lookupField).contains(car.get(nameFieldForLookup).toString())) {
                                mapLookupsAndRecords.get(lookupField).add(car.get(nameFieldForLookup).toString());
                            }
                        }
                         if (car.get(nameFieldForLookup) != null) {
                            mapLookupsAndRecords.put(lookupField,new List<String>());
                            mapLookupsAndRecords.get(lookupField).add(car.get(nameFieldForLookup).toString());
                        }
                         if (car.get(lookupField) != null) {
                            mapLookupsAndRecords.put(lookupField,new List<String>());
                            mapLookupsAndRecords.get(lookupField).add(car.get(lookupField).toString());
                        }
                System.debug(mapLookupsAndRecords);
            }
        }
        System.debug(mapLookupsAndRecords);
        return mapLookupsAndRecords;
    }

}