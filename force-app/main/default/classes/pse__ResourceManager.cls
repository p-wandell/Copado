/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ResourceManager {
    global ResourceManager() {

    }
    webService static List<pse.ResourceManager.ConvertedResourceCostRate> getConvertedResourceCostRates(List<Id> resourceIDList, String targetCurrency, Date conversionDate) {
        return null;
    }
    webService static List<Double> getWorkingHours(List<Id> resourceIDList, Date startDate, Date endDate) {
        return null;
    }
    webService static void updateResourceActualsUtilization(List<Id> resourceActualsIDList, List<Id> resourceIDList) {

    }
global class ConvertedResourceCostRate {
    webService Double convertedRate {
        get;
        set;
    }
    webService String fromCurrencyCode {
        get;
        set;
    }
    webService Id resourceID {
        get;
        set;
    }
    webService String toCurrencyCode {
        get;
        set;
    }
    global ConvertedResourceCostRate(Id resID, String fromCurrCode, String toCurrCode, Double convRate) {

    }
}
}
