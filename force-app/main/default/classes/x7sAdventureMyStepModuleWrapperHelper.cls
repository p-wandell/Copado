/*
 * Copyright (c) 2020. 7Summits Inc.
 */

public with sharing class x7sAdventureMyStepModuleWrapperHelper {

    public static x7sAdventureStepModuleWrapper createWrapper(X7S_Adventure_Module__c theStepModule, List<X7S_Adventure_Task__c> moduleTasks) {

        x7sAdventureStepModuleWrapper stepModule = new x7sAdventureStepModuleWrapper();
        Decimal NumberOfCompletedTasks = 0;
        Decimal totalTaskAssigned = 0;
        Decimal taskProgress = 0 ;
        Boolean ModuleCompleted = false;

        if (moduleTasks.size() > 0) {
            stepModule.noUserTasks = false;
            stepModule.userTasksComplete = false;
            stepModule.moduleTasks = moduleTasks;
            for (X7S_Adventure_Task__c myTask : moduleTasks) {
                totalTaskAssigned = totalTaskAssigned + 1;
                if (myTask.Completed__c == true) {
                    stepModule.userTasksComplete = true;
                    NumberOfCompletedTasks = NumberOfCompletedTasks + 1;
                }

                //Find the next task that will be due
                if (stepModule.nextModuleTaskDueDate != null && (myTask.Task_Due_Date__c < stepModule.nextModuleTaskDueDate)) {
                    stepModule.nextModuleTaskDueDate = myTask.Task_Due_Date__c;
                    stepModule.nextModuleTaskDueId = myTask.Id;
                } else if (stepModule.nextModuleTaskDueDate == null) {
                    stepModule.nextModuleTaskDueDate = myTask.Task_Due_Date__c;
                    stepModule.nextModuleTaskDueId = myTask.Id;
                }
            }

            taskProgress = (NumberOfCompletedTasks / totalTaskAssigned) * 100;

            if (moduleTasks.size() == NumberOfCompletedTasks) {
                ModuleCompleted = true;
            }

        } else {
            stepModule.moduleTasks = null;
            stepModule.noUserTasks = true;
            stepModule.userTasksComplete = false;
        }

        stepModule.id = theStepModule.Id;
        stepModule.Adventure_Step_Id = theStepModule.Adventure_Step__c;
        stepModule.title = theStepModule.Title__c;

        stepModule.order = (Integer) theStepModule.Order__c;
        stepModule.descriptionLabel = theStepModule.Description_Label__c;
        stepModule.descriptionLink = theStepModule.Description_URL__c;
        stepModule.tooltip = theStepModule.Tooltip_Description__c;
        stepModule.taskProgress = taskProgress.setScale(0);
        stepModule.completedFlag = ModuleCompleted;

        return stepModule;
    }
}