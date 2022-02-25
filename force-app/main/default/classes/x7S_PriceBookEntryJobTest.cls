/**
 * Created by andyhall on 2019-07-08.
 *
 * This class is for the Unit Tests for the x7S_PriceBookEntryJob class
 */
@IsTest
private class x7S_PriceBookEntryJobTest {

    @IsTest
    static void testBehavior() {
        testSetup();
        Product2 origProduct = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        System.assert(origProduct != null);

        // Get the latest PriceBookEntry
        List<PricebookEntry> pbes = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE IsActive = TRUE ORDER BY SystemModstamp DESC];
        System.assert(pbes != null);
        System.assert(pbes.size() == 1);
        PricebookEntry entry = pbes.get(0);

        // Make sure that the prices are not the same
        System.assert(origProduct.Price__c != entry.UnitPrice);

        // Call the update to update the Product with the new price
        x7S_PriceBookEntryJob.updateProducts();

        // Get the Product
        Product2 product = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        System.assert(product != null);

        // Make sure that the product's price is set correctly
        System.assertEquals(product.Price__c, entry.UnitPrice);
    }

    @IsTest
    static void testBehaviorWithSchedule() {
        testSetup();
        Product2 origProduct = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        System.assert(origProduct != null);

        // Get the latest PriceBookEntry
        List<PricebookEntry> pbes = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE IsActive = TRUE ORDER BY SystemModstamp DESC];
        System.assert(pbes != null);
        System.assert(pbes.size() == 1);
        PricebookEntry entry = pbes.get(0);

        // Make sure that the prices are not the same
        System.assert(origProduct.Price__c != entry.UnitPrice);

        // Call the update to update the Product with the new price
        x7S_PriceBookEntryJob job = new x7S_PriceBookEntryJob();
        job.execute(null);

        // Get the Product
        Product2 product = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        System.assert(product != null);

        // Make sure that the product's price is set correctly
        System.assertEquals(product.Price__c, entry.UnitPrice);
    }

    @IsTest(SeeAllData=true)
    static void testBehaviorWithScheduleWithRealData() {
        //testSetup();
        //Product2 origProduct = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        //System.assert(origProduct != null);

        // Get the latest PriceBookEntry
        //List<PricebookEntry> pbes = [SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE IsActive = TRUE ORDER BY SystemModstamp DESC];
        //System.assert(pbes != null);
        //System.assert(pbes.size() == 1);
        //PricebookEntry entry = pbes.get(0);

        // Make sure that the prices are not the same
        //System.assert(origProduct.Price__c != entry.UnitPrice);

        // Call the update to update the Product with the new price
        x7S_PriceBookEntryJob job = new x7S_PriceBookEntryJob();
        job.execute(null);

        // Get the Product
        //Product2 product = [SELECT Id, Name, Description, Price__c FROM Product2 WHERE IsActive = TRUE];
        //System.assert(product != null);

        // Make sure that the product's price is set correctly
        //System.assertEquals(product.Price__c, entry.UnitPrice);
    }

    //TestSetup
    static void testSetup() {
        Product2 product = createProduct();
        Pricebook2 priceBook = createPricebook();
        createPricebookEntry(priceBook, product, 1.1);
    }

    static Product2 createProduct() {
        String rand = '' + (Integer)(Math.random() * 1000);
        Product2 product = new Product2();
        product.Name = 'Test' + rand;
        product.Price__c = 0;
        product.Description = 'Test Product';
        product.IsActive = true;
        insert product;
        return product;
    }

    static Pricebook2 createPricebook() {
        Pricebook2 pb = new Pricebook2();
        pb.Id = Test.getStandardPricebookId();
        pb.IsActive = true;
        update pb;
        return pb;
    }

    static PricebookEntry createPricebookEntry(Pricebook2 priceBook, Product2 product, Decimal price) {
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2 = priceBook;
        pbe.Pricebook2Id = priceBook.Id;
        pbe.Product2 = product;
        pbe.Product2Id = product.Id;
        pbe.UnitPrice = price;
        pbe.IsActive = true;
        insert pbe;
        return pbe;
    }
}