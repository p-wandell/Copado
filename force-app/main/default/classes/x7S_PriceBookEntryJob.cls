/**
 * Created by andyhall on 2019-07-08.
 *
 * This class id used to update Product (Product2) objects with the most recent price from PriceBookEntry object.  In
 * case that there are multiple PriceBookEntry objects that are modified that are linked to the same Product, only the
 * most recently updated will be used.
 */
public class x7S_PriceBookEntryJob implements Schedulable {

    // TODO Move this to custom metadata to allow the interval to be more finely tuned
    private static final Integer CHECK_INTERVAL = -60;

    /**
     * This method is used to ensure that this class is a Schedulable Apex Job
     *
     * @param schedulableContext The Schedulable Context
     */
    public void execute(SchedulableContext schedulableContext) {
        System.debug('Executing the main logic');
        updateProducts();
        System.debug('Completed Scheduled job');
    }

    /**
     * This method will update the Price on Product objects that are linked to a recently updated PriceBookEntry
     */
    public static void updateProducts() {
        // Get the updates PriceBookEntry objects
        List<PricebookEntry> pbes = getActiveUpdatedPriceBookEntries();
        if ( (pbes == null) || (pbes.size() <= 0) ) {
            System.debug('Unable to update Products as no recently updated PriceBookEntry objects were found');
            return;
        }

        // Get the data as maps to make the logic easier
        Map<Id, PricebookEntry> pbeMap = getPriceBookEntryMapByProductId(pbes);

        // Get the Products linked to the Price Book Entries
        List<Product2> products = getActiveProducts(pbeMap.keySet());
        if ( (products == null) || (products.size() <= 0) ) {
            System.debug('Unable to update Products as no valid active Products were found from the PriceBookEntries: ' + pbes);
            return;
        }

        List<Product2> updatedProducts = new List<Product2>();

        // Walk the Products and update the prices
        for (Product2 product : products) {
            if ( (product == null) || (product.IsActive != true) || (product.Id == null) ) {
                System.debug('Skipping Product as it is either not valid or active: ' + product);
                continue;
            }

            // Get the PriceBookEntries for the Product
            PricebookEntry entry = pbeMap.get(product.Id);
            if (entry == null) {
                System.debug('Unable to update Product with a new price as no valid PriceBookEntry objects were found.  Product: ' + product);
                continue;
            }
            else {
                product.Price__c = entry.UnitPrice;
                updatedProducts.add(product);
                System.debug('Setting Price of: ' + product.Price__c + ' on Product: ' + product.Id);
            }
        }

        // If there were changed products, update them now
        if (updatedProducts.size() > 0) {
            update updatedProducts;
            System.debug('Updated products with new prices: ' + updatedProducts);
        }
        else {
            System.debug('No Products where updated, this is likely due to a logic error in the code!');
        }
    }

    /**
     * This method will retrieve active and recently updated PriceBookEntry objects based on the SystemModstamp.
     * The interval for this timeframe is set via custom metadata
     *
     * @return A List of updated and active PricebookEntry objects
     */
    static List<PriceBookEntry> getActiveUpdatedPriceBookEntries() {
        // TODO Get the interval to check from custom metadata
        return [SELECT Id, PriceBook2Id, Product2Id, UnitPrice, SystemModstamp, IsActive
                FROM PricebookEntry
                WHERE SystemModstamp >= :Datetime.now().addMinutes(CHECK_INTERVAL)
                AND IsActive = TRUE
                ORDER BY SystemModstamp DESC];
    }

    /**
     * This method will retrieve all of the active Products that are linked to the supplied Ids
     *
     * @param ids A Set of Ids
     *
     * @return The Product objects
     */
    static List<Product2> getActiveProducts(Set<Id> ids) {
        List<Product2> result = null;
        if ( (ids != null) && (ids.size() > 0) ) {
            result = [SELECT Id, IsActive, Name, Price__c FROM Product2 WHERE IsActive = TRUE AND Id IN :ids];
            System.debug('Retrieved Products from PriceBookEntries: ' + ids + ' Retrieved Products: ' + result);
        }
        else {
            System.debug('Unable to retrieve Products as no valid Ids where found from the supplied PriceBookEntries: ' + ids);
        }

        return result;
    }

    /**
     * This method will create a Map of Product Id and the most recently updated and active PriceBookEntry.  This will
     * ensure that only the most recently updated PriceBookEntry will be used.
     *
     * @param pbes A List of PriceBookEntry objects
     *
     * @return A Map of Product Id and PriceBookEntry
     */
    static Map<Id, PricebookEntry> getPriceBookEntryMapByProductId(List<PriceBookEntry> pbes) {
        Map<Id, PricebookEntry> result = new Map<Id, PricebookEntry>();

        for (PricebookEntry pbe : pbes) {
            if ( (pbe == null) || (pbe.IsActive != true) || (pbe.UnitPrice == null) || (pbe.Pricebook2Id == null) ) {
                System.debug('Unable to process PriceBookEntry as the object is either null, not active, no have a price, or no Product: ' + pbe);
                continue;
            }

            // Get the current object from the map
            PricebookEntry temp = result.get(pbe.Product2Id);

            // If nothing was found or the timestamp on the value in the map is older than the
            // new timestamp, use the new object
            if ( (temp == null) || (pbe.SystemModstamp > temp.SystemModstamp) ) {
                result.put(pbe.Product2Id, pbe);
            }
        }

        return result;
    }
}