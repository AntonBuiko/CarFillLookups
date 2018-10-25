/**
 * Created by a2.buyko on 17.10.18.
 */

@IsTest
private class TestFillLookupTrigger {
    static Manufacturer__c manufacturer;
    static Model__c model;
    static Engine__c engine;
    static Color__c color;
    static Insurance__c insurance;

    @IsTest
    static void testSuccessFill() {
        FillObjects();
        Car__c car = new Car__c(Name = 'Success  Test Car', Manufacturer_Name__c = 'Toyota Motors',
                Model_Name__c = 'Camry', Engine_Name__c = 'V6', Color_Name__c = 'Green', Insurance_number__c = 'Casco');
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
        car.Insurance_number__c = 'dsfsd';

        Database.SaveResult result = Database.insert(car, false);
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
    }

    @IsTest
    static void testBulkCarsSuccessFill() {
        FillObjects();
        Car__c car1 = new Car__c(Name = 'Success  Test Car', Manufacturer_Name__c = 'Toyota Motors',
                Model_Name__c = 'Camry', Engine_Name__c = 'V12', Color_Name__c = 'Green', Insurance_number__c = 'Casco');
        Car__c car2 = new Car__c(Name = 'Success  Test Car', Manufacturer_Name__c = 'Toyota Motors',
                Model_Name__c = 'Camry', Engine_Name__c = 'V6', Color_Name__c = 'Green', Insurance_number__c = 'Casco');
        List<Car__c> cars = new List<Car__c>();
        cars.add(car1);
        cars.add(car2);
        Test.startTest();
        Database.SaveResult[] result = Database.insert(cars, false);
        Test.stopTest();
        System.assert(result[0].isSuccess());
        System.assert(result[1].isSuccess());
    }

    @IsTest
    static void testEmptyCar() {
        FillObjects();
        Car__c car = new Car__c(Name = 'Success  Test Car');
        Test.startTest();
        Database.SaveResult result = Database.insert(car, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    @IsTest
    static void tesOnlyLookup() {
        FillObjects();
        Car__c car = new Car__c(Name = 'Success  Test Car', Model__c = model.Id, Manufacturer__c = manufacturer.Id,
                            Engine__c = engine.Id, Color__c = color.Id, Insurance__c = insurance.Id);
        Test.startTest();
        Database.SaveResult result = Database.insert(car, false);
        Test.stopTest();
        System.assert(result.isSuccess());
    }

    static void FillObjects() {
        manufacturer = new Manufacturer__c(Name = 'Toyota Motors');
        insert manufacturer;
        model = new Model__c(Name = 'Camry', Manufacturer__c = manufacturer.Id);
        engine = new Engine__c(Name = 'V12', Manufacturer__c = manufacturer.Id);
        color = new Color__c(Name = 'Green');
        insurance = new Insurance__c(Name = 'Casco');
        insert insurance;
        insert model;
        insert engine;
        insert color;
        engine = new Engine__c(Name = 'V6', Manufacturer__c = manufacturer.Id);
        insert engine;
    }
}