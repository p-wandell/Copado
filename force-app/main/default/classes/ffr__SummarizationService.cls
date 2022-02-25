/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SummarizationService {
    global static List<ffr.SummarizationService.Destination> getAvailableSummarizationObjects(String objectNameFragment) {
        return null;
    }
    global static List<ffr.SummarizationService.SummarizationTemplate> getTemplates(Set<Id> templateIds) {
        return null;
    }
    global static void purgeTemplateData(Set<Id> templatesToPurge) {

    }
    global static void runSummarization(Set<Id> summarizationTemplateIds) {

    }
    global static List<Id> saveAndRunSummarizationTemplates(Set<ffr.SummarizationService.SummarizationTemplate> templates) {
        return null;
    }
    global static List<Id> saveTemplates(Set<ffr.SummarizationService.SummarizationTemplate> templates) {
        return null;
    }
    global static void scheduleSummarization(Set<Id> summarizationTemplateIds, ffr.CronSpec cron) {

    }
    global static void unscheduleSummarization(Set<Id> summarizationTemplateIds) {

    }
global class Destination {
    global String objectLabel {
        get;
    }
    global String objectName {
        get;
    }
}
global class DestinationField {
    global String DestinationFieldLabel {
        get;
        set;
    }
    global String DestinationFieldName {
        get;
        set;
    }
    global Schema.DisplayType Type {
        get;
        set;
    }
    global DestinationField() {

    }
    global DestinationField(String name, String label) {

    }
    global DestinationField(String name, String label, Schema.DisplayType fieldType) {

    }
}
global class Filter implements ffr.SummarizationService.ISummarizationServiceObject {
    global List<ffr.SummarizationService.FilterElement> filterElements {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global String name {
        get;
    }
    global Filter() {

    }
    global Filter(ffr__Filter__c filterSobject) {

    }
    global ffr__Filter__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class FilterElement implements System.Comparable, ffr.SummarizationService.ISummarizationServiceObject {
    global Decimal closingBrackets {
        get;
        set;
    }
    global String combineType {
        get;
        set;
    }
    global String field {
        get;
        set;
    }
    global String fromValue {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global Decimal index {
        get;
        set;
    }
    global String name {
        get;
    }
    global Decimal openingBrackets {
        get;
        set;
    }
    global String operator {
        get;
        set;
    }
    global String toValue {
        get;
        set;
    }
    global FilterElement() {

    }
    global FilterElement(ffr__FilterElement__c filterElementSobject) {

    }
    global Integer compareTo(Object compareTo) {
        return null;
    }
    global ffr__FilterElement__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global interface ISummarizationServiceObject {
    SObject createSObject();
}
global class ObjectToObjectMap implements ffr.SummarizationService.ISummarizationServiceObject {
    global Id id {
        get;
        set;
    }
    global String name {
        get;
    }
    global List<ffr.SummarizationService.ObjectToObjectMapFieldLink> objectToObjectMapFieldLinks {
        get;
        set;
    }
    global ObjectToObjectMap() {

    }
    global ObjectToObjectMap(ffr__ObjectToObjectMap__c objectToObjectMapSobject) {

    }
    global ffr__ObjectToObjectMap__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class ObjectToObjectMapFieldLink implements ffr.SummarizationService.ISummarizationServiceObject {
    global Decimal displayOrder {
        get;
        set;
    }
    global ffr.SummarizationService.Filter filter {
        get;
        set;
    }
    global String fromField {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global String name {
        get;
    }
    global String toField {
        get;
        set;
    }
    global ObjectToObjectMapFieldLink() {

    }
    global ObjectToObjectMapFieldLink(ffr__ObjectToObjectMapFieldLink__c objectToObjectMapFieldLinkSobject) {

    }
    global ffr__ObjectToObjectMapFieldLink__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class SummarizationRunInformation implements ffr.SummarizationService.ISummarizationServiceObject {
    global Datetime endTime {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global Decimal lastAttemptedInstance {
        get;
        set;
    }
    global Decimal lastSuccessfulInstance {
        get;
        set;
    }
    global Datetime startTime {
        get;
        set;
    }
    global SummarizationRunInformation() {

    }
    global SummarizationRunInformation(ffr__SummarizationRunInformation__c summarizationRunInfo) {

    }
    global ffr__SummarizationRunInformation__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class SummarizationTemplate implements ffr.SummarizationService.ISummarizationServiceObject {
    global String basePeriod {
        get;
        set;
    }
    global ffr.CommonService.Identity Dataview {
        get;
        set;
    }
    global String destination {
        get;
        set;
    }
    global List<ffr.SummarizationService.SummarizationTemplateFieldProcess> fieldProcesses {
        get;
        set;
    }
    global ffr.SummarizationService.Filter filter {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global ffr.SummarizationService.ObjectToObjectMap objectToObjectMap {
        get;
        set;
    }
    global Boolean useCurrentPeriod {
        get;
        set;
    }
    global SummarizationTemplate() {

    }
    global SummarizationTemplate(ffr__SummarizationTemplate__c summarizationTemplate) {

    }
    global ffr__SummarizationTemplate__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
global class SummarizationTemplateFieldProcess implements ffr.SummarizationService.ISummarizationServiceObject {
    global String fieldName {
        get;
        set;
    }
    global Id id {
        get;
        set;
    }
    global String name {
        get;
    }
    global String process {
        get;
        set;
    }
    global SummarizationTemplateFieldProcess() {

    }
    global SummarizationTemplateFieldProcess(ffr__SummarizationTemplateFieldProcess__c summarizationTemplateFieldProcessSObject) {

    }
    global ffr__SummarizationTemplateFieldProcess__c createSObject() {
        return null;
    }
    global Boolean equals(Object obj) {
        return null;
    }
    global Integer hashCode() {
        return null;
    }
}
}
