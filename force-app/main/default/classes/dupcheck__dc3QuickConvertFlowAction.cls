/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3QuickConvertFlowAction {
    global dc3QuickConvertFlowAction() {

    }
    @InvocableMethod(label='DC - Quick Convert' description='Convert given records based on the Duplicate Check configuration.')
    global static List<dupcheck.dc3QuickConvertFlowAction.QuickConvertResult> quickConvertRecords(List<dupcheck.dc3QuickConvertFlowAction.QuickConvertRequest> quickConvertRequests) {
        return null;
    }
global class QuickConvertRequest {
    @InvocableVariable(label='AccountID' description='Optional Account ID to convert to.' required=false)
    global Id accountId;
    @InvocableVariable(label='ContactID' description='Optional Contact ID to convert to.' required=false)
    global Id contactId;
    @InvocableVariable(label='ConvertStatus' description='The Convert Status of the lead.' required=true)
    global String convertStatus;
    @InvocableVariable(label='CreateOpportunity' description='Wether or not an opportunity should be created as well.' required=false)
    global Boolean createOpportunity;
    @InvocableVariable(label='LeadID' description='The lead ID to convert.' required=false)
    global Id leadId;
    @InvocableVariable(label='OpportunityName' description='The opportunity name.' required=false)
    global String opportunityName;
    @InvocableVariable(label='SearchResult' description='A duplicate search result from a DC3 Search Flow Action.' required=false)
    global dupcheck.dc3FlowSearchComplexType searchResult;
    @InvocableVariable(label='Threshold' description='Threshold for Search Results to be eligible for converting.' required=false)
    global Integer threshold;
    global QuickConvertRequest() {

    }
}
global class QuickConvertResult {
    @InvocableVariable(label='AccountID' description='The (Person) Account ID the lead has been converted in to.' required=false)
    global Id accountId;
    @InvocableVariable(label='ContactID' description='The Contact ID the lead has been converted in to.' required=false)
    global Id contactId;
    @InvocableVariable(label='ConvertSucceeded' description='Wether or not the convertion has succeeded.' required=false)
    global Boolean convertSucceeded;
    @InvocableVariable(label='OpportunityID' description='The Opportunity ID that might have been created if requested.' required=false)
    global Id opportunityId;
    global QuickConvertResult() {

    }
}
}
