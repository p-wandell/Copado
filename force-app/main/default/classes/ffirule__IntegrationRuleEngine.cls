/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class IntegrationRuleEngine implements Database.Batchable<SObject>, Process.Plugin, System.Schedulable, ffirule.IIntegrationRuleEngine {
    global ffirule__IntegrationRuleButton__c Button;
    global ffirule__IntegrationRuleJob__c Job;
    global ffirule__IntegrationRule__c Rule;
    global List<Id> SourceRecordIds;
    global String SourceSOQL;
    global IntegrationRuleEngine() {

    }
    global IntegrationRuleEngine(ApexPages.StandardController standardController) {

    }
    global IntegrationRuleEngine(ApexPages.StandardSetController standardSetController) {

    }
    global IntegrationRuleEngine(ffirule__IntegrationRuleJob__c job) {

    }
    global IntegrationRuleEngine(ffirule__IntegrationRuleButton__c button, List<Id> sourceRecordIds) {

    }
    global System.PageReference convert() {
        return null;
    }
    global Process.PluginDescribeResult describe() {
        return null;
    }
    global void execute(System.SchedulableContext ctx) {

    }
    global void execute(Database.BatchableContext ctx, List<SObject> sourceRecords) {

    }
    global static String exportAsJSON(String integrationRuleName) {
        return null;
    }
    global void finish(Database.BatchableContext ctx) {

    }
    global ffirule.IntegrationRuleEngine getEngine() {
        return null;
    }
    global static Set<Id> getRunningApexJobs(Set<Id> apexJobIds) {
        return null;
    }
    global static void importFromJSON(String integrationRuleJSON) {

    }
    global Process.PluginResult invoke(Process.PluginRequest request) {
        return null;
    }
    global Database.QueryLocator start(Database.BatchableContext ctx) {
        return null;
    }
    global static void triggerHandler() {

    }
}
