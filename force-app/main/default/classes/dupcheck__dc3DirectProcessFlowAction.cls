/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3DirectProcessFlowAction {
    global dc3DirectProcessFlowAction() {

    }
    @InvocableMethod(label='DC - Process record via Direct Processing' description='The record added via this action will be processed according to the Direct Processing configuration.')
    global static List<dupcheck.dc3DirectProcessFlowAction.DirectProcessFlowResult> directProcessFlowAction(List<dupcheck.dc3DirectProcessFlowAction.DirectProcessFlowRequest> directProcessRequests) {
        return null;
    }
global class DirectProcessFlowRequest {
    @InvocableVariable(label='Async' description='Wether or not to process Async.' required=false)
    global Boolean async;
    @InvocableVariable(label='RecordID' description='The Record ID to Process' required=true)
    global Id recordId;
    global DirectProcessFlowRequest() {

    }
}
global class DirectProcessFlowResult {
    @InvocableVariable(label='Succeeded' required=false)
    global Boolean succeeded;
    global DirectProcessFlowResult() {

    }
}
}
