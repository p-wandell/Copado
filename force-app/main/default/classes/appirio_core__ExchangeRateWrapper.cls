/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ExchangeRateWrapper {
    global Integer currentScale {
        get;
        set;
    }
    global ExchangeRateWrapper() {

    }
    global ExchangeRateWrapper(Set<String> currencyCodeSet, Set<Date> dateSet) {

    }
    global ExchangeRateWrapper(Set<String> currencyCodeSet, Set<Date> dateSet, Integer scale) {

    }
    global void addDatedCurrency(String currencyCode, Date conversionDate) {

    }
    global Decimal convertAmount(Decimal fromAmount, String fromCurrencyCode, Date fromDate, String toCurrencyCode, Date toDate) {
        return null;
    }
    global Decimal getDatedRate(String currencyCode, Date rateDate) {
        return null;
    }
}
