/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class TaskManagementService {
    global TaskManagementService() {

    }
    global static void externalTriggerFinish() {

    }
    global static void externalTriggerStart() {

    }
    global static Boolean isGanttSaveInProcess() {
        return null;
    }
global class GanttSaveContext {
    global Id projectID {
        get;
        set;
    }
    global GanttSaveContext() {

    }
}
global interface GanttSavePlugin {
    void afterSave(pse.TaskManagementService.GanttSaveContext param0);
    void beforeSave(pse.TaskManagementService.GanttSaveContext param0);
}
global class SampleGanttSavePlugin implements pse.TaskManagementService.GanttSavePlugin {
    global SampleGanttSavePlugin() {

    }
    global void afterSave(pse.TaskManagementService.GanttSaveContext gsc) {

    }
    global void beforeSave(pse.TaskManagementService.GanttSaveContext gsc) {

    }
}
}
