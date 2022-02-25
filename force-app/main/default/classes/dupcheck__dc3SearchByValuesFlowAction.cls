/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3SearchByValuesFlowAction {
    global dc3SearchByValuesFlowAction() {

    }
    @InvocableMethod(label='DC - Find Duplicate by Field Values' description='Given some Field Values, return a list of potential duplicates.')
    global static List<dupcheck.dc3SearchByValuesFlowAction.SearchByValuesResult> findDuplicateByValues(List<dupcheck.dc3SearchByValuesFlowAction.SearchByValuesRequest> searchRequests) {
        return null;
    }
global class SearchByValuesRequest {
    @InvocableVariable(label='Search Cross Object' description='Search cross object, defaults to false' required=false)
    global Boolean crossObject;
    @InvocableVariable(label='Object and Fields' description='Object fields and values' required=true)
    global SObject searchObject;
    global SearchByValuesRequest() {

    }
}
global class SearchByValuesResult {
    @InvocableVariable(label='Duplicate' description='Indicates wether duplicates have been found' required=false)
    global Boolean duplicate;
    @InvocableVariable(label='Duplicate Result' description='The full duplicate search result' required=false)
    global dupcheck.dc3FlowSearchComplexType duplicateResult;
    @InvocableVariable(label='Matching Score' description='The highest matching score' required=false)
    global Integer matchingScore;
    @InvocableVariable(label='Record ID' description='Record ID based on the highest matching score' required=false)
    global Id recordId;
    @InvocableVariable(label='Total Duplicates' description='The total number of duplicates found' required=false)
    global Integer totalDuplicates;
    global SearchByValuesResult() {

    }
}
}
