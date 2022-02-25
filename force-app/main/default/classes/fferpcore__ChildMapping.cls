/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ChildMapping extends fferpcore.SubscriptionDescription.Mapping {
    global ChildMapping(Schema.SObjectType childType, Schema.SObjectField parentField, fferpcore.ChildMapping.ChildCorrelationStrategy correlationStrategy, List<String> messageKey) {

    }
    global ChildMapping(Schema.SObjectType childType, Schema.SObjectField parentField, fferpcore.ChildMapping.ChildCorrelationStrategy correlationStrategy, String messageKey) {

    }
    global override Set<String> getAdditionalSelections() {
        return null;
    }
    global override List<List<String>> getMessageKeys() {
        return null;
    }
    global override Set<String> getTargetFields() {
        return null;
    }
    global override void performBulkActions() {

    }
    global override void performImmediateActions(fferpcore.SubscriptionDescription.ApplyMappingRequest request) {

    }
    global fferpcore.ChildMapping withMapping(fferpcore.SubscriptionDescription.Mapping mapping) {
        return null;
    }
    global fferpcore.ChildMapping withMappings(List<fferpcore.SubscriptionDescription.Mapping> mappings) {
        return null;
    }
global class AppendChildCorrelationStrategy extends fferpcore.ChildMapping.ChildCorrelationStrategy {
    global AppendChildCorrelationStrategy() {

    }
}
global abstract class ChildCorrelationStrategy {
    global ChildCorrelationStrategy() {

    }
}
global class ReplaceChildCorrelationStrategy extends fferpcore.ChildMapping.ChildCorrelationStrategy {
    global ReplaceChildCorrelationStrategy() {

    }
}
global virtual class UpdateChildCorrelationStrategy extends fferpcore.ChildMapping.ChildCorrelationStrategy {
    global UpdateChildCorrelationStrategy(Schema.SObjectField correlationField, List<String> correlationKey) {

    }
    global UpdateChildCorrelationStrategy(Schema.SObjectField correlationField, String correlationKey) {

    }
}
global class UpdateTotalChildCorrelationStrategy extends fferpcore.ChildMapping.UpdateChildCorrelationStrategy {
    global UpdateTotalChildCorrelationStrategy(Schema.SObjectField correlationField, List<String> correlationKey) {

    }
    global UpdateTotalChildCorrelationStrategy(Schema.SObjectField correlationField, String correlationKey) {

    }
}
}
