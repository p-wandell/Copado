/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class OutputAPI {
    global OutputAPI() {

    }
    global String generateTemplateOutput(Id objectID, String templateClass) {
        return null;
    }
    global static ob1.OutputAPI.ScheduleResult schedule(String jobName, String cronExpression, Id templateID) {
        return null;
    }
    global static ob1.OutputAPI.ScheduleResult schedule(String jobName, ob1.OutputAPI.ScheduleParams params, Id templateID) {
        return null;
    }
global abstract class BatchContext {
    global Database.BatchableContext context;
    global BatchContext() {

    }
}
global class OutputGenerateContext extends ob1.OutputAPI.BatchContext {
    global Id historyID;
    global Id objectID;
    global String operatingMode;
    global Id templateID;
    global OutputGenerateContext() {

    }
}
global class ScheduleParams {
    global ScheduleParams() {

    }
    global ob1.OutputAPI.ScheduleParams amPm(String s) {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams april() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams august() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams dayOfMonth(Integer i) {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams december() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams everyDay() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams february() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams friday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams hour(Integer hour) {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams indexedDayAndWeek(Integer day, Integer week) {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams january() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams july() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams june() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastDayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastFridayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastMondayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastSaturdayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastSundayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastThursdayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastTuesdayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams lastWednesdayOfMonth() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams march() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams may() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams minute(Integer minute) {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams monday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams november() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams october() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams saturday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams september() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams sunday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams thursday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams tuesday() {
        return null;
    }
    global ob1.OutputAPI.ScheduleParams wednesday() {
        return null;
    }
}
global class ScheduleResult {
    global String errorMessage {
        get;
    }
    global Boolean isError {
        get;
    }
    global String successMessage {
        get;
    }
}
global interface iBatchCallback {
    void afterExecute(ob1.OutputAPI.BatchContext param0);
    void afterFinish(ob1.OutputAPI.BatchContext param0);
    void afterStart(ob1.OutputAPI.BatchContext param0);
    void beforeExecute(ob1.OutputAPI.BatchContext param0);
    void beforeFinish(ob1.OutputAPI.BatchContext param0);
    void beforeStart(ob1.OutputAPI.BatchContext param0);
}
}
