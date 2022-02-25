/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class DataViewService {
    global DataViewService() {

    }
    global static ffr.DataViewService.DataView createNewDataView() {
        return null;
    }
    global static void deleteDataView(Set<Id> dataViewIds) {

    }
    global static List<String> getActionClasses() {
        return null;
    }
    global static ffr.IActionViewsAction getActionInstance(String apexClassName) {
        return null;
    }
    global static Map<String,Set<Id>> getActionRequirements(ffr.DataViewService.DataView dataView) {
        return null;
    }
    global static List<ffr.CommonService.Identity> getAllFields(Set<Id> dataviewIds) {
        return null;
    }
    global static Set<String> getCommonNamePicklistValuesSet() {
        return null;
    }
    global static List<ffr.CommonService.Picklist> getCommonNamePicklistValues() {
        return null;
    }
    global static Map<String,ffr.CommonService.ObjectMetadata> getDataViewMetadata(Set<Id> dataViewIds) {
        return null;
    }
    global static Map<String,ffr.CommonService.ObjectMetadata> getDataViewMetadata(Set<Id> dataViewIds, Boolean throwException) {
        return null;
    }
    global static List<ffr.DataViewService.DataView> getDataView(Set<Id> dataViewIds) {
        return null;
    }
    global static List<ffr.DataViewService.DataView> getDataView(Set<Id> dataViewIds, Boolean isDataviewMaster) {
        return null;
    }
    global static List<Id> save(List<ffr.DataViewService.DataView> dataViews) {
        return null;
    }
global class Action {
    global String ApexClass {
        get;
        set;
    }
    global String Description {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global Boolean IsSingleSelect {
        get;
    }
    global String Name {
        get;
        set;
    }
    global String Parameter {
        get;
        set;
    }
    global List<ffr.DataViewService.ParameterMetadataType> ParameterMetadataList {
        get;
    }
    global Action() {

    }
    global Action(ffr__DataViewAction__c sObj, Boolean singleSelect, List<ffr.DataViewService.ParameterMetadataType> metadataList) {

    }
    global ffr__DataViewAction__c createSObject() {
        return null;
    }
}
global class CommonNamePicklistField {
    global String FieldName {
        get;
        set;
    }
    global String ObjectName {
        get;
        set;
    }
    global CommonNamePicklistField() {

    }
    global CommonNamePicklistField(String objectName, String fieldName) {

    }
}
global class DataView {
    global List<ffr.DataViewService.Action> Actions {
        get;
        set;
    }
    global List<ffr.DataViewService.Field> Fields {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global Boolean isSummarizedData {
        get;
        set;
    }
    global List<ffr.DataViewService.DataViewJoin> Joins {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String StartingObject {
        get;
        set;
    }
    global DataView() {

    }
    global DataView(ffr__DataView__c sObj) {

    }
    global ffr__DataView__c createSObject() {
        return null;
    }
    global ffr.DataViewService.Action getActionById(Id actionId) {
        return null;
    }
}
global class DataViewJoin {
    global Decimal Depth {
        get;
        set;
    }
    global Boolean Expanded {
        get;
        set;
    }
    global List<ffr.DataViewService.DataViewJoinFilter> Filters {
        get;
        set;
    }
    global Boolean HasInvalidRelationship {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global Decimal Index {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String ParentName {
        get;
        set;
    }
    global String RelatedObject {
        get;
    }
    global String RelationshipName {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global DataViewJoin() {

    }
    global DataViewJoin(ffr__DataViewJoin__c sObj, Schema.DescribeSObjectResult relatedObj) {

    }
    global ffr__DataViewJoin__c createSObject() {
        return null;
    }
}
global class DataViewJoinFilter {
    global Decimal ClosingBrackets {
        get;
        set;
    }
    global String CombineType {
        get;
        set;
    }
    global String Field {
        get;
        set;
    }
    global String FromValue {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
    }
    global Decimal OpeningBrackets {
        get;
        set;
    }
    global String Operator {
        get;
        set;
    }
    global Boolean Prompt {
        get;
        set;
    }
    global String ToValue {
        get;
        set;
    }
    global DataViewJoinFilter() {

    }
    global DataViewJoinFilter(ffr__DataViewJoinFilter__c sObj) {

    }
    global ffr__DataViewJoinFilter__c createSObject() {
        return null;
    }
}
global class Field {
    global Boolean Aggregatable {
        get;
        set;
    }
    global String AggregationMode {
        get;
        set;
    }
    global String CommonName {
        get;
        set;
    }
    global Boolean ConvertCurrency {
        get;
        set;
    }
    global Id Id {
        get;
        set;
    }
    global List<String> InquiryTemplatesWhereIsInUse {
        get;
        set;
    }
    global Integer KeyPriority {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global String ObjectField {
        get;
        set;
    }
    global Boolean Presentable {
        get;
        set;
    }
    global Boolean Reversible {
        get;
        set;
    }
    global Boolean Selectable {
        get;
        set;
    }
    global String Source {
        get;
        set;
    }
    global Id sourceID;
    global Set<String> SummarizationTemplatesWhereIsInUse {
        get;
        set;
    }
    global List<ffr.DataViewService.TransposeItem> TransposeItems {
        get;
        set;
    }
    global Field() {

    }
    global Field(ffr__DataViewField__c sObj) {

    }
    global ffr__DataViewField__c createSObject() {
        return null;
    }
}
global class ParameterMetadataType {
    global String Key {
        get;
        set;
    }
    global String Label {
        get;
        set;
    }
    global Boolean ReadOnly {
        get;
        set;
    }
    global List<ffr.DataViewService.SelectionOption> SelectionOptions {
        get;
        set;
    }
    global String Type {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global ParameterMetadataType() {

    }
    global ParameterMetadataType(String key, String label, String type) {

    }
    global ParameterMetadataType(String key, String label, String type, String value, Boolean readOnly, List<ffr.DataViewService.SelectionOption> selectionOptions) {

    }
}
global class SelectionOption {
    global String Key {
        get;
        set;
    }
    global String Label {
        get;
        set;
    }
    global SelectionOption() {

    }
    global SelectionOption(String key, String label) {

    }
}
global class TransposeItem {
    global Id Id {
        get;
        set;
    }
    global String ObjectField {
        get;
        set;
    }
    global String Source {
        get;
        set;
    }
    global String Value {
        get;
        set;
    }
    global TransposeItem() {

    }
    global TransposeItem(ffr__DataViewTransposeItem__c sObj) {

    }
    global ffr__DataViewTransposeItem__c createSObject() {
        return null;
    }
}
}
