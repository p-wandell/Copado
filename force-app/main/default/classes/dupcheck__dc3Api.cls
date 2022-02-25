/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class dc3Api {
    global dc3Api() {

    }
    global static void disableTriggers() {

    }
    global void doDirectProcess(Id recordId) {

    }
    global void doDirectProcess(Id recordId, String filterDeveloperName) {

    }
    global ApexPages.Message doDuplicatePrevention(SObject objectData) {
        return null;
    }
    global static Boolean doIndex(String objectPrefix) {
        return null;
    }
    global static Boolean doIndex(Set<Id> recordSet) {
        return null;
    }
    global Boolean doMerge(List<Id> objectList) {
        return null;
    }
    global Boolean doMerge(List<SObject> objectList) {
        return null;
    }
    global Boolean doMerge(List<SObject> objectList, SObject masterObject) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearchWithFilter(Id objectId, String filterDeveloperName) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearchWithFilter(Map<String,Object> objectData, String objectPrefix, String filterDeveloperName) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearchWithFilter(Map<String,Object> objectData, String objectPrefix, String filterDeveloperName, Set<String> scenarioIds) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearchWithFilter(SObject objectData, String filterDeveloperName) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearch(Id objectId) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearch(Map<String,Object> objectData, String objectPrefix) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearch(Map<String,Object> objectData, String objectPrefix, String filter) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearch(Map<String,Object> objectData, String objectPrefix, String filter, Set<String> scenarioIds) {
        return null;
    }
    global Map<String,List<dupcheck.dc3SearchResult>> doSearch(SObject objectData) {
        return null;
    }
    global static void enableTriggers() {

    }
    global static String exportConfiguration() {
        return null;
    }
    global dupcheck.dc3SearchResult.IndexSearchData getIndexResultData(String prefix) {
        return null;
    }
    global static Map<Id,String> getLinkedSandboxes() {
        return null;
    }
    global SObject getMergeMaster(List<SObject> objectList) {
        return null;
    }
    global List<dupcheck.dc3Config.ResultField> getResultFieldList(String prefix) {
        return null;
    }
    global static void importConfiguration(String jsonString) {

    }
    global static Boolean linkSandboxLicense(String sandboxName, String organizationId) {
        return null;
    }
    global static Integer matchRecord(SObject recordA, SObject recordB) {
        return null;
    }
    global static Integer matchRecord(SObject recordA, SObject recordB, Set<Id> scenarioIds) {
        return null;
    }
    global static void processDeltaByIds(String jobName, List<Id> recordList) {

    }
    global static void processRecordAsDeltaByIds(String jobName, List<Id> recordList, String deltaType) {

    }
    global static Boolean refreshLicense() {
        return null;
    }
    global void startIndexQueue() {

    }
    global static Boolean unlinkSandboxLicense(String organizationId) {
        return null;
    }
}
