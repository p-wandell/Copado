/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class MultiCurrencyUtil {
    global static Boolean APPIRIO_CURRENCY_TEST_MODE;
    global MultiCurrencyUtil() {

    }
    global static Decimal getConversionRateByDate(String currencyCode, Date d) {
        return null;
    }
    global static Decimal getConversionRateRatioByDate(String currencyCodeVariable, String currencyCodeFixed, Date effectiveDate, Date currentDate) {
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
    global static Map<String,Decimal> getConversionRatesByDate(Set<String> currencyCodes, Date d) {
        return null;
    }
    webService static Double getConvertedAmount(Double fromAmount, String fromCurrency, String toCurrency, Date d) {
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
}
