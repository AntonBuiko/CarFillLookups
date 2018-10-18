/**
 * Created by a2.buyko on 17.10.18.
 */

@IsTest
private class TestFillLookupTrigger {
    static Manufacturer__c manufacturer;
    static Model__c model;
    static Engine__c engine;
    static Color__c color;

    @IsTest
    static void testSuccessFill() {
            FillObjects();
            System.debug(manufacturer);
            Car__c car = new Car__c(Name = 'Success  Test Car', Manufacturer_Name__c = 'Toyota Motors',
                    Model_Name__c = 'Camry', Engine_Name__c = 'V12', Color_Name__c = 'Green');
            Test.startTest();
            Database.SaveResult result = Database.insert(car, false);
            Test.stopTest();
            System.assert(result.isSuccess());
    }

    @IsTest
    static void testNegativeBehavior() {
        FillObjects();
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

    static void FillObjects(){
        manufacturer = new Manufacturer__c(Name='Toyota Motors');
        insert manufacturer;
        model = new Model__c(Name='Camry', Manufacturer__c = manufacturer.Id);
        engine = new Engine__c(Name='V12', Manufacturer__c = manufacturer.Id);
        color = new Color__c(Name='Green');
        insert model;
        insert engine;
        insert color;
    }
}