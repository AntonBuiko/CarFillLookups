trigger FillLookupTrigger on Car__c (before insert) {
    Map<SObjectField, SObjectField> mapLookupsAndNameForLookups = MapLookupsFieldAndNames.getMap();
    Map<SObjectField, List<sObject>> mapLookupAndSObjects = new Map<SObjectField, List<sObject>>();
    for (SObjectField lookupField : mapLookupsAndNameForLookups.keySet()) {
        mapLookupAndSObjects.put(lookupField, Database.query('SELECT Id, Name FROM ' + lookupField));
    }
    System.debug(mapLookupAndSObjects);
    List<Car__c> cars = Trigger.new;
    for (Car__c car : cars) {
        for (SObjectField lookupField : mapLookupsAndNameForLookups.keySet()) {
            SObjectField nameFieldForLookup = mapLookupsAndNameForLookups.get(lookupField);
            for (SObject sObj : mapLookupAndSObjects.get(lookupField)) {
                if (car.get(nameFieldForLookup) == sObj.get('Name')) {
                    car.put(lookupField, sObj.Id);
                    break;
                }
            }
        }
    }
    System.debug(cars);
}