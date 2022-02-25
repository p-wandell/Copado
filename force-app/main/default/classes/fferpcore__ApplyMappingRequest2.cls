/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface ApplyMappingRequest2 {
    fferpcore.SubscriptionDescription.Value getLatestValue(List<String> param0);
    List<fferpcore.SubscriptionDescription.Value> getLatestValues(List<List<String>> param0);
    fferpcore.TargetObject getTarget();
    Boolean hasError();
    void respondError(fferpcore.ErpErrorBody param0);
}
