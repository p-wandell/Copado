/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3FlowSearchComplexType {
    @AuraEnabled
    @InvocableVariable( required=false)
    global List<dupcheck.dc3FlowSearchComplexType.dc3FlowSearchResultWrapper> searchResults;
    @AuraEnabled
    @InvocableVariable( required=false)
    global Id sourceId;
    @AuraEnabled
    @InvocableVariable( required=false)
    global String sourcePrefix;
    global dc3FlowSearchComplexType() {

    }
global class FlowScenarioScore {
    @AuraEnabled
    @InvocableVariable( required=false)
    global Id scenarioId;
    @AuraEnabled
    @InvocableVariable( required=false)
    global String scenarioName;
    @AuraEnabled
    @InvocableVariable( required=false)
    global Integer scenarioScore;
    global FlowScenarioScore() {

    }
}
global class FlowSearchResult {
    @AuraEnabled
    @InvocableVariable( required=false)
    global SObject objectData;
    @AuraEnabled
    @InvocableVariable( required=false)
    global List<String> objectIds;
    @AuraEnabled
    @InvocableVariable( required=false)
    global List<dupcheck.dc3FlowSearchComplexType.FlowScenarioScore> scenarioScores;
    @AuraEnabled
    @InvocableVariable( required=false)
    global Integer score;
    global FlowSearchResult() {

    }
}
global class dc3FlowSearchResultWrapper {
    @AuraEnabled
    @InvocableVariable( required=false)
    global String objectPrefix;
    @AuraEnabled
    @InvocableVariable( required=false)
    global List<dupcheck.dc3FlowSearchComplexType.FlowSearchResult> results;
    @AuraEnabled
    @InvocableVariable( required=false)
    global String stringifiedResults;
    global dc3FlowSearchResultWrapper() {

    }
}
}
