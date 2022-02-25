/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AnalyticsApi {
    global AnalyticsApi() {

    }
global class ClickEvent extends CoveoV2.AnalyticsApi.Event {
    global ClickEvent(CoveoV2.SearchApiResult result, String language, String searchQueryUid, String actionCause) {

    }
}
global class CustomEvent extends CoveoV2.AnalyticsApi.Event {
    global String eventType;
    global String eventValue;
    global String language;
    global CustomEvent(String eventType, String eventValue, String language) {

    }
}
global virtual class Event {
    global String stringify() {
        return null;
    }
    global CoveoV2.AnalyticsApi.Event withCustomData(String key, Object value) {
        return null;
    }
    global CoveoV2.AnalyticsApi.Event withParam(String key, Object value) {
        return null;
    }
    global CoveoV2.AnalyticsApi.Event withParamsMap(Map<String,Object> params) {
        return null;
    }
}
global class SearchEvent extends CoveoV2.AnalyticsApi.Event {
    global SearchEvent(CoveoV2.SearchApiResponse response, String language, String queryText, String actionCause) {

    }
}
}
