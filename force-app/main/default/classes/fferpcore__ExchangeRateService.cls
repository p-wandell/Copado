/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ExchangeRateService {
    global ExchangeRateService() {

    }
    global static fferpcore.ExchangeRateService.RateTablesResult getRateTables(fferpcore.ExchangeRateService.RateTablesRequest rateTableRequest) {
        return null;
    }
    global static Map<String,Decimal> getRates(String groupName, String rateType, Date effectiveDate, String relativeCurrency, Set<String> targetCurrencies) {
        return null;
    }
    global static void setRates(List<fferpcore.ExchangeRateService.SetRateRequest> requests) {

    }
global interface RateTable {
    Set<String> getAvailableCurrencies(Date param0);
    Date getEndDate();
    Date getEndDate(Date param0, String param1);
    Decimal getRate(Date param0, String param1, String param2);
    String getRateType();
    Map<String,Decimal> getRates(Date param0, String param1, Set<String> param2);
    Date getStartDate();
    Date getStartDate(Date param0, String param1);
}
global class RateTablesRequest {
    global Date FromDate;
    global Set<String> GroupNames;
    global Set<String> RateTypes;
    global Date ToDate;
    global RateTablesRequest(Set<String> groupNames, Date fromDate, Date toDate, Set<String> rateTypes) {

    }
}
global interface RateTablesResult {
    fferpcore.ExchangeRateService.RateTable getRateTable(String param0, String param1);
}
global class SetRateRequest {
    global Date EndDate;
    global String RateGroup;
    global Map<String,Decimal> RatesByCurrency;
    global String RateType;
    global String RelativeCurrency;
    global Date StartDate;
    global SetRateRequest(String rateGroup, String rateType, Date startDate, Date endDate, String relativeCurrency, Map<String,Decimal> ratesByCurrency) {

    }
    global SetRateRequest(String rateGroup, String rateType, Date startDate, Date endDate, String relativeCurrency, String targetCurrency, Decimal rate) {

    }
}
}
