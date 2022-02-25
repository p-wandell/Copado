/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface SubscriptionMapping {
    Boolean canHaveChildren();
    void disableOutputTo(Set<String> param0);
    List<fferpcore.SubscriptionMapping> getChildren();
    List<List<String>> getMessageKeys();
    Set<String> getTargetFields();
    String getTransformTableId();
    Boolean isDeclarative();
    Boolean isDisabled();
    void performBulkActions();
    void performImmediateActions(fferpcore.ApplyMappingRequest2 param0);
    void prepare(fferpcore.DataTarget param0);
    void setDeclarative(Boolean param0);
}
