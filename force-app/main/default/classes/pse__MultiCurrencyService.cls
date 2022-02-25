/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MultiCurrencyService {
    global MultiCurrencyService() {

    }
    global static Decimal getConversionRateRatioByDate(String fromCurrencyCode, String toCurrencyCode, Date initialConversionDate, Date targetConversionDate) {
        return null;
    }
    global static Map<Date,Map<String,Decimal>> getConversionRatesByDate(List<String> currencyCodeList, List<Date> dateList) {
        return null;
    }
    global static Map<Date,Map<String,Decimal>> getConversionRatesByDate(List<String> currencyCodeList, Set<Date> dateSet) {
        return null;
    }
    global static Map<Date,Map<String,Decimal>> getConversionRatesByDate(Set<String> currencyCodeSet, List<Date> dateList) {
        return null;
    }
    global static Map<Date,Map<String,Decimal>> getConversionRatesByDate(Set<String> currencyCodeSet, Set<Date> dateSet) {
        return null;
    }
    global static Double getConvertedAmount(Double fromAmount, String fromCurrency, String toCurrency, Date d) {
        return null;
    }
    global static Map<String,Boolean> isCurrencyCorporate(Set<String> currencyCodeSet) {
        return null;
    }
    global static Boolean useDatedExchangeRates() {
        return null;
    }
    global static Boolean useSalesforceAdvancedMultiCurrency() {
        return null;
    }
global class ExchangeRate {
    global Integer currentScale {
        get;
        set;
    }
    global ExchangeRate() {

    }
    global ExchangeRate(Set<String> currencyCodeSet, Set<Date> dateSet) {

    }
    global ExchangeRate(Set<String> currencyCodeSet, Set<Date> dateSet, Integer scale) {

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
}
