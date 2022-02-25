/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class APICommonsService {
    global APICommonsService() {

    }
global abstract class BatchContext {
    global Database.BatchableContext context;
    global pse.APICommonsService.BatchJobType jobType;
    global BatchContext() {

    }
}
global enum BatchJobType {Clear, Generate, Invoice, Recalc, Release, Remove}
global class BatchStatus {
    global String errorMessage {
        get;
    }
    global Id jobID {
        get;
    }
    global String status {
        get;
    }
    global BatchStatus(String status, String errorMessage, Id jobID) {

    }
}
global interface iBatchCallback {
    void afterExecute(pse.APICommonsService.BatchContext param0, Set<Id> param1);
    void afterFinish(pse.APICommonsService.BatchContext param0);
    void afterStart(pse.APICommonsService.BatchContext param0);
    void beforeExecute(pse.APICommonsService.BatchContext param0, Set<Id> param1);
    void beforeFinish(pse.APICommonsService.BatchContext param0);
    void beforeStart(pse.APICommonsService.BatchContext param0);
    pse.APICommonsService.BatchJobType getJobType();
}
}
