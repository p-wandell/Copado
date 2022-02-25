/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class APIBillingService {
    global APIBillingService() {

    }
    global static pse.APICommonsService.BatchStatus clear(pse.APIBillingService.BillingContextClear bc) {
        return null;
    }
    global static pse.APIBillingService.BillingResults fetch(pse.APIBillingService.BillingContextFetch bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus generate(pse.APIBillingService.BillingContextGenerate bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus invoice(pse.APIBillingService.BillingContextInvoice bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus recalc(pse.APIBillingService.BillingContextRecalc bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus release(pse.APIBillingService.BillingContextRelease bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus remove(pse.APIBillingService.BillingContextRemove bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus schedule(pse.APIBillingService.BillingContextSchedule bc) {
        return null;
    }
    global static pse.APICommonsService.BatchStatus status(Id jobID) {
        return null;
    }
global class BEBContainer {
    global pse__Billing_Event_Batch__c billingEventBatch;
    global List<pse.APIBillingService.BEContainer> billingEvents;
}
global class BEContainer {
    global pse__Billing_Event__c billingEvent;
    global List<pse__Billing_Event_Item__c> billingEventItems;
}
global class BillingContextClear extends pse.APICommonsService.BatchContext {
    global Id id;
    global Set<Id> ids;
    global pse.APIBillingService.ObjectTypesClear objectType;
    global BillingContextClear() {

    }
}
global class BillingContextFetch extends pse.APICommonsService.BatchContext {
    global Id accountID;
    global Id groupID;
    global Boolean isApproved;
    global Boolean isInvoiced;
    global Boolean isReleased;
    global Id practiceID;
    global Id projectID;
    global Id regionID;
    global Id timePeriodID;
    global BillingContextFetch() {

    }
}
global class BillingContextGenerate extends pse.APICommonsService.BatchContext {
    global Id accountID;
    global Id billingCalculationID;
    global Date cutoff;
    global Id groupID;
    global Boolean includePriorPeriods {
        get;
        set;
    }
    global Id practiceID;
    global Id projectID;
    global Id regionID;
    global Id timePeriodID;
    global Boolean useFlexiblePeriods {
        get;
        set;
    }
    global BillingContextGenerate() {

    }
}
global class BillingContextInvoice extends pse.APICommonsService.BatchContext {
    global List<pse.BillingEventsManager.InvoiceInfo> invoiceInfo;
    global BillingContextInvoice() {

    }
}
global class BillingContextRecalc extends pse.APICommonsService.BatchContext {
    global Set<Id> billingEventIds;
    global BillingContextRecalc() {

    }
}
global class BillingContextRelease extends pse.APICommonsService.BatchContext {
    global Set<Id> ids;
    global pse.APIBillingService.ObjectTypesRelease objectType;
    global BillingContextRelease() {

    }
}
global class BillingContextRemove extends pse.APICommonsService.BatchContext {
    global Set<Id> ids;
    global pse.APIBillingService.ObjectTypesRemove objectType;
    global BillingContextRemove() {

    }
}
global class BillingContextSchedule extends pse.APICommonsService.BatchContext {
    global Id accountID;
    global String cronDaysParm;
    global String cronSchedule;
    global Id groupID;
    global Boolean includePriorPeriods {
        get;
        set;
    }
    global Integer periodOffset;
    global Id practiceID;
    global Id projectID;
    global Id regionID;
    global String scheduledJobName;
    global Id timePeriodID;
    global Boolean useFlexiblePeriods {
        get;
        set;
    }
    global BillingContextSchedule() {

    }
}
global class BillingResults {
    global List<pse.APIBillingService.BEBContainer> billingEventBatches;
}
global class DefaultBillingGenerateHandler implements pse.APICommonsService.iBatchCallback {
    global DefaultBillingGenerateHandler() {

    }
    global void afterExecute(pse.APICommonsService.BatchContext bc, Set<Id> scope) {

    }
    global void afterFinish(pse.APICommonsService.BatchContext bc) {

    }
    global void afterStart(pse.APICommonsService.BatchContext bc) {

    }
    global void beforeExecute(pse.APICommonsService.BatchContext bc, Set<Id> scope) {

    }
    global void beforeFinish(pse.APICommonsService.BatchContext bc) {

    }
    global void beforeStart(pse.APICommonsService.BatchContext bc) {

    }
    global pse.APICommonsService.BatchJobType getJobType() {
        return null;
    }
}
global class DefaultBillingReleaseHandler implements pse.APICommonsService.iBatchCallback {
    global DefaultBillingReleaseHandler() {

    }
    global void afterExecute(pse.APICommonsService.BatchContext bc, Set<Id> scope) {

    }
    global void afterFinish(pse.APICommonsService.BatchContext bc) {

    }
    global void afterStart(pse.APICommonsService.BatchContext bc) {

    }
    global void beforeExecute(pse.APICommonsService.BatchContext bc, Set<Id> scope) {

    }
    global void beforeFinish(pse.APICommonsService.BatchContext bc) {

    }
    global void beforeStart(pse.APICommonsService.BatchContext bc) {

    }
    global pse.APICommonsService.BatchJobType getJobType() {
        return null;
    }
}
global enum ObjectTypesClear {billing_event_batch, budget, event, expense, expense_report, item, milestone, misc_adj, timecard, timecard_split}
global enum ObjectTypesRelease {Batch, Event}
global enum ObjectTypesRemove {Batch, Event, Item}
}
