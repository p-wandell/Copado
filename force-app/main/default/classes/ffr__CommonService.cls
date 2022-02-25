/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CommonService {
    global static List<String> getObjectList() {
        return null;
    }
    global static Map<String,ffr.CommonService.ObjectMetadata> getObjectMetadata(Set<String> objects, Boolean throwException) {
        return null;
    }
    global static Map<String,ffr.CommonService.ObjectMetadata> getObjectMetadata(Set<String> objects, Boolean throwException, Boolean getAllFields) {
        return null;
    }
    global static Map<String,ffr.CommonService.ObjectMetadata> getObjectMetadata(Set<String> objects, Boolean throwException, Boolean getAllFields, Boolean getLookups) {
        return null;
    }
    global static List<ffr.CommonService.Picklist> getPicklistOptions(Schema.DescribeFieldResult picklistField) {
        return null;
    }
    global static List<ffr.CommonService.Identity> lookupChildrenByParentIds(String childObject, String parentFieldName, Set<Id> ids) {
        return null;
    }
    global static List<ffr.CommonService.Identity> lookup(String targetObject, String namePrefix) {
        return null;
    }
    global static List<ffr.CommonService.Identity> lookup(String targetObject, String searchText, Boolean contains, Integer rowLimit) {
        return null;
    }
    global static List<ffr.CommonService.Identity> selectIdentitiesByIds(String targetObject, Set<Id> ids) {
        return null;
    }
global class ClassFactory {
    global String Name {
        get;
    }
    global String Namespace {
        get;
    }
    global ClassFactory(String fullyQualifiedName) {

    }
    global System.Type getType() {
        return null;
    }
    global Object newInstance() {
        return null;
    }
}
global class Field {
    global Boolean displayLocationInDecimal {
        get;
        set;
    }
    global Boolean isAccessible {
        get;
        set;
    }
    global Boolean isEncrypted {
        get;
        set;
    }
    global Boolean isFilterable {
        get;
        set;
    }
    global Boolean isGroupable {
        get;
        set;
    }
    global Boolean isHtmlFormatted {
        get;
        set;
    }
    global Boolean isNameField {
        get;
        set;
    }
    global Boolean isRestrictedPicklist {
        get;
        set;
    }
    global Boolean isUpdatable {
        get;
        set;
    }
    global String label {
        get;
        set;
    }
    global Integer length {
        get;
        set;
    }
    global String lookupObject {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global List<ffr.CommonService.Picklist> picklist {
        get;
        set;
    }
    global Integer precision {
        get;
        set;
    }
    global String relationshipName {
        get;
        set;
    }
    global Integer scale {
        get;
        set;
    }
    global String soapType {
        get;
        set;
    }
    global String type {
        get;
        set;
    }
    global Field() {

    }
}
global class Identity {
    global Id Id {
        get;
        set;
    }
    global String Name {
        get;
    }
    global Identity(Id anId) {

    }
    global Identity(String aName) {

    }
    global Identity(Id anId, String aName) {

    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class ObjectMetadata {
    global Map<String,ffr.CommonService.Field> fieldMap {
        get;
        set;
    }
    global Map<String,ffr.CommonService.Field> lookupMap {
        get;
        set;
    }
    global String objectName {
        get;
        set;
    }
    global Map<String,ffr.CommonService.Relationship> relationshipMap {
        get;
        set;
    }
    global ObjectMetadata() {

    }
}
global class Picklist {
    global String Label {
        get;
        set;
    }
    global String Name {
        get;
        set;
    }
    global Picklist() {

    }
}
global class Relationship {
    global String objectLabel {
        get;
        set;
    }
    global String objectName {
        get;
        set;
    }
    global String relationshipName {
        get;
        set;
    }
    global Relationship() {

    }
}
global class SObjectNamespaceHelper {
    global String Name {
        get;
    }
    global String Namespace {
        get;
    }
    global SObjectNamespaceHelper(String fullyQualifiedName) {

    }
}
global class Size {
    global Integer Height {
        get;
        set;
    }
    global Integer Width {
        get;
        set;
    }
    global Size() {

    }
    global Size(Integer width, Integer height) {

    }
}
}
