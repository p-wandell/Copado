/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global abstract class ChainedMapping extends fferpcore.SubscriptionDescription.Mapping {
    global static List<String> MESSAGE_KEY_UPSTREAM_RESULT;
    global ChainedMapping(fferpcore.SubscriptionDescription.Mapping nextMapping) {

    }
    global override virtual void disableFields(Set<String> fieldNames) {

    }
    global fferpcore.SubscriptionDescription.Mapping getNextMapping() {
        return null;
    }
    global override virtual Set<String> getTargetFields() {
        return null;
    }
    global override virtual Boolean isDisabled() {
        return null;
    }
    global override void performBulkActions() {

    }
    global override void performImmediateActions(fferpcore.SubscriptionDescription.ApplyMappingRequest request) {

    }
    global virtual void processImmediateRequest(fferpcore.ChainedMapping.CollectedRequest request) {

    }
    global abstract void processRequests(List<fferpcore.ChainedMapping.CollectedRequest> param0);
global interface CollectedRequest {
    fferpcore.SubscriptionDescription.Value getLatestValue(List<String> param0);
    List<fferpcore.SubscriptionDescription.Value> getLatestValues(List<List<String>> param0);
    SObject getRecord();
    void respondError(fferpcore.ErpErrorBody param0);
    void setResult(fferpcore.SubscriptionDescription.Value param0);
}
}
