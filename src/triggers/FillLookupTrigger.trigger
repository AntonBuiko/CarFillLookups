trigger FillLookupTrigger on Car__c (before insert) {
    Map<String, Schema.SObjectField> fieldMap = Car__c.SObjectType.getDescribe().fields.getMap();
    List<Car__c> cars = Trigger.new;
    for (Car__c car : cars) {
        for (String key : fieldMap.keySet()) {
            SObjectField field = fieldMap.get(key);
            if (field.getDescribe().getType() == DisplayType.REFERENCE && field.getDescribe().getName().endsWith('__c')) {
                String lookupField = field.getDescribe().getName();
                String lookupName = fieldMap.get(key.substringBefore('_') + '_name_' + key.substringAfter('_')).getDescribe().getName();
                String sObjName = car.get(lookupName).toString();
                List<sObject> sObj = Database.query('SELECT Id FROM ' + lookupField + ' WHERE Name = \'' + String.valueOf(sObjName)+'\'');
                if (sObj.size()>0) {
                    car.put(lookupField, sObj[0].Id);
                }
                else{
                    car.addError('Not found lookup name!');
                }

            }
        }
    }
    System.debug(cars);
}