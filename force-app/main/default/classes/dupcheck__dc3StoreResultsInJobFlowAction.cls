/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3StoreResultsInJobFlowAction {
    global dc3StoreResultsInJobFlowAction() {

    }
    @InvocableMethod(label='DC - Store Duplicate in DC Job' description='Store DC Search By ID results in a DC Job')
    global static List<dupcheck.dc3StoreResultsInJobFlowAction.StoreResultsInJobResult> storeResultsInJob(List<dupcheck.dc3StoreResultsInJobFlowAction.StoreResultsInJobRequest> storeResultsInJobRequests) {
        return null;
    }
global class StoreResultsInJobRequest {
    @InvocableVariable(label='DC Job Name' description='The name of the DC job to create.' required=false)
    global String dcJobName;
    @InvocableVariable(label='SearchResult' description='A duplicate search result from a DC3 Search Flow Action.' required=true)
    global dupcheck.dc3FlowSearchComplexType searchResult;
    global StoreResultsInJobRequest() {

    }
}
global class StoreResultsInJobResult {
    @InvocableVariable(label='DcJobID' required=false)
    global Id dcJobID;
    @InvocableVariable(label='Succeeded' required=false)
    global Boolean succeeded;
    global StoreResultsInJobResult() {

    }
}
}
