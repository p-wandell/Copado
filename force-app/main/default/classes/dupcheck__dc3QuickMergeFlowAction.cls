/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3QuickMergeFlowAction {
    global dc3QuickMergeFlowAction() {

    }
    @InvocableMethod(label='DC - Quick Merge' description='Merge given records based on the Duplicate Check merge rules.')
    global static List<dupcheck.dc3QuickMergeFlowAction.QuickMergeResult> quickMergeRecords(List<dupcheck.dc3QuickMergeFlowAction.QuickMergeRequest> quickMergeRequests) {
        return null;
    }
global class QuickMergeRequest {
    @InvocableVariable(label='RecordIDs' description='The record IDs to merge.' required=false)
    global List<Id> recordIds;
    @InvocableVariable(label='SearchResult' description='A duplicate search result from a DC3 Search Flow Action.' required=false)
    global dupcheck.dc3FlowSearchComplexType searchResult;
    @InvocableVariable(label='Threshold' description='The threshold for merging SearchResult records.' required=false)
    global Integer threshold;
    global QuickMergeRequest() {

    }
}
global class QuickMergeResult {
    @InvocableVariable(label='MasterRecordID' description='The ID of the master record duplicates have been merged into.' required=false)
    global Id masterRecordId;
    @InvocableVariable(label='MergeSucceeded' description='Wether or not the merge has succeeded.' required=false)
    global Boolean mergeSucceeded;
    global QuickMergeResult() {

    }
}
}
