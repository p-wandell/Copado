/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SubscriptionDescription implements fferpcore.LinkingMessageToObjectMarshaller, fferpcore.LinkingMessageToObjectMarshaller2 {
    global SubscriptionDescription(Schema.SObjectType context) {

    }
    global SubscriptionDescription(Schema.SObjectType context, List<fferpcore.SubscriptionDescription.Mapping> mappings) {

    }
    global void addMappings(List<fferpcore.SubscriptionDescription.Mapping> mappings) {

    }
    global static fferpcore.SubscriptionDescription.Mapping createDataTransformationLookupMapping(Schema.SObjectField targetField, List<List<String>> messageKeys, Id transformTableId, Schema.SObjectType relatedObjectType) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createDataTransformationLookupMapping(Schema.SObjectField targetField, List<List<String>> messageKeys, Id transformTableId, Schema.SObjectType relatedObjectType, Schema.SObjectField relatedLookupField, Schema.SObjectField relatedResultField) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createDataTransformationMapping(Schema.SObjectField targetField, List<List<String>> messageKeys, Id transformTableId) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createDataTransformationRecordTypeMapping(List<List<String>> messageKeys, Id transformTableId, Schema.SObjectType objectType) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createFieldMapping(Schema.SObjectField targetField, List<String> messageKey) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createLookupMapping(Schema.SObjectField targetField, List<String> messageKey, Schema.SObjectType relatedObjectType) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createLookupMapping(Schema.SObjectField targetField, List<String> messageKey, Schema.SObjectType relatedObjectType, Schema.SObjectField relatedLookupField, Schema.SObjectField relatedResultField) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createLookupRecordTypeMapping(List<String> messageKey, Schema.SObjectType lookupObjectType, Schema.SObjectField lookupField, Schema.SObjectField resultField, Schema.SObjectType recordTypeObjectType) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createRecordTypeMapping(List<String> messageKey, Schema.SObjectType objectType) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createStaticMapping(Object data, Schema.SObjectField targetField) {
        return null;
    }
    global static fferpcore.SubscriptionDescription.Mapping createStaticRecordTypeMapping(String recordTypeName, Schema.SObjectType objectType) {
        return null;
    }
global abstract class ApplyMappingRequest {
    global ApplyMappingRequest() {

    }
    global abstract Map<String,Object> getMessage();
    global abstract SObject getRecord();
    global abstract fferpcore.SubscriptionDescription.Value getValue(List<String> param0);
    global abstract Boolean isFirstRequestForRecord();
    global virtual Boolean isLastRequestForRecord() {
        return null;
    }
    global abstract void respondError(fferpcore.ErpErrorBody param0);
}
global class FieldMapping extends fferpcore.SubscriptionDescription.Mapping {
    global FieldMapping(Schema.SObjectField targetField, List<String> messageKey) {

    }
    global FieldMapping(Schema.SObjectField targetField, String messageKey) {

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
    global override void performImmediateActions(fferpcore.SubscriptionDescription.ApplyMappingRequest request) {

    }
}
global class LinkingFieldMapping extends fferpcore.SubscriptionDescription.Mapping {
    global LinkingFieldMapping(Schema.SObjectType recordType, List<String> linkControlPath) {

    }
    global LinkingFieldMapping(Schema.SObjectType recordType, String linkControlKey) {

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
    global override void performImmediateActions(fferpcore.SubscriptionDescription.ApplyMappingRequest request) {

    }
}
global abstract class Mapping {
    global Mapping() {

    }
    global virtual void disableFields(Set<String> fieldNames) {

    }
    global virtual Set<String> getAdditionalSelections() {
        return null;
    }
    global abstract List<List<String>> getMessageKeys();
    global abstract Set<String> getTargetFields();
    global virtual Boolean isDisabled() {
        return null;
    }
    global virtual void performBulkActions() {

    }
    global abstract void performImmediateActions(fferpcore.SubscriptionDescription.ApplyMappingRequest param0);
}
global class Value {
    global Value(Object value) {

    }
    global Object getValue() {
        return null;
    }
}
}
