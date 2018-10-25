trigger FillLookupTrigger on Car__c (before insert) {
    List<Car__c> cars = Trigger.new;
    Map<SObjectField, SObjectField> mapLookupsAndNameForLookups = MapperFields.getMapLookupsAndNames();
    Map<SObjectField, List<sObject>> mapLookupsAndQuery = new Map<SObjectField, List<sObject>>();
    Map<SObjectField, List<String>> mapLookupsAndRecords = MapperFields.getMapLookupsAndRecords(cars, mapLookupsAndNameForLookups);
    SObjectField manufacturer;
    List<String> childManufacturer = new List<String>();
    childManufacturer.add('Model__c');
    childManufacturer.add('Engine__c');

    System.debug('mapLookupsAndRecords  ' + mapLookupsAndRecords);
    for (SObjectField lookupField : mapLookupsAndRecords.keySet()) {
        if (lookupField.getDescribe().getName() == 'Manufacturer__c') {
            manufacturer = lookupField;
        }
        List<String> records = mapLookupsAndRecords.get(lookupField);
        if (!childManufacturer.contains(lookupField.getDescribe().getName())) {
            mapLookupsAndQuery.put(lookupField, Database.query('SELECT Id, Name FROM ' + lookupField + ' WHERE Name IN :records OR Id IN :records' ));
          }
        else
        {
            List<Id> listId = new List<Id>();
            for (SObject obj : mapLookupsAndQuery.get(manufacturer))
            {
                listId.add(obj.Id);
            }
            mapLookupsAndQuery.put(lookupField, Database.query('SELECT Id, Name FROM ' + lookupField + ' WHERE Manufacturer__r.Id IN :listId AND (Name IN :records OR Id IN :records)'  ));
        }
    }
    System.debug('mapLookupsAndQuery  ' + mapLookupsAndQuery);
    for (Car__c car : cars) {
        for (SObjectField lookupField : mapLookupsAndRecords.keySet()) {
            SObjectField nameFieldForLookup = mapLookupsAndNameForLookups.get(lookupField);
                for (SObject sObj : mapLookupsAndQuery.get(lookupField)) {
                    if (car.get(nameFieldForLookup) != null && car.get(nameFieldForLookup) == sObj.get('Name')) {
                        car.put(lookupField, sObj.Id);
                        break;
                    } else if (car.get(lookupField) != null) {
                        car.put(nameFieldForLookup, sObj.get('Name'));
                        break;
                    }
                }
            system.debug(mapLookupsAndQuery.get(lookupField).size());
            if(car.get(lookupField) == null) {
                car.addError(car.Name + '  ----> Not found lookup name!        '+ nameFieldForLookup.getDescribe().getLabel() );
                break;
            }
        }
    }
}