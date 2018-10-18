/**
 * Created by a2.buyko on 17.10.18.
 */

@IsTest
private class TestFillLookupTrigger {
    @IsTest
    static void testSuccessFill() {
        Car__c car = new Car__c(Name = 'Success  Test Car', Manufacturer_Name__c = 'Toyota Motors',
                Model_Name__c = 'Camry', Engine_Name__c = 'V12', Color_Name__c = 'Green');

        Test.startTest();
        Database.SaveResult result = Database.insert(car, false);
        Test.stopTest();
        System.debug(result);
        System.assert(result.isSuccess());
        System.assert(result.getErrors().size() < 0);
    }

    @IsTest
    static void testNegativeBehavior() {
        Car__c car = new Car__c();
        car.Name = 'Unsuccess  Test Car';
        car.Manufacturer_Name__c = 'Toyota sdf';
        car.Model_Name__c = 'sdf';
        car.Engine_Name__c = 'df';
        car.Color_Name__c = 'fd';

        Database.SaveResult result = Database.insert(car, false);
        System.debug(result);
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Not found lookup name!',
                result.getErrors()[0].getMessage());
    }
}